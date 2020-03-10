Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD531800FF
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 16:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727488AbgCJPEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 11:04:00 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:10606 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726295AbgCJPEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 11:04:00 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02AEtw7K011804;
        Tue, 10 Mar 2020 08:03:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=ks9FqzUZeT5Syqtav1fB+k81VWUFMmwklgRl+52XaLc=;
 b=t1g7e14Kq6iD2Jx1RkIT+ZB3MczS1Pq/8cBBCkarhRdkqZwQmDO14Mgrl3aHqZ4rcng/
 CX/cYJ4zy/sIwde2d2V9NYWX1rJrre9flXWvI7bvt2QMpMn9N7CprxGsxb3VuMj2jgpo
 9YkcsJ3kgKo1DYMw9ldTa9gRkGTbZuAhzwRt36r6PdlwL5sGcYdjGM/gmDGi9d8UnGkv
 ChJAgBEQOLUkSP5XP0FnmO4AIiJqic8wM33Yr4pwRG5b8Jpxw4OBj7njdgUycSDhgld0
 G3wlTfYyXNrMmp98YV2jJgRCFUwYWF9bgqY0Ekun5v9Kk6LRozq5mYm++agm/kqk//jH ow== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2yp04fm0pk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 10 Mar 2020 08:03:57 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Mar
 2020 08:03:55 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 10 Mar 2020 08:03:55 -0700
Received: from NN-LT0019.rdc.aquantia.com (nn-lt0019.marvell.com [10.9.16.69])
        by maili.marvell.com (Postfix) with ESMTP id 812A03F703F;
        Tue, 10 Mar 2020 08:03:54 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     Mark Starovoytov <mstarovoitov@marvell.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [RFC v2 00/16]  net: atlantic: MACSec support for AQC devices
Date:   Tue, 10 Mar 2020 18:03:26 +0300
Message-ID: <20200310150342.1701-1-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-10_08:2020-03-10,2020-03-10 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This RFC patchset introduces MACSec HW offloading support in
Marvell(Aquantia) AQC atlantic driver.

This implementation is a joint effort of Marvell developers on top of
the work started by Antoine Tenart.

RFC v2:
  - Split out patch for updating the SCI upon MAC address change.
    Sent as a net tree fix;
  - Improved changelog for "net: macsec: add support for getting offloaded
    stats" patch (patch 0008 in this series);
  - Don't fallback to s/w stats when offloading is enabled;
  - Removed the "enable HW offloading by default" patch. Separate patch
    will be submitted to enable specifying the desired offload upon macsec
    device creation (upon ip link add);
  - Accommodated comments related to "MACSec offload skeleton" patch.

v1: https://patchwork.ozlabs.org/cover/1238082/

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

Mark Starovoytov (4):
  net: macsec: support multicast/broadcast when offloading
  net: macsec: report real_dev features when HW offloading is enabled
  net: atlantic: MACSec ingress offload HW bindings
  net: atlantic: MACSec ingress offload implementation

 drivers/net/ethernet/aquantia/Kconfig         |    1 +
 .../net/ethernet/aquantia/atlantic/Makefile   |    7 +-
 .../ethernet/aquantia/atlantic/aq_ethtool.c   |  160 +-
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |    6 +
 .../ethernet/aquantia/atlantic/aq_macsec.c    | 1840 +++++++++++
 .../ethernet/aquantia/atlantic/aq_macsec.h    |  138 +
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |   21 +-
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |    6 +-
 .../ethernet/aquantia/atlantic/aq_pci_func.c  |    5 +
 .../aquantia/atlantic/hw_atl/hw_atl_utils.h   |   51 +-
 .../atlantic/hw_atl/hw_atl_utils_fw2x.c       |   69 +
 .../atlantic/macsec/MSS_Egress_registers.h    |   78 +
 .../atlantic/macsec/MSS_Ingress_registers.h   |   82 +
 .../aquantia/atlantic/macsec/macsec_api.c     | 2938 +++++++++++++++++
 .../aquantia/atlantic/macsec/macsec_api.h     |  328 ++
 .../aquantia/atlantic/macsec/macsec_struct.h  |  919 ++++++
 drivers/net/macsec.c                          |  447 ++-
 include/linux/netdev_features.h               |    3 +
 include/linux/netdevice.h                     |    9 +
 include/net/macsec.h                          |   29 +-
 include/uapi/linux/if_link.h                  |    1 +
 net/ethtool/common.c                          |    1 +
 tools/include/uapi/linux/if_link.h            |    1 +
 23 files changed, 6962 insertions(+), 178 deletions(-)
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/aq_macsec.h
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/macsec/MSS_Egress_registers.h
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/macsec/MSS_Ingress_registers.h
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.h
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/macsec/macsec_struct.h

-- 
2.17.1

