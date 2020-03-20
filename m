Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7292A18D842
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 20:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbgCTTT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 15:19:26 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:42339 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727262AbgCTTTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 15:19:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584731964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=QRTCx7iUFxWApQLdwBhGyDxdNRfn8szKdemehtnU9Mo=;
        b=ggR+i7S3Iki1qc+G3FQjlgb5h8Lyxd+UsQ2u3eIR5Sa8XsSwp0agAYO5NBacKS0j8JwVdU
        0oWuZmQ+4q8ZIJUSBUZCMMciPGyEpNVlV5ZxEZYq19RmYEb4n8w1oIb8/CNg4xKFzJbdyT
        qcFm/xEJ0hDKYEIsdpo6dPvAUoJbQ5k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-oi80VyK-P_SJHLTY9NPDjQ-1; Fri, 20 Mar 2020 15:19:22 -0400
X-MC-Unique: oi80VyK-P_SJHLTY9NPDjQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1C1A1800D53;
        Fri, 20 Mar 2020 19:19:20 +0000 (UTC)
Received: from llong.com (ovpn-118-190.rdu2.redhat.com [10.10.118.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 308A45C1AB;
        Fri, 20 Mar 2020 19:19:18 +0000 (UTC)
From:   Waiman Long <longman@redhat.com>
To:     David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     keyrings@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org, netdev@vger.kernel.org,
        linux-afs@lists.infradead.org, Sumit Garg <sumit.garg@linaro.org>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Eric Biggers <ebiggers@google.com>,
        Chris von Recklinghausen <crecklin@redhat.com>,
        Waiman Long <longman@redhat.com>
Subject: [PATCH v6 2/2] KEYS: Avoid false positive ENOMEM error on key read
Date:   Fri, 20 Mar 2020 15:19:03 -0400
Message-Id: <20200320191903.19494-3-longman@redhat.com>
In-Reply-To: <20200320191903.19494-1-longman@redhat.com>
References: <20200320191903.19494-1-longman@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By allocating a kernel buffer with a user-supplied buffer length, it
is possible that a false positive ENOMEM error may be returned because
the user-supplied length is just too large even if the system do have
enough memory to hold the actual key data.

Moreover, if the buffer length is larger than the maximum amount of
memory that can be returned by kmalloc() (2^(MAX_ORDER-1) number of
pages), a warning message will also be printed.

To reduce this possibility, we set a threshold (page size) over which we
do check the actual key length first before allocating a buffer of the
right size to hold it. The threshold is arbitrary, it is just used to
trigger a buffer length check. It does not limit the actual key length
as long as there is enough memory to satisfy the memory request.

To further avoid large buffer allocation failure due to page
fragmentation, kvmalloc() is used to allocate the buffer so that vmapped
pages can be used when there is not a large enough contiguous set of
pages available for allocation.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 security/keys/internal.h | 12 ++++++++++++
 security/keys/keyctl.c   | 39 +++++++++++++++++++++++++++++++--------
 2 files changed, 43 insertions(+), 8 deletions(-)

diff --git a/security/keys/internal.h b/security/keys/internal.h
index ba3e2da14cef..6d0ca48ae9a5 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -16,6 +16,8 @@
 #include <linux/keyctl.h>
 #include <linux/refcount.h>
 #include <linux/compat.h>
+#include <linux/mm.h>
+#include <linux/vmalloc.h>
 
 struct iovec;
 
@@ -349,4 +351,14 @@ static inline void key_check(const struct key *key)
 
 #endif
 
+/*
+ * Helper function to clear and free a kvmalloc'ed memory object.
+ */
+static inline void __kvzfree(const void *addr, size_t len)
+{
+	if (addr) {
+		memset((void *)addr, 0, len);
+		kvfree(addr);
+	}
+}
 #endif /* _INTERNAL_H */
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 5a0794cb8815..ded69108db0d 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -339,7 +339,7 @@ long keyctl_update_key(key_serial_t id,
 	payload = NULL;
 	if (plen) {
 		ret = -ENOMEM;
-		payload = kmalloc(plen, GFP_KERNEL);
+		payload = kvmalloc(plen, GFP_KERNEL);
 		if (!payload)
 			goto error;
 
@@ -360,7 +360,7 @@ long keyctl_update_key(key_serial_t id,
 
 	key_ref_put(key_ref);
 error2:
-	kzfree(payload);
+	__kvzfree(payload, plen);
 error:
 	return ret;
 }
@@ -877,13 +877,23 @@ long keyctl_read_key(key_serial_t keyid, char __user *buffer, size_t buflen)
 		 * transferring them to user buffer to avoid potential
 		 * deadlock involving page fault and mmap_sem.
 		 */
-		char *key_data = kmalloc(buflen, GFP_KERNEL);
+		char *key_data = NULL;
+		size_t key_data_len = buflen;
 
-		if (!key_data) {
-			ret = -ENOMEM;
-			goto error2;
+		/*
+		 * When the user-supplied key length is larger than
+		 * PAGE_SIZE, we get the actual key length first before
+		 * allocating a right-sized key data buffer.
+		 */
+		if (buflen <= PAGE_SIZE) {
+allocbuf:
+			key_data = kvmalloc(key_data_len, GFP_KERNEL);
+			if (!key_data) {
+				ret = -ENOMEM;
+				goto error2;
+			}
 		}
-		ret = __keyctl_read_key(key, key_data, buflen);
+		ret = __keyctl_read_key(key, key_data, key_data_len);
 
 		/*
 		 * Read methods will just return the required length
@@ -891,10 +901,23 @@ long keyctl_read_key(key_serial_t keyid, char __user *buffer, size_t buflen)
 		 * enough.
 		 */
 		if (ret > 0 && ret <= buflen) {
+			/*
+			 * The key may change (unlikely) in between 2
+			 * consecutive __keyctl_read_key() calls. We will
+			 * need to allocate a larger buffer and redo the key
+			 * read when key_data_len < ret <= buflen.
+			 */
+			if (!key_data || unlikely(ret > key_data_len)) {
+				if (unlikely(key_data))
+					__kvzfree(key_data, key_data_len);
+				key_data_len = ret;
+				goto allocbuf;
+			}
+
 			if (copy_to_user(buffer, key_data, ret))
 				ret = -EFAULT;
 		}
-		kzfree(key_data);
+		__kvzfree(key_data, key_data_len);
 	}
 
 error2:
-- 
2.18.1

