Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3A8E37624D
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 10:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236420AbhEGIsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 04:48:45 -0400
Received: from inva020.nxp.com ([92.121.34.13]:59638 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230302AbhEGIsp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 May 2021 04:48:45 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id C0CEE1A09FD;
        Fri,  7 May 2021 10:47:44 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id E4A271A19BF;
        Fri,  7 May 2021 10:47:41 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 3F4CA4029F;
        Fri,  7 May 2021 10:47:38 +0200 (CEST)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next 0/6] ptp: support virtual clocks for multiple domains
Date:   Fri,  7 May 2021 16:57:50 +0800
Message-Id: <20210507085756.20427-1-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PTP hardware clock user space API, together with SO_TIMESTAMPING socket
options presents a standardized method for developing PTP user space
programs.

Current ptp driver exposes only one /dev/ptpN device which is the time
source for hardware timestamping. No matter the /dev/ptpN device is
registered by a physical clock or a virtual clock utilizing timecounter,
there is only one.

This patch-set provides a way to support PTP virtual clocks for multiple
domains:

- Register PTP virtual clock with specified domain via sysfs. No number
  limitation. Or remove them via sysfs if not needs them.

- The domain that ptp clock serves could be changed via sysfs too.

- Regarding network timestamp, the additional work to support domain is
  parsing PTP packet domain number, and convert hardware timestamp to
  domain time before transmitting it to upper stack. (If no ptp device
  serves the domain, just use the hardware timestamp. No conversion.)

So actually, the ptp virtual clock driver exposes more /dev/ptpN
devices for using. The timestamp conversion to domain time is handled in
driver. No user space API changing to support multiple domains.
And single domain PTP user space application could be ran multiple times
in background for multiple domains synchronization verification.

For example, we have ptp virtual clocks ptp1, ptp2, and ptp3 registered
for domain 1, 2 and 3 on board1. We could run ptp4l for 3 domains
synchronization on board1.

  ptp4l -i eno0 -p/dev/ptp1 -m --domainNumber=1 --priority1=127 > domain1-master.log 2>&1 &
  ptp4l -i eno0 -p/dev/ptp2 -m --domainNumber=2 --priority1=127 > domain2-master.log 2>&1 &
  ptp4l -i eno0 -p/dev/ptp3 -m --domainNumber=3 --priority1=128 > domain3-slave.log 2>&1 &

On board2 which is connected to board1 in back-to-back way, we have ptp
virtual clocks ptp1, ptp2, and ptp3 registered for domain 1, 2 and 3.
We could run ptp4l for 3 domains synchronization with board1 on board2.

  ptp4l -i eno0 -p/dev/ptp1 -m --domainNumber=1 --priority1=128 > domain1-slave.log 2>&1 &
  ptp4l -i eno0 -p/dev/ptp2 -m --domainNumber=2 --priority1=128 > domain2-slave.log 2>&1 &
  ptp4l -i eno0 -p/dev/ptp3 -m --domainNumber=3 --priority1=127 > domain3-master.log 2>&1 &

But this patch-set is not perfect. And there is still much work to do,
such as,

- Make changing on physical clock transparent to virtual clocks.
  The virtual clock is based on free running physical clock. If physical
  clock has to be changed, how to make the change transparent to all
  virtual clocks? Actually the frequency adjustmend on physical clock
  may be hidden by updating virtual clocks in opposite direction at same
  time. Considering the ppb values adjusted, the code execution delay
  will be little enough to ignore. But it's hard to hide clock stepping,
  by now I think the workaround may be inhibiting physical clock stepping
  when run user space ptp application.

- User space API for PTP virtual clock registering/removing, for user
  space PTP application.

- Make common function for ptp domain parsing so that any driver could
  use it.

- We may consider some reworking on this ptp virtual clock driver, so that
  current ptp device drivers with timecounter used may convert to use it.

Yangbo Lu (6):
  ptp: add ptp virtual clock driver framework
  ptp: support virtual clock and domain via sysfs
  ptp_qoriq: export ptp clock reading function for cyclecounter
  enetc_ptp: support ptp virtual clock
  enetc: store ptp device pointer
  enetc: support PTP domain timestamp conversion

 Documentation/ABI/testing/sysfs-ptp           |  25 +++
 MAINTAINERS                                   |   6 +
 drivers/net/ethernet/freescale/enetc/enetc.c  |  37 +++-
 drivers/net/ethernet/freescale/enetc/enetc.h  |   1 +
 .../net/ethernet/freescale/enetc/enetc_pf.c   |   5 +
 .../net/ethernet/freescale/enetc/enetc_ptp.c  |  11 ++
 .../net/ethernet/freescale/enetc/enetc_vf.c   |   5 +
 drivers/ptp/Makefile                          |   2 +-
 drivers/ptp/ptp_private.h                     |  25 +++
 drivers/ptp/ptp_qoriq.c                       |  15 ++
 drivers/ptp/ptp_sysfs.c                       | 122 ++++++++++++
 drivers/ptp/ptp_vclock.c                      | 176 ++++++++++++++++++
 include/linux/fsl/ptp_qoriq.h                 |   1 +
 include/linux/ptp_clock_kernel.h              |  51 +++++
 14 files changed, 478 insertions(+), 4 deletions(-)
 create mode 100644 drivers/ptp/ptp_vclock.c


base-commit: 9d31d2338950293ec19d9b095fbaa9030899dcb4
-- 
2.25.1

