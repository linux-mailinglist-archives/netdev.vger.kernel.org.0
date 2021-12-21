Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF7DF47C79C
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 20:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241846AbhLUTkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 14:40:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237467AbhLUTkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 14:40:03 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53524C061574;
        Tue, 21 Dec 2021 11:40:03 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id i31so120909lfv.10;
        Tue, 21 Dec 2021 11:40:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X+qQ8cOWr3KYDLsqh+E8A3qJbCcPj8hXX9NXQmQghMw=;
        b=IOh1sSAi35BrRDyT2BlikmB1kEuAJLWXMHKnQ5egM133fsVbRUwZrbL8GzMG1WdWyz
         lUR/VXFc1/sC4h9Kmv4tH4YXzBue1EEXp8YZTb0sfqQJwIGeap2S4ukbBvtDTnovRsAw
         kXMvMOJqamHKy/pzrvOF5oR1ZvdflKwSfbrNI8WV+CH0MZ8PA9siP1QiIlLU4/d1Tko3
         CFVEtDtmUi6kzyss2xIpEkJES7rxOWwFktkFVU8F1q/INoZtj/NQH+pi9rxbM6HxG7DH
         9YNssPt9pTO9LaNRReO6qlASl6nA9iClNSg4hKKzuogHlmioiKdFq/I9trDBXM6RATHL
         6A7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X+qQ8cOWr3KYDLsqh+E8A3qJbCcPj8hXX9NXQmQghMw=;
        b=XxL/ZYgTpkyu0jpZuxXIkbbK31QV1VpGpcHwqE12O9XthzsCuGVcsd10FeVbDQ2CuJ
         F8LkpCnkc7p6UZB5alIZsAEf+LnL9BmccbO2MsRBHMxMGHuaPG9WpF7OqLcCXm+5f1iS
         ZWcUNXmzJ8BvNSlth0re0V0JqZnyoqb/iiMccsMiN93IE1OufzjyewiVNdqAh36nD7Bk
         2eY/lGz5MoaM/HRDyetMpr5wcSMagRc+LqCeoG/5rjMitpHzVOAy1n+r8k8OLAU08M+1
         SKPj0P+ZAsGkjNuFGfP/R14iuMsQZUop6ladOpt3mpwX3rbNPAXXcVi2EXwyqfcRO+Qc
         E2Dg==
X-Gm-Message-State: AOAM531eeRoi/s8ksGHO3cQvfIV/EOjIFb2AB9TTuXlJGLMq6qxngYtb
        zxXt+VtKLAO/U/Aj6VO05Dk=
X-Google-Smtp-Source: ABdhPJyiWYtCRiDHXtbL3FNBAPDPseFmLc0mG9mUtTOEL9oDneTuykecD30kXs+F2wE2ie8XpjqfXg==
X-Received: by 2002:a05:6512:3e28:: with SMTP id i40mr4084008lfv.436.1640115601549;
        Tue, 21 Dec 2021 11:40:01 -0800 (PST)
Received: from localhost.localdomain ([94.103.235.97])
        by smtp.gmail.com with ESMTPSA id d5sm662799lfv.83.2021.12.21.11.40.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 11:40:01 -0800 (PST)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux@rempel-privat.de,
        andrew@lunn.ch, robert.foss@collabora.com, freddy@asix.com.tw
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+f44badb06036334e867a@syzkaller.appspotmail.com
Subject: [PATCH 1/2] asix: fix uninit-value in asix_mdio_read()
Date:   Tue, 21 Dec 2021 22:39:32 +0300
Message-Id: <bd6a7e1779ba97a300650e8e23b69ecffb3b4236.1640115493.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

asix_read_cmd() may read less than sizeof(smsr) bytes and in this case
smsr will be uninitialized.

Fail log:
BUG: KMSAN: uninit-value in asix_check_host_enable drivers/net/usb/asix_common.c:82 [inline]
BUG: KMSAN: uninit-value in asix_check_host_enable drivers/net/usb/asix_common.c:82 [inline] drivers/net/usb/asix_common.c:497
BUG: KMSAN: uninit-value in asix_mdio_read+0x3c1/0xb00 drivers/net/usb/asix_common.c:497 drivers/net/usb/asix_common.c:497
 asix_check_host_enable drivers/net/usb/asix_common.c:82 [inline]
 asix_check_host_enable drivers/net/usb/asix_common.c:82 [inline] drivers/net/usb/asix_common.c:497
 asix_mdio_read+0x3c1/0xb00 drivers/net/usb/asix_common.c:497 drivers/net/usb/asix_common.c:497

Fixes: d9fe64e51114 ("net: asix: Add in_pm parameter")
Reported-and-tested-by: syzbot+f44badb06036334e867a@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/net/usb/asix_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
index 42ba4af68090..06823d7141b6 100644
--- a/drivers/net/usb/asix_common.c
+++ b/drivers/net/usb/asix_common.c
@@ -77,7 +77,7 @@ static int asix_check_host_enable(struct usbnet *dev, int in_pm)
 				    0, 0, 1, &smsr, in_pm);
 		if (ret == -ENODEV)
 			break;
-		else if (ret < 0)
+		else if (ret < sizeof(smsr))
 			continue;
 		else if (smsr & AX_HOST_EN)
 			break;
-- 
2.34.1

