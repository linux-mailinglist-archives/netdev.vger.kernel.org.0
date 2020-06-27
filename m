Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17C0420BD8F
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 03:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgF0B1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 21:27:01 -0400
Received: from smtprelay0248.hostedemail.com ([216.40.44.248]:60636 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726101AbgF0B1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 21:27:00 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id D6152180A7FE6;
        Sat, 27 Jun 2020 01:26:59 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 10,1,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2716:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3872:3873:4250:4321:5007:6119:6742:7903:10004:10400:10848:10967:11026:11232:11473:11658:11914:12043:12296:12297:12438:12679:12740:12760:12895:13069:13311:13357:13439:14659:14721:21080:21627:21990:30054:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: soup87_3502c0226e5a
X-Filterd-Recvd-Size: 2709
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf08.hostedemail.com (Postfix) with ESMTPA;
        Sat, 27 Jun 2020 01:26:57 +0000 (UTC)
Message-ID: <552ee6083623bb7fe5e11f33cff654deed8e0982.camel@perches.com>
Subject: Re: [net-next v3 11/15] iecm: Add splitq TX/RX
From:   Joe Perches <joe@perches.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, Alice Michael <alice.michael@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Alan Brady <alan.brady@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Joshua Hay <joshua.a.hay@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        Donald Skidmore <donald.c.skidmore@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>
Date:   Fri, 26 Jun 2020 18:26:56 -0700
In-Reply-To: <20200626125806.0b1831a1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200626020737.775377-1-jeffrey.t.kirsher@intel.com>
         <20200626020737.775377-12-jeffrey.t.kirsher@intel.com>
         <20200626125806.0b1831a1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-06-26 at 12:58 -0700, Jakub Kicinski wrote:
> On Thu, 25 Jun 2020 19:07:33 -0700 Jeff Kirsher wrote:
> > @@ -1315,7 +1489,18 @@ iecm_tx_splitq_clean(struct iecm_queue *tx_q, u16 end, int napi_budget,
> >   */
> >  static inline void iecm_tx_hw_tstamp(struct sk_buff *skb, u8 *desc_ts)
> 
> Pretty sure you don't need the inline here. It's static function with
> one caller.
> 
> >  {
> > -	/* stub */
> > +	struct skb_shared_hwtstamps hwtstamps;
> > +	u64 tstamp;
> > +
> > +	/* Only report timestamp to stack if requested */
> > +	if (!likely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))
> > +		return;

Is this supposed to be unlikely?

> > +	tstamp = (desc_ts[0] | (desc_ts[1] << 8) | (desc_ts[2] & 0x3F) << 16);

btw: there are inconsistent parentheses for the ORs vs shifts here.

I think this might read better as

	tstamp = desc_ts[0] | (desc_ts[1] << 8) | ((desc_ts[2] & 0x3F) << 16);

This is a u64 result, but the ORs are int

23 bits of timestamp isn't very many at 100Gb.

> > +	hwtstamps.hwtstamp =
> > +		ns_to_ktime(tstamp << IECM_TW_TIME_STAMP_GRAN_512_DIV_S);
> > +
> > +	skb_tstamp_tx(skb, &hwtstamps);
> >  }
> 
> Why is there time stamp reading support if you have no ts_info
> configuration on ethtool side at all and no PHC support?

