Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE20462FE83
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 21:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbiKRUEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 15:04:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbiKRUEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 15:04:07 -0500
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45549DC6;
        Fri, 18 Nov 2022 12:04:05 -0800 (PST)
Received: by mail-io1-f46.google.com with SMTP id b2so4604536iof.12;
        Fri, 18 Nov 2022 12:04:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AhdkGygTY3zoLbGAB/+Raeg5fzHG6ZjkIK/WhyIG7oM=;
        b=qMQUo+5n/Qgrw6orGT5BagNpQES5PYD3ObMq9VBTMugxag5GNnzhDRJJHpaCPgQd3O
         OWnjrI7GsMeHJ6LG5II/Lg0l1gIgWPP2MUOZsqygOL7XhyYc+NeTcBu/u1WOnOZdevvR
         IvkN121o63/tvk2nf45xa6T/z3gSPY6aPBHeG91GpGz2rdfXc5VG6g7kl7DGzHrHnOt2
         hHOt2y6tWMk8T25uXiQtT4A1CtpiOLW2hoNTStO2+L7UaHqFbnj6/FBdIJhRyMI3ATX+
         4GWqx40BXAf37tN6c5ZZy1fbka3Q8jtyRIoiI97lhHomuCMtm7ajJiVilT5VvoIzOZS5
         51FQ==
X-Gm-Message-State: ANoB5pkTcmOXXfnzVq2qiZKgtbh2rK/4tmzOXoVW8rshgaZ3YC4DVUZB
        9EYjoyEiHm3RJ8CdvbI0Lh8=
X-Google-Smtp-Source: AA0mqf5Br29FRXK/1NcL4h/veA3rOteAy8JC0XUr5l+LfnOm1RRMi55jyOIwQU0JwxDIIpRa32SFaA==
X-Received: by 2002:a6b:8d09:0:b0:68b:7b1f:92b9 with SMTP id p9-20020a6b8d09000000b0068b7b1f92b9mr4167072iod.163.1668801844397;
        Fri, 18 Nov 2022 12:04:04 -0800 (PST)
Received: from noodle.cs.purdue.edu (switch-lwsn2133-z1r11.cs.purdue.edu. [128.10.127.250])
        by smtp.googlemail.com with ESMTPSA id i13-20020a02b68d000000b003638d00b759sm1517966jam.54.2022.11.18.12.04.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 12:04:03 -0800 (PST)
From:   Sungwoo Kim <iam@sung-woo.kim>
Cc:     Sungwoo Kim <iam@sung-woo.kim>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Bluetooth: L2CAP: Fix u8 overflow
Date:   Fri, 18 Nov 2022 15:01:47 -0500
Message-Id: <20221118200145.1741199-1-iam@sung-woo.kim>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By keep sending L2CAP_CONF_REQ packets, chan->num_conf_rsp increases
multiple times and eventually it will wrap around the maximum number
(i.e., 255).
This patch prevents this by adding a boundary check with
L2CAP_MAX_CONF_RSP

Btmon log:
Bluetooth monitor ver 5.64
= Note: Linux version 6.1.0-rc2 (x86_64)                               0.264594
= Note: Bluetooth subsystem version 2.22                               0.264636
@ MGMT Open: btmon (privileged) version 1.22                  {0x0001} 0.272191
= New Index: 00:00:00:00:00:00 (Primary,Virtual,hci0)          [hci0] 13.877604
@ RAW Open: 9496 (privileged) version 2.22                   {0x0002} 13.890741
= Open Index: 00:00:00:00:00:00                                [hci0] 13.900426
(...)
> ACL Data RX: Handle 200 flags 0x00 dlen 1033             #32 [hci0] 14.273106
        invalid packet size (12 != 1033)
        08 00 01 00 02 01 04 00 01 10 ff ff              ............    
> ACL Data RX: Handle 200 flags 0x00 dlen 1547             #33 [hci0] 14.273561
        invalid packet size (14 != 1547)
        0a 00 01 00 04 01 06 00 40 00 00 00 00 00        ........@.....  
> ACL Data RX: Handle 200 flags 0x00 dlen 2061             #34 [hci0] 14.274390
        invalid packet size (16 != 2061)
        0c 00 01 00 04 01 08 00 40 00 00 00 00 00 00 04  ........@.......
> ACL Data RX: Handle 200 flags 0x00 dlen 2061             #35 [hci0] 14.274932
        invalid packet size (16 != 2061)
        0c 00 01 00 04 01 08 00 40 00 00 00 07 00 03 00  ........@.......
= bluetoothd: Bluetooth daemon 5.43                                   14.401828
> ACL Data RX: Handle 200 flags 0x00 dlen 1033             #36 [hci0] 14.275753
        invalid packet size (12 != 1033)
        08 00 01 00 04 01 04 00 40 00 00 00              ........@...    


Signed-off-by: Sungwoo Kim <iam@sung-woo.kim>
---
 net/bluetooth/l2cap_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 9c24947aa..9fdede5fe 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4453,7 +4453,8 @@ static inline int l2cap_config_req(struct l2cap_conn *conn,
 
 	chan->ident = cmd->ident;
 	l2cap_send_cmd(conn, cmd->ident, L2CAP_CONF_RSP, len, rsp);
-	chan->num_conf_rsp++;
+	if (chan->num_conf_rsp < L2CAP_CONF_MAX_CONF_RSP)
+		chan->num_conf_rsp++;
 
 	/* Reset config buffer. */
 	chan->conf_len = 0;
-- 
2.25.1

