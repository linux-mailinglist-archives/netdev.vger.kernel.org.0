Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA2F2C3172
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 12:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729892AbfJAKbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 06:31:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44778 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725765AbfJAKbX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 06:31:23 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 98757A44AC3;
        Tue,  1 Oct 2019 10:31:23 +0000 (UTC)
Received: from renaissance-vector.mxp.redhat.com (unknown [10.32.181.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C1729261A0;
        Tue,  1 Oct 2019 10:31:22 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2] tc: fix segmentation fault on gact action
Date:   Tue,  1 Oct 2019 12:32:17 +0200
Message-Id: <b498237ee5b99e4687ba5068de09da91ef315235.1569924170.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.68]); Tue, 01 Oct 2019 10:31:23 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tc segfaults if gact action is used without action or index:

$ ip link add type dummy
$ tc actions add action pipe index 1
$ tc filter add dev dummy0 parent ffff: protocol ip \
  pref 10 u32 match ip src 127.0.0.2 flowid 1:10 action gact
Segmentation fault

We expect tc to fail gracefully with an error message.

This happens if gact is the last argument of the incomplete
command. In this case the "gact" action is parsed, the macro
NEXT_ARG_FWD() is executed and the next matches() crashes
because of null argv pointer.

To avoid this, simply use NEXT_ARG() instead.

With this change in place:

$ ip link add type dummy
$ tc actions add action pipe index 1
$ tc filter add dev dummy0 parent ffff: protocol ip \
  pref 10 u32 match ip src 127.0.0.2 flowid 1:10 action gact
Command line is not complete. Try option "help"

Fixes: fa4958897314 ("tc: Fix binding of gact action by index.")
Reported-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 tc/m_gact.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tc/m_gact.c b/tc/m_gact.c
index dca2a2f9692fd..b06e8ee95818f 100644
--- a/tc/m_gact.c
+++ b/tc/m_gact.c
@@ -87,7 +87,7 @@ parse_gact(struct action_util *a, int *argc_p, char ***argv_p,
 		return -1;
 
 	if (!matches(*argv, "gact"))
-		NEXT_ARG_FWD();
+		NEXT_ARG();
 	/* we're binding existing gact action to filter by index. */
 	if (!matches(*argv, "index"))
 		goto skip_args;
-- 
2.21.0

