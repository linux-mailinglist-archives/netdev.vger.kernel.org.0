Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADC42290768
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 16:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406144AbgJPOmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 10:42:43 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:45220 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2405559AbgJPOmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 10:42:43 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@nvidia.com)
        with SMTP; 16 Oct 2020 17:42:38 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 09GEgcnS020163;
        Fri, 16 Oct 2020 17:42:38 +0300
From:   Vlad Buslov <vladbu@nvidia.com>
To:     dsahern@gmail.com, stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, ivecera@redhat.com,
        vlad@buslov.dev, Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH iproute2-next v3 2/2] tc: implement support for terse dump
Date:   Fri, 16 Oct 2020 17:42:05 +0300
Message-Id: <20201016144205.21787-3-vladbu@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20201016144205.21787-1-vladbu@nvidia.com>
References: <20201016144205.21787-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

Implement support for classifier/action terse dump using new TCA_DUMP_FLAGS
tlv with only available flag value TCA_DUMP_FLAGS_TERSE. Set the flag when
user requested it with following example CLI (-br for 'brief'):

$ tc -s -brief filter show dev ens1f0 ingress
filter protocol all pref 49151 flower chain 0
filter protocol all pref 49151 flower chain 0 handle 0x1
  not_in_hw
        action order 1:         Action statistics:
        Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
        backlog 0b 0p requeues 0

filter protocol all pref 49152 flower chain 0
filter protocol all pref 49152 flower chain 0 handle 0x1
  not_in_hw
        action order 1:         Action statistics:
        Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
        backlog 0b 0p requeues 0

In terse mode dump only outputs essential data needed to identify the
filter and action (handle, cookie, etc.) and stats, if requested by the
user. The intention is to significantly improve rule dump rate by omitting
all static data that do not change after rule is created.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
---

Notes:
    Changes V2 -> V3:
    
    - Add brief dump output example to commit message.
    
    Changes V1 -> V2:
    
    - Invoke terse dump with tc command '-brief' option instead of
    filter-specific 'terse' flag.
    
    - Extend tc man and usage string with new option.

 man/man8/tc.8  | 6 ++++++
 tc/tc.c        | 6 +++++-
 tc/tc_filter.c | 9 +++++++++
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/man/man8/tc.8 b/man/man8/tc.8
index 7e9019f561ea..e8622053df65 100644
--- a/man/man8/tc.8
+++ b/man/man8/tc.8
@@ -854,6 +854,12 @@ option for creating
 alias.
 .RE
 
+.TP
+.BR "\-br" , " \-brief"
+Print only essential data needed to identify the filter and action (handle,
+cookie, etc.) and stats. This option is currently only supported by
+.BR "tc filter show " command.
+
 .SH "EXAMPLES"
 .PP
 tc -g class show dev eth0
diff --git a/tc/tc.c b/tc/tc.c
index 5d57054b45fb..bdd5d4faf886 100644
--- a/tc/tc.c
+++ b/tc/tc.c
@@ -44,6 +44,7 @@ bool use_names;
 int json;
 int color;
 int oneline;
+int brief;
 
 static char *conf_file;
 
@@ -202,7 +203,8 @@ static void usage(void)
 		"       OPTIONS := { -V[ersion] | -s[tatistics] | -d[etails] | -r[aw] |\n"
 		"		    -o[neline] | -j[son] | -p[retty] | -c[olor]\n"
 		"		    -b[atch] [filename] | -n[etns] name | -N[umeric] |\n"
-		"		     -nm | -nam[es] | { -cf | -conf } path }\n");
+		"		     -nm | -nam[es] | { -cf | -conf } path\n"
+		"		     -br[ief] }\n");
 }
 
 static int do_cmd(int argc, char **argv)
@@ -336,6 +338,8 @@ int main(int argc, char **argv)
 			++json;
 		} else if (matches(argv[1], "-oneline") == 0) {
 			++oneline;
+		}else if (matches(argv[1], "-brief") == 0) {
+			++brief;
 		} else {
 			fprintf(stderr,
 				"Option \"%s\" is unknown, try \"tc -help\".\n",
diff --git a/tc/tc_filter.c b/tc/tc_filter.c
index c591a19f3123..71be2e8119c9 100644
--- a/tc/tc_filter.c
+++ b/tc/tc_filter.c
@@ -721,6 +721,15 @@ static int tc_filter_list(int cmd, int argc, char **argv)
 	if (filter_chain_index_set)
 		addattr32(&req.n, sizeof(req), TCA_CHAIN, chain_index);
 
+	if (brief) {
+		struct nla_bitfield32 flags = {
+			.value = TCA_DUMP_FLAGS_TERSE,
+			.selector = TCA_DUMP_FLAGS_TERSE
+		};
+
+		addattr_l(&req.n, MAX_MSG, TCA_DUMP_FLAGS, &flags, sizeof(flags));
+	}
+
 	if (rtnl_dump_request_n(&rth, &req.n) < 0) {
 		perror("Cannot send dump request");
 		return 1;
-- 
2.21.0

