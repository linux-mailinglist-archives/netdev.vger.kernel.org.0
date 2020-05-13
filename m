Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 714951D1F1F
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390665AbgEMT0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:26:47 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58512 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390662AbgEMT0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 15:26:47 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04DJN4p0025673
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 12:26:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Vt6b4IsgaUijrPwec5yIarlKP77zjjmjFSSaoMLmR54=;
 b=qZ+JySzgoxKTlZKlysvkM7wdNorDGoenc0KYh/I7SlCSRRd2D/fjoJxGpYXtpgEAJc8O
 xWKZZVa2uIRC83hy9jyNan2UwUildOGA3HuMlomkcTCVDDMWTPR/kctipDx6WK6NnQlh
 Z3MLwqZfrzr0R0c+qIQRvp/YJ9DJeoFNvBw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3100x26twf-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 12:26:44 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 13 May 2020 12:26:10 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 20F702EC3007; Wed, 13 May 2020 12:26:05 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/6] tools/memory-model: add BPF ringbuf MPSC litmus tests
Date:   Wed, 13 May 2020 12:25:28 -0700
Message-ID: <20200513192532.4058934-3-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200513192532.4058934-1-andriin@fb.com>
References: <20200513192532.4058934-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-13_09:2020-05-13,2020-05-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 spamscore=0
 clxscore=1015 priorityscore=1501 suspectscore=8 phishscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=338 cotscore=-2147483648
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005130166
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add 4 litmus tests for BPF ringbuf implementation, divided into two diffe=
rent
use cases.

First, two unbounded case, one with 1 producer and another with
2 producers, single consumer. All reservations are supposed to succeed.

Second, bounded case with only 1 record allowed in ring buffer at any giv=
en
time. Here failures to reserve space are expected. Again, 1- and 2- produ=
cer
cases, single consumer, are validated.

Just for the fun of it, I also wrote a 3-producer cases, it took *16 hour=
s* to
validate, but came back successful as well. I'm not including it in this
patch, because it's not practical to run it. See output for all included
4 cases and one 3-producer one with bounded use case.

Each litmust test implements producer/consumer protocol for BPF ring buff=
er
implementation found in kernel/bpf/ringbuf.c. Due to limitations, all rec=
ords
are assumed equal-sized and producer/consumer counters are incremented by=
 1.
This doesn't change the correctness of the algorithm, though.

Verification results:

$ herd7 -unroll 0 -conf linux-kernel.cfg mpsc-rb+1p1c+bounded.litmus
Test mpsc-rb+1p1c+bounded Allowed
States 2
0:rFail=3D0; 1:rFail=3D0; cx=3D0; dropped=3D0; len1=3D1; px=3D1;
0:rFail=3D0; 1:rFail=3D0; cx=3D1; dropped=3D0; len1=3D1; px=3D1;
Ok
Witnesses
Positive: 3 Negative: 0
Condition exists (0:rFail=3D0 /\ 1:rFail=3D0 /\ dropped=3D0 /\ px=3D1 /\ =
len1=3D1 /\ (cx=3D0 \/ cx=3D1))
Observation mpsc-rb+1p1c+bounded Always 3 0
Time mpsc-rb+1p1c+bounded 0.03
Hash=3D554e6af9bfde3d1bfbb2c07bb0e283ad

$ herd7 -unroll 0 -conf linux-kernel.cfg mpsc-rb+2p1c+bounded.litmus
Test mpsc-rb+2p1c+bounded Allowed
States 4
0:rFail=3D0; 1:rFail=3D0; 2:rFail=3D0; cx=3D0; dropped=3D1; len1=3D1; px=3D=
1;
0:rFail=3D0; 1:rFail=3D0; 2:rFail=3D0; cx=3D1; dropped=3D0; len1=3D1; px=3D=
2;
0:rFail=3D0; 1:rFail=3D0; 2:rFail=3D0; cx=3D1; dropped=3D1; len1=3D1; px=3D=
1;
0:rFail=3D0; 1:rFail=3D0; 2:rFail=3D0; cx=3D2; dropped=3D0; len1=3D1; px=3D=
2;
Ok
Witnesses
Positive: 40 Negative: 0
Condition exists (0:rFail=3D0 /\ 1:rFail=3D0 /\ 2:rFail=3D0 /\ len1=3D1 /=
\ (dropped=3D0 /\ px=3D2 /\ (cx=3D1 \/ cx=3D2) \/ dropped=3D1 /\ px=3D1 /=
\ (cx=3D0 \/ cx=3D1)))
Observation mpsc-rb+2p1c+bounded Always 40 0
Time mpsc-rb+2p1c+bounded 114.32
Hash=3Dfa7c38edbf482a6605d6b2031c310bdc

