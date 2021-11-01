Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E710D44129F
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 05:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbhKAEDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 00:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhKAEDu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 00:03:50 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAC22C061714;
        Sun, 31 Oct 2021 21:01:17 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id o14so1727507pfu.10;
        Sun, 31 Oct 2021 21:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j1zj81YWFTCZDWmrdom1kjokPFz9peyCsLfXqGwKeAM=;
        b=oEXgbZE9MHRoqaP8v3ANr6PRFNf293gF+YOPtvpe51oK0zkfO4HvXRp+/o3kEjQhfw
         QZV+/4H8kYbKEnoRBNn45OFYS9sAdhCClHzuOV3J7YXgAN+Z18pkVgCqCjRVE2v+SPMu
         cdiYvBzs8tdXVpvVbN/UaP/HPIPrY/apU4kGgyX2epjG0BstHdoAxNAM4V4iumXO+AUm
         /JJJhrUVhwSKa62zb/TejxjvYTBFkwi6r7rBWD5bVFAdVpZu3vPaZJzkjX3i/SYg7tPQ
         GR8iOV3KKGoJR9zS20atQ46TCZLj+K9DA+6S+l4Qa85eL10vrhLbKsFPbiKNG9imIlaa
         WYjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j1zj81YWFTCZDWmrdom1kjokPFz9peyCsLfXqGwKeAM=;
        b=AuGC+ocrxoGJ83D1Ow8D+ARo3MBHsTdWdCWNsk3l5mZZwzcawFn9iXjB6fGrXNf5NY
         /LSEMtzZyvypBHTpi1+u/v6LCOHyXLSox1Jd2XYrWyiX/STTUilHaJ9Q8T/QI/8NsUfE
         tmCHmB+Nso1p8y7lXpny9KB/KYz5lfAIC7B6wraXZDFLDtcZP06czc7uMsj6P7y3OKcb
         TQdLc7w7uCDoFJ2mgBRuAYcTcX7uBFaAhL3w5P2KhneXIpbtjld2i0uXx+w0mtVMS1O1
         XwNR82fJnWOfzkz4oZMGcYjGfsWETm7tYXb/KsNXb6aKOHR3Z4zPks2EqKjZx/2k3hrh
         yBRg==
X-Gm-Message-State: AOAM5306DAvS2zGYvceEYgZXdJ47dVjw45QI4XB5Kh28qrQKW7n+Cr6d
        wkfVh+/6NjOkfryCFacgyfk=
X-Google-Smtp-Source: ABdhPJx3viV9qB1TaG/SmbmbPFCaZuGtMQWOEaiqw5HZpi1nO9LoS6YyMIJVdscQCooQtte/iK3Haw==
X-Received: by 2002:a63:e216:: with SMTP id q22mr19590520pgh.3.1635739277100;
        Sun, 31 Oct 2021 21:01:17 -0700 (PDT)
Received: from localhost.localdomain ([94.177.118.117])
        by smtp.gmail.com with ESMTPSA id a20sm13387682pff.57.2021.10.31.21.01.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Oct 2021 21:01:16 -0700 (PDT)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <a@unstable.cc>,
        Sven Eckelmann <sven@narfation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        Antonio Quartulli <antonio@open-mesh.com>,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: batman-adv: fix warning in batadv_v_ogm_free
Date:   Mon,  1 Nov 2021 12:01:02 +0800
Message-Id: <20211101040103.388646-1-mudongliangabcd@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If batadv_v_ogm_init encounters a memory failure, the fields ogm_wq,
ogm_buff_mutex and etc. are not initialized. Then the control flow goes
to batadv_v_ogm_free due to the error handling code. As a result, the
API invocation "cancel_delayed_work_sync" and "mutex_lock" will cause
many issues. The crashing stack trace is as follows:

Call Trace:
 __cancel_work_timer+0x1c9/0x280 kernel/workqueue.c:3170
 batadv_v_ogm_free+0x1d/0x50 net/batman-adv/bat_v_ogm.c:1076
 batadv_mesh_free+0x35/0xa0 net/batman-adv/main.c:244
 batadv_mesh_init+0x22a/0x240 net/batman-adv/main.c:226
 batadv_softif_init_late+0x1ad/0x240 net/batman-adv/soft-interface.c:804
 register_netdevice+0x15d/0x810 net/core/dev.c:10229

Fixes: a8d23cbbf6c9 ("batman-adv: Avoid free/alloc race when handling OGM2 buffer")
Fixes: 0da0035942d4 ("batman-adv: OGMv2 - add basic infrastructure")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
 net/batman-adv/bat_v_ogm.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/batman-adv/bat_v_ogm.c b/net/batman-adv/bat_v_ogm.c
index 1d750f3cb2e4..2f3ecbcec58d 100644
--- a/net/batman-adv/bat_v_ogm.c
+++ b/net/batman-adv/bat_v_ogm.c
@@ -1044,6 +1044,13 @@ int batadv_v_ogm_init(struct batadv_priv *bat_priv)
 	unsigned char *ogm_buff;
 	u32 random_seqno;
 
+	/* randomize initial seqno to avoid collision */
+	get_random_bytes(&random_seqno, sizeof(random_seqno));
+	atomic_set(&bat_priv->bat_v.ogm_seqno, random_seqno);
+	INIT_DELAYED_WORK(&bat_priv->bat_v.ogm_wq, batadv_v_ogm_send);
+
+	mutex_init(&bat_priv->bat_v.ogm_buff_mutex);
+
 	bat_priv->bat_v.ogm_buff_len = BATADV_OGM2_HLEN;
 	ogm_buff = kzalloc(bat_priv->bat_v.ogm_buff_len, GFP_ATOMIC);
 	if (!ogm_buff)
@@ -1057,13 +1064,6 @@ int batadv_v_ogm_init(struct batadv_priv *bat_priv)
 	ogm_packet->flags = BATADV_NO_FLAGS;
 	ogm_packet->throughput = htonl(BATADV_THROUGHPUT_MAX_VALUE);
 
-	/* randomize initial seqno to avoid collision */
-	get_random_bytes(&random_seqno, sizeof(random_seqno));
-	atomic_set(&bat_priv->bat_v.ogm_seqno, random_seqno);
-	INIT_DELAYED_WORK(&bat_priv->bat_v.ogm_wq, batadv_v_ogm_send);
-
-	mutex_init(&bat_priv->bat_v.ogm_buff_mutex);
-
 	return 0;
 }
 
-- 
2.25.1

