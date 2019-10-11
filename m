Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9DCED4702
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 19:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728608AbfJKR45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 13:56:57 -0400
Received: from mga04.intel.com ([192.55.52.120]:38524 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728374AbfJKR45 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Oct 2019 13:56:57 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Oct 2019 10:56:56 -0700
X-IronPort-AV: E=Sophos;i="5.67,284,1566889200"; 
   d="scan'208";a="188387875"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Oct 2019 10:56:56 -0700
Message-ID: <bb71ee9658e7fcacde2c1bcdc258524e75474b7b.camel@linux.intel.com>
Subject: Re: [PATCH v3 3/3] i40e: Add UDP segmentation offload support
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        Josh Hunt <johunt@akamai.com>, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, jeffrey.t.kirsher@intel.com
Cc:     willemb@google.com, aaron.f.brown@intel.com
Date:   Fri, 11 Oct 2019 10:56:56 -0700
In-Reply-To: <db84a310-950a-f7e9-0d92-f7c81e27eb61@intel.com>
References: <1570812820-20052-1-git-send-email-johunt@akamai.com>
         <1570812820-20052-4-git-send-email-johunt@akamai.com>
         <db84a310-950a-f7e9-0d92-f7c81e27eb61@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-10-11 at 10:39 -0700, Samudrala, Sridhar wrote:
> 
> On 10/11/2019 9:53 AM, Josh Hunt wrote:
> > Based on a series from Alexander Duyck this change adds UDP segmentation
> > offload support to the i40e driver.
> > 
> > CC: Alexander Duyck <alexander.h.duyck@intel.com>
> > CC: Willem de Bruijn <willemb@google.com>
> > Signed-off-by: Josh Hunt <johunt@akamai.com>
> > ---
> >   drivers/net/ethernet/intel/i40e/i40e_main.c |  1 +
> >   drivers/net/ethernet/intel/i40e/i40e_txrx.c | 12 +++++++++---
> >   2 files changed, 10 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
> > index 6031223eafab..56f8c52cbba1 100644
> > --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
> > +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
> > @@ -12911,6 +12911,7 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
> >   			  NETIF_F_GSO_IPXIP6		|
> >   			  NETIF_F_GSO_UDP_TUNNEL	|
> >   			  NETIF_F_GSO_UDP_TUNNEL_CSUM	|
> > +			  NETIF_F_GSO_UDP_L4		|
> >   			  NETIF_F_SCTP_CRC		|
> >   			  NETIF_F_RXHASH		|
> >   			  NETIF_F_RXCSUM		|
> > diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > index e3f29dc8b290..b8496037ef7f 100644
> > --- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > +++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > @@ -2960,10 +2960,16 @@ static int i40e_tso(struct i40e_tx_buffer *first, u8 *hdr_len,
> >   
> >   	/* remove payload length from inner checksum */
> >   	paylen = skb->len - l4_offset;
> > -	csum_replace_by_diff(&l4.tcp->check, (__force __wsum)htonl(paylen));
> >   
> > -	/* compute length of segmentation header */
> > -	*hdr_len = (l4.tcp->doff * 4) + l4_offset;
> > +	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4) {
> > +		csum_replace_by_diff(&l4.udp->check, (__force __wsum)htonl(paylen));
> > +		/* compute length of segmentation header */
> > +		*hdr_len = sizeof(*l4.udp) + l4_offset;
> > +	} else {
> > +		csum_replace_by_diff(&l4.tcp->check, (__force __wsum)htonl(paylen));
> > +		/* compute length of segmentation header */
> > +		*hdr_len = (l4.tcp->doff * 4) + l4_offset;
> > +	}
> 
> Is it guaranteed that gso_type can be either UDP or TCP only if we reach 
> here? Don't we need to handle the case where it is neither and return 
> from this function?

We should only reach here if a supported gso_type value is in the packet,
otherwise we should end up with software segmentation taking care of it
and clearing the gso_size value if I recall correctly.

Otherwise the code should have been checking for non-TCP types ages ago,
and we would have experienced all sorts of bugs.

- Alex