$ herd7 -unroll 0 -conf linux-kernel.cfg mpsc-rb+1p1c+unbound.litmus
Test mpsc-rb+1p1c+unbound Allowed
States 2
0:rFail=3D0; 1:rFail=3D0; cx=3D0; len1=3D1; px=3D1;
0:rFail=3D0; 1:rFail=3D0; cx=3D1; len1=3D1; px=3D1;
Ok
Witnesses
Positive: 4 Negative: 0
Condition exists (0:rFail=3D0 /\ 1:rFail=3D0 /\ px=3D1 /\ len1=3D1 /\ (cx=
=3D0 \/ cx=3D1))
Observation mpsc-rb+1p1c+unbound Always 4 0
Time mpsc-rb+1p1c+unbound 0.02
Hash=3D0798c82c96356e6eb25edbcd8561dfcf

$ herd7 -unroll 0 -conf linux-kernel.cfg mpsc-rb+2p1c+unbound.litmus
Test mpsc-rb+2p1c+unbound Allowed
States 3
0:rFail=3D0; 1:rFail=3D0; 2:rFail=3D0; cx=3D0; len1=3D1; len2=3D1; px=3D2=
;
0:rFail=3D0; 1:rFail=3D0; 2:rFail=3D0; cx=3D1; len1=3D1; len2=3D1; px=3D2=
;
0:rFail=3D0; 1:rFail=3D0; 2:rFail=3D0; cx=3D2; len1=3D1; len2=3D1; px=3D2=
;
Ok
Witnesses
Positive: 78 Negative: 0
Condition exists (0:rFail=3D0 /\ 1:rFail=3D0 /\ 2:rFail=3D0 /\ px=3D2 /\ =
len1=3D1 /\ len2=3D1 /\ (cx=3D0 \/ cx=3D1 \/ cx=3D2))
Observation mpsc-rb+2p1c+unbound Always 78 0
Time mpsc-rb+2p1c+unbound 37.85
Hash=3Da1a73c1810ff3eb91f0d054f232399a1

$ herd7 -unroll 0 -conf linux-kernel.cfg mpsc-rb+3p1c+bounded.litmus
Test mpsc+ringbuf-spinlock Allowed
States 5
0:rFail=3D0; 1:rFail=3D0; 2:rFail=3D0; 3:rFail=3D0; cx=3D0; len1=3D1; len=
2=3D1; px=3D2;
0:rFail=3D0; 1:rFail=3D0; 2:rFail=3D0; 3:rFail=3D0; cx=3D1; len1=3D1; len=
2=3D1; px=3D2;
0:rFail=3D0; 1:rFail=3D0; 2:rFail=3D0; 3:rFail=3D0; cx=3D1; len1=3D1; len=
2=3D1; px=3D3;
0:rFail=3D0; 1:rFail=3D0; 2:rFail=3D0; 3:rFail=3D0; cx=3D2; len1=3D1; len=
2=3D1; px=3D2;
0:rFail=3D0; 1:rFail=3D0; 2:rFail=3D0; 3:rFail=3D0; cx=3D2; len1=3D1; len=
2=3D1; px=3D3;
Ok
Witnesses
Positive: 558 Negative: 0
Condition exists (0:rFail=3D0 /\ 1:rFail=3D0 /\ 2:rFail=3D0 /\ 3:rFail=3D=
0 /\ len1=3D1 /\ len2=3D1 /\ (px=3D2 /\ (cx=3D0 \/ cx=3D1 \/ cx=3D2) \/ p=
x=3D3 /\ (cx=3D1 \/ cx=3D2)))
Observation mpsc+ringbuf-spinlock Always 558 0
Time mpsc+ringbuf-spinlock 57487.24
Hash=3D133977dba930d167b4e1b4a6923d5687

