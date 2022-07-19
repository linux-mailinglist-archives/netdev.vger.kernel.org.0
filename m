Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA55957A1CB
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239339AbiGSOiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239094AbiGSOiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:38:04 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4DB63D1
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 07:33:06 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id b26so21903363wrc.2
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 07:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jiozccj2BWurN83Zaln6WR8wVlsBuIbAtfwjePxJ5xs=;
        b=j/V8yV4AbNrAU2b5xvM7uHGvCPL5wd4kdmsVRgW4vNI0wv2i8dS/VP2HVycxtAwMF1
         DjVT3SXO/YmKX3A3B5Ox0/gKOkwwOTRFtSXILdjJE0oCSJGUz8TsZGyBmAsyzdP46yge
         ovgW9QNXCgJqjkEaeETj9DzoSi1NFYNBJeQb2LgQluwm5roW+jL6PlYjQ2gVp5Ymju3x
         iDAK45AMynZT9nG/nh19GGSjcs+jgcpJOD3e84fLkNUZ9jBc8wYScqCtltlTU/3pfBCI
         nioRyoYOFfJr9jtx6ONhBYchnl913v4vU0ipujFYb2EOO79xQQqf0UbDdtn34sUD4wzT
         YLzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jiozccj2BWurN83Zaln6WR8wVlsBuIbAtfwjePxJ5xs=;
        b=bTFBJ6D7SwAl+F1EzjbRrF5I6c7JCnWqI2E8QcsYVFfJIN0m75PYpY8Mq1nmhI6omH
         XODekS4UM0IA6ofOum8hwyrBk/Qe0J+A2fTeSn1uhoBYukO6jqQTPFlE3UZcGtSehbt5
         lA3gv4CEkW6TEgRe9SemWNzRdsMVE27roFs7nsNdwoMyn77bEDrCFSkZNsZozPgSrPJ/
         zzeWTLj9jUrCbUhByBShuOTPFJ4Q+gT95fiL3wxdlXQqXMhi74iGbRFzvb//MX6AMVMc
         IsE+sq4jNribPGrM4xtS/iw3+9sJUyJbEvkEsewPR9Xsc2buv/sP3y8hNbl6NfKy8xMJ
         Id3w==
X-Gm-Message-State: AJIora8CbXFD0RAgbHxWs3+hjwnqZ5MjFGPXK5Y9N6iil7xjfuoykD7L
        VQujSe5p9icYUldQXERwvHLVHA==
X-Google-Smtp-Source: AGRyM1vQmoXmOhtVatOyF2FdR1hMdhsDHe0jUtpokkckhskc9E3/56zBV+6kRy21p8RYBAN5/XPJ8g==
X-Received: by 2002:a05:6000:249:b0:21d:a952:31f1 with SMTP id m9-20020a056000024900b0021da95231f1mr27733640wrz.411.1658241185157;
        Tue, 19 Jul 2022 07:33:05 -0700 (PDT)
Received: from sagittarius-a.chello.ie (188-141-3-169.dynamic.upc.ie. [188.141.3.169])
        by smtp.gmail.com with ESMTPSA id d15-20020adffbcf000000b0020fff0ea0a3sm13634378wrs.116.2022.07.19.07.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 07:33:04 -0700 (PDT)
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
To:     kvalo@kernel.org, loic.poulain@linaro.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        bryan.odonoghue@linaro.org
Subject: [PATCH v2 0/4] wcn36xx: Add in debugfs export of firmware feature bits
Date:   Tue, 19 Jul 2022 15:32:58 +0100
Message-Id: <20220719143302.2071223-1-bryan.odonoghue@linaro.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75 autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

V2:
Drops "FW Cap = " prefix from each feature item - Loic

cat /sys/kernel/debug/ieee80211/phy0/wcn36xx/firmware_feat_caps 
MCC
P2P
DOT11AC
SLM_SESSIONIZATION
DOT11AC_OPMODE
SAP32STA
TDLS
P2P_GO_NOA_DECOUPLE_INIT_SCAN
WLANACTIVE_OFFLOAD
BEACON_OFFLOAD
SCAN_OFFLOAD
BCN_MISS_OFFLOAD
STA_POWERSAVE
STA_ADVANCED_PWRSAVE
BCN_FILTER
RTT
RATECTRL
WOW
WLAN_ROAM_SCAN_OFFLOAD
SPECULATIVE_PS_POLL
IBSS_HEARTBEAT_OFFLOAD
WLAN_SCAN_OFFLOAD
WLAN_PERIODIC_TX_PTRN
ADVANCE_TDLS
BATCH_SCAN
FW_IN_TX_PATH
EXTENDED_NSOFFLOAD_SLOT
CH_SWITCH_V1
HT40_OBSS_SCAN
UPDATE_CHANNEL_LIST
WLAN_MCADDR_FLT
WLAN_CH144
TDLS_SCAN_COEXISTENCE
LINK_LAYER_STATS_MEAS
MU_MIMO
EXTENDED_SCAN
DYNAMIC_WMM_PS
MAC_SPOOFED_SCAN
FW_STATS
WPS_PRBRSP_TMPL
BCN_IE_FLT_DELTA

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
 drivers/net/wireless/ath/wcn36xx/debug.c    |  37 ++++++
 drivers/net/wireless/ath/wcn36xx/debug.h    |   1 +
 drivers/net/wireless/ath/wcn36xx/firmware.c | 125 ++++++++++++++++++++
 drivers/net/wireless/ath/wcn36xx/firmware.h |  84 +++++++++++++
 drivers/net/wireless/ath/wcn36xx/hal.h      |  68 -----------
 drivers/net/wireless/ath/wcn36xx/main.c     |  86 ++------------
 drivers/net/wireless/ath/wcn36xx/smd.c      |  57 ++-------
 drivers/net/wireless/ath/wcn36xx/smd.h      |   3 -
 9 files changed, 264 insertions(+), 200 deletions(-)
 create mode 100644 drivers/net/wireless/ath/wcn36xx/firmware.c
 create mode 100644 drivers/net/wireless/ath/wcn36xx/firmware.h

-- 
2.36.1

