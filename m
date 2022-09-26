Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91F465EB29E
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 22:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbiIZUsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 16:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiIZUsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 16:48:01 -0400
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE030A6C6A;
        Mon, 26 Sep 2022 13:47:59 -0700 (PDT)
Received: by mail-io1-f54.google.com with SMTP id p202so6246982iod.6;
        Mon, 26 Sep 2022 13:47:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=faa5y7qBR+UreIMx8m63IdwyTJaEPpyMFVUYsgBqw10=;
        b=iD+KSdS9wJ0+tBHuKR3iPyul3DGyZ7cSsdx9WiLUoPpUnzpuSp9f4CgWfGLPTr0+aq
         BWNPp2hHs0Wy4CUHPCaRNJJmGfkA4ZxsdlY47mvPWk4ICJEWuquvn9igcawiv8LMsBgL
         AtZVH5xTtTOBqmsHr4J0ELev9dZ4s1ZHUJcPnW1pBnIKWhcSO3hB5NbABRXdZR5ctDck
         J8Dkwu+123wLlgLDauLTN8fM8QPpckJ7+3tsj7oGPd3cUycRQwE0+8bV7Ds7jqYIvHWa
         /HGs+IJa4O2QQluDeRoRkWsak1R4/5PHjNbmOUUIfVggR4SoAjqqWnyhOBWZgso509kp
         5igQ==
X-Gm-Message-State: ACrzQf0HAzwntkcy2b/9uPJ9Ik70B/Uwn8m6p0FI79JWbGn6muwYyVUE
        6Pa2I2Ah4bebHhQxcsnndwI=
X-Google-Smtp-Source: AMsMyM6O6zaf+mSCDHfYhOS6FFRft1h0I2XNvK2d8x/7KIMcdO0Q6CEYIKgagoctq1u/jQXoPwdbWg==
X-Received: by 2002:a05:6638:3821:b0:35a:1973:ae9 with SMTP id i33-20020a056638382100b0035a19730ae9mr11897859jav.313.1664225279054;
        Mon, 26 Sep 2022 13:47:59 -0700 (PDT)
Received: from noodle.cs.purdue.edu (switch-lwsn2133-z1r11.cs.purdue.edu. [128.10.127.250])
        by smtp.googlemail.com with ESMTPSA id c14-20020a023b0e000000b0035a8d644a31sm7336423jaa.117.2022.09.26.13.47.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 13:47:58 -0700 (PDT)
From:   Sungwoo Kim <iam@sung-woo.kim>
Cc:     syzkaller@googlegroups.com, Sungwoo Kim <iam@sung-woo.kim>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Bluetooth: L2CAP: fix an illegal state transition from BT_DISCONN
Date:   Mon, 26 Sep 2022 16:46:58 -0400
Message-Id: <20220926204657.3147968-1-iam@sung-woo.kim>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prevent an illegal state transition from BT_DISCONN to BT_CONFIG.
L2CAP_CONN_RSP and L2CAP_CREATE_CHAN_RSP events should be ignored
for BT_DISCONN state according to the Bluetooth Core v5.3 p.1096.
It is found by BTFuzz, a modified version of syzkaller.

Signed-off-by: Sungwoo Kim <iam@sung-woo.kim>
---
 net/bluetooth/l2cap_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 2c9de67da..a15d64b13 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4307,6 +4307,9 @@ static int l2cap_connect_create_rsp(struct l2cap_conn *conn,
 		}
 	}
 
+	if (chan->state == BT_DISCONN)
+		goto unlock;
+
 	err = 0;
 
 	l2cap_chan_lock(chan);
-- 
2.25.1

