Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 359D63CCAB6
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 23:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232562AbhGRVDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 17:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbhGRVDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Jul 2021 17:03:15 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1A1C061762;
        Sun, 18 Jul 2021 14:00:16 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id x17so20858688edd.12;
        Sun, 18 Jul 2021 14:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DtE6kMD05VS1enzrY9m04X9GCgbs5zImzlvGDa+/w4c=;
        b=iyMc+c2B2jllNfJByIWw05AlIH6sSlSGsxP1tPn3XMCEhUmKZbuqsGhaJ1BL+9VwGB
         2gKqUU+CtHyzrrHw3q2idPA0tkOfPjc3XpSAC0Mokm4zU0LC19Bty3LjzPYr7UnnEVyG
         sws174afjOUn8q6cWeaAvBdpwCz0qlZ44wZSgr4dgSJ30hJ4A27ierrVmPVLUpJI5naK
         Dlifsx8Ddg5+JCdnHT3/2PMGxgH3k77PCWSyhp1jsNvhA2FZMrDbq+gyyYNlppSYSjz0
         ltz/EWV0Mn4xKNgBy2jiRzxWVZTT3dLM15FS+L+9bGdv8GXFzFMfjfb8eWAJoI3PtYcL
         hnCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DtE6kMD05VS1enzrY9m04X9GCgbs5zImzlvGDa+/w4c=;
        b=DKyLlx848sEtmI6dMOl4ewGs5dLe5P6oTGHuSDBGlw1lL4GVtVh+mcJy1o2Uk/Q6D+
         5noTWqVPwCh1e+lD2spu+ZnjvGpt7Ye0QG5XVa+BLL8dy6WH/gqiOdon0pGbccz7wsVg
         RfD0RzkrhdPS82mTIOCSzLuyW8OtV4WJ4QS76PdUIKZ9IgirMYRHVYPzKz6qSaXg1luI
         THYFOW8hhfORltFEUbq6EKbtHu5BY8iHBlaqtLOKFMMgO2oUf46ibgnrotc2CwgppIoF
         +ga/+D0uARvSgLzLkciTSlmozC2SGh0oWF1wc421RD1Lv75AQWZ5kXzvsa9XQImE8WgZ
         B4sA==
X-Gm-Message-State: AOAM531+RlsSTzepUwMkWt77LegHG1R/SfIoozwNmNNqtzXxmSXnYeqR
        Prgzss92qImDXjOrDQwkDk8=
X-Google-Smtp-Source: ABdhPJw1ZFZdIld4DUgLFlaLlxpo9SDzkVQfPdRxofoyuM9AqV2dZ4K3eMm+rJwKPDbXOlzAHH+q7g==
X-Received: by 2002:a05:6402:358c:: with SMTP id y12mr29971144edc.329.1626642015242;
        Sun, 18 Jul 2021 14:00:15 -0700 (PDT)
Received: from localhost.localdomain ([176.30.96.12])
        by smtp.gmail.com with ESMTPSA id i6sm5116951ejr.68.2021.07.18.14.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Jul 2021 14:00:14 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, kaber@trash.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+13ad608e190b5f8ad8a8@syzkaller.appspotmail.com
Subject: [PATCH] net: 802: fix memory leak in garp_uninit_applicant
Date:   Mon, 19 Jul 2021 00:00:06 +0300
Message-Id: <20210718210006.26212-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported memory leak in garp_uninit_applicant(). The problem was
in missing clean up function in garp_uninit_applicant().

The reproducer provided by syzbot doing following things in order:

	1. garp_request_join()
 	     garp_attr_event(app, attr, GARP_EVENT_REQ_JOIN);
		/* attr->state == GARP_APPLICANT_VP */

	2. garp_request_leave()
	     garp_attr_event(app, attr, GARP_EVENT_REQ_LEAVE);
		/* attr->state == GARP_APPLICANT_VO */

	3. garp_uninit_applicant()
	     garp_gid_event(app, GARP_EVENT_TRANSMIT_PDU);
  		/* attr is not freed */

Why attr won't be freed? Let's refer to garp_applicant_state_table:

[GARP_APPLICANT_VO] = {
	[GARP_EVENT_TRANSMIT_PDU]	= { .state = GARP_APPLICANT_INVALID },
	[GARP_EVENT_R_JOIN_IN]		= { .state = GARP_APPLICANT_AO },
	[GARP_EVENT_R_JOIN_EMPTY]	= { .state = GARP_APPLICANT_VO },
	[GARP_EVENT_R_EMPTY]		= { .state = GARP_APPLICANT_VO },
	[GARP_EVENT_R_LEAVE_IN]		= { .state = GARP_APPLICANT_VO },
	[GARP_EVENT_R_LEAVE_EMPTY]	= { .state = GARP_APPLICANT_VO },
	[GARP_EVENT_REQ_JOIN]		= { .state = GARP_APPLICANT_VP },
	[GARP_EVENT_REQ_LEAVE]		= { .state = GARP_APPLICANT_INVALID },

REQ_LEAVE event has INVALID state as standard says and
garp_attr_event() just returns in case of invalid state.
Since garp_uninit_applicant() is destroy function for applicant we need
to free remaining attrs to avoid memory leaks.

Fixes: eca9ebac651f ("net: Add GARP applicant-only participant")
Reported-and-tested-by: syzbot+13ad608e190b5f8ad8a8@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 net/802/garp.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/net/802/garp.c b/net/802/garp.c
index 400bd857e5f5..4a1ef95ae428 100644
--- a/net/802/garp.c
+++ b/net/802/garp.c
@@ -553,6 +553,16 @@ static void garp_release_port(struct net_device *dev)
 	kfree_rcu(port, rcu);
 }
 
+static void garp_destroy_remaining_attrs(struct garp_applicant *app)
+{
+	while (!RB_EMPTY_ROOT(&app->gid)) {
+		struct garp_attr *attr =
+			rb_entry(rb_first(&app->gid),
+				 struct garp_attr, node);
+		garp_attr_destroy(app, attr);
+	}
+}
+
 int garp_init_applicant(struct net_device *dev, struct garp_application *appl)
 {
 	struct garp_applicant *app;
@@ -610,6 +620,13 @@ void garp_uninit_applicant(struct net_device *dev, struct garp_application *appl
 	spin_lock_bh(&app->lock);
 	garp_gid_event(app, GARP_EVENT_TRANSMIT_PDU);
 	garp_pdu_queue(app);
+
+	/* We need to free remaining attrs since this scenario is possible:
+	 *	garp_request_join()
+	 *	garp_request_leave()
+	 *	garp_uninit_applicant()
+	 */
+	garp_destroy_remaining_attrs(app);
 	spin_unlock_bh(&app->lock);
 
 	garp_queue_xmit(app);
-- 
2.32.0

