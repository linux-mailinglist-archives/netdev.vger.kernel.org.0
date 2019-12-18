Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6F5123BF3
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 01:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfLRAv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 19:51:27 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38052 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbfLRAv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 19:51:27 -0500
Received: by mail-pg1-f195.google.com with SMTP id a33so263475pgm.5;
        Tue, 17 Dec 2019 16:51:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ABUqdUxFYplY8BOM3XuA0Fxd42dzU9oSNOiYz1wYZWw=;
        b=Vx3Y1O6ScfLrpSWCK/33PwA3zlcJ/DSmCtNdk/rmt2/WpGRMag8BAyub98wTfHFGXu
         zj0YsO1gZYyVtgUs/A9v6sZmUqaELNkSeoFfbhGEpAk7WzXN8RwFq5kBxmbS/hQ0IO4X
         JPWbaWim2Fg7ac6/wWGNSYB7rv8cgOV1YOWZTHSKtFNlHW8UL0H04USkll402+AmzIeM
         KGlQ+GDAHucv81ZSzdJIulIEe70E61vXYLZ79DsHMNG/c00vgWdXahjsXZf/x3zJ/UQ+
         xjBQWK7ic3K/aabtFlwQWrrNy0wdepk5GHhCl8EGSvKy28Rp2G0BID+dztXLvHN6yYic
         3qcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ABUqdUxFYplY8BOM3XuA0Fxd42dzU9oSNOiYz1wYZWw=;
        b=Ol/Sf5eXPG4q0V3n3AU0ksp/0gynzLMbZLBA0j2sFQ9QELF5+V/+yszBsdBDSRfRws
         5lDJ91mnsbip1XyxW2M2iRP3XzYmfqUiy5+oW/ZmRGRCFLm6eehJxQ9WpAd2hX8ZcmSc
         emwwzNlXpBfvThLOZ05ZOupuYl2qDZrkciolBAxSuozRVImc+WRRFpTo3ekNmsRb90Fa
         YDA6hzcv38g+sZy99+Knb3OZOdT1Al8TIa2R96BNhI3eu17Z2ZajFWNWZEKAhl0cUeJu
         SR4Z/7i1mVPgoti1jwEJtls1+cV0UhQeGKGrIW+TZJsnv2CwtaDn0O2bH+cFDvxVxCYG
         wOog==
X-Gm-Message-State: APjAAAVUOluj7z9+tg2UXvXJy0ZTK+dxVBOckDkj1ldiV0YiODecQ6fX
        7ZzD1pAeS42JYtnYZHv6hC4=
X-Google-Smtp-Source: APXvYqxmIdnASO50yRj1nIyrySbT6BD8ZMksmKjKuo+BwantJGO+PFuePHgW2CcNE/ZBpq4w3KnbtA==
X-Received: by 2002:aa7:8d4d:: with SMTP id s13mr730354pfe.18.1576630286445;
        Tue, 17 Dec 2019 16:51:26 -0800 (PST)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 81sm274819pfx.30.2019.12.17.16.51.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 17 Dec 2019 16:51:25 -0800 (PST)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net-next v2 0/8] net: bcmgenet: Turn on offloads by default
Date:   Tue, 17 Dec 2019 16:51:07 -0800
Message-Id: <1576630275-17591-1-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit stack is based on Florian's commit 4e8aedfe78c7 ("net: 
systemport: Turn on offloads by default") and enables the offloads for
the bcmgenet driver by default.

The first commit adds support for the HIGHDMA feature to the driver.

The second converts the Tx checksum implementation to use the generic
hardware logic rather than the deprecated IP centric methods.

The third modifies the Rx checksum implementation to use the hardware
offload to compute the complete checksum rather than filtering out bad
packets detected by the hardware's IP centric implementation. This may
increase processing load by passing bad packets to the network stack,
but it provides for more flexible handling of packets by the network
stack without requiring software computation of the checksum.

The remaining commits mirror the extensions Florian made to the sysport
driver to retain symmetry with that driver and to make the benefits of
the hardware offloads more ubiquitous.

Doug Berger (8):
  net: bcmgenet: enable NETIF_F_HIGHDMA flag
  net: bcmgenet: enable NETIF_F_HW_CSUM feature
  net: bcmgenet: use CHECKSUM_COMPLETE for NETIF_F_RXCSUM
  net: bcmgenet: Refactor bcmgenet_set_features()
  net: bcmgenet: Utilize bcmgenet_set_features() during resume/open
  net: bcmgenet: Turn on offloads by default
  net: bcmgenet: Be drop monitor friendly while re-allocating headroom
  net: bcmgenet: Add software counters to track reallocations

 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 113 ++++++++++++++-----------
 drivers/net/ethernet/broadcom/genet/bcmgenet.h |   4 +-
 2 files changed, 67 insertions(+), 50 deletions(-)

-- 

Changes in v2:
  - Added "Reviewed-by" where given
  - Removed no longer used private structure member dma_rx_chk_bit
  - Used __force casting to remove sparse warnings

2.7.4

