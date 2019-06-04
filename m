Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2BA5352B4
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 00:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbfFDWa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 18:30:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44044 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbfFDWa2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 18:30:28 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 304F918DF7A;
        Tue,  4 Jun 2019 22:30:28 +0000 (UTC)
Received: from new-host.redhat.com (ovpn-204-40.brq.redhat.com [10.40.204.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7170C6014C;
        Tue,  4 Jun 2019 22:30:25 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Andrea Claudi <aclaudi@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 v2] tc: simple: don't hardcode the control action
Date:   Wed,  5 Jun 2019 00:30:16 +0200
Message-Id: <ea2fbb2d36828188d11090d73b648d97988cdcf6.1559687259.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Tue, 04 Jun 2019 22:30:28 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

the following TDC test case:

 b776 - Replace simple action with invalid goto chain control

checks if the kernel correctly validates the 'goto chain' control action,
when it is specified in 'act_simple' rules. The test systematically fails
because the control action is hardcoded in parse_simple(), i.e. it is not
parsed by command line arguments, so its value is constantly TC_ACT_PIPE.
Because of that, the following command:

 # tc action add action simple sdata "test" drop index 7

installs an 'act_simple' rule that never drops packets, and whose 'index'
is the first IDR available, plus an 'act_gact' rule with 'index' equal to
7, that drops packets.

Use parse_action_control_dflt(), like we did on many other TC actions, to
make the control action configurable also with 'act_simple'. The expected
results of test b776 are summarized below:

 iproute2
   v       kernel->| 5.1-rc2 (and previous)  | 5.1-rc3 (and subsequent)
 ------------------+-------------------------+-------------------------
 5.1.0             | FAIL (bad IDR)          | FAIL (bad IDR)
 5.1.0(patched)    | FAIL (no rule/bad sdata)| PASS

Changes since v1:
 - reword commit message, thanks Stephen Hemminger

Fixes: 087f46ee4ebd ("tc: introduce simple action")
CC: Andrea Claudi <aclaudi@redhat.com>
CC: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 tc/m_simple.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tc/m_simple.c b/tc/m_simple.c
index 886606f9f8b4..e3c8a60ff64a 100644
--- a/tc/m_simple.c
+++ b/tc/m_simple.c
@@ -119,6 +119,9 @@ parse_simple(struct action_util *a, int *argc_p, char ***argv_p, int tca_id,
 		}
 	}
 
+	parse_action_control_dflt(&argc, &argv, &sel.action, false,
+				  TC_ACT_PIPE);
+
 	if (argc) {
 		if (matches(*argv, "index") == 0) {
 			NEXT_ARG();
@@ -144,8 +147,6 @@ parse_simple(struct action_util *a, int *argc_p, char ***argv_p, int tca_id,
 		return -1;
 	}
 
-	sel.action = TC_ACT_PIPE;
-
 	tail = addattr_nest(n, MAX_MSG, tca_id);
 	addattr_l(n, MAX_MSG, TCA_DEF_PARMS, &sel, sizeof(sel));
 	if (simpdata)
-- 
2.20.1

