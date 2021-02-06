Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA076311CBB
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 11:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbhBFKu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 05:50:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:52460 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229570AbhBFKul (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 05:50:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1612608587; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=dE46dgUQjvo/vJLSEaUtAdX4bEkarOQCB+4cTFCnP1M=;
        b=QrCfkhZ9kH6dd3p0kbDY5etXQLR7YA6fF7S4sBCvIYn3HsEhD8zDi8/nrJAkjr+5OiuNsO
        qR+sdnPHE3sVhc6pMZV3asmTaXx7t2OGH0pSGgLCV/LVP9RbwfgXXcjXrnMW/fO54ZX1ek
        UhKlmhgCima7ddr5rYrpiYWaVy5Ib8M=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DD5BDAD29;
        Sat,  6 Feb 2021 10:49:46 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Jens Axboe <axboe@kernel.dk>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 0/7] xen/events: bug fixes and some diagnostic aids
Date:   Sat,  6 Feb 2021 11:49:25 +0100
Message-Id: <20210206104932.29064-1-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first three patches are fixes for XSA-332. The avoid WARN splats
and a performance issue with interdomain events.

Patches 4 and 5 are some additions to event handling in order to add
some per pv-device statistics to sysfs and the ability to have a per
backend device spurious event delay control.

Patches 6 and 7 are minor fixes I had lying around.

Juergen Gross (7):
  xen/events: reset affinity of 2-level event initially
  xen/events: don't unmask an event channel when an eoi is pending
  xen/events: fix lateeoi irq acknowledgement
  xen/events: link interdomain events to associated xenbus device
  xen/events: add per-xenbus device event statistics and settings
  xen/evtch: use smp barriers for user event ring
  xen/evtchn: read producer index only once

 drivers/block/xen-blkback/xenbus.c  |   2 +-
 drivers/net/xen-netback/interface.c |  16 ++--
 drivers/xen/events/events_2l.c      |  20 +++++
 drivers/xen/events/events_base.c    | 133 ++++++++++++++++++++++------
 drivers/xen/evtchn.c                |   6 +-
 drivers/xen/pvcalls-back.c          |   4 +-
 drivers/xen/xen-pciback/xenbus.c    |   2 +-
 drivers/xen/xen-scsiback.c          |   2 +-
 drivers/xen/xenbus/xenbus_probe.c   |  66 ++++++++++++++
 include/xen/events.h                |   7 +-
 include/xen/xenbus.h                |   7 ++
 11 files changed, 217 insertions(+), 48 deletions(-)

-- 
2.26.2

