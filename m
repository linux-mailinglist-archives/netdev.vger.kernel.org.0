Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03E6C67F355
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 01:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233512AbjA1AwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 19:52:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233092AbjA1Av7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 19:51:59 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9997EFC9
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 16:51:57 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id b6so4266118pgi.7
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 16:51:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MiU9G7/Ds/01bMEGuQC9LxFoYAJoQIyJyB7uaGN1BVg=;
        b=OLznq80N8Oh4QKvXlMNb3ih7XmBuOr005NMxnz1LIqYtgjmVS4YuyblUnj4zWitmjZ
         lJCBYiXm4J7ZPtv8qMBJLQ2QyrCPUVlMoHuTzG6nrKbe2t4bMMlp9FCurOKdogoN8i4l
         hQWxAh2177dSgrm4CatTUBP0hAX9SrJm5fmoc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MiU9G7/Ds/01bMEGuQC9LxFoYAJoQIyJyB7uaGN1BVg=;
        b=CXjOCCaOCEfYDx/8Zr13UqxqDto3v1/wkCdhYpRw2kqX6JxrrX6h+T1ccaWsG1Edzd
         a8eao3ygWFp5awoai7L6aPNdMg3c3hRLUTNoObC5HtFFtk9czmOL5yW2pymuAsLQDwOP
         4vz2LDilIHkXlsr+7zRah05zBWHBwrdkqH9yAgW6Z175XuTmKVuCU+RcPiIYFuBvAABs
         Zol/DyAuVn2DAq+YT7Haq069/vrsqpe/ODhQ7Jed5CpqQBSl+apvmr3dXdHh91x4pVeW
         U2nw8RGxK5Ayrc55yLUdf9wmuIc6T0UcEpOQLZ8Ss8xYmbDSrJF9Ico8KmpIkkHOpZn1
         ojXg==
X-Gm-Message-State: AO0yUKVy/dg4uzOe++BrppfqrsWYRDVRczepUpp05LWywzsr4Nd5pOF6
        32s8UGYtjzdCAYwVLZFEgfRIig==
X-Google-Smtp-Source: AK7set/63G02VXwkIsu1E4p409jYWDbrPfYLbnmPnCzvwiV1jwDFggi8v/o9Uk6HJHHBGWdI8SwqBg==
X-Received: by 2002:a05:6a00:1916:b0:58d:aae3:bcc1 with SMTP id y22-20020a056a00191600b0058daae3bcc1mr590500pfi.5.1674867116995;
        Fri, 27 Jan 2023 16:51:56 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id i2-20020a056a00004200b0059392f591b0sm202309pfk.53.2023.01.27.16.51.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 16:51:56 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] Bluetooth: hci_conn: Refactor hci_bind_bis() since it always succeeds
Date:   Fri, 27 Jan 2023 16:51:54 -0800
Message-Id: <20230128005150.never.909-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2549; h=from:subject:message-id; bh=mVnvB6NOyfWKqwGU5dfT8S9lHvRpK/kONHhCQ2CZubo=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBj1HGqBJHOTl2sp2HPsmuw4TM++NQqA2fhgVBlGeK4 MQdzgL2JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCY9RxqgAKCRCJcvTf3G3AJjDqD/ 0V0RCFZ3es87Ut1Lhxbg2HbsAjs/19gb8HGiAWmEiBRCm82CiN1ITFJVmYFH0xvuismK6BY5FNj8lS CMX08uMHTIswyaN5ofAc9gyH8zLHzyyEnNe+hJrJlN4vqzi0QGNy5uAyt6QG/7kQvabiiQXS34cOsr VJI3asei8wsGFxCvYz/vBYL7zz6j1aQ1ZdnRrRt6yOk7XIfpp6M65oPkznc/2vtOsgb9BQ5eQsvvA5 hbDSzxnlzxviJ5nXIZSKQcn6F5raQ0Yy3rj6dLnGt2JkESmUwvuXBmU0alQK2uuW9f0MNYlDAboyvX VwuTTivoEkQbOM3AzdHp6JOQP7daw+nRfxiiqiffRME5JbQckkDi9wjaBZvBrcWRLDIoQPTgBOWGKD f1xNi2lOWu6AOrsv6ZGKTp72iZsieXDBwBc2TbeGZ4+9PhS4g8jQQ1QLHQCUKVBLk/GNpTcYWO8+Nw i0CrHq5WR2SmhGB/UYiZON2eOmeugzjRR8XWZFk+tgiGsjlwIFJn4MyIv4bT+GFcnm2w5J8NEfc85q fWVG3gz0ySWvP5ysxUpuv6GlMw8Tobx+52ascosL0U43MqZJ8/ZrSe/99wfCbdUcblc1BkWp3ggxRJ ezfgazR7DB1IvBC35Sm6nk2z2M7+PLYlE0jWeC8Amh3+ty78ipc69h9JwAYA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The compiler thinks "conn" might be NULL after a call to hci_bind_bis(),
which cannot happen. Avoid any confusion by just making it not return a
value since it cannot fail. Fixes the warnings seen with GCC 13:

In function 'arch_atomic_dec_and_test',
    inlined from 'atomic_dec_and_test' at ../include/linux/atomic/atomic-instrumented.h:576:9,
    inlined from 'hci_conn_drop' at ../include/net/bluetooth/hci_core.h:1391:6,
    inlined from 'hci_connect_bis' at ../net/bluetooth/hci_conn.c:2124:3:
../arch/x86/include/asm/rmwcc.h:37:9: warning: array subscript 0 is outside array bounds of 'atomic_t[0]' [-Warray-bounds=]
   37 |         asm volatile (fullop CC_SET(cc) \
      |         ^~~
...
In function 'hci_connect_bis':
cc1: note: source object is likely at address zero

Fixes: eca0ae4aea66 ("Bluetooth: Add initial implementation of BIS connections")
Cc: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Johan Hedberg <johan.hedberg@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: linux-bluetooth@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/bluetooth/hci_conn.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index acf563fbdfd9..61a34801e61e 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1981,16 +1981,14 @@ static void hci_iso_qos_setup(struct hci_dev *hdev, struct hci_conn *conn,
 		qos->latency = conn->le_conn_latency;
 }
 
-static struct hci_conn *hci_bind_bis(struct hci_conn *conn,
-				     struct bt_iso_qos *qos)
+static void hci_bind_bis(struct hci_conn *conn,
+			 struct bt_iso_qos *qos)
 {
 	/* Update LINK PHYs according to QoS preference */
 	conn->le_tx_phy = qos->out.phy;
 	conn->le_tx_phy = qos->out.phy;
 	conn->iso_qos = *qos;
 	conn->state = BT_BOUND;
-
-	return conn;
 }
 
 static int create_big_sync(struct hci_dev *hdev, void *data)
@@ -2119,11 +2117,7 @@ struct hci_conn *hci_connect_bis(struct hci_dev *hdev, bdaddr_t *dst,
 	if (IS_ERR(conn))
 		return conn;
 
-	conn = hci_bind_bis(conn, qos);
-	if (!conn) {
-		hci_conn_drop(conn);
-		return ERR_PTR(-ENOMEM);
-	}
+	hci_bind_bis(conn, qos);
 
 	/* Add Basic Announcement into Peridic Adv Data if BASE is set */
 	if (base_len && base) {
-- 
2.34.1

