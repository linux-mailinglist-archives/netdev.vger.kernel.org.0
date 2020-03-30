Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66045198840
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 01:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729146AbgC3X1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 19:27:43 -0400
Received: from gateway23.websitewelcome.com ([192.185.49.184]:39835 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729060AbgC3X1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 19:27:43 -0400
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id 0D3AB64CA2
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 18:27:06 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id J3oAjP6YNVQh0J3oAjc9XK; Mon, 30 Mar 2020 18:27:06 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xhDG3dLN6Yo/RcJTREoCUsHNM+lDjok6pPw8Y/2IHM8=; b=MtlPW6u5+hLcKOUUXlj4aIV1Rj
        9B0gN5E8BYFgAboLKbVSMJv9CLzUllkbOGoJ5uVeFjdQyFcsKSgmb94YHCEluUiTLdiIvl1Iw9Kh7
        UEysDtp3D/TKEt7UoawdP5pIKFmEHmuEMtb7KbEw87S5JLEHhtvync+0lQAgbAzrPAvDNlKdr0oTQ
        eA8UgVSLM4dW4VduF9LpxGAlWDgc4Tm3z3+eEsqipTPVemYbRNIL5Ke+1I5Z0C6OTZU+aRH6MqoX3
        z4peADMt/7/RUsPjpqton+bGTUBsDpELiYI4qwLsuRc+1PGByVH7+q93N0/n5A3Oy6DSG1aAacQ1n
        mRKizwoQ==;
Received: from cablelink-189-218-116-241.hosts.intercable.net ([189.218.116.241]:50684 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1jJ3o8-000bhq-I6; Mon, 30 Mar 2020 18:27:04 -0500
Date:   Mon, 30 Mar 2020 18:27:02 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH net-next] netdevsim: dev: Fix memory leak in
 nsim_dev_take_snapshot_write
Message-ID: <20200330232702.GA3212@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 189.218.116.241
X-Source-L: No
X-Exim-ID: 1jJ3o8-000bhq-I6
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: cablelink-189-218-116-241.hosts.intercable.net (embeddedor) [189.218.116.241]:50684
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 5
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case memory resources for dummy_data were allocated, release them
before return.

Addresses-Coverity-ID: 1491997 ("Resource leak")
Fixes: 7ef19d3b1d5e ("devlink: report error once U32_MAX snapshot ids have been used")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/netdevsim/dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 2b727a7001f6..9897e9a0e26f 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -75,6 +75,7 @@ static ssize_t nsim_dev_take_snapshot_write(struct file *file,
 	err = devlink_region_snapshot_id_get(devlink, &id);
 	if (err) {
 		pr_err("Failed to get snapshot id\n");
+		kfree(dummy_data);
 		return err;
 	}
 	err = devlink_region_snapshot_create(nsim_dev->dummy_region,
-- 
2.23.0

