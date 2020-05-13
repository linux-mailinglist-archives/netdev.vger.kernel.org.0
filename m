Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 317E91D1F14
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387597AbgEMT0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:26:18 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3556 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390289AbgEMT0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 15:26:15 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04DJPRJc012803
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 12:26:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=QyUuXmFDgH7uw95K2mgFMcPKQpbinpx5/O8D8KaLYrQ=;
 b=eNdGz742YSYYXIuofXFo2+vxCo4plpkOmptZfXz+1e/HLqpIDxRqTNhV9nDfAZlwjqIV
 A1vQ/KCuujZbbWoR4LIgIn8Uezt9xN5BSU17eopYaDD+NXM4J6en4+VjCqF/E0T1jCpM
 Q14/NMnHodrDbbeesPkyMjKnQRq+bs+kGbk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3100x9xt3w-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 12:26:11 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 13 May 2020 12:26:05 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id E7D872EC3007; Wed, 13 May 2020 12:26:02 -0700 (PDT)
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
Subject: [PATCH bpf-next 1/6] bpf: implement BPF ring buffer and verifier support for it
Date:   Wed, 13 May 2020 12:25:27 -0700
Message-ID: <20200513192532.4058934-2-andriin@fb.com>
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
 priorityscore=1501 bulkscore=0 phishscore=0 lowpriorityscore=0 mlxscore=0
 mlxlogscore=999 malwarescore=0 clxscore=1015 impostorscore=0
 cotscore=-2147483648 suspectscore=2 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005130166
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commits adds a new MPSC ring buffer implementation into BPF ecosyste=
m,
which allows multiple CPUs to submit data to a single shared ring buffer.=
 On
the consumption side, only single consumer is assumed.

Motivation
----------
There are two distinctive motivators for this work, which are not satisfi=
ed by
existing perf buffer, which prompted creation of a new ring buffer
implementation.
  - more efficient memory utilization by sharing ring buffer across CPUs;
  - preserving ordering of events that happen sequentially in time, even
  across multiple CPUs (e.g., fork/exec/exit events for a task).

These two problems are independent, but perf buffer fails to satisfy both=
.
Both are a result of a choice to have per-CPU perf ring buffer.  Both can=
 be
also solved by having an MPSC implementation of ring buffer. The ordering
problem could technically be solved for perf buffer with some in-kernel
counting, but given the first one requires an MPSC buffer, the same solut=
ion
would solve the second problem automatically.

Semantics and APIs
------------------
Single ring buffer is presented to BPF programs as an instance of BPF map=
 of
type BPF_MAP_TYPE_RINGBUF. Two other alternatives considered, but ultimat=
ely
rejected.

One way would be to, similar to BPF_MAP_TYPE_PERF_EVENT_ARRAY, make
BPF_MAP_TYPE_RINGBUF could represent an array of ring buffers, but not en=
force
"same CPU only" rule. This would be more familiar interface compatible wi=
th
existing perf buffer use in BPF, but would fail if application needed mor=
e
advanced logic to lookup ring buffer by arbitrary key. HASH_OF_MAPS addre=
sses
this with current approach. Additionally, given the performance of BPF
ringbuf, many use cases would just opt into a simple single ring buffer s=
hared
among all CPUs, for which current approach would be an overkill.

Another approach could introduce a new concept, alongside BPF map, to
represent generic "container" object, which doesn't necessarily have key/=
value
interface with lookup/update/delete operations. This approach would add a=
 lot
of extra infrastructure that has to be built for observability and verifi=
er
support. It would also add another concept that BPF developers would have=
 to
familiarize themselves with, new syntax in libbpf, etc. But then would re=
ally
provide no additional benefits over the approach of using a map.
BPF_MAP_TYPE_RINGBUF doesn't support lookup/update/delete operations, but=
 so
doesn't few other map types (e.g., queue and stack; array doesn't support
delete, etc).

The approach chosen has an advantage of re-using existing BPF map
infrastructure (introspection APIs in kernel, libbpf support, etc), being
familiar concept (no need to teach users a new type of object in BPF prog=
ram),
and utilizing existing tooling (bpftool). For common scenario of using
a single ring buffer for all CPUs, it's as simple and straightforward, as
would be with a dedicated "container" object. On the other hand, by being
a map, it can be combined with ARRAY_OF_MAPS and HASH_OF_MAPS map-in-maps=
 to
implement a wide variety of topologies, from one ring buffer for each CPU
(e.g., as a replacement for perf buffer use cases), to a complicated
application hashing/sharding of ring buffers (e.g., having a small pool o=
f
ring buffers with hashed task's tgid being a look up key to preserve orde=
r,
but reduce contention).

Key and value sizes are enforced to be zero. max_entries is used to speci=
fy
the size of ring buffer and has to be a power of 2 value.

There are a bunch of similarities between perf buffer
(BPF_MAP_TYPE_PERF_EVENT_ARRAY) and new BPF ring buffer semantics:
  - variable-length records;
  - if there is no more space left in ring buffer, reservation fails, no
    blocking;
  - memory-mappable data area for user-space applications for ease of
    consumption and high performance;
  - epoll notifications for new incoming data;
  - but still the ability to do busy polling for new data to achieve the
    lowest latency, if necessary.

BPF ringbuf provides two sets of APIs to BPF programs:
  - bpf_ringbuf_output() allows to *copy* data from one place to a ring
    buffer, similarly to bpf_perf_event_output();
  - bpf_ringbuf_reserve()/bpf_ringbuf_commit()/bpf_ringbuf_discard() APIs
    split the whole process into two steps. First, a fixed amount of spac=
e is
    reserved. If successful, a pointer to a data inside ring buffer data =
area
    is returned, which BPF programs can use similarly to a data inside
    array/hash maps. Once ready, this piece of memory is either committed=
 or
    discarded. Discard is similar to commit, but makes consumer ignore th=
e
    record.

bpf_ringbuf_output() has disadvantage of incurring extra memory copy, bec=
ause
record has to be prepared in some other place first. But it allows to sub=
mit
records of the length that's not known to verifier beforehand. It also cl=
osely
matches bpf_perf_event_output(), so will simplify migration significantly=
.

bpf_ringbuf_reserve() avoids the extra copy of memory by providing a memo=
ry
pointer directly to ring buffer memory. In a lot of cases records are lar=
ger
than BPF stack space allows, so many programs have use extra per-CPU arra=
y as
a temporary heap for preparing sample. bpf_ringbuf_reserve() avoid this n=
eeds
completely. But in exchange, it only allows a known constant size of memo=
ry to
be reserved, such that verifier can verify that BPF program can't access
memory outside its reserved record space. bpf_ringbuf_output(), while sli=
ghtly
slower due to extra memory copy, covers some use cases that are not suita=
ble
for bpf_ringbuf_reserve().

The difference between commit and discard is very small. Discard just mar=
ks
a record as discarded, and such records are supposed to be ignored by con=
sumer
code. Discard is useful for some advanced use-cases, such as ensuring
all-or-nothing multi-record submission, or emulating temporary malloc()/f=
ree()
within single BPF program invocation.

Each reserved record is tracked by verifier through existing
reference-tracking logic, similar to socket ref-tracking. It is thus
impossible to reserve a record, but forget to submit (or discard) it.

