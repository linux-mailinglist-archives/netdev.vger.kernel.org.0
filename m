Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8E71D6CAE
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 21:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbgEQT6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 15:58:03 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19226 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726722AbgEQT56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 May 2020 15:57:58 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04HJrxQd029470
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 12:57:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=KGd8IKZV0sXzyk1o+zFwRc06cXywfi9UewothHj879s=;
 b=Cix0pjvDACWPU7EnWR3Q2OP1vW8lIKrbtkPZcWGaVwF+n8bF3PIGVgGSiDBWzxKAk/ue
 vpBJw6OtdUQXV0IDNC2ZVtEQzlpRytzT2i1ma/fWMGD8kJTwaYrpl01HJrXhtwtoSAOz
 fN+gFKDgG+ZxIa/M3/ZrYpDgpfvx6vYp0YY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 312dpwtxgt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 12:57:55 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sun, 17 May 2020 12:57:55 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 89A122EC32DC; Sun, 17 May 2020 12:57:50 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Stanislav Fomichev <sdf@google.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 7/7] docs/bpf: add BPF ring buffer design notes
Date:   Sun, 17 May 2020 12:57:27 -0700
Message-ID: <20200517195727.279322-8-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200517195727.279322-1-andriin@fb.com>
References: <20200517195727.279322-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-17_08:2020-05-15,2020-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 phishscore=0
 malwarescore=0 clxscore=1015 impostorscore=0 spamscore=0 mlxlogscore=999
 lowpriorityscore=0 suspectscore=25 bulkscore=0 priorityscore=1501
 cotscore=-2147483648 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005170182
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add commit description from patch #1 as a stand-alone documentation under
Documentation/bpf, as it might be more convenient format, in long term
perspective.

Suggested-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 Documentation/bpf/ringbuf.txt | 191 ++++++++++++++++++++++++++++++++++
 1 file changed, 191 insertions(+)
 create mode 100644 Documentation/bpf/ringbuf.txt

diff --git a/Documentation/bpf/ringbuf.txt b/Documentation/bpf/ringbuf.tx=
t
new file mode 100644
index 000000000000..72f0a2480db3
--- /dev/null
+++ b/Documentation/bpf/ringbuf.txt
@@ -0,0 +1,191 @@
+BPF ring buffer
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+Motivation
+----------
+There are two distinctive motivators for this work, which are not satisf=
ied by
+existing perf buffer, which prompted creation of a new ring buffer
+implementation.
+  - more efficient memory utilization by sharing ring buffer across CPUs=
;
+  - preserving ordering of events that happen sequentially in time, even
+  across multiple CPUs (e.g., fork/exec/exit events for a task).
+
+These two problems are independent, but perf buffer fails to satisfy bot=
h.
+Both are a result of a choice to have per-CPU perf ring buffer.  Both ca=
n be
+also solved by having an MPSC implementation of ring buffer. The orderin=
g
+problem could technically be solved for perf buffer with some in-kernel
+counting, but given the first one requires an MPSC buffer, the same solu=
tion
+would solve the second problem automatically.
+
+Semantics and APIs
+------------------
+Single ring buffer is presented to BPF programs as an instance of BPF ma=
p of
+type BPF_MAP_TYPE_RINGBUF. Two other alternatives considered, but ultima=
tely
+rejected.
+
+One way would be to, similar to BPF_MAP_TYPE_PERF_EVENT_ARRAY, make
+BPF_MAP_TYPE_RINGBUF could represent an array of ring buffers, but not e=
nforce
+"same CPU only" rule. This would be more familiar interface compatible w=
ith
+existing perf buffer use in BPF, but would fail if application needed mo=
re
+advanced logic to lookup ring buffer by arbitrary key. HASH_OF_MAPS addr=
esses
+this with current approach. Additionally, given the performance of BPF
+ringbuf, many use cases would just opt into a simple single ring buffer =
shared
+among all CPUs, for which current approach would be an overkill.
+
+Another approach could introduce a new concept, alongside BPF map, to
+represent generic "container" object, which doesn't necessarily have key=
/value
+interface with lookup/update/delete operations. This approach would add =
a lot
+of extra infrastructure that has to be built for observability and verif=
ier
+support. It would also add another concept that BPF developers would hav=
e to
+familiarize themselves with, new syntax in libbpf, etc. But then would r=
eally
+provide no additional benefits over the approach of using a map.
+BPF_MAP_TYPE_RINGBUF doesn't support lookup/update/delete operations, bu=
t so
+doesn't few other map types (e.g., queue and stack; array doesn't suppor=
t
+delete, etc).
+
+The approach chosen has an advantage of re-using existing BPF map
+infrastructure (introspection APIs in kernel, libbpf support, etc), bein=
g
+familiar concept (no need to teach users a new type of object in BPF pro=
gram),
+and utilizing existing tooling (bpftool). For common scenario of using
+a single ring buffer for all CPUs, it's as simple and straightforward, a=
s
+would be with a dedicated "container" object. On the other hand, by bein=
g
+a map, it can be combined with ARRAY_OF_MAPS and HASH_OF_MAPS map-in-map=
s to
+implement a wide variety of topologies, from one ring buffer for each CP=
U
+(e.g., as a replacement for perf buffer use cases), to a complicated
+application hashing/sharding of ring buffers (e.g., having a small pool =
of
+ring buffers with hashed task's tgid being a look up key to preserve ord=
er,
+but reduce contention).
+
+Key and value sizes are enforced to be zero. max_entries is used to spec=
ify
+the size of ring buffer and has to be a power of 2 value.
+
+There are a bunch of similarities between perf buffer
+(BPF_MAP_TYPE_PERF_EVENT_ARRAY) and new BPF ring buffer semantics:
+  - variable-length records;
+  - if there is no more space left in ring buffer, reservation fails, no
+    blocking;
+  - memory-mappable data area for user-space applications for ease of
+    consumption and high performance;
+  - epoll notifications for new incoming data;
+  - but still the ability to do busy polling for new data to achieve the
+    lowest latency, if necessary.
+
+BPF ringbuf provides two sets of APIs to BPF programs:
+  - bpf_ringbuf_output() allows to *copy* data from one place to a ring
+    buffer, similarly to bpf_perf_event_output();
+  - bpf_ringbuf_reserve()/bpf_ringbuf_commit()/bpf_ringbuf_discard() API=
s
+    split the whole process into two steps. First, a fixed amount of spa=
ce is
+    reserved. If successful, a pointer to a data inside ring buffer data=
 area
