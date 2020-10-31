Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C316D2A1A88
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 21:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728569AbgJaU0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 16:26:00 -0400
Received: from mail.buslov.dev ([199.247.26.29]:58589 "EHLO mail.buslov.dev"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728562AbgJaU0A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 16:26:00 -0400
Received: from vlad-x1g6.localdomain (unknown [IPv6:2a0b:2bc3:193f:1:a5fe:a7d6:6345:fe8d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.buslov.dev (Postfix) with ESMTPSA id CEE581F8EB;
        Sat, 31 Oct 2020 22:25:56 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=buslov.dev; s=2019;
        t=1604175957;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MPdTTuiSc3igTEfW0hxDyYLCLwk3Lnf4CV2rfZfCs7g=;
        b=MPpvDuvmh4L8CQVYmpDAQieaJLH5RAwtNqwwojzA97QJGD/jwkvch9jZbFSDuYXsOVTl2Z
        1AwJfl7xdSjGjo72NRhgcLDbkTT3UpfSRR9ML1xqWZ08tObulsaiP6FvKOFt0KpJ2RzNSZ
        asoV8YuWFHNQ2UFF5c93DH2OolLDRpqO5hTCtqbPerpPckgwtgQlbjJJurLnIYT0UbgSGU
        5X5+zLwhPlVOmEySAL3upC3zgxWEozuEmYYbwRHMj6GWN/SJ80QIpp7XgTKMTnA1CK4F8z
        HH738IJZez/NUsdsTHwWP1oSvtYq5lejnQ03OVS+muBABMl15G8o4ua0x2y4cw==
From:   Vlad Buslov <vlad@buslov.dev>
To:     jhs@mojatatu.com, netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     davem@davemloft.net, kuba@kernel.org, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, Vlad Buslov <vlad@buslov.dev>
Subject: [PATCH iproute2-next] tc: implement support for action terse dump
Date:   Sat, 31 Oct 2020 22:25:22 +0200
Message-Id: <20201031202522.247924-1-vlad@buslov.dev>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201031201644.247605-1-vlad@buslov.dev>
References: <20201031201644.247605-1-vlad@buslov.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=vlad@buslov.dev smtp.mailfrom=vlad@buslov.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement support for action terse dump using new TCA_FLAG_TERSE_DUMP value
of TCA_ROOT_FLAGS tlv. Set the flag when user requested it with following
example CLI (-br for 'brief'):

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
 include/uapi/linux/rtnetlink.h | 4 ++++
 man/man8/tc.8                  | 2 +-
 tc/m_action.c                  | 9 +++++++++
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index 5ad84e663d01..b486f52900f0 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -768,8 +768,12 @@ enum {
  * actions in a dump. All dump responses will contain the number of actions
  * being dumped stored in for user app's consumption in TCA_ROOT_COUNT
  *
+ * TCA_FLAG_TERSE_DUMP user->kernel to request terse (brief) dump that only
+ * includes essential action info (kind, index, etc.)
+ *
  */
 #define TCA_FLAG_LARGE_DUMP_ON		(1 << 0)
+#define TCA_FLAG_TERSE_DUMP		(1 << 1)
 
 /* New extended info filters for IFLA_EXT_MASK */
 #define RTEXT_FILTER_VF		(1 << 0)
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
index 66e672453c25..b640b3c88b7b 100644
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
 	flag_select.value |= TCA_FLAG_LARGE_DUMP_ON;
 	flag_select.selector |= TCA_FLAG_LARGE_DUMP_ON;
+	if (brief) {
+		flag_select.value |= TCA_FLAG_TERSE_DUMP;
+		flag_select.selector |= TCA_FLAG_TERSE_DUMP;
+	}
 	addattr_l(&req.n, MAX_MSG, TCA_ROOT_FLAGS, &flag_select,
 		  sizeof(struct nla_bitfield32));
 	tail3->rta_len = (void *) NLMSG_TAIL(&req.n) - (void *) tail3;
-- 
2.29.1