Design and implementation
-------------------------
This reserve/commit schema allows a natural way for multiple producers, e=
ither
on different CPUs or even on the same CPU/in the same BPF program, to res=
erve
independent records and work with them without blocking other producers. =
This
means that if BPF program was interruped by another BPF program sharing t=
he
same ring buffer, they will both get a record reserved (provided there is
enough space left) and can work with it and submit it independently. This
applies to NMI context as well, except that due to using a spinlock durin=
g
reservation, in NMI context, bpf_ringbuf_reserve() might fail to get a lo=
ck,
in which case reservation will fail even if ring buffer is not full.

The ring buffer itself internally is implemented as a power-of-2 sized
circular buffer, with two logical and ever-increasing counters (which mig=
ht
wrap around on 32-bit architectures, that's not a problem):
  - consumer counter shows up to which logical position consumer consumed=
 the
    data;
  - producer counter denotes amount of data reserved by all producers.

Each time a record is reserved, producer that "owns" the record will
successfully advance producer counter. At that point, data is still not y=
et
ready to be consumed, though. Each record has 8 byte header, which contai=
ns
the length of reserved record, as well as two extra bits: busy bit to den=
ote
that record is still being worked on, and discard bit, which might be set=
 at
commit time if record is discarded. In the latter case, consumer is suppo=
sed
to skip the record and move on to the next one. Record header also encode=
s
record's relative offset from the beginning of ring buffer data area (in
pages). This allows bpf_ringbuf_commit()/bpf_ringbuf_discard() to accept =
only
the pointer to the record itself, without requiring also the pointer to r=
ing
buffer itself. Ring buffer memory location will be restored from record
metadata header. This significantly simplifies verifier, as well as impro=
ving
API usability.

Producer counter increments are serialized under spinlock, so there is
a strict ordering between reservations. Commits, on the other hand, are
completely lockless and independent. All records become available to cons=
umer
in the order of reservations, but only after all previous records where
already committed. It is thus possible for slow producers to temporarily =
hold
off submitted records, that were reserved later.

Reservation/commit/consumer protocol is verified by litmus tests in the l=
ater
patch in this series.

One interesting implementation bit, that significantly simplifies (and th=
us
speeds up as well) implementation of both producers and consumers is how =
data
area is mapped twice contiguously back-to-back in the virtual memory. Thi=
s
allows to not take any special measures for samples that have to wrap aro=
und
at the end of the circular buffer data area, because the next page after =
the
last data page would be first data page again, and thus the sample will s=
till
appear completely contiguous in virtual memory. See comment and a simple =
ASCII
diagram showing this visually in bpf_ringbuf_area_alloc().

Another feature that distinguishes BPF ringbuf from perf ring buffer is
a self-pacing notifications of new data being availability.
bpf_ringbuf_commit() implementation will send a notification of new recor=
d
being available after commit only if consumer has already caught up right=
 up
to the record being committed. If not, consumer still has to catch up and=
 thus
will see new data anyways without needing an extra poll notification. As =
will
be shown in benchmarks in later patch in the series, this allows to achie=
ve
a very high throughput without having to resort to tricks like "notify on=
ly
every Nth sample", like with perf buffer, to achieve good throughput
performance.

For performance evaluation against perf buffer and scalability limits, se=
e
patch later in the series, adding ring buffers benchmark.
number of contention

Comparison to alternatives
--------------------------
Before considering implementing BPF ring buffer from scratch existing
alternatives in kernel were evaluated, but didn't seem to meet the needs.=
 They
largely fell into few categores:
  - per-CPU buffers (perf, ftrace, etc), which don't satisfy two motivati=
ons
    outlined above (ordering and memory consumption);
  - linked list-based implementations; while some were multi-producer des=
igns,
    consuming these from user-space would be very complicated and most
    probably not performant; memory-mapping contiguous piece of memory is
    simpler and more performant for user-space consumers;
  - io_uring is SPSC, but also requires fixed-sized elements. Naively tur=
ning
    SPSC queue into MPSC w/ lock would have subpar performance compared t=
o
    locked reserve + lockless commit, as with BPF ring buffer. Fixed size=
d
    elements would be too limiting for BPF programs, given existing BPF
    programs heavily rely on variable-sized perf buffer already;
  - specialized implementations (like a new printk ring buffer, [0]) with=
 lots
    of printk-specific limitations and implications, that didn't seem to =
fit
    well for intended use with BPF programs.

  [0] https://lwn.net/Articles/779550/

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 include/linux/bpf.h            |  12 +
 include/linux/bpf_types.h      |   1 +
 include/linux/bpf_verifier.h   |   4 +
 include/uapi/linux/bpf.h       |  33 ++-
 kernel/bpf/Makefile            |   2 +-
 kernel/bpf/helpers.c           |   8 +
 kernel/bpf/ringbuf.c           | 409 +++++++++++++++++++++++++++++++++
 kernel/bpf/syscall.c           |  12 +
 kernel/bpf/verifier.c          | 156 ++++++++++---
 kernel/trace/bpf_trace.c       |   8 +
 tools/include/uapi/linux/bpf.h |  33 ++-
 11 files changed, 643 insertions(+), 35 deletions(-)
 create mode 100644 kernel/bpf/ringbuf.c

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index cf4b6e44f2bc..9e3da01f3e9b 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -89,6 +89,8 @@ struct bpf_map_ops {
 	int (*map_direct_value_meta)(const struct bpf_map *map,
 				     u64 imm, u32 *off);
 	int (*map_mmap)(struct bpf_map *map, struct vm_area_struct *vma);
+	__poll_t (*map_poll)(struct bpf_map *map, struct file *filp,
+			     struct poll_table_struct *pts);
 };
=20
 struct bpf_map_memory {
@@ -243,6 +245,9 @@ enum bpf_arg_type {
 	ARG_PTR_TO_LONG,	/* pointer to long */
 	ARG_PTR_TO_SOCKET,	/* pointer to bpf_sock (fullsock) */
 	ARG_PTR_TO_BTF_ID,	/* pointer to in-kernel struct */
+	ARG_PTR_TO_ALLOC_MEM,	/* pointer to dynamically allocated memory */
+	ARG_PTR_TO_ALLOC_MEM_OR_NULL,	/* pointer to dynamically allocated memor=
y or NULL */
+	ARG_CONST_ALLOC_SIZE_OR_ZERO,	/* number of allocated bytes requested */
 };
=20
 /* type of values returned from helper functions */
@@ -254,6 +259,7 @@ enum bpf_return_type {
 	RET_PTR_TO_SOCKET_OR_NULL,	/* returns a pointer to a socket or NULL */
 	RET_PTR_TO_TCP_SOCK_OR_NULL,	/* returns a pointer to a tcp_sock or NULL=
 */
 	RET_PTR_TO_SOCK_COMMON_OR_NULL,	/* returns a pointer to a sock_common o=
r NULL */
+	RET_PTR_TO_ALLOC_MEM_OR_NULL,	/* returns a pointer to dynamically alloc=
ated memory or NULL */
 };
=20
 /* eBPF function prototype used by verifier to allow BPF_CALLs from eBPF=
 programs
@@ -321,6 +327,8 @@ enum bpf_reg_type {
 	PTR_TO_XDP_SOCK,	 /* reg points to struct xdp_sock */
 	PTR_TO_BTF_ID,		 /* reg points to kernel struct */
 	PTR_TO_BTF_ID_OR_NULL,	 /* reg points to kernel struct or NULL */
+	PTR_TO_MEM,		 /* reg points to valid memory region */
+	PTR_TO_MEM_OR_NULL,	 /* reg points to valid memory region or NULL */
 };
