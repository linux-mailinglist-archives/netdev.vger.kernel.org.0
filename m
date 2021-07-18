Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28A8C3CCAB8
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 23:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232724AbhGRVEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 17:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbhGRVEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Jul 2021 17:04:11 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E723C061762;
        Sun, 18 Jul 2021 14:01:12 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id w14so20872677edc.8;
        Sun, 18 Jul 2021 14:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wkVpMiI/1dyHY4pesGQ09SEuq36Bw6ApFoQ9agB3/Rs=;
        b=ll9QRUPfovKVcEoesAgjgOil/BYS4M+JmcoKCWUhoYpDtV33nYNXPuBVeQUcRhghvt
         q4tDTYwLHpQ2CUQhUNmH4gS7ss2PnNPMLcRdvTElq522RvlY9ccTgwh2l8WKCEvHvCYQ
         2N/ZSWFADTcM0bpuV8FI43bfcx6bbodmfphyS8ZWrh3zK/+dSXvyMU8gO9uJU0U+wUut
         dxUTOxfIq1Zw/OWTlffnmRdabNNFZPejiUFa4shkg1/kA8l7l24S/0JaD0J5xtIkL0tb
         YhKhI7tJf1MqXeS65SVJXlXi5dU5tpN73TPLych6g0LeKoX+mcRWKQOIRK3I2JmsnqPD
         NBWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wkVpMiI/1dyHY4pesGQ09SEuq36Bw6ApFoQ9agB3/Rs=;
        b=tUzZX6r0jPFoaN4RhgTRZIqUfawjbNddgL4vhq+JkVCF616R6N6H4kTHagCWMAYSbH
         hS/LCsrWNFeQVjEh9QGvcLA2s1HHtA14slfRTrB7pJEcJCTxRg02D86J0YlZ6Dk6S3TI
         nkKdX9B9QxvLQKHFI4qQNGIBLeKKMLaHocUJEhjli+nsK0cBQMMaVs+PdjbpJOVWO/2w
         Rv3zF38+EaTaH+9Wnvx4ar2Yw03wI9dx9YxhtKJrKx4L+kBQ15CHNxWVwjzNfWgOVOv5
         hKZwdcTct8p06F8dqPPFRDVvtSvJm2Mf0Q2mNX3J2xq/ygNmaxx4Ii5YU5CofdRgkuop
         Ofdw==
X-Gm-Message-State: AOAM5310grfKm7KmAQfFVfh1NhIa+0ABvAPBPebv0n/ifHH+GQFmdrIS
        Wty7qbmMl5S5jGbnbM5GVyw=
X-Google-Smtp-Source: ABdhPJyH8VIts6bNGMlGzRD2vwvN1gTii7t146Vo+1gbteyJCZYUN9uWSjc25YWsb6plEEjMKicJaQ==
X-Received: by 2002:a50:a456:: with SMTP id v22mr24604309edb.333.1626642070846;
        Sun, 18 Jul 2021 14:01:10 -0700 (PDT)
Received: from localhost.localdomain ([176.30.96.12])
        by smtp.gmail.com with ESMTPSA id jw8sm5112825ejc.60.2021.07.18.14.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Jul 2021 14:01:10 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, kaber@trash.net,
        david.ward@ll.mit.edu
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+5cfab121b54dff775399@syzkaller.appspotmail.com
Subject: [PATCH] net: 802: fix memory leak in mrp_uninit_applicant
Date:   Mon, 19 Jul 2021 00:01:04 +0300
Message-Id: <20210718210104.30285-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported memory leak in mrp_uninit_applicant(). The problem was
in missing clean up function in mrp_uninit_applicant().

The reproducer provided by syzbot doing following things in order:

	1. mrp_request_join()
	     mrp_attr_event(app, attr, MRP_EVENT_JOIN);
		/* attr->state == MRP_APPLICANT_VP */

	2. mrp_request_leave()
	     mrp_attr_event(app, attr, MRP_EVENT_LV);
		/* attr->state == MRP_APPLICANT_VO */

	3. mrp_uninit_applicant()
  	     mrp_mad_event(app, MRP_EVENT_TX);
		/* attr is not freed */

Why attr won't be freed? Since last event == MRP_EVENT_TX let's refer
to mrp_tx_action_table:

static const u8
mrp_tx_action_table[MRP_APPLICANT_MAX + 1] = {
	[MRP_APPLICANT_VO] = MRP_TX_ACTION_S_IN_OPTIONAL,
	[MRP_APPLICANT_VP] = MRP_TX_ACTION_S_JOIN_IN,
	[MRP_APPLICANT_VN] = MRP_TX_ACTION_S_NEW,
	[MRP_APPLICANT_AN] = MRP_TX_ACTION_S_NEW,
	[MRP_APPLICANT_AA] = MRP_TX_ACTION_S_JOIN_IN,
	[MRP_APPLICANT_QA] = MRP_TX_ACTION_S_JOIN_IN_OPTIONAL,
	[MRP_APPLICANT_LA] = MRP_TX_ACTION_S_LV,
	[MRP_APPLICANT_AO] = MRP_TX_ACTION_S_IN_OPTIONAL,
	[MRP_APPLICANT_QO] = MRP_TX_ACTION_S_IN_OPTIONAL,
	[MRP_APPLICANT_AP] = MRP_TX_ACTION_S_JOIN_IN,
	[MRP_APPLICANT_QP] = MRP_TX_ACTION_S_IN_OPTIONAL,
};

[MRP_APPLICANT_VO] member has MRP_TX_ACTION_S_IN_OPTIONAL action and
mrp_attr_event() just returns in case of this action.
Since mrp_uninit_applicant() is destroy function for applicant we need
to free remaining attrs to avoid memory leaks.

Reported-and-tested-by: syzbot+5cfab121b54dff775399@syzkaller.appspotmail.com
Fixes: febf018d2234 ("net/802: Implement Multiple Registration Protocol (MRP)")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 net/802/mrp.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/net/802/mrp.c b/net/802/mrp.c
index bea6e43d45a0..bf319f3f2094 100644
--- a/net/802/mrp.c
+++ b/net/802/mrp.c
@@ -834,6 +834,16 @@ static void mrp_release_port(struct net_device *dev)
 	kfree_rcu(port, rcu);
 }
 
+static void mrp_destroy_remaining_attrs(struct mrp_applicant *app)
+{
+	while (!RB_EMPTY_ROOT(&app->mad)) {
+		struct mrp_attr *attr =
+			rb_entry(rb_first(&app->mad),
+				 struct mrp_attr, node);
+		mrp_attr_destroy(app, attr);
+	}
+}
+
 int mrp_init_applicant(struct net_device *dev, struct mrp_application *appl)
 {
 	struct mrp_applicant *app;
@@ -896,6 +906,13 @@ void mrp_uninit_applicant(struct net_device *dev, struct mrp_application *appl)
 	spin_lock_bh(&app->lock);
 	mrp_mad_event(app, MRP_EVENT_TX);
 	mrp_pdu_queue(app);
+
+	/* We need to free remaining attrs since this scenario is possible:
+	 *	mrp_request_join()
+	 *	mrp_request_leave()
+	 *	mrp_uninit_applicant()
+	 */
+	mrp_destroy_remaining_attrs(app);
 	spin_unlock_bh(&app->lock);
 
 	mrp_queue_xmit(app);
-- 
2.32.0

