Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC47C582A72
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 18:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234803AbiG0QRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 12:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbiG0QRA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 12:17:00 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A6412D2B
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 09:16:59 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id h9so25229888wrm.0
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 09:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xtL8vSInFUl8C/6EzAwgwZ1g8R0SH+mlFdNxondG6VM=;
        b=L5J41i3HeSHIXhZiJ2IAdTA+bfA64HsMnn6kufgLIMbFHi+X9zEIwgnljD43gLDnxT
         1AKTQ+K318ze5f4LqgMMncfL5M5leE2kB+qTiocoansVmuZTKiX41HlYG4xP8yXf8y6G
         N6TXFwKbQs5pNMJC6SBBY3FnXNzq6aVnaz9JDLUu+zAIad/ZebIalujpSwhi3zDFGnLZ
         Rflv0LXPx3cbZYFnC9wwfzG0xfWAffdq60YR5HYoZncRwVXvL/XThRbVZoOngPPgvFhV
         YGvwPXRUsiWV9Qt3oAG7yFK5rPi2MGGom1miKpzPTiBGA7jPBGxuijCsLpRi9NvRVTiP
         ARNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xtL8vSInFUl8C/6EzAwgwZ1g8R0SH+mlFdNxondG6VM=;
        b=S4DUyl5oZNH62TDBpMQ5YS6BjW3Lc05BjWEJvjEk5JRmYLQizRy9lk9AtqibzBz+kD
         umsxFnkZ+4sV6Qq3tpRAKg4NbXbgC5P1ZW7PtQGbma7udITC6a3QQbIAWsoMqcQR3lUV
         RZdJ6lPgGoG6AgBloOSX+PFC+0JLYs0bESoFWfUrLET06TqeDYf2WVeM+f1WYPBOBuj0
         LQivoqhjYEiT1T1tOr4IG3DiGjIP08EUZcODJ71AvNP8kY5HEHiNk3JDQBIefMr22I/j
         t0XYmGJSY3lZoRt8WH3FLvIpxDUnLne0yW7LcRoxfAA1VqZ+M3Sc1tfHo8Y/+3iPebNF
         Rmlw==
X-Gm-Message-State: AJIora/h+ai+jp8uPaOUpBX1ZtwCoU+qB3OobZK4r4YeCEIeaEuH7GhT
        dlnG+tO3brPgzEwMKNcJo8Kzrw==
X-Google-Smtp-Source: AGRyM1syLBtUxyOb4DeFEWlEqFXKln1pr0DFer482bcOWdkJij1IkHxbJJ0eDqBWBmHEZUQcJA1GeA==
X-Received: by 2002:a5d:63ca:0:b0:21e:b7be:668f with SMTP id c10-20020a5d63ca000000b0021eb7be668fmr4818278wrw.272.1658938617479;
        Wed, 27 Jul 2022 09:16:57 -0700 (PDT)
Received: from sagittarius-a.chello.ie (188-141-3-169.dynamic.upc.ie. [188.141.3.169])
        by smtp.gmail.com with ESMTPSA id l4-20020a05600012c400b0021e4829d359sm17245474wrx.39.2022.07.27.09.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 09:16:56 -0700 (PDT)
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
To:     kvalo@kernel.org, loic.poulain@linaro.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, bryan.odonoghue@linaro.org
Subject: [PATCH v3 0/4] wcn36xx: Add in debugfs export of firmware feature bits
Date:   Wed, 27 Jul 2022 17:16:51 +0100
Message-Id: <20220727161655.2286867-1-bryan.odonoghue@linaro.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

V3:
- Adds RB from Loic for 3/4 patches - Loic
- Leaves RB from Loic out of patch 4/4 which has been updated since - bod
- Uses kzalloc/kfree for memory allocation - Kalle
- Co-locates memory check adjacent to memory allocation - Kalle
- Uses scnprintf instead of sprintf - bod

V2:
- Drops "FW Cap = " prefix from each feature item - Loic

V1:
This series tidies up the code to get/set/clear discovered firmware feature
bits and adds a new debugfs entry to read the feature bits as strings.

cat /sys/kernel/debug/ieee80211/phy0/wcn36xx/firmware_feat_caps

