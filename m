Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D64B018BD4F
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 17:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728390AbgCSQ6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 12:58:12 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:59984 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727399AbgCSQ6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 12:58:11 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02JGw6GU033844;
        Thu, 19 Mar 2020 11:58:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1584637086;
        bh=aQNDZpwoD//NddOMwwOcYJ+olavsk0mn5RxqJOKX+0w=;
        h=From:To:CC:Subject:Date;
        b=OAzb32aFvJdopTSf9FiR51L2n3uu4PBPUMChpOG14NHszhyVB3YgldiiX4I4bVJx6
         QCq+IL4p7OrPfZaUF7XCEv0898T21U82xR8K4FTnw6KZXOloD7zwqFFqBpmjW7yRt2
         UqtJ7hAx+uyFHYCEe+YIPlqlMNm066JiAy4OOOGs=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 02JGw6GT022866
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 19 Mar 2020 11:58:06 -0500
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Thu, 19
 Mar 2020 11:58:06 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Thu, 19 Mar 2020 11:58:06 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02JGw5ST036056;
        Thu, 19 Mar 2020 11:58:05 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Tony Lindgren <tony@atomide.com>
CC:     Sekhar Nori <nsekhar@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        netdev <netdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v2 00/10] net: ethernet: ti: cpts: add irq and HW_TS_PUSH events
Date:   Thu, 19 Mar 2020 18:57:52 +0200
Message-ID: <20200319165802.30898-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Richard, All,

v2: no functional changes.

This is re-spin of patches to add CPSW IRQ and HW_TS_PUSH events support I've
sent long time ago [1]. In this series, I've tried to restructure and split changes,
and also add few additional optimizations comparing to initial RFC submission [1].

The HW_TS_PUSH events intended to serve for different timesync purposes on of
which is to add PPS generation function, which can be implemented as below:

                     +-----------------+
                     | Control         |
                     | application     |
            +------->+                 +----------+
            |        |                 |          |
            |        |                 |          |
            |        +-----------------+          |
            |                                     |
            |                                     |
            | PTP_EXTTS_REQUEST                   |
            |                                     |
            |                                     |
 +----------------------------------------------------------------+
            |                                     |    Kernel
    +-------+----------+                  +-------v--------+
    |  \dev\ptpX       |                  | /sys/class/pwm/|
    |                  |                  |                |
    +-------^----------+                  +-------+--------+
            |                                     |
            |                                     |
            |                             +-------v-------------------+
    +-------+----------+                  |                           |
    | CPTS driver      |                  |pwm/pwm-omap-dmtimer.c     |
    |                  |                  +---------------------------+
    +-------^----------+                  |clocksource/timer_ti_dm.c  |
            |                             +-------+-------------------+
            |HWx_TS_PUSH evt                      |
 +----------------------------------------------------------------+
            |                                     |         HW
    +-------+----------+                  +-------v--------+
    | CPTS             |                  | DMTimer        |
    |                  |                  |                |
    |      HWx_TS_PUSH X<-----------------+                |
    |                  +                  |                |
    +------------------+                  +-------+--------+
                                                  |
                                                  X timer4


As per my knowledge there is at least one public implemented above PPS generation
schema from Tusori Tibor [2] based on initial HW_TS_PUSH enable submission[1].
And now there is work done by Lokesh Vutla <lokeshvutla@ti.com> published to
enable PWM enable/improve PWM adjustment from user space [3][4][5].

Main changes comparing to initial submission:
- both RX/TX timestamp processing deferred to ptp worker
- both CPTS IRQ and polling events processing supported to make it work for
  Keystone 2 also
- switch to use new .gettimex64() interface
- no DT updates as number of HWx_TS_PUSH inputs is static per HW

Dependency:
 ff7cf1822b93 kthread: mark timer used by delayed kthread works as IRQ safe
 which was merged in -next, but has to be back-ported for testing with earlier
 versions

Testing on am571x-idk/omap2plus_defconfig/+CONFIG_PREEMPT=y:
1) testing HW_TS_PUSH
 - enable pwm in DT
	pwm16: dmtimer-pwm {
		compatible = "ti,omap-dmtimer-pwm";
		ti,timers = <&timer16>;
		#pwm-cells = <3>;
	};
 - configure and start pwm
  echo 0 > /sys/class/pwm/pwmchip0/export                                                                          
  echo 1000000000 > /sys/class/pwm/pwmchip0/pwm0/period                                                            
  echo 500000000 > /sys/class/pwm/pwmchip0/pwm0/duty_cycle                                                         
  echo 1 > /sys/class/pwm/pwmchip0/pwm0/enable   
 - test HWx_TS_PUSH using Kernel selftest testptp application
  ./tools/testing/selftests/ptp/testptp -d /dev/ptp0 -e 1000 -i 3

2) testing phc2sys
# ./linuxptp/phc2sys -s CLOCK_REALTIME -c eth0 -m -O 0 -u30                                            
phc2sys[1616.791]: eth0 rms 408190379792180864 max 1580914543017209856 freq +864 +/- 4635 delay 645 +/- 29
phc2sys[1646.795]: eth0 rms 41 max 108 freq +0 +/- 36 delay 656 +/- 29
phc2sys[1676.800]: eth0 rms 43 max 83 freq +2 +/- 38 delay 650 +/- 0
phc2sys[1706.804]: eth0 rms 39 max 87 freq +4 +/- 34 delay 672 +/- 55
phc2sys[1736.808]: eth0 rms 35 max 66 freq +1 +/- 30 delay 667 +/- 49
phc2sys[1766.813]: eth0 rms 38 max 79 freq +2 +/- 33 delay 656 +/- 29
phc2sys[1796.817]: eth0 rms 45 max 98 freq +1 +/- 39 delay 656 +/- 29
phc2sys[1826.821]: eth0 rms 40 max 87 freq +5 +/- 35 delay 650 +/- 0
phc2sys[1856.826]: eth0 rms 29 max 76 freq -0 +/- 25 delay 656 +/- 29
phc2sys[1886.830]: eth0 rms 40 max 97 freq +4 +/- 35 delay 667 +/- 49
phc2sys[1916.834]: eth0 rms 42 max 94 freq +2 +/- 36 delay 661 +/- 41
phc2sys[1946.839]: eth0 rms 40 max 91 freq +2 +/- 35 delay 661 +/- 41
phc2sys[1976.843]: eth0 rms 46 max 88 freq -0 +/- 40 delay 667 +/- 49
phc2sys[2006.847]: eth0 rms 49 max 97 freq +2 +/- 43 delay 650 +/- 0

