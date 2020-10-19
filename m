Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11358292A4A
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 17:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730127AbgJSPXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 11:23:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20431 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729544AbgJSPXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 11:23:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603120987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5Jm0UZAni2Sj7ACDQrN/FANmPI3FttTmXGTUg5ePf90=;
        b=Ouyts7JAFjZN9U0dTL+3fDNlBkB1X5sMpc0gvbu3e2VQ66m+IW1CuCxjDMCXv3R3D9MfgI
        WiVYAnEYYLoTRmn694OFmtkwEW7+o8p6nLNPf1sZZEiDltBi71l2Pq052y/1ZUHGTuh5PV
        62bCnHoVd4gG+9AeBxEytG9muEg7UZI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-542-Kj-5LiRMPtO_c2aYuZO6QQ-1; Mon, 19 Oct 2020 11:23:05 -0400
X-MC-Unique: Kj-5LiRMPtO_c2aYuZO6QQ-1
Received: by mail-wr1-f70.google.com with SMTP id t17so8777wrm.13
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 08:23:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5Jm0UZAni2Sj7ACDQrN/FANmPI3FttTmXGTUg5ePf90=;
        b=nCvfh8kISpvMOv4DOik65V2CuqSSUoNXn0k/wul0x2YQMg7u1QTM8rLYh6XFZwzxf3
         grlEBsOa8Lyu247iVZLTQP1dAvHLedMpka6fpZXCPvwmygPPNFtA661mfwYv4RA+pxzz
         0KGP/vYV0yemt0UoE1oQ89sShZ+8QmB5WAFJkJmFgx6Q6qfFJny8bdniIz6i1RlqbGg1
         HfdYWXKTJQrsNeiuCg3QAr6SlVHaXx/39ZhgUxPvQyP+JLoPkojj2Kg1/ikmRWl0baaM
         3iF5rsdh+vI4NDBSwsxI/cnFHU+/Rs2JZTtWCqo8EoyNCvUWYYRgRYucnsvo0msogHsT
         BhSw==
X-Gm-Message-State: AOAM533b89UcEwxPJRBn9HJgF6XEfdpchMHI+dddI5FpnOPo7762WFuE
        eUORNKNqwchhAYGSrpsTWrTscGLEEa2dPUtJjuvh6flmb/XdKhJ3shUchypGkf2dz9jp6jFT+in
        pGOFlVDv+QqvFeibP
X-Received: by 2002:a1c:b757:: with SMTP id h84mr66075wmf.108.1603120984003;
        Mon, 19 Oct 2020 08:23:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw4L+x7esXiSifkqP+wRlhvYmKd8MPEnOmfo0/wAC+kjx22CTMKjfFVDdeiDT41Dk5Kwv6o4w==
X-Received: by 2002:a1c:b757:: with SMTP id h84mr66052wmf.108.1603120983671;
        Mon, 19 Oct 2020 08:23:03 -0700 (PDT)
Received: from pc-2.home (2a01cb058d4f8400c9f0d639f7c74c26.ipv6.abo.wanadoo.fr. [2a01:cb05:8d4f:8400:c9f0:d639:f7c7:4c26])
        by smtp.gmail.com with ESMTPSA id v9sm408441wmh.23.2020.10.19.08.23.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 08:23:03 -0700 (PDT)
