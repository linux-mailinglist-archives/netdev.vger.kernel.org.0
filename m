Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4804836D
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 15:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbfFQNFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 09:05:21 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:56847 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725983AbfFQNFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 09:05:21 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MxHLs-1iaB902HqC-00xXc6; Mon, 17 Jun 2019 15:05:06 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Ariel Elior <aelior@marvell.com>, GR-everest-linux-l2@marvell.com,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Ariel Elior <ariel.elior@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Denis Bolotin <dbolotin@marvell.com>,
        Tomer Tayar <tomer.tayar@cavium.com>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] qed: Fix -Wmaybe-uninitialized false positive
Date:   Mon, 17 Jun 2019 15:04:49 +0200
Message-Id: <20190617130504.1906523-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:+mmC7KynQ+2sddMylzq2+ftuxPNGFt1OtXTkR+yN566PmwzbyDo
 bXQTUjpA9qOlN2+o2T1d4PREWunObLscF9GhNcjtYqOM3Oila0QWRY6wCKPGXk5HnxX83mB
 7J7bfPlUP8j0k/MjxhJD/WSqEDpN54R9a9VwehJ4Qr9g0Ds9smgkEjTt6wtr7EAr8pPis3L
 gP0aW5mBEp4KV+qgU77kw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:d5ZO6L8lGYg=:7/TFzafs/62j0Fn1qTS/5b
 stiTggZP23rEne6LpCi6BMHiVDqL2ELZLWImG7czTF87WsvjcAfOhtY8rQMFn65Dzc6jQIYzU
 Ms2fme/NnUJJtAJEVUDRYKLdQTiJ9mP+YcMrW+9AYiDDcnHxiZg6KepwSm8SeRPtByUri7MUD
 QvfhlXHmOpnFPAVQ0lSk+ITH736cojeZilzk9rZYHbx/rHdssa5qQNvJYjxF4RJsMJX5qMrlQ
 WIo2u9j2j0Z0IMSovIHTV+bh5ankUjIQqgZ8sAsieey3tX/8NTGo/U6JbpVGYnEId+0eGLWrM
 Zo2YPQZ1uuNJQd1m8kP2SYWjz2HrMhSJ8KpGfCO4rG9ymOJ0nAxXNgzg7jxI7In1fFyubMxEK
 iYNs/BxcvRs7IXte7L5IUrkv+kxb9YCBiVjl+Sp/Y9IxOYNz+3N5LCe4cKJ/gtBZ06W4E/yDb
 1eIlTGu64vZQvYzDmPS9y3LRsJcubJ8qRrKzVHiX9AdTFmXmA6NshSODuB7X8Fn7tFk+fNI7F
 4JWeQfzj/FIasmqD/o0vVAKs4k0zZdYuZ6rMtWMAga351UuqtWhhpeyCh3zUkTGOktCVtcQkG
 nWopkC8tgRYW10M5jqJdpZW4+Ylhaa8nvEU4Du0dEX4zGfRJqW7+ja7dZRQkoBWk1zXGP8ks1
 QEGtNDw9EetWIfPwFGowXEYELXq1QKpcC8/0CbTZb7k4cLGKYTOUzHh2f3oM3fR3lOdYO4vp/
 eKqqTg6LjCNnc4SF2Lw5baa4n7VeYfaotyUnjA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A previous attempt to shut up the uninitialized variable use
warning was apparently insufficient. When CONFIG_PROFILE_ANNOTATED_BRANCHES
is set, gcc-8 still warns, because the unlikely() check in DP_NOTICE()
causes it to no longer track the state of all variables correctly:

drivers/net/ethernet/qlogic/qed/qed_dev.c: In function 'qed_llh_set_ppfid_affinity':
drivers/net/ethernet/qlogic/qed/qed_dev.c:798:47: error: 'abs_ppfid' may be used uninitialized in this function [-Werror=maybe-uninitialized]
  addr = NIG_REG_PPF_TO_ENGINE_SEL + abs_ppfid * 0x4;
                                     ~~~~~~~~~~^~~~~

This is not a nice workaround, but always initializing the output from
qed_llh_abs_ppfid() at least shuts up the false positive reliably.

Fixes: 79284adeb99e ("qed: Add llh ppfid interface and 100g support for offload protocols")
Fixes: 8e2ea3ea9625 ("qed: Fix static checker warning")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/qlogic/qed/qed_dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index eec7cb65c7e6..a1ebc2b1ca0b 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -652,6 +652,7 @@ static int qed_llh_abs_ppfid(struct qed_dev *cdev, u8 ppfid, u8 *p_abs_ppfid)
 		DP_NOTICE(cdev,
 			  "ppfid %d is not valid, available indices are 0..%hhd\n",
 			  ppfid, p_llh_info->num_ppfid - 1);
+		*p_abs_ppfid = 0;
 		return -EINVAL;
 	}
 
-- 
2.20.0

