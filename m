Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47AC64E693C
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 20:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346784AbiCXTY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 15:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239554AbiCXTYz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 15:24:55 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 194585EDC6
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 12:23:19 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-de48295467so5930973fac.2
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 12:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j9BqjEYvOFe5WpddGrQo4xVWwwokoJ6HsWwRT+vVQGE=;
        b=mCsfxVjHLvWlO/T2W8HwddHWFNxjVNKCBPgvpFCCt9deEYFFxC8DfMmYhS4TxppP0s
         LqgsbsrJAafd/rxoVtlbCFg/n6zafHCTexEM+WsBgmFRxsucMhhQ/6oMdztMHAxlYU5E
         FR13lPo2RX/Bcoqr9GSKzboWWnuiFNY58oGUzm+4yIAWtk6iKwJ9C2jGdnVrT081KWI5
         7tER3WFXoBfrWxBR4+QXIxjx2vTiCuU9zm4LIXfa51n3iTPNORAkqV3ZXW4RHysMwFgI
         4AWLSVuFVrJjcZqiliszpx+fGoBUnQW2s5i43pmAIW25yW/0sfAZsEYdQI2XV4BXe762
         XIBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j9BqjEYvOFe5WpddGrQo4xVWwwokoJ6HsWwRT+vVQGE=;
        b=cbqCqt1+ch14rYGF/1hwUD858maQhAjtruLPvmtVvaV2xL9zWIqQ5JnDDmy4Dj2A45
         U41YZE1cdSHSvPlztRP5vPcymrSF8iG7bWb3tbKQ3hJA3zfthlWG80y0v9OSVzE1ZPXH
         MWBaq/RPJG+7TS4BYpGLVz1ne1foaxdqy8VOK+oL1XCKIj5cRvYhzYopPYA6GaxA9YxT
         vNpr7yN5F2lJZ1HDJZk00oryYDZl2mRzh7JO7Sd7QAXOteHZPy4nO2z7GwzpfSaDFXsv
         a3k+ytZCoKvy5ZD6BjEx5dWU5H6zVUj71lsa1StbGB/JxmmZmGw0BB44Y9ek0pcN2cQN
         tOsw==
X-Gm-Message-State: AOAM531oE2jV9zcHUEfrA+4rgouSfM8ogzSFwPQbAB4yqAwHpNUp7wLa
        /sbnQ4M6LSWIzMLQr0d7GUARzgfAvh8l6g==
X-Google-Smtp-Source: ABdhPJz4/i7jZlMOPbfoTO6MH2NRUynSP+pRHSVmB4ZizHED4f4BsTgxf0+mAJ9Xz2MieYaMCXmJqA==
X-Received: by 2002:a05:6870:8196:b0:dd:e471:8bb5 with SMTP id k22-20020a056870819600b000dde4718bb5mr3234240oae.294.1648149798381;
        Thu, 24 Mar 2022 12:23:18 -0700 (PDT)
Received: from t14s.localdomain ([2804:14d:32b1:2927::1001])
        by smtp.gmail.com with ESMTPSA id g105-20020a9d12f2000000b005c961f9e119sm1702442otg.35.2022.03.24.12.23.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 12:23:18 -0700 (PDT)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 409941D1B62; Thu, 24 Mar 2022 16:23:16 -0300 (-03)
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, Paul Blakey <paulb@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: [PATCH net] net/sched: act_ct: fix ref leak when switching zones
Date:   Thu, 24 Mar 2022 16:22:10 -0300
Message-Id: <9925b0003629c6f3421f6b36819fa1edabd44f4f.1648149598.git.marcelo.leitner@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When switching zones or network namespaces without doing a ct clear in
between, it is now leaking a reference to the old ct entry. That's
because tcf_ct_skb_nfct_cached() returns false and
tcf_ct_flow_table_lookup() may simply overwrite it.

The fix is to, as the ct entry is not reusable, free it already at
tcf_ct_skb_nfct_cached().

Reported-by: Florian Westphal <fw@strlen.de>
Fixes: 2f131de361f6 ("net/sched: act_ct: Fix flow table lookup after ct clear or switching zones")
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sched/act_ct.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index ec19f625863a04229a9a3894a423e6dd562844a1..25718acc0ff00178fa42d6169d930351e565b104 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -605,22 +605,25 @@ static bool tcf_ct_skb_nfct_cached(struct net *net, struct sk_buff *skb,
 	if (!ct)
 		return false;
 	if (!net_eq(net, read_pnet(&ct->ct_net)))
-		return false;
+		goto drop_ct;
 	if (nf_ct_zone(ct)->id != zone_id)
-		return false;
+		goto drop_ct;
 
 	/* Force conntrack entry direction. */
 	if (force && CTINFO2DIR(ctinfo) != IP_CT_DIR_ORIGINAL) {
 		if (nf_ct_is_confirmed(ct))
 			nf_ct_kill(ct);
 
-		nf_ct_put(ct);
-		nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
-
-		return false;
+		goto drop_ct;
 	}
 
 	return true;
+
+drop_ct:
+	nf_ct_put(ct);
+	nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
+
+	return false;
 }
 
 /* Trim the skb to the length specified by the IP/IPv6 header,
-- 
2.35.1

