Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 655583187F6
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 11:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbhBKKTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 05:19:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:40916 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229639AbhBKKS1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 05:18:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1613038660; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=in+h4lBDIRM6mJ7t9cKXZa5bGbgsEjGF9LUcGBiK4pw=;
        b=V6/nHildAeeP4mTaW9pkNSIVN3W5JG7oTeZ/pm8uEYQwO4UvFiHUpuKpMve/BpBv1v2hDc
        zSTmNSzLpmjpGw4gEVI+1q7BnJ17tQmdjF7FJ39oRAfLmWt2kbB7tj8L2NeYypbl1pGYHA
        D4i8R84Uh3YQj183ZThezUvLnAY9qNY=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2F54EADA2;
        Thu, 11 Feb 2021 10:17:40 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2 0/8] xen/events: bug fixes and some diagnostic aids
Date:   Thu, 11 Feb 2021 11:16:08 +0100
Message-Id: <20210211101616.13788-1-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first four patches are fixes for XSA-332. The avoid WARN splats
and a performance issue with interdomain events.

Patches 5 and 6 are some additions to event handling in order to add
some per pv-device statistics to sysfs and the ability to have a per
backend device spurious event delay control.

Patches 7 and 8 are minor fixes I had lying around.

Juergen Gross (8):
  xen/events: reset affinity of 2-level event when tearing it down
  xen/events: don't unmask an event channel when an eoi is pending
  xen/events: avoid handling the same event on two cpus at the same time
  xen/netback: fix spurious event detection for common event case
  xen/events: link interdomain events to associated xenbus device
  xen/events: add per-xenbus device event statistics and settings
  xen/evtchn: use smp barriers for user event ring
  xen/evtchn: use READ/WRITE_ONCE() for accessing ring indices

 .../ABI/testing/sysfs-devices-xenbus          |  41 ++++
 drivers/block/xen-blkback/xenbus.c            |   2 +-
 drivers/net/xen-netback/interface.c           |  24 ++-
 drivers/xen/events/events_2l.c                |  22 +-
 drivers/xen/events/events_base.c              | 190 ++++++++++++++----
 drivers/xen/events/events_fifo.c              |   7 -
 drivers/xen/events/events_internal.h          |  14 +-
 drivers/xen/evtchn.c                          |  29 ++-
 drivers/xen/pvcalls-back.c                    |   4 +-
 drivers/xen/xen-pciback/xenbus.c              |   2 +-
 drivers/xen/xen-scsiback.c                    |   2 +-
 drivers/xen/xenbus/xenbus_probe.c             |  66 ++++++
 include/xen/events.h                          |   7 +-
 include/xen/xenbus.h                          |   7 +
 14 files changed, 323 insertions(+), 94 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-devices-xenbus

-- 
2.26.2

