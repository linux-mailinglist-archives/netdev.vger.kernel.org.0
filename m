Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAAFE6612E2
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 02:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbjAHBax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 20:30:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbjAHBaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 20:30:52 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9545FEA
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 17:30:50 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id z7so3719152pfq.13
        for <netdev@vger.kernel.org>; Sat, 07 Jan 2023 17:30:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=schmorgal.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aukUG7G4mJzk2l5eLMtMhDac84dRtZO/NL0wRxvV5bk=;
        b=Ijxb/24IC1QEwcFPwKJk4vJx2f6a8zMHcCVr/IsNjIGR2KzZbwDO35AJaWgi1jyKrW
         WSM+WXH6JOT9P065y2RaXl8S4f3Qn50st7OBaUbdPoRUy8Up0tjjEOEUM70mE9Wezpwo
         w36HUDl/gULXddw8GGTNXSf5mmaJjmgRY+6BM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aukUG7G4mJzk2l5eLMtMhDac84dRtZO/NL0wRxvV5bk=;
        b=j1fNDDEsgOmVPRBWhlHaqNPvUfuw0pMrI8t8BsUxxzhdelOYiCzFJCIB7v+7sZjvFD
         JBTc6rUDTXvDW13SRUsPiF3NP1UfMEzVkkljbGJLuTRbNjY8YWkpYn17fwX13mw1GswC
         Dy88r5tBbeKGmBle6ti+NoDtkB/5waxx4I2J8WdfMPVayrnapame+c+S8dXSn+lnTiB6
         QinKYnLDQfrKsdXmZdNkAHFRYZuJrLUWUKmJB43wVHglMHg4890opOX/d6SjG3ieGh9n
         a+38XnLdPb+H3f0ikx8GLmw4pCsJ9OQgxHPOL5SHmdv0Y+VGxmEvX16JcphU3DBLNEac
         xB8w==
X-Gm-Message-State: AFqh2krKWKvh+pLkV4CQJTTMZO2Ks/HL4gf7ErQC1HfqKf8ID9rhcZQc
        5Ju7OyMR1E48fWcvdeJtm1yKMA==
X-Google-Smtp-Source: AMrXdXt1YyhzMqHrXb31aa2EUig1lyLxmOXR47HOZG7xnl6pDXO98PqEkXxynRd/lMzDNFeB/mp3Tw==
X-Received: by 2002:a05:6a00:d4e:b0:581:a2b6:df19 with SMTP id n14-20020a056a000d4e00b00581a2b6df19mr34548691pfv.14.1673141450142;
        Sat, 07 Jan 2023 17:30:50 -0800 (PST)
Received: from doug-ryzen-5700G.. ([192.183.212.197])
        by smtp.gmail.com with ESMTPSA id x14-20020aa79a4e000000b005811c421e6csm3323714pfj.162.2023.01.07.17.30.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Jan 2023 17:30:49 -0800 (PST)
From:   Doug Brown <doug@schmorgal.com>
To:     Dan Williams <dcbw@redhat.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Doug Brown <doug@schmorgal.com>
Subject: [PATCH v2 0/4] wifi: libertas: IE handling fixes
Date:   Sat,  7 Jan 2023 17:30:12 -0800
Message-Id: <20230108013016.222494-1-doug@schmorgal.com>
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
compatibility with modern wpa_supplicant versions, and adds support for
WPS in the process.

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

Dan, I wanted to point out that based on my packet sniffing, I
determined that the 0x011B TLV automatically wraps its contents in a
vendor-specific IE header. I may have misunderstood and you were already
saying that, but I wanted to clarify just to be sure. If I explicitly
included the WPS IE's 2-byte 0xDD/length header inside of the TLV data,
I ended up with a duplicate 0xDD, with the outer one having a length
that was 2 more than the inner/original. Wireshark barfed on it.

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
  wifi: libertas: fix capitalization in mrvl_ie_data struct
  wifi: libertas: only add RSN/WPA IE in lbs_add_wpa_tlv
  wifi: libertas: add new TLV type for WPS enrollee IE
  wifi: libertas: add support for WPS enrollee IE in probe requests

 drivers/net/wireless/marvell/libertas/cfg.c   | 76 +++++++++++++++----
 drivers/net/wireless/marvell/libertas/types.h |  3 +-
 2 files changed, 65 insertions(+), 14 deletions(-)

-- 
2.34.1

