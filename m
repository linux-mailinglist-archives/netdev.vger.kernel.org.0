Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 711A42F6CE0
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 22:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729187AbhANVIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 16:08:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727806AbhANVIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 16:08:37 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE54C0613C1
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 13:07:57 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id j1so3565154pld.3
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 13:07:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TqaoyqwoZBWdbtWoGtgfpXqYtxK0WIqgsl2emnUTD/Y=;
        b=WH3GuIWeHOALkImin5C1sMt/0F4IYbqGL3igAFN5RmuwenKdCJARkEuYr/mnalyfAU
         6t/xiTy9U+7N7uiX4sZyQgadmZFtqFil7kV/bWun8NmM3W+Inlr2O5y4NsYbZ7/BDB2l
         lA/BoYg1Akzk8O7YGyTSpZRXvJvJp+kTtkOOvnB2sd0169Jrm4b1GiP7v9pzYKw5ftib
         a93D5DPlGH2Fa/nVeAJecgV4c22RsyHXPCcG+wKtCJ/ZtgPcEnEtrA4wGOcKPyIEoLMM
         X3tuIau1Vxaiq8jUWCHZcyhfnUkwMQxingCJtPZivJg7sbK89H3mY+JDH1Q2fzKFRL0N
         tB1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TqaoyqwoZBWdbtWoGtgfpXqYtxK0WIqgsl2emnUTD/Y=;
        b=nKyAOwvXRQn8Ikd9ughLj51SX6dHgKm0a4DET8eLviY8keNYPteLEj9uyNQKZB8Rbm
         xdhZYUSowbM7hX6EOsC87qpSvw+GY3SsubQrJMBvylRGwU9tjZB3YDDOgNlD5aBrRcih
         eB7IYEO1nwUtk4SBDmdXCREZC8QIyIXRMAHJSgnCKmnJfKjcCy6+uYnWfIooAjdP2+E8
         MdknWb8DTT+H8AUOy+lhuzeJhcdp5iEG/5A/ygJVzw/AWCwWHNNzy5hgbC8fX0SkNWEj
         xYDSTMxW1Fhas9ZJsJ2Ns9FbXqEykAnfCuo9LqREi6dTRwtNB9WO4gG3T6Bk88j8UJnx
         Qf7Q==
X-Gm-Message-State: AOAM533WW9LxTK7MpODpC/Wc4p9+h0nIv+E5ML5yWdSqXr9mPSQ3aGEJ
        2TxBTjmdILVkz2Zs072y8LxXW6L5Zloh8g==
X-Google-Smtp-Source: ABdhPJwPftXMt+1e2HEDWZwcH8L1YtYEB69rS8+VxWINk+tqZHdoPDMs9bdm9gqsmeekTZ2xU6okJQ==
X-Received: by 2002:a17:90a:a88:: with SMTP id 8mr6859153pjw.120.1610658476703;
        Thu, 14 Jan 2021 13:07:56 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:245e:7a53:4c33:e5e8])
        by smtp.gmail.com with ESMTPSA id z12sm5991612pfn.186.2021.01.14.13.07.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 13:07:55 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <cong.wang@bytedance.com>,
        syzbot+2624e3778b18fc497c92@syzkaller.appspotmail.com,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Xin Long <lucien.xin@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [Patch net v3] cls_flower: call nla_ok() before nla_next()
Date:   Thu, 14 Jan 2021 13:07:49 -0800
Message-Id: <20210114210749.61642-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

fl_set_enc_opt() simply checks if there are still bytes left to parse,
but this is not sufficent as syzbot seems to be able to generate
malformatted netlink messages. nla_ok() is more strict so should be
used to validate the next nlattr here.

And nla_validate_nested_deprecated() has less strict check too, it is
probably too late to switch to the strict version, but we can just
call nla_ok() too after it.

Reported-and-tested-by: syzbot+2624e3778b18fc497c92@syzkaller.appspotmail.com
Fixes: 0a6e77784f49 ("net/sched: allow flower to match tunnel options")
Fixes: 79b1011cb33d ("net: sched: allow flower to match erspan options")
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Xin Long <lucien.xin@gmail.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/sched/cls_flower.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 1319986693fc..280eab0c833f 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -1272,6 +1272,10 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
 
 		nla_opt_msk = nla_data(tb[TCA_FLOWER_KEY_ENC_OPTS_MASK]);
 		msk_depth = nla_len(tb[TCA_FLOWER_KEY_ENC_OPTS_MASK]);
+		if (!nla_ok(nla_opt_msk, msk_depth)) {
+			NL_SET_ERR_MSG(extack, "Invalid attribute for masks");
+			return -EINVAL;
+		}
 	}
 
 	nla_for_each_attr(nla_opt_key, nla_enc_key,
@@ -1307,9 +1311,6 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
 				NL_SET_ERR_MSG(extack, "Key and mask miss aligned");
 				return -EINVAL;
 			}
-
-			if (msk_depth)
-				nla_opt_msk = nla_next(nla_opt_msk, &msk_depth);
 			break;
 		case TCA_FLOWER_KEY_ENC_OPTS_VXLAN:
 			if (key->enc_opts.dst_opt_type) {
@@ -1340,9 +1341,6 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
 				NL_SET_ERR_MSG(extack, "Key and mask miss aligned");
 				return -EINVAL;
 			}
-
-			if (msk_depth)
-				nla_opt_msk = nla_next(nla_opt_msk, &msk_depth);
 			break;
 		case TCA_FLOWER_KEY_ENC_OPTS_ERSPAN:
 			if (key->enc_opts.dst_opt_type) {
@@ -1373,14 +1371,20 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
 				NL_SET_ERR_MSG(extack, "Key and mask miss aligned");
 				return -EINVAL;
 			}
-
-			if (msk_depth)
-				nla_opt_msk = nla_next(nla_opt_msk, &msk_depth);
 			break;
 		default:
 			NL_SET_ERR_MSG(extack, "Unknown tunnel option type");
 			return -EINVAL;
 		}
+
+		if (!nla_opt_msk)
+			continue;
+
+		if (!nla_ok(nla_opt_msk, msk_depth)) {
+			NL_SET_ERR_MSG(extack, "A mask attribute is invalid");
+			return -EINVAL;
+		}
+		nla_opt_msk = nla_next(nla_opt_msk, &msk_depth);
 	}
 
 	return 0;
-- 
2.25.1

