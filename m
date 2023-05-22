Return-Path: <netdev+bounces-4354-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 73A7770C2AB
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 17:46:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A14F428105B
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 15:46:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBB4B15482;
	Mon, 22 May 2023 15:46:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE3F14AA9
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 15:46:13 +0000 (UTC)
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59586D2;
	Mon, 22 May 2023 08:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1684770373; x=1716306373;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=e//5RLUVPU9F5Ilco4gWUMUa+N+uxNtJHX2X6l2Uq94=;
  b=cAnbUh4nUCYeqtIyvkDEqtn/kK19sYJ3QymwjV7RFOklzoHlqjgvKEfi
   69yPmj3Ekmw4hpBgZwXp86zUugky/NmoCk3M/rKwSrOKSLxZ8IHIGHXPM
   1yJXNqqqvrQTmkA1DAQwwPXSr0oCEvttXNGYc1LdIf+WE7BILy/Iu/22V
   Q=;
X-IronPort-AV: E=Sophos;i="6.00,184,1681171200"; 
   d="scan'208";a="340595341"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-83883bdb.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 15:46:08 +0000
Received: from EX19MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
	by email-inbound-relay-pdx-2a-m6i4x-83883bdb.us-west-2.amazon.com (Postfix) with ESMTPS id 18F3960D02;
	Mon, 22 May 2023 15:46:07 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 22 May 2023 15:46:06 +0000
Received: from 88665a182662.ant.amazon.com (10.119.123.82) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.26;
 Mon, 22 May 2023 15:46:03 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <ptyadav@amazon.de>
CC: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<kuniyu@amazon.com>, <linux-kernel@vger.kernel.org>,
	<netdev@vger.kernel.org>, <nmanthey@amazon.de>, <pabeni@redhat.com>,
	<willemb@google.com>
Subject: Re: [PATCH net] net: fix skb leak in __skb_tstamp_tx()
Date: Mon, 22 May 2023 08:45:54 -0700
Message-ID: <20230522154554.44836-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230522153020.32422-1-ptyadav@amazon.de>
References: <20230522153020.32422-1-ptyadav@amazon.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.119.123.82]
X-ClientProxiedBy: EX19D045UWC003.ant.amazon.com (10.13.139.198) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
	T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Pratyush Yadav <ptyadav@amazon.de>
Date: Mon, 22 May 2023 17:30:20 +0200
> Commit 50749f2dd685 ("tcp/udp: Fix memleaks of sk and zerocopy skbs with
> TX timestamp.") added a call to skb_orphan_frags_rx() to fix leaks with
> zerocopy skbs. But it ended up adding a leak of its own. When
> skb_orphan_frags_rx() fails, the function just returns, leaking the skb
> it just cloned. Free it before returning.
> 
> This bug was discovered and resolved using Coverity Static Analysis
> Security Testing (SAST) by Synopsys, Inc.
> 
> Fixes: 50749f2dd685 ("tcp/udp: Fix memleaks of sk and zerocopy skbs with TX timestamp.")
> Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>

Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>

Good catch, thanks!


> ---
> 
> I do not know this code very well, this was caught by our static
> analysis tool. I did not try specifically reproducing the leak but I did
> do a boot test by adding this patch on 6.4-rc3 and the kernel boots
> fine.
> 
>  net/core/skbuff.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 515ec5cdc79c..cea28d30abb5 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -5224,8 +5224,10 @@ void __skb_tstamp_tx(struct sk_buff *orig_skb,
>  	} else {
>  		skb = skb_clone(orig_skb, GFP_ATOMIC);
> 
> -		if (skb_orphan_frags_rx(skb, GFP_ATOMIC))
> +		if (skb_orphan_frags_rx(skb, GFP_ATOMIC)) {
> +			kfree_skb(skb);
>  			return;
> +		}
>  	}
>  	if (!skb)
>  		return;
> --
> 2.39.2

