Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 920A92F6619
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 17:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbhANQjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 11:39:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbhANQjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 11:39:08 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAFE6C061574
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 08:38:27 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id i6so5740030otr.2
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 08:38:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z+DsKs940eR1cGRf3/JgrwiIgtKjPUhWNPD9l5ksRQk=;
        b=APyOy7SKvoROeJW7hpiJmoxVrZXUv0VL7ijk/zXMfTD6oU97ft6l4I1XWmu8Siwxs2
         KYrv2fDfCDjoZBiHgiLhd5g01bQ0di/OY43huq+NiL8XRZ10zl3NRifNdZ/adh/w9Sgh
         BqkBeGGLSMZWEkYZzOPk8UZBsejPrON9TaNUKk56ekXDuJg2nbkt0iV5XRM6cnCK1miv
         k2Cik9UF6ds/6gRG1viCHpkXYj5u4NCYeOBozTMA1qLq4B7psLrRp4/HmCi5/6ExXBep
         bqcr+owEnztCueBwZ5rKlReDl9QtmPS6mlIjBi3x2CXlnqlBxZtaWQ03PrUBLik2mwGx
         ZuHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z+DsKs940eR1cGRf3/JgrwiIgtKjPUhWNPD9l5ksRQk=;
        b=Kyx8MOjbI9rqqdFdral0I91ylQ+eMRK50ixd/JKRiNZXRlnm88ktQYbgsnKE0m74nd
         lGWeiwJbKu9p7JjcG18N6NvAsbMRZL3ZHKqren5bkfivs6SoOJ/bp42z2YEpcl/m2K2s
         z2ZuGH0oarjdfS4ycRaIBWIz1ZwWQcyC23otVNKxhy8DVbcTbOPiA364ji3cFyEva+Az
         kvOlCogq9gSHMR+An0M830XKGwBLbRCoZMK2E2dJxZ3xT6HCJWcjXrBZ/zI1rQoeYzV0
         8omNQYf1vOjWg8Xyk8tpJqSTdsb1nKS/7kAgAnCvdz3TT260fsr5YsfcsS6zdJvmlcWL
         o3Gw==
X-Gm-Message-State: AOAM533GMK5mUT0sH37Kujp4d7kANy0vMYPP8St+70sEx+zjRb0Ps32i
        u7K3de4bT0SCsm2eiZuEYgQ8PT8D0gbPsg==
X-Google-Smtp-Source: ABdhPJxsWqZ5j5/jlREuP/AkcJ/uM+wlMYLfL3keFJ6qhyHsVBo9vi5lkYW471jbUgTSt7nTm39TBw==
X-Received: by 2002:a9d:19c9:: with SMTP id k67mr5144610otk.292.1610642306955;
        Thu, 14 Jan 2021 08:38:26 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:245e:7a53:4c33:e5e8])
        by smtp.gmail.com with ESMTPSA id w10sm1124841oic.44.2021.01.14.08.38.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 08:38:26 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <cong.wang@bytedance.com>,
        syzbot+2624e3778b18fc497c92@syzkaller.appspotmail.com,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Xin Long <lucien.xin@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [Patch net v2] cls_flower: call nla_ok() before nla_next()
Date:   Thu, 14 Jan 2021 08:38:22 -0800
Message-Id: <20210114163822.56306-1-xiyou.wangcong@gmail.com>
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
 net/sched/cls_flower.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 1319986693fc..740d9018e45f 100644
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
@@ -1373,14 +1371,17 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
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
+		if (!nla_ok(nla_opt_msk, msk_depth)) {
+			NL_SET_ERR_MSG(extack, "Mask attribute is invalid");
+			return -EINVAL;
+		}
+		nla_opt_msk = nla_next(nla_opt_msk, &msk_depth);
 	}
 
 	return 0;
-- 
2.25.1

