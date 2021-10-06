Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28A9B42392A
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 09:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237646AbhJFHtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 03:49:10 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:57108 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237470AbhJFHtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 03:49:09 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id F20D92032B;
        Wed,  6 Oct 2021 07:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1633506437; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=vC+peXbLyhoq34gt4sxSNbbrHWOmoJrZoXCJA5n8nTE=;
        b=sLQOXhEh339PQDju3r6xJSdrs8uugt0IbtE6JsxmVA839RSk5a4WiTWFEdXV9rguEVbK6A
        YhV7m53gqbB2pC41oeMpVRSsBQuFLNXHvurGAa550rRQpgAI/Eu5x9WUGUGU4TT90w3fg8
        5ZwMJU/5QOWGa65mV6PHBTuyxyWSYOI=
Received: from g78.suse.de (unknown [10.163.24.38])
        by relay2.suse.de (Postfix) with ESMTP id C1EA6A3B84;
        Wed,  6 Oct 2021 07:47:15 +0000 (UTC)
From:   Richard Palethorpe <rpalethorpe@suse.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Richard Palethorpe <rpalethorpe@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        rpalethorpe@richiejp.com
Subject: [PATCH] vsock: Handle compat 32-bit timeout
Date:   Wed,  6 Oct 2021 08:45:47 +0100
Message-Id: <20211006074547.14724-1-rpalethorpe@suse.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow 32-bit timevals to be used with a 64-bit kernel.

This allows the LTP regression test vsock01 to run without
modification in 32-bit compat mode.

Fixes: fe0c72f3db11 ("socket: move compat timeout handling into sock.c")
Signed-off-by: Richard Palethorpe <rpalethorpe@suse.com>

---

This is one of those fixes where I am not sure if we should just
change the test instead. Because it's not clear if someone is likely
to use vsock's in 32-bit compat mode?

 net/vmw_vsock/af_vsock.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 3e02cc3b24f8..6e9232adf8d0 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1616,7 +1616,16 @@ static int vsock_connectible_setsockopt(struct socket *sock,
 
 	case SO_VM_SOCKETS_CONNECT_TIMEOUT: {
 		struct __kernel_old_timeval tv;
-		COPY_IN(tv);
+		struct old_timeval32 tv32;
+
+		if (in_compat_syscall() && !COMPAT_USE_64BIT_TIME) {
+			COPY_IN(tv32);
+			tv.tv_sec = tv32.tv_sec;
+			tv.tv_usec = tv32.tv_usec;
+		} else {
+			COPY_IN(tv);
+		}
+
 		if (tv.tv_sec >= 0 && tv.tv_usec < USEC_PER_SEC &&
 		    tv.tv_sec < (MAX_SCHEDULE_TIMEOUT / HZ - 1)) {
 			vsk->connect_timeout = tv.tv_sec * HZ +
@@ -1694,11 +1703,20 @@ static int vsock_connectible_getsockopt(struct socket *sock,
 
 	case SO_VM_SOCKETS_CONNECT_TIMEOUT: {
 		struct __kernel_old_timeval tv;
+		struct old_timeval32 tv32;
+
 		tv.tv_sec = vsk->connect_timeout / HZ;
 		tv.tv_usec =
 		    (vsk->connect_timeout -
 		     tv.tv_sec * HZ) * (1000000 / HZ);
-		COPY_OUT(tv);
+
+		if (in_compat_syscall() && !COMPAT_USE_64BIT_TIME) {
+			tv32.tv_sec = (u32)tv.tv_sec;
+			tv32.tv_usec = (u32)tv.tv_usec;
+			COPY_OUT(tv32);
+		} else {
+			COPY_OUT(tv);
+		}
 		break;
 	}
 	default:
-- 
2.33.0

