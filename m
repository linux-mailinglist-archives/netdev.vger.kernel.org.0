Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 976482EADA5
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 15:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728343AbhAEOqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 09:46:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728261AbhAEOqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 09:46:21 -0500
Received: from gofer.mess.org (gofer.mess.org [IPv6:2a02:8011:d000:212::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B141C061793;
        Tue,  5 Jan 2021 06:45:40 -0800 (PST)
Received: by gofer.mess.org (Postfix, from userid 1000)
        id A116CC6380; Tue,  5 Jan 2021 14:45:34 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mess.org; s=2020;
        t=1609857934; bh=XyfV4MumL/vdwtEdKPZBJY4kmdUketFIHWUHfdh0BuQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ErXM3l7Zgw31/WIKGbDnhjDtvEYA4qSZDDBVeGs6DBjE/V2QFeNgxBvALHAo83/5H
         /xhfglSc2nGEo6Ai5YJZfOX22+E0tR1QPiIxPobFNFB1haTXCDXzcixB6O3D+wJTiH
         ZDestK4yYhPdfWQUncNdVsr5Io3G5Nw9G71ov5X2guulrdk05eBGk27QUWyOBkNWTW
         ebx7QQNiVL9/lCAwugKy3FiYSsSZQD5vTGNR5FpghyMY3S3RL3nulNG0MgT66S+yb4
         gOi4Cdo/JvBo541aNKlJbiVRfcKrPlMs69SWddya4cEN3joy5iUYNlXDEn322IEoRy
         Vu+BrGphjPZwg==
From:   Sean Young <sean@mess.org>
To:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Quentin Monnet <quentin@isovalent.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH v3 1/4] btf: add support for ints larger than 128 bits
Date:   Tue,  5 Jan 2021 14:45:31 +0000
Message-Id: <13cfab3593e0ea960ca732c259bfa60bf3c16b3b.1609855479.git.sean@mess.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1609855479.git.sean@mess.org>
References: <cover.1609855479.git.sean@mess.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

clang supports arbitrary length ints using the _ExtInt extension. This
can be useful to hold very large values, e.g. 256 bit or 512 bit types.

Larger types (e.g. 1024 bits) are possible but I am unaware of a use
case for these.

This requires the _ExtInt extension enabled in clang, which is under
review.

Link: https://clang.llvm.org/docs/LanguageExtensions.html#extended-integer-types
Link: https://reviews.llvm.org/D93103

Signed-off-by: Sean Young <sean@mess.org>
---
 Documentation/bpf/btf.rst      |  4 +--
 include/uapi/linux/btf.h       |  2 +-
 kernel/bpf/btf.c               | 54 ++++++++++++++++++++++++++++------
 tools/include/uapi/linux/btf.h |  2 +-
 4 files changed, 49 insertions(+), 13 deletions(-)

diff --git a/Documentation/bpf/btf.rst b/Documentation/bpf/btf.rst
index 44dc789de2b4..784f1743dbc7 100644
--- a/Documentation/bpf/btf.rst
+++ b/Documentation/bpf/btf.rst
@@ -132,7 +132,7 @@ The following sections detail encoding of each kind.
 
   #define BTF_INT_ENCODING(VAL)   (((VAL) & 0x0f000000) >> 24)
   #define BTF_INT_OFFSET(VAL)     (((VAL) & 0x00ff0000) >> 16)
-  #define BTF_INT_BITS(VAL)       ((VAL)  & 0x000000ff)
+  #define BTF_INT_BITS(VAL)       ((VAL)  & 0x000003ff)
 
 The ``BTF_INT_ENCODING`` has the following attributes::
 
@@ -147,7 +147,7 @@ pretty print. At most one encoding can be specified for the int type.
 The ``BTF_INT_BITS()`` specifies the number of actual bits held by this int
 type. For example, a 4-bit bitfield encodes ``BTF_INT_BITS()`` equals to 4.
 The ``btf_type.size * 8`` must be equal to or greater than ``BTF_INT_BITS()``
-for the type. The maximum value of ``BTF_INT_BITS()`` is 128.
+for the type. The maximum value of ``BTF_INT_BITS()`` is 512.
 
 The ``BTF_INT_OFFSET()`` specifies the starting bit offset to calculate values
 for this int. For example, a bitfield struct member has:
diff --git a/include/uapi/linux/btf.h b/include/uapi/linux/btf.h
index 5a667107ad2c..1696fd02b302 100644
--- a/include/uapi/linux/btf.h
+++ b/include/uapi/linux/btf.h
@@ -84,7 +84,7 @@ struct btf_type {
  */
 #define BTF_INT_ENCODING(VAL)	(((VAL) & 0x0f000000) >> 24)
 #define BTF_INT_OFFSET(VAL)	(((VAL) & 0x00ff0000) >> 16)
-#define BTF_INT_BITS(VAL)	((VAL)  & 0x000000ff)
+#define BTF_INT_BITS(VAL)	((VAL)  & 0x000003ff)
 
 /* Attributes stored in the BTF_INT_ENCODING */
 #define BTF_INT_SIGNED	(1 << 0)
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 8d6bdb4f4d61..44bc17207e9b 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -166,7 +166,8 @@
  *
  */
 
-#define BITS_PER_U128 (sizeof(u64) * BITS_PER_BYTE * 2)
+#define BITS_PER_U128 128
+#define BITS_PER_U512 512
 #define BITS_PER_BYTE_MASK (BITS_PER_BYTE - 1)
 #define BITS_PER_BYTE_MASKED(bits) ((bits) & BITS_PER_BYTE_MASK)
 #define BITS_ROUNDDOWN_BYTES(bits) ((bits) >> 3)
@@ -1907,9 +1908,9 @@ static int btf_int_check_member(struct btf_verifier_env *env,
 	nr_copy_bits = BTF_INT_BITS(int_data) +
 		BITS_PER_BYTE_MASKED(struct_bits_off);
 
-	if (nr_copy_bits > BITS_PER_U128) {
+	if (nr_copy_bits > BITS_PER_U512) {
 		btf_verifier_log_member(env, struct_type, member,
-					"nr_copy_bits exceeds 128");
+					"nr_copy_bits exceeds 512");
 		return -EINVAL;
 	}
 
@@ -1963,9 +1964,9 @@ static int btf_int_check_kflag_member(struct btf_verifier_env *env,
 
 	bytes_offset = BITS_ROUNDDOWN_BYTES(struct_bits_off);
 	nr_copy_bits = nr_bits + BITS_PER_BYTE_MASKED(struct_bits_off);
-	if (nr_copy_bits > BITS_PER_U128) {
+	if (nr_copy_bits > BITS_PER_U512) {
 		btf_verifier_log_member(env, struct_type, member,
-					"nr_copy_bits exceeds 128");
+					"nr_copy_bits exceeds 512");
 		return -EINVAL;
 	}
 
@@ -2012,9 +2013,9 @@ static s32 btf_int_check_meta(struct btf_verifier_env *env,
 
 	nr_bits = BTF_INT_BITS(int_data) + BTF_INT_OFFSET(int_data);
 
-	if (nr_bits > BITS_PER_U128) {
-		btf_verifier_log_type(env, t, "nr_bits exceeds %zu",
-				      BITS_PER_U128);
+	if (nr_bits > BITS_PER_U512) {
+		btf_verifier_log_type(env, t, "nr_bits exceeds %u",
+				      BITS_PER_U512);
 		return -EINVAL;
 	}
 
@@ -2080,6 +2081,37 @@ static void btf_int128_print(struct btf_show *show, void *data)
 				     lower_num);
 }
 
+static void btf_bigint_print(struct btf_show *show, void *data, u16 nr_bits)
+{
+	/* data points to 256 or 512 bit int type */
+	char buf[129];
+	int last_u64 = nr_bits / 64 - 1;
+	bool seen_nonzero = false;
+	int i;
+
+	for (i = 0; i <= last_u64; i++) {
+#ifdef __BIG_ENDIAN_BITFIELD
+		u64 v = ((u64 *)data)[i];
+#else
+		u64 v = ((u64 *)data)[last_u64 - i];
+#endif
+		if (!seen_nonzero) {
+			if (!v && i != last_u64)
+				continue;
+
+			snprintf(buf, sizeof(buf), "%llx", v);
+
+			seen_nonzero = true;
+		} else {
+			size_t off = strlen(buf);
+
+			snprintf(buf + off, sizeof(buf) - off, "%016llx", v);
+		}
+	}
+
+	btf_show_type_value(show, "0x%s", buf);
+}
+
 static void btf_int128_shift(u64 *print_num, u16 left_shift_bits,
 			     u16 right_shift_bits)
 {
@@ -2172,7 +2204,7 @@ static void btf_int_show(const struct btf *btf, const struct btf_type *t,
 	u32 int_data = btf_type_int(t);
 	u8 encoding = BTF_INT_ENCODING(int_data);
 	bool sign = encoding & BTF_INT_SIGNED;
-	u8 nr_bits = BTF_INT_BITS(int_data);
+	u16 nr_bits = BTF_INT_BITS(int_data);
 	void *safe_data;
 
 	safe_data = btf_show_start_type(show, t, type_id, data);
@@ -2186,6 +2218,10 @@ static void btf_int_show(const struct btf *btf, const struct btf_type *t,
 	}
 
 	switch (nr_bits) {
+	case 512:
+	case 256:
+		btf_bigint_print(show, safe_data, nr_bits);
+		break;
 	case 128:
 		btf_int128_print(show, safe_data);
 		break;
diff --git a/tools/include/uapi/linux/btf.h b/tools/include/uapi/linux/btf.h
index 5a667107ad2c..1696fd02b302 100644
--- a/tools/include/uapi/linux/btf.h
+++ b/tools/include/uapi/linux/btf.h
@@ -84,7 +84,7 @@ struct btf_type {
  */
 #define BTF_INT_ENCODING(VAL)	(((VAL) & 0x0f000000) >> 24)
 #define BTF_INT_OFFSET(VAL)	(((VAL) & 0x00ff0000) >> 16)
-#define BTF_INT_BITS(VAL)	((VAL)  & 0x000000ff)
+#define BTF_INT_BITS(VAL)	((VAL)  & 0x000003ff)
 
 /* Attributes stored in the BTF_INT_ENCODING */
 #define BTF_INT_SIGNED	(1 << 0)
-- 
2.29.2

