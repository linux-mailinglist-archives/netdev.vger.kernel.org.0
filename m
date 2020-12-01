Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B182CACA8
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 20:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730402AbgLATph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 14:45:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgLATpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 14:45:36 -0500
Received: from mail-oo1-xc41.google.com (mail-oo1-xc41.google.com [IPv6:2607:f8b0:4864:20::c41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3C2C0613D4;
        Tue,  1 Dec 2020 11:44:56 -0800 (PST)
Received: by mail-oo1-xc41.google.com with SMTP id i13so685480oou.11;
        Tue, 01 Dec 2020 11:44:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yGDNcbcqlchKkDNxGYtB/yjqUUjJw+c/0TidcKqaoHA=;
        b=ukOwb62vJKm3vAi/Mp32y0rN6l4uSjF7tr6I16g5lkDRJr9v+fG5tCfiWiEXOsTtYy
         x/hqdkC6XLeyxGGXM0+v1Xz2dsUcoCg9rGJHT9oIn8fpkXkR9Y5g8wTSgZ9wcZib1ISe
         h0WUO3AlF6xabIYJSKb7ItTRjhS6dkanlBMmMo0tmTyW/RMWDE5Ic08iCNZEXnE8Tv/C
         z821k+gfnuK2vIe62hB5vHgtmmQ8BqMRJ5zGk0syV1uQ3p4OuqucQkRuxhV/5rOsaC/S
         hZzKvdeNVdDCMF3m3VXKE7SNgdpld+RV1MSwAihOe6oGnQon4byyjyRlEkK5lSsRlSUN
         Qz1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yGDNcbcqlchKkDNxGYtB/yjqUUjJw+c/0TidcKqaoHA=;
        b=GJbxzgKKemdBsCRKYJ4Fh7LijQyKptI81E++KJSm14dhrIUqoQk/3KWfA/8jdUZIJR
         c20vJSG7XXFkpQTXBsGM/5iDPmQM8eA9HQsgqjcXQiQ3SQ9b6GyNKf+VzApLdaLOXoFm
         9NjoF6L+gvLZenPgHVPvFzqdZpv1UOaOpkaUuE0zRd2xbxH8LMS0WcvS3vYoO1oKZnYT
         kssHZGgeajFOIJeyy3EsaFhRIqxWYL+c/ZPWNcVzeAMCw0vstCwPQ9y1z9rNf39tHhMA
         W2HefDtsTvN/xM+M7W/WF2hY+rbEc5FpTfpqZKinXtuFgjUY+dsMtqtWwo2X+bYgBWUT
         oSzQ==
X-Gm-Message-State: AOAM53079Q1A+Tx3TM9FZZ+K0vaUw1gyWWDmNhiuYzx4m+tjUCErMixv
        509jXvt9zA528gG+5mrhMvGV1ibLte2hbA==
X-Google-Smtp-Source: ABdhPJzqj5MJhUuLB/6QDTCqnLSXynJQ0U+v2B7OEW3QbsqB0HOG76CmbLQ4XmWLyAbAaq35Sc0m0Q==
X-Received: by 2002:a4a:b144:: with SMTP id e4mr3063095ooo.3.1606851895466;
        Tue, 01 Dec 2020 11:44:55 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:2482:49a9:7a40:f76b])
        by smtp.gmail.com with ESMTPSA id n3sm120351oif.42.2020.12.01.11.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 11:44:54 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Dongdong Wang <wangdongdong@bytedance.com>,
        Thomas Graf <tgraf@suug.ch>, bpf@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch net] lwt: disable BH too in run_lwt_bpf()
Date:   Tue,  1 Dec 2020 11:44:38 -0800
Message-Id: <20201201194438.37402-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dongdong Wang <wangdongdong@bytedance.com>

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
Cc: bpf@vger.kernel.org
Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Dongdong Wang <wangdongdong@bytedance.com>
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

