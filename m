Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A870A7CED
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 09:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728948AbfIDHkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 03:40:14 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:7988 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728209AbfIDHkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 03:40:14 -0400
X-IronPort-AV: E=Sophos;i="5.64,465,1559491200"; 
   d="scan'208";a="74815429"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 04 Sep 2019 15:40:06 +0800
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 2AF7B4CE14E6;
        Wed,  4 Sep 2019 15:40:07 +0800 (CST)
Received: from localhost.localdomain (10.167.226.33) by
 G08CNEXCHPEKD03.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.439.0; Wed, 4 Sep 2019 15:40:10 +0800
From:   Su Yanjun <suyj.fnst@cn.fujitsu.com>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <suyj.fnst@cn.fujitsu.com>
Subject: [PATCH net] ipv4: fix ifa_flags reuse problem in using ifconfig tool
Date:   Wed, 4 Sep 2019 15:37:47 +0800
Message-ID: <1567582667-56549-1-git-send-email-suyj.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.33]
X-yoursite-MailScanner-ID: 2AF7B4CE14E6.A1108
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suyj.fnst@cn.fujitsu.com
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When NetworkManager has already set ipv4 address then uses
ifconfig set another ipv4 address. It will use previous ifa_flags
that will cause device route not be inserted.

As NetworkManager has already support IFA_F_NOPREFIXROUTE flag [1],
but ifconfig will reuse the ifa_flags. It's weird especially
some old scripts or program [2]  still  use ifconfig.

[1] https://gitlab.freedesktop.org/NetworkManager/NetworkManager/
commit/fec80e7473ad16979af75ed299d68103e7aa3fe9

[2] LTP or TAHI

Signed-off-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>
---
 net/ipv4/devinet.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index a4b5bd4..56ca339 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1159,6 +1159,7 @@ int devinet_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr)
 			inet_del_ifa(in_dev, ifap, 0);
 			ifa->ifa_broadcast = 0;
 			ifa->ifa_scope = 0;
+			ifa->ifa_flags = 0;
 		}
 
 		ifa->ifa_address = ifa->ifa_local = sin->sin_addr.s_addr;
-- 
2.7.4



