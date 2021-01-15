Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75B162F84BB
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 19:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728565AbhAOSvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 13:51:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbhAOSvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 13:51:11 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE308C0613C1
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 10:50:30 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id w3so9475513otp.13
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 10:50:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/e8TXLfr9KgIRhBv3DkYacukvLPeDNuuybWkaAdAMSs=;
        b=PDZpxYrzkYMGosIouJya2Y2+CmNoSl3O5HCzhsrAD4nrwhcBMTPoJ6Y8xuIH5A1WvS
         nsFrNu8Yz35YPlg2hYH8qFL/tlBaKCp8mnuuvffrpTBNBWGlpeqYPXKzOXZWH1OP3AG3
         4lY8MoJzVD+DzZ6lVeTLHHQeuvf+BYMroo08FP4h9RtgGwd1xR83OANjY7Cun2ht77K3
         /ZBWWMhMrshwciO/KODR+jYCAcwAOs+KYM3mEZMhgiV/pPO/i38VlDuSWfay0apk+HIt
         Z6koknifsYw67nc9CXb9cJVLx57//GjHWDNdC0i+OKWvcV9CLbkBzKjlyhnT9sb6ZBEx
         Hxjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/e8TXLfr9KgIRhBv3DkYacukvLPeDNuuybWkaAdAMSs=;
        b=n7PwrY4gQRiYTxWzQeOryJwEm6zPgbv5UaLwGHVUo0Y9dS9+7he57tp1N/FZPYt2Ig
         emvZ9XgrjMGN9xScMPuE+uNcPSzRhWsp9pbP+fi2RBF32UPXyiHypa27KXXmRGZKz4DL
         swc5/UcVjrCxETxe46NYo95VOYqu3OA4KQokKXxAICfLkVbUPYAio/8ecd5gL8ZIdpOf
         ke84xHow1yfqu4FEOjvxvIlShOLHcgXk+ig2UNN7jV2TOon7Z4EixBadBXLyFF9vfwPD
         moDNG5Lu4yKCSgR3tJc1YxqgC7dTRXRNGTgLf7ImtAx901e0ahTljFT/pZwWj5zVzyJx
         tyig==
X-Gm-Message-State: AOAM530KpCQ+EWxZ9QUvqcx9+uUSqx/RlnH+6RuYbRlZOHeLtS7cyAah
        4i9RgXnumOvMSUSwHhfGvFjUAjcqTwkw6w==
X-Google-Smtp-Source: ABdhPJwyC3qtC3d1K5NTDjzoNHa7fEmprtXVfntlmAR3u9oF5ff2Ff2xs7YYUAaVSSn/Bqh0AuG64Q==
X-Received: by 2002:a05:6830:157:: with SMTP id j23mr9751735otp.240.1610736629946;
        Fri, 15 Jan 2021 10:50:29 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:245e:7a53:4c33:e5e8])
        by smtp.gmail.com with ESMTPSA id g21sm1961413otj.77.2021.01.15.10.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 10:50:29 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <cong.wang@bytedance.com>,
        syzbot+2624e3778b18fc497c92@syzkaller.appspotmail.com,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Xin Long <lucien.xin@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [Patch net v4] cls_flower: call nla_ok() before nla_next()
Date:   Fri, 15 Jan 2021 10:50:24 -0800
Message-Id: <20210115185024.72298-1-xiyou.wangcong@gmail.com>
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
index 1319986693fc..84f932532db7 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -1272,6 +1272,10 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
 
 		nla_opt_msk = nla_data(tb[TCA_FLOWER_KEY_ENC_OPTS_MASK]);
 		msk_depth = nla_len(tb[TCA_FLOWER_KEY_ENC_OPTS_MASK]);
+		if (!nla_ok(nla_opt_msk, msk_depth)) {
+			NL_SET_ERR_MSG(extack, "Invalid nested attribute for masks");
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
+		if (!msk_depth)
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

