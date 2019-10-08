Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCF2ED03FF
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 01:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbfJHXT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 19:19:27 -0400
Received: from mga07.intel.com ([134.134.136.100]:32240 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726579AbfJHXT1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 19:19:27 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Oct 2019 16:19:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,273,1566889200"; 
   d="scan'208";a="393500106"
Received: from vcostago-desk1.jf.intel.com ([10.54.70.82])
  by fmsmga005.fm.intel.com with ESMTP; 08 Oct 2019 16:19:27 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        olteanv@gmail.com
Subject: [PATCH net v1] net: taprio: Fix returning EINVAL when configuring without flags
Date:   Tue,  8 Oct 2019 16:20:07 -0700
Message-Id: <20191008232007.16083-1-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When configuring a taprio instance if "flags" is not specified (or
it's zero), taprio currently replies with an "Invalid argument" error.

So, set the return value to zero after we are done with all the
checks.

Fixes: 9c66d1564676 ("taprio: Add support for hardware offloading")
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 net/sched/sch_taprio.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 68b543f85a96..6719a65169d4 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1341,6 +1341,10 @@ static int taprio_parse_clockid(struct Qdisc *sch, struct nlattr **tb,
 		NL_SET_ERR_MSG(extack, "Specifying a 'clockid' is mandatory");
 		goto out;
 	}
+
+	/* Everything went ok, return success. */
+	err = 0;
+
 out:
 	return err;
 }
-- 
2.23.0