=20
 /* The information passed from prog-specific *_is_valid_access
@@ -1585,6 +1593,10 @@ extern const struct bpf_func_proto bpf_tcp_sock_pr=
oto;
 extern const struct bpf_func_proto bpf_jiffies64_proto;
 extern const struct bpf_func_proto bpf_get_ns_current_pid_tgid_proto;
 extern const struct bpf_func_proto bpf_event_output_data_proto;
+extern const struct bpf_func_proto bpf_ringbuf_output_proto;
+extern const struct bpf_func_proto bpf_ringbuf_reserve_proto;
+extern const struct bpf_func_proto bpf_ringbuf_submit_proto;
+extern const struct bpf_func_proto bpf_ringbuf_discard_proto;
=20
 const struct bpf_func_proto *bpf_tracing_func_proto(
 	enum bpf_func_id func_id, const struct bpf_prog *prog);
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 29d22752fc87..fa8e1b552acd 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -118,6 +118,7 @@ BPF_MAP_TYPE(BPF_MAP_TYPE_STACK, stack_map_ops)
 #if defined(CONFIG_BPF_JIT)
 BPF_MAP_TYPE(BPF_MAP_TYPE_STRUCT_OPS, bpf_struct_ops_map_ops)
 #endif
+BPF_MAP_TYPE(BPF_MAP_TYPE_RINGBUF, ringbuf_map_ops)
=20
 BPF_LINK_TYPE(BPF_LINK_TYPE_RAW_TRACEPOINT, raw_tracepoint)
 BPF_LINK_TYPE(BPF_LINK_TYPE_TRACING, tracing)
diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 6abd5a778fcd..c94a736e53cd 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -54,6 +54,8 @@ struct bpf_reg_state {
=20
 		u32 btf_id; /* for PTR_TO_BTF_ID */
=20
+		u32 mem_size; /* for PTR_TO_MEM | PTR_TO_MEM_OR_NULL */
+
 		/* Max size from any of the above. */
 		unsigned long raw;
 	};
