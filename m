Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6BC3D0D95
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 13:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240325AbhGUKqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 06:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238551AbhGUJgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 05:36:53 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392B8C0613E3;
        Wed, 21 Jul 2021 03:17:29 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id j73so1441000pge.1;
        Wed, 21 Jul 2021 03:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GmFXEsAxbG8KZfMM+UsqBDrbJkHUFiGmqFsibv1XO4g=;
        b=Fx32sue3mQepTLN9Ttrt6nLPas35qhyRkAnEpea2Mouer4p+Cp6rthrsL0RXkc9o1M
         s4xuwkH74RNoERSESufIhVW5eNQj38mMmrHQXEDWSVGjLfLVy2TSkuvNab0maOwEyAmH
         vhtKcsVhXIv3VHE2dy7Bxv3e2XjJSjApiub4YZQWmmJ3hpaLjd4pxLNhfMeBjBfkFE6G
         wcs16zGFHsiqGI2ZwZeZ7hjkkP8Xgozod55VlGfbMi6U4GR0+/ul1sFKsHzpeZ/Mw/kQ
         1RbnVd1EOtTJRIQcbHlan6TIBFQKtiHCYvWczkApNzkSqtUKeY9mFElQvgqpoxLK/XyU
         8Mzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GmFXEsAxbG8KZfMM+UsqBDrbJkHUFiGmqFsibv1XO4g=;
        b=llkvxkCmvQAILRG42cjdegu0GrLXO4MGeMtASaEHZM4Enxvi2ZOiHCoYpmk/VPbd5J
         +FFivlWTMry8WjXRdABo9fy3QEEWVOgZgoBggq+XboymfeFf3lsD7z7kGOwCE0TGFoDg
         ZwJM6em0t5yxx5qMAmrYUnUQnqJYwz70kjepwxS0qkY2SlPw+MHQ2SVF1dtUygKO/lOD
         VWbmy0bNnlCOCiw9llYMkfMPNbVogeisrFxp2aSwZM1YBqxVlrKfK7Csw2uoDBdLzdaD
         f3dOY2k8EJJwqOiSTephpZDWBGtMUNyY2awwVPAJ3lhye6pRRGFrieZ43MbfcvYyijiu
         tjPQ==
X-Gm-Message-State: AOAM531JwknIZkSX/Akn6w40zZLRvclfTWXsZfTlsxSDLSogUKVcit/1
        IHh9L0Y7Qg9WcrlZXLfPyHtubP8nmoqEVIFRMEQ=
X-Google-Smtp-Source: ABdhPJxabd+8ymM2NRg2/JRi5E0kd2wtw9dI2cxAd5OZTNoNwxYd09wBP09f+o8F+RdDtGAnclFeIQ==
X-Received: by 2002:a62:160a:0:b029:328:56b9:b1ee with SMTP id 10-20020a62160a0000b029032856b9b1eemr36090473pfw.52.1626862648751;
        Wed, 21 Jul 2021 03:17:28 -0700 (PDT)
Received: from localhost.localdomain ([118.200.190.93])
        by smtp.gmail.com with ESMTPSA id p33sm26481068pfw.40.2021.07.21.03.17.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 03:17:28 -0700 (PDT)
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
        gregkh@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+66264bf2fd0476be7e6c@syzkaller.appspotmail.com
Subject: [PATCH] Bluetooth: skip invalid hci_sync_conn_complete_evt
Date:   Wed, 21 Jul 2021 18:17:10 +0800
Message-Id: <20210721101710.82974-1-desmondcheongzx@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported a corrupted list in kobject_add_internal [1]. This
happens when multiple HCI_EV_SYNC_CONN_COMPLETE event packets with
status 0 are sent for the same HCI connection. This causes us to
register the device more than once which corrupts the kset list.

To fix this, in hci_sync_conn_complete_evt, we check whether we're
trying to process the same HCI_EV_SYNC_CONN_COMPLETE event multiple
times for one connection. If that's the case, the event is invalid, so
we skip further processing and exit.

Link: https://syzkaller.appspot.com/bug?extid=66264bf2fd0476be7e6c [1]
Reported-by: syzbot+66264bf2fd0476be7e6c@syzkaller.appspotmail.com
Tested-by: syzbot+66264bf2fd0476be7e6c@syzkaller.appspotmail.com
Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
---
 net/bluetooth/hci_event.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 016b2999f219..091a92338492 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4373,6 +4373,8 @@ static void hci_sync_conn_complete_evt(struct hci_dev *hdev,
 
 	switch (ev->status) {
 	case 0x00:
+		if (conn->state == BT_CONNECTED)
+			goto unlock;  /* Already connected, event not valid */
 		conn->handle = __le16_to_cpu(ev->handle);
 		conn->state  = BT_CONNECTED;
 		conn->type   = ev->link_type;
-- 
2.25.1

