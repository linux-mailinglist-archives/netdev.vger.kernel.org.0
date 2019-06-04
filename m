Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC29934973
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 15:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727515AbfFDNww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 09:52:52 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33051 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727033AbfFDNww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 09:52:52 -0400
Received: by mail-wm1-f68.google.com with SMTP id v19so2349124wmh.0
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 06:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=darbyshire-bryant.me.uk; s=google;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hNMqi8fgjonMJMDMpvo5BW6x0w2xEuZta68Hme39Q7w=;
        b=Ex/UKCafk5zqZ77w43jp/hhqNTJLQA3fCFdH/vGIzMRBjcb0WfnJ01WF/p4bqS+Ett
         iYp92fRGchxyReteTVp3EYLn2zujwyRxnQmTB52t0qhYoOhAzOGRF6XN8jaCAWXkNHR0
         BI2MLahP5oMIaSOnQRIJ7nSvgrOGGY2EXiVZw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=hNMqi8fgjonMJMDMpvo5BW6x0w2xEuZta68Hme39Q7w=;
        b=hzLVw+hrXavZb9cviS3onIpuVbINOwt83yGxZ9ZQ095wS9kucQfIQW+5pCm8TQsi3U
         AwJGlOporVgv+YXi3wqr7Tvu9o5oxVrIb4XFFR/SASY2MACXvpvCO8dV8BgYeP0YgqEW
         gmztYFuiLvFgn9F4Eaez3rzMs+1hZ19VBhpGuKljSDqM0FQWMRRtLk398cyJGVkgDm07
         hTVrlI8ZN9dsRgho+CvaHMmEdaQYc5q5vomvUhQNSzXmXqIjVrPTR0/l/7WOrLnq0Kk+
         B0Q9BPINje16etmyPqQDyHNJTlN2C78md1idFyq9GPuTq5cZh74t1Bfwdt10d7eEIUS6
         pc8w==
X-Gm-Message-State: APjAAAUNuzXcVJyvmdxQ2H04z7b8fbNeY6dSe89GCQMd2jZQzzWYuW6D
        ZGWJ3E61Kruz2HBDkSYA31AKNw==
X-Google-Smtp-Source: APXvYqxSdS6Fnj3y0lz5XCZOK582ybAlQ/o+bdSdwisvuwjKFXnQZXzHhOlWSEbCUZlb8KAsdqhEBg==
X-Received: by 2002:a1c:3287:: with SMTP id y129mr18794791wmy.153.1559656367909;
        Tue, 04 Jun 2019 06:52:47 -0700 (PDT)
Received: from Kevins-MBP.lan.darbyshire-bryant.me.uk ([2a02:c7f:1268:6500::dc83])
        by smtp.gmail.com with ESMTPSA id y2sm3364500wrl.4.2019.06.04.06.52.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 06:52:46 -0700 (PDT)
From:   Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
To:     stephen@networkplumber.org
Cc:     ldir@darbyshire-bryant.me.uk, netdev@vger.kernel.org,
        toke@redhat.com
Subject: [PATCH iproute2-next v2] tc: add support for action act_ctinfo
Date:   Tue,  4 Jun 2019 14:52:09 +0100
Message-Id: <20190604135208.94432-1-ldir@darbyshire-bryant.me.uk>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20190603135219.180df8e6@hermes.lan>
References: <20190603135219.180df8e6@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ctinfo is a tc action restoring data stored in conntrack marks to
various fields.  At present it has two independent modes of operation,
restoration of DSCP into IPv4/v6 diffserv and restoration of conntrack
marks into packet skb marks.

It understands a number of parameters specific to this action in
additional to the usual action syntax.  Each operating mode is
independent of the other so all options are optional, however not
specifying at least one mode is a bit pointless.

Usage: ... ctinfo [dscp mask [statemask]] [cpmark [mask]] [zone ZONE]
		  [CONTROL] [index <INDEX>]

DSCP mode

dscp enables copying of a DSCP stored in the conntrack mark into the
ipv4/v6 diffserv field.  The mask is a 32bit field and specifies where
in the conntrack mark the DSCP value is located.  It must be 6
contiguous bits long. eg. 0xfc000000 would restore the DSCP from the
upper 6 bits of the conntrack mark.

The DSCP copying may be optionally controlled by a statemask.  The
statemask is a 32bit field, usually with a single bit set and must not
overlap the dscp mask.  The DSCP restore operation will only take place
if the corresponding bit/s in conntrack mark ANDed with the statemask
yield a non zero result.

