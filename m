Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7274A50C425
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 01:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233704AbiDVWyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 18:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233808AbiDVWy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 18:54:27 -0400
X-Greylist: delayed 5419 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 22 Apr 2022 15:17:30 PDT
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A433A33A976
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 15:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:Message-ID:Date:Subject:Cc:To:From:References:In-Reply-To:
        Content-ID:Content-Description;
        bh=XRgs5dgoBGBDr9oS5MRbFhujpNneuzIzg2K4+SgByuA=; b=LTDQ4JRHSj7PS7jOvG31dv/Q7W
        ZB5cT+8p9nbf0eUz5yz+8PNMcOu8i0/sHYrLMr3C/t55uXOeknvcQDdlGTXTeMpLgihR40eBAQrJl
        P8l8Yv+c2+K3v1qKaaDgvgjT/zsxA/Gt8AP0vETbSgpH+/Oypsirx7HCyP9w9S5r9Ny+XmwPHYsPh
        OD0V3dy2DL0UwsPda7DPkigL/etquLdpVrlB4a09h5JMZbQruEXzTWncpVrqar8Pu+2lSR9If/7vj
        6Sfamqo8kSVgsRbeLyTkBYnX6ubInNVSO4lRPybZO0yubOK1HC2gLVQOlrVaDga2fNKMRVP8a1TwZ
        a5O+Mt7SbmZCZ5whMbAq6J/sbt3uRetJNum0op4p4Znw31xcjBGhLnzh6SjDFFt3BbvYihp6cKqn7
        dkTGuC1GoUabk3W6/3J1KoJHonNV04yf5QB93sTVhwRrcZxIdWrKbEz6Z4ct2yZuBSshH8WGtUbiz
        nHkhgpU2Sp4VB5Nd4X/4W4aZjSWomDcCPXUPtxBntMzd5yZ2VuUorQlLZkeLD+smipJlYjfUoGSJz
        jOZzjLoKQXDyvGhRGNtsJdM0GXy9JXuSlLg+kwYpj7/s3+tMQV1MB6hBmAYF+UHfpIB3b4kVxThdl
        Ha2e37FPpqkbh9tzHmQsXrvnrM6fckHGNMhBwlTnM=;
From:   Christian Schoenebeck <qemu_oss@crudebyte.com>
To:     qemu-devel@nongnu.org
Cc:     Will Cohen <wwcohen@gmail.com>, Greg Kurz <groug@kaod.org>,
        Michael Roitzsch <reactorcontrol@icloud.com>,
        Keno Fischer <keno@juliacomputing.com>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        Latchesar Ionkov <lucho@ionkov.net>
Subject: [RFC PATCH] 9p: case-insensitive host filesystems
Date:   Fri, 22 Apr 2022 20:02:46 +0200
Message-ID: <1757498.AyhHxzoH2B@silver>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that 9p support for macOS hosts just landed in QEMU 7.0 and with support 
for Windows hosts on the horizon [1], the question is how to deal with case-
insensitive host filesystems, which are very common on those two systems?

I made some tests, e.g. trying to setup a 9p root fs Linux installation on a 
macOS host as described in the QEMU HOWTO [2], which at a certain point causes 
the debootstrap script to fail when trying to unpack the 'libpam-runtime' 
package. That's because it would try to create this symlink:

  /usr/share/man/man7/PAM.7.gz -> /usr/share/man/man7/pam.7.gz

which fails with EEXIST on a case-insensitive APFS. Unfortunately you can't 
easily switch an existing APFS partition to case-sensitivity. It requires to 
reformat the entire partition, loosing all your data, etc.

So I did a quick test with QEMU as outlined below, trying to simply let 9p 
server "eat" EEXIST errors in such cases, but then I realized that most of the 
time it would not even come that far, as Linux client would first send a 
'Twalk' request to check whether target symlink entry already exists, and as 
it gets a positive response from 9p server (again, due to case-insensitivity) 
client would stop right there without even trying to send a 'Tsymlink' 
request.

So maybe it's better to handle case-insensitivity entirely on client side? 
I've read that some generic "case fold" code has landed in the Linux kernel 
recently that might do the trick?

