Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F50D211DCC
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 10:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgGBINQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 04:13:16 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:31878 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbgGBINP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 04:13:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593677594; x=1625213594;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Yl2VuSGjDWMQiuL7KQmLjM60vMbdhACMmPH2M/uS8AI=;
  b=Cjb/Gq85dtEqcYo4xHVUNCpu9HJJese/PSqoGVjXgjJIbwlCB+Lw8YFr
   ek5ER9VqeCOpiR+6rfQrZzArr8QYhU6JdiljSzO/a2kBUItfsykAA6Bm8
   BkQ2LhA2ccQGGOVxIpkD6QLrG1a62+IvOcDB7eZSefHbNv8nfR8ki1M+a
   OP4ZcwlM4IfHqu0Mqh7NqG04yPAhkYpgovd1nuuxXvkgd4YNvnMMMLl3k
   bhIhGB/+54ohRHCfc7ZQuYYOy9VJSPbGTZQRg47yG3T8Xb9tpjKmTOcZB
   n7Ljisq8ieoiaLB2wcfcHxhPCiYEPhrFkHOq9/lXe/smP4IC3NHZ4nKg7
   g==;
IronPort-SDR: d27XaLuMzYw/vdevJ2B/WamZccilcKMA0wEBvK45ggmZFnkAqv4RoHQKQRTIdMbSs/t4O/y9uX
 wjfWpDWBJojBJkFqQrGCH/zgTrr1AhJFc4NQKU7nz6Ns1ZjkAaOjTA2/oY4baFGqfQeFuyI5ki
 R1iirTvd5/+oDPQ2fR2vOHWjirkHAvL6B8tDryTE0LqyrK7WjWtAZLd5zzmur4ieAJTog7+78j
 uHD4mNU+JYPzalIep4KwLIHp+vkb4AwDwxKs41E8ec0Q+traMWj848D6UXq0zO33ixWlqEhm7B
 itU=
X-IronPort-AV: E=Sophos;i="5.75,303,1589266800"; 
   d="scan'208";a="80467644"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Jul 2020 01:13:13 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 2 Jul 2020 01:13:13 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Thu, 2 Jul 2020 01:12:50 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <jiri@mellanox.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 0/3] bridge: mrp: Add support for getting the status
Date:   Thu, 2 Jul 2020 10:13:04 +0200
Message-ID: <20200702081307.933471-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series extends the MRP netlink interface to allow the userspace
daemon to get the status of the MRP instances in the kernel.

v3:
  - remove misleading comment
  - fix to use correctly the RCU

v2:
  - fix sparse warnings

Horatiu Vultur (3):
  bridge: uapi: mrp: Extend MRP attributes to get the status
  bridge: mrp: Add br_mrp_fill_info
  bridge: Extend br_fill_ifinfo to return MPR status

 include/uapi/linux/if_bridge.h | 17 +++++++++
 include/uapi/linux/rtnetlink.h |  1 +
 net/bridge/br_mrp_netlink.c    | 64 ++++++++++++++++++++++++++++++++++
 net/bridge/br_netlink.c        | 25 ++++++++++++-
 net/bridge/br_private.h        |  7 ++++
 5 files changed, 113 insertions(+), 1 deletion(-)

-- 
2.27.0