eg. dscp 0xfc000000 0x01000000 would retrieve the DSCP from the top 6
bits, whilst using bit 25 as a flag to do so.  Bit 26 is unused in this
example.

CPMARK mode

cpmark enables copying of the conntrack mark to the packet skb mark.  In
this mode it is completely equivalent to the existing act_connmark
action.  Additional functionality is provided by the optional mask
parameter, whereby the stored conntrack mark is logically ANDed with the
cpmark mask before being stored into skb mark.  This allows shared usage
of the conntrack mark between applications.

eg. cpmark 0x00ffffff would restore only the lower 24 bits of the
conntrack mark, thus may be useful in the event that the upper 8 bits
are used by the DSCP function.

Usage: ... ctinfo [dscp mask [statemask]] [cpmark [mask]] [zone ZONE]
		  [CONTROL] [index <INDEX>]
where :
	dscp MASK is the bitmask to restore DSCP
	     STATEMASK is the bitmask to determine conditional restoring
	cpmark MASK mask applied to restored packet mark
	ZONE is the conntrack zone
	CONTROL := reclassify | pipe | drop | continue | ok |
		   goto chain <CHAIN_INDEX>

Signed-off-by: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
v2 - added a man page which has been a learning experience.
     took opportunity to fix typos in commit message.

 include/uapi/linux/pkt_cls.h          |   1 +
 include/uapi/linux/tc_act/tc_ctinfo.h |  34 ++++
 man/man8/tc-ctinfo.8                  | 170 ++++++++++++++++
 tc/Makefile                           |   1 +
 tc/m_ctinfo.c                         | 268 ++++++++++++++++++++++++++
 5 files changed, 474 insertions(+)
 create mode 100644 include/uapi/linux/tc_act/tc_ctinfo.h
 create mode 100644 man/man8/tc-ctinfo.8
 create mode 100644 tc/m_ctinfo.c

diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 51a0496f..a93680fc 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -105,6 +105,7 @@ enum tca_id {
 	TCA_ID_IFE = TCA_ACT_IFE,
 	TCA_ID_SAMPLE = TCA_ACT_SAMPLE,
 	/* other actions go here */
+	TCA_ID_CTINFO,
 	__TCA_ID_MAX = 255
 };
 