Should 9p server give a hint to 9p client that it's a case-insensitive fs? And 
if yes, once per entire exported fs or rather for each directory (as there 
might be submounts on host)?

[1] https://lore.kernel.org/all/20220408171013.912436-1-bmeng.cn@gmail.com/
[2] https://wiki.qemu.org/Documentation/9p_root_fs

---
 hw/9pfs/9p-local.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/hw/9pfs/9p-local.c b/hw/9pfs/9p-local.c
index d42ce6d8b8..d6cb45c758 100644
--- a/hw/9pfs/9p-local.c
+++ b/hw/9pfs/9p-local.c
@@ -39,6 +39,10 @@
 #endif
 #endif
 #include <sys/ioctl.h>
+#ifdef CONFIG_DARWIN
+#include <glib.h>
+#include <glib/gprintf.h>
+#endif
 
 #ifndef XFS_SUPER_MAGIC
 #define XFS_SUPER_MAGIC  0x58465342
@@ -57,6 +61,18 @@ typedef struct {
     int mountfd;
 } LocalData;
 
+#ifdef CONFIG_DARWIN
+
+/* Compare strings case-insensitive (assuming UTF-8 encoding). */
+static int p9_stricmp(const char *a, const char *b)
+{
+    g_autofree gchar *cia = g_utf8_casefold(a, -1);
+    g_autofree gchar *cib = g_utf8_casefold(b, -1);
+    return g_utf8_collate(cia, cib);
+}
+
+#endif
+
 int local_open_nofollow(FsContext *fs_ctx, const char *path, int flags,
                         mode_t mode)
 {
@@ -931,6 +947,25 @@ static int local_symlink(FsContext *fs_ctx, const char 
*oldpath,
                fs_ctx->export_flags & V9FS_SM_NONE) {
         err = symlinkat(oldpath, dirfd, name);
         if (err) {
+#if CONFIG_DARWIN
+            if (errno == EEXIST) {
+                printf("  -> symlinkat(oldpath='%s', dirfd=%d, name='%s') = 
EEXIST\n", oldpath, dirfd, name);
+            }
+            if (errno == EEXIST &&
+                strcmp(oldpath, name) && !p9_stricmp(oldpath, name))
+            {
+                struct stat st1, st2;
+                const int cur_errno = errno;
+                if (!fstatat(dirfd, oldpath, &st1, AT_SYMLINK_NOFOLLOW) &&
+                    !fstatat(dirfd, name, &st2, AT_SYMLINK_NOFOLLOW) &&
+                    st1.st_dev == st2.st_dev && st1.st_ino == st2.st_ino)
+                {
+                    printf("  -> iCASE SAME\n");
+                    err = 0;
+                }
+                errno = cur_errno;
+            }
+#endif
             goto out;
         }
         err = fchownat(dirfd, name, credp->fc_uid, credp->fc_gid,
@@ -983,6 +1018,25 @@ static int local_link(FsContext *ctx, V9fsPath *oldpath,
 
     ret = linkat(odirfd, oname, ndirfd, name, 0);
     if (ret < 0) {
+#if CONFIG_DARWIN
+        if (errno == EEXIST) {
+            printf("  -> linkat(odirfd=%d, oname='%s', ndirfd=%d, name='%s') 
= EEXIST\n", odirfd, oname, ndirfd, name);
+        }
+        if (errno == EEXIST &&
+            strcmp(oname, name) && !p9_stricmp(oname, name))
+        {
+            struct stat st1, st2;
+            const int cur_errno = errno;
+            if (!fstatat(odirfd, oname, &st1, AT_SYMLINK_NOFOLLOW) &&
+                !fstatat(ndirfd, name, &st2, AT_SYMLINK_NOFOLLOW) &&
+                st1.st_dev == st2.st_dev && st1.st_ino == st2.st_ino)
+            {
+                printf("  -> iCASE SAME\n");
+                ret = 0;
+            }
+            errno = cur_errno;
+        }
+#endif
         goto out_close;
     }
 
-- 
2.32.0 (Apple Git-132)