@@ -63,6 +65,8 @@ struct bpf_reg_state {
 	 * offset, so they can share range knowledge.
 	 * For PTR_TO_MAP_VALUE_OR_NULL this is used to share which map value w=
e
 	 * came from, when one is tested for !=3D NULL.
+	 * For PTR_TO_MEM_OR_NULL this is used to identify memory allocation
+	 * for the purpose of tracking that it's freed.
 	 * For PTR_TO_SOCKET this is used to share which pointers retain the
 	 * same reference to the socket, to determine proper reference freeing.
 	 */
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index bfb31c1be219..ae2deb6a8afc 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -147,6 +147,7 @@ enum bpf_map_type {
 	BPF_MAP_TYPE_SK_STORAGE,
 	BPF_MAP_TYPE_DEVMAP_HASH,
 	BPF_MAP_TYPE_STRUCT_OPS,
+	BPF_MAP_TYPE_RINGBUF,
 };
=20
 /* Note that tracing related programs such as
@@ -3121,6 +3122,32 @@ union bpf_attr {
  * 		0 on success, or a negative error in case of failure:
  *
  *		**-EOVERFLOW** if an overflow happened: The same object will be trie=
d again.
+ *
+ * void *bpf_ringbuf_output(void *ringbuf, void *data, u64 size, u64 fla=
gs)
+ * 	Description
+ * 		Copy *size* bytes from *data* into a ring buffer *ringbuf*.
+ * 	Return
+ * 		0, on success;
+ * 		< 0, on error.
+ *
+ * void *bpf_ringbuf_reserve(void *ringbuf, u64 size, u64 flags)
+ * 	Description
+ * 		Reserve *size* bytes of payload in a ring buffer *ringbuf*.
+ * 	Return
+ * 		Valid pointer with *size* bytes of memory available; NULL,
+ * 		otherwise.
+ *
+ * void bpf_ringbuf_submit(void *data)
+ * 	Description
+ * 		Submit reserved ring buffer sample, pointed to by *data*.
+ * 	Return
+ * 		Nothing.
+ *
+ * void bpf_ringbuf_discard(void *data)
+ * 	Description
+ * 		Discard reserved ring buffer sample, pointed to by *data*.
+ * 	Return
+ * 		Nothing.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3250,7 +3277,11 @@ union bpf_attr {
 	FN(sk_assign),			\
 	FN(ktime_get_boot_ns),		\
 	FN(seq_printf),			\
-	FN(seq_write),
+	FN(seq_write),			\
+	FN(ringbuf_output),		\
+	FN(ringbuf_reserve),		\
+	FN(ringbuf_submit),		\
+	FN(ringbuf_discard),
=20
 /* integer value in 'imm' field of BPF_CALL instruction selects which he=
lper
  * function eBPF program intends to call
diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index 37b2d8620153..c9aada6c1806 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -4,7 +4,7 @@ CFLAGS_core.o +=3D $(call cc-disable-warning, override-in=
it)
=20
 obj-$(CONFIG_BPF_SYSCALL) +=3D syscall.o verifier.o inode.o helpers.o tn=
um.o bpf_iter.o map_iter.o task_iter.o
 obj-$(CONFIG_BPF_SYSCALL) +=3D hashtab.o arraymap.o percpu_freelist.o bp=
f_lru_list.o lpm_trie.o map_in_map.o
-obj-$(CONFIG_BPF_SYSCALL) +=3D local_storage.o queue_stack_maps.o
+obj-$(CONFIG_BPF_SYSCALL) +=3D local_storage.o queue_stack_maps.o ringbu=
f.o
 obj-$(CONFIG_BPF_SYSCALL) +=3D disasm.o
 obj-$(CONFIG_BPF_JIT) +=3D trampoline.o
 obj-$(CONFIG_BPF_SYSCALL) +=3D btf.o
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 5c0290e0696e..27321ca8803f 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -629,6 +629,14 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 		return &bpf_ktime_get_ns_proto;
 	case BPF_FUNC_ktime_get_boot_ns:
 		return &bpf_ktime_get_boot_ns_proto;
+	case BPF_FUNC_ringbuf_output:
+		return &bpf_ringbuf_output_proto;
+	case BPF_FUNC_ringbuf_reserve:
+		return &bpf_ringbuf_reserve_proto;
+	case BPF_FUNC_ringbuf_submit:
+		return &bpf_ringbuf_submit_proto;
+	case BPF_FUNC_ringbuf_discard:
+		return &bpf_ringbuf_discard_proto;
 	default:
 		break;
 	}
diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
new file mode 100644
index 000000000000..f2ae441a1695
--- /dev/null
+++ b/kernel/bpf/ringbuf.c
@@ -0,0 +1,409 @@
+#include <linux/bpf.h>
+#include <linux/btf.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/filter.h>
+#include <linux/mm.h>
+#include <linux/vmalloc.h>
+#include <linux/wait.h>
+#include <linux/poll.h>
+#include <uapi/linux/btf.h>
+
+#define RINGBUF_CREATE_FLAG_MASK (BPF_F_NUMA_NODE)
+
+#define RINGBUF_BUSY_BIT BIT(31)
+#define RINGBUF_DISCARD_BIT BIT(30)
+#define RINGBUF_META_SZ 8
+
+/* non-mmap()'able part of bpf_ringbuf (everything up to consumer page) =
*/
+#define BPF_RINGBUF_PGOFF \
+	(offsetof(struct bpf_ringbuf, consumer_pos) >> PAGE_SHIFT)
+
+struct bpf_ringbuf {
+	wait_queue_head_t waitq;
+	u64 mask;
+	spinlock_t spinlock ____cacheline_aligned_in_smp;
+	u64 consumer_pos __aligned(PAGE_SIZE);
+	u64 producer_pos __aligned(PAGE_SIZE);
+	char data[] __aligned(PAGE_SIZE);
+};
+
+struct bpf_ringbuf_map {
+	struct bpf_map map;
+	struct bpf_map_memory memory;
+	struct bpf_ringbuf *rb;
+};
+
+static struct bpf_ringbuf *bpf_ringbuf_area_alloc(size_t data_sz, int nu=
ma_node)
+{
+	const gfp_t flags =3D GFP_KERNEL | __GFP_RETRY_MAYFAIL | __GFP_NOWARN |
+			    __GFP_ZERO;
+	int nr_meta_pages =3D 2 + BPF_RINGBUF_PGOFF;
+	int nr_data_pages =3D data_sz >> PAGE_SHIFT;
+	int nr_pages =3D nr_meta_pages + nr_data_pages;
+	struct page **pages, *page;
+	size_t array_size;
+	void *addr;
+	int i;
+
+	/* Each data page is mapped twice to allow "virtual"
+	 * continuous read of samples wrapping around the end of ring
+	 * buffer area:
+	 * ------------------------------------------------------
+	 * | meta pages |  real data pages  |  same data pages  |
+	 * ------------------------------------------------------
+	 * |            | 1 2 3 4 5 6 7 8 9 | 1 2 3 4 5 6 7 8 9 |
+	 * ------------------------------------------------------
+	 * |            | TA             DA | TA             DA |
+	 * ------------------------------------------------------
+	 *                               ^^^^^^^
+	 *                                  |
+	 * Here, no need to worry about special handling of wrapped-around
+	 * data due to double-mapped data pages. This works both in kernel and
+	 * when mmap()'ed in user-space, simplifying both kernel and
+	 * user-space implementations significantly.
+	 */
+	array_size =3D (nr_meta_pages + 2 * nr_data_pages) * sizeof(*pages);
+	if (array_size > PAGE_SIZE)
+		pages =3D vmalloc_node(array_size, numa_node);
+	else
+		pages =3D kmalloc_node(array_size, flags, numa_node);
+	if (!pages)
+		return NULL;
+
+	for (i =3D 0; i < nr_pages; i++) {
+		page =3D alloc_pages_node(numa_node, flags, 0);
+		if (!page) {
+			nr_pages =3D i;
+			goto err_free_pages;
+		}
+		pages[i] =3D page;
+		if (i >=3D nr_meta_pages)
+			pages[nr_data_pages + i] =3D page;
+	}
+
+	addr =3D vmap(pages, nr_meta_pages + 2 * nr_data_pages,
+		    VM_ALLOC | VM_USERMAP, PAGE_KERNEL);
+	if (addr)
+		return addr;
+
+err_free_pages:
+	for (i =3D 0; i < nr_pages; i++)
+		free_page((unsigned long)pages[i]);
+	kvfree(pages);
+	return NULL;
+}
+
+static struct bpf_ringbuf *bpf_ringbuf_alloc(size_t data_sz, int numa_no=
de)
+{
+	struct bpf_ringbuf *rb;
+
+	if (!data_sz || !PAGE_ALIGNED(data_sz))
+		return ERR_PTR(-EINVAL);
+
+	rb =3D bpf_ringbuf_area_alloc(data_sz, numa_node);
+	if (!rb)
+		return ERR_PTR(-ENOMEM);
+
+	spin_lock_init(&rb->spinlock);
+	init_waitqueue_head(&rb->waitq);
+
+	rb->mask =3D data_sz - 1;
+	rb->consumer_pos =3D 0;
+	rb->producer_pos =3D 0;
+
+	return rb;
+}
+
+static struct bpf_map *ringbuf_map_alloc(union bpf_attr *attr)
+{
+	struct bpf_ringbuf_map *rb_map;
+	u64 cost;
+	int err;
+
+	if (attr->map_flags & ~RINGBUF_CREATE_FLAG_MASK)
+		return ERR_PTR(-EINVAL);
+
+	if (attr->key_size || attr->value_size ||
+	    attr->max_entries =3D=3D 0 || !PAGE_ALIGNED(attr->max_entries))
+		return ERR_PTR(-EINVAL);
+
+	rb_map =3D kzalloc(sizeof(*rb_map), GFP_USER);
+	if (!rb_map)
+		return ERR_PTR(-ENOMEM);
+
+	bpf_map_init_from_attr(&rb_map->map, attr);
+
+	cost =3D sizeof(struct bpf_ringbuf_map) +
+	       sizeof(struct bpf_ringbuf) +
+	       attr->max_entries;
+	err =3D bpf_map_charge_init(&rb_map->map.memory, cost);
+	if (err)
+		goto err_free_map;
+
+	rb_map->rb =3D bpf_ringbuf_alloc(attr->max_entries, rb_map->map.numa_no=
de);
+	if (IS_ERR(rb_map->rb)) {
+		err =3D PTR_ERR(rb_map->rb);
+		goto err_uncharge;
+	}
+
+	return &rb_map->map;
+
+err_uncharge:
+	bpf_map_charge_finish(&rb_map->map.memory);
+err_free_map:
+	kfree(rb_map);
+	return ERR_PTR(err);
+}
+
+static void bpf_ringbuf_free(struct bpf_ringbuf *ringbuf)
+{
+	kvfree(ringbuf);
+}
+
+static void ringbuf_map_free(struct bpf_map *map)
+{
+	struct bpf_ringbuf_map *rb_map;
+
+	/* at this point bpf_prog->aux->refcnt =3D=3D 0 and this map->refcnt =3D=
=3D 0,
+	 * so the programs (can be more than one that used this map) were
+	 * disconnected from events. Wait for outstanding critical sections in
+	 * these programs to complete
+	 */
+	synchronize_rcu();
+
+	rb_map =3D container_of(map, struct bpf_ringbuf_map, map);
+	bpf_ringbuf_free(rb_map->rb);
+	kfree(rb_map);
+}
+
+static void *ringbuf_map_lookup_elem(struct bpf_map *map, void *key)
+{
+	return ERR_PTR(-ENOTSUPP);
+}
+
+static int ringbuf_map_update_elem(struct bpf_map *map, void *key, void =
*value,
+				   u64 flags)
+{
+	return -ENOTSUPP;
+}
+
+static int ringbuf_map_delete_elem(struct bpf_map *map, void *key)
+{
+	return -ENOTSUPP;
+}
+
+static int ringbuf_map_get_next_key(struct bpf_map *map, void *key,
+				    void *next_key)
+{
+	return -ENOTSUPP;
+}
+
+static size_t bpf_ringbuf_mmap_page_cnt(const struct bpf_ringbuf *rb)
+{
+	size_t data_pages =3D (rb->mask + 1) >> PAGE_SHIFT;
+
+	/* consumer page + producer page + 2 x data pages */
+	return 2 + 2 * data_pages;
+}
+
+static int ringbuf_map_mmap(struct bpf_map *map, struct vm_area_struct *=
vma)
+{
+	struct bpf_ringbuf_map *rb_map;
+	size_t mmap_sz;
+
+	rb_map =3D container_of(map, struct bpf_ringbuf_map, map);
+	mmap_sz =3D bpf_ringbuf_mmap_page_cnt(rb_map->rb) << PAGE_SHIFT;
+
+	if (vma->vm_pgoff * PAGE_SIZE + (vma->vm_end - vma->vm_start) > mmap_sz=
)
+		return -EINVAL;
+
+	return remap_vmalloc_range(vma, rb_map->rb,
+				   vma->vm_pgoff + BPF_RINGBUF_PGOFF);
+}
+
+static __poll_t ringbuf_map_poll(struct bpf_map *map, struct file *filp,
+				  struct poll_table_struct *pts)
+{
+	struct bpf_ringbuf_map *rb_map;
+
+	rb_map =3D container_of(map, struct bpf_ringbuf_map, map);
+	poll_wait(filp, &rb_map->rb->waitq, pts);
+
+	return EPOLLIN | EPOLLRDNORM;
+}
+
+const struct bpf_map_ops ringbuf_map_ops =3D {
+	.map_alloc =3D ringbuf_map_alloc,
+	.map_free =3D ringbuf_map_free,
+	.map_mmap =3D ringbuf_map_mmap,
+	.map_poll =3D ringbuf_map_poll,
+	.map_lookup_elem =3D ringbuf_map_lookup_elem,
+	.map_update_elem =3D ringbuf_map_update_elem,
+	.map_delete_elem =3D ringbuf_map_delete_elem,
+	.map_get_next_key =3D ringbuf_map_get_next_key,
+};
+
+/* Given pointer to ring buffer record metadata and struct bpf_ringbuf i=
tself,
+ * calculate offset from record metadata to ring buffer in pages, rounde=
d
+ * down. This page offset is stored as part of record metadata and allow=
s to
+ * restore struct bpf_ringbuf * from record pointer. This page offset is
+ * stored at offset 4 of record metadata header.
+ */
+static size_t bpf_ringbuf_rec_pg_off(struct bpf_ringbuf *rb, void *meta_=
ptr)
+{
+	return (meta_ptr - (void *)rb) >> PAGE_SHIFT;
+}
+
+/* Given pointer to ring buffer record metadata, restore pointer to stru=
ct
+ * bpf_ringbuf itself by using page offset stored at offset 4
+ */
+static struct bpf_ringbuf *bpf_ringbuf_restore_from_rec(void *meta_ptr)
+{
+	unsigned long addr =3D (unsigned long)meta_ptr;
+	unsigned long off =3D *(u32 *)(meta_ptr + 4) << PAGE_SHIFT;
+
+	return (void*)((addr & PAGE_MASK) - off);
+}
+
+static void *__bpf_ringbuf_reserve(struct bpf_ringbuf *rb, u64 size)
+{
+	unsigned long cons_pos, prod_pos, new_prod_pos, flags;
+	u32 len, pg_off;
+	void *meta_ptr;
+
+	if (unlikely(size > UINT_MAX))
+		return NULL;
+
+	len =3D round_up(size + RINGBUF_META_SZ, 8);
+	cons_pos =3D READ_ONCE(rb->consumer_pos);
+
+	if (in_nmi()) {
+		if (!spin_trylock_irqsave(&rb->spinlock, flags))
+			return NULL;
+	} else {
+		spin_lock_irqsave(&rb->spinlock, flags);
+	}
+
+	prod_pos =3D rb->producer_pos;
+	new_prod_pos =3D prod_pos + len;
+
+	/* check for out of ringbuf space by ensuring producer position
+	 * doesn't advance more than (ringbuf_size - 1) ahead
+	 */
+	if (new_prod_pos - cons_pos > rb->mask) {
+		spin_unlock_irqrestore(&rb->spinlock, flags);
+		return NULL;
+	}
+
+	meta_ptr =3D rb->data + (prod_pos & rb->mask);
+	pg_off =3D bpf_ringbuf_rec_pg_off(rb, meta_ptr);
+
+	WRITE_ONCE(*(u32 *)meta_ptr, RINGBUF_BUSY_BIT | size);
+	WRITE_ONCE(*(u32 *)(meta_ptr + 4), pg_off);
+
+	/* ensure length prefix is written before updating producer positions *=
/
+	smp_wmb();
+	WRITE_ONCE(rb->producer_pos, new_prod_pos);
+
+	spin_unlock_irqrestore(&rb->spinlock, flags);
+
+	return meta_ptr + RINGBUF_META_SZ;
+}
+
+BPF_CALL_3(bpf_ringbuf_reserve, struct bpf_map *, map, u64, size, u64, f=
lags)
+{
+	struct bpf_ringbuf_map *rb_map;
+
+	if (unlikely(flags))
+		return -EINVAL;
+
+	rb_map =3D container_of(map, struct bpf_ringbuf_map, map);
+	return (unsigned long)__bpf_ringbuf_reserve(rb_map->rb, size);
+}
+
+const struct bpf_func_proto bpf_ringbuf_reserve_proto =3D {
+	.func		=3D bpf_ringbuf_reserve,
+	.ret_type	=3D RET_PTR_TO_ALLOC_MEM_OR_NULL,
+	.arg1_type	=3D ARG_CONST_MAP_PTR,
+	.arg2_type	=3D ARG_CONST_ALLOC_SIZE_OR_ZERO,
+	.arg3_type	=3D ARG_ANYTHING,
+};
+
+static void bpf_ringbuf_commit(void *sample, bool discard)
+{
+	unsigned long rec_pos, cons_pos;
+	u32 new_meta, old_meta;
+	void *meta_ptr;
+	struct bpf_ringbuf *rb;
+
+	meta_ptr =3D sample - RINGBUF_META_SZ;
+	rb =3D bpf_ringbuf_restore_from_rec(meta_ptr);
+	old_meta =3D *(u32 *)meta_ptr;
+	new_meta =3D old_meta ^ RINGBUF_BUSY_BIT;
+	if (discard)
+		new_meta |=3D RINGBUF_DISCARD_BIT;
+
+	/* update metadata header with correct final size prefix */
+	xchg((u32 *)meta_ptr, new_meta);
+
+	/* if consumer caught up and is waiting for our record, notify about
+	 * new data availability
+	 */
+	rec_pos =3D (void *)meta_ptr - (void *)rb->data;
+	cons_pos =3D smp_load_acquire(&rb->consumer_pos) & rb->mask;
+	if (cons_pos =3D=3D rec_pos)
+		wake_up_all(&rb->waitq);
+}
+
+BPF_CALL_1(bpf_ringbuf_submit, void *, sample)
+{
+	bpf_ringbuf_commit(sample, false /* discard */);
+	return 0;
+}
+
+const struct bpf_func_proto bpf_ringbuf_submit_proto =3D {
+	.func		=3D bpf_ringbuf_submit,
+	.ret_type	=3D RET_VOID,
+	.arg1_type	=3D ARG_PTR_TO_ALLOC_MEM,
+};
+
+BPF_CALL_1(bpf_ringbuf_discard, void *, sample)
+{
+	bpf_ringbuf_commit(sample, true /* discard */);
+	return 0;
+}
+
+const struct bpf_func_proto bpf_ringbuf_discard_proto =3D {
+	.func		=3D bpf_ringbuf_discard,
+	.ret_type	=3D RET_VOID,
+	.arg1_type	=3D ARG_PTR_TO_ALLOC_MEM,
+};
+
+BPF_CALL_4(bpf_ringbuf_output, struct bpf_map *, map, void *, data, u64,=
 size,
+	   u64, flags)
+{
+	struct bpf_ringbuf_map *rb_map;
+	void *rec;
+
+	if (unlikely(flags))
+		return -EINVAL;
+
+	rb_map =3D container_of(map, struct bpf_ringbuf_map, map);
+	rec =3D __bpf_ringbuf_reserve(rb_map->rb, size);
+	if (!rec)
+		return -EAGAIN;
+
+	memcpy(rec, data, size);
+	bpf_ringbuf_commit(rec, false /* discard */);
+	return 0;
+}
+
+const struct bpf_func_proto bpf_ringbuf_output_proto =3D {
+	.func		=3D bpf_ringbuf_output,
+	.ret_type	=3D RET_INTEGER,
+	.arg1_type	=3D ARG_CONST_MAP_PTR,
+	.arg2_type	=3D ARG_PTR_TO_MEM,
+	.arg3_type	=3D ARG_CONST_SIZE_OR_ZERO,
+	.arg4_type	=3D ARG_ANYTHING,
+};
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index de2a75500233..462db8595e9f 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -26,6 +26,7 @@
 #include <linux/audit.h>
 #include <uapi/linux/btf.h>
 #include <linux/bpf_lsm.h>
+#include <linux/poll.h>
=20
 #define IS_FD_ARRAY(map) ((map)->map_type =3D=3D BPF_MAP_TYPE_PERF_EVENT=
_ARRAY || \
 			  (map)->map_type =3D=3D BPF_MAP_TYPE_CGROUP_ARRAY || \
@@ -651,6 +652,16 @@ static int bpf_map_mmap(struct file *filp, struct vm=
_area_struct *vma)
 	return err;
 }
