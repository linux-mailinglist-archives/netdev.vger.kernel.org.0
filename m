Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF4B47F9DF
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 04:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235162AbhL0DMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 22:12:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235086AbhL0DMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Dec 2021 22:12:17 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 163ADC06175C;
        Sun, 26 Dec 2021 19:12:17 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id v22so12527528qtx.8;
        Sun, 26 Dec 2021 19:12:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=TnbDwenis0DSVok+PgiD3nCGmJt+xEi6EV/3sU9Vggk=;
        b=daEwbdkIMCdYpd33oLolUKQq2eSOwdIv7yuWfQMY4MlqHCVdsCobIkrx9azhrvhM/J
         Qb2Hv96anByxXTfvvGinwMF2T3AOxqdd/8jMgmbDZc3rNTji6a4vwNjQwFhOKOIz7bUx
         iaV6J+k+CvMuNzfsHES2te+wHG5H0QvpEc/AlUsKodQ/YrtzzYPyqUlB4bPbtaczNyaa
         q0EHtWRh2htqT86KHm9U3CRavNpuqISNWr3tBFGrlj14R+7dmhYM5QEiGSvY0/dpq79g
         TuJHEJh4UcF7EyfKQK+HzIX9PEUE8fh+CThuGmMckZe/r8iQ0uSWiHRQw16Fs9gfDNuq
         F0dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=TnbDwenis0DSVok+PgiD3nCGmJt+xEi6EV/3sU9Vggk=;
        b=XKENqVTiCF8D2Bd3XtO7nakZmomZ/qtJjqMDG3F5MYRuXG5KTBCOJg3CorJJegbjQB
         Kp96jvKcJzGCss/3kL+85g7wlLK+cAJIccdlfIENbCXo+AyrFx/4vVijsQmXlKlHRT+D
         nS4qK0SerrZDtRkIQNTi9XWVXRgfOPJEekbqb9fFSd5f1YhTDYxiYOdTvl7SENraad0Z
         Hz4mqnAnKZvg/nHhF9EqFY/l0KkHD4Zs9aqZuC6LGunojjOPPN6EQ3XLpm2iEScxcJJ/
         Ttlha+k9x9ope395YvBB2gb4zkZlUMS3G6TeRBWbptyg2uQdN0CRt7D4Q6w797ormPnK
         nvuw==
X-Gm-Message-State: AOAM532SfuXlXF3YntS1VPVNa6hkSm4SnfecUuqOFUkVH73H/nVQSsFs
        puITDQLEsAIRRc3/4hVNZZk=
X-Google-Smtp-Source: ABdhPJx+swC7W5NZGQJcYNvt/9+LilJ6br2YetTnjSKOFAzV2SOsILxqKcvgDD5K6ENec4HbmkF1UA==
X-Received: by 2002:ac8:5816:: with SMTP id g22mr13429789qtg.515.1640574736116;
        Sun, 26 Dec 2021 19:12:16 -0800 (PST)
Received: from a-10-27-26-18.dynapool.vpn.nyu.edu (vpnrasa-wwh-pat-01.natpool.nyu.edu. [216.165.95.84])
        by smtp.gmail.com with ESMTPSA id j13sm8099707qta.76.2021.12.26.19.12.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Dec 2021 19:12:15 -0800 (PST)
Date:   Sun, 26 Dec 2021 22:12:13 -0500
From:   Zekun Shen <bruceshenzk@gmail.com>
To:     bruceshenzk@gmail.com
Cc:     Jiri Slaby <jirislaby@kernel.org>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, brendandg@nyu.edu
Subject: [PATCH] ath5k: fix OOB in ath5k_eeprom_read_pcal_info_5111
Message-ID: <YckvDdj3mtCkDRIt@a-10-27-26-18.dynapool.vpn.nyu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bug was found during fuzzing. Stacktrace locates it in
ath5k_eeprom_convert_pcal_info_5111.
When none of the curve is selected in the loop, idx can go
up to AR5K_EEPROM_N_PD_CURVES. The line makes pd out of bound.
pd = &chinfo[pier].pd_curves[idx];

There are many OOB writes using pd later in the code. So I
added a sanity check for idx. Checks for other loops involving
AR5K_EEPROM_N_PD_CURVES are not needed as the loop index is not
used outside the loops.

The patch is NOT tested with real device.

The following is the fuzzing report

BUG: KASAN: slab-out-of-bounds in ath5k_eeprom_read_pcal_info_5111+0x126a/0x1390 [ath5k]
Write of size 1 at addr ffff8880174a4d60 by task modprobe/214

CPU: 0 PID: 214 Comm: modprobe Not tainted 5.6.0 #1
Call Trace:
 dump_stack+0x76/0xa0
 print_address_description.constprop.0+0x16/0x200
 ? ath5k_eeprom_read_pcal_info_5111+0x126a/0x1390 [ath5k]
 ? ath5k_eeprom_read_pcal_info_5111+0x126a/0x1390 [ath5k]
 __kasan_report.cold+0x37/0x7c
 ? ath5k_eeprom_read_pcal_info_5111+0x126a/0x1390 [ath5k]
 kasan_report+0xe/0x20
 ath5k_eeprom_read_pcal_info_5111+0x126a/0x1390 [ath5k]
 ? apic_timer_interrupt+0xa/0x20
 ? ath5k_eeprom_init_11a_pcal_freq+0xbc0/0xbc0 [ath5k]
 ? ath5k_pci_eeprom_read+0x228/0x3c0 [ath5k]
 ath5k_eeprom_init+0x2513/0x6290 [ath5k]
 ? ath5k_eeprom_init_11a_pcal_freq+0xbc0/0xbc0 [ath5k]
 ? usleep_range+0xb8/0x100
 ? apic_timer_interrupt+0xa/0x20
 ? ath5k_eeprom_read_pcal_info_2413+0x2f20/0x2f20 [ath5k]
 ath5k_hw_init+0xb60/0x1970 [ath5k]
 ath5k_init_ah+0x6fe/0x2530 [ath5k]
 ? kasprintf+0xa6/0xe0
 ? ath5k_stop+0x140/0x140 [ath5k]
 ? _dev_notice+0xf6/0xf6
 ? apic_timer_interrupt+0xa/0x20
 ath5k_pci_probe.cold+0x29a/0x3d6 [ath5k]
 ? ath5k_pci_eeprom_read+0x3c0/0x3c0 [ath5k]
 ? mutex_lock+0x89/0xd0
 ? ath5k_pci_eeprom_read+0x3c0/0x3c0 [ath5k]
 local_pci_probe+0xd3/0x160
 pci_device_probe+0x23f/0x3e0
 ? pci_device_remove+0x280/0x280
 ? pci_device_remove+0x280/0x280
 really_probe+0x209/0x5d0

Reported-by: Brendan Dolan-Gavitt <brendandg@nyu.edu>
Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>
---
 drivers/net/wireless/ath/ath5k/eeprom.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
index 1fbc2c198..d444b3d70 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -746,6 +746,9 @@ ath5k_eeprom_convert_pcal_info_5111(struct ath5k_hw *ah, int mode,
 			}
 		}
 
+		if (idx == AR5K_EEPROM_N_PD_CURVES)
+			goto err_out;
+
 		ee->ee_pd_gains[mode] = 1;
 
 		pd = &chinfo[pier].pd_curves[idx];
-- 
2.25.1

