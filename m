Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE661928E9
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 13:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbgCYMw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 08:52:58 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:5546 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726998AbgCYMw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 08:52:58 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02PCp9W4014712;
        Wed, 25 Mar 2020 05:52:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=Kmmvf4/FT3YQ9/4nTycrCWCzvVVoH5n8j5Huy6jgq60=;
 b=O50GS0Cjq1j6Kc40dKLiJDHh0Yev5/jAocvD7t35Ad/QfhQhdPUmt3Jik/yJoAH5TLUC
 dmTNn2VWNpY7qDaCLRPZe+FNdycFkHmquIyk3OsK7MlkC7heOrUhJIXnURL5j6LLZzVV
 EK1X4ctQt3/m4kwGXBqLbnnjPLhfTIaBN9hBd6Vm07KqX2Bm4b7PQZd8nBPw76gcbhCb
 zxnCbDch6nnLp/SZTc6RqXtzRsgHGQTHnR8EQpabLpPqGc4Zn5yYl/uiLgA900lHu0HW
 fS0EPSGUYDE39RgFiKq3JEw5FDjhCbuHqTOSDh51Rm1Z31OxvCPD7EIWxGe3bNgcqXU/ 5Q== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3006xkr5n9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 25 Mar 2020 05:52:55 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 25 Mar
 2020 05:52:53 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 25 Mar 2020 05:52:53 -0700
Received: from localhost.localdomain (unknown [10.9.16.55])
        by maili.marvell.com (Postfix) with ESMTP id DC2BB3F703F;
        Wed, 25 Mar 2020 05:52:51 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     Mark Starovoytov <mstarovoitov@marvell.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "Igor Russkikh" <irusskikh@marvell.com>
Subject: [PATCH v2 net-next 00/17] net: atlantic: MACSec support for AQC devices
Date:   Wed, 25 Mar 2020 15:52:29 +0300
Message-ID: <20200325125246.987-1-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-25_05:2020-03-24,2020-03-25 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset introduces MACSec HW offloading support in
Marvell(Aquantia) AQC atlantic driver.

This implementation is a joint effort of Marvell developers on top of
the work started by Antoine Tenart.

v2:
 * clean up the generated code (removed useless bit operations);
 * use WARN_ONCE to avoid log spam;
 * use put_unaligned_be64;
 * removed trailing \0 and length limit for format strings;

v1: https://patchwork.ozlabs.org/cover/1259998/

RFC v2: https://patchwork.ozlabs.org/cover/1252204/

RFC v1: https://patchwork.ozlabs.org/cover/1238082/

Several patches introduce backward-incompatible changes and are
subject for discussion/drop:

1) patch 0007:
  multicast/broadcast when offloading is needed to handle ARP requests,
  because they have broadcast destination address;
  With this patch we also match and encrypt/decrypt packets between macsec
  hw and realdev based on device's mac address.
  This can potentially be used to support multiple macsec offloaded
  interfaces on top of one realdev.
  However in some environments this could lead to problems, e.g. the
  'bridge over macsec' configuration will expect the packets with unknown
  src MAC should come through macsec.
  The patch is questionable, we've used it because our current hw setup
  and requirements both assume that the decryption is done based on mac
  address match only.
  This could be changed by encrypting/decripting all the traffic (except
  control).

2) patch 0009:
  real_dev features are now propagated to macsec device (when HW
  offloading is enabled), otherwise feature set might lead to HW
  reconfiguration during MACSec configuration.
  Also, HW offloaded macsec should be able to keep LRO LSO features,
  since they are transparent for macsec engine (at least in our hardware).

Antoine Tenart (4):
  net: introduce the MACSEC netdev feature
  net: add a reference to MACsec ops in net_device
  net: macsec: allow to reference a netdev from a MACsec context
  net: macsec: add support for offloading to the MAC

Dmitry Bogdanov (8):
  net: macsec: init secy pointer in macsec_context
  net: macsec: allow multiple macsec devices with offload
  net: macsec: add support for getting offloaded stats
  net: atlantic: MACSec offload skeleton
  net: atlantic: MACSec egress offload HW bindings
  net: atlantic: MACSec egress offload implementation
  net: atlantic: MACSec offload statistics HW bindings
  net: atlantic: MACSec offload statistics implementation

Mark Starovoytov (5):
  net: macsec: support multicast/broadcast when offloading
  net: macsec: report real_dev features when HW offloading is enabled
  net: atlantic: MACSec ingress offload HW bindings
  net: atlantic: MACSec ingress offload implementation
  net: atlantic: add XPN handling

 drivers/net/ethernet/aquantia/Kconfig         |    1 +
 .../net/ethernet/aquantia/atlantic/Makefile   |    7 +-
 .../ethernet/aquantia/atlantic/aq_ethtool.c   |  160 +-
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |    6 +
 .../ethernet/aquantia/atlantic/aq_macsec.c    | 1777 ++++++++++++
 .../ethernet/aquantia/atlantic/aq_macsec.h    |  133 +
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |   21 +-
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |    6 +-
 .../ethernet/aquantia/atlantic/aq_pci_func.c  |    5 +
 .../aquantia/atlantic/hw_atl/hw_atl_utils.h   |   51 +-
 .../atlantic/hw_atl/hw_atl_utils_fw2x.c       |   69 +
 .../atlantic/macsec/MSS_Egress_registers.h    |   73 +
 .../atlantic/macsec/MSS_Ingress_registers.h   |   77 +
 .../aquantia/atlantic/macsec/macsec_api.c     | 2473 +++++++++++++++++
 .../aquantia/atlantic/macsec/macsec_api.h     |  323 +++
 .../aquantia/atlantic/macsec/macsec_struct.h  |  914 ++++++
 drivers/net/macsec.c                          |  452 ++-
 include/linux/netdev_features.h               |    3 +
 include/linux/netdevice.h                     |    9 +
 include/net/macsec.h                          |   29 +-
 include/uapi/linux/if_link.h                  |    1 +
 net/ethtool/common.c                          |    1 +
 tools/include/uapi/linux/if_link.h            |    1 +
 23 files changed, 6411 insertions(+), 181 deletions(-)
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/aq_macsec.h
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/macsec/MSS_Egress_registers.h
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/macsec/MSS_Ingress_registers.h
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.h
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/macsec/macsec_struct.h

-- 
2.17.1

