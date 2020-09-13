Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD47E267F62
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 13:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbgIMLwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 07:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbgIMLwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 07:52:09 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA0BCC061574
        for <netdev@vger.kernel.org>; Sun, 13 Sep 2020 04:52:08 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id f18so10279875pfa.10
        for <netdev@vger.kernel.org>; Sun, 13 Sep 2020 04:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=w8p5ozZTrU4K68HpfFs6yDFKhq88It5zforK+H4u9lU=;
        b=nIoZDvQXFzzXGkn3QBx6Ncb18cbT/490INoiPEHYsFSBHQjjuC42Y2hVUb6ryZs9XU
         gamxrN4RawWwjBDnFNsO6Jib4gfBrnXuUHJkDC+uWd+3pUFptC7jnCqdPObPFFg0Xkp1
         G41Ql/zo0wCc+HP3LSTO5N5q54YcgMqwVSyF6b+j26xQFD/C1ymMBJD4z3bQCW3GKOHM
         4JqK9A+aIj+XQS5ANJiCTLEnZwxnkjwY6xmOHAtUZyt6w1Ct8PnaKuwIhShG/w4+FOcn
         RtdcDCa5w+qbOHCUHv0aAg8jfZDOOfS4AONwhOnQ5vVFe9FJaQnA64WwcBQUwiXA6RWI
         s+ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=w8p5ozZTrU4K68HpfFs6yDFKhq88It5zforK+H4u9lU=;
        b=iijX8wCi3ByIYoOW2jYR2MojfwN5Cuj9VScw/P8KMyriJcu0IQg0c8kMBV5hLKfPrY
         KYJKTW4+M80lElFR8SJcfjmzsL9jqzC3AJL+cBEgduRBQ0waE1R2PFL3kcTcyBV8PWFr
         rLc4O2jmAoaDOIQ5cA8D747F6bDOqtmpQRwZ+CJRglBQNwzA0vjeAlHC62b3X4giY3CY
         Rd2+KrYGNwehWffnoFjqL7WJE5cTTyul8HMBOq5wX8/aLmf2J/5YAY9eThQIUHnRYmCH
         7+grAwhmcdlx0BYMAnKiH2xluj3ipoi7nrXrOSVGRXHL/ImefxA94jfv53GA+cmBeNGb
         Zh1Q==
X-Gm-Message-State: AOAM531/C2++btz+60RzWHkKcnaemHa+Ot3eREgCt89XWamMUUb0yFBU
        qSd8LzqTI6rz105m6q3YMxrqmwiWLhA=
X-Google-Smtp-Source: ABdhPJyYnxy88lALsrYd/nW5yCtX8Z502Gex10RI7CoOoUO3sVDmYburBYHde0D7HRUZTUpjvzJ2dg==
X-Received: by 2002:a63:c446:: with SMTP id m6mr7171661pgg.95.1599997928165;
        Sun, 13 Sep 2020 04:52:08 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c202sm7382121pfc.15.2020.09.13.04.52.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 13 Sep 2020 04:52:07 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH net 1/2] net: sched: only keep the available bits when setting vxlan md->gbp
Date:   Sun, 13 Sep 2020 19:51:50 +0800
Message-Id: <6772f33cc49808af9be5c7109d9eed20d309e863.1599997873.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1599997873.git.lucien.xin@gmail.com>
References: <cover.1599997873.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1599997873.git.lucien.xin@gmail.com>
References: <cover.1599997873.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As we can see from vxlan_build/parse_gbp_hdr(), when processing metadata
on vxlan rx/tx path, only dont_learn/policy_applied/policy_id fields can
be set to or parse from the packet for vxlan gbp option.

So we'd better do the mask when set it in act_tunnel_key and cls_flower.
Otherwise, when users don't know these bits, they may configure with a
value which can never be matched.

Reported-by: Shuang Li <shuali@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/vxlan.h        | 3 +++
 net/sched/act_tunnel_key.c | 1 +
 net/sched/cls_flower.c     | 4 +++-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/net/vxlan.h b/include/net/vxlan.h
index 3a41627c..08537aa 100644
--- a/include/net/vxlan.h
+++ b/include/net/vxlan.h
@@ -121,6 +121,9 @@ struct vxlanhdr_gbp {
 #define VXLAN_GBP_POLICY_APPLIED	(BIT(3) << 16)
 #define VXLAN_GBP_ID_MASK		(0xFFFF)
 
+#define VXLAN_GBP_MASK (VXLAN_GBP_DONT_LEARN | VXLAN_GBP_POLICY_APPLIED | \
+			VXLAN_GBP_ID_MASK)
+
 /*
  * VXLAN Generic Protocol Extension (VXLAN_F_GPE):
  * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
index 536c4bc..37f1e10 100644
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -156,6 +156,7 @@ tunnel_key_copy_vxlan_opt(const struct nlattr *nla, void *dst, int dst_len,
 		struct vxlan_metadata *md = dst;
 
 		md->gbp = nla_get_u32(tb[TCA_TUNNEL_KEY_ENC_OPT_VXLAN_GBP]);
+		md->gbp &= VXLAN_GBP_MASK;
 	}
 
 	return sizeof(struct vxlan_metadata);
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 19a8fa2..fed18fd 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -1175,8 +1175,10 @@ static int fl_set_vxlan_opt(const struct nlattr *nla, struct fl_flow_key *key,
 		return -EINVAL;
 	}
 
-	if (tb[TCA_FLOWER_KEY_ENC_OPT_VXLAN_GBP])
+	if (tb[TCA_FLOWER_KEY_ENC_OPT_VXLAN_GBP]) {
 		md->gbp = nla_get_u32(tb[TCA_FLOWER_KEY_ENC_OPT_VXLAN_GBP]);
+		md->gbp &= VXLAN_GBP_MASK;
+	}
 
 	return sizeof(*md);
 }
-- 
2.1.0

