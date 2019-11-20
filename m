Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3F9103AAF
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 14:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730059AbfKTNFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 08:05:32 -0500
Received: from mail-eopbgr50050.outbound.protection.outlook.com ([40.107.5.50]:61262
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730039AbfKTNFb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 08:05:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T41aRNzetiNdWt4t79Oly5dyU0g8XHe9rC+XgEaM1f4f3CgicG0Ed+lyWg4hO3kBoi3HKhHXTo8TWf9hk+eKZ8j5wi/h/QQqLIih3cNkfcPSnC+yOBMufs5HKdaOoN+yREWy3TNYaL6aAacZOgy/1zXh03lSYUd6mGwicMddnjsW5C2W2gr0MejKzIabFV3QVz2u1Z8oM4BqgcVhhYOjZo3vmStUSird8cMNc9RoXlG1uEEJdSyzFBMaeQ35StvtZfX/BRf4o2+uS3o2sAvWn09E8nvdILnRtg5Z5NrjxzXoxDCcz73KDekpX7DVlErOzLp2u6sHhO9UxO8XBQy7tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uQk9N0vcjLxF0Grp1mbI7wgoIV7nWLtApHwsRzZ3hW0=;
 b=YOuZBJdlH/qCN0vlZtTHcEg2AsFGZW5UGzxF7TJmfCWCLJu0deMbdbSpYhxRJrQwG2qM9U9sC9QstPC4rTADu0FbYCWec1Hc6speqRuJNtOwZzxy7dtBQRBh1PSORmZ4kmDUb85KjWMh0oylwR9m3Abzf/HASFfDD13zN4pGuMGxYYldXBR1g9i6fiEhgvvWcn7I01XbsJMUNpE4YN7ZQRlZYcjhmXv8DofHoEnxic3glVVOJVbZOIfj78FmLWgLdd3cma3i25frQWx8mSTjamfoBEKrtxbu9I2t/f0CyozPpdq/LvZ0ZSif8uWYIbppgB3UKzzV93eiXVZQxqbArg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uQk9N0vcjLxF0Grp1mbI7wgoIV7nWLtApHwsRzZ3hW0=;
 b=oVK+NnPKl94Hf/QZahYsv1PIQvSAlTgyHlB54eVR3YRSSbu/jIHaLPZX/jvlIbo98OYb8C5akyFouJq07pegq6tjrEk44lwgZyY5VENRreudVDen5s0J3dl7R2Ai/MyXes5bctk4hKPThs5xpm3W2VWyujZ24zhsUA6poam2obs=
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com (10.172.250.135) by
 DB6PR0502MB2950.eurprd05.prod.outlook.com (10.172.246.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.28; Wed, 20 Nov 2019 13:05:22 +0000
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::24d5:3eb9:d96b:c521]) by DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::24d5:3eb9:d96b:c521%7]) with mapi id 15.20.2451.029; Wed, 20 Nov 2019
 13:05:22 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: [RFC PATCH 3/3] tc: Add support for ETS Qdisc
