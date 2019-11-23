Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3453D10803D
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 21:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbfKWUGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 15:06:32 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:44890 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfKWUGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 15:06:32 -0500
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id xANK6I3f025617;
        Sat, 23 Nov 2019 12:06:19 -0800
Date:   Sun, 24 Nov 2019 01:27:57 +0530
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.apana.org.au,
        nirranjan@chelsio.com, atul.gupta@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: Re: [PATCH net-next v2 2/3] cxgb4: add UDP segmentation offload
 support
Message-ID: <20191123195755.GA30684@chelsio.com>
References: <cover.1574383652.git.rahul.lakkireddy@chelsio.com>
 <1638e6bdd3aa9a4536aaeb644418d2a0ff5e5368.1574383652.git.rahul.lakkireddy@chelsio.com>
 <20191122161334.44de6174@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191122161334.44de6174@cakuba.netronome.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday, November 11/22/19, 2019 at 16:13:34 -0800, Jakub Kicinski wrote:
> On Fri, 22 Nov 2019 06:30:02 +0530, Rahul Lakkireddy wrote:
> > Implement and export UDP segmentation offload (USO) support for both
> > NIC and MQPRIO QoS offload Tx path. Update appropriate logic in Tx to
> > parse GSO info in skb and configure FW_ETH_TX_EO_WR request needed to
> > perform USO.
> > 
> > v2:
> > - Remove inline keyword from write_eo_udp_wr() in sge.c. Let the
> >   compiler decide.
> > 
> > Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
> 
> > diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
> > index 76538f4cd595..f57457453561 100644
> > --- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
> > +++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
> > @@ -91,6 +91,7 @@ static const char stats_strings[][ETH_GSTRING_LEN] = {
> >  	"rx_bg3_frames_trunc    ",
> >  
> >  	"tso                    ",
> > +	"uso                    ",
> 
> Oh wow, the spaces, people's inventiveness when it comes to ethtool free
> form strings knows no bounds..
> 
> That's not a review comment, I just wanted to say that :)
> 
> >  	"tx_csum_offload        ",
> >  	"rx_csum_good           ",
> >  	"vlan_extractions       ",
> 
> > diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
> > index e8a1826a1e90..12ff69b3ba91 100644
> > --- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
> > +++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
> > @@ -1136,11 +1136,17 @@ static u16 cxgb_select_queue(struct net_device *dev, struct sk_buff *skb,
> >  
> >  	if (dev->num_tc) {
> >  		struct port_info *pi = netdev2pinfo(dev);
> > +		u8 ver, proto;
> > +
> > +		ver = ip_hdr(skb)->version;
> > +		proto = (ver == 6) ? ipv6_hdr(skb)->nexthdr :
> > +				     ip_hdr(skb)->protocol;
> 
> Checking ip version now looks potentially like a fix?
> 

Yes, the earlier check was not considering IPv6 header when extracting
the protocol field for comparison, used to decide whether the traffic
can be sent on the TC-MQPRIO QoS offload Tx path added very recently
just a couple of weeks ago.

> >  		/* Send unsupported traffic pattern to normal NIC queues. */
> >  		txq = netdev_pick_tx(dev, skb, sb_dev);
> >  		if (xfrm_offload(skb) || is_ptp_enabled(skb, dev) ||
> > -		    ip_hdr(skb)->protocol != IPPROTO_TCP)
> > +		    skb->encapsulation ||
> 
> The addition of encapsulation check also looks unrelated? 
> 

UDP traffic was not supported on the TC-MQPRIO QoS offload Tx path
before this patch. VxLAN and Geneve UDP tunnel packets need to be
handled differently and hence the above check to send these packets
through the normal Tx path for now. The support for them on QoS
offload path will be enabled by a future patchset.

> > +		    (proto != IPPROTO_TCP && proto != IPPROTO_UDP))
> >  			txq = txq % pi->nqsets;
> >  
> >  		return txq;


Thanks,
Rahul
