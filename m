Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44E8D230D2
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 11:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730039AbfETJ6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 05:58:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38862 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725951AbfETJ6M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 May 2019 05:58:12 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4D2EF356E7;
        Mon, 20 May 2019 09:58:12 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.32.181.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 53B4561D0E;
        Mon, 20 May 2019 09:58:11 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     stephen@networkplumber.org, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@mellanox.com>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH iproute2 v2] m_mirred: don't bail if the control action is missing
Date:   Mon, 20 May 2019 11:56:52 +0200
Message-Id: <fb92be6e671450d181f552c883feae849f840283.1558345901.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Mon, 20 May 2019 09:58:12 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mirred act admits an optional control action, defaulting
to TC_ACT_PIPE. The parsing code currently emits an error message
if the control action is not provided on the command line, even
if the command itself completes with no error.

This change shuts down the error message, using the appropriate
parsing helper.

Fixes: e67aba559581 ("tc: actions: add helpers to parse and print control actions")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
v1 -> v2:
 - add missing recipients, sorry for the unneeded duplicates to
   the initial, partial list
---
 tc/m_mirred.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tc/m_mirred.c b/tc/m_mirred.c
index c7f7318b..23ba638a 100644
--- a/tc/m_mirred.c
+++ b/tc/m_mirred.c
@@ -202,7 +202,8 @@ parse_direction(struct action_util *a, int *argc_p, char ***argv_p,
 
 
 	if (p.eaction == TCA_EGRESS_MIRROR || p.eaction == TCA_INGRESS_MIRROR)
-		parse_action_control(&argc, &argv, &p.action, false);
+		parse_action_control_dflt(&argc, &argv, &p.action, false,
+					  TC_ACT_PIPE);
 
 	if (argc) {
 		if (iok && matches(*argv, "index") == 0) {
-- 
2.20.1

