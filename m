Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF761EF755
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 09:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387862AbfKEIe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 03:34:58 -0500
Received: from mail-m972.mail.163.com ([123.126.97.2]:43602 "EHLO
        mail-m972.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387575AbfKEIe6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 03:34:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=UmCATjPG/GKR+6fRa5
        oRwlQUqq9VmP1kRhoxMz0GB78=; b=AAfCtRej8KmnUcsJgbHv21b8BJBL4z4LbK
        0WgcSD02B11JJy8eIYB3pt3scN13PA65kdwqQYTBG42ZVs5DHOUbIHuiUj7Hh6nr
        q5UmIcpzIeWd7PuCXGgUVfBuehJ/OLUfnfntNVq5n+Mn0OaE6l92a0JmRGyvSrvU
        uVMabAGNg=
Received: from localhost.localdomain (unknown [202.112.113.212])
        by smtp2 (Coremail) with SMTP id GtxpCgB3wh8MNMFd8mC3Aw--.239S3;
        Tue, 05 Nov 2019 16:34:30 +0800 (CST)
From:   Pan Bian <bianpan2016@163.com>
To:     Allison Randal <allison@lohutok.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Fontana <rfontana@redhat.com>,
        Kate Stewart <kstewart@linuxfoundation.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pan Bian <bianpan2016@163.com>
Subject: [PATCH] NFC: fdp: fix incorrect free object
Date:   Tue,  5 Nov 2019 16:34:07 +0800
Message-Id: <1572942847-35209-1-git-send-email-bianpan2016@163.com>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: GtxpCgB3wh8MNMFd8mC3Aw--.239S3
X-Coremail-Antispam: 1Uf129KBjvdXoW7Wr4UXFy8Aw13XF1xuFWxWFg_yoW3Jrc_CF
        srur47ur15CFyfK343ur4FvryUK347Zwn3GF1SgFW3AryUXF4DAw4UZrn7Ar45Ww47Zas8
        Ww4DW34rZ3yDCjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU1jNt3UUUUU==
X-Originating-IP: [202.112.113.212]
X-CM-SenderInfo: held01tdqsiiqw6rljoofrz/xtbBURZkclaD5IoMxAAAsi
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The address of fw_vsc_cfg is on stack. Releasing it with devm_kfree() is
incorrect, which may result in a system crash or other security impacts.
The expected object to free is *fw_vsc_cfg.

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 drivers/nfc/fdp/i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/fdp/i2c.c b/drivers/nfc/fdp/i2c.c
index 1cd113c8d7cb..ad0abb1f0bae 100644
--- a/drivers/nfc/fdp/i2c.c
+++ b/drivers/nfc/fdp/i2c.c
@@ -259,7 +259,7 @@ static void fdp_nci_i2c_read_device_properties(struct device *dev,
 						  *fw_vsc_cfg, len);
 
 		if (r) {
-			devm_kfree(dev, fw_vsc_cfg);
+			devm_kfree(dev, *fw_vsc_cfg);
 			goto vsc_read_err;
 		}
 	} else {
-- 
2.7.4

