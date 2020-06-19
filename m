Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7ABB2005AF
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 11:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732201AbgFSJqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 05:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729718AbgFSJqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 05:46:07 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD967C06174E
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 02:46:06 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id y18so3735844plr.4
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 02:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oneconvergence-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=U+TSRhpjMCC5R2Ooi/N/kaAswzU8zvrL1OW1HTQ1MAA=;
        b=07trk6qWLCW72Et1H5twjTVtT2UzikacGVNdziAkqcq4pgRHEtgsUeGo7utstzVtwO
         ob6pAZ05SKCWYAlblbxkL5A919xY8PGh6FfNDycU0DHChNY9iZjL8GsSmZxred0GNWcw
         XvvaDCPJb2pUD0FZunQ+ynWrLexBbHZswOcNqNDF9i65F9xpeFtKc2TVfCprpl3BEWvj
         AKQZ/GO989joGD0J9ORb0scU9rgcnDcSA78zrSaLtT2crvdY+QplNY5HW1yaXtmyji3A
         iS4HGbQ8Ro+wj4IbCH5Lczy4b61IiirtbzI2qRaRf0R008NeR7wpQOToD5j2aHhdDFRb
         J5gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=U+TSRhpjMCC5R2Ooi/N/kaAswzU8zvrL1OW1HTQ1MAA=;
        b=bkvkXfI6YiJGXGQmZzYYQRupEtVH8GbtB/4tmGoquZ9DNJpEHgMqwzPpFKTtPzfJ/T
         Nalb4Tf/HZe73yem7+fYeUoZgl0eLB8nIJ8Nc0TQ8vQu8UwkFDyIXH+aS3MyGDex8NzU
         ZYGRpFDKVvrBRtItL8Ww8NO4KZ7Z0Ec4CxvTp2Az1+2V6xFZuAvpYW1KjlEA0/FOXM+0
         vwWCkFUP0Ievj2vv+Ycs2yGdPsVH4ih7BRqta7yszTmG4L4oBL1ykKEXf2c5/WyuAGtw
         dSKGxkkrB3rWmEfIIjTbQYUoYZboJyNCXSCeFxketOtlWUDfWAJuCeCw8IXI3caZRFQN
         00HA==
X-Gm-Message-State: AOAM532X554MOKuxf7oQTJIQ4BRM2H/dvwYDhHvH0WKCV8oDpbvhorU8
        HraD0zIEwiSo/ds+Q6OYozbDKw==
X-Google-Smtp-Source: ABdhPJz7+AdtbL/BQMAt6+rsOeqVv9Znq9GG7pLMNry2vLOoKws6kTZuP9WD21BTmqEc5YNf7PKeTQ==
X-Received: by 2002:a17:902:b106:: with SMTP id q6mr7274724plr.23.1592559966243;
        Fri, 19 Jun 2020 02:46:06 -0700 (PDT)
Received: from localhost.localdomain ([27.57.206.119])
        by smtp.gmail.com with ESMTPSA id m20sm5896306pfk.52.2020.06.19.02.46.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2020 02:46:05 -0700 (PDT)
From:   dsatish <satish.d@oneconvergence.com>
To:     davem@davemloft.net
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        kuba@kernel.org, netdev@vger.kernel.org,
        simon.horman@netronome.com, kesavac@gmail.com,
        satish.d@oneconvergence.com, prathibha.nagooru@oneconvergence.com,
        intiyaz.basha@oneconvergence.com, jai.rana@oneconvergence.com
Subject: [PATCH net-next 3/3] cls_flower: Allow flow offloading though masked key exist.
Date:   Fri, 19 Jun 2020 15:11:56 +0530
Message-Id: <20200619094156.31184-4-satish.d@oneconvergence.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200619094156.31184-1-satish.d@oneconvergence.com>
References: <20200619094156.31184-1-satish.d@oneconvergence.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A packet reaches OVS user space, only if, either there is no rule in
datapath/hardware or there is race condition that the flow is added
to hardware but before it is processed another packet arrives.

It is possible hardware as part of its limitations/optimizations
remove certain flows. To handle such cases where the hardware lost
the flows, tc can offload to hardware if it receives a flow for which
there exists an entry in its flow table. To handle such cases TC when
it returns EEXIST error, also programs the flow in hardware, if
hardware offload is enabled.

Signed-off-by: Chandra Kesava <kesavac@gmail.com>
Signed-off-by: Prathibha Nagooru <prathibha.nagooru@oneconvergence.com>
Signed-off-by: Satish Dhote <satish.d@oneconvergence.com>
---
 net/sched/cls_flower.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index f1a5352cbb04..d718233cd5b9 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -431,7 +431,8 @@ static void fl_hw_destroy_filter(struct tcf_proto *tp, struct cls_fl_filter *f,
 
 static int fl_hw_replace_filter(struct tcf_proto *tp,
 				struct cls_fl_filter *f, bool rtnl_held,
-				struct netlink_ext_ack *extack)
+				struct netlink_ext_ack *extack,
+				unsigned long cookie)
 {
 	struct tcf_block *block = tp->chain->block;
 	struct flow_cls_offload cls_flower = {};
@@ -444,7 +445,7 @@ static int fl_hw_replace_filter(struct tcf_proto *tp,
 
 	tc_cls_common_offload_init(&cls_flower.common, tp, f->flags, extack);
 	cls_flower.command = FLOW_CLS_REPLACE;
-	cls_flower.cookie = (unsigned long) f;
+	cls_flower.cookie = cookie;
 	cls_flower.rule->match.dissector = &f->mask->dissector;
 	cls_flower.rule->match.mask = &f->mask->key;
 	cls_flower.rule->match.key = &f->mkey;
@@ -2024,11 +2025,25 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 	fl_init_unmasked_key_dissector(&fnew->unmasked_key_dissector);
 
 	err = fl_ht_insert_unique(fnew, fold, &in_ht);
-	if (err)
+	if (err) {
+		/* It is possible Hardware lost the flow even though TC has it,
+		 * and flow miss in hardware causes controller to offload flow again.
+		 */
+		if (err == -EEXIST && !tc_skip_hw(fnew->flags)) {
+			struct cls_fl_filter *f =
+				__fl_lookup(fnew->mask, &fnew->mkey);
+
+			if (f)
+				fl_hw_replace_filter(tp, fnew, rtnl_held,
+						     extack,
+						     (unsigned long)(f));
+		}
 		goto errout_mask;
+	}
 
 	if (!tc_skip_hw(fnew->flags)) {
-		err = fl_hw_replace_filter(tp, fnew, rtnl_held, extack);
+		err = fl_hw_replace_filter(tp, fnew, rtnl_held, extack,
+					   (unsigned long)fnew);
 		if (err)
 			goto errout_ht;
 	}
-- 
2.17.1

