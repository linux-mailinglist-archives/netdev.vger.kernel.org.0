Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6979BE9D54
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 15:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbfJ3OUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 10:20:53 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:56624 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726321AbfJ3OUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 10:20:53 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 30 Oct 2019 16:20:49 +0200
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x9UEKn6w003862;
        Wed, 30 Oct 2019 16:20:49 +0200
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com,
        Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH iproute2 net-next v2] tc: implement support for action flags
Date:   Wed, 30 Oct 2019 16:20:40 +0200
Message-Id: <20191030142040.19404-1-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191030140907.18561-1-vladbu@mellanox.com>
References: <20191030140907.18561-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement setting and printing of action flags with single available flag
value "no_percpu" that translates to kernel UAPI TCA_ACT_FLAGS value
TCA_ACT_FLAGS_NO_PERCPU_STATS. Update man page with information regarding
usage of action flags.

Example usage:

 # tc actions add action gact drop no_percpu
 # sudo tc actions list action gact
 total acts 1

        action order 0: gact action drop
         random type none pass val 0
         index 1 ref 1 bind 0
        no_percpu

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
---

Notes:
    Changes V1 -> V2:
    
    - Rework the change to use action API TCA_ACT_FLAGS instead of
      per-action flags implementation.

 include/uapi/linux/pkt_cls.h |  5 +++++
 man/man8/tc-actions.8        | 14 ++++++++++++++
 tc/m_action.c                | 19 +++++++++++++++++++
 3 files changed, 38 insertions(+)

diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index a6aa466fac9e..c6ad22f76ede 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -16,9 +16,14 @@ enum {
 	TCA_ACT_STATS,
 	TCA_ACT_PAD,
 	TCA_ACT_COOKIE,
+	TCA_ACT_FLAGS,
 	__TCA_ACT_MAX
 };
 
+#define TCA_ACT_FLAGS_NO_PERCPU_STATS 1 /* Don't use percpu allocator for
+					 * actions stats.
+					 */
+
 #define TCA_ACT_MAX __TCA_ACT_MAX
 #define TCA_OLD_COMPAT (TCA_ACT_MAX+1)
 #define TCA_ACT_MAX_PRIO 32
diff --git a/man/man8/tc-actions.8 b/man/man8/tc-actions.8
index f46166e3f685..bee59f7247fa 100644
--- a/man/man8/tc-actions.8
+++ b/man/man8/tc-actions.8
@@ -47,6 +47,8 @@ actions \- independently defined actions in tc
 ] [
 .I COOKIESPEC
 ] [
+.I FLAGS
+] [
 .I CONTROL
 ]
 
@@ -71,6 +73,10 @@ ACTNAME
 :=
 .BI cookie " COOKIE"
 
+.I FLAGS
+:=
+.I no_percpu
+
 .I ACTDETAIL
 :=
 .I ACTNAME ACTPARAMS
@@ -186,6 +192,14 @@ As such, it can be used as a correlating value for maintaining user state.
 The value to be stored is completely arbitrary and does not require a specific
 format. It is stored inside the action structure itself.
 
+.TP
+.I FLAGS
+Action-specific flags. Currently, the only supported flag is
+.I no_percpu
+which indicates that action is expected to have minimal software data-path
+traffic and doesn't need to allocate stat counters with percpu allocator.
+This option is intended to be used by hardware-offloaded actions.
+
 .TP
 .BI since " MSTIME"
 When dumping large number of actions, a millisecond time-filter can be
diff --git a/tc/m_action.c b/tc/m_action.c
index 36c744bbe374..4da810c8c0aa 100644
--- a/tc/m_action.c
+++ b/tc/m_action.c
@@ -250,6 +250,16 @@ done0:
 				addattr_l(n, MAX_MSG, TCA_ACT_COOKIE,
 					  &act_ck, act_ck_len);
 
+			if (*argv && strcmp(*argv, "no_percpu") == 0) {
+				struct nla_bitfield32 flags =
+					{ TCA_ACT_FLAGS_NO_PERCPU_STATS,
+					  TCA_ACT_FLAGS_NO_PERCPU_STATS };
+
+				addattr_l(n, MAX_MSG, TCA_ACT_FLAGS, &flags,
+					  sizeof(struct nla_bitfield32));
+				NEXT_ARG_FWD();
+			}
+
 			addattr_nest_end(n, tail);
 			ok++;
 		}
@@ -318,6 +328,15 @@ static int tc_print_one_action(FILE *f, struct rtattr *arg)
 					   strsz, b1, sizeof(b1)));
 		print_string(PRINT_FP, NULL, "%s", _SL_);
 	}
+	if (tb[TCA_ACT_FLAGS]) {
+		struct nla_bitfield32 *flags = RTA_DATA(tb[TCA_ACT_FLAGS]);
+
+		if (flags->selector & TCA_ACT_FLAGS_NO_PERCPU_STATS)
+			print_bool(PRINT_ANY, "no_percpu", "\tno_percpu",
+				   flags->value &
+				   TCA_ACT_FLAGS_NO_PERCPU_STATS);
+		print_string(PRINT_FP, NULL, "%s", _SL_);
+	}
 
 	return 0;
 }
-- 
2.21.0

