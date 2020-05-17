Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB6711D6CA4
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 21:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbgEQT5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 15:57:47 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17210 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726269AbgEQT5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 May 2020 15:57:46 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04HJtSMS020898
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 12:57:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=HisIGKAv4VrnMJx7LxmQhcH6r5aSNlVCdz642a7/snU=;
 b=ZGN3upZesJEg1pHFQ2+tB1eULEOu5b7hI7sViyLuSSNuV4bRYSlDsuoxU5z3F9gqiXb2
 VjtRZObJqvUW+09v1jywK5nf1l36/0mURxw5Tar2xSmAk0ANQ6pSRkW6HUunuEjuDEmF
 S/GLVjhJAI0wRyJvITvvPx8vaBVIN4nc3+k= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3130134eyx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 12:57:45 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sun, 17 May 2020 12:57:44 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 7B7FB2EC32DC; Sun, 17 May 2020 12:57:39 -0700 (PDT)
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
Subject: [PATCH v2 bpf-next 2/7] tools/memory-model: add BPF ringbuf MPSC litmus tests
Date:   Sun, 17 May 2020 12:57:22 -0700
Message-ID: <20200517195727.279322-3-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200517195727.279322-1-andriin@fb.com>
References: <20200517195727.279322-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-17_07:2020-05-15,2020-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 priorityscore=1501 suspectscore=8 lowpriorityscore=0 spamscore=0
 adultscore=0 clxscore=1015 impostorscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=387 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005170182
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
/* 1p1c bounded case */
$ herd7 -unroll 0 -conf linux-kernel.cfg litmus-tests/mpsc-rb+1p1c+bounde=
d.litmus
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
Hash=3D5bdad0f41557a641370e7fa6b8eb2f43

/* 2p1c bounded case */
$ herd7 -unroll 0 -conf linux-kernel.cfg litmus-tests/mpsc-rb+2p1c+bounde=
d.litmus
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
Positive: 22 Negative: 0
Condition exists (0:rFail=3D0 /\ 1:rFail=3D0 /\ 2:rFail=3D0 /\ len1=3D1 /=
\ (dropped=3D0 /\ px=3D2 /\ (cx=3D1 \/ cx=3D2) \/ dropped=3D1 /\ px=3D1 /=
\ (cx=3D0 \/ cx=3D1)))
Observation mpsc-rb+2p1c+bounded Always 22 0
Time mpsc-rb+2p1c+bounded 119.38
Hash=3De2f8f442a02bf7d8c2988ba82cf002d2

/* 1p1c unbounded case */
$ herd7 -unroll 0 -conf linux-kernel.cfg litmus-tests/mpsc-rb+1p1c+unboun=
d.litmus
Test mpsc-rb+1p1c+unbound Allowed
States 2
0:rFail=3D0; 1:rFail=3D0; cx=3D0; len1=3D1; px=3D1;
0:rFail=3D0; 1:rFail=3D0; cx=3D1; len1=3D1; px=3D1;
Ok
Witnesses
Positive: 3 Negative: 0
Condition exists (0:rFail=3D0 /\ 1:rFail=3D0 /\ px=3D1 /\ len1=3D1 /\ (cx=
=3D0 \/ cx=3D1))
Observation mpsc-rb+1p1c+unbound Always 3 0
Time mpsc-rb+1p1c+unbound 0.02
Hash=3Dbe9de6487d8e27c3d37802d122e4a87c

/* 2p1c unbounded case */
$ herd7 -unroll 0 -conf linux-kernel.cfg litmus-tests/mpsc-rb+2p1c+unboun=
d.litmus
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
Positive: 42 Negative: 0
Condition exists (0:rFail=3D0 /\ 1:rFail=3D0 /\ 2:rFail=3D0 /\ px=3D2 /\ =
len1=3D1 /\ len2=3D1 /\ (cx=3D0 \/ cx=3D1 \/ cx=3D2))
Observation mpsc-rb+2p1c+unbound Always 42 0
Time mpsc-rb+2p1c+unbound 39.19
Hash=3Df0352aba9bdc03dd0b1def7d0c4956fa

