Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98FEC352AA5
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 14:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235330AbhDBM1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 08:27:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229599AbhDBM1f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Apr 2021 08:27:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 184BD61158;
        Fri,  2 Apr 2021 12:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617366454;
        bh=idDTKzoCPAbQsNqWyYOiujZSln6yo9RWoeQ82hvVNpc=;
        h=From:To:Cc:Subject:Date:From;
        b=CBRsc9Z626kNMmpXAaBUyLCFT0F4HMn9KGxh227eSJ8a8vkGHhlND13KW25wlkQkq
         tqFoLpK+sxXY1RcFp8rAamn7AtLWa6fNBRq4Ldbnka4dMgqpbC+EYvVs/zBB404mG4
         qITvYaBkUD0UoPgXX07cB735PxuxVIhJVHWHjiZVtLANagQGepcCCcz9+xQiRnxBE1
         ErmRSqCugMv5nf+zdu3WoGbUU2K+QxbqgV4ac1mRwnz6qto0BxSQ/edHP7nha1II7i
         iYNP0VEpAq2YW7q0C8/2+7B9ljMzkfqxVbSEd++qE8x1ro0r3m+AkPfqppOJ/pUYKe
         xA3uH1qHMR2CA==
Received: by pali.im (Postfix)
        id 5000A810; Fri,  2 Apr 2021 14:27:31 +0200 (CEST)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath9k-devel@qca.qualcomm.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ath9k: Fix kernel NULL pointer dereference during ath_reset_internal()
Date:   Fri,  2 Apr 2021 14:26:53 +0200
Message-Id: <20210402122653.24014-1-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function ath9k_hw_reset() is dereferencing chan structure pointer, so it
needs to be non-NULL pointer.

Function ath9k_stop() already contains code which sets ah->curchan to valid
non-NULL pointer prior calling ath9k_hw_reset() function.

Add same code pattern also into ath_reset_internal() function to prevent
kernel NULL pointer dereference in ath9k_hw_reset() function.

This change fixes kernel NULL pointer dereference in ath9k_hw_reset() which
is caused by calling ath9k_hw_reset() from ath_reset_internal() with NULL
chan structure.

    [   45.334305] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000008
    [   45.344417] Mem abort info:
    [   45.347301]   ESR = 0x96000005
    [   45.350448]   EC = 0x25: DABT (current EL), IL = 32 bits
    [   45.356166]   SET = 0, FnV = 0
    [   45.359350]   EA = 0, S1PTW = 0
    [   45.362596] Data abort info:
    [   45.365756]   ISV = 0, ISS = 0x00000005
    [   45.369735]   CM = 0, WnR = 0
    [   45.372814] user pgtable: 4k pages, 39-bit VAs, pgdp=000000000685d000
    [   45.379663] [0000000000000008] pgd=0000000000000000, p4d=0000000000000000, pud=0000000000000000
    [   45.388856] Internal error: Oops: 96000005 [#1] SMP
    [   45.393897] Modules linked in: ath9k ath9k_common ath9k_hw
    [   45.399574] CPU: 1 PID: 309 Comm: kworker/u4:2 Not tainted 5.12.0-rc2-dirty #785
    [   45.414746] Workqueue: phy0 ath_reset_work [ath9k]
    [   45.419713] pstate: 40000005 (nZcv daif -PAN -UAO -TCO BTYPE=--)
    [   45.425910] pc : ath9k_hw_reset+0xc4/0x1c48 [ath9k_hw]
    [   45.431234] lr : ath9k_hw_reset+0xc0/0x1c48 [ath9k_hw]
    [   45.436548] sp : ffffffc0118dbca0
    [   45.439961] x29: ffffffc0118dbca0 x28: 0000000000000000
    [   45.445442] x27: ffffff800dee4080 x26: 0000000000000000
    [   45.450923] x25: ffffff800df9b9d8 x24: 0000000000000000
    [   45.456404] x23: ffffffc0115f6000 x22: ffffffc008d0d408
    [   45.461885] x21: ffffff800dee5080 x20: ffffff800df9b9d8
    [   45.467366] x19: 0000000000000000 x18: 0000000000000000
    [   45.472846] x17: 0000000000000000 x16: 0000000000000000
    [   45.478326] x15: 0000000000000010 x14: ffffffffffffffff
    [   45.483807] x13: ffffffc0918db94f x12: ffffffc011498720
    [   45.489289] x11: 0000000000000003 x10: ffffffc0114806e0
    [   45.494770] x9 : ffffffc01014b2ec x8 : 0000000000017fe8
    [   45.500251] x7 : c0000000ffffefff x6 : 0000000000000001
    [   45.505733] x5 : 0000000000000000 x4 : 0000000000000000
    [   45.511213] x3 : 0000000000000000 x2 : ffffff801fece870
    [   45.516693] x1 : ffffffc00eded000 x0 : 000000000000003f
    [   45.522174] Call trace:
    [   45.524695]  ath9k_hw_reset+0xc4/0x1c48 [ath9k_hw]
    [   45.529653]  ath_reset_internal+0x1a8/0x2b8 [ath9k]
    [   45.534696]  ath_reset_work+0x2c/0x40 [ath9k]
    [   45.539198]  process_one_work+0x210/0x480
    [   45.543339]  worker_thread+0x5c/0x510
    [   45.547115]  kthread+0x12c/0x130
    [   45.550445]  ret_from_fork+0x10/0x1c
    [   45.554138] Code: 910922c2 9117e021 95ff0398 b4000294 (b9400a61)
    [   45.560430] ---[ end trace 566410ba90b50e8b ]---
    [   45.565193] Kernel panic - not syncing: Oops: Fatal exception in interrupt
    [   45.572282] SMP: stopping secondary CPUs
    [   45.576331] Kernel Offset: disabled
    [   45.579924] CPU features: 0x00040002,0000200c
    [   45.584416] Memory Limit: none
    [   45.587564] Rebooting in 3 seconds..

Signed-off-by: Pali Rohár <pali@kernel.org>
Cc: stable@vger.kernel.org
---
 drivers/net/wireless/ath/ath9k/main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 45f6402478b5..97c3a53f9cef 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -307,6 +307,11 @@ static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan)
 		hchan = ah->curchan;
 	}
 
+	if (!hchan) {
+		fastcc = false;
+		hchan = ath9k_cmn_get_channel(sc->hw, ah, &sc->cur_chan->chandef);
+	}
+
 	if (!ath_prepare_reset(sc))
 		fastcc = false;
 
-- 
2.20.1

