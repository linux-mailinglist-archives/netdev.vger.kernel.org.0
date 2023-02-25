Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37B876A2716
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 04:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjBYDrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 22:47:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbjBYDra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 22:47:30 -0500
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B3E13526;
        Fri, 24 Feb 2023 19:47:28 -0800 (PST)
Received: from localhost.localdomain (unknown [10.101.196.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 0EA433FD9B;
        Sat, 25 Feb 2023 03:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1677296847;
        bh=bcQHkZBt47YSJLdo3rhz3wDvWS17bb1/IY5Vilwk+kU=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=cvrsp7xwMX+acb0LJ5tEFftqHMNlQY286cuyU7LtzXZ1zaSujFai/pV8Ib0vrTCR7
         ic8oA2vqnRP1tBqGiUM2rb/oexVylUUo/CyGUv1ywwL9j/D6Y3XFD+fw7cZefy0NqG
         VwX5NS9PjqVutJKuY7YLJ6T3T+l9xj7rHjkvvSt5/acflDjxyumX2wOsbIDrL3/cfI
         FFZeWiyJId5dxCjeU8suv8oOLLwe3zh2zyAfS360J+/8dzP71M/YnPNKquZTBg077b
         gu0zuBdgvBdnmJiK7HppFi+2BH8P2Gfaxxy2VDIVfV0xhoQngqzSuqkRJfONxCPHev
         C+sqjjUgW3f4w==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     hkallweit1@gmail.com, nic_swsd@realtek.com, bhelgaas@google.com
Cc:     koba.ko@canonical.com, acelan.kao@canonical.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        vidyas@nvidia.com, rafael.j.wysocki@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [PATCH net-next v9 0/5] r8169: Temporarily disable ASPM on NAPI poll
Date:   Sat, 25 Feb 2023 11:46:30 +0800
Message-Id: <20230225034635.2220386-1-kai.heng.feng@canonical.com>
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

The series is to temporarily disable ASPM on NAPI poll, so the NIC can
"regain" the performace loss when ASPM is enabled. The idea is from
Realtek vendor driver's feature "dynamic ASPM" .

We have "dynamic ASPM" mechanism in Ubuntu 22.04 LTS kernel for quite a
while, and AFAIK it hasn't introduced any regression so far. 

A very similar issue was observed on Realtek wireless NIC, and it was
resolved by disabling ASPM during NAPI poll. So in v8 and v9, we use the
same approach, which is more straightforward, instead of toggling ASPM
based on packet count.

In addition to that, The series also enables ASPM on more systems where
BIOS doesn't grant OS ASPM control.

v8:
https://lore.kernel.org/netdev/20230221023849.1906728-1-kai.heng.feng@canonical.com/

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

Kai-Heng Feng (5):
  Revert "PCI/ASPM: Unexport pcie_aspm_support_enabled()"
  PCI/ASPM: Add pcie_aspm_capable() helper
  r8169: Consider chip-specific ASPM can be enabled on more cases
  r8169: Use spinlock to guard config register locking
  r8169: Disable ASPM while doing NAPI poll

 drivers/net/ethernet/realtek/r8169_main.c | 42 +++++++++++++++++++----
 drivers/pci/pcie/aspm.c                   | 12 +++++++
 include/linux/pci.h                       |  2 ++
 3 files changed, 50 insertions(+), 6 deletions(-)

-- 
2.34.1

