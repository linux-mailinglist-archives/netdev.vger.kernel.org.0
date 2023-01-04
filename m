Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF0465D019
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 11:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234112AbjADKDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 05:03:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233067AbjADKDj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 05:03:39 -0500
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF3F1B1D4;
        Wed,  4 Jan 2023 02:03:38 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sendonly@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id C9E433FB17;
        Wed,  4 Jan 2023 10:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1672826616; bh=uvTIZXmlp9F4KsvUKwHHPKv5C7NMYiaYAHYUkqRYJ5A=;
        h=From:To:Cc:Subject:Date;
        b=QmV3K0wjhKqdCpGRzPEdPCjHTcInnR3KEHeQVpafGtpHjEYXNSlfwgAGHBDeageT3
         VMuN/bmKq3cwmS1TrODh85GyF/eBnZ6CZVudCRosUVMHZq0BBUVQiVp+CCUUVzcH3g
         eP+z8h06VvXl0sEucungsxWAcEpiAaTuK2k0ENo/mUnTOpAq8niUzlW73T6iXGxR7R
         dShRfylXECekCR/p3fZ4kxcSepJnNwWu8Lh/Zoz7b5rD8gU0r6jVhrABo+hP39BGAs
         CTH2XpUSpdAC+4P7UF2Va9RHmXHSL0D+DxqTzOPTifvkctWppIklFv+gWWufys5PNB
         ja4bEOsB/mIhA==
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
        asahi@lists.linux.dev, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hector Martin <marcan@marcan.st>
Subject: [PATCH v1 0/4] BCM4355/4364/4377 support & identification fixes
Date:   Wed,  4 Jan 2023 19:01:12 +0900
Message-Id: <20230104100116.729-1-marcan@marcan.st>
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
just a BCM4355.

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

Hector Martin (4):
  wifi: brcmfmac: Rename Cypress 89459 to BCM4355
  brcmfmac: pcie: Add IDs/properties for BCM4355
  brcmfmac: pcie: Add IDs/properties for BCM4377
  brcmfmac: pcie: Perform correct BCM4364 firmware selection

 .../broadcom/brcm80211/brcmfmac/chip.c        |  6 ++--
 .../broadcom/brcm80211/brcmfmac/pcie.c        | 32 +++++++++++++++----
 .../broadcom/brcm80211/include/brcm_hw_ids.h  |  9 ++++--
 3 files changed, 35 insertions(+), 12 deletions(-)

-- 
2.35.1

