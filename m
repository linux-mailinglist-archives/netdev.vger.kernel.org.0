Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC58538BD69
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 06:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239086AbhEUE2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 00:28:43 -0400
Received: from inva020.nxp.com ([92.121.34.13]:47074 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239043AbhEUE20 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 00:28:26 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id A752D1A02F7;
        Fri, 21 May 2021 06:26:28 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 inva020.eu-rdc02.nxp.com A752D1A02F7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com;
        s=nselector3; t=1621571188;
        bh=xWdpvUNHOpo1goBVDaGMkot3qL0rnwVRmFyYfs+yFJ4=;
        h=From:To:Cc:Subject:Date:From;
        b=BytnMPG1Ao1yGBQ0Com8jD/LJB3CDjyH7Zpzr7lR31kcQYW4REBmYXGR5S5XSh5Nf
         9O9sL6qj5n94GA7nZYtICX5oO9yBkcyTGxiYs2foqchn7bj5M71uf8Ad8FASpvD8aL
         7IysA9p+Dg5taSWB6wnZTSU7QDi1BiPQwinYUtdorJSiepnbgbUrxkORqvUhca2cqY
         MFoktwb4X/hNdHKKBT7ErG9b54LGCUhrJR5KbB9lGd55Ozn++6ctoIetHCyMmAtPxD
         e7u6muv5so5S1KbslZEdSp0cQC0BkXQU7tTZG9D6WGjES707nqL6+2kUQSVOKCpW66
         1ApnRA5OsJVZA==
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id C90D31A02C1;
        Fri, 21 May 2021 06:26:25 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 inva020.eu-rdc02.nxp.com C90D31A02C1
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 2CD5B4027E;
        Fri, 21 May 2021 12:26:22 +0800 (+08)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next, v2, 0/7] ptp: support virtual clocks for multiple
Date:   Fri, 21 May 2021 12:36:12 +0800
Message-Id: <20210521043619.44694-1-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current PTP driver exposes one PTP device to user which binds network
interface/interfaces to provide timestamping. Actually we have a way
utilizing timecounter/cyclecounter to virtualize any number of PTP
clocks based on a same free running physical clock for using.
The purpose of having multiple PTP virtual clocks is for user space
to directly/easily use them for multiple domains synchronization.

               +------------------------------+
MAC driver:    |      rx/tx PTP packet        |
               +------------------------------+
                               ^
                               | Match vclock via domain value
                               | Convert HW timestamp to domain time
                               v
         +--------------+--------------+--------------+
vclock:  | ptp1 domain1 | ptp2 domain2 | ptpN domainN |
         +--------------+--------------+--------------+
pclock:  |             ptp0 free running              |
         +--------------------------------------------+

The block diagram may explain how it works. Besides the PTP virtual
clocks, the PTP packet HW timestamp converting to domain time is also
done in kernel.

An example to use it:

  Run two ptp4l jobs on each of two boards for domain 1 and 2 synchronziation.

  Board1:
    # echo 2 > /sys/class/ptp/ptp0/num_vclocks
    [  282.230432] ptp ptp0: new virtual clock ptp2
    [  282.235211] ptp ptp0: new virtual clock ptp3
    [  282.240354] ptp ptp0: guarantee physical clock free running
    # echo 1 > /sys/class/ptp/ptp2/domain
    # echo 2 > /sys/class/ptp/ptp3/domain
    #
    # ptp4l -i eno0 -p/dev/ptp2 -m --domainNumber=1 --priority1=127 > domain1-master.log 2>&1 &
    # ptp4l -i eno0 -p/dev/ptp3 -m --domainNumber=2 --priority1=128 > domain2-slave.log 2>&1 &

  Board2:
    # echo 2 > /sys/class/ptp/ptp0/num_vclocks
    [  259.619382] ptp ptp0: new virtual clock ptp2
    [  259.624140] ptp ptp0: new virtual clock ptp3
    [  259.629315] ptp ptp0: guarantee physical clock free running
    # echo 1 > /sys/class/ptp/ptp2/domain
    # echo 2 > /sys/class/ptp/ptp3/domain
    #
    # ptp4l -i eno0 -p/dev/ptp2 -m --domainNumber=1 --priority1=128 > domain1-slave.log 2>&1 &
    # ptp4l -i eno0 -p/dev/ptp3 -m --domainNumber=2 --priority1=127 > domain2-master.log 2>&1 &

  Physical clock is guaranteed to stay free running when virtual clocks
  are created. To back use physical clock,

    # echo 0 > /sys/class/ptp/ptp0/num_vclocks
    [  531.249944] ptp ptp0: delete virtual clock ptp3
    [  531.254971] ptp ptp0: delete virtual clock ptp2
    [  531.259976] ptp ptp0: only physical clock in use now

