Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0408D4A8879
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 17:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346699AbiBCQSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 11:18:43 -0500
Received: from mga14.intel.com ([192.55.52.115]:20070 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231477AbiBCQSi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 11:18:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643905119; x=1675441119;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ARb6j7+l1wuryTTlmyeKT87Elz11FCQCv50Dn2FT8IA=;
  b=laCdawFaWLT048elHOiPw2hXBwDkCFfHUxohvZY51efHNMp5stCDAZ1X
   Q4xfc8cpVrfTt9RWvvsBB/58mfIXWWvcC/vZ+x1yN+NS3UDcoliQN0O/8
   cmMcu27pfAKPPRzDAkDkphfMArpyIMoLOUaWSzJhQpfffVNbzNLKZHgYZ
   9ibhNcvxNaBiaZFFW0tVdMzMIEg8Dtvhy6QocT1Emgn5cYO722z4ALqtJ
   z5lq35JujQmFckSs187R02boTP1v78PrAA7cuuSeIwzPzOgvFP6WqPSsI
   +COXuBAELdUBGFMGSx1yKzZpIAieJH2gGEL09mQHr3Yr3Lr0QvPtodMaa
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10247"; a="248393204"
X-IronPort-AV: E=Sophos;i="5.88,340,1635231600"; 
   d="scan'208";a="248393204"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2022 08:18:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,340,1635231600"; 
   d="scan'208";a="480533134"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga003.jf.intel.com with ESMTP; 03 Feb 2022 08:18:36 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 213GIY10015819;
        Thu, 3 Feb 2022 16:18:35 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 1/3] net: gro: avoid re-computing truesize twice on recycle
Date:   Thu,  3 Feb 2022 17:16:32 +0100
Message-Id: <20220203161632.13190-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <e311f77a9ddb739e3c583201fb99b9945942f68a.1643902526.git.pabeni@redhat.com>
References: <cover.1643902526.git.pabeni@redhat.com> <e311f77a9ddb739e3c583201fb99b9945942f68a.1643902526.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Thu,  3 Feb 2022 16:48:21 +0100

> After commit 5e10da5385d2 ("skbuff: allow 'slow_gro' for skb
> carring sock reference") and commit af352460b465 ("net: fix GRO
> skb truesize update") the truesize of freed skb is properly updated

                                        ^^^^^

One nit here, I'd change this to "truesize of skb with stolen head"
or so. It took me a bit of time to get why we should update the
truesize of skb already freed (: Right, napi_reuse_skb() makes use
of stolen-data skbs.

> by the GRO engine, we don't need anymore resetting it at recycle time.
> 
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  net/core/gro.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/net/core/gro.c b/net/core/gro.c
> index a11b286d1495..d43d42215bdb 100644
> --- a/net/core/gro.c
> +++ b/net/core/gro.c
> @@ -634,7 +634,6 @@ static void napi_reuse_skb(struct napi_struct *napi, struct sk_buff *skb)
>  
>  	skb->encapsulation = 0;
>  	skb_shinfo(skb)->gso_type = 0;
> -	skb->truesize = SKB_TRUESIZE(skb_end_offset(skb));
>  	if (unlikely(skb->slow_gro)) {
>  		skb_orphan(skb);
>  		skb_ext_reset(skb);
> -- 
> 2.34.1

Thanks,
Al
