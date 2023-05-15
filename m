Return-Path: <netdev+bounces-2492-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7173D70235C
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 07:36:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 787B71C20A47
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 05:36:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26DB51FC8;
	Mon, 15 May 2023 05:36:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B3410E6
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 05:36:07 +0000 (UTC)
X-Greylist: delayed 2364 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 14 May 2023 22:36:05 PDT
Received: from a27-27.smtp-out.us-west-2.amazonses.com (a27-27.smtp-out.us-west-2.amazonses.com [54.240.27.27])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5ADF172B;
	Sun, 14 May 2023 22:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=s25kmyuhzvo7troimxqpmtptpemzlc6l; d=exabit.dev; t=1684125268;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=r6c3/lQyX/E8+aAyavuFwemjmoLaGwLDqBf2HVjnXqo=;
	b=MKJCR5w8HKas5WBydD7nJeZUfb/O8YliJD8Owi57XZ6qjNWXFQf6zYXtS2vWrnVH
	O2uKeEXSJtzqiILyoxtWFWT767w0QQAtmTXrpSozIELgQ2ARYGzuK7Shz/jyncOLYEL
	mX3bM9SAAndF5wU7Jl4bhIJfudmEuwklUYnpKkLXEZ2ysSRut10TD18GXa99uRq2jxH
	FwaIFVGJ4qDnTzYG6EcshHEqCit0tTblkgqPa3iHEGYSt79QqHVHl37mvP9OCCr9I31
	+ag3ehjRKpaOlW8eqFagSq6IAdfleNHQijsP2JGQz3m1+T8ea1TeCa3bCvymLHLUALz
	SVpwYyfEGg==
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1684125268;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Feedback-ID;
	bh=r6c3/lQyX/E8+aAyavuFwemjmoLaGwLDqBf2HVjnXqo=;
	b=eYPk2n3tIFvCGvVeDC0uJb7+4G0iJo+BgAwof++3SLKsZXYYtWWreorFg/Ma+w3E
	/sLa1yoxtAdOZmEPtw5y5zGMoY1wcoeqmLYuMTzkdHXbmAkFDXCytQr1/1+3jHAQlBE
	E+WUKQ0ibt0zrpSzeuwkky/0cv+6yFUfB18OtoP0=
From: FUJITA Tomonori <tomo@exabit.dev>
To: rust-for-linux@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-crypto@vger.kernel.org
Cc: FUJITA Tomonori <fujita.tomonori@gmail.com>
Subject: [PATCH 2/2] rust: add socket support
Date: Mon, 15 May 2023 04:34:28 +0000
Message-ID: <010101881db03866-754b644c-682c-44be-8d8e-8376d34c77b3-000000@us-west-2.amazonses.com>
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
X-SES-Outgoing: 2023.05.15-54.240.27.27
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: FUJITA Tomonori <fujita.tomonori@gmail.com>

minimum abstraction for networking.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
---
 rust/bindings/bindings_helper.h |   3 +
 rust/kernel/lib.rs              |   2 +
 rust/kernel/net.rs              | 174 ++++++++++++++++++++++++++++++++
 3 files changed, 179 insertions(+)
 create mode 100644 rust/kernel/net.rs

diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index 65683b9aa45d..7cbb5dd96bf6 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -7,8 +7,11 @@
  */
 
 #include <crypto/hash.h>
+#include <linux/net.h>
 #include <linux/slab.h>
 #include <linux/refcount.h>
+#include <linux/socket.h>
+#include <linux/tcp.h>
 #include <linux/wait.h>
 #include <linux/sched.h>
 
diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index 753fd62b84f1..42dbef3d9e88 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -40,6 +40,8 @@ pub mod crypto;
 pub mod error;
 pub mod init;
 pub mod ioctl;
+#[cfg(CONFIG_NET)]
+pub mod net;
 pub mod prelude;
 pub mod print;
 mod static_assert;