/* 3p1c bounded case */
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
index 000000000000..cafd17afe11e
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
+	rCx =3D smp_load_acquire(cx);
+
+	rPx =3D smp_load_acquire(px);
+	if (rCx < rPx) {
+		if (rCx =3D=3D 0)
+			rLenPtr =3D len1;
+		else
+			rFail =3D 1;
+
+		rLen =3D smp_load_acquire(rLenPtr);
+		if (rLen =3D=3D 0) {
+			rFail =3D 1;
+		} else if (rLen =3D=3D 1) {
+			rCx =3D rCx + 1;
+			smp_store_release(cx, rCx);
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
+	rCx =3D smp_load_acquire(cx);
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
+		*rLenPtr =3D -1;
+		smp_wmb();
+		smp_store_release(px, rPx + 1);
+
+		spin_unlock(rb_lock);
+
+		smp_store_release(rLenPtr, 1);
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
index 000000000000..84f660598015
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
+	rCx =3D smp_load_acquire(cx);
+
+	rPx =3D smp_load_acquire(px);
+	if (rCx < rPx) {
+		if (rCx =3D=3D 0)
+			rLenPtr =3D len1;
+		else
+			rFail =3D 1;
+
+		rLen =3D smp_load_acquire(rLenPtr);
+		if (rLen =3D=3D 0) {
+			rFail =3D 1;
+		} else if (rLen =3D=3D 1) {
+			rCx =3D rCx + 1;
+			smp_store_release(cx, rCx);
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
+	rCx =3D smp_load_acquire(cx);
+
+	spin_lock(rb_lock);
+
+	rPx =3D *px;
+	if (rPx =3D=3D 0)
+		rLenPtr =3D len1;
+	else
+		rFail =3D 1;
+
+	*rLenPtr =3D -1;
+	smp_wmb();
+	smp_store_release(px, rPx + 1);
+
+	spin_unlock(rb_lock);
+
+	smp_store_release(rLenPtr, 1);
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
index 000000000000..900104c4933b
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
+	rCx =3D smp_load_acquire(cx);
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
+		rLen =3D smp_load_acquire(rLenPtr);
+		if (rLen =3D=3D 0) {
+			rFail =3D 1;
+		} else if (rLen =3D=3D 1) {
+			rCx =3D rCx + 1;
+			smp_store_release(cx, rCx);
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
+		rLen =3D smp_load_acquire(rLenPtr);
+		if (rLen =3D=3D 0) {
+			rFail =3D 1;
+		} else if (rLen =3D=3D 1) {
+			rCx =3D rCx + 1;
+			smp_store_release(cx, rCx);
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
+	rCx =3D smp_load_acquire(cx);
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
+		*rLenPtr =3D -1;
+		smp_wmb();
+		smp_store_release(px, rPx + 1);
+
+		spin_unlock(rb_lock);
+
+		smp_store_release(rLenPtr, 1);
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
+	rCx =3D smp_load_acquire(cx);
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
+		*rLenPtr =3D -1;
+		smp_wmb();
+		smp_store_release(px, rPx + 1);
+
+		spin_unlock(rb_lock);
+
+		smp_store_release(rLenPtr, 1);
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
index 000000000000..83372e9eb079
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
+	rCx =3D smp_load_acquire(cx);
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
+		rLen =3D smp_load_acquire(rLenPtr);
+		if (rLen =3D=3D 0) {
+			rFail =3D 1;
+		} else if (rLen =3D=3D 1) {
+			rCx =3D rCx + 1;
+			smp_store_release(cx, rCx);
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
+		rLen =3D smp_load_acquire(rLenPtr);
+		if (rLen =3D=3D 0) {
+			rFail =3D 1;
+		} else if (rLen =3D=3D 1) {
+			rCx =3D rCx + 1;
+			smp_store_release(cx, rCx);
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
+	rCx =3D smp_load_acquire(cx);
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
+	*rLenPtr =3D -1;
+	smp_wmb();
+	smp_store_release(px, rPx + 1);
+
+	spin_unlock(rb_lock);
+
+	smp_store_release(rLenPtr, 1);
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
+	rCx =3D smp_load_acquire(cx);
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
+	*rLenPtr =3D -1;
+	smp_wmb();
+	smp_store_release(px, rPx + 1);
+
+	spin_unlock(rb_lock);
+
+	smp_store_release(rLenPtr, 1);
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

