Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 679C65A85DE
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 20:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbiHaSju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 14:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233098AbiHaSjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 14:39:16 -0400
Received: from 69-171-232-181.mail-mxout.facebook.com (69-171-232-181.mail-mxout.facebook.com [69.171.232.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A30ADDABD
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 11:36:51 -0700 (PDT)
Received: by devbig010.atn6.facebook.com (Postfix, from userid 115148)
        id C89CD1127DA65; Wed, 31 Aug 2022 11:36:37 -0700 (PDT)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     bpf@vger.kernel.org
Cc:     andrii@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        kafai@fb.com, memxor@gmail.com, toke@redhat.com, kuba@kernel.org,
        netdev@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH bpf-next v5 1/3] bpf: Add skb dynptrs
Date:   Wed, 31 Aug 2022 11:32:22 -0700
Message-Id: <20220831183224.3754305-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220831183224.3754305-1-joannelkoong@gmail.com>
References: <20220831183224.3754305-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=1.6 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,RDNS_DYNAMIC,
        SPF_HELO_PASS,SPF_SOFTFAIL,TVD_RCVD_IP,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add skb dynptrs, which are dynptrs whose underlying pointer points
to a skb. The dynptr acts on skb data. skb dynptrs have two main
benefits. One is that they allow operations on sizes that are not
statically known at compile-time (eg variable-sized accesses).
Another is that parsing the packet data through dynptrs (instead of
through direct access of skb->data and skb->data_end) can be more
ergonomic and less brittle (eg does not need manual if checking for
being within bounds of data_end).

For bpf prog types that don't support writes on skb data, the dynptr is
read-only (bpf_dynptr_write() will return an error and bpf_dynptr_data()
will return NULL; for a read-only data slice, there will be a separate
API bpf_dynptr_data_rdonly(), which will be added in the near future).

For reads and writes through the bpf_dynptr_read() and bpf_dynptr_write()
interfaces, reading and writing from/to data in the head as well as from/=
to
non-linear paged buffers is supported. For data slices (through the
bpf_dynptr_data() interface), if the data is in a paged buffer, the user
must first call bpf_skb_pull_data() to pull the data into the linear
portion.

Any bpf_dynptr_write() automatically invalidates any prior data slices
to the skb dynptr. This is because a bpf_dynptr_write() may be writing
to data in a paged buffer, so it will need to pull the buffer first into
the head. The reason it needs to be pulled instead of writing directly to
the paged buffers is because they may be cloned (only the head of the skb
is by default uncloned). As such, any bpf_dynptr_write() will
automatically have its prior data slices invalidated, even if the write
is to data in the skb head (the verifier has no way of differentiating
whether the write is to the head or paged buffers during program load
time). Please note as well that any other helper calls that change the
underlying packet buffer (eg bpf_skb_pull_data()) invalidates any data
slices of the skb dynptr as well. The stack trace for this is
check_helper_call() -> clear_all_pkt_pointers() ->
__clear_all_pkt_pointers() -> mark_reg_unknown().

For examples of how skb dynptrs can be used, please see the attached
selftests.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/bpf.h            | 82 +++++++++++++++++++------------
 include/linux/filter.h         | 17 +++++++
 include/uapi/linux/bpf.h       | 43 +++++++++++++++--
 kernel/bpf/helpers.c           | 71 ++++++++++++++++++++++++---
 kernel/bpf/verifier.c          | 88 +++++++++++++++++++++++++++-------
 net/core/filter.c              | 72 ++++++++++++++++++++++++++--
 tools/include/uapi/linux/bpf.h | 43 +++++++++++++++--
 7 files changed, 352 insertions(+), 64 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 9c1674973e03..26ad1422a157 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -408,11 +408,14 @@ enum bpf_type_flag {
 	/* Size is known at compile time. */
 	MEM_FIXED_SIZE		=3D BIT(10 + BPF_BASE_TYPE_BITS),
=20
+	/* DYNPTR points to sk_buff */
+	DYNPTR_TYPE_SKB		=3D BIT(11 + BPF_BASE_TYPE_BITS),
+
 	__BPF_TYPE_FLAG_MAX,
 	__BPF_TYPE_LAST_FLAG	=3D __BPF_TYPE_FLAG_MAX - 1,
 };
=20
-#define DYNPTR_TYPE_FLAG_MASK	(DYNPTR_TYPE_LOCAL | DYNPTR_TYPE_RINGBUF)
+#define DYNPTR_TYPE_FLAG_MASK	(DYNPTR_TYPE_LOCAL | DYNPTR_TYPE_RINGBUF |=
 DYNPTR_TYPE_SKB)
=20
 /* Max number of base types. */
 #define BPF_BASE_TYPE_LIMIT	(1UL << BPF_BASE_TYPE_BITS)
