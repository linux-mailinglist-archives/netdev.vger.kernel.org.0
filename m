Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E017511EABF
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 19:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728671AbfLMSzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 13:55:23 -0500
Received: from mail-pf1-f170.google.com ([209.85.210.170]:45199 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728552AbfLMSzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 13:55:23 -0500
Received: by mail-pf1-f170.google.com with SMTP id 2so1913521pfg.12
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 10:55:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=G3AETG1PHdrDYUWiJKZpP5YvRz7xnlsT9JItYftb7xg=;
        b=uYnz4Kqzw+yEhp9w89ZYwiPmwp6S2MuOAUZ2bwZMLJBm9K9yxk1dUEYdMMVQHxV5fs
         ToyltWXIl4qU3QTN8g7TLQfkxGAHCBZ1lq1DOvQAXSAdvz7N7tfCk6d5XdauSFLIM8ra
         BksHVx87MTn86gX4XIl5UWsLcysgUUv+9P25P5/X+9ByCONsUg6vUP9PcPpqs7yIGTEV
         Fi8IK3vBz+VPm8Uw7ezADZcQiP/J77XVUjjgZ41qAgJwuuMc4E+QP4aTw5QIfIahm0ra
         i+BRZkdTAqspm5QftyD2boN5iecHQsQiRMn6uSVjYws7HaDEwESxERgpxBe9fFvENpc9
         t+4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=G3AETG1PHdrDYUWiJKZpP5YvRz7xnlsT9JItYftb7xg=;
        b=WItlZMmuE+IKJ/yLnptIlIJCpKYp8+mwEsLcr6gKR4X98T/as6Etn1Y4I4NFpjAuMd
         +OmtqgvsqOMMmP9+kuR/vkB1IMzxrGfIdeUIcbLO4K2H8aFHSG9a+ML63rC0j11M+1VG
         dnuK3TJ5SUFp5B3W9JwMCykFROEMb8gd7yhkdMv22VxwPwkQlND8rXDxVvClxHUhSCnY
         zMvkIsKCy6K5KBw6HsZO+r4lt7reUCeERvXPLMXWLrRk8UVL6inGTfb5V2sZwWRrH8fC
         4/obZE3jE1108I5DtxLVm1IOJaxWVKMKicLWJFlT7j1JzZvJDGoVXGmf2mcJiNZ6mK/u
         atAw==
X-Gm-Message-State: APjAAAXfOWmtITWBvx/HETr1OU4EEjCwojzUGLJ5CamizQd5TxtR6Fnd
        ZSKC0NR0Dso58dADSbmEs0EZxqLW46k=
X-Google-Smtp-Source: APXvYqxM/03Xp+7obBRfeILFtRtRCH06khfWpHk558eE6GbnNR4RvAIAhe1y4I2VUuosCDNQQtaYIw==
X-Received: by 2002:a63:4d1b:: with SMTP id a27mr959612pgb.352.1576263322640;
        Fri, 13 Dec 2019 10:55:22 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id n26sm12609003pgd.46.2019.12.13.10.55.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Dec 2019 10:55:22 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     parav@mellanox.com, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 0/2] ionic: add sriov support
Date:   Fri, 13 Dec 2019 10:55:14 -0800
Message-Id: <20191213185516.52087-1-snelson@pensando.io>
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
	remove checks for vf too big
	add locking for the VF operations
	disable VFs in ionic_remove() if they are still running

v3:	added check in probe for pre-existing VFs
	split out the alloc and dealloc of vf structs to better deal
	  with pre-existing VFs (left enabled on remove)
	restored the checks for vf too big because of a potential
	  case where VFs are already enabled but driver failed to
	  alloc the vf structs

Shannon Nelson (2):
  ionic: ionic_if bits for sr-iov support
  ionic: support sr-iov operations

 drivers/net/ethernet/pensando/ionic/ionic.h   |  17 +-
 .../ethernet/pensando/ionic/ionic_bus_pci.c   | 101 ++++++++
 .../net/ethernet/pensando/ionic/ionic_dev.c   |  58 +++++
 .../net/ethernet/pensando/ionic/ionic_dev.h   |   7 +
 .../net/ethernet/pensando/ionic/ionic_if.h    |  97 ++++++++
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 222 +++++++++++++++++-
 .../net/ethernet/pensando/ionic/ionic_lif.h   |   6 +
 .../net/ethernet/pensando/ionic/ionic_main.c  |   4 +
 8 files changed, 504 insertions(+), 8 deletions(-)

-- 
2.17.1

