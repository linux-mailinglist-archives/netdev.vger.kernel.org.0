Return-Path: <netdev+bounces-2494-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DBAF170239E
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 07:51:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EBFC01C20976
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 05:51:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA27E3D64;
	Mon, 15 May 2023 05:51:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92FC4400
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 05:51:53 +0000 (UTC)
X-Greylist: delayed 3432 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 14 May 2023 22:51:29 PDT
Received: from a27-42.smtp-out.us-west-2.amazonses.com (a27-42.smtp-out.us-west-2.amazonses.com [54.240.27.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FF940DF
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 22:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=s25kmyuhzvo7troimxqpmtptpemzlc6l; d=exabit.dev; t=1684125268;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=SjA4EaCWPWL6OZBVB5Rud8Di4or9uoJm1afWFaPyX9c=;
	b=iVLtFZGcy72XM77Ym4DWxlRmSWZ6CkOm7NEvChgbS8ui1BeqoGzqJeBjJlXSRUxc
	/nAVxvtl7ALCDVCLb1S/pyfx6BKioFNjNcJqPQ4zoi+8bMzBD9rCyuXPwlgJE5kuSyF
	YI1xS3j4NqdJcTeYDN8XLOq5rNWOi4ADaIIAXelOhamvh1TuU7G8ijDGBOSYGiLEvLn
	YFbYw1qMERSm4wlpR0GK4mdBtHBjrrlOzrEDjrdPGDD+f0zB6nP2ZUbEMnq8oWY9/eY
	zhMNk8kxaFQLvsmKnXvlsMBtokI0DUtDShX3NLiC1Ljl6rfM1uGAJlwiaGj3UtenZfy
	Aova5BAOYA==
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1684125268;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Feedback-ID;
	bh=SjA4EaCWPWL6OZBVB5Rud8Di4or9uoJm1afWFaPyX9c=;
	b=T3MRTQRSgzyzheEUU3gNXVNnJUm+6t41rYP6bGnf2jJl/q9I7I5Kfj0EDZAkdC5P
	VH3QzbQ98eWQSsk6pLaPUTGno3VBtT9teOo/j5BpDHP0EUPOAoskUI9Knr5dfRh+8/P
	uEocbii0brG0h9m32oPf1bbdNe3DH4TKTxNZ3EmE=
From: FUJITA Tomonori <tomo@exabit.dev>
To: rust-for-linux@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-crypto@vger.kernel.org
Cc: FUJITA Tomonori <fujita.tomonori@gmail.com>
Subject: [PATCH 1/2] rust: add synchronous message digest support
Date: Mon, 15 May 2023 04:34:27 +0000
Message-ID: <010101881db037b4-c8c941a9-c482-4759-9c07-b8bf645d96ed-000000@us-west-2.amazonses.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230515043353.2324288-1-tomo@exabit.dev>
References: <20230515043353.2324288-1-tomo@exabit.dev>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Feedback-ID: 1.us-west-2.j0GTvY5MHQQ5Spu+i4ZGzzYI1gDE7m7iuMEacWMZbe8=:AmazonSES
X-SES-Outgoing: 2023.05.15-54.240.27.42
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_BL_SPAMCOP_NET,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: FUJITA Tomonori <fujita.tomonori@gmail.com>

Adds abstractions for crypto shash.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
---
 rust/bindings/bindings_helper.h |   1 +
 rust/helpers.c                  |  24 +++++++
 rust/kernel/crypto.rs           | 108 ++++++++++++++++++++++++++++++++
 rust/kernel/lib.rs              |   2 +
 4 files changed, 135 insertions(+)
 create mode 100644 rust/kernel/crypto.rs

diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index 50e7a76d5455..65683b9aa45d 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -6,6 +6,7 @@
  * Sorted alphabetically.
  */
 
+#include <crypto/hash.h>
 #include <linux/slab.h>
 #include <linux/refcount.h>
 #include <linux/wait.h>
diff --git a/rust/helpers.c b/rust/helpers.c
index 81e80261d597..03c131b1ca38 100644
--- a/rust/helpers.c
+++ b/rust/helpers.c
@@ -18,6 +18,7 @@
  * accidentally exposed.
  */
 
+#include <crypto/hash.h>
 #include <linux/bug.h>
 #include <linux/build_bug.h>
 #include <linux/err.h>
@@ -27,6 +28,29 @@
 #include <linux/sched/signal.h>
 #include <linux/wait.h>
 
+void rust_helper_crypto_free_shash(struct crypto_shash *tfm)
+{
+	crypto_free_shash(tfm);
+}
+EXPORT_SYMBOL_GPL(rust_helper_crypto_free_shash);
+
+unsigned int rust_helper_crypto_shash_digestsize(struct crypto_shash *tfm)
+{
+    return crypto_shash_digestsize(tfm);
+}
+EXPORT_SYMBOL_GPL(rust_helper_crypto_shash_digestsize);
+
+unsigned int rust_helper_crypto_shash_descsize(struct crypto_shash *tfm)
+{
+    return crypto_shash_descsize(tfm);
+}
+EXPORT_SYMBOL_GPL(rust_helper_crypto_shash_descsize);
+
+int rust_helper_crypto_shash_init(struct shash_desc *desc) {
+	return crypto_shash_init(desc);
+}
+EXPORT_SYMBOL_GPL(rust_helper_crypto_shash_init);
+
 __noreturn void rust_helper_BUG(void)
 {
 	BUG();
diff --git a/rust/kernel/crypto.rs b/rust/kernel/crypto.rs
new file mode 100644
index 000000000000..963487428525
--- /dev/null
+++ b/rust/kernel/crypto.rs
@@ -0,0 +1,108 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! Cryptography.
+//!
+//! C headers: [`include/crypto/hash.h`](../../../../include/crypto/hash.h)
+
+use crate::{
+    error::{from_err_ptr, to_result, Result},
+    str::CStr,
+};
+use alloc::alloc::{alloc, dealloc};
+use core::alloc::Layout;
+
+/// Represents `struct crypto_shash *`.
+///
+/// # Invariants
+///
+/// The pointer is valid.
+pub struct Shash(*mut bindings::crypto_shash);
+
+impl Drop for Shash {
+    fn drop(&mut self) {
+        // SAFETY: The type invariant guarantees that the pointer is valid.
+        unsafe { bindings::crypto_free_shash(self.0) }
+    }
+}
+
+impl Shash {
+    /// Creates a [`Shash`] object for a message digest handle.
+    pub fn new(name: &'static CStr, t: u32, mask: u32) -> Result<Shash> {
+        // SAFETY: FFI call.
+        let ptr =
+            unsafe { from_err_ptr(bindings::crypto_alloc_shash(name.as_char_ptr(), t, mask)) }?;
+        Ok(Self(ptr))
+    }
+
+    /// Sets optional key used by the hashing algorithm.
+    pub fn setkey(&mut self, data: &[u8]) -> Result {
+        // SAFETY: The type invariant guarantees that the pointer is valid.
+        to_result(unsafe {
+            bindings::crypto_shash_setkey(self.0, data.as_ptr(), data.len() as u32)
+        })
+    }
+
+    /// Returns the size of the result of the transformation.
+    pub fn digestsize(&self) -> u32 {
+        // SAFETY: The type invariant guarantees that the pointer is valid.
+        unsafe { bindings::crypto_shash_digestsize(self.0) }
+    }
+}
+
+/// Represents `struct shash_desc *`.
+///
+/// # Invariants
+///
+/// The field `ptr` is non-null and valid for the lifetime of the object.
+pub struct ShashDesc<'a> {
+    ptr: *mut bindings::shash_desc,
+    tfm: &'a Shash,
+    size: usize,
+}
+
+impl Drop for ShashDesc<'_> {
+    fn drop(&mut self) {
+        // SAFETY: The type invariant guarantees that the pointer is valid.
+        unsafe {
+            dealloc(
+                self.ptr.cast(),
+                Layout::from_size_align(self.size, 2).unwrap(),
+            );
+        }
+    }
+}
+
+impl<'a> ShashDesc<'a> {
+    /// Creates a [`ShashDesc`] object for a request data structure for message digest.
+    pub fn new(tfm: &'a Shash) -> Result<Self> {
+        // SAFETY: The type invariant guarantees that the pointer is valid.
+        let size = core::mem::size_of::<bindings::shash_desc>()
+            + unsafe { bindings::crypto_shash_descsize(tfm.0) } as usize;
+        let layout = Layout::from_size_align(size, 2)?;
+        let ptr = unsafe { alloc(layout) } as *mut bindings::shash_desc;
+        let mut desc = ShashDesc { ptr, tfm, size };
+        // SAFETY: The `desc.tfm` is non-null and valid for the lifetime of this object.
+        unsafe { (*desc.ptr).tfm = desc.tfm.0 };
+        Ok(desc)
+    }
+
+    /// (Re)initializes message digest.
+    pub fn init(&mut self) -> Result {
+        // SAFETY: The type invariant guarantees that the pointer is valid.
+        to_result(unsafe { bindings::crypto_shash_init(self.ptr) })
+    }
+
+    /// Adds data to message digest for processing.
+    pub fn update(&mut self, data: &[u8]) -> Result {
+        // SAFETY: The type invariant guarantees that the pointer is valid.
+        to_result(unsafe {
+            bindings::crypto_shash_update(self.ptr, data.as_ptr(), data.len() as u32)
+        })
+    }
+
+    /// Calculates message digest.
+    pub fn finalize(&mut self, output: &mut [u8]) -> Result {
+        // SAFETY: The type invariant guarantees that the pointer is valid.
+        to_result(unsafe { bindings::crypto_shash_final(self.ptr, output.as_mut_ptr()) })
+    }
+}
diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index 676995d4e460..753fd62b84f1 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -35,6 +35,8 @@ extern crate self as kernel;
 #[cfg(not(testlib))]
 mod allocator;
 mod build_assert;
+#[cfg(CONFIG_CRYPTO)]
+pub mod crypto;
 pub mod error;
 pub mod init;
 pub mod ioctl;
-- 
2.34.1


