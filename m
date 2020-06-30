Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED0F20EBE1
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 05:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729037AbgF3DPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 23:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727826AbgF3DPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 23:15:05 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F5AC061755
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 20:15:05 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id o22so3815648pjw.2
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 20:15:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lnvoY3haB0lkXFUtpPBEotF++tFsvMyqqAyM4Qg1MaQ=;
        b=XWeAl/Q1DUptQJdejIDggTu9F0H4AtRUlR9s9MxsEwBtXR7JAE3kLeX11fTCj/Dycr
         hNBqrh5b7MRiUYB5pQgEbL71EsKqbhYN8g63BKt1LHdu4lI8vK0prJ1YAISUG7K2RqVS
         hcvNXEbx1VMxIGtqRnzQ+tKyAcStwdn8W3PgQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lnvoY3haB0lkXFUtpPBEotF++tFsvMyqqAyM4Qg1MaQ=;
        b=Ayq2pZ+Lkv4zo6Gn+I6Wvxi4DgYMlhE8bExbpuhLRnR4N4f+CTpU/agvLWjf2qzgc8
         I82hp8Vs/BUWmIWIJOck/FK6TkURpTrtLw8Z/4/jH1S5eDosVFankZasiavpXdPY43fC
         o813GP6O+AVvclhG80YzteW2RJXsPzJiGb390dISantYUvWyZRdVZrnzeJAUBiR3JpJi
         wsoGKIEINaANlar7JRT2JenJrcq8YvEe99XA3fyd5FUga1MRmAXPBH/a0cRxehTEuEru
         CJrN0uOJRda7+lDa08BaYa5FKlXU7Nw3pFM3UOlFB1B+x1lNgSha4S8QFendFT6wfFgq
         UtTQ==
X-Gm-Message-State: AOAM532vRJdV0w10xgM0ysyyu8xDfNczCMn+9rKg5S3r9hXRQH49jiYP
        rKrifMmmwezwn60yPBsAq0oJAA==
X-Google-Smtp-Source: ABdhPJyCaY4RyJ36oOm/AkJtdEmCYXpSXmi7dv53zIUgI3DXuKN9uF2aD+jKbihSx6VE2FF7bgv16w==
X-Received: by 2002:a17:902:a513:: with SMTP id s19mr15417102plq.140.1593486905209;
        Mon, 29 Jun 2020 20:15:05 -0700 (PDT)
Received: from mcchou0.mtv.corp.google.com ([2620:15c:202:201:de4a:3eff:fe75:1314])
        by smtp.gmail.com with ESMTPSA id x66sm54166pgb.12.2020.06.29.20.15.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jun 2020 20:15:04 -0700 (PDT)
From:   Miao-chen Chou <mcchou@chromium.org>
To:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Alain Michaud <alainm@chromium.org>, pavel@ucw.cz,
        Miao-chen Chou <mcchou@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v1] Bluetooth: Fix kernel oops triggered by hci_adv_monitors_clear()
Date:   Mon, 29 Jun 2020 20:15:00 -0700
Message-Id: <20200629201441.v1.1.I162e3c6c4f4d963250c37733c3428329110c5989@changeid>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes the kernel oops by removing unnecessary background scan
update from hci_adv_monitors_clear() which shouldn't invoke any work
queue.

The following test was performed.
- Run "rmmod btusb" and verify that no kernel oops is triggered.

Signed-off-by: Miao-chen Chou <mcchou@chromium.org>
Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Reviewed-by: Alain Michaud <alainm@chromium.org>
---

 net/bluetooth/hci_core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 5577cf9e2c7cd..77615161c7d72 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3005,8 +3005,6 @@ void hci_adv_monitors_clear(struct hci_dev *hdev)
 		hci_free_adv_monitor(monitor);
 
 	idr_destroy(&hdev->adv_monitors_idr);
-
-	hci_update_background_scan(hdev);
 }
 
 void hci_free_adv_monitor(struct adv_monitor *monitor)
-- 
2.26.2

