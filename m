Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F88711C17C
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 01:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbfLLAd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 19:33:56 -0500
Received: from mail-pj1-f42.google.com ([209.85.216.42]:44230 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726673AbfLLAdz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 19:33:55 -0500
Received: by mail-pj1-f42.google.com with SMTP id w5so247856pjh.11
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 16:33:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=7Y07r+tiw0blKw19rI8Pi4pb+z6GV+dRLG25qbdXruk=;
        b=obSvtXTEvh34GMkq7kebRTwxlvHm41HDGPBZTPLfRhMw4+2zvEedUsljuw+4btHBqA
         GD9nHs511yRZLchFAMD4MdIAt8AX96P1yG/ag8bJ/RAKaeDKkZivfwRfC5SoQ74AQ684
         p05cxPs82x1KFLHNM88aXzmuroltfYv1xK2qaaqkS51rqXqrkqAiEwApOm+fW5tlsRHV
         2uejO6lAm7GaukHSnns7d1CcptspAxZZtLjf+ZST5IANIgRHWoahc5lBNerrV0sq7Brp
         nnEQjZD6GZlCR4pB/Ud++RCTFKid4uOSxhiL+5lMO/2tBBEGIUhUmix4OtBRrfFAqC23
         rE6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7Y07r+tiw0blKw19rI8Pi4pb+z6GV+dRLG25qbdXruk=;
        b=oE/EZDvr1utZ46KkEfPO/aGLUY2Q6YsALVifJTlcPZKfxV3SBG0G1ho5uvHxsiHJoZ
         ZYGiV32AzLomlRaFe6/NnwdXs/UFdErYRp0NLLiCQlN8ua8ECx7S6je/PkpufgOKyQ3d
         LMPCN+0VBMybkkRQ8nAM5l65nTzOG7bNv5KRKgR3rPgxZk90yZlbYN51jsL/riOj1204
         MazNvZ+HQQf4oplkhzbDxMGsMQgq9QyjkcN74eumxo9Dlzpl5kNE1IHWdRm646+cc5YL
         zD5hfD90t91iH9td2rwG3BytRPsuGcEDVmAmuO2QVHs6fjwV4LopkWuY9cqrAkgna41j
         DFsw==
X-Gm-Message-State: APjAAAUdIi7ovinjAjA7M5P65sxbNQiJ0ilhm9pEuMi/iLZkQU5ascA1
        YUe/tqK5z2zVu27qxaEj4K3adwb7Fag=
X-Google-Smtp-Source: APXvYqzSsY33abDZl7AYYcx2TJ+kXwrvS17l4u2f48Cap2Yn+E9b9QNUSPLKs5FYP+QV3T9OH99KIA==
X-Received: by 2002:a17:90a:350e:: with SMTP id q14mr6821053pjb.46.1576110834343;
        Wed, 11 Dec 2019 16:33:54 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id 16sm4343509pfh.182.2019.12.11.16.33.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Dec 2019 16:33:53 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     parav@mellanox.com, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 0/2] ionic: add sriov support
Date:   Wed, 11 Dec 2019 16:33:42 -0800
Message-Id: <20191212003344.5571-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set up the basic support for enabling SR-IOV devices in the
ionic driver.  Since most of the management work happens in
the NIC firmware, the driver becomes mostly a pass-through
for the network stack commands that want to control and
configure the VFs.

v2:	use pci_num_vf() and kcalloc()
	add locking for the VF operations
	disable VFs in ionic_remove() if they are still running

Shannon Nelson (2):
  ionic: ionic_if bits for sr-iov support
  ionic: support sr-iov operations

 drivers/net/ethernet/pensando/ionic/ionic.h   |  15 +-
 .../ethernet/pensando/ionic/ionic_bus_pci.c   |  85 ++++++
 .../net/ethernet/pensando/ionic/ionic_dev.c   |  58 ++++
 .../net/ethernet/pensando/ionic/ionic_dev.h   |   7 +
 .../net/ethernet/pensando/ionic/ionic_if.h    |  97 +++++++
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 254 +++++++++++++++++-
 .../net/ethernet/pensando/ionic/ionic_lif.h   |   7 +
 .../net/ethernet/pensando/ionic/ionic_main.c  |   4 +
 8 files changed, 519 insertions(+), 8 deletions(-)

-- 
2.17.1