diff --git a/include/uapi/linux/tc_act/tc_ctinfo.h b/include/uapi/linux/tc_act/tc_ctinfo.h
new file mode 100644
index 00000000..da803e05
--- /dev/null
+++ b/include/uapi/linux/tc_act/tc_ctinfo.h
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef __UAPI_TC_CTINFO_H
+#define __UAPI_TC_CTINFO_H
+
+#include <linux/types.h>
+#include <linux/pkt_cls.h>
+
+struct tc_ctinfo {
+	tc_gen;
+};
+
+enum {
+	TCA_CTINFO_UNSPEC,
+	TCA_CTINFO_PAD,
+	TCA_CTINFO_TM,
+	TCA_CTINFO_ACT,
+	TCA_CTINFO_ZONE,
+	TCA_CTINFO_PARMS_DSCP_MASK,
+	TCA_CTINFO_PARMS_DSCP_STATEMASK,
+	TCA_CTINFO_PARMS_CPMARK_MASK,
+	TCA_CTINFO_STATS_DSCP_SET,
+	TCA_CTINFO_STATS_DSCP_ERROR,
+	TCA_CTINFO_STATS_CPMARK_SET,
+	__TCA_CTINFO_MAX
+};
+
+#define TCA_CTINFO_MAX (__TCA_CTINFO_MAX - 1)
+
+enum {
+	CTINFO_MODE_DSCP	= BIT(0),
+	CTINFO_MODE_CPMARK	= BIT(1)
+};
+
+#endif
diff --git a/man/man8/tc-ctinfo.8 b/man/man8/tc-ctinfo.8
new file mode 100644
index 00000000..096590d1
--- /dev/null
+++ b/man/man8/tc-ctinfo.8
@@ -0,0 +1,170 @@
+.TH "ctinfo action in tc" 8 "4 Jun 2019" "iproute2" "Linux"
+.SH NAME
+ctinfo \- tc connmark processing action
+.SH SYNOPSIS
+.B tc ... action ctinfo
+[
+.B dscp
+MASK [STATEMASK] ] [
+.B cpmark
+[MASK] ] [
+.B zone
+ZONE ] [
+.B CONTROL
+] [
+.B index
+<INDEX>
+]
+
+.SH DESCRIPTION
+CTINFO (Conntrack Information) is a tc action for retrieving data from
+conntrack marks into various fields.  At present it has two independent
+processing modes which may be viewed as sub-functions.
+
+DSCP mode copies a DSCP stored in conntrack's connmark into the IPv4/v6 diffserv
+field.  The copying may conditionally occur based on a flag also stored in the
+connmark.  DSCP mode was designed to assist in restoring packet classifications on
+ingress, classifications which may then be used by qdiscs such as CAKE.  It may be
+used in any circumstance where ingress classification needs to be maintained across
+links that otherwise bleach or remap according to their own policies.
+
+CPMARK (copymark) mode copies the conntrack connmark into the packet's mark field.  Without
+additional parameters it is functionally completely equivalent to the existing
+connmark action.  An optional mask may be specified to mask which bits of the
+connmark are restored.  This may be useful when DSCP and CPMARK modes are combined.
+
+Simple statistics (tc -s) on DSCP restores and CPMARK copies are maintained where values for
+set indicate a count of packets altered for that mode.  DSCP includes an error count
+where the destination packet's diffserv field was unwriteable.
+.SH PARAMETERS
+.SS DSCP mode parameters:
+.IP mask
+A mask of 6 contiguous bits indicating where the DSCP value is located in the 32 bit
+conntrack mark field.  A mask must be provided for this mode.  mask is a 32 bit
+unsigned value.
+.IP statemask
+A mask of at least 1 bit indicating where a conditional restore flag is located in the
+32 bit conntrack mark field.  The statemask bit/s must NOT overlap the mask bits.  The
+DSCP will be restored if the conntrack mark logically ANDed with the statemask yields
+a non-zero result.  statemask is an optional unsigned 32 bit value.
+.SS CPMARK mode parameters:
+.IP mask
+Store the logically ANDed result of conntrack mark and mask into the packet's mark
+field.  Default is 0xffffffff i.e. the whole mark field.  mask is an optional unsigned 32 bit
+value
+.SS Overall action parameters:
+.IP zone
+Specify the conntrack zone when doing conntrack lookups for packets.
+zone is a 16bit unsigned decimal value.
+Default is 0.
+.IP CONTROL
+The following keywords allow to control how the tree of qdisc, classes,
+filters and actions is further traversed after this action.
+.RS
+.TP
+.B reclassify
+Restart with the first filter in the current list.
+.TP
+.B pipe
+Continue with the next action attached to the same filter.
+.TP
+.B drop
+Drop the packet.
+.TP
+.B shot
+synonym for
+.B drop
+.TP
+.B continue
+Continue classification with the next filter in line.
+.TP
+.B pass
+Finish classification process and return to calling qdisc for further packet
+processing. This is the default.
+.RE
+.IP index
+Specify an index for this action in order to being able to identify it in later
+commands. index is a 32bit unsigned decimal value.
+.SH EXAMPLES
+Example showing conditional restoration of DSCP on ingress via an IFB
+.RS
+.EX
+
+#Set up the IFB interface
+.br
+tc qdisc add dev ifb4eth0 handle ffff: ingress
+
+#Put CAKE qdisc on it
+.br
+tc qdisc add dev ifb4eth0 root cake bandwidth 40mbit
+
+#Set interface UP
+.br
+ip link set dev ifb4eth0 up
+
+#Add 2 actions, ctinfo to restore dscp & mirred to redirect the packets to IFB
+.br
+tc filter add dev eth0 parent ffff: protocol all prio 10 u32 \\
+    match u32 0 0 flowid 1:1 action    \\
+    ctinfo dscp 0xfc000000 0x01000000  \\ 
+    mirred egress redirect dev ifb4eth0
+
+tc -s qdisc show dev eth0 ingress
+
+ filter parent ffff: protocol all pref 10 u32 chain 0
+ filter parent ffff: protocol all pref 10 u32 chain 0 fh 800: ht divisor 1
+ filter parent ffff: protocol all pref 10 u32 chain 0 fh 800::800 order 2048 key ht 800 bkt 0 flowid 1:1 not_in_hw
+  match 00000000/00000000 at 0
+    action order 1: ctinfo zone 0 pipe
+    index 2 ref 1 bind 1 dscp 0xfc000000 0x01000000 installed 72 sec used 0 sec DSCP set 1333 error 0 CPMARK set 0
+    Action statistics:
+    Sent 658484 bytes 1833 pkt (dropped 0, overlimits 0 requeues 0) 
+    backlog 0b 0p requeues 0
+
+    action order 2: mirred (Egress Redirect to device ifb4eth0) stolen
+    index 1 ref 1 bind 1 installed 72 sec used 0 sec
+    Action statistics:
+    Sent 658484 bytes 1833 pkt (dropped 0, overlimits 0 requeues 0) 
+    backlog 0b 0p requeues 0
+.EE
+.RE
+
+Example showing conditional restoration of DSCP on egress
+
+This may appear nonsensical since iptables marking of egress packets is easy
+to achieve, however the iptables flow classification rules may be extensive
+and so some sort of set once and forget may be useful especially on cpu
+constrained devices.
+.RS
+.EX
+
+# Send unmarked connections to a marking chain which needs to store a DSCP
+and set statemask bit in the connmark
+.br
+iptables -t mangle -A POSTROUTING -o eth0 -m connmark \\
+    --mark 0x00000000/0x01000000 -g CLASS_MARKING_CHAIN 
+
+# Apply marked DSCP to the packets
+.br
+tc filter add dev eth0 protocol all prio 10 u32 \\
+    match u32 0 0 flowid 1:1 action \\
+    ctinfo dscp 0xfc000000 0x01000000
+
+tc -s filter show dev eth0
+ filter parent 800e: protocol all pref 10 u32 chain 0 
+ filter parent 800e: protocol all pref 10 u32 chain 0 fh 800: ht divisor 1 
+ filter parent 800e: protocol all pref 10 u32 chain 0 fh 800::800 order 2048 key ht 800 bkt 0 flowid 1:1 not_in_hw 
+  match 00000000/00000000 at 0
+    action order 1: ctinfo zone 0 pipe
+    index 1 ref 1 bind 1 dscp 0xfc000000 0x01000000 installed 7414 sec used 0 sec DSCP set 53404 error 0 CPMARK set 0
+    Action statistics:
+    Sent 32890260 bytes 120441 pkt (dropped 0, overlimits 0 requeues 0) 
+    backlog 0b 0p requeues 0
+.br
+.SH SEE ALSO
+.BR tc (8),
+.BR tc-cake (8)
+.BR tc-connmark (8)
+.BR tc-mirred (8)
+.SH AUTHORS
+ctinfo was written by Kevin Darbyshire-Bryant.
diff --git a/tc/Makefile b/tc/Makefile
index 1a305cf4..60abddee 100644
--- a/tc/Makefile
+++ b/tc/Makefile
@@ -48,6 +48,7 @@ TCMODULES += m_csum.o
 TCMODULES += m_simple.o
 TCMODULES += m_vlan.o
 TCMODULES += m_connmark.o
