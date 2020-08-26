Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9212253862
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 21:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbgHZTkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 15:40:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:49474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727000AbgHZTkM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Aug 2020 15:40:12 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3083D2087C;
        Wed, 26 Aug 2020 19:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598470811;
        bh=PlxJUtSatmHsLwVJNr8Jh69DbIQ2kckl9zogannde9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fYaV107owUgHEUIofyJlLGd0K21YNajkrA/wyGZDFWTmnhyiM/c3USxDSs1xbIGK0
         /b/TgWgwa1zD+d2GpgL71X0WqH4Y7yMstZgDDVwTyi5hBYUQTi9+2Rsf0YD+kGc1Tm
         JjZjo/UQgl31Z/QXC0kWpoPLYnch9GKOoYkxIXHI=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     eric.dumazet@gmail.com, michael.chan@broadcom.com,
        netdev@vger.kernel.org, kernel-team@fb.com,
        Jakub Kicinski <kuba@kernel.org>, Rob Sherwood <rsher@fb.com>
Subject: [PATCH net 2/2] bnxt: don't enable NAPI until rings are ready
Date:   Wed, 26 Aug 2020 12:40:07 -0700
Message-Id: <20200826194007.1962762-3-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200826194007.1962762-1-kuba@kernel.org>
References: <20200826194007.1962762-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Netpoll can try to poll napi as soon as napi_enable() is called.
It crashes trying to access a doorbell which is still NULL:

 BUG: kernel NULL pointer dereference, address: 0000000000000000
 CPU: 59 PID: 6039 Comm: ethtool Kdump: loaded Tainted: G S                5.9.0-rc1-00469-g5fd99b5d9950-dirty #26
 RIP: 0010:bnxt_poll+0x121/0x1c0
 Code: c4 20 44 89 e0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 41 8b 86 a0 01 00 00 41 23 85 18 01 00 00 49 8b 96 a8 01 00 00 0d 00 00 00 24 <89> 02
41 f6 45 77 02 74 cb 49 8b ae d8 01 00 00 31 c0 c7 44 24 1a
  netpoll_poll_dev+0xbd/0x1a0
  __netpoll_send_skb+0x1b2/0x210
  netpoll_send_udp+0x2c9/0x406
  write_ext_msg+0x1d7/0x1f0
  console_unlock+0x23c/0x520
  vprintk_emit+0xe0/0x1d0
  printk+0x58/0x6f
  x86_vector_activate.cold+0xf/0x46
  __irq_domain_activate_irq+0x50/0x80
  __irq_domain_activate_irq+0x32/0x80
  __irq_domain_activate_irq+0x32/0x80
  irq_domain_activate_irq+0x25/0x40
  __setup_irq+0x2d2/0x700
  request_threaded_irq+0xfb/0x160
  __bnxt_open_nic+0x3b1/0x750
  bnxt_open_nic+0x19/0x30
  ethtool_set_channels+0x1ac/0x220
  dev_ethtool+0x11ba/0x2240
  dev_ioctl+0x1cf/0x390
  sock_do_ioctl+0x95/0x130

Reported-by: Rob Sherwood <rsher@fb.com>
Fixes: c0c050c58d84 ("bnxt_en: New Broadcom ethernet driver.")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 316227136f5b..57d0e195cddf 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9504,15 +9504,15 @@ static int __bnxt_open_nic(struct bnxt *bp, bool irq_re_init, bool link_re_init)
 		}
 	}
 
-	bnxt_enable_napi(bp);
-	bnxt_debug_dev_init(bp);
-
 	rc = bnxt_init_nic(bp, irq_re_init);
 	if (rc) {
 		netdev_err(bp->dev, "bnxt_init_nic err: %x\n", rc);
-		goto open_err;
+		goto open_err_irq;
 	}
 
+	bnxt_enable_napi(bp);
+	bnxt_debug_dev_init(bp);
+
 	if (link_re_init) {
 		mutex_lock(&bp->link_lock);
 		rc = bnxt_update_phy_setting(bp);
@@ -9543,10 +9543,6 @@ static int __bnxt_open_nic(struct bnxt *bp, bool irq_re_init, bool link_re_init)
 		bnxt_vf_reps_open(bp);
 	return 0;
 
-open_err:
-	bnxt_debug_dev_exit(bp);
-	bnxt_disable_napi(bp);
-
 open_err_irq:
 	bnxt_del_napi(bp);
 
-- 
2.26.2

