Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE2B321AC17
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 02:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgGJAm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 20:42:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726311AbgGJAm4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 20:42:56 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4732220748;
        Fri, 10 Jul 2020 00:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594341775;
        bh=5Ehg+qQHY6D1Ucot0ZlhMa9wqKPDdhou+QBUE179+vQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q0w92nHdRkTh9mYwS73oP9jCagsJ0p5QXFwe3A5S9SbiGOeNgkemneZktGC4AMgx8
         p8JMDjANrsL1sr6etCMN1psvXsmlqNTon0svjaNtUOQKpmdQ6Mdn5rwK8bjORPnjBi
         nmCCNB0lRYXw9sHeA3XlFMCoTbwRBPGa54FHyt7o=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, saeedm@mellanox.com,
        michael.chan@broadcom.com, emil.s.tantilov@intel.com,
        alexander.h.duyck@linux.intel.com, jeffrey.t.kirsher@intel.com,
        tariqt@mellanox.com, mkubecek@suse.cz,
        Jakub Kicinski <kuba@kernel.org>,
        Chucheng Luo <luochucheng@vivo.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH net-next v4 01/10] debugfs: make sure we can remove u32_array files cleanly
Date:   Thu,  9 Jul 2020 17:42:44 -0700
Message-Id: <20200710004253.211130-2-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200710004253.211130-1-kuba@kernel.org>
References: <20200710004253.211130-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

debugfs_create_u32_array() allocates a small structure to wrap
the data and size information about the array. If users ever
try to remove the file this leads to a leak since nothing ever
frees this wrapper.

That said there are no upstream users of debugfs_create_u32_array()
that'd remove a u32 array file (we only have one u32 array user in
CMA), so there is no real bug here.

Make callers pass a wrapper they allocated. This way the lifetime
management of the wrapper is on the caller, and we can avoid the
potential leak in debugfs.

CC: Chucheng Luo <luochucheng@vivo.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/filesystems/debugfs.rst | 12 ++++++++----
 fs/debugfs/file.c                     | 27 +++++++--------------------
 include/linux/debugfs.h               | 12 +++++++++---
 mm/cma.h                              |  3 +++
 mm/cma_debug.c                        |  7 ++++---
 5 files changed, 31 insertions(+), 30 deletions(-)

diff --git a/Documentation/filesystems/debugfs.rst b/Documentation/filesystems/debugfs.rst
index 1da7a4b7383d..728ab57a611a 100644
--- a/Documentation/filesystems/debugfs.rst
+++ b/Documentation/filesystems/debugfs.rst
@@ -185,13 +185,17 @@ byte offsets over a base for the register block.
 
 If you want to dump an u32 array in debugfs, you can create file with::
 
+    struct debugfs_u32_array {
+	u32 *array;
+	u32 n_elements;
+    };
+
     void debugfs_create_u32_array(const char *name, umode_t mode,
 			struct dentry *parent,
-			u32 *array, u32 elements);
+			struct debugfs_u32_array *array);
 
-The "array" argument provides data, and the "elements" argument is
-the number of elements in the array. Note: Once array is created its
-size can not be changed.
+The "array" argument wraps a pointer to the array's data and the number
+of its elements. Note: Once array is created its size can not be changed.
 
 There is a helper function to create device related seq_file::
 
diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index ae49a55bda00..d0ed71f37511 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -918,11 +918,6 @@ struct dentry *debugfs_create_blob(const char *name, umode_t mode,
 }
 EXPORT_SYMBOL_GPL(debugfs_create_blob);
 
