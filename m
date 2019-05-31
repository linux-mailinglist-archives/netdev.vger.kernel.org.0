Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26F0630BB1
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 11:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbfEaJfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 05:35:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39112 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726233AbfEaJfV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 05:35:21 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0560E6EB9A;
        Fri, 31 May 2019 09:35:21 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.32.181.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EE3885D719;
        Fri, 31 May 2019 09:35:19 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     aclaudi@redhat.com, marcelo.leitner@gmail.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Subject: [PATCH iproute2] tc: simple: don't hardcode the control action
Date:   Fri, 31 May 2019 11:34:46 +0200
Message-Id: <25d2af8d9fc5af184ad1694c2963403753aef53e.1559294588.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Fri, 31 May 2019 09:35:21 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

don't hardcode the 'pipe' control action, so that the following TDC test

 b776 - Replace simple action with invalid goto chain control

can detect kernels that correctly validate 'goto chain' control action.

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

