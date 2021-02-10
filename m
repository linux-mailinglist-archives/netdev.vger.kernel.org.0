Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1400315C96
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 02:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234395AbhBJBuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 20:50:11 -0500
Received: from mo-csw-fb1516.securemx.jp ([210.130.202.172]:47692 "EHLO
        mo-csw-fb.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234262AbhBJBtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 20:49:53 -0500
X-Greylist: delayed 750 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Feb 2021 20:49:51 EST
Received: by mo-csw-fb.securemx.jp (mx-mo-csw-fb1516) id 11A1ZCCQ000977; Wed, 10 Feb 2021 10:37:25 +0900
Received: by mo-csw.securemx.jp (mx-mo-csw1515) id 11A1Z3ER003714; Wed, 10 Feb 2021 10:35:03 +0900
X-Iguazu-Qid: 34tKHZCCJ2jy5U0aeA
X-Iguazu-QSIG: v=2; s=0; t=1612920903; q=34tKHZCCJ2jy5U0aeA; m=2l+v7qA9BE1Eq129Ioma2LhJgMfeRXDwbXBx2mtt/8o=
Received: from imx2.toshiba.co.jp (imx2.toshiba.co.jp [106.186.93.51])
        by relay.securemx.jp (mx-mr1513) id 11A1Z22L008504;
        Wed, 10 Feb 2021 10:35:02 +0900
Received: from enc01.toshiba.co.jp ([106.186.93.100])
        by imx2.toshiba.co.jp  with ESMTP id 11A1Z2TE012533;
        Wed, 10 Feb 2021 10:35:02 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.toshiba.co.jp  with ESMTP id 11A1Z2oE017978;
        Wed, 10 Feb 2021 10:35:02 +0900
From:   Punit Agrawal <punit1.agrawal@toshiba.co.jp>
To:     netdev@vger.kernel.org
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        daichi1.fukui@toshiba.co.jp, nobuhiro1.iwamatsu@toshiba.co.jp,
        Corinna Vinschen <vinschen@redhat.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH v4.4.y, v4.9.y] igb: Remove incorrect "unexpected SYS WRAP" log message
Date:   Wed, 10 Feb 2021 10:34:48 +0900
X-TSB-HOP: ON
Message-Id: <20210210013448.2116413-1-punit1.agrawal@toshiba.co.jp>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Corinna Vinschen <vinschen@redhat.com>

commit 2643e6e90210e16c978919617170089b7c2164f7 upstream

TSAUXC.DisableSystime is never set, so SYSTIM runs into a SYS WRAP
every 1100 secs on 80580/i350/i354 (40 bit SYSTIM) and every 35000
secs on 80576 (45 bit SYSTIM).

This wrap event sets the TSICR.SysWrap bit unconditionally.

However, checking TSIM at interrupt time shows that this event does not
actually cause the interrupt.  Rather, it's just bycatch while the
actual interrupt is caused by, for instance, TSICR.TXTS.

The conclusion is that the SYS WRAP is actually expected, so the
"unexpected SYS WRAP" message is entirely bogus and just helps to
confuse users.  Drop it.

Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
Acked-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
Hi,

A customer reported that the following message appears in the kernel
logs every 1100s -

    igb 0000:01:00.1: unexpected SYS WRAP

As the systems have large uptimes the messages are crowding the logs.

The message was dropped in 
commit 2643e6e90210e16c ("igb: Remove incorrect "unexpected SYS WRAP" log message")
in v4.14.

Please consider applying to patch to v4.4 and v4.9 stable kernels - it
applies cleanly to both the trees.

Thanks,
Punit

 drivers/net/ethernet/intel/igb/igb_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index a4aa4d10ca70..682f52760898 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -5421,8 +5421,6 @@ static void igb_tsync_interrupt(struct igb_adapter *adapter)
 		event.type = PTP_CLOCK_PPS;
 		if (adapter->ptp_caps.pps)
 			ptp_clock_event(adapter->ptp_clock, &event);
-		else
-			dev_err(&adapter->pdev->dev, "unexpected SYS WRAP");
 		ack |= TSINTR_SYS_WRAP;
 	}
 
-- 
2.29.2

