Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51B91617CE
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 00:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbfGGWcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 18:32:31 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:46133 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727820AbfGGWcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 18:32:31 -0400
Received: by mail-qt1-f193.google.com with SMTP id h21so14055985qtn.13
        for <netdev@vger.kernel.org>; Sun, 07 Jul 2019 15:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=+V6wlvQVGFrqENZccXmvvMg7fnrq9npJuDnFhROskBQ=;
        b=Db2JghIgVwGQKfE70hTws0FZnMwhrsBuc9PztShElSaDQgScHLOk+TK5d7Mo6pMNe8
         Q1HQTohoJI25jsVtaXBn8ZewDfVb/kW+71qklPobuc9SNeFCJylmgvqaXRt92VO3aOrh
         xTTOeZH9S9obPYEp+4j4bbuVSkc55ehXxuv8iofxqsDDK3VSCDVTvPI7aP25d6kzXTr0
         QaTJdNaKDEaCQx5y2HBpRmkf22B5/4QA6MAkoPTd3UAx0SYgHb3S/X5GsNJTWieCveV+
         604tafrSz5jtggTZQuUKh3hy7y+Z1pFOXE+npLYalfybEZ0eHpJNquA3x6c5wJZrwiOQ
         6VAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+V6wlvQVGFrqENZccXmvvMg7fnrq9npJuDnFhROskBQ=;
        b=AKPLGDS3Igsh4BpH835HODHEF6cW5HwmRvvwbhMWvMM2C+9bxFcRvIYXiWm3iLlc2k
         yfBJX19I5ksXi8o1KizxY/a4bCmQraPEDvlGrWncwxJlLL0OsvUid6W/Z6FE9WdGxgC8
         l8I91oGzwIqVrRlbdqVg8EylCH+Qygs3rdxFJEMN2t+2zCrK32PJHGLU0KxiHDFqvKst
         1nMF+IeVIaSSMKDv++3YVkfULX7OarV26bkrjjvma16v9GCze6+5sVnQ01KEl8kPnREE
         AHR/xY4mDiMiqFxB3TDkQSm6IoPa+ejCF5GP2VJPh0bwUMMuiTyQ484dhqZfMMZZdR1s
         15XA==
X-Gm-Message-State: APjAAAUvdBACqA6O/PgAd6cxn7G9HgUkFqJndHM5zU5klHzncXIqtTqM
        MZ8Ch3Iptw0CRt+oAuBs2FdsYJ7W
X-Google-Smtp-Source: APXvYqyYDArsgZ9+HbmmkNNKyW0i/ZqgADY9RDRuzjKE/xn1Sazs3LOL8k3mU5u/CjTxLiixZAMZ0A==
X-Received: by 2002:ac8:4442:: with SMTP id m2mr11954226qtn.107.1562538750292;
        Sun, 07 Jul 2019 15:32:30 -0700 (PDT)
Received: from localhost.localdomain (c-75-69-96-209.hsd1.nh.comcast.net. [75.69.96.209])
        by smtp.gmail.com with ESMTPSA id z19sm6011048qtu.43.2019.07.07.15.32.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 07 Jul 2019 15:32:29 -0700 (PDT)
From:   "kwangdo.yi" <kwangdo.yi@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "kwangdo.yi" <kwangdo.yi@gmail.com>
Subject: [PATCH] phy: added a PHY_BUSY state into phy_state_machine
Date:   Sun,  7 Jul 2019 18:32:12 -0400
Message-Id: <1562538732-20700-1-git-send-email-kwangdo.yi@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When mdio driver polling the phy state in the phy_state_machine,
sometimes it results in -ETIMEDOUT and link is down. But the phy
is still alive and just didn't meet the polling deadline. 
Closing the phy link in this case seems too radical. Failing to 
meet the deadline happens very rarely. When stress test runs for 
tens of hours with multiple target boards (Xilinx Zynq7000 with
marvell 88E1512 PHY, Xilinx custom emac IP), it happens. This 
patch gives another chance to the phy_state_machine when polling 
timeout happens. Only two consecutive failing the deadline is 
treated as the real phy halt and close the connection.


Signed-off-by: kwangdo.yi <kwangdo.yi@gmail.com>
---
 drivers/net/phy/phy.c | 6 ++++++
 include/linux/phy.h   | 1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index e888542..9e8138b 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -919,7 +919,13 @@ void phy_state_machine(struct work_struct *work)
 		break;
 	case PHY_NOLINK:
 	case PHY_RUNNING:
+	case PHY_BUSY:
 		err = phy_check_link_status(phydev);
+		if (err == -ETIMEDOUT && old_state == PHY_RUNNING) {
+			phy->state = PHY_BUSY;
+			err = 0;
+
+		}
 		break;
 	case PHY_FORCING:
 		err = genphy_update_link(phydev);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 6424586..4a49401 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -313,6 +313,7 @@ enum phy_state {
 	PHY_RUNNING,
 	PHY_NOLINK,
 	PHY_FORCING,
+	PHY_BUSY,
 };
 
 /**
-- 
2.7.4