Date:   Mon, 19 Oct 2020 17:23:01 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, martin.varghese@nokia.com
Subject: [PATCH v2 iproute2-next 1/2] m_vlan: add pop_eth and push_eth actions
Message-ID: <a35ef5479e7a47f25d0f07e31d13b89256f4b4cc.1603120726.git.gnault@redhat.com>
References: <cover.1603120726.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1603120726.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the new TCA_VLAN_ACT_POP_ETH and TCA_VLAN_ACT_PUSH_ETH
actions (kernel commit 19fbcb36a39e ("net/sched: act_vlan:
Add {POP,PUSH}_ETH actions"). These action let TC remove or add the
Ethernet at the head of a frame.

Drop an Ethernet header:
 # tc filter add dev ethX matchall action vlan pop_eth

Push an Ethernet header (the original frame must have no MAC header):
 # tc filter add dev ethX matchall action vlan \
       push_eth dst_mac 0a:00:00:00:00:02 src_mac 0a:00:00:00:00:01

Also add a test suite for m_vlan, which covers these new actions and
the pre-existing ones.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 man/man8/tc-vlan.8        | 39 +++++++++++++++++-
 tc/m_vlan.c               | 69 +++++++++++++++++++++++++++++++
 testsuite/tests/tc/vlan.t | 86 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 192 insertions(+), 2 deletions(-)
 create mode 100755 testsuite/tests/tc/vlan.t

diff --git a/man/man8/tc-vlan.8 b/man/man8/tc-vlan.8
index f5ffc25f..5c2808b1 100644
--- a/man/man8/tc-vlan.8
+++ b/man/man8/tc-vlan.8
@@ -5,8 +5,8 @@ vlan - vlan manipulation module
 .SH SYNOPSIS
 .in +8
 .ti -8
-.BR tc " ... " "action vlan" " { " pop " |"
-.IR PUSH " | " MODIFY " } [ " CONTROL " ]"
+.BR tc " ... " "action vlan" " { " pop " | " pop_eth " |"
+.IR PUSH " | " MODIFY " | " PUSH_ETH " } [ " CONTROL " ]"
 
 .ti -8
 .IR PUSH " := "
@@ -24,6 +24,11 @@ vlan - vlan manipulation module
 .IR VLANPRIO " ] "
 .BI id " VLANID"
 
+.ti -8
+.IR PUSH_ETH " := "
+.B push_eth
+.BI dst_mac " LLADDR " src_mac " LLADDR "
+
 .ti -8
 .IR CONTROL " := { "
 .BR reclassify " | " pipe " | " drop " | " continue " | " pass " | " goto " " chain " " CHAIN_INDEX " }"
@@ -43,6 +48,20 @@ modes require at least a
 and allow to optionally choose the
 .I VLANPROTO
 to use.
+
+The
+.B vlan
+action can also be used to add or remove the base Ethernet header. The
+.B pop_eth
+mode, which takes no argument, is used to remove the base Ethernet header. All
+existing VLANs must have been previously dropped. The opposite operation,
+adding a base Ethernet header, is done with the
+.B push_eth
+mode. In that case, the packet must have no MAC header (stacking MAC headers is
+not permitted). This mode is mostly useful when a previous action has
+encapsulated the whole original frame behind a network header and one needs
+to prepend an Ethernet header before forwarding the resulting packet.
+
 .SH OPTIONS
 .TP
 .B pop
@@ -58,6 +77,16 @@ Replace mode. Existing 802.1Q tag is replaced. Requires at least
 .B id
 option.
 .TP
+.B pop_eth
+Ethernet header decapsulation mode. Only works on a plain Ethernet header:
+VLANs, if any, must be removed first.
+.TP
+.B push_eth
+Ethernet header encapsulation mode. The Ethertype is automatically set
+using the network header type. Chaining Ethernet headers is not allowed: the
+packet must have no MAC header when using this mode. Requires the
+.BR "dst_mac " and " src_mac " options.
+.TP
 .BI id " VLANID"
 Specify the VLAN ID to encapsulate into.
 .I VLANID
@@ -73,6 +102,12 @@ Choose the VLAN protocol to use. At the time of writing, the kernel accepts only
 .BI priority " VLANPRIO"
 Choose the VLAN priority to use. Decimal number in range of 0-7.
 .TP
+.BI dst_mac " LLADDR"
+Choose the destination MAC address to use.
+.TP
+.BI src_mac " LLADDR"
+Choose the source MAC address to use.
+.TP
 .I CONTROL
 How to continue after executing this action.
 .RS
diff --git a/tc/m_vlan.c b/tc/m_vlan.c
index 1096ba0f..e6b21330 100644
--- a/tc/m_vlan.c
+++ b/tc/m_vlan.c
@@ -23,6 +23,8 @@ static const char * const action_names[] = {
 	[TCA_VLAN_ACT_POP] = "pop",
 	[TCA_VLAN_ACT_PUSH] = "push",
 	[TCA_VLAN_ACT_MODIFY] = "modify",
+	[TCA_VLAN_ACT_POP_ETH] = "pop_eth",
+	[TCA_VLAN_ACT_PUSH_ETH] = "push_eth",
 };
 
 static void explain(void)
@@ -31,6 +33,8 @@ static void explain(void)
 		"Usage: vlan pop\n"
 		"       vlan push [ protocol VLANPROTO ] id VLANID [ priority VLANPRIO ] [CONTROL]\n"
 		"       vlan modify [ protocol VLANPROTO ] id VLANID [ priority VLANPRIO ] [CONTROL]\n"
+		"       vlan pop_eth [CONTROL]\n"
+		"       vlan push_eth dst_mac LLADDR src_mac LLADDR [CONTROL]\n"
 		"       VLANPROTO is one of 802.1Q or 802.1AD\n"
 		"            with default: 802.1Q\n"
 		"       CONTROL := reclassify | pipe | drop | continue | pass |\n"
@@ -63,6 +67,10 @@ static int parse_vlan(struct action_util *a, int *argc_p, char ***argv_p,
 	char **argv = *argv_p;
 	struct rtattr *tail;
 	int action = 0;
+	char dst_mac[ETH_ALEN] = {};
+	int dst_mac_set = 0;
+	char src_mac[ETH_ALEN] = {};
+	int src_mac_set = 0;
 	__u16 id;
 	int id_set = 0;
 	__u16 proto;
@@ -95,6 +103,18 @@ static int parse_vlan(struct action_util *a, int *argc_p, char ***argv_p,
 				return -1;
 			}
 			action = TCA_VLAN_ACT_MODIFY;
+		} else if (matches(*argv, "pop_eth") == 0) {
+			if (action) {
+				unexpected(*argv);
+				return -1;
+			}
+			action = TCA_VLAN_ACT_POP_ETH;
+		} else if (matches(*argv, "push_eth") == 0) {
+			if (action) {
+				unexpected(*argv);
+				return -1;
+			}
+			action = TCA_VLAN_ACT_PUSH_ETH;
 		} else if (matches(*argv, "id") == 0) {
 			if (!has_push_attribs(action))
 				invarg("only valid for push/modify", *argv);
@@ -119,6 +139,22 @@ static int parse_vlan(struct action_util *a, int *argc_p, char ***argv_p,
 			if (get_u8(&prio, *argv, 0) || (prio & ~0x7))
 				invarg("prio is invalid", *argv);
 			prio_set = 1;
+		} else if (matches(*argv, "dst_mac") == 0) {
+			if (action != TCA_VLAN_ACT_PUSH_ETH)
+				invarg("only valid for push_eth", *argv);
+
+			NEXT_ARG();
+			if (ll_addr_a2n(dst_mac, sizeof(dst_mac), *argv) < 0)
+				invarg("dst_mac is invalid", *argv);
+			dst_mac_set = 1;
+		} else if (matches(*argv, "src_mac") == 0) {
+			if (action != TCA_VLAN_ACT_PUSH_ETH)
+				invarg("only valid for push_eth", *argv);
+
+			NEXT_ARG();
+			if (ll_addr_a2n(src_mac, sizeof(src_mac), *argv) < 0)
+				invarg("src_mac is invalid", *argv);
+			src_mac_set = 1;
 		} else if (matches(*argv, "help") == 0) {
 			usage();
 		} else {
@@ -150,6 +186,20 @@ static int parse_vlan(struct action_util *a, int *argc_p, char ***argv_p,
 		return -1;
 	}
 
+	if (action == TCA_VLAN_ACT_PUSH_ETH) {
+		if (!dst_mac_set) {
+			fprintf(stderr, "dst_mac needs to be set for %s\n",
+				action_names[action]);
+			explain();
+			return -1;
+		} else if (!src_mac_set) {
+			fprintf(stderr, "src_mac needs to be set for %s\n",
+				action_names[action]);
+			explain();
+			return -1;
+		}
+	}
+
 	parm.v_action = action;
 	tail = addattr_nest(n, MAX_MSG, tca_id);
 	addattr_l(n, MAX_MSG, TCA_VLAN_PARMS, &parm, sizeof(parm));
@@ -167,6 +217,12 @@ static int parse_vlan(struct action_util *a, int *argc_p, char ***argv_p,
 	}
 	if (prio_set)
 		addattr8(n, MAX_MSG, TCA_VLAN_PUSH_VLAN_PRIORITY, prio);
+	if (dst_mac_set)
+		addattr_l(n, MAX_MSG, TCA_VLAN_PUSH_ETH_DST, dst_mac,
+			  sizeof(dst_mac));
+	if (src_mac_set)
+		addattr_l(n, MAX_MSG, TCA_VLAN_PUSH_ETH_SRC, src_mac,
+			  sizeof(src_mac));
 
 	addattr_nest_end(n, tail);
 
@@ -216,6 +272,19 @@ static int print_vlan(struct action_util *au, FILE *f, struct rtattr *arg)
 			print_uint(PRINT_ANY, "priority", " priority %u", val);
 		}
 		break;
+	case TCA_VLAN_ACT_PUSH_ETH:
+		if (tb[TCA_VLAN_PUSH_ETH_DST] &&
+		    RTA_PAYLOAD(tb[TCA_VLAN_PUSH_ETH_DST]) == ETH_ALEN) {
+			ll_addr_n2a(RTA_DATA(tb[TCA_VLAN_PUSH_ETH_DST]),
+				    ETH_ALEN, 0, b1, sizeof(b1));
+			print_string(PRINT_ANY, "dst_mac", " dst_mac %s", b1);
+		}
+		if (tb[TCA_VLAN_PUSH_ETH_SRC &&
+		       RTA_PAYLOAD(tb[TCA_VLAN_PUSH_ETH_SRC]) == ETH_ALEN]) {
+			ll_addr_n2a(RTA_DATA(tb[TCA_VLAN_PUSH_ETH_SRC]),
+				    ETH_ALEN, 0, b1, sizeof(b1));
+			print_string(PRINT_ANY, "src_mac", " src_mac %s", b1);
+		}
 	}
 	print_action_control(f, " ", parm->action, "");
 
diff --git a/testsuite/tests/tc/vlan.t b/testsuite/tests/tc/vlan.t
new file mode 100755
index 00000000..b86dc364
--- /dev/null
+++ b/testsuite/tests/tc/vlan.t
@@ -0,0 +1,86 @@
+#!/bin/sh
+
+. lib/generic.sh
+
+DEV="$(rand_dev)"
+ts_ip "$0" "Add $DEV dummy interface" link add dev $DEV up type dummy
+ts_tc "$0" "Add ingress qdisc" qdisc add dev $DEV ingress
+
+reset_qdisc()
+{
+	ts_tc "$0" "Remove ingress qdisc" qdisc del dev $DEV ingress
+	ts_tc "$0" "Add ingress qdisc" qdisc add dev $DEV ingress
+}
+
+ts_tc "$0" "Add vlan action pop" \
+	filter add dev $DEV ingress matchall action vlan pop
+ts_tc "$0" "Show ingress filters" filter show dev $DEV ingress
+test_on "vlan"
+test_on "pop"
+test_on "pipe"
+
+reset_qdisc
+ts_tc "$0" "Add vlan action push (default parameters)" \
+	filter add dev $DEV ingress matchall action vlan push id 5
+ts_tc "$0" "Show ingress filters" filter show dev $DEV ingress
+test_on "vlan"
+test_on "push"
+test_on "id 5"
+test_on "protocol 802.1Q"
+test_on "priority 0"
+test_on "pipe"
+
+reset_qdisc
+ts_tc "$0" "Add vlan action push (explicit parameters)" \
+	filter add dev $DEV ingress matchall            \
+	action vlan push id 5 protocol 802.1ad priority 2
+ts_tc "$0" "Show ingress filters" filter show dev $DEV ingress
+test_on "vlan"
+test_on "push"
+test_on "id 5"
+test_on "protocol 802.1ad"
+test_on "priority 2"
+test_on "pipe"
+
+reset_qdisc
+ts_tc "$0" "Add vlan action modify (default parameters)" \
+	filter add dev $DEV ingress matchall action vlan modify id 5
+ts_tc "$0" "Show ingress filters" filter show dev $DEV ingress
+test_on "vlan"
+test_on "modify"
+test_on "id 5"
+test_on "protocol 802.1Q"
+test_on "priority 0"
+test_on "pipe"
+
+reset_qdisc
+ts_tc "$0" "Add vlan action modify (explicit parameters)" \
+	filter add dev $DEV ingress matchall              \
+	action vlan modify id 5 protocol 802.1ad priority 2
+ts_tc "$0" "Show ingress filters" filter show dev $DEV ingress
+test_on "vlan"
+test_on "modify"
+test_on "id 5"
+test_on "protocol 802.1ad"
+test_on "priority 2"
+test_on "pipe"
+
+reset_qdisc
+ts_tc "$0" "Add vlan action pop_eth" \
+	filter add dev $DEV ingress matchall action vlan pop_eth
+ts_tc "$0" "Show ingress filters" filter show dev $DEV ingress
+test_on "vlan"
+test_on "pop_eth"
+test_on "pipe"
+
+reset_qdisc
+ts_tc "$0" "Add vlan action push_eth"                  \
+	filter add dev $DEV ingress matchall           \
+	action vlan push_eth dst_mac 02:00:00:00:00:02 \
+	src_mac 02:00:00:00:00:01
+ts_tc "$0" "Show ingress filters" filter show dev $DEV ingress
+test_on "vlan"
+test_on "push_eth"
+test_on "dst_mac 02:00:00:00:00:02"
+test_on "src_mac 02:00:00:00:00:01"
+test_on "pipe"
-- 
2.21.3

