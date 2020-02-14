Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEAFC15DA25
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 16:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729470AbgBNPDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 10:03:14 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:29184 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729268AbgBNPDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 10:03:14 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01EF02LF019060;
        Fri, 14 Feb 2020 07:03:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=faW9IgFdtek7L/Wtj5Hprh9BgB808Pkq6XyDkSC0zzc=;
 b=eWwd1UDNG9pqwYozAkuISndWBcAaqkhehQVwa3QXN55l/IKU03Qg4i+Dl1uHWvPnAlfm
 RSmKf+i6Z/bZMQ+3yFZUxMbDASv+mtNdhM6SojTpuU0EYrJxeV+lxAVXXrS/r9arM7SZ
 eQzSn0P/kOYIYX04PRhJLj2T/8ts8zu5ijNTBmJq7TRmPro+sC3RB14MbUQqHFVVmuR/
 kgGsMjMQ3zn79eAJ/NgeLpSXSrds7emA0ILMnOZKTYccm0EetvgBqNL3Q9+0OTY8HnjQ
 JeZpu7Fb2OTLKkzICVe6oI5lShkmj7X58CHj8rD7JAp+cCgreXP3whgi9ErivhAdc8/o 2w== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2y4be2n5jd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 07:03:09 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 14 Feb
 2020 07:03:08 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 14 Feb 2020 07:03:08 -0800
Received: from NN-LT0019.rdc.aquantia.com (unknown [10.9.16.63])
        by maili.marvell.com (Postfix) with ESMTP id 970D93F703F;
        Fri, 14 Feb 2020 07:03:06 -0800 (PST)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [RFC 00/18] net: atlantic: MACSec support for AQC devices
Date:   Fri, 14 Feb 2020 18:02:40 +0300
Message-ID: <20200214150258.390-1-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-14_04:2020-02-12,2020-02-14 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This RFC patchset introduces MACSec HW offloading support in
Marvell(Aquantia) AQC atlantic driver.

This implementation is a joint effort of Marvell developers on top of
the work started by Antoine Tenart.

Several patches introduce backward-incompatible changes and are
subject for discussion/drop:

1) patch 0008:
  multicast/broadcast when offloading is needed to handle ARP requests,
  because they have broadcast destination address;
  With this patch we also match and encrypt/decrypt packets between macsec
  hw and realdev based on device's mac address.
  This potentially can be used to support multiple macsec offloaded interfaces
  on top of one realdev.
  On some environments however this could lead to problems, e.g. bridge over
  macsec configuration will expect packets with unknown src MAC
  should come through macsec.
  The patch is questionable, we've used it because our current hw setup and
  requirements assumes decryption is only done based on mac address match.
  This could be changed by encrypting/decripting all the traffic (except control).

2) patch 0010:
   HW offloading is enabled by default. This is a workaround for the fact
   that macsec offload can't be configured at the moment of macsec device
   creation. This causes side effects on atlantic device. The best way to
   resolve this is to implement an option in ip tools to specify macsec
   offload type immediately inside the command where it is created.
   Such a comment was proposed in ip tools discussion.

3) patch 0011:
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

Dmitry Bogdanov (9):
  net: macsec: init secy pointer in macsec_context
  net: macsec: invoke mdo_upd_secy callback when mac address changed
  net: macsec: allow multiple macsec devices with offload
  net: macsec: add support for getting offloaded stats
  net: atlantic: MACSec offload skeleton
  net: atlantic: MACSec egress offload HW bindings
  net: atlantic: MACSec egress offload implementation
  net: atlantic: MACSec offload statistics HW bindings
  net: atlantic: MACSec offload statistics implementation

Mark Starovoytov (5):
  net: macsec: support multicast/broadcast when offloading
  net: macsec: enable HW offloading by default (when available)
  net: macsec: report real_dev features when HW offloading is enabled
  net: atlantic: MACSec ingress offload HW bindings
  net: atlantic: MACSec ingress offload implementation

 .../net/ethernet/aquantia/atlantic/Makefile   |    6 +-
 .../ethernet/aquantia/atlantic/aq_ethtool.c   |  160 +-
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |    6 +
 .../ethernet/aquantia/atlantic/aq_macsec.c    | 1842 +++++++++++
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
 drivers/net/macsec.c                          |  510 ++-
 include/linux/netdev_features.h               |    3 +
 include/linux/netdevice.h                     |    9 +
 include/net/macsec.h                          |   29 +-
 include/uapi/linux/if_link.h                  |    1 +
 net/ethtool/common.c                          |    1 +
 tools/include/uapi/linux/if_link.h            |    1 +
 22 files changed, 7018 insertions(+), 185 deletions(-)
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/aq_macsec.h
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/macsec/MSS_Egress_registers.h
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/macsec/MSS_Ingress_registers.h
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.h
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/macsec/macsec_struct.h

-- 
2.17.1