wcn3680b:
FW Cap = MCC
FW Cap = P2P
FW Cap = DOT11AC
FW Cap = SLM_SESSIONIZATION
FW Cap = DOT11AC_OPMODE
FW Cap = SAP32STA
FW Cap = TDLS
FW Cap = P2P_GO_NOA_DECOUPLE_INIT_SCAN
FW Cap = WLANACTIVE_OFFLOAD
FW Cap = BEACON_OFFLOAD
FW Cap = SCAN_OFFLOAD
FW Cap = BCN_MISS_OFFLOAD
FW Cap = STA_POWERSAVE
FW Cap = STA_ADVANCED_PWRSAVE
FW Cap = BCN_FILTER
FW Cap = RTT
FW Cap = RATECTRL
FW Cap = WOW
FW Cap = WLAN_ROAM_SCAN_OFFLOAD
FW Cap = SPECULATIVE_PS_POLL
FW Cap = IBSS_HEARTBEAT_OFFLOAD
FW Cap = WLAN_SCAN_OFFLOAD
FW Cap = WLAN_PERIODIC_TX_PTRN
FW Cap = ADVANCE_TDLS
FW Cap = BATCH_SCAN
FW Cap = FW_IN_TX_PATH
FW Cap = EXTENDED_NSOFFLOAD_SLOT
FW Cap = CH_SWITCH_V1
FW Cap = HT40_OBSS_SCAN
FW Cap = UPDATE_CHANNEL_LIST
FW Cap = WLAN_MCADDR_FLT
FW Cap = WLAN_CH144
FW Cap = TDLS_SCAN_COEXISTENCE
FW Cap = LINK_LAYER_STATS_MEAS
FW Cap = MU_MIMO
FW Cap = EXTENDED_SCAN
FW Cap = DYNAMIC_WMM_PS
FW Cap = MAC_SPOOFED_SCAN
FW Cap = FW_STATS
FW Cap = WPS_PRBRSP_TMPL
FW Cap = BCN_IE_FLT_DELTA

wcn3620:
FW Cap = MCC
FW Cap = P2P
FW Cap = SLM_SESSIONIZATION
FW Cap = DOT11AC_OPMODE
FW Cap = SAP32STA
FW Cap = TDLS
FW Cap = P2P_GO_NOA_DECOUPLE_INIT_SCAN
FW Cap = WLANACTIVE_OFFLOAD
FW Cap = BEACON_OFFLOAD
FW Cap = SCAN_OFFLOAD
FW Cap = BCN_MISS_OFFLOAD
FW Cap = STA_POWERSAVE
FW Cap = STA_ADVANCED_PWRSAVE
FW Cap = BCN_FILTER
FW Cap = RTT
FW Cap = RATECTRL
FW Cap = WOW
FW Cap = WLAN_ROAM_SCAN_OFFLOAD
FW Cap = SPECULATIVE_PS_POLL
FW Cap = IBSS_HEARTBEAT_OFFLOAD
FW Cap = WLAN_SCAN_OFFLOAD
FW Cap = WLAN_PERIODIC_TX_PTRN
FW Cap = ADVANCE_TDLS
FW Cap = BATCH_SCAN
FW Cap = FW_IN_TX_PATH
FW Cap = EXTENDED_NSOFFLOAD_SLOT
FW Cap = CH_SWITCH_V1
FW Cap = HT40_OBSS_SCAN
FW Cap = UPDATE_CHANNEL_LIST
FW Cap = WLAN_MCADDR_FLT
FW Cap = WLAN_CH144
FW Cap = TDLS_SCAN_COEXISTENCE
FW Cap = LINK_LAYER_STATS_MEAS
FW Cap = EXTENDED_SCAN
FW Cap = DYNAMIC_WMM_PS
FW Cap = MAC_SPOOFED_SCAN
FW Cap = FW_STATS
FW Cap = WPS_PRBRSP_TMPL
FW Cap = BCN_IE_FLT_DELTA

This is a handy way of debugging WiFi on different platforms without
necessarily having to recompile to see the debug printout on firmware boot.

Bryan O'Donoghue (4):
  wcn36xx: Rename clunky firmware feature bit enum
  wcn36xx: Move firmware feature bit storage to dedicated firmware.c
    file
  wcn36xx: Move capability bitmap to string translation function to
    firmware.c
  wcn36xx: Add debugfs entry to read firmware feature strings

 drivers/net/wireless/ath/wcn36xx/Makefile   |   3 +-
 drivers/net/wireless/ath/wcn36xx/debug.c    |  40 +++++++
 drivers/net/wireless/ath/wcn36xx/debug.h    |   1 +
 drivers/net/wireless/ath/wcn36xx/firmware.c | 125 ++++++++++++++++++++
 drivers/net/wireless/ath/wcn36xx/firmware.h |  84 +++++++++++++
 drivers/net/wireless/ath/wcn36xx/hal.h      |  68 -----------
 drivers/net/wireless/ath/wcn36xx/main.c     |  86 ++------------
 drivers/net/wireless/ath/wcn36xx/smd.c      |  57 ++-------
 drivers/net/wireless/ath/wcn36xx/smd.h      |   3 -
 9 files changed, 267 insertions(+), 200 deletions(-)
 create mode 100644 drivers/net/wireless/ath/wcn36xx/firmware.c
 create mode 100644 drivers/net/wireless/ath/wcn36xx/firmware.h

-- 
2.36.1

