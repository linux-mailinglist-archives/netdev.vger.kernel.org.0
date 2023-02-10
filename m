Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9066916D0
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 03:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbjBJCui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 21:50:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbjBJCuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 21:50:37 -0500
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FCE76F23D;
        Thu,  9 Feb 2023 18:50:35 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sendonly@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 7E5A341EF0;
        Fri, 10 Feb 2023 02:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1675997431; bh=dJYvSnjg1TsvS4N14R3W3MLMAAB3oGY+43m95CrJNq0=;
        h=From:To:Cc:Subject:Date;
        b=B/q6tembF5Kee89myywnTK0eLjTJnXo8cJo5nBCB33oCHCmyFHLxFRudDLeqIvyz7
         ze+XjEslAuMVtTEgs3gF8VQifJ4SEboEPBDwaI5aoXHgCKhGb+CiIiMULbkxzRhNdx
         FhfMBWhiFHekBfFYiPScIvcpkE64jD4nOLHI4rCXtnwxlLSd9GzwbNok8kQnOCwCky
         Uy3SRktjEUkOP9pASVbyFYBv2VS4z5gQ2IEL/EZ4S40+pM6azmR+5Qcoqk8sHzbvLy
         8qQ1UqgtBWO0k11qJM5a2zBed2Dd57a1F7Jl3G5tbxw2mZztmBlGvUF2sMi1EH5Ct6
         NzTtPf32CSflg==
From:   Hector Martin <marcan@marcan.st>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Alexander Prutskov <alep@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Ian Lin <ian.lin@infineon.com>,
        Soontak Lee <soontak.lee@cypress.com>,
        Joseph chuang <jiac@cypress.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Aditya Garg <gargaditya08@live.com>,
        Jonas Gorski <jonas.gorski@gmail.com>, asahi@lists.linux.dev,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hector Martin <marcan@marcan.st>
Subject: [PATCH v3 0/4] BCM4355/4364/4377 support & identification fixes
Date:   Fri, 10 Feb 2023 11:50:05 +0900
Message-Id: <20230210025009.21873-1-marcan@marcan.st>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

This series adds support for the BCM4355, BCM4364, and BCM4377 variants
found on Intel Apple Macs of the T2 era (and a few pre-T2 ones).

The first patch fixes a bunch of confusion introduced when adding
support for the Cypress 89459 chip, which is, as far as I can tell,
just a BCM4355. This also drops the RAW device ID (just for this one
chip), as there's no reason to add it unless we find actual hardware
in the wild that uses it, and besides the raw device ID is already
there twice (with a subvendor match), which was added by 2fef681a4cf7
("brcmfmac: add CYW89342 mini-PCIe device").

The subsequent patches add the firmware names and remaining missing
device IDs, including splitting the BCM4364 firmware name by revision
(since it was previously added without giving thought to the existence
of more than one revision in the wild with different firmwares,
resulting in different users manually copying different incompatible
firmwares as the same firmware name).

None of these devices have firmware in linux-firmware, so we should
still be able to tweak firmware filenames without breaking anyone that
matters. Apple T2 users these days are mostly using downstream trees
with the Asahi Linux WLAN patches merged anyway, so they already know
about this.

Note that these devices aren't fully usable as far as firmware
selection on these platforms without some extra patches to add support
for fetching the required info from ACPI, but I want to get the device
ID stuff out of the way first to move forward.

v2: Added a commit in front to drop all the RAW device IDs as discussed,
    and also fixed the 4364 firmware interface from BCA to WCC, as
    pointed out in the v1 thread.

v3: Dropped the raw cleanup commit because apparently some platforms
    rely on those. Still removing the redundant raw ID for CYW89459,
    though. It seems highly unlikely that will break anything, as it'd
    have to be a device with no proper ID programmed *and* a custom
    subvendor programmed.

Hector Martin (4):
  wifi: brcmfmac: Rename Cypress 89459 to BCM4355
  brcmfmac: pcie: Add IDs/properties for BCM4355
  brcmfmac: pcie: Add IDs/properties for BCM4377
  brcmfmac: pcie: Perform correct BCM4364 firmware selection

 .../broadcom/brcm80211/brcmfmac/chip.c        |  6 ++--
 .../broadcom/brcm80211/brcmfmac/pcie.c        | 33 +++++++++++++++----
 .../broadcom/brcm80211/include/brcm_hw_ids.h  |  8 +++--
 3 files changed, 34 insertions(+), 13 deletions(-)

-- 
2.35.1

