Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14E16315B9E
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 01:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233945AbhBJAtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 19:49:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234526AbhBJApx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 19:45:53 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EED5C061221
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 16:42:39 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id i20so276915otl.7
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 16:42:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lSxRQe0NkuXvIC4LukBFAaQnS+eadT8rfkVxfIWM+A0=;
        b=CALrMMBCEUbB8CMtagKUhuHyyPH7YzI4dGisIXZAIC0QFUvYm0rwn/tZPFXXErx5QM
         GP8j/k1nlTROOjPRVG3EoZbP3sg8sWz61Bu9aFzBxZw7XvaFI1lVTf1FeaXnSZri5hY8
         qBhy39vwsrJqLSQLOVw+fq5m2l8KLvuKd+3Wo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lSxRQe0NkuXvIC4LukBFAaQnS+eadT8rfkVxfIWM+A0=;
        b=Y+I//yLsnLFfsE0UkChapoSjF045YUyYlaGG2QrhjJUIi+FmMF/0/SB1lFLaWQ9M5I
         1Cdf657Qm5RTIK6z5ybgjRXR7BCNuPYZVi0SEt1yK777j0cpk+DPEyWYAlXrmKn9wG2H
         brjD+Mllr2xCmklksAcJ3CpVymVsw9vueDKTtetmo+4K2sHLAtA2GxeQ6AHfhfxhMTuV
         MOsW271AYr/68twcZMsFvjCFoXR1k900glHlIuKxs7PAvR9zza6TEE1Veh9HQ/IhE4ia
         CH0g52HnlMORJxdaoGShe7qiByi/m3DvyGJT3ufW5FTHOH/KRYX0EjO0CFP46CXN9w5F
         qp2Q==
X-Gm-Message-State: AOAM533FAIIf8g9Cv3PdAKJcoBJOavuNVDpNDWrb/SAjwRZrlHh3gFLF
        OIG/0DWquYOoov9Tlsr3kNu0IQ==
X-Google-Smtp-Source: ABdhPJwhMYzaqq232uAzJkcr5mlDWVQmCT0WHImd9fGHVfEjYCTxeS0NBNDzY8hl72uY1rvdPGJLLA==
X-Received: by 2002:a9d:6003:: with SMTP id h3mr243308otj.23.1612917758613;
        Tue, 09 Feb 2021 16:42:38 -0800 (PST)
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id s123sm103060oos.3.2021.02.09.16.42.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 16:42:38 -0800 (PST)
From:   Shuah Khan <skhan@linuxfoundation.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] ath10k: reduce invalid ht params rate message noise
Date:   Tue,  9 Feb 2021 17:42:26 -0700
Message-Id: <76a816d983e6c4d636311738396f97971b5523fb.1612915444.git.skhan@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1612915444.git.skhan@linuxfoundation.org>
References: <cover.1612915444.git.skhan@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ath10k_mac_get_rate_flags_ht() floods dmesg with the following messages,
when it fails to find a match for mcs=7 and rate=1440.

supported_ht_mcs_rate_nss2:
{7,  {1300, 2700, 1444, 3000} }

ath10k_pci 0000:02:00.0: invalid ht params rate 1440 100kbps nss 2 mcs 7

dev_warn_ratelimited() isn't helping the noise. Use dev_warn_once()
instead.

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 3545ce7dce0a..276321f0cfdd 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -8970,8 +8970,9 @@ static void ath10k_mac_get_rate_flags_ht(struct ath10k *ar, u32 rate, u8 nss, u8
 		*bw |= RATE_INFO_BW_40;
 		*flags |= RATE_INFO_FLAGS_SHORT_GI;
 	} else {
-		ath10k_warn(ar, "invalid ht params rate %d 100kbps nss %d mcs %d",
-			    rate, nss, mcs);
+		dev_warn_once(ar->dev,
+			      "invalid ht params rate %d 100kbps nss %d mcs %d",
+			      rate, nss, mcs);
 	}
 }
 
-- 
2.27.0

