Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1B95281433
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 15:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbgJBNjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 09:39:47 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:64978 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387917AbgJBNjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 09:39:42 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 092DU81V005042;
        Fri, 2 Oct 2020 06:39:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=KTKcL+VHIp7pc/TWqouEIcmEdyTZLhZaH5Mkthe6Fug=;
 b=GnYatbnRCVvoQeI8E6v5w5rRPXbzs20gjyxaLtb0pvW3as5j9ubEAyns+aX2puxdaZD2
 ioMl+JB6EWZVfUHDgrW9HsJZirCh3HuvndAcBjo0/LfEkl7q4vzE7mj2mtZyiszZn1O7
 irjngby18od44msVwol207aRLuvlevYHIkTAPTNirU5HYwqo6XXDnamJWYtzONVnJurz
 7l4dY/81LFU1ek0O2y2RvYb2itqPRPpZJyt3jqtucIp/ECj6cuE9rZJ5byef4Cro/GaK
 Yic0Ar1VUB3MbuY7y3jEgZ+oOqv08k/T/qI+bX+CNDlMtcQ9cWkgdTMQO2QZp4Ret70b Sw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 33t55pj6r5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 06:39:34 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 2 Oct
 2020 06:39:32 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 2 Oct
 2020 06:39:31 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 2 Oct 2020 06:39:31 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.193.39.7])
        by maili.marvell.com (Postfix) with ESMTP id C82DE3F703F;
        Fri,  2 Oct 2020 06:39:29 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH v2 net-next 0/3] net: atlantic: phy tunables from mac driver
Date:   Fri, 2 Oct 2020 16:39:20 +0300
Message-ID: <20201002133923.1677-1-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-02_06:2020-10-02,2020-10-02 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series implements phy tunables settings via MAC driver callbacks.

AQC 10G devices use integrated MAC+PHY solution, where PHY is fully controlled
by MAC firmware. Therefore, it is not possible to implement separate phy driver
for these.

We use ethtool ops callbacks to implement downshift and EDPC tunables.

v2: comments from Andrew

Igor Russkikh (3):
  ethtool: allow netdev driver to define phy tunables
  net: atlantic: implement phy downshift feature
  net: atlantic: implement media detect feature via phy tunables

 .../ethernet/aquantia/atlantic/aq_ethtool.c   | 53 +++++++++++++++++++
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |  6 +++
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 49 +++++++++++++++++
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |  4 ++
 .../atlantic/hw_atl/hw_atl_utils_fw2x.c       | 37 +++++++++++++
 .../atlantic/hw_atl2/hw_atl2_utils_fw.c       | 13 +++++
 include/linux/ethtool.h                       |  4 ++
 net/ethtool/ioctl.c                           | 37 ++++++++-----
 8 files changed, 190 insertions(+), 13 deletions(-)

-- 
2.17.1