-struct array_data {
-	void *array;
-	u32 elements;
-};
-
 static size_t u32_format_array(char *buf, size_t bufsize,
 			       u32 *array, int array_size)
 {
@@ -943,8 +938,8 @@ static size_t u32_format_array(char *buf, size_t bufsize,
 
 static int u32_array_open(struct inode *inode, struct file *file)
 {
-	struct array_data *data = inode->i_private;
-	int size, elements = data->elements;
+	struct debugfs_u32_array *data = inode->i_private;
+	int size, elements = data->n_elements;
 	char *buf;
 
 	/*
@@ -959,7 +954,7 @@ static int u32_array_open(struct inode *inode, struct file *file)
 	buf[size] = 0;
 
 	file->private_data = buf;
-	u32_format_array(buf, size, data->array, data->elements);
+	u32_format_array(buf, size, data->array, data->n_elements);
 
 	return nonseekable_open(inode, file);
 }
@@ -996,8 +991,7 @@ static const struct file_operations u32_array_fops = {
  * @parent: a pointer to the parent dentry for this file.  This should be a
  *          directory dentry if set.  If this parameter is %NULL, then the
  *          file will be created in the root of the debugfs filesystem.
- * @array: u32 array that provides data.
- * @elements: total number of elements in the array.
+ * @array: wrapper struct containing data pointer and size of the array.
  *
  * This function creates a file in debugfs with the given name that exports
  * @array as data. If the @mode variable is so set it can be read from.
@@ -1005,17 +999,10 @@ static const struct file_operations u32_array_fops = {
  * Once array is created its size can not be changed.
  */
 void debugfs_create_u32_array(const char *name, umode_t mode,
-			      struct dentry *parent, u32 *array, u32 elements)
+			      struct dentry *parent,
+			      struct debugfs_u32_array *array)
 {
-	struct array_data *data = kmalloc(sizeof(*data), GFP_KERNEL);
-
-	if (data == NULL)
-		return;
-
-	data->array = array;
-	data->elements = elements;
-
-	debugfs_create_file_unsafe(name, mode, parent, data, &u32_array_fops);
+	debugfs_create_file_unsafe(name, mode, parent, array, &u32_array_fops);
 }
 EXPORT_SYMBOL_GPL(debugfs_create_u32_array);
 
diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index 63cb3606dea7..851dd1f9a8a5 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -38,6 +38,11 @@ struct debugfs_regset32 {
 	struct device *dev;	/* Optional device for Runtime PM */
 };
 
+struct debugfs_u32_array {
+	u32 *array;
+	u32 n_elements;
+};
+
 extern struct dentry *arch_debugfs_dir;
 
 #define DEFINE_DEBUGFS_ATTRIBUTE(__fops, __get, __set, __fmt)		\
@@ -136,7 +141,8 @@ void debugfs_print_regs32(struct seq_file *s, const struct debugfs_reg32 *regs,
 			  int nregs, void __iomem *base, char *prefix);
 
 void debugfs_create_u32_array(const char *name, umode_t mode,
-			      struct dentry *parent, u32 *array, u32 elements);
+			      struct dentry *parent,
+			      struct debugfs_u32_array *array);
 
 struct dentry *debugfs_create_devm_seqfile(struct device *dev, const char *name,
 					   struct dentry *parent,
@@ -316,8 +322,8 @@ static inline bool debugfs_initialized(void)
 }
 
 static inline void debugfs_create_u32_array(const char *name, umode_t mode,
-					    struct dentry *parent, u32 *array,
-					    u32 elements)
+					    struct dentry *parent,
+					    struct debugfs_u32_array *array)
 {
 }
 
diff --git a/mm/cma.h b/mm/cma.h
index 33c0b517733c..6698fa63279b 100644
--- a/mm/cma.h
+++ b/mm/cma.h
@@ -2,6 +2,8 @@
 #ifndef __MM_CMA_H__
 #define __MM_CMA_H__
 
+#include <linux/debugfs.h>
+
 struct cma {
 	unsigned long   base_pfn;
 	unsigned long   count;
@@ -11,6 +13,7 @@ struct cma {
 #ifdef CONFIG_CMA_DEBUGFS
 	struct hlist_head mem_head;
 	spinlock_t mem_head_lock;
+	struct debugfs_u32_array dfs_bitmap;
 #endif
 	const char *name;
 };
diff --git a/mm/cma_debug.c b/mm/cma_debug.c
index 4e6cbe2f586e..d5bf8aa34fdc 100644
--- a/mm/cma_debug.c
+++ b/mm/cma_debug.c
@@ -164,7 +164,6 @@ static void cma_debugfs_add_one(struct cma *cma, struct dentry *root_dentry)
 {
 	struct dentry *tmp;
 	char name[16];
-	int u32s;
 
 	scnprintf(name, sizeof(name), "cma-%s", cma->name);
 
@@ -180,8 +179,10 @@ static void cma_debugfs_add_one(struct cma *cma, struct dentry *root_dentry)
 	debugfs_create_file("used", 0444, tmp, cma, &cma_used_fops);
 	debugfs_create_file("maxchunk", 0444, tmp, cma, &cma_maxchunk_fops);
 
-	u32s = DIV_ROUND_UP(cma_bitmap_maxno(cma), BITS_PER_BYTE * sizeof(u32));
-	debugfs_create_u32_array("bitmap", 0444, tmp, (u32 *)cma->bitmap, u32s);
+	cma->dfs_bitmap.array = (u32 *)cma->bitmap;
+	cma->dfs_bitmap.n_elements = DIV_ROUND_UP(cma_bitmap_maxno(cma),
+						  BITS_PER_BYTE * sizeof(u32));
+	debugfs_create_u32_array("bitmap", 0444, tmp, &cma->dfs_bitmap);
 }
 
 static int __init cma_debugfs_init(void)
-- 
2.26.2