@@ -904,6 +907,36 @@ static __always_inline __nocfi unsigned int bpf_disp=
atcher_nop_func(
 	return bpf_func(ctx, insnsi);
 }
=20
+/* the implementation of the opaque uapi struct bpf_dynptr */
+struct bpf_dynptr_kern {
+	void *data;
+	/* Size represents the number of usable bytes of dynptr data.
+	 * If for example the offset is at 4 for a local dynptr whose data is
+	 * of type u64, the number of usable bytes is 4.
+	 *
+	 * The upper 8 bits are reserved. It is as follows:
+	 * Bits 0 - 23 =3D size
+	 * Bits 24 - 30 =3D dynptr type
+	 * Bit 31 =3D whether dynptr is read-only
+	 */
+	u32 size;
+	u32 offset;
+} __aligned(8);
+
+enum bpf_dynptr_type {
+	BPF_DYNPTR_TYPE_INVALID,
+	/* Points to memory that is local to the bpf program */
+	BPF_DYNPTR_TYPE_LOCAL,
+	/* Underlying data is a ringbuf record */
+	BPF_DYNPTR_TYPE_RINGBUF,
+	/* Underlying data is a sk_buff */
+	BPF_DYNPTR_TYPE_SKB,
+	/* Underlying data is a xdp_buff */
+	BPF_DYNPTR_TYPE_XDP,
+};
+
+int bpf_dynptr_check_size(u32 size);
+
 #ifdef CONFIG_BPF_JIT
 int bpf_trampoline_link_prog(struct bpf_tramp_link *link, struct bpf_tra=
mpoline *tr);
 int bpf_trampoline_unlink_prog(struct bpf_tramp_link *link, struct bpf_t=
rampoline *tr);
@@ -1983,6 +2016,11 @@ static inline bool has_current_bpf_ctx(void)
 {
 	return !!current->bpf_ctx;
 }