diff --git a/rust/kernel/net.rs b/rust/kernel/net.rs
new file mode 100644
index 000000000000..204b5222abdc
--- /dev/null
+++ b/rust/kernel/net.rs
@@ -0,0 +1,174 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! Networking.
+//!
+//! C headers: [`include/linux/net.h`](../../../../include/linux/net.h),
+//! [`include/linux/socket.h`](../../../../include/linux/socket.h),
+
+use crate::{
+    bindings,
+    error::{to_result, Result},
+};
+use alloc::vec::Vec;
+
+/// Represents `struct socket *`.
+///
+/// # Invariants
+///
+/// The pointer is valid.
+pub struct Socket {
+    pub(crate) sock: *mut bindings::socket,
+}
+
+impl Drop for Socket {
+    fn drop(&mut self) {
+        // SAFETY: The type invariant guarantees that the pointer is valid.
+        unsafe { bindings::sock_release(self.sock) }
+    }
+}
+
+/// Address families. Defines AF_* here.
+pub enum Family {
+    /// Internet IP Protocol.
+    Ip = bindings::AF_INET as isize,
+}
+
+/// Communication type.
+pub enum SocketType {
+    /// Stream (connection).
+    Stream = bindings::sock_type_SOCK_STREAM as isize,
+}
+
+/// Protocols.
+pub enum Protocol {
+    /// Transmission Control Protocol.
+    Tcp = bindings::IPPROTO_TCP as isize,
+}
+
+impl Socket {
+    /// Creates a [`Socket`] object.
+    pub fn new(family: Family, sf: SocketType, proto: Protocol) -> Result<Self> {
+        let mut sock = core::ptr::null_mut();
+
+        // SAFETY: FFI call.
+        to_result(unsafe {
+            bindings::sock_create_kern(
+                &mut bindings::init_net,
+                family as _,
+                sf as _,
+                proto as _,
+                &mut sock,
+            )
+        })
+        .map(|_| Socket { sock })
+    }
+
+    /// Moves a socket to listening state.
+    pub fn listen(&mut self, backlog: i32) -> Result {
+        // SAFETY: The type invariant guarantees that the pointer is valid.
+        to_result(unsafe { bindings::kernel_listen(self.sock, backlog) })
+    }
+
+    /// Binds an address to a socket.
+    pub fn bind(&mut self, addr: &SocketAddr) -> Result {
+        let (addr, addrlen) = match addr {
+            SocketAddr::V4(addr) => (
+                addr as *const _ as _,
+                core::mem::size_of::<bindings::sockaddr>() as i32,
+            ),
+        };
+        // SAFETY: The type invariant guarantees that the pointer is valid.
+        to_result(unsafe { bindings::kernel_bind(self.sock, addr, addrlen) })
+    }
+
+    /// Accepts a connection
+    pub fn accept(&mut self) -> Result<Self> {
+        let mut client = core::ptr::null_mut();
+        // SAFETY: The type invariant guarantees that the pointer is valid.
+        to_result(unsafe { bindings::kernel_accept(self.sock, &mut client, 0) })
+            .map(|_| Socket { sock: client })
+    }
+
+    /// Receives a message from a socket.
+    pub fn recvmsg(&mut self, bufs: &mut [&mut [u8]], flags: i32) -> Result<usize> {
+        let mut msg = bindings::msghdr::default();
+        let mut kvec = Vec::try_with_capacity(bufs.len())?;
+        let mut len = 0;
+        for i in 0..bufs.len() {
+            len += bufs[i].len();
+            kvec.try_push(bindings::kvec {
+                iov_base: bufs[i].as_mut_ptr().cast(),
+                iov_len: bufs[i].len(),
+            })?;
+        }
+        // SAFETY: The type invariant guarantees that the pointer is valid.
+        let r = unsafe {
+            bindings::kernel_recvmsg(
+                self.sock,
+                &mut msg,
+                kvec.as_mut_ptr(),
+                bufs.len(),
+                len,
+                flags,
+            )
+        };
+        to_result(r).map(|_| r as usize)
+    }
+
+    /// Sends a message through a socket.
+    pub fn sendmsg(&mut self, bufs: &[&[u8]]) -> Result<usize> {
+        let mut msg = bindings::msghdr::default();
+        let mut kvec = Vec::try_with_capacity(bufs.len())?;
+        let mut len = 0;
+        for i in 0..bufs.len() {
+            len += bufs[i].len();
+            kvec.try_push(bindings::kvec {
+                iov_base: bufs[i].as_ptr() as *mut u8 as _,
+                iov_len: bufs[i].len(),
+            })?;
+        }
+        // SAFETY: The type invariant guarantees that the pointer is valid.
+        let r = unsafe {
+            bindings::kernel_sendmsg(self.sock, &mut msg, kvec.as_mut_ptr(), bufs.len(), len)
+        };
+        to_result(r).map(|_| r as usize)
+    }
+}
+
+/// A socket address.
+pub enum SocketAddr {
+    /// An IPv4 socket address.
+    V4(SocketAddrV4),
+}
+
+/// Represents `struct in_addr`.
+#[repr(transparent)]
+pub struct Ipv4Addr(bindings::in_addr);
+
+impl Ipv4Addr {
+    /// Creates a new IPv4 address from four eight-bit octets.
+    pub const fn new(a: u8, b: u8, c: u8, d: u8) -> Self {
+        Self(bindings::in_addr {
+            s_addr: u32::from_be_bytes([a, b, c, d]).to_be(),
+        })
+    }
+}
+
+/// Prepresents `struct sockaddr_in`.
+#[repr(transparent)]
+pub struct SocketAddrV4(bindings::sockaddr_in);
+
+impl SocketAddrV4 {
+    /// Creates a new IPv4 socket address.
+    pub const fn new(addr: Ipv4Addr, port: u16) -> Self {
+        Self(bindings::sockaddr_in {
+            sin_family: Family::Ip as _,
+            sin_port: port.to_be(),
+            sin_addr: addr.0,
+            __pad: [0; 8],
+        })
+    }
+}
+
+/// Waits for a full request
+pub const MSG_WAITALL: i32 = bindings::MSG_WAITALL as i32;
-- 
2.34.1


