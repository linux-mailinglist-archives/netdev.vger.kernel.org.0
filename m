Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2FBE185792
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 02:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727220AbgCOBlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 21:41:03 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54239 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbgCOBlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 21:41:02 -0400
Received: by mail-wm1-f67.google.com with SMTP id 25so13894399wmk.3
        for <netdev@vger.kernel.org>; Sat, 14 Mar 2020 18:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=utk+Y3EnXR4eAe+bo7+GZ3rfIBJoOfB5XvmiWJiyWF4=;
        b=w/VdvvxBzUWvNIprayh4sH6VomFf+dzgwwCDAIfyk5cm/hMh9/Vouyq+8SwPkD6bSn
         V7F3d6bFBqAGKICTypAyVCoQxPJ8D3gKpT1Ae0S0ym8rTeOXWChT1ZKZXM9MfaPtlK8i
         Vi+Nn+UmYyxRb8bfS22i3tEW2TMbKhoRZuYeYs6ykpZMbWPqWHd4qpVXus45g6StLMWK
         mgtoyc2GyooUoKBouJ+dHJPHJb97IX4H4mKBZYF6aF6f9fHHRzX5jyqelUQpX6EO6xPl
         Flt4vjmds0N+IGEDc/ZwMfpvpgY8S92im1K3iDlrjtGXSinr4ulnZ/dxumZ/O4U1qgi9
         fwUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=utk+Y3EnXR4eAe+bo7+GZ3rfIBJoOfB5XvmiWJiyWF4=;
        b=cN60OBsx3LzmRCR1vBL7hKFCYHHP8BsbTq9pTI8DWdSCYQWkAxCIg8voupKz0K/g4u
         Rf2wQy/ZjJNToGbTWfowaYjCr3tPaa+cXw2J50eBB8RZFF677euSXQpe9i5xgXSviM2B
         KMhWF1q5tq9VUh+utvdxkP7TwEbdhQznmjtNSE6diOfbv053HW5q0rToBDqyPNav/k/G
         gI3TU5Dl1ujJz9fokT7l8BKMPLhKpCzbItHVe037egdhiX602+vDxwRY5ZnXDyCuB5DS
         OeZic0+hu0vSuQSOGi6SNNzE5D0vBGhxr64gKaecagY5Ch5S3XBxyHiEDsau7UYoMxAd
         gH3Q==
X-Gm-Message-State: ANhLgQ0WSRU3WmZAjr4CTfDHXy79ZSdwPg4rdZ3ig6kBcrDndP4qCCtQ
        d5570aYuBYRfKMqbuHrWfFmqQtAZs2U=
X-Google-Smtp-Source: ADFU+vvB7eZ2f/k4J51kzWkIZ5yrubueWh9uFneh/nj5lMgThR0WA2Po5BPDL5G/iOEqPoffGU9CgQ==
X-Received: by 2002:a05:600c:204:: with SMTP id 4mr14995545wmi.112.1584177950306;
        Sat, 14 Mar 2020 02:25:50 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id v26sm2988969wra.7.2020.03.14.02.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Mar 2020 02:25:49 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, mlxsw@mellanox.com
Subject: [patch iproute2/net-next v5] tc: m_action: introduce support for hw stats type
Date:   Sat, 14 Mar 2020 10:25:48 +0100
Message-Id: <20200314092548.27793-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Introduce support for per-action hw stats type config.

This patch allows user to specify one of the following types of HW
stats for added action:
immediate - queried during dump time
delayed - polled from HW periodically or sent by HW in async manner
disabled - no stats needed

Note that if "hw_stats" option is not passed, user does not care about
the type, just expects any type of stats.

Examples:
$ tc filter add dev enp0s16np28 ingress proto ip handle 1 pref 1 flower skip_sw dst_ip 192.168.1.1 action drop hw_stats disabled
$ tc -s filter show dev enp0s16np28 ingress
filter protocol ip pref 1 flower chain 0
filter protocol ip pref 1 flower chain 0 handle 0x1
  eth_type ipv4
  dst_ip 192.168.1.1
  skip_sw
  in_hw in_hw_count 2
        action order 1: gact action drop
         random type none pass val 0
         index 1 ref 1 bind 1 installed 7 sec used 2 sec
        Action statistics:
        Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
        backlog 0b 0p requeues 0
        hw_stats disabled

