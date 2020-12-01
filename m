Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A282CA7C3
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 17:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391990AbgLAQIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 11:08:18 -0500
Received: from mailout09.rmx.de ([94.199.88.74]:34632 "EHLO mailout09.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388182AbgLAQIS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 11:08:18 -0500
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout09.rmx.de (Postfix) with ESMTPS id 4Cln7B2DCHzbgrf;
        Tue,  1 Dec 2020 17:07:34 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4Cln6x4fT1z2xCx;
        Tue,  1 Dec 2020 17:07:21 +0100 (CET)
Received: from N95HX1G2.wgnetz.xx (192.168.54.19) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Tue, 1 Dec
 2020 17:06:20 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        "Rob Herring" <robh+dt@kernel.org>
CC:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Christian Eggers <ceggers@arri.de>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v4 0/9] net: dsa: microchip: PTP support for KSZ956x
Date:   Tue, 1 Dec 2020 17:06:02 +0100
Message-ID: <20201201160611.22129-1-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.19]
X-RMX-ID: 20201201-170721-4Cln6x4fT1z2xCx-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is only little documentation for PTP available on the data sheet
[1] (more or less only the register reference). Questions to the
Microchip support were seldom answered comprehensively or in reasonable
time. So this is more or less the result of reverse engineering.

[1]
http://ww1.microchip.com/downloads/en/DeviceDoc/KSZ9563R-Data-Sheet-DS00002419D.pdf

Changes from v3  --> v4
------------------------
The first 2 patches of v3 have been applied.

[ 5/12]-->[ 3/9] - Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
[ 6/12]-->[ 4/9] - s/low active/active low/
                 - Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
[ 7/12]-->[ 5/9] - Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
[ 9/12]-->[ 7/9] - Remove useless case statement
                 - Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
[10/12]-->[ 8/9] - s/low active/active low/
                 - 80 chars per line
                 - Use IEEE 802.1AS mode (to suppress forwarding of PDelay messages)
                 - Enable/disable hardware timestaping at runtime (port_hwtstamp_set)
                 - Use mutex in port_hwtstamp_set
                 - Don't use port specific struct hwtstamp_config
                 - removed #ifdefs from tag_ksz.c
                 - Set port's tx_latency and rx_latency to 0
                 - added include/linux/dsa/ksz_common.h to MAINTAINERS
[11/12]          - removed Patch 11/12 (PPS support)
[12/12]-->[ 9/9] - 80 chars per line
                 - reverse christmas tree
                 - Set default pulse width for perout pulse to 50% (max. 125ms)
                 - reject unsupported flags for perout_request


Changes from v2  --> v3
------------------------
Applied all changes requested by Vladimir Oltean. v3 depends on my other
netdev patches from 2020-11-18:
- net: ptp: introduce common defines for PTP message types
- net: dsa: avoid potential use-after-free error

[1/11]-->[1/12]  - dts: remove " OR BSD-2-Clause" from SPDX-License-Identifier
                 - dts: add "additionalProperties"
                 - dts: remove quotes
[2/11]-->[2/12]  - Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
[3/11]           - [Patch removed] (split ksz_common.h)
[4/11]-->[3/12]  - Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
                 - fixed summary
[5/11]-->[4/12]  - Use "interrupts-extended" syntax
[6/11]-->[5+6/12] - Split up patch
                 - style fixes
                 - use GENMASK()
                 - IRQF_ONESHOT|IRQF_SHARED
[7/11]-->[7/12]  - Remove "default n" from Kconfig
                 - use mutex in adjfine()
                 - style fixes
[8/11]-->[8/12]  - Be more verbose in commit message
                 - Rename helper
                 - provide correction instead of t2
                 - simplify location of UDP header
[9/11]-->[9+10/12] - Split up patch
                 - Update commmit messages
                 - don't use OR operator on irqreturn_t
                 - spin_lock_irqsave() --> spin_lock_bh()
                 - style fixes
                 - remove rx_filter cases for DELAY_REQ
                 - use new PTP_MSGTYPE_* defines
                 - inline ksz9477_ptp_should_tstamp()
                 - ksz9477_tstamp_to_clock() --> ksz9477_tstamp_reconstruct()
                 - use shared data in include/linux/net/dsa/ksz_common.h
                 - wait for tx time stamp (within sleepable context)
                 - use boolean for tx time stamp enable
                 - move t2 from correction to tail tag (again)
                 - ...

Changes from RFC --> v2
------------------------
I think that all open questions regarding the RFC version could be solved.
dts: referenced to dsa.yaml
dts: changed node name to "switch" in example
dts: changed "ports" subnode to "ethernet-ports"
ksz_common: support "ethernet-ports" subnode
tag_ksz: fix usage of correction field (32 bit ns + 16 bit sub-ns)
tag_ksz: use cached PTP header from device's .port_txtstamp function
tag_ksz: refactored ksz9477_tstamp_to_clock()
tag_ksz: pdelay_req: only subtract 2 bit seconds from the correction field
tag_ksz: pdelay_resp: don't move (negative) correction to the egress tail tag
ptp_classify: add ptp_onestep_p2p_move_t2_to_correction helper
ksz9477_ptp: removed E2E support (as suggested by Vladimir)
ksz9477_ptp: removed master/slave sysfs attributes (nacked by Richard)
ksz9477_ptp: refactored ksz9477_ptp_port_txtstamp
ksz9477_ptp: removed "pulse" attribute
kconfig: depend on PTP_1588_CLOCK (instead of "imply")


