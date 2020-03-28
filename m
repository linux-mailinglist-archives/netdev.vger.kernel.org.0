Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF08719634F
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 04:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgC1DO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 23:14:56 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:33280 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbgC1DOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 23:14:55 -0400
Received: by mail-pj1-f50.google.com with SMTP id jz1so4888484pjb.0
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 20:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=A4O1rvvlffv1sScfwWf118aLPMEBNvPDr07L+rsh2nM=;
        b=3tdxogztS/hbS6vk8xEONQvuQwD+0kO0TQEUsGLunfCtNNWxP3iBPEIg7heWtPtEKF
         GZJVFgBaLH/7hccvj7QVbgj4duA6qAnXhpSJCIrQnt/7P/dr9/Y+6gn2XoNcG7oxKVyc
         hhQxIxPMhbiCXjekEhhky0IuIr0DnebamtQ/j3uGGItelLedvmARATUd2nQrIMJ0Zu9R
         fccR76tHzSHFQUXZAQKuDp5Y4vHr6BApuSv/ay1wxK+Swi+IrpQWcz8GqusyFwhwqS0k
         f0garsZJLuYJ1Q05/7damOemRFLrOIItSDBQkQW7nMhUChWtR47g50iCReesnwKCeop/
         GLjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=A4O1rvvlffv1sScfwWf118aLPMEBNvPDr07L+rsh2nM=;
        b=C47UhLGGN+Gqg5+FDkjbPSxltOQiyG+TDXCiFYavRr0CF89K5hdXMTCpSASSaUOGfL
         sHGTBNpk1p8O3MyVsFKJyj+0pHewkeKYUW1/uLhbNOoPNz4i7W7b9DJlKhsTNiP2/hq/
         6Lxt7BBix5snmoKGcU/H13a6Da6tMPhdUklVVzKIGcOBkDIKPxznPScx/Ux6ZDXxRlI2
         jyE3zLmqln92U1BU/hWZfsFNoJAlLJheb3G4H56drDdJ+fvsWLSHlor2pOhgAsxXrSZA
         mhvRAoQWPHTG5lS01WGVubvqsm4pBMhbhxBxoM3TYUychdH8G28HFhed3D3YK8VcYvGd
         ybGA==
X-Gm-Message-State: ANhLgQ2zUdpOIO+5CR3ao5zkLrmQiq+vZadFl3ROtp8Z/W8jLx4s497s
        VsQNYr1FmfomvKh7p04huSxdY08We6U=
X-Google-Smtp-Source: ADFU+vt3TurAHwXHdvIUF/iERN3DFQXIRMPwT0HKu5RCBBh5AN3RUkyQooo1kX02spaVE6XG6p+h3g==
X-Received: by 2002:a17:90a:9284:: with SMTP id n4mr2710127pjo.196.1585365294421;
        Fri, 27 Mar 2020 20:14:54 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id o65sm5208391pfg.187.2020.03.27.20.14.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 27 Mar 2020 20:14:53 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 0/8] ionic support for firmware upgrade
Date:   Fri, 27 Mar 2020 20:14:40 -0700
Message-Id: <20200328031448.50794-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Pensando Distributed Services Card can get firmware upgrades from
the off-host centralized management suite, and can be upgraded without a
host reboot or driver reload.  This patchset sets up the support for fw
upgrade in the Linux driver.

When the upgrade begins, the DSC first brings the link down, then stops
the firmware.  The driver will notice this and quiesce itself by stopping
the queues and releasing DMA resources, then monitoring for firmware to
start back up.  When the upgrade is finished the firmware is restarted
and link is brought up, and the driver rebuilds the queues and restarts
traffic flow.

First we separate the Link state from the netdev state, then reorganize a
few things to prepare for partial tear-down of the queues.  Next we fix
up the state machine so that we take the Tx and Rx queues down and back
up when we get LINK_DOWN and LINK_UP events.  Lastly, we add handling of
the FW reset itself by tearing down the lif internals and rebuilding them
with the new FW setup.

v2: This changes the design from (ab)using the full .ndo_stop and
    .ndo_open routines to getting a better separation between the
    alloc and the init functions so that we can keep our resource
    allocations as long as possible.

Shannon Nelson (8):
  ionic: decouple link message from netdev state
  ionic: check for linkup in watchdog
  ionic: move debugfs add/delete to match alloc/free
  ionic: move irq request to qcq alloc
  ionic: clean tx queue of unfinished requests
  ionic: check for queues before deleting
  ionic: disable the queues on link down
  ionic: remove lifs on fw reset

 .../net/ethernet/pensando/ionic/ionic_dev.c   |  46 ++-
 .../net/ethernet/pensando/ionic/ionic_dev.h   |   1 +
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 390 +++++++++++-------
 .../net/ethernet/pensando/ionic/ionic_lif.h   |   5 +
 .../net/ethernet/pensando/ionic/ionic_main.c  |   8 +-
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  16 +
 .../net/ethernet/pensando/ionic/ionic_txrx.h  |   1 +
 7 files changed, 322 insertions(+), 145 deletions(-)

-- 
2.17.1

