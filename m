Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B427CD8C78
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 11:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391947AbfJPJY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 05:24:26 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:22852 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726480AbfJPJY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 05:24:26 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Oct 2019 05:24:25 EDT
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Wed, 16 Oct 2019 02:09:21 -0700
Received: from akaher-virtual-machine.eng.vmware.com (unknown [10.197.103.239])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 66AE5B2609;
        Wed, 16 Oct 2019 05:09:23 -0400 (EDT)
From:   Ajay Kaher <akaher@vmware.com>
To:     <gregkh@linuxfoundation.org>
CC:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>, <jmorris@namei.org>,
        <yoshfuji@linux-ipv6.org>, <kaber@trash.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, <srivatsab@vmware.com>,
        <srivatsa@csail.mit.edu>, <amakhalov@vmware.com>,
        <srinidhir@vmware.com>, <bvikas@vmware.com>, <anishs@vmware.com>,
        <vsirnapalli@vmware.com>, <srostedt@vmware.com>,
        <akaher@vmware.com>, "Mao Wenan" <maowenan@huawei.com>
Subject: [PATCH 4.9.y] Revert "net: sit: fix memory leak in sit_init_net()"
Date:   Wed, 16 Oct 2019 14:33:54 +0530
Message-ID: <1571216634-44834-1-git-send-email-akaher@vmware.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-001.vmware.com: akaher@vmware.com does not
 designate permitted sender hosts)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 375d6d454a95ebacb9c6eb0b715da05a4458ffef which is
commit 07f12b26e21ab359261bf75cfcb424fdc7daeb6d upstream.

Unnecessarily calling free_netdev() from sit_init_net().
ipip6_dev_free() of 4.9.y called free_netdev(), so no need
to call again after ipip6_dev_free().

Cc: Mao Wenan <maowenan@huawei.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ajay Kaher <akaher@vmware.com>
---
 net/ipv6/sit.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 47ca2a2..16eba7b 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1856,7 +1856,6 @@ static int __net_init sit_init_net(struct net *net)
 
 err_reg_dev:
 	ipip6_dev_free(sitn->fb_tunnel_dev);
-	free_netdev(sitn->fb_tunnel_dev);
 err_alloc_dev:
 	return err;
 }
-- 
2.7.4

