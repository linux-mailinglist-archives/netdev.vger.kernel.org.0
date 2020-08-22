Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1F524E4D6
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 05:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbgHVD27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 23:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbgHVD24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 23:28:56 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D87C061573
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 20:28:56 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id 93so3185942otx.2
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 20:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tfz-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kNFvTy16HpOVCNdGxD9ipIrzab+Hn9l1juY0UXcBGUU=;
        b=gVXwQ3IqLVRndDQQiR+X5uO++U2rn3k5Shfn1C8IyWEWPZdGckHmAXbGg5EAnA6yEG
         QCZuBiqCjzOYp14+VObQ0kiI4QdljhDVe+Go57c0Ff6gfBwP0MyX2ucT0vjUnW8ao4sU
         raOEj+gWbemAEEQjmkMC8CXRMWZh5sjZACKgiGRlbiner+oWKr4e1hs2gI9ZxgUSuf68
         kaWaiXHjpzaf4VPs5I4rqUro084kUhYNKiBeU563V5/dfm6xxnhrB5WDozjrH8LeoGFm
         Ef7H/6piJyl5TV7O2g+uZ3kEXM8ChFuEHtYwD76GavumfXlsUj0yfQc08GWlXInC90n3
         MnCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kNFvTy16HpOVCNdGxD9ipIrzab+Hn9l1juY0UXcBGUU=;
        b=kyDWWbosJ7nx3U/A6juOg3Z+XgdVeCqC+oTRXkm9c2wymcL0wLcKHXG9a2XLlmoM6q
         fmopQb/iRCyjDxyvlsLmxEPH1ay0FBwvH1tG1NZCLm7eNEQnSAemdudYZ+A+N240iRzL
         6g7eM46YH6cTIA1/U5yaDslhiW5y12edEvo7ce213HLcxnlFXQ2YqQag521mctMwQC+N
         684KXqLM79vvZ9ZPD4pbKWDS1tVhS6FeQ3aav/m+fmYaOYRt72EP39t0/oU8Wgq1W2rr
         Rr6Ew6T3Q7TG+eXyeTQybwi4WnTzlwKsG7AYpU1WT/xbPk7kWNqZp9iW34uAMb55Sxcq
         U0Bg==
X-Gm-Message-State: AOAM532Lr0CxCbidnBqhSEhJJLI3++Q5aLBp2cgUJChv5gSkdbrWdbAg
        Cjm4XHcBGzgHn8XhFb/tgcjiHw==
X-Google-Smtp-Source: ABdhPJwIm0yvUYt8KDlaMjTXWuFtdodXn+S1MItqOwjr25MersCZGDL9EAUlvwc8QDZC+kVrOmp9Wg==
X-Received: by 2002:a9d:685a:: with SMTP id c26mr4454908oto.244.1598066935504;
        Fri, 21 Aug 2020 20:28:55 -0700 (PDT)
Received: from foo.attlocal.net (108-232-117-128.lightspeed.sntcca.sbcglobal.net. [108.232.117.128])
        by smtp.gmail.com with ESMTPSA id o3sm829431oom.26.2020.08.21.20.28.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 20:28:54 -0700 (PDT)
From:   Pascal Bouchareine <kalou@tfz.net>
To:     linux-kernel@vger.kernel.org
Cc:     Pascal Bouchareine <kalou@tfz.net>, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Alexey Dobriyan" <adobriyan@gmail.com>,
        "Al Viro" <viro@zeniv.linux.org.uk>
Subject: [PATCH v2 1/2] mm: add GFP mask param to strndup_user
Date:   Fri, 21 Aug 2020 20:28:26 -0700
Message-Id: <20200822032827.6386-1-kalou@tfz.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200815182344.7469-1-kalou@tfz.net>
References: <20200815182344.7469-1-kalou@tfz.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let caller specify allocation.
Preserve existing calls with GFP_USER.

Signed-off-by: Pascal Bouchareine <kalou@tfz.net>
---

