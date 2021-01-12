Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2D92F2675
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 03:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731131AbhALC4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 21:56:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728044AbhALC4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 21:56:41 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8295EC061575
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 18:56:01 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id l200so855326oig.9
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 18:56:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tkhhlh0ax1zebrf/ztDg+GsDD7mIaP6cRJYlZlKkR2s=;
        b=amqqhpiJIBPlGsmoAenw/C4zMHTU2gaGEfkIK8MoVflEq+vstdESxm1hBGdB9Twmwi
         wFIHW0qQHjF8FsPCOt4L3RP+6wJFzlEE2CGQqJlunLaJnMWhlGXD0wDzfX5M11La/lOw
         GqdgdtK3B/uA6izLeluukRooPB+9FQJdk4J4M+B+t4eMHaN2lVNG4A+jLQIaEapajDfD
         v+vcH2/DQWLlESTIpVcCEAbxdrF/zho1x7irrAJKkNgwYWKksMq1NAa0xKzLEJlfeZ7n
         EA0W9Pals3bt2Msl8l/QIhiXiTjN9ZaUEky+i7knY5VypZ2ZvxChd9t9y1lAAv115ugy
         wvRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tkhhlh0ax1zebrf/ztDg+GsDD7mIaP6cRJYlZlKkR2s=;
        b=pOSK/9tOZnBmO3GkkgBURK7t2KtgFnaUq9q7p/Fhcz+hM7WNbllgBadmE3O4ftJhyG
         o7kVx+7amwrOlFjXKSVVOt3Lyagx29fJDYmfFmcPVlpkT0GMIwrBgt0xaT0v5WOYmaQ1
         JCzWK62DxXldblhxtHrzMYW0EOSl/BSNUflHcr4IRVc3vfQzJ7Nw1cLkzlEcyKOoY60v
         rlaN/qg3ZHju6JjeS4Guwnn2YoTD8lSwn+wktFjeQY6UPRS+hRFVIRTVgHsLAnpaGPGp
         ycyx1iu6CpW0W41ETnISDT+2VGro1UpdRpBqYw3VKu69lSjLVQhK0uvXOvjPgRmBu4Or
         Sb3A==
X-Gm-Message-State: AOAM530WxQ7mxsKdjyQDhoM/mhT5wWW2VBtQkgmqJERQ5ZMMtu6aCkT/
        gju96RvR6WexVo5CfN7rQvpXPHmDvd42Wg==
X-Google-Smtp-Source: ABdhPJzg+2XXKft4cur7aWeLPCXf3ProneULMTsxAeJv9/QwPvymI930jAj5rKdmPNneW71GvE2UJg==
X-Received: by 2002:a05:6808:650:: with SMTP id z16mr1115812oih.50.1610420160659;
        Mon, 11 Jan 2021 18:56:00 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:245e:7a53:4c33:e5e8])
        by smtp.gmail.com with ESMTPSA id b8sm386531oia.39.2021.01.11.18.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 18:55:59 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <cong.wang@bytedance.com>,
        syzbot+2624e3778b18fc497c92@syzkaller.appspotmail.com,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Xin Long <lucien.xin@gmail.com>, Jiri Pirko <jiri@resnulli.us>
Subject: [Patch net] cls_flower: call nla_ok() before nla_next()
Date:   Mon, 11 Jan 2021 18:55:48 -0800
Message-Id: <20210112025548.19107-1-xiyou.wangcong@gmail.com>
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
Cc: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Xin Long <lucien.xin@gmail.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/sched/cls_flower.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 1319986693fc..e265c443536e 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -1272,6 +1272,8 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
 
 		nla_opt_msk = nla_data(tb[TCA_FLOWER_KEY_ENC_OPTS_MASK]);
 		msk_depth = nla_len(tb[TCA_FLOWER_KEY_ENC_OPTS_MASK]);
+		if (!nla_ok(nla_opt_msk, msk_depth))
+			return -EINVAL;
 	}
 
 	nla_for_each_attr(nla_opt_key, nla_enc_key,
@@ -1308,7 +1310,7 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
 				return -EINVAL;
 			}
 
-			if (msk_depth)
+			if (nla_ok(nla_opt_msk, msk_depth))
 				nla_opt_msk = nla_next(nla_opt_msk, &msk_depth);
 			break;
 		case TCA_FLOWER_KEY_ENC_OPTS_VXLAN:
@@ -1341,7 +1343,7 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
 				return -EINVAL;
 			}
 
-			if (msk_depth)
+			if (nla_ok(nla_opt_msk, msk_depth))
 				nla_opt_msk = nla_next(nla_opt_msk, &msk_depth);
 			break;
 		case TCA_FLOWER_KEY_ENC_OPTS_ERSPAN:
@@ -1374,7 +1376,7 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
 				return -EINVAL;
 			}
 
-			if (msk_depth)
+			if (nla_ok(nla_opt_msk, msk_depth))
 				nla_opt_msk = nla_next(nla_opt_msk, &msk_depth);
 			break;
 		default:
-- 
2.25.1

