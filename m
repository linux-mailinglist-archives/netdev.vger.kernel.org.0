Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F45369C7B
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 00:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243974AbhDWWXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 18:23:25 -0400
Received: from saphodev.broadcom.com ([192.19.11.229]:42764 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232106AbhDWWXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 18:23:23 -0400
X-Greylist: delayed 565 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Apr 2021 18:23:23 EDT
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 856832F44A;
        Fri, 23 Apr 2021 15:13:19 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 856832F44A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1619215999;
        bh=Y1AUBiFeqm+AEY6bmN4k+SUGVzScFH15xASDqrF/uPU=;
        h=From:To:Cc:Subject:Date:From;
        b=QT3UN6H/EojK1ntyYfC7kjJAoYcjSEb5OEa8f1jTS9nqjrDCf7azgePCXSgrX/X9b
         hmzqk2WR8lskcVhIr2eOVmi6oN43jc3RhYgZaw5qjFp0nqUs0aGisInpwAOl94iXqU
         in4DgKoGH9Mnn/jvlhwRDwKj6xsrm/WLHI63ddb0=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net] bnxt_en: Fix RX consumer index logic in the error path.
Date:   Fri, 23 Apr 2021 18:13:19 -0400
Message-Id: <1619215999-8880-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In bnxt_rx_pkt(), the RX buffers are expected to complete in order.
If the RX consumer index indicates an out of order buffer completion,
it means we are hitting a hardware bug and the driver will abort all
remaining RX packets and reset the RX ring.  The RX consumer index
that we pass to bnxt_discard_rx() is not correct.  We should be
passing the current index (tmp_raw_cons) instead of the old index
(raw_cons).  This bug can cause us to be at the wrong index when
trying to abort the next RX packet.  It can crash like this:

 #0 [ffff9bbcdf5c39a8] machine_kexec at ffffffff9b05e007
 #1 [ffff9bbcdf5c3a00] __crash_kexec at ffffffff9b111232
 #2 [ffff9bbcdf5c3ad0] panic at ffffffff9b07d61e
 #3 [ffff9bbcdf5c3b50] oops_end at ffffffff9b030978
 #4 [ffff9bbcdf5c3b78] no_context at ffffffff9b06aaf0
 #5 [ffff9bbcdf5c3bd8] __bad_area_nosemaphore at ffffffff9b06ae2e
 #6 [ffff9bbcdf5c3c28] bad_area_nosemaphore at ffffffff9b06af24
 #7 [ffff9bbcdf5c3c38] __do_page_fault at ffffffff9b06b67e
 #8 [ffff9bbcdf5c3cb0] do_page_fault at ffffffff9b06bb12
 #9 [ffff9bbcdf5c3ce0] page_fault at ffffffff9bc015c5
    [exception RIP: bnxt_rx_pkt+237]
    RIP: ffffffffc0259cdd  RSP: ffff9bbcdf5c3d98  RFLAGS: 00010213
    RAX: 000000005dd8097f  RBX: ffff9ba4cb11b7e0  RCX: ffffa923cf6e9000
    RDX: 0000000000000fff  RSI: 0000000000000627  RDI: 0000000000001000
    RBP: ffff9bbcdf5c3e60   R8: 0000000000420003   R9: 000000000000020d
    R10: ffffa923cf6ec138  R11: ffff9bbcdf5c3e83  R12: ffff9ba4d6f928c0
    R13: ffff9ba4cac28080  R14: ffff9ba4cb11b7f0  R15: ffff9ba4d5a30000
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018

Fixes: a1b0e4e684e9 ("bnxt_en: Improve RX consumer index validity check.")
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Andy Gospodarek <gospo@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index aeb8c61c0f87..73239d3eaca1 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1732,14 +1732,16 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 
 	cons = rxcmp->rx_cmp_opaque;
 	if (unlikely(cons != rxr->rx_next_cons)) {
-		int rc1 = bnxt_discard_rx(bp, cpr, raw_cons, rxcmp);
+		int rc1 = bnxt_discard_rx(bp, cpr, &tmp_raw_cons, rxcmp);
 
 		/* 0xffff is forced error, don't print it */
 		if (rxr->rx_next_cons != 0xffff)
 			netdev_warn(bp->dev, "RX cons %x != expected cons %x\n",
 				    cons, rxr->rx_next_cons);
 		bnxt_sched_reset(bp, rxr);
-		return rc1;
+		if (rc1)
+			return rc1;
+		goto next_rx_no_prod_no_len;
 	}
 	rx_buf = &rxr->rx_buf_ring[cons];
 	data = rx_buf->data;
-- 
2.18.1