Thread-Topic: [RFC PATCH 3/3] tc: Add support for ETS Qdisc
Thread-Index: AQHVn6MqLDZCnQebb0WbhpEYHh1GXg==
Date:   Wed, 20 Nov 2019 13:05:22 +0000
Message-ID: <20191120130519.17702-3-petrm@mellanox.com>
References: <cover.1574253236.git.petrm@mellanox.com>
In-Reply-To: <cover.1574253236.git.petrm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-clientproxiedby: LO2P265CA0375.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a3::27) To DB6PR0502MB3047.eurprd05.prod.outlook.com
 (2603:10a6:4:9f::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e0a068da-71c1-4933-b66d-08d76dba4cea
x-ms-traffictypediagnostic: DB6PR0502MB2950:|DB6PR0502MB2950:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0502MB295080A9FCFCA810AE40845DDB4F0@DB6PR0502MB2950.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(136003)(396003)(346002)(366004)(189003)(199004)(30864003)(52116002)(486006)(8936002)(2616005)(66066001)(256004)(14444005)(5024004)(476003)(25786009)(6486002)(102836004)(6506007)(386003)(76176011)(81156014)(3846002)(316002)(6116002)(54906003)(2501003)(6436002)(26005)(66946007)(66476007)(66556008)(66446008)(64756008)(86362001)(5640700003)(5660300002)(6916009)(2906002)(11346002)(8676002)(71190400001)(1730700003)(2351001)(81166006)(446003)(1076003)(99286004)(478600001)(7736002)(6512007)(50226002)(36756003)(305945005)(4326008)(14454004)(186003)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0502MB2950;H:DB6PR0502MB3047.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PboznjB/nDRmw45Q39/6Csn32FFB8T9B13xQ7Z52mfq8lKgZ+IwFC8E7/SABrq7OXz+pZfK7+IhVEnqCoJ5mYfjG6k4neTCJHzo23uuzZTvojP9cWmK+tjvOpzsY0gw3Uw4JTec+uTLUdbmR1sdguIq6bgxhQMElrksssS/fBrNpDBZCOS35cWDos0JqhGPRja0PFt7R3+1kDa1jP/j7E/2nDO1oslugJRzXI1XuQkYYEde4ESyB+ZUCc3cp+W0wwMNvTz28wj3YwL0bjNs3kGjxI9Xczye76qTh5+Y8itoBQlYRKvFnjyVlgmUhAjYLfHpk5JgQ+Ccb2HEhXiVMpexrQq49l/lqAXB2RFa4Us9Rx4yLpY6Tg21qVe1B4AS+YgZ56dBg0nzImdl/r5aDkMkvbiAn0bYAWIa2KCHjpcE31iAXgncHQL0wIMIVQuCe
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0a068da-71c1-4933-b66d-08d76dba4cea
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 13:05:22.0668
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dQ7o+zyWUfDP0tab6WX7xg9y2i5gH4BF+j79Vfhjrs8grUymFLfwGHNydyBV/XrFTFTD79DW6jW/+BRrHvmgWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB2950
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new module to generate and parse options specific to the ETS Qdisc.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 man/man8/tc-ets.8 | 165 ++++++++++++++++++++++
 man/man8/tc.8     |   1 +
 tc/Makefile       |   1 +
 tc/q_ets.c        | 338 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 505 insertions(+)
 create mode 100644 man/man8/tc-ets.8
 create mode 100644 tc/q_ets.c

diff --git a/man/man8/tc-ets.8 b/man/man8/tc-ets.8
new file mode 100644
index 00000000..fe824106
--- /dev/null
+++ b/man/man8/tc-ets.8
@@ -0,0 +1,165 @@
+.TH TC 8 "October 2019" "iproute2" "Linux"
+.SH NAME
+ETS \- Enhanced Transmission Selection scheduler
+.SH SYNOPSIS
+.B tc qdisc ... ets [ bands
+number
+.B ] [ strict
+number
+.B ] [ quanta
+bytes bytes bytes...
+.B ] [ priomap
+band band band...
+.B ]
+
+.B tc class ... ets [ quantum
+bytes
+.B ]
+
+.SH DESCRIPTION
+
+The Enhanced Transmission Selection scheduler is a classful queuing
+discipline that merges the functionality of the PRIO and DRR qdiscs in one
+scheduler. ETS makes it easy to configure a set of strict and
+bandwidth-sharing bands to implement the transmission selection described
+in 802.1Qaz.
+
+On creation with 'tc qdisc add', a fixed number of bands is created. Each
+band is a class, although it is not possible to directly add and remove
+bands with 'tc class' commands. The number of bands to be created must
+instead be specified on the command line as the qdisc is added.
+
+The minor number of classid to use when referring to a band is the band
+number increased by one. Thus band 0 will have classid of major:1, band 1
+that of major:2, etc.
+
+ETS bands are of two types: some number may be in strict mode, the
+remaining ones are in bandwidth-sharing mode.
+
+.SH ALGORITHM
+When dequeueing, strict bands are tried first, if there are any. Band 0 is
+tried first. If it did not deliver a packet, band 1 is tried next, and so
+on until one of the bands delivers a packet, or the strict bands are
+exhausted.
+
+If no packet has been dequeued from any of the strict bands, if there are
+any bandwidth-sharing bands, the dequeing proceeds according to the DRR
+algorithm. Each bandwidth-sharing band is assigned a deficit counter,
+initialized to quantum assigned by a
+.B quanta
+element. ETS maintains an (internal) ''active'' list of bandwidth-sharing
+bands whose qdiscs are non-empty. This list is used for dequeuing. A packe=
t
+is dequeued from the band at the head of the list if the packet size is
+smaller or equal to the deficit counter. If the counter is too small, it i=
s
+increased by
+.B quantum
+and the scheduler moves on to the next band in the active list.
+
+Only qdiscs that own their queue should be added below the
+bandwidth-sharing bands. Attaching to them non-work-conserving qdiscs like
+TBF does not make sense \-\- other qdiscs in the active list will also
+become inactive until the dequeue operation succeeds. This limitation does
+not exist with the strict bands.
+
+.SH CLASSIFICATION
+The ETS qdisc allows three ways to decide which band to enqueue a packet
+to:
+
+- Packet priority can be directly set to a class handle, in which case tha=
t
+  is the queue where the packet will be put. For example, band number 2 of
+  a qdisc with handle of 11: will have classid 11:3. To mark a packet for
+  queuing to this band, the packet priority should be set to 0x110003.
+
+- A tc filter attached to the qdisc can put the packet to a band by using
+  the \fBflowid\fR keyword.
+
+- As a last resort, the ETS qdisc consults its priomap (see below), which
+  maps packets to bands based on packet priority.
+
+.SH PARAMETERS
+.TP
+strict
+The number of bands that should be created in strict mode. If not given,
+this value is 0.
+
+.TP
+quanta
+Each bandwidth-sharing band needs to know its quantum, which is the amount
+of bytes a flow is allowed to dequeue before the scheduler moves to the
+next bandwidth-sharing band. The
+.B quanta
+argument lists quanta for the individual bandwidth-sharing bands.
+The minimum value of each quantum is 1.
+
+.TP
+bands
+Number of bands given explicitly. This value has to be at least large
+enough to cover the strict bands specified through the
+.B strict
+keyword and bandwidth-sharing bands specified in
+.B quanta.
+If a larger value is given, any extra bands are in bandwidth-sharing mode,
+and their quanta are deduced from the interface MTU.
+
+.TP
+priomap
+The priomap maps the priority of a packet to a band. The argument is a lis=
t
+of numbers. The first number indicates which band the packets with priorit=
y
+0 should be put to, the second is for priority 1, and so on.
+
+.SH EXAMPLE & USAGE
+
+.P
+Add a qdisc with 8 bandwidth-sharing bands, using the interface MTU as
+their quanta. Since all quanta are the same, this will lead to equal
+distribution of bandwidth between the bands, each will get about 12.5% of
+the link. The low 8 priorities go to individual bands in a 1:1 fashion:
+
+.P
+# tc qdisc add dev eth0 root handle 1: ets bands 8 priomap 7 6 5 4 3 2 1 0
+.br
+# tc qdisc show dev eth0
+.br
+qdisc ets 1: root refcnt 2 bands 8 quanta 1514 1514 1514 1514 1514 1514 15=
14 1514 priomap 7 6 5 4 3 2 1 0 0 0 0 0 0 0 0 0
+
+.P
+Tweak the first band of the above qdisc to give it a quantum of 2650, whic=
h
+will give it about 20% of the link (and about 11.5% to the remaining
+bands):
+
+.P
+# tc class change dev eth0 classid 1:1 ets quantum 2650
+.br
+# tc qdisc show dev eth0
+.br
+qdisc ets 1: root refcnt 2 bands 8 quanta 2650 1514 1514 1514 1514 1514 15=
14 1514 priomap 7 6 5 4 3 2 1 0 0 0 0 0 0 0 0 0
+
+.P
+Create a purely strict Qdisc with 1:1 mapping between priorities and TCs:
+
+.P
+# tc qdisc add dev eth0 root handle 1: ets strict 8 priomap 7 6 5 4 3 2 1 =
0
+.br
+# tc qdisc sh dev eth0
+.br
+qdisc ets 1: root refcnt 2 bands 8 strict 8 priomap 7 6 5 4 3 2 1 0 0 0 0 =
0 0 0 0 0
+
+.P
+Add a Qdisc with 6 bands, 3 strict and 3 ETS with 35%-30%-25% weights:
+.P
+# tc qdisc add dev eth0 root handle 1: ets strict 3 quanta 3500 3000 2500 =
priomap 0 1 1 1 2 3 4 5
+.br
+# tc qdisc sh dev eth0
+.br
+qdisc ets 1: root refcnt 2 bands 6 strict 3 quanta 3500 3000 2500 priomap =
0 1 1 1 2 3 4 5 0 0 0 0 0 0 0 0
+
+.SH SEE ALSO
+.BR tc (8),
+.BR tc-prio (8),
+.BR tc-drr (8)
+
+.SH AUTHOR
+Parts of both this manual page and the code itself are taken from PRIO and
+DRR qdiscs.
+.br
+ETS qdisc itself was written by Petr Machata.
diff --git a/man/man8/tc.8 b/man/man8/tc.8
index b81a396f..c4564a06 100644
--- a/man/man8/tc.8
+++ b/man/man8/tc.8
@@ -843,6 +843,7 @@ was written by Alexey N. Kuznetsov and added in Linux 2=
.2.
 .BR tc-codel (8),
 .BR tc-drr (8),
 .BR tc-ematch (8),
+.BR tc-ets (8),
 .BR tc-flow (8),
 .BR tc-flower (8),
 .BR tc-fq (8),
diff --git a/tc/Makefile b/tc/Makefile
index 14171a28..bea5550f 100644
--- a/tc/Makefile
+++ b/tc/Makefile
@@ -79,6 +79,7 @@ TCMODULES +=3D q_cbs.o
 TCMODULES +=3D q_etf.o
 TCMODULES +=3D q_taprio.o
 TCMODULES +=3D q_plug.o
+TCMODULES +=3D q_ets.o
=20
 TCSO :=3D
 ifeq ($(TC_CONFIG_ATM),y)
diff --git a/tc/q_ets.c b/tc/q_ets.c
new file mode 100644
index 00000000..c7b12183
--- /dev/null
+++ b/tc/q_ets.c
@@ -0,0 +1,338 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+
+/*
+ * Enhanced Transmission Selection - 802.1Qaz-based Qdisc
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <sys/socket.h>
+#include <netinet/in.h>
+#include <arpa/inet.h>
+#include <string.h>
+
+#include "utils.h"
+#include "tc_util.h"
+
+static void explain(void)
+{
+	fprintf(stderr, "Usage: ... ets [bands NUMBER] [strict NUMBER] [quanta Q1=
 Q2...] [priomap P1 P2...]\n");
+}
+
+static void cexplain(void)
+{
+	fprintf(stderr, "Usage: ... ets [quantum Q1]\n");
+}
+
+static unsigned int parse_quantum(const char *arg)
+{
+	unsigned int quantum;
+
+	if (get_unsigned(&quantum, arg, 10)) {
+		fprintf(stderr, "Illegal \"quanta\" element\n");
+		return 0;
+	}
+	if (!quantum)
+		fprintf(stderr, "\"quanta\" must be > 0\n");
+	return quantum;
+}
+
+static int parse_nbands(const char *arg, __u8 *pnbands, const char *what)
+{
+	unsigned int tmp;
+
+	if (*pnbands) {
+		fprintf(stderr, "Duplicate \"%s\"\n", what);
+		return -1;
+	}
+	if (get_unsigned(&tmp, arg, 10)) {
+		fprintf(stderr, "Illegal \"%s\"\n", what);
+		return -1;
+	}
+	if (tmp > ETS_MAX_BANDS) {
+		fprintf(stderr, "The value of \"%s\" must be <=3D %d\n",
+			what, ETS_MAX_BANDS);
+		return -1;
+	}
+
+	*pnbands =3D tmp;
+	return 0;
+}
+
+static int ets_parse_opt(struct qdisc_util *qu, int argc, char **argv,
+			 struct nlmsghdr *n, const char *dev)
+{
+	__u8 nbands =3D 0;
+	__u8 nstrict =3D 0;
+	bool quanta_mode =3D false;
+	unsigned int nquanta =3D 0;
+	__u32 quanta[ETS_MAX_BANDS] =3D {0};
+	bool priomap_mode =3D false;
+	unsigned int nprio =3D 0;
+	__u8 priomap[TC_PRIO_MAX + 1] =3D {0};
+	unsigned int tmp;
+	struct rtattr *tail, *nest;
+
+	while (argc > 0) {
+		if (strcmp(*argv, "bands") =3D=3D 0) {
+			NEXT_ARG();
+			if (parse_nbands(*argv, &nbands, "bands"))
+				return -1;
+			priomap_mode =3D quanta_mode =3D false;
+		} else if (strcmp(*argv, "strict") =3D=3D 0) {
+			NEXT_ARG();
+			if (parse_nbands(*argv, &nstrict, "strict"))
+				return -1;
+			priomap_mode =3D quanta_mode =3D false;
+		} else if (strcmp(*argv, "quanta") =3D=3D 0) {
+			if (nquanta) {
+				fprintf(stderr, "Duplicate \"quanta\"\n");
+				return -1;
+			}
+			NEXT_ARG();
+			priomap_mode =3D false;
+			quanta_mode =3D true;
+			goto parse_quantum;
+		} else if (strcmp(*argv, "priomap") =3D=3D 0) {
+			if (nprio) {
+				fprintf(stderr, "Duplicate \"priomap\"\n");
+				return -1;
+			}
+			NEXT_ARG();
+			priomap_mode =3D true;
+			quanta_mode =3D false;
+			goto parse_priomap;
+		} else if (strcmp(*argv, "help") =3D=3D 0) {
+			explain();
+			return -1;
+		} else if (quanta_mode) {
+			unsigned int quantum;
+
+parse_quantum:
+			quantum =3D parse_quantum(*argv);
+			if (!quantum)
+				return -1;
+			quanta[nquanta++] =3D quantum;
+		} else if (priomap_mode) {
+			unsigned int band;
+
+parse_priomap:
+			if (get_unsigned(&band, *argv, 10)) {
+				fprintf(stderr, "Illegal \"priomap\" element\n");
+				return -1;
+			}
+			if (nprio > TC_PRIO_MAX) {
+				fprintf(stderr, "\"priomap\" index > TC_PRIO_MAX=3D%u\n", TC_PRIO_MAX)=
;
+				return -1;
+			}
+			priomap[nprio++] =3D band;
+		} else {
+			fprintf(stderr, "What is \"%s\"?\n", *argv);
+			explain();
+			return -1;
+		}
+		argc--; argv++;
+	}
+
+	if (!nbands)
+		nbands =3D nquanta + nstrict;
+	if (!nbands) {
+		fprintf(stderr, "One of \"bands\", \"quanta\" or \"strict\" needs to be =
specified\n");
+		explain();
+		return -1;
+	}
+	if (nbands < 1) {
+		fprintf(stderr, "The value of \"bands\" must be >=3D 1\n");
+		explain();
+		return -1;
+	}
+	if (nstrict + nquanta > nbands) {
+		fprintf(stderr, "Not enough total bands to cover all the strict bands an=
d quanta.\n");
+		explain();
+		return -1;
+	}
+	for (tmp =3D 0; tmp < nprio; tmp++) {
+		if (priomap[tmp] >=3D nbands) {
+			fprintf(stderr, "\"priomap\" element is out of bounds\n");
+			return -1;
+		}
+	}
+
+	tail =3D addattr_nest(n, 1024, TCA_OPTIONS | NLA_F_NESTED);
+	addattr_l(n, 1024, TCA_ETS_BANDS, &nbands, sizeof(nbands));
+	if (nstrict)
+		addattr_l(n, 1024, TCA_ETS_STRICT, &nstrict, sizeof(nstrict));
+	if (nquanta) {
+		nest =3D addattr_nest(n, 1024, TCA_ETS_QUANTA | NLA_F_NESTED);
+		for (tmp =3D 0; tmp < nquanta; tmp++)
+			addattr_l(n, 1024, TCA_ETS_BAND_QUANTUM,
+				  &quanta[tmp], sizeof(quanta[0]));
+		addattr_nest_end(n, nest);
+	}
+	if (nprio) {
+		nest =3D addattr_nest(n, 1024, TCA_ETS_PRIOMAP | NLA_F_NESTED);
+		for (tmp =3D 0; tmp < nprio; tmp++)
+			addattr_l(n, 1024, TCA_ETS_PMAP_BAND,
+				  &priomap[tmp], sizeof(priomap[0]));
+		addattr_nest_end(n, nest);
+	}
+	addattr_nest_end(n, tail);
+
+	return 0;
+}
+
+static int ets_parse_copt(struct qdisc_util *qu, int argc, char **argv,
+			  struct nlmsghdr *n, const char *dev)
+{
+	unsigned int quantum =3D 0;
+	struct rtattr *tail;
+
+	while (argc > 0) {
+		if (strcmp(*argv, "quantum") =3D=3D 0) {
+			if (quantum) {
+				fprintf(stderr, "Duplicate \"quanta\"\n");
+				return -1;
+			}
+			NEXT_ARG();
+			quantum =3D parse_quantum(*argv);
+			if (!quantum)
+				return -1;
+		} else if (strcmp(*argv, "help") =3D=3D 0) {
+			cexplain();
+			return -1;
+		} else {
+			fprintf(stderr, "What is \"%s\"?\n", *argv);
+			cexplain();
+			return -1;
+		}
+		argc--; argv++;
+	}
+
+	tail =3D addattr_nest(n, 1024, TCA_OPTIONS | NLA_F_NESTED);
+	if (quantum)
+		addattr_l(n, 1024, TCA_ETS_BAND_QUANTUM, &quantum,
+			  sizeof(quantum));
+	addattr_nest_end(n, tail);
+
+	return 0;
+}
+
+static int ets_print_opt_quanta(struct rtattr *opt)
+{
+	int len =3D RTA_PAYLOAD(opt);
+	unsigned int offset;
+
+	open_json_array(PRINT_ANY, "quanta");
+	for (offset =3D 0; offset < len; ) {
+		struct rtattr *tb[TCA_ETS_BAND_MAX + 1] =3D {NULL};
+		struct rtattr *attr;
+		__u32 quantum;
+
+		attr =3D RTA_DATA(opt) + offset;
+		parse_rtattr(tb, TCA_ETS_BAND_MAX, attr, len - offset);
+		offset +=3D RTA_LENGTH(RTA_PAYLOAD(attr));
+
+		if (!tb[TCA_ETS_BAND_QUANTUM]) {
+			fprintf(stderr, "ERROR: No ETS band quantum\n");
+			return -1;
+		}
+
+		quantum =3D rta_getattr_u32(tb[TCA_ETS_BAND_QUANTUM]);
+		print_uint(PRINT_ANY, NULL, " %u", quantum);
+
+	}
+	close_json_array(PRINT_ANY, " ");
+
+	return 0;
+}
+
+static int ets_print_opt_priomap(struct rtattr *opt)
+{
+	int len =3D RTA_PAYLOAD(opt);
+	unsigned int offset;
+
+	open_json_array(PRINT_ANY, "priomap");
+	for (offset =3D 0; offset < len; ) {
+		struct rtattr *tb[TCA_ETS_PMAP_MAX + 1] =3D {NULL};
+		struct rtattr *attr;
+		__u8 band;
+
+		attr =3D RTA_DATA(opt) + offset;
+		parse_rtattr(tb, TCA_ETS_PMAP_MAX, attr, len - offset);
+		offset +=3D RTA_LENGTH(RTA_PAYLOAD(attr)) + 3 /*padding*/;
+
+		if (!tb[TCA_ETS_PMAP_BAND]) {
+			fprintf(stderr, "ERROR: No ETS priomap band\n");
+			return -1;
+		}
+
+		band =3D rta_getattr_u8(tb[TCA_ETS_PMAP_BAND]);
+		print_uint(PRINT_ANY, NULL, " %u", band);
+
+	}
+	close_json_array(PRINT_ANY, " ");
+
+	return 0;
+}
+
+static int ets_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *op=
t)
+{
+	struct rtattr *tb[TCA_ETS_MAX + 1];
+	__u8 nbands;
+	__u8 nstrict;
+	int err;
+
+	if (opt =3D=3D NULL)
+		return 0;
+
+	parse_rtattr_nested(tb, TCA_ETS_MAX, opt);
+
+	if (!tb[TCA_ETS_BANDS] || !tb[TCA_ETS_PRIOMAP]) {
+		fprintf(stderr, "ERROR: Incomplete ETS options\n");
+		return -1;
+	}
+
+	nbands =3D rta_getattr_u8(tb[TCA_ETS_BANDS]);
+	print_uint(PRINT_ANY, "bands", "bands %u ", nbands);
+
+	if (tb[TCA_ETS_STRICT]) {
+		nstrict =3D rta_getattr_u8(tb[TCA_ETS_STRICT]);
+		print_uint(PRINT_ANY, "strict", "strict %u ", nstrict);
+	}
+
+	if (tb[TCA_ETS_QUANTA]) {
+		err =3D ets_print_opt_quanta(tb[TCA_ETS_QUANTA]);
+		if (err)
+			return err;
+	}
+
+	return ets_print_opt_priomap(tb[TCA_ETS_PRIOMAP]);
+}
+
+static int ets_print_copt(struct qdisc_util *qu, FILE *f, struct rtattr *o=
pt)
+{
+	struct rtattr *tb[TCA_ETS_BAND_MAX + 1];
+	__u32 quantum;
+
+	if (opt =3D=3D NULL)
+		return 0;
+
+	parse_rtattr_nested(tb, TCA_ETS_BAND_MAX, opt);
+
+	if (tb[TCA_ETS_BAND_QUANTUM]) {
+		quantum =3D rta_getattr_u32(tb[TCA_ETS_BAND_QUANTUM]);
+		print_uint(PRINT_ANY, "quantum", "quantum %u ", quantum);
+	}
+
+	return 0;
+}
+
+struct qdisc_util ets_qdisc_util =3D {
+	.id		=3D "ets",
+	.parse_qopt	=3D ets_parse_opt,
+	.parse_copt	=3D ets_parse_copt,
+	.print_qopt	=3D ets_print_opt,
+	.print_copt	=3D ets_print_copt,
+};
--=20
2.20.1

