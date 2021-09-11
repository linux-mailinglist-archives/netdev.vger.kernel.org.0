Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84A5440781E
	for <lists+netdev@lfdr.de>; Sat, 11 Sep 2021 15:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237986AbhIKNXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Sep 2021 09:23:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:49020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237035AbhIKNVI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Sep 2021 09:21:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37B0561245;
        Sat, 11 Sep 2021 13:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631366072;
        bh=Hk6/lm38Mo/E7s7d+TYfx7X+xQAAR/8dc+MEWNECQQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hd90TZHFsaQ438vX7IBAf/qITDQEi7TfXfJyR1+R3iw3bx1hhssdkP9uKxUBgL7O7
         VCpJtimunka/ABZxaEDvp48kirjooa0hTiKn69rQ22kVbzEK9Cr7Pmu7ac/t3zDZjQ
         ruE8uK21QlYbG0LCF1vEQ+cCrrGF9n747VS8aa0LEnSaTSEy1Sb98LZkEz49jU+HIT
         aBmdZwDQIGnm0BO/XAoSIidiYrX7z07f9f/PyR/AF9UqTuY33CyZ1BYsnUWOvcl4NY
         2rx7ncq3VEaXGVr6MOiILxCdh9FtU3KXCMP+Nk9O6Qz1Q4GGMZCvrLGJmAjog2BP/t
         TRm0pJWnWJ8uA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 2/2] ethtool: Fix an error code in cxgb2.c
Date:   Sat, 11 Sep 2021 09:14:29 -0400
Message-Id: <20210911131429.286330-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210911131429.286330-1-sashal@kernel.org>
References: <20210911131429.286330-1-sashal@kernel.org>
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
index f5f1b0b51ebd..79eb2257a30e 100644
--- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
+++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
@@ -1133,6 +1133,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!adapter->registered_device_map) {
 		pr_err("%s: could not register any net devices\n",
 		       pci_name(pdev));
+		err = -EINVAL;
 		goto out_release_adapter_res;
 	}
 
-- 
2.30.2

