Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2109FE8EB8
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 18:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfJ2Rya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 13:54:30 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:41035 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725830AbfJ2Rya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 13:54:30 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 29 Oct 2019 19:54:10 +0200
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x9THrmTJ001340;
        Tue, 29 Oct 2019 19:53:48 +0200
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mleitner@redhat.com, paulb@mellanox.com,
        Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH iproute2 net] tc: remove duplicated NEXT_ARG_FWD() in parse_ct()
Date:   Tue, 29 Oct 2019 19:53:46 +0200
Message-Id: <20191029175346.14564-1-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function parse_ct() manually calls NEXT_ARG_FWD() after
parse_action_control_dflt(). This is redundant because
parse_action_control_dflt() modifies argc and argv itself. Moreover, such
implementation parses out any following actions option. For example, adding
action ct with cookie errors:

$ sudo tc actions add action ct cookie 111111111111
Bad action type 111111111111
Usage: ... gact <ACTION> [RAND] [INDEX]
Where:  ACTION := reclassify | drop | continue | pass | pipe |
                  goto chain <CHAIN_INDEX> | jump <JUMP_COUNT>
        RAND := random <RANDTYPE> <ACTION> <VAL>
        RANDTYPE := netrand | determ
        VAL : = value not exceeding 10000
        JUMP_COUNT := Absolute jump from start of action list
        INDEX := index value used

With fix:

$ sudo tc actions add action ct cookie 111111111111
$ sudo tc actions list action ct
total acts 1

        action order 0: ct zone 0 pipe
         index 1 ref 1 bind 0
        cookie 111111111111

Fixes: c8a494314c40 ("tc: Introduce tc ct action")
Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
---
 tc/m_ct.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tc/m_ct.c b/tc/m_ct.c
index 8589cb9a3c51..d79eb5e361ac 100644
--- a/tc/m_ct.c
+++ b/tc/m_ct.c
@@ -316,7 +316,6 @@ parse_ct(struct action_util *a, int *argc_p, char ***argv_p, int tca_id,
 
 	parse_action_control_dflt(&argc, &argv, &sel.action, false,
 				  TC_ACT_PIPE);
-	NEXT_ARG_FWD();
 
 	addattr16(n, MAX_MSG, TCA_CT_ACTION, ct_action);
 	addattr_l(n, MAX_MSG, TCA_CT_PARMS, &sel, sizeof(sel));
-- 
2.21.0