3) testing ptp4l
- 1G connection
# ./linuxptp/ptp4l -P -2 -H -i eth0 -l 6 -m -q -p /dev/ptp0 -f ptp.cfg -s                              
ptp4l[862.891]: port 1: UNCALIBRATED to SLAVE on MASTER_CLOCK_SELECTED
ptp4l[923.894]: rms 1019697354682 max 5768279314068 freq +26053 +/- 72 delay 488 +/- 1
ptp4l[987.896]: rms 13 max 26 freq +26005 +/- 29 delay 488 +/- 1
ptp4l[1051.899]: rms 14 max 50 freq +25895 +/- 21 delay 488 +/- 1
ptp4l[1115.901]: rms 11 max 27 freq +25878 +/- 17 delay 488 +/- 1
ptp4l[1179.904]: rms 10 max 27 freq +25857 +/- 12 delay 488 +/- 1
ptp4l[1243.906]: rms 14 max 37 freq +25851 +/- 15 delay 488 +/- 1
ptp4l[1307.909]: rms 12 max 33 freq +25835 +/- 15 delay 488 +/- 1
ptp4l[1371.911]: rms 11 max 27 freq +25832 +/- 14 delay 488 +/- 1
ptp4l[1435.914]: rms 11 max 26 freq +25823 +/- 11 delay 488 +/- 1
ptp4l[1499.916]: rms 10 max 29 freq +25829 +/- 11 delay 489 +/- 1
ptp4l[1563.919]: rms 11 max 27 freq +25827 +/- 12 delay 488 +/- 1

- 10M connection
# ./linuxptp/ptp4l -P -2 -H -i eth0 -l 6 -m -q -p /dev/ptp0 -f ptp.cfg -s                              
ptp4l[51.955]: port 1: UNCALIBRATED to SLAVE on MASTER_CLOCK_SELECTED
ptp4l[112.957]: rms 279468848453933920 max 1580914542977391360 freq +25390 +/- 3207 delay 8222 +/- 36
ptp4l[176.960]: rms 254 max 522 freq +25809 +/- 219 delay 8271 +/- 30
ptp4l[240.962]: rms 271 max 684 freq +25868 +/- 234 delay 8249 +/- 22
ptp4l[304.965]: rms 263 max 556 freq +25894 +/- 227 delay 8225 +/- 47
ptp4l[368.967]: rms 238 max 648 freq +25908 +/- 204 delay 8234 +/- 40
ptp4l[432.970]: rms 274 max 658 freq +25932 +/- 237 delay 8241 +/- 22
ptp4l[496.972]: rms 247 max 557 freq +25943 +/- 213 delay 8223 +/- 26
ptp4l[560.974]: rms 291 max 756 freq +25968 +/- 251 delay 8244 +/- 41
ptp4l[624.977]: rms 249 max 697 freq +25975 +/- 216 delay 8258 +/- 22

Changes in v2:
 - fixed (formatting) comments from David Miller <davem@davemloft.net>

v1: https://patchwork.ozlabs.org/cover/1254708/

[1] https://lore.kernel.org/patchwork/cover/799251/
[2] https://usermanual.wiki/Document/SetupGuide.632280828.pdf
    https://github.com/t-tibor/msc_thesis
[3] https://patchwork.kernel.org/cover/11421329/
[4] https://patchwork.kernel.org/cover/11433197/
[5] https://sourceforge.net/p/linuxptp/mailman/message/36943248/

Grygorii Strashko (10):
  net: ethernet: ti: cpts: use dev_yy() api for logs
  net: ethernet: ti: cpts: separate hw counter read from timecounter
  net: ethernet: ti: cpts: move tc mult update in cpts_fifo_read()
  net: ethernet: ti: cpts: switch to use new .gettimex64() interface
  net: ethernet: ti: cpts: optimize packet to event matching
  net: ethernet: ti: cpts: move tx timestamp processing to ptp worker
    only
  net: ethernet: ti: cpts: rework locking
  net: ethernet: ti: cpts: move rx timestamp processing to ptp worker
    only
  net: ethernet: ti: cpts: add irq support
  net: ethernet: ti: cpsw: enable cpts irq

 drivers/net/ethernet/ti/cpsw.c        |  35 +-
 drivers/net/ethernet/ti/cpsw_new.c    |  33 +-
 drivers/net/ethernet/ti/cpsw_priv.c   |  17 +-
 drivers/net/ethernet/ti/cpsw_priv.h   |   2 +
 drivers/net/ethernet/ti/cpts.c        | 508 +++++++++++++++++---------
 drivers/net/ethernet/ti/cpts.h        |  27 +-
 drivers/net/ethernet/ti/netcp_ethss.c |   3 +-
 7 files changed, 442 insertions(+), 183 deletions(-)

-- 
2.17.1

