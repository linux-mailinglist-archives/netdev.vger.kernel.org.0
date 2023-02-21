Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B41169D899
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 03:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233058AbjBUCjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 21:39:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232561AbjBUCjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 21:39:43 -0500
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED7A035BD;
        Mon, 20 Feb 2023 18:39:41 -0800 (PST)
Received: from localhost.localdomain (unknown [10.101.196.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 103723F158;
        Tue, 21 Feb 2023 02:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1676947179;
        bh=xJcQS0NHTjCqYge6gioIOPlQ1NL7iqmzKC8V/TyADfk=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=PGvC9jSB0+GdP2xkQ22s/7tDptZWAqMwqXWWoi0WPMNzhvW6g/Q/MlSPcqsKCpE6q
         1QhWf0wUyibyX60ib4Vk3vUBA6yKgeDazmh/jKuw6eCRs9rwOzqmVb53zU4+LN2K7U
         RRXnMMD3PLvEQtaM5aJejTAzJ2LplFeJPDHKjmSl6527pPhBwUEiVSJcgdkYjwUB/W
         UmBuoCvhygjb8J/0lIedgaM9BcNWz+tGOnkP+We6kBr2TwhaY0am5EGjBKazcyuYBt
         r1EAxtWxuD6xllDdNfhMFJdcazxtwmM8zHJlKFO8/eCe1MLOMC+8Xp+jqsswp1Pho4
         H4xEtVe7F/Jwg==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     hkallweit1@gmail.com, nic_swsd@realtek.com, bhelgaas@google.com
Cc:     koba.ko@canonical.com, acelan.kao@canonical.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        vidyas@nvidia.com, rafael.j.wysocki@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [PATCH v8 RESEND 0/6] r8169: Enable ASPM for recent 1.0/2.5Gbps Realtek NICs
Date:   Tue, 21 Feb 2023 10:38:43 +0800
Message-Id: <20230221023849.1906728-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The series is to enable ASPM on more r8169 supported devices, if
available.

The latest Realtek vendor driver and its Windows driver implements a
feature called "dynamic ASPM" which can improve performance on it's
ethernet NICs.

We have "dynamic ASPM" mechanism in Ubuntu 22.04 LTS kernel for quite a
while, and AFAIK it hasn't introduced any regression so far. 

A very similar issue was observed on Realtek wireless NIC, and it was
resolved by disabling ASPM during NAPI poll. So in v8, we use the same
approach, which is more straightforward, instead of toggling ASPM based
on packet count.

v7:
https://lore.kernel.org/netdev/20211016075442.650311-1-kai.heng.feng@canonical.com/

v6:
https://lore.kernel.org/netdev/20211007161552.272771-1-kai.heng.feng@canonical.com/

v5:
https://lore.kernel.org/netdev/20210916154417.664323-1-kai.heng.feng@canonical.com/

v4:
https://lore.kernel.org/netdev/20210827171452.217123-1-kai.heng.feng@canonical.com/

v3:
https://lore.kernel.org/netdev/20210819054542.608745-1-kai.heng.feng@canonical.com/

v2:
https://lore.kernel.org/netdev/20210812155341.817031-1-kai.heng.feng@canonical.com/

v1:
https://lore.kernel.org/netdev/20210803152823.515849-1-kai.heng.feng@canonical.com/

Kai-Heng Feng (6):
  r8169: Disable ASPM L1.1 on 8168h
  Revert "PCI/ASPM: Unexport pcie_aspm_support_enabled()"
  PCI/ASPM: Add pcie_aspm_capable() helper
  r8169: Consider chip-specific ASPM can be enabled on more cases
  r8169: Use mutex to guard config register locking
  r8169: Disable ASPM while doing NAPI poll

 drivers/net/ethernet/realtek/r8169_main.c | 48 ++++++++++++++++++-----
 drivers/pci/pcie/aspm.c                   | 12 ++++++
 include/linux/pci.h                       |  2 +
 3 files changed, 53 insertions(+), 9 deletions(-)

-- 
2.34.1

