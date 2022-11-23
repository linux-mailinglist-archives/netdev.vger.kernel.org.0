Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2B9163692E
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 19:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239217AbiKWSpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 13:45:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238260AbiKWSpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 13:45:10 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA07978D52;
        Wed, 23 Nov 2022 10:45:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669229109; x=1700765109;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KS49cPpGkhy7gLY+lTDuqpn3zAsc+OOvSKK5SN036ww=;
  b=NudbCSU3/oHTHv/t6FFBuykXlAk9/nsJbrLonWN6eVBMdnoYnE0dF5/T
   a/xnJiJc+N+mVhrFo7uCQUNgbDMK/oZounhBX4J+6XAciYim92ZIwc/Wg
   0p+vIChI7KhdwTy7IAigGnFKj0rMWyMohKhFsjMBq9eyCG4Jaay/gOTJD
   BCLcGzS95j91h65X+ntf11Yh6rZpfXB3hnv4cZJryGIX+v/HCNTkgV9E4
   OatXTkhhB0CbCV8646QDEB3ZKiug3FwPISrys2uZbyTRW7jCZJ3gDt7sd
   squT21Tc+I+kbghTkdXFZjPeGE1l3SHUiOB5DZLMoYcQ9XreEELF+D0tJ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="297496164"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="297496164"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 10:45:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="970966434"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="970966434"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga005.fm.intel.com with ESMTP; 23 Nov 2022 10:45:06 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2ANIj5Dq005397;
        Wed, 23 Nov 2022 18:45:05 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Coco Li <lixiaoyan@google.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David Ahern" <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] IPv6/GRO: generic helper to remove temporary HBH/jumbo header in driver
Date:   Wed, 23 Nov 2022 19:44:52 +0100
Message-Id: <20221123184452.489864-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123163825.485611-1-alexandr.lobakin@intel.com>
References: <20221122232740.3180560-1-lixiaoyan@google.com> <20221123163825.485611-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alexandr.lobakin@intel.com>
Date: Wed, 23 Nov 2022 17:38:25 +0100

> From: Coco Li <lixiaoyan@google.com>
> Date: Tue, 22 Nov 2022 15:27:39 -0800
> 
> > IPv6/TCP and GRO stacks can build big TCP packets with an added
> > temporary Hop By Hop header.
> > 
> > Is GSO is not involved, then the temporary header needs to be removed in
> > the driver. This patch provides a generic helper for drivers that need
> > to modify their headers in place.
> > 
> > Signed-off-by: Coco Li <lixiaoyan@google.com>
> > ---
> >  include/net/ipv6.h | 33 +++++++++++++++++++++++++++++++++
> >  1 file changed, 33 insertions(+)
> > 
> > diff --git a/include/net/ipv6.h b/include/net/ipv6.h
> > index d383c895592a..a11d58c85c05 100644
> > --- a/include/net/ipv6.h
> > +++ b/include/net/ipv6.h
> > @@ -500,6 +500,39 @@ static inline int ipv6_has_hopopt_jumbo(const struct sk_buff *skb)
> >  	return jhdr->nexthdr;
> >  }
> >  
> > +/* Return 0 if HBH header is successfully removed
> > + * Or if HBH removal is unnecessary (packet is not big TCP)
> > + * Return error to indicate dropping the packet
> > + */
> > +static inline int ipv6_hopopt_jumbo_remove(struct sk_buff *skb)
> > +{
> > +	const int hophdr_len = sizeof(struct hop_jumbo_hdr);
> > +	int nexthdr = ipv6_has_hopopt_jumbo(skb);
> > +	struct ipv6hdr *h6;
> > +
> > +	if (!nexthdr)
> > +		return 0;
> > +
> > +	if (skb_cow_head(skb, 0))
> > +		return -1;
> 
> 	err = skb_cow_head(skb, 0);
> 	if (err)
> 		return err;
> 
> Alternatively, if you want to keep it simple, make the function bool
> and return false on `if (skb_cow_head(skb, 0)` and true otherwise.
> 
> > +
> > +	/* Remove the HBH header.
> > +	 * Layout: [Ethernet header][IPv6 header][HBH][L4 Header]
> > +	 */
> > +	memmove(skb->data + hophdr_len,
> > +		skb->data,
> 
> This can fit into the previous line.
> 
> > +		ETH_HLEN + sizeof(struct ipv6hdr));
> 
> Not correct at this point. I assume you took the implementation from
> ip6_offload.c[0], but ::gso_segment() and ::ndo_start_xmit() are two

Traditionally forgot to paste the links to the end of the mail. Pls
look at the end of this one for them (if I don't forget to paste
them again :clownface:).

> different entry points. Here you may have not only Eth header, but
> also VLAN, MPLS and whatnot.
> Correct way would be:
> 
> 	memmove(skb_mac_header(skb) + hophdr_len, skb_mac_header(skb),
> 		ipv6_hdr(skb) - skb_mac_header(skb) +
> 		sizeof(struct ipv6hdr));
> 
> > +
> > +	skb->data += hophdr_len;
> > +	skb->len -= hophdr_len;
> > +	skb->network_header += hophdr_len;
> 
> skb->mac_header also needs to be adjusted, the fact that it's equal
> to skb->data at the entry of ::ndo_start_xmit() doesn't mean
> anything.

Also, while I'm here: you should use skb_may_pull() +
{,__}skb_pull() here instead of manual maths. ::network_header and
::mac_header still need to be adjusted manually tho.

> 
> > +
> > +	h6 = ipv6_hdr(skb);
> > +	h6->nexthdr = nexthdr;
> > +
> > +	return 0;
> > +}
> 
> Please switch all the places where the same logics is used to your
> new helper.
> 
> > +
> >  static inline bool ipv6_accept_ra(struct inet6_dev *idev)
> >  {
> >  	/* If forwarding is enabled, RA are not accepted unless the special
> > -- 
> > 2.38.1.584.g0f3c55d4c2-goog
> 
> Thanks,
> Olek

[0] https://elixir.bootlin.com/linux/v6.1-rc6/source/net/ipv6/ip6_offload.c#L92

Thanks,
Olek
