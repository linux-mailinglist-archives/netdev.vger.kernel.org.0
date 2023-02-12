Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B25F069363B
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 07:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbjBLGiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 01:38:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjBLGip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 01:38:45 -0500
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7812213D7C;
        Sat, 11 Feb 2023 22:38:42 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sendonly@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 15A5F425AB;
        Sun, 12 Feb 2023 06:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1676183919; bh=UuZurNk9zhY1jxoEx2xHRndSkiGfgY+vAAycuZiOwnk=;
        h=From:To:Cc:Subject:Date;
        b=RIhD3JSnY7vyqo9dQeqCmnng0EcbcqTPv2A7JVDwG8RQAf0ro7Hum3HJ0wlzhvaFK
         gSAti8wEaGOcx55rAU05QAoMyewuhzDrZtXbtqnCQV8fHVyxz8ZqOvKGi49fPOxCTo
         MtxvxRhO3lfW+jJ1tNCvswg4/OJ0pNgMhN1wqR/SyVwJCRRV+TOeN0gSuxJCkoJJ4q
         5Upn/jWx1VUysYbsxWDzgpA+NWB/68l/sHPhPpX3aZFCsegHYztrnIdDSYlfuEzcUx
         htEl0HM7Gzci2RC3g8eB+d44H69Cxg6sPnn/11tenPqo4wM9q68HMuVcZQosZGZSXx
         wz8yOvELoVlAQ==
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
        Ian Lin <ian.lin@infineon.com>,
        Joseph chuang <jiac@cypress.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Aditya Garg <gargaditya08@live.com>,
        Jonas Gorski <jonas.gorski@gmail.com>, asahi@lists.linux.dev,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hector Martin <marcan@marcan.st>
Subject: [PATCH v4 0/4] BCM4355/4364/4377 support & identification fixes
Date:   Sun, 12 Feb 2023 15:38:09 +0900
Message-Id: <20230212063813.27622-1-marcan@marcan.st>
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

v4: Removed a total of 12 characters from the commit descriptions,
    because the nitpicking must go on even though this practice is
    widespread with more than 17000 examples in the kernel's Git
    history, and over 500 in networking alone. Earned a gratuitous
    insult to my intelligence in the process of discussing this.

    Apple already have new chips shipping on new machines now, beyond
    the ones I submitted a year ago as part of a larger series that
    this series is only part of, as Kalle refused to merge it back then
    for having too many patches. Plus there's more patches queued
    downstream for suspend support now. I wonder if we'll ever catch up
    with upstreaming brcmfmac changes at this rate? I'm starting to lose
    hope.

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