=20
+static __poll_t bpf_map_poll(struct file *filp, struct poll_table_struct=
 *pts)
+{
+	struct bpf_map *map =3D filp->private_data;
+
+	if (map->ops->map_poll)
+		return map->ops->map_poll(map, filp, pts);
+
+	return EPOLLERR;
+}
+
 const struct file_operations bpf_map_fops =3D {
 #ifdef CONFIG_PROC_FS
 	.show_fdinfo	=3D bpf_map_show_fdinfo,
@@ -659,6 +670,7 @@ const struct file_operations bpf_map_fops =3D {
 	.read		=3D bpf_dummy_read,
 	.write		=3D bpf_dummy_write,
 	.mmap		=3D bpf_map_mmap,
+	.poll		=3D bpf_map_poll,
 };
=20
 int bpf_map_new_fd(struct bpf_map *map, int flags)
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 2a1826c76bb6..b8f0158d2327 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -233,6 +233,7 @@ struct bpf_call_arg_meta {
 	bool pkt_access;
 	int regno;
 	int access_size;
+	int mem_size;
 	u64 msize_max_value;
 	int ref_obj_id;
 	int func_id;
@@ -399,7 +400,8 @@ static bool reg_type_may_be_null(enum bpf_reg_type ty=
pe)
 	       type =3D=3D PTR_TO_SOCKET_OR_NULL ||
 	       type =3D=3D PTR_TO_SOCK_COMMON_OR_NULL ||
 	       type =3D=3D PTR_TO_TCP_SOCK_OR_NULL ||
-	       type =3D=3D PTR_TO_BTF_ID_OR_NULL;
+	       type =3D=3D PTR_TO_BTF_ID_OR_NULL ||
+	       type =3D=3D PTR_TO_MEM_OR_NULL;
 }
=20
 static bool reg_may_point_to_spin_lock(const struct bpf_reg_state *reg)
@@ -413,7 +415,9 @@ static bool reg_type_may_be_refcounted_or_null(enum b=
pf_reg_type type)
 	return type =3D=3D PTR_TO_SOCKET ||
 		type =3D=3D PTR_TO_SOCKET_OR_NULL ||
 		type =3D=3D PTR_TO_TCP_SOCK ||
-		type =3D=3D PTR_TO_TCP_SOCK_OR_NULL;
+		type =3D=3D PTR_TO_TCP_SOCK_OR_NULL ||
+		type =3D=3D PTR_TO_MEM ||
+		type =3D=3D PTR_TO_MEM_OR_NULL;
 }
