Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB1766774EE
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 06:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbjAWFb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 00:31:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbjAWFby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 00:31:54 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD4F5DBD4
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 21:31:52 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id v23so10377349plo.1
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 21:31:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=schmorgal.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rfXdSlIJ0cEFfvBNKtU4aYKvXeb4DfwYM4tZyFqSEdc=;
        b=ih0EjG00ea+2ztE9XCzNv9W6pqfROzGcCZ8SWfvI+vHwyOAdMQCUn/0r9IPTIE8u/h
         SjMvF3iokqVjfRzdydmw9zsyvc2tfcBEQ8DYXkKT3MixzLGyV+Na73e/38bDPUqfoiPW
         hwjydWUe0z1EmwzvqI/Srl+X0F69lXfEZPH7s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rfXdSlIJ0cEFfvBNKtU4aYKvXeb4DfwYM4tZyFqSEdc=;
        b=Wn17ThhPKT10qygYb4VzFaILlrIgmVyxYjFBU3e+zmdUSrf2Z9DCTmxwOznciK2w+D
         d7o6pL3a2tJ+N8FoDz3RVDc3rSH5dpVqMEBY1oXreh9ZgDIkAKggc3DkG3nvZAdycgLB
         nDevud+07KrgUMGtg5/NEFEDv5TnmnKnNkGZp5G9QE6NWwgjnIlpKHlZn5y8iUoAxqYU
         SuxRulC08OQrU70jwtH8R1UFj21qDjN2Cpb3r69VCw5vHpzi+QZI4HBoYtmXwKy56ipK
         tZcnEm6vUIkxAWnHe0U8bHLjMpyfgVgeI2yiIqVNSnz+nxHjU4L1BeSH89FY5fn5sI4c
         Dh4w==
X-Gm-Message-State: AFqh2krO94dCjY7AQ3XWreUDu6CXW58MmE5Mgqx9InZUBO58fp0d2w3q
        kbNF04PROCm4JGoAFKzp3aC//Q==
X-Google-Smtp-Source: AMrXdXtOV3kmCwv5ekVJNfkJSJYf4uUHeSmdkttcMW4+fycMcvN52M3ggMj5J7NT7Aa+K7OJLLhjlQ==
X-Received: by 2002:a17:902:e847:b0:194:7cd3:329a with SMTP id t7-20020a170902e84700b001947cd3329amr31411263plg.10.1674451912064;
        Sun, 22 Jan 2023 21:31:52 -0800 (PST)
Received: from doug-ryzen-5700G.. ([192.183.212.197])
        by smtp.gmail.com with ESMTPSA id m3-20020a170902db0300b0018963b8e131sm9125244plx.290.2023.01.22.21.31.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Jan 2023 21:31:51 -0800 (PST)
From:   Doug Brown <doug@schmorgal.com>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Dan Williams <dcbw@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Doug Brown <doug@schmorgal.com>
Subject: [PATCH v4 0/4] wifi: libertas: IE handling fixes
Date:   Sun, 22 Jan 2023 21:31:28 -0800
Message-Id: <20230123053132.30710-1-doug@schmorgal.com>
X-Mailer: git-send-email 2.34.1
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

This series implements two fixes for the libertas driver that restore
compatibility with modern wpa_supplicant versions, and adds (or at least
improves) support for WPS in the process.

1) Better handling of the RSN/WPA IE in association requests:
   The previous logic was always just grabbing the first one, and didn't
   handle multiple IEs properly, which wpa_supplicant adds nowadays.

2) Support for IEs in scan requests:
   Modern wpa_supplicant always adds an "extended capabilities" IE,
   which violates max_scan_ie_len in this driver. Go ahead and allow
   scan IEs, and handle WPS based on the info that Dan provided.

These changes have been tested on a Marvell PXA168-based device with a
Marvell 88W8686 Wi-Fi chipset. I've confirmed that with these changes
applied, modern wpa_supplicant versions connect properly and WPS also
works correctly (tested with "wpa_cli -i wlan0 wps_pbc any").

Changes since V3:
- Do more extensive code style fixes suggested by Ping-Ke Shih

Changes since V2:
- Add missing cpu_to_le16 as suggested by Simon Horman

Changes since V1 (which was a single patch linked here [1]):

- Switch to cfg80211_find_*_elem when looking for specific IEs,
  resulting in cleaner/safer code.
- Use mrvl_ie_data struct for cleaner manipulation of TLV buffer, and
  fix capitalization of the "data" member to avoid checkpatch warnings.
- Implement idea suggested by Dan to change max_scan_ie_len to be
  nonzero and enable WPS support in probe requests while we're at it.
- Remove "Fixes:" tag; I'm not sure if it's still appropriate or not
  with it depending on the capitalization fix.
- Clarify comments.

[1] https://lore.kernel.org/all/20230102234714.169831-1-doug@schmorgal.com/

Doug Brown (4):
  wifi: libertas: fix code style in Marvell structs
  wifi: libertas: only add RSN/WPA IE in lbs_add_wpa_tlv
  wifi: libertas: add new TLV type for WPS enrollee IE
  wifi: libertas: add support for WPS enrollee IE in probe requests

 drivers/net/wireless/marvell/libertas/cfg.c   | 76 +++++++++++++++----
 drivers/net/wireless/marvell/libertas/types.h | 21 ++---
 2 files changed, 74 insertions(+), 23 deletions(-)

-- 
2.34.1

