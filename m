Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9E723B551
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 09:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725917AbgHDHCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 03:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbgHDHCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 03:02:39 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C2AC06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 00:02:39 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id j19so21580220pgm.11
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 00:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=KwzYEz8QDEZpIN6Vw8GeaQReHKRrUa12ee8r7FthIiA=;
        b=IcudVeWrL7dQCqVgD8n2ApWnl67uaLGGGI3LtrWdjEiCi2YPbYoHP9Gn1ASDHMjoyn
         Cc2b60mFkOyN5k8Bt7L9W2Em2/qYvIWEYF0GYmQtGa0h99XGhs2DWEvsXzhcI0a2I3lQ
         GC0+g9wPiiiIPIqQ/9BH76uOWIdWurjQs1DWDon9+5FOJiI+4dDcxG7hiPmO+q3AwTb1
         bJtUahWWAPhvRzvEsNKLbCyl50YTELWsrrZHP2As6zwqMXfzDzuyGXYKpZjc8yWaAfs+
         ufPsyYok/nwmt51jesuPWTdxaTLu3HhK9KBXLohAsTDp3+IC/n1mFrPLsdLQxlUdHenN
         pOdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KwzYEz8QDEZpIN6Vw8GeaQReHKRrUa12ee8r7FthIiA=;
        b=d8smQXZEnUrRJFw8ZUsKX53IctnEMtClLFvXOkwMhaiJ3x4Y3Y9np4KWnMfVCJ+ATa
         lbWhtctXSzwoGoWahC5KCTDSYTr91uEVONi3srZITUoiMwwG5SchDpwrgtDsBeu3DDpa
         ngXuSo1pKzopl/fAIlpFV3jTkhzBoFnt0a+drfuwSDg4v8/LlvzUd2P3asSZgzt73ZgW
         rKkpkdZBy17Vtrs3KQfQveuHDjlc8Csie5+AXIdyBKimmcySxeMqIkycIiOwUdQfwzSN
         CVWSc8GzG5k0yyAQd/iVx6zXUJvC5BcjsGXKoeukE0UdhdxC40fySQiR7hW+XmRhzvLd
         SLhg==
X-Gm-Message-State: AOAM530NR5HWP5NytL4FFi9BkYAvIpXf4O2M/02EahrFN/GKirh6y/id
        Q91aEUZFtqPdMGLvestjnSCI1Jdxbe4=
X-Google-Smtp-Source: ABdhPJySYRULaAKMmcocmEbFK3D9UAkViitwF1QBq/YnSfBp/c32JDqNlLSLRzsMD9tmJVHxwSMRrA==
X-Received: by 2002:a05:6a00:84d:: with SMTP id q13mr19730886pfk.167.1596524558367;
        Tue, 04 Aug 2020 00:02:38 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 144sm11396484pfu.114.2020.08.04.00.02.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Aug 2020 00:02:37 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, dnelson@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        Sunil Goutham <sgoutham@cavium.com>,
        Robert Richter <rric@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCHv2 net] net: thunderx: use spin_lock_bh in nicvf_set_rx_mode_task()
Date:   Tue,  4 Aug 2020 15:02:30 +0800
Message-Id: <9809b6b99bf5ba2dc8d1440c7d4fc93d04a7504a.1596524550.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A dead lock was triggered on thunderx driver:

        CPU0                    CPU1
        ----                    ----
   [01] lock(&(&nic->rx_mode_wq_lock)->rlock);
                           [11] lock(&(&mc->mca_lock)->rlock);
                           [12] lock(&(&nic->rx_mode_wq_lock)->rlock);
   [02] <Interrupt> lock(&(&mc->mca_lock)->rlock);

The path for each is:

  [01] worker_thread() -> process_one_work() -> nicvf_set_rx_mode_task()
  [02] mld_ifc_timer_expire()
  [11] ipv6_add_dev() -> ipv6_dev_mc_inc() -> igmp6_group_added() ->
  [12] dev_mc_add() -> __dev_set_rx_mode() -> nicvf_set_rx_mode()

To fix it, it needs to disable bh on [1], so that the timer on [2]
wouldn't be triggered until rx_mode_wq_lock is released. So change
to use spin_lock_bh() instead of spin_lock().

Thanks to Paolo for helping with this.

v1->v2:
  - post to netdev.

Reported-by: Rafael P. <rparrazo@redhat.com>
Tested-by: Dean Nelson <dnelson@redhat.com>
Fixes: 469998c861fa ("net: thunderx: prevent concurrent data re-writing by nicvf_set_rx_mode")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 drivers/net/ethernet/cavium/thunder/nicvf_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index 2ba0ce1..a82c708 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -2042,11 +2042,11 @@ static void nicvf_set_rx_mode_task(struct work_struct *work_arg)
 	/* Save message data locally to prevent them from
 	 * being overwritten by next ndo_set_rx_mode call().
 	 */
-	spin_lock(&nic->rx_mode_wq_lock);
+	spin_lock_bh(&nic->rx_mode_wq_lock);
 	mode = vf_work->mode;
 	mc = vf_work->mc;
 	vf_work->mc = NULL;
-	spin_unlock(&nic->rx_mode_wq_lock);
+	spin_unlock_bh(&nic->rx_mode_wq_lock);
 
 	__nicvf_set_rx_mode_task(mode, mc, nic);
 }
-- 
2.1.0