+
+void bpf_dynptr_init(struct bpf_dynptr_kern *ptr, void *data,
+		     enum bpf_dynptr_type type, u32 offset, u32 size);
+void bpf_dynptr_set_null(struct bpf_dynptr_kern *ptr);
+void bpf_dynptr_set_rdonly(struct bpf_dynptr_kern *ptr);
 #else /* !CONFIG_BPF_SYSCALL */
 static inline struct bpf_prog *bpf_prog_get(u32 ufd)
 {
@@ -2196,6 +2234,19 @@ static inline bool has_current_bpf_ctx(void)
 {
 	return false;
 }
+
+static inline void bpf_dynptr_init(struct bpf_dynptr_kern *ptr, void *da=
ta,
+				   enum bpf_dynptr_type type, u32 offset, u32 size)
+{
+}
+
+static inline void bpf_dynptr_set_null(struct bpf_dynptr_kern *ptr)
+{
+}
+
+static inline void bpf_dynptr_set_rdonly(struct bpf_dynptr_kern *ptr)
+{
+}
 #endif /* CONFIG_BPF_SYSCALL */
=20
 void __bpf_free_used_btfs(struct bpf_prog_aux *aux,
@@ -2557,35 +2608,6 @@ int bpf_bprintf_prepare(char *fmt, u32 fmt_size, c=
onst u64 *raw_args,
 			u32 **bin_buf, u32 num_args);
 void bpf_bprintf_cleanup(void);
=20
-/* the implementation of the opaque uapi struct bpf_dynptr */
-struct bpf_dynptr_kern {
-	void *data;
-	/* Size represents the number of usable bytes of dynptr data.
-	 * If for example the offset is at 4 for a local dynptr whose data is
-	 * of type u64, the number of usable bytes is 4.
-	 *
-	 * The upper 8 bits are reserved. It is as follows:
-	 * Bits 0 - 23 =3D size
-	 * Bits 24 - 30 =3D dynptr type
-	 * Bit 31 =3D whether dynptr is read-only
-	 */
-	u32 size;
-	u32 offset;
-} __aligned(8);
-
-enum bpf_dynptr_type {
-	BPF_DYNPTR_TYPE_INVALID,
-	/* Points to memory that is local to the bpf program */
-	BPF_DYNPTR_TYPE_LOCAL,
-	/* Underlying data is a ringbuf record */
-	BPF_DYNPTR_TYPE_RINGBUF,
-};
-
-void bpf_dynptr_init(struct bpf_dynptr_kern *ptr, void *data,
-		     enum bpf_dynptr_type type, u32 offset, u32 size);
-void bpf_dynptr_set_null(struct bpf_dynptr_kern *ptr);
-int bpf_dynptr_check_size(u32 size);
-
 #ifdef CONFIG_BPF_LSM
 void bpf_cgroup_atype_get(u32 attach_btf_id, int cgroup_atype);
 void bpf_cgroup_atype_put(int cgroup_atype);
diff --git a/include/linux/filter.h b/include/linux/filter.h
index a5f21dc3c432..a3a415344001 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1532,4 +1532,21 @@ static __always_inline int __bpf_xdp_redirect_map(=
struct bpf_map *map, u32 ifind
 	return XDP_REDIRECT;
 }
=20
+#ifdef CONFIG_NET
+int __bpf_skb_load_bytes(const struct sk_buff *skb, u32 offset, void *to=
, u32 len);
+int __bpf_skb_store_bytes(struct sk_buff *skb, u32 offset, const void *f=
rom,
+			  u32 len, u64 flags);
+#else /* CONFIG_NET */
+int __bpf_skb_load_bytes(const struct sk_buff *skb, u32 offset, void *to=
, u32 len)
+{
+	return -EOPNOTSUPP;
+}
+
+int __bpf_skb_store_bytes(struct sk_buff *skb, u32 offset, const void *f=
rom,
+			  u32 len, u64 flags)
+{
+	return -EOPNOTSUPP;
+}
+#endif /* CONFIG_NET */
+
 #endif /* __LINUX_FILTER_H__ */
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 962960a98835..b4e5f7d81a20 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5284,22 +5284,44 @@ union bpf_attr {
  *	Description
  *		Write *len* bytes from *src* into *dst*, starting from *offset*
  *		into *dst*.
- *		*flags* is currently unused.
+ *
+ *		*flags* must be 0 except for skb-type dynptrs.
+ *
+ *		For skb-type dynptrs:
+ *		    *  All data slices of the dynptr are automatically
+ *		       invalidated after **bpf_dynptr_write**\ (). If you wish to
+ *		       avoid this, please perform the write using direct data slices
+ *		       instead.
+ *
+ *		    *  For *flags*, please see the flags accepted by
+ *		       **bpf_skb_store_bytes**\ ().
  *	Return
  *		0 on success, -E2BIG if *offset* + *len* exceeds the length
  *		of *dst*'s data, -EINVAL if *dst* is an invalid dynptr or if *dst*
- *		is a read-only dynptr or if *flags* is not 0.
+ *		is a read-only dynptr or if *flags* is not correct. For skb-type dyn=
ptrs,
+ *		other errors correspond to errors returned by **bpf_skb_store_bytes*=
*\ ().
  *
  * void *bpf_dynptr_data(struct bpf_dynptr *ptr, u32 offset, u32 len)
  *	Description
  *		Get a pointer to the underlying dynptr data.
  *
  *		*len* must be a statically known value. The returned data slice
- *		is invalidated whenever the dynptr is invalidated.
+ *		is invalidated whenever the dynptr is invalidated. If the dynptr
+ *		is read-only, this will return NULL.
+ *
+ *		For skb-type dynptrs:
+ *		    * If *offset* + *len* extends into the skb's paged buffers,
+ *		      the user should manually pull the skb with **bpf_skb_pull_data=
**\ ()
+ *		      and try again.
+ *
+ *		    * The data slice is automatically invalidated anytime
+ *		      **bpf_dynptr_write**\ () or a helper call that changes
+ *		      the underlying packet buffer (eg **bpf_skb_pull_data**\ ())
+ *		      is called.
  *	Return
  *		Pointer to the underlying dynptr data, NULL if the dynptr is
  *		read-only, if the dynptr is invalid, or if the offset and length
- *		is out of bounds.
+ *		is out of bounds or in a paged buffer for skb-type dynptrs.
  *
  * s64 bpf_tcp_raw_gen_syncookie_ipv4(struct iphdr *iph, struct tcphdr *=
th, u32 th_len)
  *	Description
@@ -5386,6 +5408,18 @@ union bpf_attr {
  *	Return
  *		Current *ktime*.
  *
+ * long bpf_dynptr_from_skb(struct sk_buff *skb, u64 flags, struct bpf_d=
ynptr *ptr)
+ *	Description
+ *		Get a dynptr to the data in *skb*. *skb* must be the BPF program
+ *		context. Depending on program type, the dynptr may be read-only.
+ *
+ *		Calls that change the *skb*'s underlying packet buffer
+ *		(eg **bpf_skb_pull_data**\ ()) do not invalidate the dynptr, but
+ *		they do invalidate any data slices associated with the dynptr.
+ *
+ *		*flags* is currently unused, it must be 0 for now.
+ *	Return
+ *		0 on success or -EINVAL if flags is not 0.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5597,6 +5631,7 @@ union bpf_attr {
 	FN(tcp_raw_check_syncookie_ipv4),	\
 	FN(tcp_raw_check_syncookie_ipv6),	\
 	FN(ktime_get_tai_ns),		\
+	FN(dynptr_from_skb),		\
 	/* */
=20
 /* integer value in 'imm' field of BPF_CALL instruction selects which he=
lper
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index fc08035f14ed..98fcb4704a9e 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1403,11 +1403,21 @@ static bool bpf_dynptr_is_rdonly(struct bpf_dynpt=
r_kern *ptr)
 	return ptr->size & DYNPTR_RDONLY_BIT;
 }
=20
+void bpf_dynptr_set_rdonly(struct bpf_dynptr_kern *ptr)
+{
+	ptr->size |=3D DYNPTR_RDONLY_BIT;
+}
+
 static void bpf_dynptr_set_type(struct bpf_dynptr_kern *ptr, enum bpf_dy=
nptr_type type)
 {
 	ptr->size |=3D type << DYNPTR_TYPE_SHIFT;
 }
=20
+static enum bpf_dynptr_type bpf_dynptr_get_type(const struct bpf_dynptr_=
kern *ptr)
+{
+	return (ptr->size & ~(DYNPTR_RDONLY_BIT)) >> DYNPTR_TYPE_SHIFT;
+}
+
 static u32 bpf_dynptr_get_size(struct bpf_dynptr_kern *ptr)
 {
 	return ptr->size & DYNPTR_SIZE_MASK;
@@ -1478,6 +1488,7 @@ static const struct bpf_func_proto bpf_dynptr_from_=
mem_proto =3D {
 BPF_CALL_5(bpf_dynptr_read, void *, dst, u32, len, struct bpf_dynptr_ker=
n *, src,
 	   u32, offset, u64, flags)
 {
+	enum bpf_dynptr_type type;
 	int err;
=20
 	if (!src->data || flags)
@@ -1487,9 +1498,19 @@ BPF_CALL_5(bpf_dynptr_read, void *, dst, u32, len,=
 struct bpf_dynptr_kern *, src
 	if (err)
 		return err;
=20
-	memcpy(dst, src->data + src->offset + offset, len);
+	type =3D bpf_dynptr_get_type(src);
=20
-	return 0;
+	switch (type) {
+	case BPF_DYNPTR_TYPE_LOCAL:
+	case BPF_DYNPTR_TYPE_RINGBUF:
+		memcpy(dst, src->data + src->offset + offset, len);
+		return 0;
+	case BPF_DYNPTR_TYPE_SKB:
+		return __bpf_skb_load_bytes(src->data, src->offset + offset, dst, len)=
;
+	default:
+		WARN_ONCE(true, "bpf_dynptr_read: unknown dynptr type %d\n", type);
+		return -EFAULT;
+	}
 }
=20
 static const struct bpf_func_proto bpf_dynptr_read_proto =3D {
@@ -1506,18 +1527,32 @@ static const struct bpf_func_proto bpf_dynptr_rea=
d_proto =3D {
 BPF_CALL_5(bpf_dynptr_write, struct bpf_dynptr_kern *, dst, u32, offset,=
 void *, src,
 	   u32, len, u64, flags)
 {
+	enum bpf_dynptr_type type;
 	int err;
=20
-	if (!dst->data || flags || bpf_dynptr_is_rdonly(dst))
+	if (!dst->data || bpf_dynptr_is_rdonly(dst))
 		return -EINVAL;
=20
 	err =3D bpf_dynptr_check_off_len(dst, offset, len);
 	if (err)
 		return err;
=20
-	memcpy(dst->data + dst->offset + offset, src, len);
+	type =3D bpf_dynptr_get_type(dst);
=20
-	return 0;
+	switch (type) {
+	case BPF_DYNPTR_TYPE_LOCAL:
+	case BPF_DYNPTR_TYPE_RINGBUF:
+		if (flags)
+			return -EINVAL;
+		memcpy(dst->data + dst->offset + offset, src, len);
+		return 0;
+	case BPF_DYNPTR_TYPE_SKB:
+		return __bpf_skb_store_bytes(dst->data, dst->offset + offset, src, len=
,
+					     flags);
+	default:
+		WARN_ONCE(true, "bpf_dynptr_write: unknown dynptr type %d\n", type);
+		return -EFAULT;
+	}
 }
=20
 static const struct bpf_func_proto bpf_dynptr_write_proto =3D {
@@ -1533,6 +1568,8 @@ static const struct bpf_func_proto bpf_dynptr_write=
_proto =3D {
=20
 BPF_CALL_3(bpf_dynptr_data, struct bpf_dynptr_kern *, ptr, u32, offset, =
u32, len)
 {
+	enum bpf_dynptr_type type;
+	void *data;
 	int err;
=20
 	if (!ptr->data)
@@ -1545,7 +1582,29 @@ BPF_CALL_3(bpf_dynptr_data, struct bpf_dynptr_kern=
 *, ptr, u32, offset, u32, len
 	if (bpf_dynptr_is_rdonly(ptr))
 		return 0;
=20
-	return (unsigned long)(ptr->data + ptr->offset + offset);
+	type =3D bpf_dynptr_get_type(ptr);
+
+	switch (type) {
+	case BPF_DYNPTR_TYPE_LOCAL:
+	case BPF_DYNPTR_TYPE_RINGBUF:
+		data =3D ptr->data;
+		break;
+	case BPF_DYNPTR_TYPE_SKB:
+	{
+		struct sk_buff *skb =3D ptr->data;
+
+		/* if the data is paged, the caller needs to pull it first */
+		if (ptr->offset + offset + len > skb->len - skb->data_len)
+			return 0;
+
+		data =3D skb->data;
+		break;
+	}
+	default:
+		WARN_ONCE(true, "bpf_dynptr_data: unknown dynptr type %d\n", type);
+		return 0;
+	}
+	return (unsigned long)(data + ptr->offset + offset);
 }
=20
 static const struct bpf_func_proto bpf_dynptr_data_proto =3D {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 0194a36d0b36..7f67fac66735 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -684,6 +684,8 @@ static enum bpf_dynptr_type arg_to_dynptr_type(enum b=
pf_arg_type arg_type)
 		return BPF_DYNPTR_TYPE_LOCAL;
 	case DYNPTR_TYPE_RINGBUF:
 		return BPF_DYNPTR_TYPE_RINGBUF;
+	case DYNPTR_TYPE_SKB:
+		return BPF_DYNPTR_TYPE_SKB;
 	default:
 		return BPF_DYNPTR_TYPE_INVALID;
 	}
@@ -1406,6 +1408,12 @@ static bool reg_is_pkt_pointer_any(const struct bp=
f_reg_state *reg)
 	       reg->type =3D=3D PTR_TO_PACKET_END;
 }
=20
+static bool reg_is_dynptr_slice_pkt(const struct bpf_reg_state *reg)
+{
+	return base_type(reg->type) =3D=3D PTR_TO_MEM &&
+		reg->type & DYNPTR_TYPE_SKB;
+}
+
 /* Unmodified PTR_TO_PACKET[_META,_END] register from ctx access. */
 static bool reg_is_init_pkt_pointer(const struct bpf_reg_state *reg,
 				    enum bpf_reg_type which)
@@ -5830,12 +5838,29 @@ int check_func_arg_reg_off(struct bpf_verifier_en=
v *env,
 	return __check_ptr_off_reg(env, reg, regno, fixed_off_ok);
 }
=20
-static u32 stack_slot_get_id(struct bpf_verifier_env *env, struct bpf_re=
g_state *reg)
+static struct bpf_reg_state *get_dynptr_arg_reg(const struct bpf_func_pr=
oto *fn,
+						struct bpf_reg_state *regs)
+{
+	int i;
+
+	for (i =3D 0; i < MAX_BPF_FUNC_REG_ARGS; i++)
+		if (arg_type_is_dynptr(fn->arg_type[i]))
+			return &regs[BPF_REG_1 + i];
+
+	return NULL;
+}
+
+static enum bpf_dynptr_type stack_slot_get_dynptr_info(struct bpf_verifi=
er_env *env,
+						       struct bpf_reg_state *reg,
+						       int *ref_obj_id)
 {
 	struct bpf_func_state *state =3D func(env, reg);
 	int spi =3D get_spi(reg->off);
=20
-	return state->stack[spi].spilled_ptr.id;
+	if (ref_obj_id)
+		*ref_obj_id =3D state->stack[spi].spilled_ptr.id;
+
+	return state->stack[spi].spilled_ptr.dynptr.type;
 }
=20
 static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
@@ -6060,6 +6085,9 @@ static int check_func_arg(struct bpf_verifier_env *=
env, u32 arg,
 			case DYNPTR_TYPE_RINGBUF:
 				err_extra =3D "ringbuf ";
 				break;
+			case DYNPTR_TYPE_SKB:
+				err_extra =3D "skb ";
+				break;
 			default:
 				break;
 			}
@@ -6490,6 +6518,9 @@ static int check_func_proto(const struct bpf_func_p=
roto *fn, int func_id)
=20
 /* Packet data might have moved, any old PTR_TO_PACKET[_META,_END]
  * are now invalid, so turn them into unknown SCALAR_VALUE.
+ *
+ * This applies to dynptr slices belonging to skb dynptrs,
+ * since these slices point to packet data.
  */
 static void __clear_all_pkt_pointers(struct bpf_verifier_env *env,
 				     struct bpf_func_state *state)
@@ -6498,13 +6529,15 @@ static void __clear_all_pkt_pointers(struct bpf_v=
erifier_env *env,
 	int i;
=20
 	for (i =3D 0; i < MAX_BPF_REG; i++)
-		if (reg_is_pkt_pointer_any(&regs[i]))
+		if (reg_is_pkt_pointer_any(&regs[i]) ||
+		    reg_is_dynptr_slice_pkt(&regs[i]))
 			mark_reg_unknown(env, regs, i);
=20
 	bpf_for_each_spilled_reg(i, state, reg) {
 		if (!reg)
 			continue;
-		if (reg_is_pkt_pointer_any(reg))
+		if (reg_is_pkt_pointer_any(reg) ||
+		    reg_is_dynptr_slice_pkt(&regs[i]))
 			__mark_reg_unknown(env, reg);
 	}
 }
@@ -7166,6 +7199,7 @@ static int check_helper_call(struct bpf_verifier_en=
v *env, struct bpf_insn *insn
 			     int *insn_idx_p)
 {
 	enum bpf_prog_type prog_type =3D resolve_prog_type(env->prog);
+	enum bpf_dynptr_type dynptr_type =3D BPF_DYNPTR_TYPE_INVALID;
 	const struct bpf_func_proto *fn =3D NULL;
 	enum bpf_return_type ret_type;
 	enum bpf_type_flag ret_flag;
@@ -7339,23 +7373,42 @@ static int check_helper_call(struct bpf_verifier_=
env *env, struct bpf_insn *insn
 		}
 		break;
 	case BPF_FUNC_dynptr_data:
-		for (i =3D 0; i < MAX_BPF_FUNC_REG_ARGS; i++) {
-			if (arg_type_is_dynptr(fn->arg_type[i])) {
-				if (meta.ref_obj_id) {
-					verbose(env, "verifier internal error: meta.ref_obj_id already set\=
n");
-					return -EFAULT;
-				}
-				/* Find the id of the dynptr we're tracking the reference of */
-				meta.ref_obj_id =3D stack_slot_get_id(env, &regs[BPF_REG_1 + i]);
-				break;
-			}
-		}
-		if (i =3D=3D MAX_BPF_FUNC_REG_ARGS) {
+	{
+		struct bpf_reg_state *reg;
+
+		reg =3D get_dynptr_arg_reg(fn, regs);
+		if (!reg) {
 			verbose(env, "verifier internal error: no dynptr in bpf_dynptr_data()=
\n");
 			return -EFAULT;
 		}
+
+		if (meta.ref_obj_id) {
+			verbose(env, "verifier internal error: meta.ref_obj_id already set\n"=
);
+			return -EFAULT;
+		}
+
+		dynptr_type =3D stack_slot_get_dynptr_info(env, reg, &meta.ref_obj_id)=
;
 		break;
 	}
+	case BPF_FUNC_dynptr_write:
+	{
+		struct bpf_reg_state *reg;
+
+		reg =3D get_dynptr_arg_reg(fn, regs);
+		if (!reg) {
+			verbose(env, "verifier internal error: no dynptr in bpf_dynptr_write(=
)\n");
+			return -EFAULT;
+		}
+
+		/* bpf_dynptr_write() for skb-type dynptrs may pull the skb, so we mus=
t
+		 * invalidate all data slices associated with it
+		 */
+		if (stack_slot_get_dynptr_info(env, reg, NULL) =3D=3D BPF_DYNPTR_TYPE_=
SKB)
+			changes_data =3D true;
+
+		break;
+	}
+	}
=20
 	if (err)
 		return err;
@@ -7417,6 +7470,9 @@ static int check_helper_call(struct bpf_verifier_en=
v *env, struct bpf_insn *insn
 		mark_reg_known_zero(env, regs, BPF_REG_0);
 		regs[BPF_REG_0].type =3D PTR_TO_MEM | ret_flag;
 		regs[BPF_REG_0].mem_size =3D meta.mem_size;
+		if (func_id =3D=3D BPF_FUNC_dynptr_data &&
+		    dynptr_type =3D=3D BPF_DYNPTR_TYPE_SKB)
+			regs[BPF_REG_0].type |=3D DYNPTR_TYPE_SKB;
 		break;
 	case RET_PTR_TO_MEM_OR_BTF_ID:
 	{
diff --git a/net/core/filter.c b/net/core/filter.c
index 63e25d8ce501..0e2238516d8b 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -1681,8 +1681,8 @@ static inline void bpf_pull_mac_rcsum(struct sk_buf=
f *skb)
 		skb_postpull_rcsum(skb, skb_mac_header(skb), skb->mac_len);
 }
=20
-BPF_CALL_5(bpf_skb_store_bytes, struct sk_buff *, skb, u32, offset,
-	   const void *, from, u32, len, u64, flags)
+int __bpf_skb_store_bytes(struct sk_buff *skb, u32 offset, const void *f=
rom,
+			  u32 len, u64 flags)
 {
 	void *ptr;
=20
@@ -1707,6 +1707,12 @@ BPF_CALL_5(bpf_skb_store_bytes, struct sk_buff *, =
skb, u32, offset,
 	return 0;
 }
=20
+BPF_CALL_5(bpf_skb_store_bytes, struct sk_buff *, skb, u32, offset,
+	   const void *, from, u32, len, u64, flags)
+{
+	return __bpf_skb_store_bytes(skb, offset, from, len, flags);
+}
+
 static const struct bpf_func_proto bpf_skb_store_bytes_proto =3D {
 	.func		=3D bpf_skb_store_bytes,
 	.gpl_only	=3D false,
@@ -1718,8 +1724,7 @@ static const struct bpf_func_proto bpf_skb_store_by=
tes_proto =3D {
 	.arg5_type	=3D ARG_ANYTHING,
 };
=20
-BPF_CALL_4(bpf_skb_load_bytes, const struct sk_buff *, skb, u32, offset,
-	   void *, to, u32, len)
+int __bpf_skb_load_bytes(const struct sk_buff *skb, u32 offset, void *to=
, u32 len)
 {
 	void *ptr;
=20
@@ -1738,6 +1743,12 @@ BPF_CALL_4(bpf_skb_load_bytes, const struct sk_buf=
f *, skb, u32, offset,
 	return -EFAULT;
 }
=20
+BPF_CALL_4(bpf_skb_load_bytes, const struct sk_buff *, skb, u32, offset,
+	   void *, to, u32, len)
+{
+	return __bpf_skb_load_bytes(skb, offset, to, len);
+}
+
 static const struct bpf_func_proto bpf_skb_load_bytes_proto =3D {
 	.func		=3D bpf_skb_load_bytes,
 	.gpl_only	=3D false,
@@ -1849,6 +1860,51 @@ static const struct bpf_func_proto bpf_skb_pull_da=
ta_proto =3D {
 	.arg2_type	=3D ARG_ANYTHING,
 };
=20
+BPF_CALL_3(bpf_dynptr_from_skb_rdwr, struct sk_buff *, skb, u64, flags,
+	   struct bpf_dynptr_kern *, ptr)
+{
+	if (flags) {
+		bpf_dynptr_set_null(ptr);
+		return -EINVAL;
+	}
+
+	bpf_dynptr_init(ptr, skb, BPF_DYNPTR_TYPE_SKB, 0, skb->len);
+
+	return 0;
+}
+
+static const struct bpf_func_proto bpf_dynptr_from_skb_rdwr_proto =3D {
+	.func		=3D bpf_dynptr_from_skb_rdwr,
+	.gpl_only	=3D false,
+	.ret_type	=3D RET_INTEGER,
+	.arg1_type	=3D ARG_PTR_TO_CTX,
+	.arg2_type	=3D ARG_ANYTHING,
+	.arg3_type	=3D ARG_PTR_TO_DYNPTR | DYNPTR_TYPE_SKB | MEM_UNINIT,
+};
+
+BPF_CALL_3(bpf_dynptr_from_skb_rdonly, struct sk_buff *, skb, u64, flags=
,
+	   struct bpf_dynptr_kern *, ptr)
+{
+	int err;
+
+	err =3D ____bpf_dynptr_from_skb_rdwr(skb, flags, ptr);
+	if (err)
+		return err;
+
+	bpf_dynptr_set_rdonly(ptr);
+
+	return 0;
+}
+
+static const struct bpf_func_proto bpf_dynptr_from_skb_rdonly_proto =3D =
{
+	.func		=3D bpf_dynptr_from_skb_rdonly,
+	.gpl_only	=3D false,
+	.ret_type	=3D RET_INTEGER,
+	.arg1_type	=3D ARG_PTR_TO_CTX,
+	.arg2_type	=3D ARG_ANYTHING,
+	.arg3_type	=3D ARG_PTR_TO_DYNPTR | DYNPTR_TYPE_SKB | MEM_UNINIT,
+};
+
 BPF_CALL_1(bpf_sk_fullsock, struct sock *, sk)
 {
 	return sk_fullsock(sk) ? (unsigned long)sk : (unsigned long)NULL;
@@ -7704,6 +7760,8 @@ sk_filter_func_proto(enum bpf_func_id func_id, cons=
t struct bpf_prog *prog)
 		return &bpf_get_socket_uid_proto;
 	case BPF_FUNC_perf_event_output:
 		return &bpf_skb_event_output_proto;
+	case BPF_FUNC_dynptr_from_skb:
+		return &bpf_dynptr_from_skb_rdonly_proto;
 	default:
 		return bpf_sk_base_func_proto(func_id);
 	}
@@ -7891,6 +7949,8 @@ tc_cls_act_func_proto(enum bpf_func_id func_id, con=
st struct bpf_prog *prog)
 		return &bpf_tcp_raw_check_syncookie_ipv6_proto;
 #endif
 #endif
+	case BPF_FUNC_dynptr_from_skb:
+		return &bpf_dynptr_from_skb_rdwr_proto;
 	default:
 		return bpf_sk_base_func_proto(func_id);
 	}
@@ -8090,6 +8150,8 @@ sk_skb_func_proto(enum bpf_func_id func_id, const s=
truct bpf_prog *prog)
 	case BPF_FUNC_skc_lookup_tcp:
 		return &bpf_skc_lookup_tcp_proto;
 #endif
+	case BPF_FUNC_dynptr_from_skb:
+		return &bpf_dynptr_from_skb_rdwr_proto;
 	default:
 		return bpf_sk_base_func_proto(func_id);
 	}
@@ -8128,6 +8190,8 @@ lwt_out_func_proto(enum bpf_func_id func_id, const =
struct bpf_prog *prog)
 		return &bpf_get_smp_processor_id_proto;
 	case BPF_FUNC_skb_under_cgroup:
 		return &bpf_skb_under_cgroup_proto;
+	case BPF_FUNC_dynptr_from_skb:
+		return &bpf_dynptr_from_skb_rdonly_proto;
 	default:
 		return bpf_sk_base_func_proto(func_id);
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index f4ba82a1eace..52e891b00a35 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5284,22 +5284,44 @@ union bpf_attr {
  *	Description
  *		Write *len* bytes from *src* into *dst*, starting from *offset*
  *		into *dst*.
- *		*flags* is currently unused.
+ *
+ *		*flags* must be 0 except for skb-type dynptrs.
+ *
+ *		For skb-type dynptrs:
+ *		    *  All data slices of the dynptr are automatically
+ *		       invalidated after **bpf_dynptr_write**\ (). If you wish to
+ *		       avoid this, please perform the write using direct data slices
+ *		       instead.
+ *
+ *		    *  For *flags*, please see the flags accepted by
+ *		       **bpf_skb_store_bytes**\ ().
  *	Return
  *		0 on success, -E2BIG if *offset* + *len* exceeds the length
  *		of *dst*'s data, -EINVAL if *dst* is an invalid dynptr or if *dst*
- *		is a read-only dynptr or if *flags* is not 0.
+ *		is a read-only dynptr or if *flags* is not correct. For skb-type dyn=
ptrs,
+ *		other errors correspond to errors returned by **bpf_skb_store_bytes*=
*\ ().
  *
  * void *bpf_dynptr_data(struct bpf_dynptr *ptr, u32 offset, u32 len)
  *	Description
  *		Get a pointer to the underlying dynptr data.
  *
  *		*len* must be a statically known value. The returned data slice
- *		is invalidated whenever the dynptr is invalidated.
+ *		is invalidated whenever the dynptr is invalidated. If the dynptr
+ *		is read-only, this will return NULL.
+ *
+ *		For skb-type dynptrs:
+ *		    * If *offset* + *len* extends into the skb's paged buffers,
+ *		      the user should manually pull the skb with **bpf_skb_pull_data=
**\ ()
+ *		      and try again.
+ *
+ *		    * The data slice is automatically invalidated anytime
+ *		      **bpf_dynptr_write**\ () or a helper call that changes
+ *		      the underlying packet buffer (eg **bpf_skb_pull_data**\ ())
+ *		      is called.
  *	Return
  *		Pointer to the underlying dynptr data, NULL if the dynptr is
  *		read-only, if the dynptr is invalid, or if the offset and length
- *		is out of bounds.
+ *		is out of bounds or in a paged buffer for skb-type dynptrs.
  *
  * s64 bpf_tcp_raw_gen_syncookie_ipv4(struct iphdr *iph, struct tcphdr *=
th, u32 th_len)
  *	Description
@@ -5386,6 +5408,18 @@ union bpf_attr {
  *	Return
  *		Current *ktime*.
  *
+ * long bpf_dynptr_from_skb(struct sk_buff *skb, u64 flags, struct bpf_d=
ynptr *ptr)
+ *	Description
+ *		Get a dynptr to the data in *skb*. *skb* must be the BPF program
+ *		context. Depending on program type, the dynptr may be read-only.
+ *
+ *		Calls that change the *skb*'s underlying packet buffer
+ *		(eg **bpf_skb_pull_data**\ ()) do not invalidate the dynptr, but
+ *		they do invalidate any data slices associated with the dynptr.
+ *
+ *		*flags* is currently unused, it must be 0 for now.
+ *	Return
+ *		0 on success or -EINVAL if flags is not 0.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5597,6 +5631,7 @@ union bpf_attr {
 	FN(tcp_raw_check_syncookie_ipv4),	\
 	FN(tcp_raw_check_syncookie_ipv6),	\
 	FN(ktime_get_tai_ns),		\
+	FN(dynptr_from_skb),		\
 	/* */
=20
 /* integer value in 'imm' field of BPF_CALL instruction selects which he=
lper
--=20
2.30.2