=20
 static bool arg_type_may_be_refcounted(enum bpf_arg_type type)
@@ -427,7 +431,9 @@ static bool arg_type_may_be_refcounted(enum bpf_arg_t=
ype type)
  */
 static bool is_release_function(enum bpf_func_id func_id)
 {
-	return func_id =3D=3D BPF_FUNC_sk_release;
+	return func_id =3D=3D BPF_FUNC_sk_release ||
+	       func_id =3D=3D BPF_FUNC_ringbuf_submit ||
+	       func_id =3D=3D BPF_FUNC_ringbuf_discard;
 }
=20
 static bool may_be_acquire_function(enum bpf_func_id func_id)
@@ -435,7 +441,8 @@ static bool may_be_acquire_function(enum bpf_func_id =
func_id)
 	return func_id =3D=3D BPF_FUNC_sk_lookup_tcp ||
 		func_id =3D=3D BPF_FUNC_sk_lookup_udp ||
 		func_id =3D=3D BPF_FUNC_skc_lookup_tcp ||
-		func_id =3D=3D BPF_FUNC_map_lookup_elem;
+		func_id =3D=3D BPF_FUNC_map_lookup_elem ||
+	        func_id =3D=3D BPF_FUNC_ringbuf_reserve;
 }
=20
 static bool is_acquire_function(enum bpf_func_id func_id,
@@ -445,7 +452,8 @@ static bool is_acquire_function(enum bpf_func_id func=
_id,
=20
 	if (func_id =3D=3D BPF_FUNC_sk_lookup_tcp ||
 	    func_id =3D=3D BPF_FUNC_sk_lookup_udp ||
-	    func_id =3D=3D BPF_FUNC_skc_lookup_tcp)
+	    func_id =3D=3D BPF_FUNC_skc_lookup_tcp ||
+	    func_id =3D=3D BPF_FUNC_ringbuf_reserve)
 		return true;
=20
 	if (func_id =3D=3D BPF_FUNC_map_lookup_elem &&
@@ -485,6 +493,8 @@ static const char * const reg_type_str[] =3D {
 	[PTR_TO_XDP_SOCK]	=3D "xdp_sock",
 	[PTR_TO_BTF_ID]		=3D "ptr_",
 	[PTR_TO_BTF_ID_OR_NULL]	=3D "ptr_or_null_",
+	[PTR_TO_MEM]		=3D "mem",
+	[PTR_TO_MEM_OR_NULL]	=3D "mem_or_null",
 };
=20
 static char slot_type_char[] =3D {
@@ -2459,32 +2469,31 @@ static int check_map_access_type(struct bpf_verif=
ier_env *env, u32 regno,
 	return 0;
 }
=20
-/* check read/write into map element returned by bpf_map_lookup_elem() *=
/
-static int __check_map_access(struct bpf_verifier_env *env, u32 regno, i=
nt off,
-			      int size, bool zero_size_allowed)
+/* check read/write into memory region (e.g., map value, ringbuf sample,=
 etc) */
+static int __check_mem_access(struct bpf_verifier_env *env, int off,
+			      int size, u32 mem_size, bool zero_size_allowed)
 {
-	struct bpf_reg_state *regs =3D cur_regs(env);
-	struct bpf_map *map =3D regs[regno].map_ptr;
+	bool size_ok =3D size > 0 || (size =3D=3D 0 && zero_size_allowed);
=20
-	if (off < 0 || size < 0 || (size =3D=3D 0 && !zero_size_allowed) ||
-	    off + size > map->value_size) {
-		verbose(env, "invalid access to map value, value_size=3D%d off=3D%d si=
ze=3D%d\n",
-			map->value_size, off, size);
-		return -EACCES;
-	}
-	return 0;
+	if (off >=3D 0 && size_ok && off + size <=3D mem_size)
+		return 0;
+
+	verbose(env, "invalid access to memory, mem_size=3D%u off=3D%d size=3D%=
d\n",
+		mem_size, off, size);
+	return -EACCES;
 }
=20
-/* check read/write into a map element with possible variable offset */
-static int check_map_access(struct bpf_verifier_env *env, u32 regno,
-			    int off, int size, bool zero_size_allowed)
+/* check read/write into a memory region with possible variable offset *=
/
+static int check_mem_region_access(struct bpf_verifier_env *env, u32 reg=
no,
+				   int off, int size, u32 mem_size,
+				   bool zero_size_allowed)
 {
 	struct bpf_verifier_state *vstate =3D env->cur_state;
 	struct bpf_func_state *state =3D vstate->frame[vstate->curframe];
 	struct bpf_reg_state *reg =3D &state->regs[regno];
 	int err;
=20
-	/* We may have adjusted the register to this map value, so we
+	/* We may have adjusted the register pointing to memory region, so we
 	 * need to try adding each of min_value and max_value to off
 	 * to make sure our theoretical access will be safe.
 	 */
@@ -2501,14 +2510,14 @@ static int check_map_access(struct bpf_verifier_e=
nv *env, u32 regno,
 	    (reg->smin_value =3D=3D S64_MIN ||
 	     (off + reg->smin_value !=3D (s64)(s32)(off + reg->smin_value)) ||
 	      reg->smin_value + off < 0)) {
-		verbose(env, "R%d min value is negative, either use unsigned index or =
do a if (index >=3D0) check.\n",
+		verbose(env, "R%d min value is negative, either use unsigned index or =
do an if (index >=3D0) check.\n",
 			regno);
 		return -EACCES;
 	}
-	err =3D __check_map_access(env, regno, reg->smin_value + off, size,
+	err =3D __check_mem_access(env, reg->smin_value + off, size, mem_size,
 				 zero_size_allowed);
 	if (err) {
-		verbose(env, "R%d min value is outside of the array range\n",
+		verbose(env, "R%d min value is outside of the memory region\n",
 			regno);
 		return err;
 	}
@@ -2518,18 +2527,38 @@ static int check_map_access(struct bpf_verifier_e=
nv *env, u32 regno,
 	 * If reg->umax_value + off could overflow, treat that as unbounded too=
.
 	 */
 	if (reg->umax_value >=3D BPF_MAX_VAR_OFF) {
-		verbose(env, "R%d unbounded memory access, make sure to bounds check a=
ny array access into a map\n",
+		verbose(env, "R%d unbounded memory access, make sure to bounds check a=
ny memory region access\n",
 			regno);
 		return -EACCES;
 	}
-	err =3D __check_map_access(env, regno, reg->umax_value + off, size,
+	err =3D __check_mem_access(env, reg->umax_value + off, size, mem_size,
 				 zero_size_allowed);
-	if (err)
-		verbose(env, "R%d max value is outside of the array range\n",
+	if (err) {
+		verbose(env, "R%d max value is outside of the memory region\n",
 			regno);
+		return err;
+	}
+
+	return 0;
+}
+
+/* check read/write into a map element with possible variable offset */
+static int check_map_access(struct bpf_verifier_env *env, u32 regno,
+			    int off, int size, bool zero_size_allowed)
+{
+	struct bpf_verifier_state *vstate =3D env->cur_state;
+	struct bpf_func_state *state =3D vstate->frame[vstate->curframe];
+	struct bpf_reg_state *reg =3D &state->regs[regno];
+	struct bpf_map *map =3D reg->map_ptr;
+	int err;
+
+	err =3D check_mem_region_access(env, regno, off, size, map->value_size,
+				      zero_size_allowed);
+	if (err)
+		return err;
=20
-	if (map_value_has_spin_lock(reg->map_ptr)) {
-		u32 lock =3D reg->map_ptr->spin_lock_off;
+	if (map_value_has_spin_lock(map)) {
+		u32 lock =3D map->spin_lock_off;
=20
 		/* if any part of struct bpf_spin_lock can be touched by
 		 * load/store reject this program.
@@ -3211,6 +3240,16 @@ static int check_mem_access(struct bpf_verifier_en=
v *env, int insn_idx, u32 regn
 				mark_reg_unknown(env, regs, value_regno);
 			}
 		}
+	} else if (reg->type =3D=3D PTR_TO_MEM) {
+		if (t =3D=3D BPF_WRITE && value_regno >=3D 0 &&
+		    is_pointer_value(env, value_regno)) {
+			verbose(env, "R%d leaks addr into mem\n", value_regno);
+			return -EACCES;
+		}
+		err =3D check_mem_region_access(env, regno, off, size,
+					      reg->mem_size, false);
+		if (!err && t =3D=3D BPF_READ && value_regno >=3D 0)
+			mark_reg_unknown(env, regs, value_regno);
 	} else if (reg->type =3D=3D PTR_TO_CTX) {
 		enum bpf_reg_type reg_type =3D SCALAR_VALUE;
 		u32 btf_id =3D 0;
@@ -3548,6 +3587,10 @@ static int check_helper_mem_access(struct bpf_veri=
fier_env *env, int regno,
 			return -EACCES;
 		return check_map_access(env, regno, reg->off, access_size,
 					zero_size_allowed);
+	case PTR_TO_MEM:
+		return check_mem_region_access(env, regno, reg->off,
+					       access_size, reg->mem_size,
+					       zero_size_allowed);
 	default: /* scalar_value|ptr_to_stack or invalid ptr */
 		return check_stack_boundary(env, regno, access_size,
 					    zero_size_allowed, meta);
@@ -3652,6 +3695,17 @@ static bool arg_type_is_mem_size(enum bpf_arg_type=
 type)
 	       type =3D=3D ARG_CONST_SIZE_OR_ZERO;
 }
=20
+static bool arg_type_is_alloc_mem_ptr(enum bpf_arg_type type)
+{
+	return type =3D=3D ARG_PTR_TO_ALLOC_MEM ||
+	       type =3D=3D ARG_PTR_TO_ALLOC_MEM_OR_NULL;
+}
+
+static bool arg_type_is_alloc_size(enum bpf_arg_type type)
+{
+	return type =3D=3D ARG_CONST_ALLOC_SIZE_OR_ZERO;
+}
+
 static bool arg_type_is_int_ptr(enum bpf_arg_type type)
 {
 	return type =3D=3D ARG_PTR_TO_INT ||
@@ -3711,7 +3765,8 @@ static int check_func_arg(struct bpf_verifier_env *=
env, u32 regno,
 			 type !=3D expected_type)
 			goto err_type;
 	} else if (arg_type =3D=3D ARG_CONST_SIZE ||
-		   arg_type =3D=3D ARG_CONST_SIZE_OR_ZERO) {
+		   arg_type =3D=3D ARG_CONST_SIZE_OR_ZERO ||
+		   arg_type =3D=3D ARG_CONST_ALLOC_SIZE_OR_ZERO) {
 		expected_type =3D SCALAR_VALUE;
 		if (type !=3D expected_type)
 			goto err_type;
@@ -3782,13 +3837,29 @@ static int check_func_arg(struct bpf_verifier_env=
 *env, u32 regno,
 		 * happens during stack boundary checking.
 		 */
 		if (register_is_null(reg) &&
-		    arg_type =3D=3D ARG_PTR_TO_MEM_OR_NULL)
+		    (arg_type =3D=3D ARG_PTR_TO_MEM_OR_NULL ||
+		     arg_type =3D=3D ARG_PTR_TO_ALLOC_MEM_OR_NULL))
 			/* final test in check_stack_boundary() */;
 		else if (!type_is_pkt_pointer(type) &&
 			 type !=3D PTR_TO_MAP_VALUE &&
+			 type !=3D PTR_TO_MEM &&
 			 type !=3D expected_type)
 			goto err_type;
 		meta->raw_mode =3D arg_type =3D=3D ARG_PTR_TO_UNINIT_MEM;
+	} else if (arg_type_is_alloc_mem_ptr(arg_type)) {
+		expected_type =3D PTR_TO_MEM;
+		if (register_is_null(reg) &&
+		    arg_type =3D=3D ARG_PTR_TO_ALLOC_MEM_OR_NULL)
+			/* final test in check_stack_boundary() */;
+		else if (type !=3D expected_type)
+			goto err_type;
+		if (meta->ref_obj_id) {
+			verbose(env, "verifier internal error: more than one arg with ref_obj=
_id R%d %u %u\n",
+				regno, reg->ref_obj_id,
+				meta->ref_obj_id);
+			return -EFAULT;
+		}
+		meta->ref_obj_id =3D reg->ref_obj_id;
 	} else if (arg_type_is_int_ptr(arg_type)) {
 		expected_type =3D PTR_TO_STACK;
 		if (!type_is_pkt_pointer(type) &&
@@ -3884,6 +3955,13 @@ static int check_func_arg(struct bpf_verifier_env =
*env, u32 regno,
 					      zero_size_allowed, meta);
 		if (!err)
 			err =3D mark_chain_precision(env, regno);
+	} else if (arg_type_is_alloc_size(arg_type)) {
+		if (!tnum_is_const(reg->var_off)) {
+			verbose(env, "R%d unbounded size, use 'var &=3D const' or 'if (var < =
const)'\n",
+				regno);
+			return -EACCES;
+		}
+		meta->mem_size =3D reg->var_off.value;
 	} else if (arg_type_is_int_ptr(arg_type)) {
 		int size =3D int_ptr_type_to_size(arg_type);
=20
@@ -3920,6 +3998,13 @@ static int check_map_func_compatibility(struct bpf=
_verifier_env *env,
 		    func_id !=3D BPF_FUNC_xdp_output)
 			goto error;
 		break;
+	case BPF_MAP_TYPE_RINGBUF:
+		if (func_id !=3D BPF_FUNC_ringbuf_output &&
+		    func_id !=3D BPF_FUNC_ringbuf_reserve &&
+		    func_id !=3D BPF_FUNC_ringbuf_submit &&
+		    func_id !=3D BPF_FUNC_ringbuf_discard)
+			goto error;
+		break;
 	case BPF_MAP_TYPE_STACK_TRACE:
 		if (func_id !=3D BPF_FUNC_get_stackid)
 			goto error;
@@ -4644,6 +4729,11 @@ static int check_helper_call(struct bpf_verifier_e=
nv *env, int func_id, int insn
 		mark_reg_known_zero(env, regs, BPF_REG_0);
 		regs[BPF_REG_0].type =3D PTR_TO_TCP_SOCK_OR_NULL;
 		regs[BPF_REG_0].id =3D ++env->id_gen;
+	} else if (fn->ret_type =3D=3D RET_PTR_TO_ALLOC_MEM_OR_NULL) {
+		mark_reg_known_zero(env, regs, BPF_REG_0);
+		regs[BPF_REG_0].type =3D PTR_TO_MEM_OR_NULL;
+		regs[BPF_REG_0].id =3D ++env->id_gen;
+		regs[BPF_REG_0].mem_size =3D meta.mem_size;
 	} else {
 		verbose(env, "unknown return type %d of func %s#%d\n",
 			fn->ret_type, func_id_name(func_id), func_id);
@@ -6583,6 +6673,8 @@ static void mark_ptr_or_null_reg(struct bpf_func_st=
ate *state,
 			reg->type =3D PTR_TO_TCP_SOCK;
 		} else if (reg->type =3D=3D PTR_TO_BTF_ID_OR_NULL) {
 			reg->type =3D PTR_TO_BTF_ID;
+		} else if (reg->type =3D=3D PTR_TO_MEM_OR_NULL) {
+			reg->type =3D PTR_TO_MEM;
 		}
 		if (is_null) {
 			/* We don't need id and ref_obj_id from this point
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index d961428fb5b6..6e6b3f8f77c1 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1053,6 +1053,14 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, c=
onst struct bpf_prog *prog)
 		return &bpf_perf_event_read_value_proto;
 	case BPF_FUNC_get_ns_current_pid_tgid:
 		return &bpf_get_ns_current_pid_tgid_proto;
+	case BPF_FUNC_ringbuf_output:
+		return &bpf_ringbuf_output_proto;
+	case BPF_FUNC_ringbuf_reserve:
+		return &bpf_ringbuf_reserve_proto;
+	case BPF_FUNC_ringbuf_submit:
+		return &bpf_ringbuf_submit_proto;
+	case BPF_FUNC_ringbuf_discard:
+		return &bpf_ringbuf_discard_proto;
 	default:
 		return NULL;
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index bfb31c1be219..ae2deb6a8afc 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -147,6 +147,7 @@ enum bpf_map_type {
 	BPF_MAP_TYPE_SK_STORAGE,
 	BPF_MAP_TYPE_DEVMAP_HASH,
 	BPF_MAP_TYPE_STRUCT_OPS,
+	BPF_MAP_TYPE_RINGBUF,
 };
=20
 /* Note that tracing related programs such as
@@ -3121,6 +3122,32 @@ union bpf_attr {
  * 		0 on success, or a negative error in case of failure:
  *
  *		**-EOVERFLOW** if an overflow happened: The same object will be trie=
d again.
+ *
+ * void *bpf_ringbuf_output(void *ringbuf, void *data, u64 size, u64 fla=
gs)
+ * 	Description
+ * 		Copy *size* bytes from *data* into a ring buffer *ringbuf*.
+ * 	Return
+ * 		0, on success;
+ * 		< 0, on error.
+ *
+ * void *bpf_ringbuf_reserve(void *ringbuf, u64 size, u64 flags)
+ * 	Description
+ * 		Reserve *size* bytes of payload in a ring buffer *ringbuf*.
+ * 	Return
+ * 		Valid pointer with *size* bytes of memory available; NULL,
+ * 		otherwise.
+ *
+ * void bpf_ringbuf_submit(void *data)
+ * 	Description
+ * 		Submit reserved ring buffer sample, pointed to by *data*.
+ * 	Return
+ * 		Nothing.
+ *
+ * void bpf_ringbuf_discard(void *data)
+ * 	Description
+ * 		Discard reserved ring buffer sample, pointed to by *data*.
+ * 	Return
+ * 		Nothing.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3250,7 +3277,11 @@ union bpf_attr {
 	FN(sk_assign),			\
 	FN(ktime_get_boot_ns),		\
 	FN(seq_printf),			\
-	FN(seq_write),
+	FN(seq_write),			\
+	FN(ringbuf_output),		\
+	FN(ringbuf_reserve),		\
+	FN(ringbuf_submit),		\
+	FN(ringbuf_discard),
=20
 /* integer value in 'imm' field of BPF_CALL instruction selects which he=
lper
  * function eBPF program intends to call
--=20
2.24.1