Updating patch 1/ and 2/ to address comments

 drivers/dma-buf/dma-buf.c                  |  2 +-
 drivers/gpu/drm/i915/i915_debugfs_params.c |  2 +-
 drivers/gpu/drm/vc4/vc4_bo.c               |  3 +-
 drivers/input/misc/uinput.c                |  2 +-
 drivers/s390/char/keyboard.c               |  3 +-
 drivers/vfio/vfio.c                        |  3 +-
 drivers/virt/fsl_hypervisor.c              |  4 +--
 fs/f2fs/file.c                             |  3 +-
 fs/fsopen.c                                |  6 ++--
 fs/namespace.c                             |  2 +-
 fs/nfs/fs_context.c                        |  8 +++--
 fs/xfs/xfs_ioctl.c                         |  2 +-
 include/linux/string.h                     |  2 +-
 kernel/events/core.c                       |  2 +-
 kernel/module.c                            |  2 +-
 kernel/trace/trace_event_perf.c            |  2 +-
 mm/util.c                                  | 36 ++++++++++++++--------
 net/core/pktgen.c                          |  2 +-
 security/keys/dh.c                         |  3 +-
 security/keys/keyctl.c                     | 17 ++++++----
 security/keys/keyctl_pkey.c                |  2 +-
 21 files changed, 65 insertions(+), 43 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 1ca609f66fdf..3d94ba811f4b 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -326,7 +326,7 @@ static __poll_t dma_buf_poll(struct file *file, poll_table *poll)
  */
 static long dma_buf_set_name(struct dma_buf *dmabuf, const char __user *buf)
 {
-	char *name = strndup_user(buf, DMA_BUF_NAME_LEN);
+	char *name = strndup_user(buf, DMA_BUF_NAME_LEN, GFP_USER);
 	long ret = 0;
 
 	if (IS_ERR(name))
diff --git a/drivers/gpu/drm/i915/i915_debugfs_params.c b/drivers/gpu/drm/i915/i915_debugfs_params.c
index 62b2c5f0495d..4c0a77e15c09 100644
--- a/drivers/gpu/drm/i915/i915_debugfs_params.c
+++ b/drivers/gpu/drm/i915/i915_debugfs_params.c
@@ -142,7 +142,7 @@ static ssize_t i915_param_charp_write(struct file *file,
 	kernel_param_lock(THIS_MODULE);
 
 	old = *s;
-	new = strndup_user(ubuf, PAGE_SIZE);
+	new = strndup_user(ubuf, PAGE_SIZE, GFP_USER);
 	if (IS_ERR(new)) {
 		len = PTR_ERR(new);
 		goto out;
diff --git a/drivers/gpu/drm/vc4/vc4_bo.c b/drivers/gpu/drm/vc4/vc4_bo.c
index 72d30d90b856..deb2c4957a6f 100644
--- a/drivers/gpu/drm/vc4/vc4_bo.c
+++ b/drivers/gpu/drm/vc4/vc4_bo.c
@@ -1072,7 +1072,8 @@ int vc4_label_bo_ioctl(struct drm_device *dev, void *data,
 	if (!args->len)
 		return -EINVAL;
 
-	name = strndup_user(u64_to_user_ptr(args->name), args->len + 1);
+	name = strndup_user(u64_to_user_ptr(args->name), args->len + 1,
+				GFP_USER);
 	if (IS_ERR(name))
 		return PTR_ERR(name);
 
diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
index f2593133e524..11627a4b4d87 100644
--- a/drivers/input/misc/uinput.c
+++ b/drivers/input/misc/uinput.c
@@ -926,7 +926,7 @@ static long uinput_ioctl_handler(struct file *file, unsigned int cmd,
 			goto out;
 		}
 
-		phys = strndup_user(p, 1024);
+		phys = strndup_user(p, 1024, GFP_USER);
 		if (IS_ERR(phys)) {
 			retval = PTR_ERR(phys);
 			goto out;
diff --git a/drivers/s390/char/keyboard.c b/drivers/s390/char/keyboard.c
index 567aedc03c76..8e58921d5db4 100644
--- a/drivers/s390/char/keyboard.c
+++ b/drivers/s390/char/keyboard.c
@@ -464,7 +464,8 @@ do_kdgkb_ioctl(struct kbd_data *kbd, struct kbsentry __user *u_kbs,
 	case KDSKBSENT:
 		if (!perm)
 			return -EPERM;
-		p = strndup_user(u_kbs->kb_string, sizeof(u_kbs->kb_string));
+		p = strndup_user(u_kbs->kb_string,
+			sizeof(u_kbs->kb_string), GFP_USER);
 		if (IS_ERR(p))
 			return PTR_ERR(p);
 		kfree(kbd->func_table[kb_func]);
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 580099afeaff..d55aae6661eb 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1547,7 +1547,8 @@ static long vfio_group_fops_unl_ioctl(struct file *filep,
 	{
 		char *buf;
 
-		buf = strndup_user((const char __user *)arg, PAGE_SIZE);
+		buf = strndup_user((const char __user *)arg, PAGE_SIZE,
+					GFP_USER);
 		if (IS_ERR(buf))
 			return PTR_ERR(buf);
 
diff --git a/drivers/virt/fsl_hypervisor.c b/drivers/virt/fsl_hypervisor.c
index 1b0b11b55d2a..142c74aab2b0 100644
--- a/drivers/virt/fsl_hypervisor.c
+++ b/drivers/virt/fsl_hypervisor.c
@@ -346,11 +346,11 @@ static long ioctl_dtprop(struct fsl_hv_ioctl_prop __user *p, int set)
 	upropname = (char __user *)(uintptr_t)param.propname;
 	upropval = (void __user *)(uintptr_t)param.propval;
 
-	path = strndup_user(upath, FH_DTPROP_MAX_PATHLEN);
+	path = strndup_user(upath, FH_DTPROP_MAX_PATHLEN, GFP_USER);
 	if (IS_ERR(path))
 		return PTR_ERR(path);
 
-	propname = strndup_user(upropname, FH_DTPROP_MAX_PATHLEN);
+	propname = strndup_user(upropname, FH_DTPROP_MAX_PATHLEN, GFP_USER);
 	if (IS_ERR(propname)) {
 		ret = PTR_ERR(propname);
 		goto err_free_path;
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 3268f8dd59bb..ce37a97fbca7 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -3395,7 +3395,8 @@ static int f2fs_set_volume_name(struct file *filp, unsigned long arg)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	vbuf = strndup_user((const char __user *)arg, FSLABEL_MAX);
+	vbuf = strndup_user((const char __user *)arg, FSLABEL_MAX,
+				GFP_USER);
 	if (IS_ERR(vbuf))
 		return PTR_ERR(vbuf);
 
diff --git a/fs/fsopen.c b/fs/fsopen.c
index 2fa3f241b762..c17ef9ee455c 100644
--- a/fs/fsopen.c
+++ b/fs/fsopen.c
@@ -125,7 +125,7 @@ SYSCALL_DEFINE2(fsopen, const char __user *, _fs_name, unsigned int, flags)
 	if (flags & ~FSOPEN_CLOEXEC)
 		return -EINVAL;
 
-	fs_name = strndup_user(_fs_name, PAGE_SIZE);
+	fs_name = strndup_user(_fs_name, PAGE_SIZE, GFP_USER);
 	if (IS_ERR(fs_name))
 		return PTR_ERR(fs_name);
 
@@ -381,7 +381,7 @@ SYSCALL_DEFINE5(fsconfig,
 	}
 
 	if (_key) {
-		param.key = strndup_user(_key, 256);
+		param.key = strndup_user(_key, 256, GFP_USER);
 		if (IS_ERR(param.key)) {
 			ret = PTR_ERR(param.key);
 			goto out_f;
@@ -394,7 +394,7 @@ SYSCALL_DEFINE5(fsconfig,
 		break;
 	case FSCONFIG_SET_STRING:
 		param.type = fs_value_is_string;
-		param.string = strndup_user(_value, 256);
+		param.string = strndup_user(_value, 256, GFP_USER);
 		if (IS_ERR(param.string)) {
 			ret = PTR_ERR(param.string);
 			goto out_key;
diff --git a/fs/namespace.c b/fs/namespace.c
index 4a0f600a3328..1d9da91fbd2e 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3099,7 +3099,7 @@ void *copy_mount_options(const void __user * data)
 
 char *copy_mount_string(const void __user *data)
 {
-	return data ? strndup_user(data, PATH_MAX) : NULL;
+	return data ? strndup_user(data, PATH_MAX, GFP_USER) : NULL;
 }
 
 /*
diff --git a/fs/nfs/fs_context.c b/fs/nfs/fs_context.c
index ccc88be88d6a..fcdaeca51ca9 100644
--- a/fs/nfs/fs_context.c
+++ b/fs/nfs/fs_context.c
@@ -1077,18 +1077,20 @@ static int nfs4_parse_monolithic(struct fs_context *fc,
 		} else
 			ctx->selected_flavor = RPC_AUTH_UNIX;
 
-		c = strndup_user(data->hostname.data, NFS4_MAXNAMLEN);
+		c = strndup_user(data->hostname.data, NFS4_MAXNAMLEN,
+					GFP_USER);
 		if (IS_ERR(c))
 			return PTR_ERR(c);
 		ctx->nfs_server.hostname = c;
 
-		c = strndup_user(data->mnt_path.data, NFS4_MAXPATHLEN);
+		c = strndup_user(data->mnt_path.data, NFS4_MAXPATHLEN,
+					GFP_USER);
 		if (IS_ERR(c))
 			return PTR_ERR(c);
 		ctx->nfs_server.export_path = c;
 		dfprintk(MOUNT, "NFS: MNTPATH: '%s'\n", c);
 
-		c = strndup_user(data->client_addr.data, 16);
+		c = strndup_user(data->client_addr.data, 16, GFP_USER);
 		if (IS_ERR(c))
 			return PTR_ERR(c);
 		ctx->client_address = c;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index a190212ca85d..216ab920c6b3 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -546,7 +546,7 @@ xfs_ioc_attrmulti_one(
 	if ((flags & XFS_IOC_ATTR_ROOT) && (flags & XFS_IOC_ATTR_SECURE))
 		return -EINVAL;
 
-	name = strndup_user(uname, MAXNAMELEN);
+	name = strndup_user(uname, MAXNAMELEN, GFP_USER);
 	if (IS_ERR(name))
 		return PTR_ERR(name);
 
diff --git a/include/linux/string.h b/include/linux/string.h
index 9b7a0632e87a..3eb69aee484d 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -9,7 +9,7 @@
 #include <stdarg.h>
 #include <uapi/linux/string.h>
 
-extern char *strndup_user(const char __user *, long);
+extern char *strndup_user(const char __user *, long, gfp_t);
 extern void *memdup_user(const void __user *, size_t);
 extern void *vmemdup_user(const void __user *, size_t);
 extern void *memdup_user_nul(const void __user *, size_t);
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 856d98c36f56..3b0621563d7f 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -10072,7 +10072,7 @@ static int perf_event_set_filter(struct perf_event *event, void __user *arg)
 	int ret = -EINVAL;
 	char *filter_str;
 
-	filter_str = strndup_user(arg, PAGE_SIZE);
+	filter_str = strndup_user(arg, PAGE_SIZE, GFP_USER);
 	if (IS_ERR(filter_str))
 		return PTR_ERR(filter_str);
 
diff --git a/kernel/module.c b/kernel/module.c
index aa183c9ac0a2..566c9ddb86d3 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3872,7 +3872,7 @@ static int load_module(struct load_info *info, const char __user *uargs,
 	flush_module_icache(mod);
 
 	/* Now copy in args */
-	mod->args = strndup_user(uargs, ~0UL >> 1);
+	mod->args = strndup_user(uargs, ~0UL >> 1, GFP_USER);
 	if (IS_ERR(mod->args)) {
 		err = PTR_ERR(mod->args);
 		goto free_arch_cleanup;
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 643e0b19920d..48569b39d1f2 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -310,7 +310,7 @@ int perf_uprobe_init(struct perf_event *p_event,
 		return -EINVAL;
 
 	path = strndup_user(u64_to_user_ptr(p_event->attr.uprobe_path),
-			    PATH_MAX);
+			    PATH_MAX, GFP_USER);
 	if (IS_ERR(path)) {
 		ret = PTR_ERR(path);
 		return (ret == -EINVAL) ? -E2BIG : ret;
diff --git a/mm/util.c b/mm/util.c
index c63c8e47be57..14b56daa8fba 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -156,20 +156,15 @@ char *kmemdup_nul(const char *s, size_t len, gfp_t gfp)
 }
 EXPORT_SYMBOL(kmemdup_nul);
 
-/**
- * memdup_user - duplicate memory region from user space
- *
- * @src: source address in user space
- * @len: number of bytes to copy
- *
- * Return: an ERR_PTR() on failure.  Result is physically
- * contiguous, to be freed by kfree().
- */
-void *memdup_user(const void __user *src, size_t len)
+static inline void *__memdup_user_flags(const void __user *src, size_t len,
+	gfp_t gfp)
 {
 	void *p;
 
-	p = kmalloc_track_caller(len, GFP_USER | __GFP_NOWARN);
+	BUG_ON(gfp & __GFP_ATOMIC);
+
+	/* Don't let users spam with big allocs and use GFP_NOWARN */
+	p = kmalloc_track_caller(len, __GFP_NOWARN | gfp);
 	if (!p)
 		return ERR_PTR(-ENOMEM);
 
@@ -180,6 +175,20 @@ void *memdup_user(const void __user *src, size_t len)
 
 	return p;
 }
+
+/**
+ * memdup_user - duplicate memory region from user space
+ *
+ * @src: source address in user space
+ * @len: number of bytes to copy
+ *
+ * Return: an ERR_PTR() on failure.  Result is physically
+ * contiguous, to be freed by kfree().
+ */
+void *memdup_user(const void __user *src, size_t len)
+{
+	return __memdup_user_flags(src, len, GFP_USER);
+}
 EXPORT_SYMBOL(memdup_user);
 
 /**
@@ -212,10 +221,11 @@ EXPORT_SYMBOL(vmemdup_user);
  * strndup_user - duplicate an existing string from user space
  * @s: The string to duplicate
  * @n: Maximum number of bytes to copy, including the trailing NUL.
+ * @gfp: the GFP mask used in the kmalloc() call when allocating memory
  *
  * Return: newly allocated copy of @s or an ERR_PTR() in case of error
  */
-char *strndup_user(const char __user *s, long n)
+char *strndup_user(const char __user *s, long n, gfp_t gfp)
 {
 	char *p;
 	long length;
@@ -228,7 +238,7 @@ char *strndup_user(const char __user *s, long n)
 	if (length > n)
 		return ERR_PTR(-EINVAL);
 
-	p = memdup_user(s, length);
+	p = __memdup_user_flags(s, length, gfp);
 
 	if (IS_ERR(p))
 		return p;
diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index b53b6d38c4df..ed12433e194a 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -901,7 +901,7 @@ static ssize_t pktgen_if_write(struct file *file,
 
 	if (debug) {
 		size_t copy = min_t(size_t, count + 1, 1024);
-		char *tp = strndup_user(user_buffer, copy);
+		char *tp = strndup_user(user_buffer, copy, GFP_USER);
 
 		if (IS_ERR(tp))
 			return PTR_ERR(tp);
diff --git a/security/keys/dh.c b/security/keys/dh.c
index c4c629bb1c03..fada6015b25b 100644
--- a/security/keys/dh.c
+++ b/security/keys/dh.c
@@ -266,7 +266,8 @@ long __keyctl_dh_compute(struct keyctl_dh_params __user *params,
 		}
 
 		/* get KDF name string */
-		hashname = strndup_user(kdfcopy->hashname, CRYPTO_MAX_ALG_NAME);
+		hashname = strndup_user(kdfcopy->hashname,
+				CRYPTO_MAX_ALG_NAME, GFP_USER);
 		if (IS_ERR(hashname)) {
 			ret = PTR_ERR(hashname);
 			goto out1;
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 9febd37a168f..0f74097cdcd1 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -93,7 +93,8 @@ SYSCALL_DEFINE5(add_key, const char __user *, _type,
 
 	description = NULL;
 	if (_description) {
-		description = strndup_user(_description, KEY_MAX_DESC_SIZE);
+		description = strndup_user(_description,
+				KEY_MAX_DESC_SIZE, GFP_USER);
 		if (IS_ERR(description)) {
 			ret = PTR_ERR(description);
 			goto error;
@@ -182,7 +183,8 @@ SYSCALL_DEFINE4(request_key, const char __user *, _type,
 		goto error;
 
 	/* pull the description into kernel space */
-	description = strndup_user(_description, KEY_MAX_DESC_SIZE);
+	description = strndup_user(_description, KEY_MAX_DESC_SIZE,
+				GFP_USER);
 	if (IS_ERR(description)) {
 		ret = PTR_ERR(description);
 		goto error;
@@ -192,7 +194,8 @@ SYSCALL_DEFINE4(request_key, const char __user *, _type,
 	callout_info = NULL;
 	callout_len = 0;
 	if (_callout_info) {
-		callout_info = strndup_user(_callout_info, PAGE_SIZE);
+		callout_info = strndup_user(_callout_info, PAGE_SIZE,
+					GFP_USER);
 		if (IS_ERR(callout_info)) {
 			ret = PTR_ERR(callout_info);
 			goto error2;
@@ -293,7 +296,7 @@ long keyctl_join_session_keyring(const char __user *_name)
 	/* fetch the name from userspace */
 	name = NULL;
 	if (_name) {
-		name = strndup_user(_name, KEY_MAX_DESC_SIZE);
+		name = strndup_user(_name, KEY_MAX_DESC_SIZE, GFP_USER);
 		if (IS_ERR(name)) {
 			ret = PTR_ERR(name);
 			goto error;
@@ -728,7 +731,8 @@ long keyctl_keyring_search(key_serial_t ringid,
 	if (ret < 0)
 		goto error;
 
-	description = strndup_user(_description, KEY_MAX_DESC_SIZE);
+	description = strndup_user(_description, KEY_MAX_DESC_SIZE,
+			GFP_USER);
 	if (IS_ERR(description)) {
 		ret = PTR_ERR(description);
 		goto error;
@@ -1742,7 +1746,8 @@ long keyctl_restrict_keyring(key_serial_t id, const char __user *_type,
 		if (ret < 0)
 			goto error;
 
-		restriction = strndup_user(_restriction, PAGE_SIZE);
+		restriction = strndup_user(_restriction, PAGE_SIZE,
+				GFP_USER);
 		if (IS_ERR(restriction)) {
 			ret = PTR_ERR(restriction);
 			goto error;
diff --git a/security/keys/keyctl_pkey.c b/security/keys/keyctl_pkey.c
index 931d8dfb4a7f..903792123a85 100644
--- a/security/keys/keyctl_pkey.c
+++ b/security/keys/keyctl_pkey.c
@@ -86,7 +86,7 @@ static int keyctl_pkey_params_get(key_serial_t id,
 	memset(params, 0, sizeof(*params));
 	params->encoding = "raw";
 
-	p = strndup_user(_info, PAGE_SIZE);
+	p = strndup_user(_info, PAGE_SIZE, GFP_USER);
 	if (IS_ERR(p))
 		return PTR_ERR(p);
 	params->info = p;
-- 
2.25.1