+TCMODULES += m_ctinfo.o
 TCMODULES += m_bpf.o
 TCMODULES += m_tunnel_key.o
 TCMODULES += m_sample.o
diff --git a/tc/m_ctinfo.c b/tc/m_ctinfo.c
new file mode 100644
index 00000000..5e451f87
--- /dev/null
+++ b/tc/m_ctinfo.c
@@ -0,0 +1,268 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * m_ctinfo.c		netfilter ctinfo mark action
+ *
+ * Copyright (c) 2019 Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <string.h>
+#include "utils.h"
+#include "tc_util.h"
+#include <linux/tc_act/tc_ctinfo.h>
+
+static void
+explain(void)
+{
+	fprintf(stderr,
+		"Usage: ... ctinfo [dscp mask [statemask]] [cpmark [mask]] [zone ZONE] [CONTROL] [index <INDEX>]\n"
+		"where :\n"
+		"\tdscp   MASK bitmask location of stored DSCP\n"
+		"\t       STATEMASK bitmask to determine conditional restoring\n"
+		"\tcpmark MASK mask applied to mark on restoration\n"
+		"\tZONE is the conntrack zone\n"
+		"\tCONTROL := reclassify | pipe | drop | continue | ok |\n"
+		"\t           goto chain <CHAIN_INDEX>\n");
+}
+
+static void
+usage(void)
+{
+	explain();
+	exit(-1);
+}
+
+static int
+parse_ctinfo(struct action_util *a, int *argc_p, char ***argv_p, int tca_id,
+	     struct nlmsghdr *n)
+{
+	unsigned int cpmarkmask = 0, dscpmask = 0, dscpstatemask = 0;
+	struct tc_ctinfo sel = {};
+	unsigned short zone = 0;
+	char **argv = *argv_p;
+	struct rtattr *tail;
+	int argc = *argc_p;
+	int ok = 0;
+	__u8 i;
+
+	while (argc > 0) {
+		if (matches(*argv, "ctinfo") == 0) {
+			ok = 1;
+			NEXT_ARG_FWD();
+		} else if (matches(*argv, "help") == 0) {
+			usage();
+		} else {
+			break;
+		}
+
+	}
+
+	if (!ok) {
+		explain();
+		return -1;
+	}
+
+	if (argc) {
+		if (matches(*argv, "dscp") == 0) {
+			NEXT_ARG();
+			if (get_u32(&dscpmask, *argv, 0)) {
+				fprintf(stderr,
+					"ctinfo: Illegal dscp \"mask\"\n");
+				return -1;
+			}
+			if (NEXT_ARG_OK()) {
+				NEXT_ARG_FWD();
+				if (!get_u32(&dscpstatemask, *argv, 0))
+					NEXT_ARG_FWD(); /* was a statemask */
+			} else {
+				NEXT_ARG_FWD();
+			}
+		}
+	}
+
+	/* cpmark has optional mask parameter, so the next arg might not  */
+	/* exist, or it might be the next option, or it may actually be a */
+	/* 32bit mask */
+	if (argc) {
+		if (matches(*argv, "cpmark") == 0) {
+			cpmarkmask = ~0;
+			if (NEXT_ARG_OK()) {
+				NEXT_ARG_FWD();
+				if (!get_u32(&cpmarkmask, *argv, 0))
+					NEXT_ARG_FWD(); /* was a mask */
+			} else {
+				NEXT_ARG_FWD();
+			}
+		}
+	}
+
+	if (argc) {
+		if (matches(*argv, "zone") == 0) {
+			NEXT_ARG();
+			if (get_u16(&zone, *argv, 10)) {
+				fprintf(stderr, "ctinfo: Illegal \"zone\"\n");
+				return -1;
+			}
+			NEXT_ARG_FWD();
+		}
+	}
+
+	parse_action_control_dflt(&argc, &argv, &sel.action,
+				  false, TC_ACT_PIPE);
+
+	if (argc) {
+		if (matches(*argv, "index") == 0) {
+			NEXT_ARG();
+			if (get_u32(&sel.index, *argv, 10)) {
+				fprintf(stderr, "ctinfo: Illegal \"index\"\n");
+				return -1;
+			}
+			NEXT_ARG_FWD();
+		}
+	}
+
+	if (dscpmask & dscpstatemask) {
+		fprintf(stderr,
+			"ctinfo: dscp mask & statemask must NOT overlap\n");
+		return -1;
+	}
+
+	i = ffs(dscpmask);
+	if (i && ((~0 & (dscpmask >> (i - 1))) != 0x3f)) {
+		fprintf(stderr,
+			"ctinfo: dscp mask must be 6 contiguous bits long\n");
+		return -1;
+	}
+
+	tail = addattr_nest(n, MAX_MSG, tca_id);
+	addattr_l(n, MAX_MSG, TCA_CTINFO_ACT, &sel, sizeof(sel));
+	addattr16(n, MAX_MSG, TCA_CTINFO_ZONE, zone);
+
+	if (dscpmask)
+		addattr32(n, MAX_MSG,
+			  TCA_CTINFO_PARMS_DSCP_MASK, dscpmask);
+
+	if (dscpstatemask)
+		addattr32(n, MAX_MSG,
+			  TCA_CTINFO_PARMS_DSCP_STATEMASK, dscpstatemask);
+
+	if (cpmarkmask)
+		addattr32(n, MAX_MSG,
+			  TCA_CTINFO_PARMS_CPMARK_MASK, cpmarkmask);
+
+	addattr_nest_end(n, tail);
+
+	*argc_p = argc;
+	*argv_p = argv;
+	return 0;
+}
+
+static void print_ctinfo_stats(FILE *f, struct rtattr *tb[TCA_CTINFO_MAX + 1])
+{
+	struct tcf_t *tm;
+
+	if (tb[TCA_CTINFO_TM]) {
+		tm = RTA_DATA(tb[TCA_CTINFO_TM]);
+
+		print_tm(f, tm);
+	}
+
+	if (tb[TCA_CTINFO_STATS_DSCP_SET])
+		print_lluint(PRINT_ANY, "dscpset", " DSCP set %llu",
+			     rta_getattr_u64(tb[TCA_CTINFO_STATS_DSCP_SET]));
+	if (tb[TCA_CTINFO_STATS_DSCP_ERROR])
+		print_lluint(PRINT_ANY, "dscperror", " error %llu",
+			     rta_getattr_u64(tb[TCA_CTINFO_STATS_DSCP_ERROR]));
+
+	if (tb[TCA_CTINFO_STATS_CPMARK_SET])
+		print_lluint(PRINT_ANY, "cpmarkset", " CPMARK set %llu",
+			     rta_getattr_u64(tb[TCA_CTINFO_STATS_CPMARK_SET]));
+}
+
+static int print_ctinfo(struct action_util *au, FILE *f, struct rtattr *arg)
+{
+	unsigned int cpmarkmask = ~0, dscpmask = 0, dscpstatemask = 0;
+	struct rtattr *tb[TCA_CTINFO_MAX + 1];
+	unsigned short zone = 0;
+	struct tc_ctinfo *ci;
+
+	if (arg == NULL)
+		return -1;
+
+	parse_rtattr_nested(tb, TCA_CTINFO_MAX, arg);
+	if (!tb[TCA_CTINFO_ACT]) {
+		print_string(PRINT_FP, NULL, "%s",
+			     "[NULL ctinfo action parameters]");
+		return -1;
+	}
+
+	ci = RTA_DATA(tb[TCA_CTINFO_ACT]);
+
+	if (tb[TCA_CTINFO_PARMS_DSCP_MASK]) {
+		if (RTA_PAYLOAD(tb[TCA_CTINFO_PARMS_DSCP_MASK]) >=
+		    sizeof(__u32))
+			dscpmask = rta_getattr_u32(
+					tb[TCA_CTINFO_PARMS_DSCP_MASK]);
+		else
+			print_string(PRINT_FP, NULL, "%s",
+				     "[invalid dscp mask parameter]");
+	}
+
+	if (tb[TCA_CTINFO_PARMS_DSCP_STATEMASK]) {
+		if (RTA_PAYLOAD(tb[TCA_CTINFO_PARMS_DSCP_STATEMASK]) >=
+		    sizeof(__u32))
+			dscpstatemask = rta_getattr_u32(
+					tb[TCA_CTINFO_PARMS_DSCP_STATEMASK]);
+		else
+			print_string(PRINT_FP, NULL, "%s",
+				     "[invalid dscp statemask parameter]");
+	}
+
+	if (tb[TCA_CTINFO_PARMS_CPMARK_MASK]) {
+		if (RTA_PAYLOAD(tb[TCA_CTINFO_PARMS_CPMARK_MASK]) >=
+		    sizeof(__u32))
+			cpmarkmask = rta_getattr_u32(
+					tb[TCA_CTINFO_PARMS_CPMARK_MASK]);
+		else
+			print_string(PRINT_FP, NULL, "%s",
+				     "[invalid cpmark mask parameter]");
+	}
+
+	if (tb[TCA_CTINFO_ZONE] && RTA_PAYLOAD(tb[TCA_CTINFO_ZONE]) >=
+	    sizeof(__u16))
+		zone = rta_getattr_u16(tb[TCA_CTINFO_ZONE]);
+
+	print_string(PRINT_ANY, "kind", "%s ", "ctinfo");
+	print_hu(PRINT_ANY, "zone", "zone %u", zone);
+	print_action_control(f, " ", ci->action, "");
+
+	print_string(PRINT_FP, NULL, "%s", _SL_);
+	print_uint(PRINT_ANY, "index", "\t index %u", ci->index);
+	print_int(PRINT_ANY, "ref", " ref %d", ci->refcnt);
+	print_int(PRINT_ANY, "bind", " bind %d", ci->bindcnt);
+
+	if (tb[TCA_CTINFO_PARMS_DSCP_MASK]) {
+		print_0xhex(PRINT_ANY, "dscpmask", " dscp %#010llx", dscpmask);
+		print_0xhex(PRINT_ANY, "dscpstatemask", " %#010llx",
+			    dscpstatemask);
+	}
+
+	if (tb[TCA_CTINFO_PARMS_CPMARK_MASK])
+		print_0xhex(PRINT_ANY, "cpmark", " cpmark %#010llx",
+			    cpmarkmask);
+
+	if (show_stats)
+		print_ctinfo_stats(f, tb);
+
+	print_string(PRINT_FP, NULL, "%s", _SL_);
+
+	return 0;
+}
+
+struct action_util ctinfo_action_util = {
+	.id = "ctinfo",
+	.parse_aopt = parse_ctinfo,
+	.print_aopt = print_ctinfo,
+};
-- 
2.20.1 (Apple Git-117)

