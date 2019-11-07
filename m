Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4CFF236F
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 01:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732752AbfKGAoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 19:44:20 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46885 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfKGAoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 19:44:19 -0500
Received: by mail-pl1-f193.google.com with SMTP id l4so120549plt.13;
        Wed, 06 Nov 2019 16:44:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ve6txvm4TEbZ68vl1TZrP7X3Fq6hJlmUnRCShKqx4Nc=;
        b=vN47OxNW9OpxtDVgv9BdNwxRsewNx8fSaPUZKaVQUNrcOQ2voRnPDZO4+7ZF+Df2qQ
         db/BjqbBzRuIHIuu8P3Dgo8tza2VWOkVhntkHXhLOTZ87cQ7YDgUV68nEPJ7pu4Yx0Al
         645dvDwdGtOzij+4nU1ffGiqD8XHqt9kmWGw5geDoU837WQCM71fbMpt698pFyWW3f8t
         a6pds0DTuwrGg5zVS3YF8Z+00AbZr221wvFURl2kJvJsFNjee6zXOmPcKnsNXCN00a4p
         YbpwLqYI68/2st7ssoQxkui/3D5im11vpVa58wRbNNiLrRG13OvUMPrFWe278MqeCfaU
         291w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ve6txvm4TEbZ68vl1TZrP7X3Fq6hJlmUnRCShKqx4Nc=;
        b=Jq+kxi8xZkCooeiwqmrCTf+IJEP54uGADLNbkUOiNK9x5bzPaRV0aAvP3Wf8Fsshf0
         bJK1H+5117kzaXFefVOWsUom5TUlG/SiTfkJmmvCU1QPfg+1KP+5ivRYzFDDBNuz5c7U
         gQN/tB7mARkhTEphEEl3s8CPPHdkS9vkWvA+/2XX+nO5F4nShzukWJKYEE0NJfLTqhQ6
         91dzmlZs/yVgS4Jcpyu/NJnks6fDKAJaU01qyP+qFK7TOPF9SJHGeGjxdYiNWSJZtMyq
         y+CJCfuLITZJQx1w2peNyL7GXqjcLsdsODyQNO3l+pB74qbSUp42dm8bqbilNT+oAN8t
         0u4g==
X-Gm-Message-State: APjAAAWoTH6M1+vjQY9h7sIsnJw58j5sS8Wq5RP2/8ZZ1pSytHYov0fY
        8BKaeXpHVeqKNm7Vi/+dbeo=
X-Google-Smtp-Source: APXvYqxpy3t28znraTs3FdUzKv0i5TNBoXLmMbIn4EQZShJvFNGc0pT9gU4Ma4CNDnuo+NLeWHI5Zg==
X-Received: by 2002:a17:902:9005:: with SMTP id a5mr583641plp.204.1573087458695;
        Wed, 06 Nov 2019 16:44:18 -0800 (PST)
Received: from debian.net.fpt ([2405:4800:58f7:3f8f:27cb:abb4:d0bd:49cb])
        by smtp.gmail.com with ESMTPSA id 71sm180385pfx.107.2019.11.06.16.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 16:44:18 -0800 (PST)
From:   Phong Tran <tranmanphong@gmail.com>
To:     syzbot+7dc7c28d4577bbe55b10@syzkaller.appspotmail.com,
        davem@davemloft.net, gregkh@linuxfoundation.org
Cc:     glider@google.com, hslester96@gmail.com,
        kstewart@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Phong Tran <tranmanphong@gmail.com>
Subject: [PATCH] usb: asix: Fix uninit-value in asix_mdio_write
Date:   Thu,  7 Nov 2019 07:44:04 +0700
Message-Id: <20191107004404.23707-1-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <0000000000009763320594f993ee@google.com>
References: <0000000000009763320594f993ee@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The local variables use without initilization value.
This fixes the syzbot report.

Reported-by: syzbot+7dc7c28d4577bbe55b10@syzkaller.appspotmail.com

Test result:

https://groups.google.com/d/msg/syzkaller-bugs/3H_n05x_sPU/sUoHhxgAAgAJ

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
 drivers/net/usb/asix_common.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
index e39f41efda3e..3c7ccd8a9da8 100644
--- a/drivers/net/usb/asix_common.c
+++ b/drivers/net/usb/asix_common.c
@@ -444,8 +444,8 @@ void asix_set_multicast(struct net_device *net)
 int asix_mdio_read(struct net_device *netdev, int phy_id, int loc)
 {
 	struct usbnet *dev = netdev_priv(netdev);
-	__le16 res;
-	u8 smsr;
+	__le16 res = 0;
+	u8 smsr = 0;
 	int i = 0;
 	int ret;
 
@@ -478,7 +478,7 @@ void asix_mdio_write(struct net_device *netdev, int phy_id, int loc, int val)
 {
 	struct usbnet *dev = netdev_priv(netdev);
 	__le16 res = cpu_to_le16(val);
-	u8 smsr;
+	u8 smsr = 0;
 	int i = 0;
 	int ret;
 
@@ -508,8 +508,8 @@ void asix_mdio_write(struct net_device *netdev, int phy_id, int loc, int val)
 int asix_mdio_read_nopm(struct net_device *netdev, int phy_id, int loc)
 {
 	struct usbnet *dev = netdev_priv(netdev);
-	__le16 res;
-	u8 smsr;
+	__le16 res = 0;
+	u8 smsr = 0;
 	int i = 0;
 	int ret;
 
@@ -543,7 +543,7 @@ asix_mdio_write_nopm(struct net_device *netdev, int phy_id, int loc, int val)
 {
 	struct usbnet *dev = netdev_priv(netdev);
 	__le16 res = cpu_to_le16(val);
-	u8 smsr;
+	u8 smsr = 0;
 	int i = 0;
 	int ret;
 
-- 
2.20.1

