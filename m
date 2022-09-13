Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05E645B7D93
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 01:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbiIMXhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 19:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbiIMXhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 19:37:22 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C41A71BEE
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 16:37:19 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id bu13-20020a056902090d00b00671743601f1so11416236ybb.0
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 16:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=NwGQODpxaIQjq2Q9i7xww6BX9L+zJmLaZqsIG4X4HwQ=;
        b=o4kOxYovTq8PJdbtLFHNsCuRZnYOxfFbUklDCum1if7Egy/oOVrLZccjBiHzq5BXuR
         HQFB4ufGVJe1EForw5n8XYdu13KQ21Jwpy0r8gcfLeBszXy1Phx3faimJZyxO37aXLOp
         YUYAH3/1WvyO3nP8fCCVDCpiVONvC+o2oLf+5sLG/VvnPA8UotxYhrM4nCJ4+/Z1GEz7
         XkEDwRlsiGrs8TsCQbv0cdQm8Oz6ibzUN3tKMehKP02NX/iFzuc8K6BUYYwhuF/pOyKD
         xwc/6jQHuSnUGzzuBLKblrDN9Xv0hArYEZKA2TvN7tKApcijJ5Fd2qwZO6MBZy6cuSMN
         nggQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=NwGQODpxaIQjq2Q9i7xww6BX9L+zJmLaZqsIG4X4HwQ=;
        b=EEboIqU7yKictLI2tOWUIFSxl0G0Tl3s+AbTRwjipklTZS2Za0xCErF8sW+Ct4yfgy
         Ug9H1jpgX4mSrM4a7ztYnvb+oubS2sWbHEfSO2IqHcF0b/HIomgrFY6gk7eUiWDh+9lq
         g4wWvAPuef+yzDKvNEJ1nglvk6+QUzos6KKEfGFpxynD2vmlt4L4yApc/kyD0ebgkhGF
         /blPKIMCjsn3553p3hrL1j2gPzkf5LoTgN0V2sdmLDOKVGejcUZfjf2AHixvefM+mSxM
         2xShlkzVkPvFDAwX52y9RtfVm3gZojbuv9Uq0p+5Xm09V4IhuHkEf5dqZ2dhdr/uNzMK
         1SqQ==
X-Gm-Message-State: ACgBeo1wIRD7Nta/c5u2lT240L7ozKKIH/RV3cvt2psyo1qRvXFuqmPf
        8Oh3a9pXTv7wTQwHY5etiodiJQRFR+CI
X-Google-Smtp-Source: AA6agR4nHY/ALASaB6ML9Y/8f2p0m5sk2i47fc6sZmQCuiYN/l2jdLI3fj8Icd8/Bz5NvCRsPfMkWvqD2Yoj
X-Received: from jiangzp-glinux-dev.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:4c52])
 (user=jiangzp job=sendgmr) by 2002:a81:1353:0:b0:345:34b5:ad29 with SMTP id
 80-20020a811353000000b0034534b5ad29mr27724101ywt.17.1663112238498; Tue, 13
 Sep 2022 16:37:18 -0700 (PDT)
Date:   Tue, 13 Sep 2022 16:37:14 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220913233715.3323089-1-jiangzp@google.com>
Subject: [kernel PATCH v2 0/1] Bluetooth: hci_sync: allow advertise when scan
 without RPA
From:   Zhengping Jiang <jiangzp@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org
Cc:     Zhengping Jiang <jiangzp@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


This patch allows the device to keep advertising during active scan when
ll privacy is enabled, if the device is not using privacy mode.

Changes in v2:
- Modify title to reduce length within limit

Changes in v1:
- Check privacy flag when disable advertising

Zhengping Jiang (1):
  Bluetooth: hci_sync: allow advertise when scan without RPA

 net/bluetooth/hci_sync.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.37.2.789.g6183377224-goog

