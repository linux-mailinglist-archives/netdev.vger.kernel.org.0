Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC70B6D263F
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 18:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbjCaQxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 12:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233076AbjCaQx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 12:53:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE7B265BD
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 09:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680281399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4kNMpcjQHBnIKpeACBG2ORRhS8M2mn8A4XCGAA2O9nA=;
        b=HnZOxt3kVt0rdWVSInNgXJ6DpRzobAniBdYRkmXSmZNxYRhV+VMvmdBLnphJzis2+IfvRq
        BosL5AOLjdOn+PTpHpqlr+Gd8Fd8NG1LJheCgdG7hWcNE6Dg67TP13v5OYmIAzjxLjhF73
        l2SSgTxG6oAOE8m6Vdwmr12IBzDy/60=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-338-XAVYpAmGO-uah0tFDXPyBg-1; Fri, 31 Mar 2023 12:49:58 -0400
X-MC-Unique: XAVYpAmGO-uah0tFDXPyBg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B1F438173C1;
        Fri, 31 Mar 2023 16:49:57 +0000 (UTC)
Received: from dcaratti.users.ipa.redhat.com (unknown [10.45.226.60])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E5F721121314;
        Fri, 31 Mar 2023 16:49:55 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ilya Maximets <i.maximets@ovn.org>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH iproute2-next] tc: m_tunnel_key: support code for "nofrag" tunnels
Date:   Fri, 31 Mar 2023 18:49:03 +0200
Message-Id: <c43213bed30edfa0d6fa1b084e4d48c26417edc9.1680281221.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add control plane for setting TCA_TUNNEL_KEY_NO_FRAG flag on
act_tunnel_key actions.

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 include/uapi/linux/tc_act/tc_tunnel_key.h |  1 +
 man/man8/tc-tunnel_key.8                  |  3 ++
 tc/m_tunnel_key.c                         | 48 +++++++++++++++++------
 3 files changed, 41 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/tc_act/tc_tunnel_key.h b/include/uapi/linux/tc_act/tc_tunnel_key.h
index 49ad4033951b..37c6f612f161 100644
--- a/include/uapi/linux/tc_act/tc_tunnel_key.h
+++ b/include/uapi/linux/tc_act/tc_tunnel_key.h
@@ -34,6 +34,7 @@ enum {
 					 */
 	TCA_TUNNEL_KEY_ENC_TOS,		/* u8 */
 	TCA_TUNNEL_KEY_ENC_TTL,		/* u8 */
+	TCA_TUNNEL_KEY_NO_FRAG,		/* flag */
 	__TCA_TUNNEL_KEY_MAX,
 };
 
diff --git a/man/man8/tc-tunnel_key.8 b/man/man8/tc-tunnel_key.8
index f639f4333540..b987cd0d95a1 100644
--- a/man/man8/tc-tunnel_key.8
+++ b/man/man8/tc-tunnel_key.8
@@ -131,6 +131,9 @@ If using
 .B nocsum
 with IPv6, be sure you know what you are doing. Zero UDP checksums provide
 weaker protection against corrupted packets. See RFC6935 for details.
+.TP
+.B nofrag
+disallow IP fragmentation.
 .RE
 .SH EXAMPLES
 The following example encapsulates incoming ICMP packets on eth0 into a vxlan
diff --git a/tc/m_tunnel_key.c b/tc/m_tunnel_key.c
index 1b4c8bd640eb..b00fe1d73c08 100644
--- a/tc/m_tunnel_key.c
+++ b/tc/m_tunnel_key.c
@@ -26,7 +26,8 @@ static void explain(void)
 		"dst_ip <IP> (mandatory)\n"
 		"dst_port <UDP_PORT>\n"
 		"geneve_opts | vxlan_opts | erspan_opts <OPTIONS>\n"
-		"csum | nocsum (default is \"csum\")\n");
+		"csum | nocsum (default is \"csum\")\n"
+		"nofrag\n");
 }
 
 static void usage(void)
