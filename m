Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63C74324810
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 01:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236496AbhBYA4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 19:56:10 -0500
Received: from mo-csw1515.securemx.jp ([210.130.202.154]:57848 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236497AbhBYA4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 19:56:08 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1515) id 11P0s9nv029449; Thu, 25 Feb 2021 09:54:09 +0900
X-Iguazu-Qid: 34tMMPQaG01V1mlNrh
X-Iguazu-QSIG: v=2; s=0; t=1614214449; q=34tMMPQaG01V1mlNrh; m=2WaOZv6s36zREBVzYHZddgJmaqBd7W+toOolwdOMvjY=
Received: from imx12-a.toshiba.co.jp (imx12-a.toshiba.co.jp [61.202.160.135])
        by relay.securemx.jp (mx-mr1512) id 11P0s83l030166
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 25 Feb 2021 09:54:08 +0900
Received: from enc02.toshiba.co.jp (enc02.toshiba.co.jp [61.202.160.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by imx12-a.toshiba.co.jp (Postfix) with ESMTPS id 706E41000D3;
        Thu, 25 Feb 2021 09:54:08 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 11P0s7Pg001054;
        Thu, 25 Feb 2021 09:54:08 +0900
From:   Punit Agrawal <punit1.agrawal@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     netdev@vger.kernel.org, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, daichi1.fukui@toshiba.co.jp,
        nobuhiro1.iwamatsu@toshiba.co.jp,
        Corinna Vinschen <vinschen@redhat.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [PATCH v4.4.y, v4.9.y] igb: Remove incorrect "unexpected SYS WRAP" log message
Date:   Thu, 25 Feb 2021 09:54:06 +0900
X-TSB-HOP: ON
Message-Id: <20210225005406.530767-1-punit1.agrawal@toshiba.co.jp>
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
[ Due to confusion about stable rules for networking the request was
mistakenly sent to netdev only[0]. Apologies if you're seeing this
again. ]

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

[0] https://lore.kernel.org/netdev/20210210013448.2116413-1-punit1.agrawal@toshiba.co.jp/

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