$ tc filter add dev enp0s16np28 ingress proto ip handle 1 pref 1 flower skip_sw dst_ip 192.168.1.1 action drop hw_stats immediate
$ tc -s filter show dev enp0s16np28 ingress
filter protocol ip pref 1 flower chain 0
filter protocol ip pref 1 flower chain 0 handle 0x1
  eth_type ipv4
  dst_ip 192.168.1.1
  skip_sw
  in_hw in_hw_count 2
        action order 1: gact action drop
         random type none pass val 0
         index 1 ref 1 bind 1 installed 11 sec used 4 sec
        Action statistics:
        Sent 102 bytes 1 pkt (dropped 1, overlimits 0 requeues 0)
        Sent software 0 bytes 0 pkt
        Sent hardware 102 bytes 1 pkt
        backlog 0b 0p requeues 0
        hw_stats immediate

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v4->v5:
- s/hwstats/hw_stats/ in help message
v3->v4:
- added to "tc actions help" output
v2->v3:
- adjusted hw_stats_type_bf struct initialization
- added comment to "disable"
v1->v2:
- added more description and examples
---
 include/uapi/linux/pkt_cls.h | 22 ++++++++++++
 man/man8/tc-actions.8        | 31 +++++++++++++++++
 tc/m_action.c                | 66 +++++++++++++++++++++++++++++++++++-
 3 files changed, 118 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 449a63971451..81cc1a869588 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -17,6 +17,7 @@ enum {
 	TCA_ACT_PAD,
 	TCA_ACT_COOKIE,
 	TCA_ACT_FLAGS,
+	TCA_ACT_HW_STATS_TYPE,
 	__TCA_ACT_MAX
 };
 
@@ -24,6 +25,27 @@ enum {
 					 * actions stats.
 					 */
 
+/* tca HW stats type
+ * When user does not pass the attribute, he does not care.
+ * It is the same as if he would pass the attribute with
+ * all supported bits set.
+ * In case no bits are set, user is not interested in getting any HW statistics.
+ */
+#define TCA_ACT_HW_STATS_TYPE_IMMEDIATE (1 << 0) /* Means that in dump, user
+						  * gets the current HW stats
+						  * state from the device
+						  * queried at the dump time.
+						  */
+#define TCA_ACT_HW_STATS_TYPE_DELAYED (1 << 1) /* Means that in dump, user gets
+						* HW stats that might be out
+						* of date for some time, maybe
+						* couple of seconds. This is
+						* the case when driver polls
+						* stats updates periodically
+						* or when it gets async stats update
+						* from the device.
+						*/
+
 #define TCA_ACT_MAX __TCA_ACT_MAX
 #define TCA_OLD_COMPAT (TCA_ACT_MAX+1)
 #define TCA_ACT_MAX_PRIO 32
diff --git a/man/man8/tc-actions.8 b/man/man8/tc-actions.8
index bee59f7247fa..7d7df00013c6 100644
--- a/man/man8/tc-actions.8
+++ b/man/man8/tc-actions.8
@@ -49,6 +49,8 @@ actions \- independently defined actions in tc
 ] [
 .I FLAGS
 ] [
+.I HWSTATSSPEC
+] [
 .I CONTROL
 ]
 
@@ -77,6 +79,12 @@ ACTNAME
 :=
 .I no_percpu
 
+.I HWSTATSSPEC
+:=
+.BR hw_stats " {"
+.IR immediate " | " delayed " | " disabled
+.R }
+
 .I ACTDETAIL
 :=
 .I ACTNAME ACTPARAMS
@@ -200,6 +208,29 @@ which indicates that action is expected to have minimal software data-path
 traffic and doesn't need to allocate stat counters with percpu allocator.
 This option is intended to be used by hardware-offloaded actions.
 
+.TP
+.BI hw_stats " HW_STATS"
+Speficies the type of HW stats of new action. If omitted, any stats counter type
+is going to be used, according to driver and its resources.
+The
+.I HW_STATS
+indicates the type. Any of the following are valid:
+.RS
+.TP
+.B immediate
+Means that in dump, user gets the current HW stats state from the device
+queried at the dump time.
+.TP
+.B delayed
+Means that in dump, user gets HW stats that might be out of date for
+some time, maybe couple of seconds. This is the case when driver polls
+stats updates periodically or when it gets async stats update
+from the device.
+.TP
+.B disabled
+No HW stats are going to be available in dump.
+.RE
+
 .TP
 .BI since " MSTIME"
 When dumping large number of actions, a millisecond time-filter can be
