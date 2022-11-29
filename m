Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75AF363C14F
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 14:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233885AbiK2Nmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 08:42:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234982AbiK2NmT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 08:42:19 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 685206205C;
        Tue, 29 Nov 2022 05:42:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669729338; x=1701265338;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PG5xQuxDe7q39dDNmtpmF3QxaHI/8GT47yySIJeveVA=;
  b=EFaO2CMy57MmGWejh59hfSmwG+DfxDNNzeLJlG9MoOOl7vm2OtTg16Bf
   PzTtPKB6tNrBvt5+75auSFx2zvhXs5F8hg+YtwLO8RQy+2SU1v5h2C59N
   y4tdQc2e1vQNvZ2zgjurEnzdoWb90OPQcXlak5qE1djbD4Yc5XnX6kPQd
   YJORPmHLJg2oee63sk/gHj+5rcKVeokE54n6Qvd3PS2GVGxB9DlbIWiho
   aOuO15MlnjgGft8lN8rDngqU8mvlpzwnGMXMJK/eOaBXj/4hj7EAGDiH+
   byflveN/8mkzdlzLJL6eUEgNm5zKP9r9F/LLW6dELzX8sAQLd3LcRlLTD
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="401399975"
X-IronPort-AV: E=Sophos;i="5.96,203,1665471600"; 
   d="scan'208";a="401399975"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2022 05:42:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="621457612"
X-IronPort-AV: E=Sophos;i="5.96,203,1665471600"; 
   d="scan'208";a="621457612"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga006.jf.intel.com with ESMTP; 29 Nov 2022 05:42:15 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2ATDgD0U028461;
        Tue, 29 Nov 2022 13:42:13 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Coco Li <lixiaoyan@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/2] IPv6/GRO: generic helper to remove temporary HBH/jumbo header in driver
Date:   Tue, 29 Nov 2022 14:41:20 +0100
Message-Id: <20221129134120.3084527-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <9480856d183c88a205fd79d9dbc156a7fd3ea0d3.camel@redhat.com>
References: <20221123191627.3442831-1-lixiaoyan@google.com> <9480856d183c88a205fd79d9dbc156a7fd3ea0d3.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Tue, 29 Nov 2022 10:33:59 +0100

> Hello,
> 
> Only a couple of minor things below, reporting them as this is still a
> RFC, right ? ;)
> 
> On Wed, 2022-11-23 at 11:16 -0800, Coco Li wrote:

[...]

> > +static inline int ipv6_hopopt_jumbo_remove(struct sk_buff *skb)

I thinks it's relatively small and inlineable enough to not make it
an external function, right? I'd keep it inline just how the author
does it, the compiler then will decide.

> > +{
> > +	const int hophdr_len = sizeof(struct hop_jumbo_hdr);
> > +	int nexthdr = ipv6_has_hopopt_jumbo(skb);
> > +	struct ipv6hdr *h6;
> > +	int err = 0;
> > +
> > +	if (!nexthdr)
> > +		return err;
> 
> You can help a bit the compiler avoiding err initialization:
> 
> 	int err;
> 
> 	if (!nexthdr)
> 		return 0;

Same with the end of the function, @err is unused after
skb_cow_head() and always equal 0, so the end return could be just
`return 0`.

> 
> > +
> > +	err = skb_cow_head(skb, 0);
> > +	if (err)
> > +		return err;
> > +
> > +	/* Remove the HBH header.
> > +	 * Layout: [Ethernet header][IPv6 header][HBH][L4 Header]
> > +	 */
> > +	memmove(skb_mac_header(skb) + hophdr_len, skb_mac_header(skb),
> > +		skb_network_header(skb) - skb_mac_header(skb) +
> 
> The have could be:
> 
> 		skb_mac_header_len(skb)
> 
> which is IMHO a little more clear.
> 
> Thanks!
> 
> Paolo

Thanks,
Olek
