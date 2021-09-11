Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1133340780E
	for <lists+netdev@lfdr.de>; Sat, 11 Sep 2021 15:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236451AbhIKNWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Sep 2021 09:22:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:47874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237241AbhIKNUm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Sep 2021 09:20:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66919613A3;
        Sat, 11 Sep 2021 13:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631366062;
        bh=FJPYZ3QWQcYsXNT8H1aJ66oPr3SBQ4L8MtBE1/nCPHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ClE30WpaXo7U0o3866ninTW9cu6MYbeZAe9QSim8LOOcuNc3EO8BWcw6BVQZmr4Gg
         MRdKN1wBGNMdbXRikdMUwJaZx0ySbtVhrgVN0qGyGZj/0YGfv8lh688Vgew2shNatS
         UI4SJr1CIs9C+hsfjBw6HNFcLUFG8YLiW2YqU4G6MgBulBFmizFYTtuXVrZGEvL+6D
         WWif8uNV9J2UYctV5qIC7S+9TCnv6VpbTXgYOPVMj4IOLuRD9HdFRNacVITCoyIMK/
         mESK2Vbf90JQDSD0YjotIsXJIpvAhw2JyMYCMz7pdJDVQBBPv+5/EJtIacn+uvM9XU
         t5iLbyIi6oFKw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 5/5] ethtool: Fix an error code in cxgb2.c
Date:   Sat, 11 Sep 2021 09:14:14 -0400
Message-Id: <20210911131415.286125-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210911131415.286125-1-sashal@kernel.org>
References: <20210911131415.286125-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Li <yang.lee@linux.alibaba.com>

[ Upstream commit 7db8263a12155c7ae4ad97e850f1e499c73765fc ]

When adapter->registered_device_map is NULL, the value of err is
uncertain, we set err to -EINVAL to avoid ambiguity.

Clean up smatch warning:
drivers/net/ethernet/chelsio/cxgb/cxgb2.c:1114 init_one() warn: missing
error code 'err'

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
index 8623be13bf86..eef8fa100889 100644
--- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
+++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
@@ -1157,6 +1157,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!adapter->registered_device_map) {
 		pr_err("%s: could not register any net devices\n",
 		       pci_name(pdev));
+		err = -EINVAL;
 		goto out_release_adapter_res;
 	}
 
-- 
2.30.2

