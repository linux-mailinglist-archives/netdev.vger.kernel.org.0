Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF915AADCA
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 13:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235434AbiIBLiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 07:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232815AbiIBLh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 07:37:57 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01FD4785BF
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 04:37:54 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id z29so2819639lfb.13
        for <netdev@vger.kernel.org>; Fri, 02 Sep 2022 04:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=yj/yL5/uncUjgABW6TlX6EV5DVXmfj7HR4uoZjmZwns=;
        b=aHW/1vZ4L/ksZ7lQK63iFZQqcY0xeh/QkIw1tMMHrkwbbngu/8mxB+lsK0ZTCU7Knv
         HGJLyUgj2oAHoWRXedDMsfyEFMB9Yj/hYTaEmEAGQunpSo0ce0SrBzv9llkQeRbJgPBR
         bulnDNBZvNBUqQ/H672ajn4nqvyVJ5ADp5OOykLlqx6/US4tGNbn1/B06qzUI2SBcPUr
         4uAnCDawL1/oYFuK/ZKLd7KS7kHDH0cK0uRrw64CwPnwVdSFvc3MtwyCwrcvpnO5Eoxn
         UV0D1ivMW2KkvPBqyZVNJ/mTMBHYPOpti1T3xIqghN+e1uuFIqn4zZri8S+diO7p0wLX
         YEaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=yj/yL5/uncUjgABW6TlX6EV5DVXmfj7HR4uoZjmZwns=;
        b=OjUMhLDYbH7eof1GAo9Kk4SywhaHNamDp0B3q9Qp3t2GKx7+X13YcHT/kWvPz5HYca
         7hdw0382FUbFeunZpEZYh+MCEZfN8a+7tGZ6XXdO6ubg1hkRh6PKZwqPF/oGrhavX+87
         8mpdndLGaYVTOa7eYZgLvjCZkf9mCWUDlNDc2qvd348yrC6qSi7wLARhhfkwn2WXF+ne
         0q2CQwPFLSmNCEW87d/cCvbOkzLMJRYLeQ8Elkzki7/uwUWdH/ZrCNhIhf4gieNlpp6S
         /5g04OYG8FdbgCo3d4h8wW3AmeRCS87i8s7xQwN/NN9k3q7blZ6KbjlBqQ+68eGPSeA1
         rRxw==
X-Gm-Message-State: ACgBeo0lplyLw2nPYhP35gcBDaT8/XPBORk/DnyvXalQ2HFMhAm6jRGd
        USeUDpv+VA1RYHK1G0bobcQccThBD5hUvk7S
X-Google-Smtp-Source: AA6agR4CjwUQmaTG56vmX2oxbfo7pxigIKf/BbBRFmVuutyV0UZe+k6dO7VeqUMXFIBuUm+jvAETeg==
X-Received: by 2002:a05:6512:12c9:b0:48b:3e0f:7a79 with SMTP id p9-20020a05651212c900b0048b3e0f7a79mr12674569lfg.52.1662118673242;
        Fri, 02 Sep 2022 04:37:53 -0700 (PDT)
Received: from saproj-Latitude-5501.yandex.net ([2a02:6b8:0:40c:bdef:fb0c:46dd:15b5])
        by smtp.gmail.com with ESMTPSA id c15-20020a2e9d8f000000b0026885ad3ba8sm152723ljj.67.2022.09.02.04.37.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 04:37:52 -0700 (PDT)
From:   Sergei Antonov <saproj@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com,
        Sergei Antonov <saproj@gmail.com>
Subject: [PATCH net-next] net: ftmac100: fix endianness-related issues from 'sparse'
Date:   Fri,  2 Sep 2022 14:37:49 +0300
Message-Id: <20220902113749.1408562-1-saproj@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sparse found a number of endianness-related issues of these kinds:

.../ftmac100.c:192:32: warning: restricted __le32 degrades to integer

.../ftmac100.c:208:23: warning: incorrect type in assignment (different base types)
.../ftmac100.c:208:23:    expected unsigned int rxdes0
.../ftmac100.c:208:23:    got restricted __le32 [usertype]

.../ftmac100.c:249:23: warning: invalid assignment: &=
.../ftmac100.c:249:23:    left side has type unsigned int
.../ftmac100.c:249:23:    right side has type restricted __le32

.../ftmac100.c:527:16: warning: cast to restricted __le32

Change type of some fields from 'unsigned int' to '__le32' to fix it.

Signed-off-by: Sergei Antonov <saproj@gmail.com>
---
 drivers/net/ethernet/faraday/ftmac100.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/faraday/ftmac100.h b/drivers/net/ethernet/faraday/ftmac100.h
index fe986f1673fc..8af32f9070f4 100644
--- a/drivers/net/ethernet/faraday/ftmac100.h
+++ b/drivers/net/ethernet/faraday/ftmac100.h
@@ -122,9 +122,9 @@
  * Transmit descriptor, aligned to 16 bytes
  */
 struct ftmac100_txdes {
-	unsigned int	txdes0;
-	unsigned int	txdes1;
-	unsigned int	txdes2;	/* TXBUF_BADR */
+	__le32		txdes0;
+	__le32		txdes1;
+	__le32		txdes2;	/* TXBUF_BADR */
 	unsigned int	txdes3;	/* not used by HW */
 } __attribute__ ((aligned(16)));
 
@@ -143,9 +143,9 @@ struct ftmac100_txdes {
  * Receive descriptor, aligned to 16 bytes
  */
 struct ftmac100_rxdes {
-	unsigned int	rxdes0;
-	unsigned int	rxdes1;
-	unsigned int	rxdes2;	/* RXBUF_BADR */
+	__le32		rxdes0;
+	__le32		rxdes1;
+	__le32		rxdes2;	/* RXBUF_BADR */
 	unsigned int	rxdes3;	/* not used by HW */
 } __attribute__ ((aligned(16)));
 
-- 
2.34.1

