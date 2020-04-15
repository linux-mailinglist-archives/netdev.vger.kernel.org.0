Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3F8C1A91C2
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 06:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388597AbgDOELa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 00:11:30 -0400
Received: from vip1.b1c1l1.com ([64.57.102.218]:47340 "EHLO vip1.b1c1l1.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726438AbgDOELa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 00:11:30 -0400
Received: by vip1.b1c1l1.com (Postfix) with ESMTPSA id 7EDFD27340;
        Wed, 15 Apr 2020 04:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=b1c1l1.com; s=alpha;
        t=1586923888; bh=F2PRp12ZauZaUcZpQqTSqggNYdKxcFGlxOfECbmeqCY=;
        h=From:To:Cc:Subject:Date;
        b=KtLTnc4LP8UNzGfmY6QcTRIrCDMCvRLfKPCep4L/Dt/RsDyomDk9YZ7Ni41NqpY/7
         crCagSnPABd+4Gpl5XInaZKInZx6t2H/4hfCQ7afuBb0PfVlZ94hk1WPi3ZIJuQJ5Y
         0vnZPdtAvL/Iz5vdfQJLoBgBztCiLLxpoYpoI04H+u05WNyvOmLDHq7lQZkPfRixVH
         vVGF82atEPXu2fSZiuVSexb0utXWo30rYpzV51A/wjt/o7t5C8pcFtLg4SuHqf0Nvc
         KouhHJ1wFCNkijuSP2/p25+kFXx2TEUM4YaUhJCfsnvQi5XrxXhP+9ldggu2tjJVm5
         Z/tVuoGmHmuqA==
From:   Benjamin Lee <ben@b1c1l1.com>
To:     netdev@vger.kernel.org
Cc:     Benjamin Lee <ben@b1c1l1.com>
Subject: [PATCH iproute2] tc: fq_codel: fix class stat deficit is signed int
Date:   Tue, 14 Apr 2020 21:11:12 -0700
Message-Id: <20200415041112.32679-1-ben@b1c1l1.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The fq_codel class stat deficit is a signed int.  This is a regression
from when JSON output was added.

Fixes: 997f2dc19378 ("tc: Add JSON output of fq_codel stats")
Signed-off-by: Benjamin Lee <ben@b1c1l1.com>
---
 tc/q_fq_codel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tc/q_fq_codel.c b/tc/q_fq_codel.c
index efed4d28..1c6cf1e0 100644
--- a/tc/q_fq_codel.c
+++ b/tc/q_fq_codel.c
@@ -264,7 +264,7 @@ static int fq_codel_print_xstats(struct qdisc_util *qu, FILE *f,
 			st->qdisc_stats.old_flows_len);
 	}
 	if (st->type == TCA_FQ_CODEL_XSTATS_CLASS) {
-		print_uint(PRINT_ANY, "deficit", "  deficit %u",
+		print_int(PRINT_ANY, "deficit", "  deficit %d",
 			st->class_stats.deficit);
 		print_uint(PRINT_ANY, "count", " count %u",
 			st->class_stats.count);
-- 
2.25.1