+    is returned, which BPF programs can use similarly to a data inside
+    array/hash maps. Once ready, this piece of memory is either committe=
d or
+    discarded. Discard is similar to commit, but makes consumer ignore t=
he
+    record.
+
+bpf_ringbuf_output() has disadvantage of incurring extra memory copy, be=
cause
+record has to be prepared in some other place first. But it allows to su=
bmit
+records of the length that's not known to verifier beforehand. It also c=
losely
+matches bpf_perf_event_output(), so will simplify migration significantl=
y.
+
+bpf_ringbuf_reserve() avoids the extra copy of memory by providing a mem=
ory
+pointer directly to ring buffer memory. In a lot of cases records are la=
rger
+than BPF stack space allows, so many programs have use extra per-CPU arr=
ay as
+a temporary heap for preparing sample. bpf_ringbuf_reserve() avoid this =
needs
+completely. But in exchange, it only allows a known constant size of mem=
ory to
+be reserved, such that verifier can verify that BPF program can't access
+memory outside its reserved record space. bpf_ringbuf_output(), while sl=
ightly
+slower due to extra memory copy, covers some use cases that are not suit=
able
+for bpf_ringbuf_reserve().
+
+The difference between commit and discard is very small. Discard just ma=
rks
+a record as discarded, and such records are supposed to be ignored by co=
nsumer
+code. Discard is useful for some advanced use-cases, such as ensuring
+all-or-nothing multi-record submission, or emulating temporary malloc()/=
free()
+within single BPF program invocation.
+
+Each reserved record is tracked by verifier through existing
+reference-tracking logic, similar to socket ref-tracking. It is thus
+impossible to reserve a record, but forget to submit (or discard) it.
+
+bpf_ringbuf_query() helper allows to query various properties of ring bu=
ffer.
+Currently 4 are supported:
+  - BPF_RB_AVAIL_DATA returns amount of unconsumed data in ring buffer;
+  - BPF_RB_RING_SIZE returns the size of ring buffer;
+  - BPF_RB_CONS_POS/BPF_RB_PROD_POS returns current logical possition of
+    consumer/producer, respectively.
+Returned values are momentarily snapshots of ring buffer state and could=
 be
