Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D82532B859F
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 21:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbgKRUbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 15:31:48 -0500
Received: from mailout06.rmx.de ([94.199.90.92]:33674 "EHLO mailout06.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726812AbgKRUbs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 15:31:48 -0500
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout06.rmx.de (Postfix) with ESMTPS id 4Cbvbz313Gz9vqV;
        Wed, 18 Nov 2020 21:31:43 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4Cbvbk5G1Mz2xDw;
        Wed, 18 Nov 2020 21:31:30 +0100 (CET)
Received: from N95HX1G2.wgnetz.xx (192.168.54.25) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Wed, 18 Nov
 2020 21:30:29 +0100
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
Subject: [PATCH net-next v3 00/12] net: dsa: microchip: PTP support for KSZ956x
Date:   Wed, 18 Nov 2020 21:30:01 +0100
Message-ID: <20201118203013.5077-1-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.25]
X-RMX-ID: 20201118-213130-4Cbvbk5G1Mz2xDw-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for PTP to the KSZ956x and KSZ9477 devices.

There is only little documentation for PTP available on the data sheet
[1] (more or less only the register reference). Questions to the
Microchip support were seldom answered comprehensively or in reasonable
time. So this is more or less the result of reverse engineering.

[1]
http://ww1.microchip.com/downloads/en/DeviceDoc/KSZ9563R-Data-Sheet-DS00002419D.pdf

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




