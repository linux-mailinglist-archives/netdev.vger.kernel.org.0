Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21BD8B5A86
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 06:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfIREpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 00:45:34 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:39322 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbfIREpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 00:45:34 -0400
Received: by mail-io1-f65.google.com with SMTP id a1so13071921ioc.6;
        Tue, 17 Sep 2019 21:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=hw+uIkbAkTcU496M5+5PQ0tjOXsducObdCZEa4vAXwI=;
        b=H7Eru9mKQiFOv8YW5bX9Hc7w1speszSOSCbW5nkA/5qMKozmhq/wrotx95C9T9ALzm
         4A/J36McipKbA1RO5KLygD2T85uu99p/kmSTvxQswCYBTjfLjVEarhaeL2+X+nDAeEf+
         Ic/tGXG9YcXmn9rkmp6LWrmfTW+qAVZHljv9tM1QOGYY3e65Iti8QkxeykG5FRpRJtTg
         1JF0kt/8E0SAYb41oFLWT5q/gyGySnDgpXlBAXN6iSgevdiusmdUbCROdju65tLmWl1N
         lHV6oZNX+lbOD2SPTDkILXsitttgAUiTOY/Bhh3SbaHl9rK57XKdLO0FiU+yicojM5S2
         7kQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=hw+uIkbAkTcU496M5+5PQ0tjOXsducObdCZEa4vAXwI=;
        b=LKtQeMpZdMHwOORUhFY7Ma/YWLxo9tJ3X8A+Br+5IjXG0kgZYKYBNwRxIhweuczPhT
         KgvtntbuzjxH/G+aQNtnC15dr824W6/bTSDUR5Z4JP53V8D68rW3/YET+zoBy9EN5h5y
         yhwg7GDmGYrCIhD8Fgld6BU/cbzIV5LqTXT0W3gsmr4ANCYS5/bmW7YRUG2Ow3nU3RCS
         q8Vy5xWHmHW7/PO0zP2HDUq2rN+dJnxZIqZEPycOaanfNeMncRqlTBVM1NORzPt37W2C
         dE1PKDoUhPqFSd1mRIVid7XrmFJnFhiMuXqPYka1ABLhSjrnuy7o8c0dFtUZyZzk981X
         s4cg==
X-Gm-Message-State: APjAAAWDCpsFm+qhhujGnyLvgt+mHBLgbSbSJqWAzGAmu+NM16oZGo4d
        Vo5fzOyY9JOolgEZm+VNuVc=
X-Google-Smtp-Source: APXvYqz2zmtV/k98/U3SUcIlqPK7RM1Rk+FijoNcVohXyYD6XnSPiMTJoeB/zbyZGbGDfL9Ibq33og==
X-Received: by 2002:a05:6602:2244:: with SMTP id o4mr1794089ioo.107.1568781933040;
        Tue, 17 Sep 2019 21:45:33 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.googlemail.com with ESMTPSA id m9sm2897247ion.65.2019.09.17.21.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Sep 2019 21:45:32 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, smccaman@umn.edu, kjlu@umn.edu,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/net: release skb on failure
Date:   Tue, 17 Sep 2019 23:45:21 -0500
Message-Id: <20190918044521.14953-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ql_run_loopback_test, ql_lb_send does not release skb when fails. So
it must be released before returning.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 drivers/net/ethernet/qlogic/qlge/qlge_ethtool.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qlge/qlge_ethtool.c b/drivers/net/ethernet/qlogic/qlge/qlge_ethtool.c
index a6886cc5654c..d539b71b2a5c 100644
--- a/drivers/net/ethernet/qlogic/qlge/qlge_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qlge/qlge_ethtool.c
@@ -544,8 +544,10 @@ static int ql_run_loopback_test(struct ql_adapter *qdev)
 		skb_put(skb, size);
 		ql_create_lb_frame(skb, size);
 		rc = ql_lb_send(skb, qdev->ndev);
-		if (rc != NETDEV_TX_OK)
+		if (rc != NETDEV_TX_OK) {
+			dev_kfree_skb_any(skb);
 			return -EPIPE;
+		}
 		atomic_inc(&qdev->lb_count);
 	}
 	/* Give queue time to settle before testing results. */
-- 
2.17.1

