Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAF61E77D0
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 10:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgE2IFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 04:05:51 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:12007 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgE2IFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 04:05:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1590739548; x=1622275548;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1j8r2lwJHp5ulvUar/6tSATkidOUKeT/fSsRUakAa/4=;
  b=IWOirYC1ZP6uVmw+pD5UCR8Hgy8hYGvJ1U84yJkL1LZ2QyFrnAfTMi5f
   hpwChKmtiq85BukhCqTkxVYBUWzHFTJY6IbRHQHPN78DLmDAb2uO5qFef
   noANQUcsADLmfcSKnGmIEWQI9/acVpy3/zpUmnJ04IIARyJSv7iQLIiAv
   IXWpV6gIs4SNloh+lIyq5oUOafIkbahlOAaaBJvv169yR598fejgymu8z
   odhcaJD49Y0jjphNJtK3OD98HVlnX0+LQa9XDG1NjjqFMSigqdTiWPBiJ
   FPp0TUdrkel0HjHuv+aJZguH4cJc0YS/MRcyX9XrUrBbkMxRwwNXF2U0l
   g==;
IronPort-SDR: e5l2prvpyvdvJ/xf0M93avS/ZfurjyADByBkLuA0Mx9ni0bU/lkv0KvnDmHTh3eZ7mi8BItQh4
 vGPgUhs77NHVpWa5+F2hikK+akbM7J5gJVbHgCfLPQdwiLjWFRyOdCGbTSfb97nzfBIqNp2g5g
 z7O+/kNa3RDnMQ1nBLhAMVmc5UQsN3r/xuze0+6Wl5w+Zh1xVYwIxWJVupaR+hvwBuan/6y4PZ
 001d0Be3A2n/T5EsixXT8/nzWu2q/dpjMKObb/Igp31Xh4DPbxeAIrxZlrNvGIGkml5zorTpn+
 9iY=
X-IronPort-AV: E=Sophos;i="5.73,447,1583218800"; 
   d="scan'208";a="81492430"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 May 2020 01:05:48 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 29 May 2020 01:05:48 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Fri, 29 May 2020 01:05:45 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <jiri@resnulli.us>, <ivecera@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 0/2] bridge: mrp: Add support for MRA role
Date:   Fri, 29 May 2020 10:05:12 +0000
Message-ID: <20200529100514.920537-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series extends the MRP with the MRA role.
A node that has the MRA role can behave as a MRM or as a MRC. In case there are
multiple nodes in the topology that has the MRA role then only one node can
behave as MRM and all the others need to be have as MRC. The node that has the
higher priority(lower value) will behave as MRM.
A node that has the MRA role and behaves as MRC, it just needs to forward the
MRP_Test frames between the ring ports but also it needs to detect in case it
stops receiving MRP_Test frames. In that case it would try to behave as MRM.

Horatiu Vultur (2):
  bridge: mrp: Set the priority of MRP instance
  bridge: mrp: Add support for role MRA

 include/net/switchdev.h         |   2 +
 include/uapi/linux/if_bridge.h  |   4 +
 include/uapi/linux/mrp_bridge.h |  38 ++++++++++
 net/bridge/br_mrp.c             | 128 +++++++++++++++++++++++++++-----
 net/bridge/br_mrp_netlink.c     |  11 +++
 net/bridge/br_mrp_switchdev.c   |   5 +-
 net/bridge/br_private_mrp.h     |   5 +-
 7 files changed, 171 insertions(+), 22 deletions(-)

-- 
2.26.2

