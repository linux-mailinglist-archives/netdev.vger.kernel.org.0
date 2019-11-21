Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF00105B0A
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 21:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbfKUUUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 15:20:54 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:44138 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfKUUUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 15:20:53 -0500
Received: by mail-il1-f195.google.com with SMTP id i6so4564177ilr.11;
        Thu, 21 Nov 2019 12:20:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=zDHfhXmednfbNTF5QPM+tR81pqc4KD04Wxyacx8vtsY=;
        b=P1akLGtN5Ybuz4E5LOg5zzo4K+eXfNzKC4ily9YZxU1exnY7X3A4LK3dSh7br3kC1A
         SZpgGTQv39uzWVk1gTNH6859YLHmCN1lINLHGB7dZ75Ai093OxEm4+tNYQKAmki3VIlx
         w1mNSOET2JL6FCh/Zv5FNf1tBRGVS1vuFtbVVCR9yPOrlcF6lPKmoai1JgRhfeJ5TIvq
         5ULHXWt9E5rINuRl9odb1x8EKuAmJvfL7VchxRev1LuF+xrWVwAnvSthsok6jy/fqyPu
         WDifPaiPDnGNMae9UK2k1PuRCX/TN/RRF8JwPN1IsPkAtnN+IL3kY76rqbh7fMDqaZDt
         3uMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zDHfhXmednfbNTF5QPM+tR81pqc4KD04Wxyacx8vtsY=;
        b=tzsnO/U4Hc66GbVXxNG6DoNP/67Yz56/6dSVbx4K/hSt0od50GUsMZ0kHnZs6O1wUn
         o1P+RRO0uSuQxs6Ov7Cz/CfPkBdYR0uyuoJosbABTT51IVL8nfJ0238PP8Vy1lLG6fKp
         1/Lype3C144nCHcVztIIcp5hH7APnQJF29XcnmJMD4NH5ajYJEfh+gZbHJzKYHBjdosw
         r7S/5KI8i79O38wKYrD3s+Atw0xou20rkzCG26HcR9GrU1avv0FC+v8V67iaCtgGzjX2
         ePh6LPynnSggG1JRPzMVwJqU8GqqXeqAlO5AdqTWgWaNiDrxqJCO2bSyBDlfKDdyhp52
         6w+g==
X-Gm-Message-State: APjAAAWIDgKc5onQLavHMhblaOUH2l7Njl/kYAexB2CVA4GmHsYAfkjt
        0BkGuql6GdRVbs5YR4y5fPw=
X-Google-Smtp-Source: APXvYqz3Rr4/hd0GLcBW+exk0abI2+p3E8Z5rOpmUk9LP0fqLSOih+IDVL66IpZ0OY0z88ARhVYX3Q==
X-Received: by 2002:a92:405a:: with SMTP id n87mr12693794ila.16.1574367651788;
        Thu, 21 Nov 2019 12:20:51 -0800 (PST)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.googlemail.com with ESMTPSA id w75sm1694089ill.78.2019.11.21.12.20.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 12:20:51 -0800 (PST)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     emamd001@umn.edu, Navid Emamdoost <navid.emamdoost@gmail.com>
Subject: [PATCH] Bluetooth: Fix memory leak in hci_connect_le_scan
Date:   Thu, 21 Nov 2019 14:20:36 -0600
Message-Id: <20191121202038.27331-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the implementation of hci_connect_le_scan() when conn is added via
hci_conn_add(), if hci_explicit_conn_params_set() fails the allocated
memory for conn is leaked. Use hci_conn_del() to release it.

Fixes: f75113a26008 ("Bluetooth: add hci_connect_le_scan")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 net/bluetooth/hci_conn.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index ad5b0ac1f9ce..4472ec02c3e2 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1168,8 +1168,10 @@ struct hci_conn *hci_connect_le_scan(struct hci_dev *hdev, bdaddr_t *dst,
 	if (!conn)
 		return ERR_PTR(-ENOMEM);
 
-	if (hci_explicit_conn_params_set(hdev, dst, dst_type) < 0)
+	if (hci_explicit_conn_params_set(hdev, dst, dst_type) < 0) {
+		hci_conn_del(conn);
 		return ERR_PTR(-EBUSY);
+	}
 
 	conn->state = BT_CONNECT;
 	set_bit(HCI_CONN_SCANNING, &conn->flags);
-- 
2.17.1

