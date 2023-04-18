Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 322046E700B
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 01:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbjDRXpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 19:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbjDRXpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 19:45:00 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B62AAD3D
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 16:44:54 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id 5614622812f47-38dfa504391so843146b6e.3
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 16:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1681861493; x=1684453493;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JiWip3RINkgGCsgi6Ojl9PsC/9Wzqn7IEpqRFkuApfA=;
        b=W1DJLRQaLSD8YyySIV6qqdtjZ8wu1C8lBdXuQHSjfdrzdjaNaIBcH3ar1Bx5R6CGSj
         +xc7MwWdUJ94NO92ebVvDGXFmkyKro5UJcR7ErLz1Sh8miqbvC47VmvTE2vnTeNYZwIh
         glX472qElC+9vN7AO5fvM6bDkRBR18mBZ6VbkNskGSGhMS/j7I4gIeY23RGPYQPPuSQg
         EViaEVv6Do38LOS996sZfAkBH0jhLYsWHg8nDGWJ21zSvTc5h8th6pwKBfn5u0OZBzxr
         t7HYWLOhALNmdTOUoYi54CIfAkkvPDFkRI7qB/fmrrYTjE7hxX6bMGBEoqkn9hbnliqz
         qytw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681861493; x=1684453493;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JiWip3RINkgGCsgi6Ojl9PsC/9Wzqn7IEpqRFkuApfA=;
        b=dOPR6B9BR2Yrjfy7wfqplYJqs0/HdPPP/bj8J6BOQBQ6T5apmi2BHM7FVz5tvjf7Gt
         W9QiKbA0+5TSjf4FTUlRiowP+ChWOOrkpCeEFhp0cwrPlnnqnZ0LjzTWII/uHgCvYx/K
         llFCAVDXBiSmCy3wukedrsAkgBZc3a5KJTz6BWHGVmxVWstdGLSt8IjbMS1TD+1pwhVB
         68x+B1rokvgbarLeNqG6VD3v0v5xcQ71eK0/6mJl/mrAbse1vtzI7FtBBK9Ifva5slTQ
         pGbnhW4mAyN4ifuMFa7OoxuaT7sqMrhQK16TKOFeOI1OoQZvgHGsGVzmp7QGPdpBnQVQ
         P2IA==
X-Gm-Message-State: AAQBX9dm1cBtcqWlplvhkV9vngpUkT9eZy51fJg8Rdtpy7FoM3YmyPFH
        yPVsQ5IbCCfjCQwFyu4U3zYAl/kIPgQez156MQY=
X-Google-Smtp-Source: AKy350Zo2dFJ2TR+DCLMaeOtaLi/rpLOP4gXpvYtg672RiS4KIDRglXLxcJQsjjlEUkg6V+F7QVfBQ==
X-Received: by 2002:a05:6808:287:b0:38c:6997:ca18 with SMTP id z7-20020a056808028700b0038c6997ca18mr1698627oic.46.1681861493633;
        Tue, 18 Apr 2023 16:44:53 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:44fb:4981:84ab:7cf2:bd9a])
        by smtp.gmail.com with ESMTPSA id o10-20020acad70a000000b0038bae910f7bsm5084357oig.1.2023.04.18.16.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 16:44:53 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v4 4/5] net/sched: act_pedit: remove extra check for key type
Date:   Tue, 18 Apr 2023 20:43:53 -0300
Message-Id: <20230418234354.582693-5-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230418234354.582693-1-pctammela@mojatatu.com>
References: <20230418234354.582693-1-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The netlink parsing already validates the key 'htype'.
Remove the datapath check as it's redundant.

Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/act_pedit.c | 29 +++++++----------------------
 1 file changed, 7 insertions(+), 22 deletions(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index ef6cdf17743b..2eacada5dcbb 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -326,37 +326,28 @@ static bool offset_valid(struct sk_buff *skb, int offset)
 	return true;
 }
 
-static int pedit_skb_hdr_offset(struct sk_buff *skb,
-				enum pedit_header_type htype, int *hoffset)
+static void pedit_skb_hdr_offset(struct sk_buff *skb,
+				 enum pedit_header_type htype, int *hoffset)
 {
-	int ret = -EINVAL;
-
+	/* 'htype' is validated in the netlink parsing */
 	switch (htype) {
 	case TCA_PEDIT_KEY_EX_HDR_TYPE_ETH:
-		if (skb_mac_header_was_set(skb)) {
+		if (skb_mac_header_was_set(skb))
 			*hoffset = skb_mac_offset(skb);
-			ret = 0;
-		}
 		break;
 	case TCA_PEDIT_KEY_EX_HDR_TYPE_NETWORK:
 	case TCA_PEDIT_KEY_EX_HDR_TYPE_IP4:
 	case TCA_PEDIT_KEY_EX_HDR_TYPE_IP6:
 		*hoffset = skb_network_offset(skb);
-		ret = 0;
 		break;
 	case TCA_PEDIT_KEY_EX_HDR_TYPE_TCP:
 	case TCA_PEDIT_KEY_EX_HDR_TYPE_UDP:
-		if (skb_transport_header_was_set(skb)) {
+		if (skb_transport_header_was_set(skb))
 			*hoffset = skb_transport_offset(skb);
-			ret = 0;
-		}
 		break;
 	default:
-		ret = -EINVAL;
 		break;
 	}
-
-	return ret;
 }
 
 TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
@@ -389,10 +380,9 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
 
 	for (i = parms->tcfp_nkeys; i > 0; i--, tkey++) {
 		int offset = tkey->off;
+		int hoffset = 0;
 		u32 *ptr, hdata;
-		int hoffset;
 		u32 val;
-		int rc;
 
 		if (tkey_ex) {
 			htype = tkey_ex->htype;
@@ -401,12 +391,7 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
 			tkey_ex++;
 		}
 
-		rc = pedit_skb_hdr_offset(skb, htype, &hoffset);
-		if (rc) {
-			pr_info("tc action pedit bad header type specified (0x%x)\n",
-				htype);
-			goto bad;
-		}
+		pedit_skb_hdr_offset(skb, htype, &hoffset);
 
 		if (tkey->offmask) {
 			u8 *d, _d;
-- 
2.34.1