@@ -321,7 +322,7 @@ static int parse_tunnel_key(struct action_util *a, int *argc_p, char ***argv_p,
 	int ret;
 	int has_src_ip = 0;
 	int has_dst_ip = 0;
-	int csum = 1;
+	int csum = 1, nofrag = 0;
 
 	if (matches(*argv, "tunnel_key") != 0)
 		return -1;
@@ -425,6 +426,8 @@ static int parse_tunnel_key(struct action_util *a, int *argc_p, char ***argv_p,
 			csum = 1;
 		} else if (matches(*argv, "nocsum") == 0) {
 			csum = 0;
+		} else if (matches(*argv, "nofrag") == 0) {
+			nofrag = 1;
 		} else if (matches(*argv, "help") == 0) {
 			usage();
 		} else {
@@ -435,6 +438,9 @@ static int parse_tunnel_key(struct action_util *a, int *argc_p, char ***argv_p,
 
 	addattr8(n, MAX_MSG, TCA_TUNNEL_KEY_NO_CSUM, !csum);
 
+	if (nofrag)
+		addattr(n, MAX_MSG, TCA_TUNNEL_KEY_NO_FRAG);
+
 	parse_action_control_dflt(&argc, &argv, &parm.action,
 				  false, TC_ACT_PIPE);
 
@@ -513,15 +519,36 @@ static void tunnel_key_print_dst_port(FILE *f, char *name,
 		   rta_getattr_be16(attr));
 }
 
-static void tunnel_key_print_flag(FILE *f, const char *name_on,
-				  const char *name_off,
-				  struct rtattr *attr)
+static const struct {
+	const char *name;
+	unsigned int nl_flag;
+} tunnel_key_flag_names[] = {
+	{ "",	    TCA_TUNNEL_KEY_NO_CSUM }, /* special handling, not bool */
+	{ "nofrag", TCA_TUNNEL_KEY_NO_FRAG },
+};
+
+static void tunnel_key_print_flags(struct rtattr *tb[])
 {
-	if (!attr)
-		return;
+	unsigned int i, nl_flag;
+
 	print_nl();
-	print_string(PRINT_ANY, "flag", "\t%s",
-		     rta_getattr_u8(attr) ? name_on : name_off);
+	for (i = 0; i < ARRAY_SIZE(tunnel_key_flag_names); i++) {
+		nl_flag = tunnel_key_flag_names[i].nl_flag;
+		if (nl_flag == TCA_TUNNEL_KEY_NO_CSUM) {
+			/* special handling to preserve csum/nocsum design */
+			if (!tb[nl_flag])
+				continue;
+			print_string(PRINT_ANY, "flag", "\t%s",
+				     rta_getattr_u8(tb[nl_flag]) ?
+					"nocsum" : "csum" );
+		} else {
+			if (tb[nl_flag])
+				print_string(PRINT_FP, NULL, "\t%s",
+					     tunnel_key_flag_names[i].name);
+			print_bool(PRINT_JSON, tunnel_key_flag_names[i].name,
+				   NULL, !!tb[nl_flag]);
+		}
+	}
 }
 
 static void tunnel_key_print_geneve_options(struct rtattr *attr)
@@ -697,8 +724,7 @@ static int print_tunnel_key(struct action_util *au, FILE *f, struct rtattr *arg)
 		tunnel_key_print_dst_port(f, "dst_port",
 					  tb[TCA_TUNNEL_KEY_ENC_DST_PORT]);
 		tunnel_key_print_key_opt(tb[TCA_TUNNEL_KEY_ENC_OPTS]);
-		tunnel_key_print_flag(f, "nocsum", "csum",
-				      tb[TCA_TUNNEL_KEY_NO_CSUM]);
+		tunnel_key_print_flags(tb);
 		tunnel_key_print_tos_ttl(f, "tos",
 					  tb[TCA_TUNNEL_KEY_ENC_TOS]);
 		tunnel_key_print_tos_ttl(f, "ttl",
-- 
2.39.2

