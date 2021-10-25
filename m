Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A980439B09
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 18:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233758AbhJYQCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 12:02:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:34874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233734AbhJYQCg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 12:02:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16C5860C49;
        Mon, 25 Oct 2021 16:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635177614;
        bh=6tTG7AA0UonWwdO8Ks74V07UuNZdM/2ZWdLfZaKr9Ug=;
        h=From:To:Cc:Subject:Date:From;
        b=UJGXAfD/2WfUTgSrFrjZMuruFOo8wrFyU0ixV2fUyfbAew7uZkw2zwIT1IyRJf306
         9l0WwRq35B5KZNPr7r/zmU0JG3EwvvpaaneaEK3COJ0gbhZWRqJk4A/e4u7IO/0iKW
         vvKN+U4xpULuG7Bs3lDg+kz4xJ8bvWwKTtdesvM7hI8ibpQuqfCMNMK7C9poCxdRZ+
         9XZAbWQBjGm/q8QiC55d9Ax2+5qokYG+soEjbPn2Oczkz3ffW0V6SIA+PmmZoStPIU
         1JD+/r17+4yqyPFejE1z16A4yfTaK6iFsYp2hnW6QFpSqoWLXvPwpbCSM8RxY2WY45
         FHmop/G7nlSPw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, macro@orcam.me.uk,
        Jakub Kicinski <kuba@kernel.org>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net-next] fddi: defza: add missing pointer type cast
Date:   Mon, 25 Oct 2021 09:00:00 -0700
Message-Id: <20211025160000.2803818-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hw_addr is a uint AKA unsigned int. dev_addr_set() takes
a u8 *.

  drivers/net/fddi/defza.c:1383:27: error: passing argument 2 of 'dev_addr_set' from incompatible pointer type [-Werror=incompatible-pointer-types]

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 1e9258c389ee ("fddi: defxx,defza: use dev_addr_set()")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/fddi/defza.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/fddi/defza.c b/drivers/net/fddi/defza.c
index 3a6b08eb5e1b..f5c25acaa577 100644
--- a/drivers/net/fddi/defza.c
+++ b/drivers/net/fddi/defza.c
@@ -1380,7 +1380,7 @@ static int fza_probe(struct device *bdev)
 		goto err_out_irq;
 
 	fza_reads(&init->hw_addr, &hw_addr, sizeof(hw_addr));
-	dev_addr_set(dev, &hw_addr);
+	dev_addr_set(dev, (u8 *)&hw_addr);
 
 	fza_reads(&init->rom_rev, &rom_rev, sizeof(rom_rev));
 	fza_reads(&init->fw_rev, &fw_rev, sizeof(fw_rev));
-- 
2.31.1

