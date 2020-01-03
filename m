Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A28BD12FBDA
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 18:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbgACRz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 12:55:26 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44338 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728110AbgACRz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 12:55:26 -0500
Received: by mail-pl1-f195.google.com with SMTP id az3so19283184plb.11
        for <netdev@vger.kernel.org>; Fri, 03 Jan 2020 09:55:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=HwKI0nFSGJXtdEsG1Lt3W2AZ3z47nYG9ydGEl21lRNc=;
        b=VHjS+NcMaEqK2rXCNKKowgU47LnBRLafwNo8diuX9QukQD8nSAntG8z1e3j+dibEV0
         yX6MkUMRGnvcv3ix0UZiyv28+rg6FB3uCaDnqgwuaOdds87GeM0e9eGAgpRegCvYnqOM
         7/8qWRS5hVVq9iouKtAlxNW0gyn7CTFoq2DAS52ROB1ZAmICmLikcPa+l2hr2ny7woHS
         IFHg8NNf/OVs8Vp+cr0qeXITv3PXEhp+FJybkQfAJEW+/l1OOIn69Krj0mLBlncoyFyQ
         SYByI+xHbYOUISulP4NTogcc1bRrEBaT5rgn2yHKli+BKCzouECZoiDLoxqAQcwJXn7M
         QmHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=HwKI0nFSGJXtdEsG1Lt3W2AZ3z47nYG9ydGEl21lRNc=;
        b=i62hVcUeMJRjNCSaMedSqE5p1sDbYvPIlLC+o8Jj4WslfLtFS0UA7Cem4NOk9b90Am
         FZTpok2DmsFDkJOJexI+t6Bj3j+5hQmvnW4r6YlKNh4ONrzZ33ARuNWJ4kuoE++6dHh6
         x75h38YpL9QqW+Gmz0NdTGTr7NjWEQLeS90GD6GlqkNTSxxIIqPlQ2Z1/GyxGPUZ7G/j
         t7ep52h/L6LQ/CTVWr4SVzvjn0zTZJWKCdVG+uWnJGX2qgL1hCajAQCd/X3GWYI9UNRo
         3sCF1eJLUqoTpMvfECu7ed2JUb5F9FHVmC0BA1r2dfEiVTBjlnwSRh8gdCsIZ6jr52Nl
         2SfQ==
X-Gm-Message-State: APjAAAWkyIhBtFcFUlcjZPcf1qaMxmx3/qwwgx9UIzBD4jGH05PIjhMF
        /q2DHWu3iTYCbZkbD/NujbC5TxOHXCxTTg==
X-Google-Smtp-Source: APXvYqwS5j5re7S3rJbWibyODWGejL29CrcA5/GfJnAsE5dslgP5M/fgarSz8XK5hyHqGgmd3e6jJQ==
X-Received: by 2002:a17:90b:258:: with SMTP id fz24mr27174453pjb.6.1578074125741;
        Fri, 03 Jan 2020 09:55:25 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id u20sm61516655pgf.29.2020.01.03.09.55.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Jan 2020 09:55:25 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     parav@mellanox.com, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v4 net-next 0/2] ionic: add sriov support
Date:   Fri,  3 Jan 2020 09:55:06 -0800
Message-Id: <20200103175508.32176-1-snelson@pensando.io>
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

v4:	changed "vf too big" checks to use pci_num_vf()
	changed from vf[] array of pointers of individually allocated
	  vf structs to single allocated vfs[] array of vf structs
	added clean up of vfs[] on probe fail
	added setup for vf stats dma

v3:	added check in probe for pre-existing VFs
	split out the alloc and dealloc of vf structs to better deal
	  with pre-existing VFs (left enabled on remove)
	restored the checks for vf too big because of a potential
	  case where VFs are already enabled but driver failed to
	  alloc the vf structs

v2:	use pci_num_vf() and kcalloc()
	remove checks for vf too big
	add locking for the VF operations
	disable VFs in ionic_remove() if they are still running


Shannon Nelson (2):
  ionic: ionic_if bits for sr-iov support
  ionic: support sr-iov operations

 drivers/net/ethernet/pensando/ionic/ionic.h   |  17 +-
 .../ethernet/pensando/ionic/ionic_bus_pci.c   | 113 ++++++++
 .../net/ethernet/pensando/ionic/ionic_dev.c   |  58 ++++
 .../net/ethernet/pensando/ionic/ionic_dev.h   |   7 +
 .../net/ethernet/pensando/ionic/ionic_if.h    |  97 +++++++
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 247 +++++++++++++++++-
 .../net/ethernet/pensando/ionic/ionic_main.c  |   4 +
 7 files changed, 535 insertions(+), 8 deletions(-)

-- 
2.17.1

