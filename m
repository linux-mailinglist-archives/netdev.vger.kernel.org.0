Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEDF2803CA
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 18:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732507AbgJAQXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 12:23:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732230AbgJAQW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 12:22:59 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259D9C0613E3
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 09:22:59 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id p21so1955134pju.0
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 09:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0ZoJl2SUn268zHQPS8miTuBp3WaeXYkq3HEEnsdCi7A=;
        b=bvFeVn1SHatRqgwpwQf92ndWCIGVyKvUjwf/jkykGz/zepencu3gU5ngaJhYjSAwuK
         eGqW5j+q2vMzd9hy5or5HRsnD8Q8oVh3Al9ZHFpY+ZamnpaTKIDfGxEpXfQrBvhk2nl2
         RiQ5nH4sWINmJ9+gHhmIoSfLCMUuuFp297Ho/WxZKImhuo06w8RLGNhMJ7F39vo2JLoz
         62/6B261pK5na4lgkEcjA9+GKGRo4/0F4pG/CiuJ5wtesR3cvTR4Ec8NVj10mm64Kdk6
         vEJr7KssM2mW6iPKLDMbL0xDvvycyblOeLoe5XnWordzKYhq+QfrCEG4sbynjVwSD9/2
         l8Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0ZoJl2SUn268zHQPS8miTuBp3WaeXYkq3HEEnsdCi7A=;
        b=SKLesFArsAgMg+cy7owJF+PQEdfpJHqwECcgfStAB+BWkJzQ5nQhGLgGqBqH8wezxN
         GGu1pN+IYwd06BdVrbw7Ed8JCEEKr9Y74S8g6N0uIiO4Cl/CuAZBvdK1JSld5h5rlEiD
         KLrvrdYgurLv12a3JuLOaf0CPB/QFQMT+QuWwW02fvRX5TU2QtYiPynRR0PI+Sxmi9J9
         SZTw6r8xolQdpa5GYr2t9mC/upqSEvLG8GeUXvpUs7Atc3l6u3iQ1twG+PT+L9GOzY2I
         Ye1HbMD1+7eJjhEk/yHP7d0TG1UzpW/I0ohfcLSJuXfAU/ncc00KbXT4jMRrUU05ecFT
         v2nA==
X-Gm-Message-State: AOAM530Enisms+6RDTL6cFPsQa+j5KK6scVkSpkmd3y8txbJF7kRQrSM
        j3a8T886jLk4F9SCdEOVjhjRxJKDH+tFag==
X-Google-Smtp-Source: ABdhPJyh3K703np8pCVG0ca510r9+w4CABZukn3DKq4ggpeX+/ZGFWqU6TJ8L2tFkrLzwyLC7135qw==
X-Received: by 2002:a17:90a:aa18:: with SMTP id k24mr667540pjq.231.1601569378262;
        Thu, 01 Oct 2020 09:22:58 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id k2sm6380066pfi.169.2020.10.01.09.22.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Oct 2020 09:22:57 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 3/8] ionic: clear linkcheck bit on alloc fail
Date:   Thu,  1 Oct 2020 09:22:41 -0700
Message-Id: <20201001162246.18508-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201001162246.18508-1-snelson@pensando.io>
References: <20201001162246.18508-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clear our link check requested flag on an allocation error.
We end up dropping this link check request, but that should
be fine as our watchdog will come back a few seconds later
and request it again.

Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 53ac0e4402e7..5906145e4585 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -164,8 +164,10 @@ void ionic_link_status_check_request(struct ionic_lif *lif, bool can_sleep)
 
 	if (!can_sleep) {
 		work = kzalloc(sizeof(*work), GFP_ATOMIC);
-		if (!work)
+		if (!work) {
+			clear_bit(IONIC_LIF_F_LINK_CHECK_REQUESTED, lif->state);
 			return;
+		}
 
 		work->type = IONIC_DW_TYPE_LINK_STATUS;
 		ionic_lif_deferred_enqueue(&lif->deferred, work);
-- 
2.17.1

