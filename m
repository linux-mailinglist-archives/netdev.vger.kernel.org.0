Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC0CB2C8E1F
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 20:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729241AbgK3TeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 14:34:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728120AbgK3TeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 14:34:04 -0500
Received: from mail.buslov.dev (mail.buslov.dev [IPv6:2001:19f0:5001:2e3f:5400:1ff:feed:a259])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48229C0613D3
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 11:33:19 -0800 (PST)
Received: from vlad-x1g6.localdomain (unknown [IPv6:2a0b:2bc3:193f:1:a5fe:a7d6:6345:fe8d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.buslov.dev (Postfix) with ESMTPSA id 29A581FC5D;
        Mon, 30 Nov 2020 21:33:17 +0200 (EET)
From:   Vlad Buslov <vlad@buslov.dev>
To:     jhs@mojatatu.com, dsahern@gmail.com, stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Vlad Buslov <vlad@buslov.dev>
Subject: [PATCH iproute2-next 2/2] tc: implement support for action terse dump
Date:   Mon, 30 Nov 2020 21:32:50 +0200
Message-Id: <20201130193250.81308-3-vlad@buslov.dev>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201130193250.81308-1-vlad@buslov.dev>
References: <20201130193250.81308-1-vlad@buslov.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement support for action terse dump using new TCA_ACT_FLAG_TERSE_DUMP
value of TCA_ROOT_FLAGS tlv. Set the flag when user requested it with
following example CLI (-br for 'brief'):

$ tc -s -br actions ls action tunnel_key
total acts 2

        action order 0: tunnel_key       index 1
        Action statistics:
        Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
        backlog 0b 0p requeues 0

        action order 1: tunnel_key       index 2
        Action statistics:
        Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
        backlog 0b 0p requeues 0

In terse mode dump only outputs essential data needed to identify the
action (kind, index) and stats, if requested by the user.

Signed-off-by: Vlad Buslov <vlad@buslov.dev>
Suggested-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 man/man8/tc.8 | 2 +-
 tc/m_action.c | 9 +++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/man/man8/tc.8 b/man/man8/tc.8
index e8622053df65..4338572a36f3 100644
--- a/man/man8/tc.8
+++ b/man/man8/tc.8
@@ -858,7 +858,7 @@ alias.
 .BR "\-br" , " \-brief"
 Print only essential data needed to identify the filter and action (handle,
 cookie, etc.) and stats. This option is currently only supported by
-.BR "tc filter show " command.
+.BR "tc filter show " and " tc actions ls " commands.
 
 .SH "EXAMPLES"
 .PP
diff --git a/tc/m_action.c b/tc/m_action.c
index 77ff4a8d4126..b16882a345dc 100644
--- a/tc/m_action.c
+++ b/tc/m_action.c
@@ -374,6 +374,11 @@ static int tc_print_one_action(FILE *f, struct rtattr *arg)
 	if (err < 0)
 		return err;
 
+	if (brief && tb[TCA_ACT_INDEX]) {
+		print_uint(PRINT_ANY, "index", "\t index %u",
+			   rta_getattr_u32(tb[TCA_ACT_INDEX]));
+		print_nl();
+	}
 	if (show_stats && tb[TCA_ACT_STATS]) {
 		print_string(PRINT_FP, NULL, "\tAction statistics:", NULL);
 		print_nl();
@@ -737,6 +742,10 @@ static int tc_act_list_or_flush(int *argc_p, char ***argv_p, int event)
 	tail3 = NLMSG_TAIL(&req.n);
 	flag_select.value |= TCA_ACT_FLAG_LARGE_DUMP_ON;
 	flag_select.selector |= TCA_ACT_FLAG_LARGE_DUMP_ON;
+	if (brief) {
+		flag_select.value |= TCA_ACT_FLAG_TERSE_DUMP;
+		flag_select.selector |= TCA_ACT_FLAG_TERSE_DUMP;
+	}
 	addattr_l(&req.n, MAX_MSG, TCA_ROOT_FLAGS, &flag_select,
 		  sizeof(struct nla_bitfield32));
 	tail3->rta_len = (void *) NLMSG_TAIL(&req.n) - (void *) tail3;
-- 
2.29.2

