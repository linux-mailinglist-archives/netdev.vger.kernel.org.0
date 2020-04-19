Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 178611AFD05
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 20:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgDSSNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 14:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726424AbgDSSNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 14:13:44 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FADAC061A0C
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 11:13:44 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id t63so7399801wmt.3
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 11:13:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=DZiiayifGHCz2XlFRsNzNJ7g5igERpCo+RMqU3nNLoc=;
        b=OHcXnRf2pUhT4YjQhVzJyJoUvYziYhYWGpoqor+XqGk2Gh+objNkftPigzPEwW5dgn
         2vsil1hZ0J7GoDXkDJx405Zldmp4YUoJkcw9N7SmCz4W62fIHME7CPC3p+zVpelr5gaq
         h9qM5zTI0c7R1a/BjLvHL8QwaDZfD2twVeD0U7ERF0sakqY5kKHgt/EiAmbUFhoI6npe
         SAQbdw4oDMI/tO+7Awz80cc9CzvS900dXX4BjfxzBCcLeeT0uGqKaG75g3iKgK0GBQVa
         lq2wBe51UhgpuI27tg8IBtW8J/NaEEq5ffPBozHyW0evuVTJuTrYEXqg6jLcRopnBoPE
         5oNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=DZiiayifGHCz2XlFRsNzNJ7g5igERpCo+RMqU3nNLoc=;
        b=J1J7XomPyROEk5xufFEbHoSKLYx3HFpGbwtW76ZpEm2JPrJ+dZxs/sTZmc2nNgNm1I
         mOgSJ4vKvy+jdWBfNNemVtyVSnj/feyBf9gUDEOh740RAOgFj6+8ahiR+ib4UQ+CWB9W
         3RZtGeuWyI51bEHI6tvMccuAOJCcL7PiQBerDzVFItGV0zuSK3m61aHKfCyEyRgNiokl
         48+eXGlVtSDXANNoJNQbhY/279V2AJvfpjW0gI6yK2emQNCnB1z4VqCBvmW+xtK7cVT7
         LjJrrZqVJcTMVFZMl+yS7hqQLCsbGKdLOsaMegeC1l4nWhZHT5qMp9XSzVkX5buBGbBx
         epQw==
X-Gm-Message-State: AGi0PubYKtEimTBL3gCfzx0btDWjen52hr8jcu49ZiUZA/MfOseCdrHC
        7NUn+mOyMn8PJ3woRBFEGKNxqPUZ
X-Google-Smtp-Source: APiQypL2MP5igPfI0gqnTKMfyz8op1uDN++HgkUINj1udwVtqfNT/MALMxvS/HTAdUBLwCF8mEJE4A==
X-Received: by 2002:a7b:c642:: with SMTP id q2mr14163414wmk.41.1587320022468;
        Sun, 19 Apr 2020 11:13:42 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:39dc:7003:657c:dd6e? (p200300EA8F29600039DC7003657CDD6E.dip0.t-ipconnect.de. [2003:ea:8f29:6000:39dc:7003:657c:dd6e])
        by smtp.googlemail.com with ESMTPSA id v7sm13408650wmg.3.2020.04.19.11.13.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Apr 2020 11:13:42 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next v2 0/3] r8169: improve memory barriers
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <a7e1d491-bede-6f86-cff0-f2b74d8af2b3@gmail.com>
Date:   Sun, 19 Apr 2020 20:13:40 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes improvements for (too heavy) memory barriers.
Tested on x86-64 with RTL8168g chip version.

v2:
- drop patch 2 from the series

Heiner Kallweit (3):
  r8169: use smp_store_mb in rtl_tx
  r8169: replace dma_rmb with READ_ONCE in rtl_rx
  r8169: use WRITE_ONCE instead of dma_wmb in rtl8169_mark_to_asic

 drivers/net/ethernet/realtek/r8169_main.c | 24 ++++++++---------------
 1 file changed, 8 insertions(+), 16 deletions(-)

-- 
2.26.1