Cc: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../litmus-tests/mpsc-rb+1p1c+bounded.litmus  |  92 +++++++++++
 .../litmus-tests/mpsc-rb+1p1c+unbound.litmus  |  83 ++++++++++
 .../litmus-tests/mpsc-rb+2p1c+bounded.litmus  | 152 ++++++++++++++++++
 .../litmus-tests/mpsc-rb+2p1c+unbound.litmus  | 137 ++++++++++++++++
 4 files changed, 464 insertions(+)
 create mode 100644 tools/memory-model/litmus-tests/mpsc-rb+1p1c+bounded.=
litmus
 create mode 100644 tools/memory-model/litmus-tests/mpsc-rb+1p1c+unbound.=
litmus
 create mode 100644 tools/memory-model/litmus-tests/mpsc-rb+2p1c+bounded.=
litmus
 create mode 100644 tools/memory-model/litmus-tests/mpsc-rb+2p1c+unbound.=
litmus

diff --git a/tools/memory-model/litmus-tests/mpsc-rb+1p1c+bounded.litmus =
b/tools/memory-model/litmus-tests/mpsc-rb+1p1c+bounded.litmus
new file mode 100644
index 000000000000..c97b2e1b56f6
--- /dev/null
+++ b/tools/memory-model/litmus-tests/mpsc-rb+1p1c+bounded.litmus
@@ -0,0 +1,92 @@
+C mpsc-rb+1p1c+bounded
+
+(*
+ * Result: Always
+ *
+ * This litmus test validates BPF ring buffer implementation under the
+ * following assumptions:
+ * - 1 producer;
+ * - 1 consumer;
+ * - ring buffer has capacity for only 1 record.
+ *
+ * Expectations:
+ * - 1 record pushed into ring buffer;
+ * - 0 or 1 element is consumed.
+ * - no failures.
+ *)
+
+{
+	max_len =3D 1;
+	len1 =3D 0;
+	px =3D 0;
+	cx =3D 0;
+	dropped =3D 0;
+}
+
+P0(int *len1, int *cx, int *px)
+{
+	int *rLenPtr;
+	int rLen;
+	int rPx;
+	int rCx;
+	int rFail;
+
+	rFail =3D 0;
+	rCx =3D READ_ONCE(*cx);
+
+	rPx =3D smp_load_acquire(px);
+	if (rCx < rPx) {
+		if (rCx =3D=3D 0)
+			rLenPtr =3D len1;
+		else
+			rFail =3D 1;
+
+		rLen =3D READ_ONCE(*rLenPtr);
+		if (rLen =3D=3D 0) {
+			rFail =3D 1;
+		} else if (rLen =3D=3D 1) {
+			rCx =3D rCx + 1;
+			WRITE_ONCE(*cx, rCx);
+		}
+	}
+}
+
+P1(int *len1, spinlock_t *rb_lock, int *px, int *cx, int *dropped, int *=
max_len)
+{
+	int rPx;
+	int rCx;
+	int rFail;
+	int *rLenPtr;
+
+	rFail =3D 0;
+	rCx =3D READ_ONCE(*cx);
+
+	spin_lock(rb_lock);
+
+	rPx =3D *px;
+	if (rPx - rCx >=3D *max_len) {
+		atomic_inc(dropped);
+		spin_unlock(rb_lock);
+	} else {
+		if (rPx =3D=3D 0)
+			rLenPtr =3D len1;
+		else
+			rFail =3D 1;
+
+		WRITE_ONCE(*rLenPtr, -1);
+		smp_wmb();
+		WRITE_ONCE(*px, rPx + 1);
+
+		spin_unlock(rb_lock);
+
+		WRITE_ONCE(*rLenPtr, 1);
+	}
+}
+
+exists (
+	0:rFail=3D0 /\ 1:rFail=3D0
+	/\
+	(
+		(dropped=3D0 /\ px=3D1 /\ len1=3D1 /\ (cx=3D0 \/ cx=3D1))
+	)
+)
diff --git a/tools/memory-model/litmus-tests/mpsc-rb+1p1c+unbound.litmus =
b/tools/memory-model/litmus-tests/mpsc-rb+1p1c+unbound.litmus
new file mode 100644
index 000000000000..b1e25ec6275e
--- /dev/null
+++ b/tools/memory-model/litmus-tests/mpsc-rb+1p1c+unbound.litmus
@@ -0,0 +1,83 @@
+C mpsc-rb+1p1c+unbound
+
+(*
+ * Result: Always
+ *
+ * This litmus test validates BPF ring buffer implementation under the
+ * following assumptions:
+ * - 1 producer;
+ * - 1 consumer;
+ * - ring buffer capacity is unbounded.
+ *
+ * Expectations:
+ * - 1 record pushed into ring buffer;
+ * - 0 or 1 element is consumed.
+ * - no failures.
+ *)
+
+{
+	len1 =3D 0;
+	px =3D 0;
+	cx =3D 0;
+}
+
+P0(int *len1, int *cx, int *px)
+{
+	int *rLenPtr;
+	int rLen;
+	int rPx;
+	int rCx;
+	int rFail;
+
+	rFail =3D 0;
+	rCx =3D READ_ONCE(*cx);
+
+	rPx =3D smp_load_acquire(px);
+	if (rCx < rPx) {
+		if (rCx =3D=3D 0)
+			rLenPtr =3D len1;
+		else
+			rFail =3D 1;
+
+		rLen =3D READ_ONCE(*rLenPtr);
+		if (rLen =3D=3D 0) {
+			rFail =3D 1;
+		} else if (rLen =3D=3D 1) {
+			rCx =3D rCx + 1;
+			WRITE_ONCE(*cx, rCx);
+		}
+	}
+}
+
+P1(int *len1, spinlock_t *rb_lock, int *px, int *cx)
+{
+	int rPx;
+	int rCx;
+	int rFail;
+	int *rLenPtr;
+
+	rFail =3D 0;
+	rCx =3D READ_ONCE(*cx);
+
+	spin_lock(rb_lock);
+
+	rPx =3D *px;
+	if (rPx =3D=3D 0)
+		rLenPtr =3D len1;
+	else
+		rFail =3D 1;
+
+	WRITE_ONCE(*rLenPtr, -1);
+	smp_wmb();
+	WRITE_ONCE(*px, rPx + 1);
+
+	spin_unlock(rb_lock);
+
+	WRITE_ONCE(*rLenPtr, 1);
+}
+
+exists (
+	0:rFail=3D0 /\ 1:rFail=3D0
+	/\ px=3D1 /\ len1=3D1
+	/\ (cx=3D0 \/ cx=3D1)
+)
diff --git a/tools/memory-model/litmus-tests/mpsc-rb+2p1c+bounded.litmus =
b/tools/memory-model/litmus-tests/mpsc-rb+2p1c+bounded.litmus
new file mode 100644
index 000000000000..0707aa9ad307
--- /dev/null
+++ b/tools/memory-model/litmus-tests/mpsc-rb+2p1c+bounded.litmus
@@ -0,0 +1,152 @@
+C mpsc-rb+2p1c+bounded
+
+(*
+ * Result: Always
+ *
+ * This litmus test validates BPF ring buffer implementation under the
+ * following assumptions:
+ * - 2 identical producers;
+ * - 1 consumer;
+ * - ring buffer has capacity for only 1 record.
+ *
+ * Expectations:
+ * - either 1 or 2 records are pushed into ring buffer;
+ * - 0, 1, or 2 elements are consumed by consumer;
+ * - appropriate number of dropped records is recorded to satisfy ring b=
uffer
+ *   size bounds;
+ * - no failures.
+ *)
+
+{
+	max_len =3D 1;
+	len1 =3D 0;
+	px =3D 0;
+	cx =3D 0;
+	dropped =3D 0;
+}
+
+P0(int *len1, int *cx, int *px)
+{
+	int *rLenPtr;
+	int rLen;
+	int rPx;
+	int rCx;
+	int rFail;
+
+	rFail =3D 0;
+	rCx =3D READ_ONCE(*cx);
+
+	rPx =3D smp_load_acquire(px);
+	if (rCx < rPx) {
+		if (rCx =3D=3D 0)
+			rLenPtr =3D len1;
+		else if (rCx =3D=3D 1)
+			rLenPtr =3D len1;
+		else
+			rFail =3D 1;
+
+		rLen =3D READ_ONCE(*rLenPtr);
+		if (rLen =3D=3D 0) {
+			rFail =3D 1;
+		} else if (rLen =3D=3D 1) {
+			rCx =3D rCx + 1;
+			WRITE_ONCE(*cx, rCx);
+		}
+	}
+
+	rPx =3D smp_load_acquire(px);
+	if (rCx < rPx) {
+		if (rCx =3D=3D 0)
+			rLenPtr =3D len1;
+		else if (rCx =3D=3D 1)
+			rLenPtr =3D len1;
+		else
+			rFail =3D 1;
+
+		rLen =3D READ_ONCE(*rLenPtr);
+		if (rLen =3D=3D 0) {
+			rFail =3D 1;
+		} else if (rLen =3D=3D 1) {
+			rCx =3D rCx + 1;
+			WRITE_ONCE(*cx, rCx);
+		}
+	}
+}
+
+P1(int *len1, spinlock_t *rb_lock, int *px, int *cx, int *dropped, int *=
max_len)
+{
+	int rPx;
+	int rCx;
+	int rFail;
+	int *rLenPtr;
+
+	rFail =3D 0;
+	rCx =3D READ_ONCE(*cx);
+
+	spin_lock(rb_lock);
+
+	rPx =3D *px;
+	if (rPx - rCx >=3D *max_len) {
+		atomic_inc(dropped);
+		spin_unlock(rb_lock);
+	} else {
+		if (rPx =3D=3D 0)
+			rLenPtr =3D len1;
+		else if (rPx =3D=3D 1)
+			rLenPtr =3D len1;
+		else
+			rFail =3D 1;
+
+		WRITE_ONCE(*rLenPtr, -1);
+		smp_wmb();
+		WRITE_ONCE(*px, rPx + 1);
+
+		spin_unlock(rb_lock);
+
+		WRITE_ONCE(*rLenPtr, 1);
+	}
+}
+
+P2(int *len1, spinlock_t *rb_lock, int *px, int *cx, int *dropped, int *=
max_len)
+{
+	int rPx;
+	int rCx;
+	int rFail;
+	int *rLenPtr;
+
+	rFail =3D 0;
+	rCx =3D READ_ONCE(*cx);
+
+	spin_lock(rb_lock);
+
+	rPx =3D *px;
+	if (rPx - rCx >=3D *max_len) {
+		atomic_inc(dropped);
+		spin_unlock(rb_lock);
+	} else {
+		if (rPx =3D=3D 0)
+			rLenPtr =3D len1;
+		else if (rPx =3D=3D 1)
+			rLenPtr =3D len1;
+		else
+			rFail =3D 1;
+
+		WRITE_ONCE(*rLenPtr, -1);
+		smp_wmb();
+		WRITE_ONCE(*px, rPx + 1);
+
+		spin_unlock(rb_lock);
+
+		WRITE_ONCE(*rLenPtr, 1);
+	}
+}
+
+exists (
+	0:rFail=3D0 /\ 1:rFail=3D0 /\ 2:rFail=3D0 /\ len1=3D1
+	/\
+	(
+		(dropped =3D 0 /\ px=3D2 /\ (cx=3D1 \/ cx=3D2))
+		\/
+		(dropped =3D 1 /\ px=3D1 /\ (cx=3D0 \/ cx=3D1))
+	)
+)
diff --git a/tools/memory-model/litmus-tests/mpsc-rb+2p1c+unbound.litmus =
b/tools/memory-model/litmus-tests/mpsc-rb+2p1c+unbound.litmus
new file mode 100644
index 000000000000..f334ffece324
--- /dev/null
+++ b/tools/memory-model/litmus-tests/mpsc-rb+2p1c+unbound.litmus
@@ -0,0 +1,137 @@
+C mpsc-rb+2p1c+unbound
+
+(*
+ * Result: Always
+ *
+ * This litmus test validates BPF ring buffer implementation under the
+ * following assumptions:
+ * - 2 identical producers;
+ * - 1 consumer;
+ * - ring buffer capacity is unbounded.
+ *
+ * Expectations:
+ * - 2 records pushed into ring buffer;
+ * - 0, 1, or 2 elements are consumed.
+ * - no failures.
+ *)
+
+{
+	len1 =3D 0;
+	len2 =3D 0;
+	px =3D 0;
+	cx =3D 0;
+}
+
+P0(int *len1, int *len2, int *cx, int *px)
+{
+	int *rLenPtr;
+	int rLen;
+	int rPx;
+	int rCx;
+	int rFail;
+
+	rFail =3D 0;
+	rCx =3D READ_ONCE(*cx);
+
+	rPx =3D smp_load_acquire(px);
+	if (rCx < rPx) {
+		if (rCx =3D=3D 0)
+			rLenPtr =3D len1;
+		else if (rCx =3D=3D 1)
+			rLenPtr =3D len2;
+		else
+			rFail =3D 1;
+
+		rLen =3D READ_ONCE(*rLenPtr);
+		if (rLen =3D=3D 0) {
+			rFail =3D 1;
+		} else if (rLen =3D=3D 1) {
+			rCx =3D rCx + 1;
+			WRITE_ONCE(*cx, rCx);
+		}
+	}
+
+	rPx =3D smp_load_acquire(px);
+	if (rCx < rPx) {
+		if (rCx =3D=3D 0)
+			rLenPtr =3D len1;
+		else if (rCx =3D=3D 1)
+			rLenPtr =3D len2;
+		else
+			rFail =3D 1;
+
+		rLen =3D READ_ONCE(*rLenPtr);
+		if (rLen =3D=3D 0) {
+			rFail =3D 1;
+		} else if (rLen =3D=3D 1) {
+			rCx =3D rCx + 1;
+			WRITE_ONCE(*cx, rCx);
+		}
+	}
+}
+
+P1(int *len1, int *len2, spinlock_t *rb_lock, int *px, int *cx)
+{
+	int rPx;
+	int rCx;
+	int rFail;
+	int *rLenPtr;
+
+	rFail =3D 0;
+	rCx =3D READ_ONCE(*cx);
+
+	spin_lock(rb_lock);
+
+	rPx =3D *px;
+	if (rPx =3D=3D 0)
+		rLenPtr =3D len1;
+	else if (rPx =3D=3D 1)
+		rLenPtr =3D len2;
+	else
+		rFail =3D 1;
+
+	WRITE_ONCE(*rLenPtr, -1);
+	smp_wmb();
+	WRITE_ONCE(*px, rPx + 1);
+
+	spin_unlock(rb_lock);
+
+	WRITE_ONCE(*rLenPtr, 1);
+}
+
+P2(int *len1, int *len2, spinlock_t *rb_lock, int *px, int *cx)
+{
+	int rPx;
+	int rCx;
+	int rFail;
+	int *rLenPtr;
+
+	rFail =3D 0;
+	rCx =3D READ_ONCE(*cx);
+
+	spin_lock(rb_lock);
+
+	rPx =3D *px;
+	if (rPx =3D=3D 0)
+		rLenPtr =3D len1;
+	else if (rPx =3D=3D 1)
+		rLenPtr =3D len2;
+	else
+		rFail =3D 1;
+
+	WRITE_ONCE(*rLenPtr, -1);
+	smp_wmb();
+	WRITE_ONCE(*px, rPx + 1);
+
+	spin_unlock(rb_lock);
+
+	WRITE_ONCE(*rLenPtr, 1);
+}
+
+exists (
+	0:rFail=3D0 /\ 1:rFail=3D0 /\ 2:rFail=3D0
+	/\
+	px=3D2 /\ len1=3D1 /\ len2=3D1
+	/\
+	(cx=3D0 \/ cx=3D1 \/ cx=3D2)
+)
--=20
2.24.1

