Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 961472FF4A4
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 20:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbhAUTfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 14:35:48 -0500
Received: from mail-m975.mail.163.com ([123.126.97.5]:37736 "EHLO
        mail-m975.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727211AbhAUTdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 14:33:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=Td2FrwxlzULpmp25Sf
        Fj2Pt01rYJ+34xjhJsW3465cI=; b=Y9zA2YuMp1ruzZD9m7CVbQc5FfqsoHe4bu
        yty2kHs3SaPh4MHX7aj9Hgiqn9yZqS8rTU/7GZUWGtT/pe3jPgxmHs9/Ssj55KC6
        KLUnQq6bVH6aBpvrkIsocnUxC2TZRLNZPe1tzq1qE0CvZaNqcMP5GloKhFzKMeZF
        52Mij8nkg=
Received: from localhost.localdomain (unknown [111.201.134.89])
        by smtp5 (Coremail) with SMTP id HdxpCgBHFfx2nQlgWwyuAw--.1252S4;
        Thu, 21 Jan 2021 23:27:54 +0800 (CST)
From:   Pan Bian <bianpan2016@163.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Qingyu Li <ieatmuttonchuan@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pan Bian <bianpan2016@163.com>
Subject: [PATCH] NFC: fix resource leak when target index is invalid
Date:   Thu, 21 Jan 2021 07:27:48 -0800
Message-Id: <20210121152748.98409-1-bianpan2016@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: HdxpCgBHFfx2nQlgWwyuAw--.1252S4
X-Coremail-Antispam: 1Uf129KBjvdXoW7JFy7KF1UXryDAFWfAF1UJrb_yoW3tFXE9F
        4Ivws7WF45WwsxCayUur18tFyxtw1UXr1xXFWfJFZYv34rWF1UCrs8WF1fAr129ryxCFy7
        CF9aqF18WwnxtjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUUwSdPUUUUU==
X-Originating-IP: [111.201.134.89]
X-CM-SenderInfo: held01tdqsiiqw6rljoofrz/xtbBZxohclet1hciOgAAsN
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Goto to the label put_dev instead of the label error to fix potential
resource leak on path that the target index is invalid.

Fixes: c4fbb6515a4d ("NFC: The core part should generate the target index")
Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 net/nfc/rawsock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/nfc/rawsock.c b/net/nfc/rawsock.c
index 955c195ae14b..9c7eb8455ba8 100644
--- a/net/nfc/rawsock.c
+++ b/net/nfc/rawsock.c
@@ -105,7 +105,7 @@ static int rawsock_connect(struct socket *sock, struct sockaddr *_addr,
 	if (addr->target_idx > dev->target_next_idx - 1 ||
 	    addr->target_idx < dev->target_next_idx - dev->n_targets) {
 		rc = -EINVAL;
-		goto error;
+		goto put_dev;
 	}
 
 	rc = nfc_activate_target(dev, addr->target_idx, addr->nfc_protocol);
-- 
2.17.1

