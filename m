Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5DB73713B3
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 12:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233387AbhECKhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 06:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232960AbhECKhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 06:37:31 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C80A4C06174A
        for <netdev@vger.kernel.org>; Mon,  3 May 2021 03:36:38 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ldVwL-0004qx-1P; Mon, 03 May 2021 12:36:37 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH iproute2] mptcp: avoid uninitialised errno usage
Date:   Mon,  3 May 2021 12:36:31 +0200
Message-Id: <20210503103631.30694-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function called *might* set errno based on errno value in NLMSG_ERROR
message, but in case no such message exists errno is left alone.

This may cause ip to fail with
    "can't subscribe to mptcp events: Success"

on kernels that support mptcp but lack event support (all kernels <= 5.11).

Set errno to a meaningful value.  This will then still exit with the
more specific 'permission denied' or some such when called by process
that lacks CAP_NET_ADMIN on 5.12 and later.

Fixes: ff619e4fd370 ("mptcp: add support for event monitoring")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 ip/ipmptcp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/ip/ipmptcp.c b/ip/ipmptcp.c
index 5f490f0026d9..504b5b2f5329 100644
--- a/ip/ipmptcp.c
+++ b/ip/ipmptcp.c
@@ -491,6 +491,9 @@ out:
 
 static int mptcp_monitor(void)
 {
+	/* genl_add_mcast_grp may or may not set errno */
+	errno = EOPNOTSUPP;
+
 	if (genl_add_mcast_grp(&genl_rth, genl_family, MPTCP_PM_EV_GRP_NAME) < 0) {
 		perror("can't subscribe to mptcp events");
 		return 1;
-- 
2.26.3