+off by the time helper returns, so this should be used only for
+debugging/reporting reasons or for implementing various heuristics, that=
 take
+into account highly-changeable nature of some of those characteristics.
+
+One such heuristic might involve more fine-grained control over poll/epo=
ll
+notifications about new data availability in ring buffer. Together with
+BPF_RB_NO_WAKEUP/BPF_RB_FORCE_WAKEUP flags for output/commit/discard hel=
pers,
+it allows BPF program a high degree of control and, e.g., more efficient
+batched notifications. Default self-balancing strategy, though, should b=
e
+adequate for most applications and will work reliable and efficiently al=
ready.
+
+Design and implementation
+-------------------------
+This reserve/commit schema allows a natural way for multiple producers, =
either
+on different CPUs or even on the same CPU/in the same BPF program, to re=
serve
+independent records and work with them without blocking other producers.=
 This
+means that if BPF program was interruped by another BPF program sharing =
the
+same ring buffer, they will both get a record reserved (provided there i=
s
+enough space left) and can work with it and submit it independently. Thi=
s
+applies to NMI context as well, except that due to using a spinlock duri=
ng
+reservation, in NMI context, bpf_ringbuf_reserve() might fail to get a l=
ock,
+in which case reservation will fail even if ring buffer is not full.
+
+The ring buffer itself internally is implemented as a power-of-2 sized
+circular buffer, with two logical and ever-increasing counters (which mi=
ght
+wrap around on 32-bit architectures, that's not a problem):
+  - consumer counter shows up to which logical position consumer consume=
d the
+    data;
+  - producer counter denotes amount of data reserved by all producers.
+
+Each time a record is reserved, producer that "owns" the record will
+successfully advance producer counter. At that point, data is still not =
yet
+ready to be consumed, though. Each record has 8 byte header, which conta=
ins
+the length of reserved record, as well as two extra bits: busy bit to de=
note
+that record is still being worked on, and discard bit, which might be se=
t at
+commit time if record is discarded. In the latter case, consumer is supp=
osed
+to skip the record and move on to the next one. Record header also encod=
es
+record's relative offset from the beginning of ring buffer data area (in
+pages). This allows bpf_ringbuf_commit()/bpf_ringbuf_discard() to accept=
 only
+the pointer to the record itself, without requiring also the pointer to =
ring
+buffer itself. Ring buffer memory location will be restored from record
+metadata header. This significantly simplifies verifier, as well as impr=
oving
+API usability.
+
+Producer counter increments are serialized under spinlock, so there is
+a strict ordering between reservations. Commits, on the other hand, are
+completely lockless and independent. All records become available to con=
sumer
+in the order of reservations, but only after all previous records where
+already committed. It is thus possible for slow producers to temporarily=
 hold
+off submitted records, that were reserved later.
+
+Reservation/commit/consumer protocol is verified by litmus tests in
+tools/memory-model/litmus-tests, see mpsc-rb*.litmus files.
+
+One interesting implementation bit, that significantly simplifies (and t=
hus
+speeds up as well) implementation of both producers and consumers is how=
 data
+area is mapped twice contiguously back-to-back in the virtual memory. Th=
is
+allows to not take any special measures for samples that have to wrap ar=
ound
+at the end of the circular buffer data area, because the next page after=
 the
+last data page would be first data page again, and thus the sample will =
still
+appear completely contiguous in virtual memory. See comment and a simple=
 ASCII
+diagram showing this visually in bpf_ringbuf_area_alloc().
+
+Another feature that distinguishes BPF ringbuf from perf ring buffer is
+a self-pacing notifications of new data being availability.
+bpf_ringbuf_commit() implementation will send a notification of new reco=
rd
+being available after commit only if consumer has already caught up righ=
t up
+to the record being committed. If not, consumer still has to catch up an=
d thus
+will see new data anyways without needing an extra poll notification.
+Benchmarks (see tools/testing/selftests/bpf/benchs/bench_ringbuf.c) show=
 that
+this allows to achieve a very high throughput without having to resort t=
o
+tricks like "notify only every Nth sample", which are necessary with per=
f
+buffer. For extreme cases, when BPF program wants more manual control of
+notifications, commit/discard/output helpers accept BPF_RB_NO_WAKEUP and
+BPF_RB_FORCE_WAKEUP flags, which give full control over notifications of=
 data
+availability, but require extra caution and diligence in using this API.
--=20
2.24.1

