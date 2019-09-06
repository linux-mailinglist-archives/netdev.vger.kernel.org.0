Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0E2BAC07B
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 21:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393142AbfIFTYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 15:24:12 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42834 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392989AbfIFTYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 15:24:10 -0400
Received: by mail-pg1-f193.google.com with SMTP id p3so4016553pgb.9
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 12:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=android.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=no7kS2T1qNHP9Zpdwy1E09Unjz4x2T2LCFjYktICQgk=;
        b=EvVkZs2J1AZ9GTp9kf0rnbiW9t2ITXImmd49lXjLrxM2btzrl5yd/T4Hcqo/dKLr6y
         Q5j5C5pCfxhbgmewV0/bNfJQ11TPyEMOE3jrODvA82aEojWf9Qagh/WFcF6vaHbvq6Pv
         ev3h/NdCyySH/YJt+JjM3K4bz5MFm47zXRTobzyogztVYzdQs9Ly0u15OSUf5Lk/j6SB
         RG9fVhihQPPSJt2EGqZ3gtgMX2daLtUNhaDhavGZdofleGMAejroOkOi4OGSv8cP+w2i
         XxbWLbE+QmfgowhG25brlvJTcvLuXFDfSOxclhU2h1c30ee7cuEd8IGt1UjKfFDGlYwa
         Rd3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=no7kS2T1qNHP9Zpdwy1E09Unjz4x2T2LCFjYktICQgk=;
        b=WCAKf9xZ1Buxb4sOB157AvkeSko2JRi1fbKcPlG3ZBo8GlmCLjd/NvmRZMwbSB52dh
         yeHDBdtc1DioFF3kh9gr1GoqNoxwmTuu+uVXzc8ZKeJ00Y7q1+w8yVjgJoM0XFIaLSmK
         2WDPPkWnljrridWqoct79ALIB0kFgFXa670QIvj0PsWxhv1jkVfBjAkdstR4Sv+QSm6i
         EJRg1Xffv+SThEPXKJ87Q3AwELwJJNzC/1TyxO8HSHZwZ8SRZZlbsamvEfYOxS0YUVV8
         CZ9fDs8ebzRAokYaMXljYycC4pQxc4DYxMH+kABu+5VTWb4Q6SM6QdE2o5AJV6Jt65Pj
         FBuw==
X-Gm-Message-State: APjAAAU18DB+Xjp9qeIKwOEs0i0x+vCbyhLgilwxTLcpkgzeBxXynsZy
        ZMc+KH48NhFnmmjJaWAsNF2SzA==
X-Google-Smtp-Source: APXvYqxHNghJveR3zrEVoimn0Wso+4JUVbYfHGnGsGo9B8NC/uWVASyxOZhZvPVLoA9ALyNt2tAvJw==
X-Received: by 2002:a65:64c5:: with SMTP id t5mr9650538pgv.168.1567797849694;
        Fri, 06 Sep 2019 12:24:09 -0700 (PDT)
Received: from nebulus.mtv.corp.google.com ([2620:15c:211:200:5404:91ba:59dc:9400])
        by smtp.gmail.com with ESMTPSA id b24sm7024169pfi.75.2019.09.06.12.24.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2019 12:24:09 -0700 (PDT)
From:   Mark Salyzyn <salyzyn@android.com>
To:     linux-kernel@vger.kernel.org
Cc:     kernel-team@android.com, Mark Salyzyn <salyzyn@android.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Marcel Holtmann <marcel@holtmann.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v2] net: enable wireless core features with LEGACY_WEXT_ALLCONFIG
Date:   Fri,  6 Sep 2019 12:24:00 -0700
Message-Id: <20190906192403.195620-1-salyzyn@android.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In embedded environments the requirements are to be able to pick and
chose which features one requires built into the kernel.  If an
embedded environment wants to supports loading modules that have been
kbuilt out of tree, there is a need to enable hidden configurations
for legacy wireless core features to provide the API surface for
them to load.

Introduce CONFIG_LEGACY_WEXT_ALLCONFIG to select all legacy wireless
extension core features by activating in turn all the associated
hidden configuration options, without having to specifically select
any wireless module(s).

Signed-off-by: Mark Salyzyn <salyzyn@android.com>
Cc: kernel-team@android.com
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org # 4.19
---
v2: change name and documentation to CONFIG_LEGACY_WEXT_ALLCONFIG
---
 net/wireless/Kconfig | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index 67f8360dfcee..0d646cf28de5 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -17,6 +17,20 @@ config WEXT_SPY
 config WEXT_PRIV
 	bool
 
+config LEGACY_WEXT_ALLCONFIG
+	bool "allconfig for legacy wireless extensions"
+	select WIRELESS_EXT
+	select WEXT_CORE
+	select WEXT_PROC
+	select WEXT_SPY
+	select WEXT_PRIV
+	help
+	  Config option used to enable all the legacy wireless extensions to
+	  the core functionality used by add-in modules.
+
+	  If you are not building a kernel to be used for a variety of
+	  out-of-kernel built wireless modules, say N here.
+
 config CFG80211
 	tristate "cfg80211 - wireless configuration API"
 	depends on RFKILL || !RFKILL
-- 
2.23.0.187.g17f5b7556c-goog

