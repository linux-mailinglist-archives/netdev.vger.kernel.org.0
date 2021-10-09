Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78AC6427DDC
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 00:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbhJIWTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 18:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbhJIWTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 18:19:15 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B13FCC061570;
        Sat,  9 Oct 2021 15:17:17 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id r18so50759246edv.12;
        Sat, 09 Oct 2021 15:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K6k8mNyxLA9vdEcmjlVx18gI02oq8G/qXeE9dmeA7d8=;
        b=lk6cXENKjt9h+3xLSMV3cVn4dD1HVf19+yIH8ZL3nMh6uv0Lt4xAsl2Oe0/GWQnZqG
         tGzQjit/yvsAsukdsIBfaKy2tj8Sr01Nz11+cO3DLwDCPU5VgaENaOYzsS53tYkKFk0o
         fSoFdGVsSfBi5nn5l4pOebrNGj1pFwqpyjSf7UV4tOkrERK0QdyO618kY1AkyqWnwlpg
         aq1QFnpg54EmjAjnVEsdvLoELqpaLCIJQWEoeDHwlvjTWTp5v6PV2d1C26zY5GK0Uy7V
         JfhlpWD/M1C9RBtRoRRyxFyfhLO04FYkxcmomei8d4LSBtS2wEboqs6wV2pMqqP/c8nC
         /Txw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K6k8mNyxLA9vdEcmjlVx18gI02oq8G/qXeE9dmeA7d8=;
        b=Nk36w1QM+q8oq9+WAhe5968c7IGCJcfvJThl7njBegI7XHMVorX7ye0UgT14/ITh0d
         /lqybHtS3TyRTZb8dqMvB9Lg2hGnrQ6LiNaQoTovdhjkjROCiMXy7bVgnQEXMs7K8PQ4
         mkbsAhQAjxbyp1EPM9Hd0E3ssI01lOKoHfq1HFrBbwf1Mh1Y0lrHyeuGgIXdwaPyX87F
         BQlPf2T2nxXJGGGtnU5vtsNb0ZZE0w/ykI181Xme0X3adhrIDLJZEvTO33pE0ckQUYPm
         OMl24RAI+CXCKVxJ8VN9XhIVVMzIFVu9A8lM1f2e1VUM8Xi9BLYCfMiZda9oQTU+n3JR
         gnHg==
X-Gm-Message-State: AOAM533MhjVQfqDvRw7HPcN5A+3c+sSKimzpZNlnque9w8dJnSLO+vcR
        c55aXpJ6sLET7znFrFG4MPg=
X-Google-Smtp-Source: ABdhPJz4mGtNwyXniyqTQXxvLJESSpe3i+QgNK3ZGA+hZ/7qyJGFX52e/hTaqd40mYeRJEgEE2MU9g==
X-Received: by 2002:a50:bf48:: with SMTP id g8mr27269492edk.10.1633817836282;
        Sat, 09 Oct 2021 15:17:16 -0700 (PDT)
Received: from fedora.. (dh207-99-195.xnet.hr. [88.207.99.195])
        by smtp.googlemail.com with ESMTPSA id kd8sm1405151ejc.69.2021.10.09.15.17.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 15:17:15 -0700 (PDT)
From:   Robert Marko <robimarko@gmail.com>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Robert Marko <robimarko@gmail.com>
Subject: [PATCH] ath10k: support bus and device specific API 1 BDF selection
Date:   Sun, 10 Oct 2021 00:17:11 +0200
Message-Id: <20211009221711.2315352-1-robimarko@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some ath10k IPQ40xx devices like the MikroTik hAP ac2 and ac3 require the
BDF-s to be extracted from the device storage instead of shipping packaged
API 2 BDF-s.

This is required as MikroTik has started shipping boards that require BDF-s
to be updated, as otherwise their WLAN performance really suffers.
This is however impossible as the devices that require this are release
under the same revision and its not possible to differentiate them from
devices using the older BDF-s.

In OpenWrt we are extracting the calibration data during runtime and we are
able to extract the BDF-s in the same manner, however we cannot package the
BDF-s to API 2 format on the fly and can only use API 1 to provide BDF-s on
the fly.
This is an issue as the ath10k driver explicitly looks only for the
board.bin file and not for something like board-bus-device.bin like it does
for pre-cal data.
Due to this we have no way of providing correct BDF-s on the fly, so lets
extend the ath10k driver to first look for BDF-s in the
board-bus-device.bin format, for example: board-ahb-a800000.wifi.bin
If that fails, look for the default board file name as defined previously.

Signed-off-by: Robert Marko <robimarko@gmail.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 2f9be182fbfb..20a448e099d8 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1182,6 +1182,7 @@ static int ath10k_fetch_cal_file(struct ath10k *ar)
 static int ath10k_core_fetch_board_data_api_1(struct ath10k *ar, int bd_ie_type)
 {
 	const struct firmware *fw;
+	char boardname[100];
 
 	if (bd_ie_type == ATH10K_BD_IE_BOARD) {
 		if (!ar->hw_params.fw.board) {
@@ -1189,9 +1190,16 @@ static int ath10k_core_fetch_board_data_api_1(struct ath10k *ar, int bd_ie_type)
 			return -EINVAL;
 		}
 
+		scnprintf(boardname, sizeof(boardname), "board-%s-%s.bin",
+			  ath10k_bus_str(ar->hif.bus), dev_name(ar->dev));
+
 		ar->normal_mode_fw.board = ath10k_fetch_fw_file(ar,
 								ar->hw_params.fw.dir,
-								ar->hw_params.fw.board);
+								boardname);
+		if (IS_ERR(ar->normal_mode_fw.board))
+			ar->normal_mode_fw.board = ath10k_fetch_fw_file(ar,
+									ar->hw_params.fw.dir,
+									ar->hw_params.fw.board);
 		if (IS_ERR(ar->normal_mode_fw.board))
 			return PTR_ERR(ar->normal_mode_fw.board);
 
-- 
2.33.0