How the patch-set affect current ptp drivers/function:

  - For current drivers, no impact on all existing function.

  - For drivers adapted to use it in the future, no impact on all
    existing function unless configuring value to num_vclocks in
    sysfs to convert to using virtual clocks.

  - For drivers adapted to use it with virtual clocks in using
    - Manual configurations are required for domain value in sysfs.
    - Manual configurations are required for application to specify
      right ptp device for domain on which the application will run.
    Note,
    - Physical clock is guaranteed to stay free running. Operation on it
      returns error.
    - If domain value of application has no PTP clock matched, the
      original HW timestamp will be used.

How to adapt drivers to use the feature:

  - During normally registering PTP clock for physical clock with
    ptp_clock_info, just fill the new member vclock_cc which contains
    cyclecounter info for virtual clock.

  - Timestamp conversion to domain time need to be done in MAC driver.
    When get HW timestamp, parse PTP packet domain value and convert
    timestamp to domain time by calling API ptp_clock_domain_tstamp(),
    before submitting to upper stack.

TODO:

  - PTP physical clock and its timestamping capabilities is still
    binding to network interface/interfaces through ethtool_ts_info.
    New way is needed to support querying all PTP virtual clocks
    and their timestamping capabilities. Making application to use
    PTP virtual clocks dynamically is a direction.

  - PTP packet parsing for domain value and one-step sync (not related
    to this patch-set) is common used. Make such functions common.

Changes for v2:
	- Converted to num_vclocks for creating virtual clocks.
	- Guranteed physical clock free running when using virtual
	  clocks.
	- Fixed build warning.
	- Updated copyright.

Yangbo Lu (7):
  ptp: add ptp virtual clock driver framework
  ptp: support ptp physical/virtual clocks conversion
  ptp: support domains and timestamp conversion
  ptp_qoriq: export ptp clock reading function for cyclecounter
  enetc_ptp: support ptp virtual clock
  enetc: store ptp device pointer
  enetc: support PTP domain timestamp conversion

 Documentation/ABI/testing/sysfs-ptp           |  25 +++
 MAINTAINERS                                   |   6 +
 drivers/net/ethernet/freescale/enetc/enetc.c  |  39 +++-
 drivers/net/ethernet/freescale/enetc/enetc.h  |   3 +-
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  14 +-
 .../net/ethernet/freescale/enetc/enetc_ptp.c  |  13 +-
 .../net/ethernet/freescale/enetc/enetc_vf.c   |  14 +-
 drivers/ptp/Makefile                          |   2 +-
 drivers/ptp/ptp_clock.c                       |  12 ++
 drivers/ptp/ptp_private.h                     |  42 +++++
 drivers/ptp/ptp_qoriq.c                       |  16 ++
 drivers/ptp/ptp_sysfs.c                       | 134 +++++++++++++
 drivers/ptp/ptp_vclock.c                      | 176 ++++++++++++++++++
 include/linux/fsl/ptp_qoriq.h                 |   3 +-
 include/linux/ptp_clock_kernel.h              |  57 +++++-
 15 files changed, 545 insertions(+), 11 deletions(-)
 create mode 100644 drivers/ptp/ptp_vclock.c


base-commit: 86544c3de6a2185409c5a3d02f674ea223a14217
-- 
2.25.1

