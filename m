Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAB4C2CFA61
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 09:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727752AbgLEIAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 03:00:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbgLEIAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 03:00:38 -0500
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2EE7C0613D1;
        Fri,  4 Dec 2020 23:59:57 -0800 (PST)
Received: by mail-oi1-x244.google.com with SMTP id p126so9069389oif.7;
        Fri, 04 Dec 2020 23:59:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gA+Cfb+GvQfN8Jyg7lGX1laB0iw7fvwn0+s3BW8xiQM=;
        b=Vn5gh4sCo7wY0H15wbaAF/sRs0SJ/YtEefOThfoiyHw9bku1/u6CwiMG1vEuRMziZ3
         x9iTDzhCg62ilJog6Sjb28WkrlFh2I9K2QUGDIaQon9WTNimQi6Xt0lOSgitzpKZQnSq
         03o85v09WKaaK009d61Jq/3zihTWRKo6MAtAXJDGL0H1dOE4N7dXxurynKCMyqOGEPve
         Brm5EU5852SdCVUl+PsDqhPXKdGaMYBospJgHT46o39ICPJkzFGWggDdAwaEWSEEqyTw
         no3tjORgSuMWG3u3z+K10HWc6IGyLoYkdzskQgqPkyMlOCYGiwoUpuUhCrR8zyxDFIbO
         9AAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gA+Cfb+GvQfN8Jyg7lGX1laB0iw7fvwn0+s3BW8xiQM=;
        b=YXu553M8IUByNw4BSDZNWoQahEVNqOet+IIHFr/rpcrsjRLb1V2awBmKEOS73OQZvo
         jT4/yCXK72iwM7lqWU4uxdF0yNNEaBriCcGSpc33fGbhGB+5TCtcAtdzzgK0R0MC/kND
         W0TzXpNLeKRl5ltzk+BNtRmvHTrxnSG6ITn37l8Kc9USomrJOI+B1Py8e7czRyopb88G
         uZLEWHLZ/sNy8ybi9ExYz0SmPnvkmNneXMKzXtRxBsL/04TOU6534OHyajInzWNdYz15
         XpNvaRmIOp29BPfl2YM8Mg5+cauL5I8g3Vqau3jiLAUztv2+zEF6tCpQ7Mgo/S+jWKrL
         XiaQ==
X-Gm-Message-State: AOAM530BSQp8h3Alhi9w2sT2yO9M/6i+x0YgLA4RkbLWCkG1kTl2Ykmc
        IxTLVY6fnX/PfYmJBkPCmkB2frNTf5lORg==
X-Google-Smtp-Source: ABdhPJyYJhwcIqc/+/0MQEfHS2qqMUFQpveI90RqtVeZ3L3ScSfbkkKQzyEz6cgPKxiG2J5trkphlg==
X-Received: by 2002:aca:6103:: with SMTP id v3mr5843840oib.64.1607155196793;
        Fri, 04 Dec 2020 23:59:56 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:2482:49a9:7a40:f76b])
        by smtp.gmail.com with ESMTPSA id i82sm1263305oif.33.2020.12.04.23.59.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 23:59:55 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Dongdong Wang <wangdongdong.6@bytedance.com>,
        Thomas Graf <tgraf@suug.ch>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch net v2 1/2] lwt: disable BH too in run_lwt_bpf()
Date:   Fri,  4 Dec 2020 23:59:45 -0800
Message-Id: <20201205075946.497763-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dongdong Wang <wangdongdong.6@bytedance.com>

The per-cpu bpf_redirect_info is shared among all skb_do_redirect()
and BPF redirect helpers. Callers on RX path are all in BH context,
disabling preemption is not sufficient to prevent BH interruption.

In production, we observed strange packet drops because of the race
condition between LWT xmit and TC ingress, and we verified this issue
is fixed after we disable BH.

Although this bug was technically introduced from the beginning, that
is commit 3a0af8fd61f9 ("bpf: BPF for lightweight tunnel infrastructure"),
at that time call_rcu() had to be call_rcu_bh() to match the RCU context.
So this patch may not work well before RCU flavor consolidation has been
completed around v5.0.

Update the comments above the code too, as call_rcu() is now BH friendly.

Cc: Thomas Graf <tgraf@suug.ch>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Dongdong Wang <wangdongdong.6@bytedance.com>
---
 net/core/lwt_bpf.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/lwt_bpf.c b/net/core/lwt_bpf.c
index 7d3438215f32..4f3cb7c15ddf 100644
--- a/net/core/lwt_bpf.c
+++ b/net/core/lwt_bpf.c
@@ -39,12 +39,11 @@ static int run_lwt_bpf(struct sk_buff *skb, struct bpf_lwt_prog *lwt,
 {
 	int ret;
 
-	/* Preempt disable is needed to protect per-cpu redirect_info between
-	 * BPF prog and skb_do_redirect(). The call_rcu in bpf_prog_put() and
-	 * access to maps strictly require a rcu_read_lock() for protection,
-	 * mixing with BH RCU lock doesn't work.
+	/* Preempt disable and BH disable are needed to protect per-cpu
+	 * redirect_info between BPF prog and skb_do_redirect().
 	 */
 	preempt_disable();
+	local_bh_disable();
 	bpf_compute_data_pointers(skb);
 	ret = bpf_prog_run_save_cb(lwt->prog, skb);
 
@@ -78,6 +77,7 @@ static int run_lwt_bpf(struct sk_buff *skb, struct bpf_lwt_prog *lwt,
 		break;
 	}
 
+	local_bh_enable();
 	preempt_enable();
 
 	return ret;
-- 
2.25.1

