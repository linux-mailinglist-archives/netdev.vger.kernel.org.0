Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88C20575DA
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727642AbfF0Ac5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:32:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:36672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727618AbfF0Acw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:32:52 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 640492083B;
        Thu, 27 Jun 2019 00:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595572;
        bh=pQKQ339g9+kyf4YsJLcT9olQk5Ox9kkrT3p5Hx86/pQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o255pYHaBHMuc0FxUshFegjPHOA0czzNGgpfPMDo8mYS73m7dN9uDyqKm5NQ3m1Nd
         YvReOBrgwuNOkcWfEZa+P3sqUZBjKhXoYjJ0IzYN9MiTSO1zlDo1F2BHoj8CZmymWj
         AoTuzoV+Lh6AY/RejOOPTnNQGKcwl2MGHPqzv0lM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Falcon <tlfalcon@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 44/95] ibmvnic: Refresh device multicast list after reset
Date:   Wed, 26 Jun 2019 20:29:29 -0400
Message-Id: <20190627003021.19867-44-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Falcon <tlfalcon@linux.ibm.com>

[ Upstream commit be32a24372cf162e825332da1a7ccef058d4f20b ]

It was observed that multicast packets were no longer received after
a device reset.  The fix is to resend the current multicast list to
the backing device after recovery.

Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 71bf895409a1..664e52fa7919 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1851,6 +1851,9 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 		return 0;
 	}
 
+	/* refresh device's multicast list */
+	ibmvnic_set_multi(netdev);
+
 	/* kick napi */
 	for (i = 0; i < adapter->req_rx_queues; i++)
 		napi_schedule(&adapter->napi[i]);
-- 
2.20.1