diff --git a/tc/m_action.c b/tc/m_action.c
index 4da810c8c0aa..58ae1846033b 100644
--- a/tc/m_action.c
+++ b/tc/m_action.c
@@ -51,8 +51,9 @@ static void act_usage(void)
 		"	FL := ls | list | flush | <ACTNAMESPEC>\n"
 		"	ACTNAMESPEC :=  action <ACTNAME>\n"
 		"	ACTISPEC := <ACTNAMESPEC> <INDEXSPEC>\n"
-		"	ACTSPEC := action <ACTDETAIL> [INDEXSPEC]\n"
+		"	ACTSPEC := action <ACTDETAIL> [INDEXSPEC] [HWSTATSSPEC]\n"
 		"	INDEXSPEC := index <32 bit indexvalue>\n"
+		"	HWSTATSSPEC := hw_stats [ immediate | delayed | disabled ]\n"
 		"	ACTDETAIL := <ACTNAME> <ACTPARAMS>\n"
 		"		Example ACTNAME is gact, mirred, bpf, etc\n"
 		"		Each action has its own parameters (ACTPARAMS)\n"
@@ -149,6 +150,59 @@ new_cmd(char **argv)
 		(matches(*argv, "add") == 0);
 }
 
+static const struct hw_stats_type_item {
+	const char *str;
+	__u8 type;
+} hw_stats_type_items[] = {
+	{ "immediate", TCA_ACT_HW_STATS_TYPE_IMMEDIATE },
+	{ "delayed", TCA_ACT_HW_STATS_TYPE_DELAYED },
+	{ "disabled", 0 }, /* no bit set */
+};
+
+static void print_hw_stats(const struct rtattr *arg)
+{
+	struct nla_bitfield32 *hw_stats_type_bf = RTA_DATA(arg);
+	__u8 hw_stats_type;
+	int i;
+
+	hw_stats_type = hw_stats_type_bf->value & hw_stats_type_bf->selector;
+	print_string(PRINT_FP, NULL, "\t", NULL);
+	open_json_array(PRINT_ANY, "hw_stats");
+
+	for (i = 0; i < ARRAY_SIZE(hw_stats_type_items); i++) {
+		const struct hw_stats_type_item *item;
+
+		item = &hw_stats_type_items[i];
+		if ((!hw_stats_type && !item->type) ||
+		    hw_stats_type & item->type)
+			print_string(PRINT_ANY, NULL, " %s", item->str);
+	}
+	close_json_array(PRINT_JSON, NULL);
+}
+
+static int parse_hw_stats(const char *str, struct nlmsghdr *n)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(hw_stats_type_items); i++) {
+		const struct hw_stats_type_item *item;
+
+		item = &hw_stats_type_items[i];
+		if (matches(str, item->str) == 0) {
+			struct nla_bitfield32 hw_stats_type_bf = {
+				.value = item->type,
+				.selector = item->type
+			};
+
+			addattr_l(n, MAX_MSG, TCA_ACT_HW_STATS_TYPE,
+				  &hw_stats_type_bf, sizeof(hw_stats_type_bf));
+			return 0;
+		}
+
+	}
+	return -1;
+}
+
 int parse_action(int *argc_p, char ***argv_p, int tca_id, struct nlmsghdr *n)
 {
 	int argc = *argc_p;
@@ -250,6 +304,14 @@ done0:
 				addattr_l(n, MAX_MSG, TCA_ACT_COOKIE,
 					  &act_ck, act_ck_len);
 
+			if (*argv && matches(*argv, "hw_stats") == 0) {
+				NEXT_ARG();
+				ret = parse_hw_stats(*argv, n);
+				if (ret < 0)
+					invarg("value is invalid\n", *argv);
+				NEXT_ARG_FWD();
+			}
+
 			if (*argv && strcmp(*argv, "no_percpu") == 0) {
 				struct nla_bitfield32 flags =
 					{ TCA_ACT_FLAGS_NO_PERCPU_STATS,
@@ -337,6 +399,8 @@ static int tc_print_one_action(FILE *f, struct rtattr *arg)
 				   TCA_ACT_FLAGS_NO_PERCPU_STATS);
 		print_string(PRINT_FP, NULL, "%s", _SL_);
 	}
+	if (tb[TCA_ACT_HW_STATS_TYPE])
+		print_hw_stats(tb[TCA_ACT_HW_STATS_TYPE]);
 
 	return 0;
 }
-- 
2.21.1

