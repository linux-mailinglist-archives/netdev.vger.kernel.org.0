Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6B4DB7E36
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 17:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391263AbfISPbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 11:31:17 -0400
Received: from mx.cjr.nz ([51.158.111.142]:37444 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388084AbfISPbQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 11:31:16 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id CE49781032;
        Thu, 19 Sep 2019 15:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1568906486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aFbgfo1uvoVeTPm4h0phE3Z4pZpOiCMHkefqq14la6Q=;
        b=nXaB8slRPCDtEybVDpqswlfqMrDCV1RBMcvotG8frZ9iAD1GKSOtzLjaNzC5ud+PZF2Gsp
        E+2Hm88M5BZ97klu/YzK20JG1jlTDGL9+fBVetWKaD2+uPMRnnw4rDU+s5KnBn5VFAxuIb
        Cw+AzBBBTGlpCIjAj/gg/xcFn6RdtzzuWBvFciYYXIB9/5P+0CkyaoLVFzKjqhAa7bTRBH
        EqVrvysdxI7sPCdVVaJozQIp7QRiZ821xvh78+09uBKZx8Yl+poTHfNec6GLGLf8dwgt9L
        e/4Dz//dzLFr2vAk+6BiDbMw0wXg7OCMEsTB2in1G4IBvKe70JsSw6vMhmNmDw==
From:   "Paulo Alcantara (SUSE)" <pc@cjr.nz>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Cc:     "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 2/3] init: Support mounting root file systems over SMB
Date:   Thu, 19 Sep 2019 12:21:15 -0300
Message-Id: <20190919152116.27076-2-pc@cjr.nz>
In-Reply-To: <20190919152116.27076-1-pc@cjr.nz>
References: <20190716220452.3382-1-paulo@paulo.ac>
 <20190919152116.27076-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz;
        s=dkim; t=1568906486; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aFbgfo1uvoVeTPm4h0phE3Z4pZpOiCMHkefqq14la6Q=;
        b=TITbx/1AVJLTFDQBFrw78lpWLqfF3EDMQZPA7WnmVHzOGKCyHBk7gYDj4GR425BZPmx4Tz
        m71oISUPmbx2AN0bO2PLOvPnONro5kAGa29cRqsCGGw4+G23MeZKCxF1wbD3tpdyJjPtBH
        ur3faHkkCgp4SZdfHnQ1SxUOzbQSwWGnjqw8qrRvBd1uDJmqnhCfh39X6+kbd4kSP12UlR
        tcDaY0QclgBK967/ehNsbjYIbFfarihwX85VBy4T5Ffvv7XOtG2pcYWPWFSWZIO85VN1wL
        ChG7RqEUkRU9FZxrb3d8rPX86h/ljdMdwYWq60nApHCL9Fozntwbph036lXLBQ==
ARC-Seal: i=1; s=dkim; d=cjr.nz; t=1568906486; a=rsa-sha256; cv=none;
        b=bmjR8f31d/SiO/chIPIooJQaIONlj7t+PitWoRXDZXUzmzzEUDGT34sveecn8BajV81urh
        uubDTRMySbnMl6xZntFJvMTHCbonQ8F/OkRfujY2eYgpQ9jAkCzhYS4Gw8DaJtry+wkb5v
        /A2pcZeI2zox/gxDddj3TEldF4XiYWXOTukdfm0Dbt2JWr9R3VVmxBkvD31bVjktG5gJ7W
        JpZdpsRhxHW+DQuuvfQGG2fxtyoRpBHeV/BvUpELtz1dz1zO/C/5KQPaYwp8l+y5+jxiYR
        SVwZOsE/zG7Ll5xbdtXPNxokI/urv9kbx0w9a9Q+vGY8ggvV/dhZXRUgGsfO/g==
ARC-Authentication-Results: i=1;
        mx.cjr.nz;
        auth=pass smtp.auth=pc smtp.mailfrom=pc@cjr.nz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new virtual device named /dev/cifs (0xfe) to tell the kernel to
mount the root file system over the network by using SMB protocol.

cifs_root_data() will be responsible to retrieve the parsed
information of the new command-line option (cifsroot=) and then call
do_mount_root() with the appropriate mount options for cifs.ko.

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 init/do_mounts.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 53cb37b66227..cffef647a95b 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -212,6 +212,7 @@ static int match_dev_by_label(struct device *dev, const void *data)
  *	   a colon.
  *	9) PARTLABEL=<name> with name being the GPT partition label.
  *	   MSDOS partitions do not support labels!
+ *	10) /dev/cifs represents Root_CIFS (0xfe)
  *
  *	If name doesn't have fall into the categories above, we return (0,0).
  *	block_class is used to check if something is a disk name. If the disk
@@ -268,6 +269,9 @@ dev_t name_to_dev_t(const char *name)
 	res = Root_NFS;
 	if (strcmp(name, "nfs") == 0)
 		goto done;
+	res = Root_CIFS;
+	if (strcmp(name, "cifs") == 0)
+		goto done;
 	res = Root_RAM0;
 	if (strcmp(name, "ram") == 0)
 		goto done;
@@ -501,6 +505,42 @@ static int __init mount_nfs_root(void)
 }
 #endif
 
+#ifdef CONFIG_CIFS_ROOT
+
+extern int cifs_root_data(char **dev, char **opts);
+
+#define CIFSROOT_TIMEOUT_MIN	5
+#define CIFSROOT_TIMEOUT_MAX	30
+#define CIFSROOT_RETRY_MAX	5
+
+static int __init mount_cifs_root(void)
+{
+	char *root_dev, *root_data;
+	unsigned int timeout;
+	int try, err;
+
+	err = cifs_root_data(&root_dev, &root_data);
+	if (err != 0)
+		return 0;
+
+	timeout = CIFSROOT_TIMEOUT_MIN;
+	for (try = 1; ; try++) {
+		err = do_mount_root(root_dev, "cifs", root_mountflags,
+				    root_data);
+		if (err == 0)
+			return 1;
+		if (try > CIFSROOT_RETRY_MAX)
+			break;
+
+		ssleep(timeout);
+		timeout <<= 1;
+		if (timeout > CIFSROOT_TIMEOUT_MAX)
+			timeout = CIFSROOT_TIMEOUT_MAX;
+	}
+	return 0;
+}
+#endif
+
 #if defined(CONFIG_BLK_DEV_RAM) || defined(CONFIG_BLK_DEV_FD)
 void __init change_floppy(char *fmt, ...)
 {
@@ -542,6 +582,15 @@ void __init mount_root(void)
 		ROOT_DEV = Root_FD0;
 	}
 #endif
+#ifdef CONFIG_CIFS_ROOT
+	if (ROOT_DEV == Root_CIFS) {
+		if (mount_cifs_root())
+			return;
+
+		printk(KERN_ERR "VFS: Unable to mount root fs via SMB, trying floppy.\n");
+		ROOT_DEV = Root_FD0;
+	}
+#endif
 #ifdef CONFIG_BLK_DEV_FD
 	if (MAJOR(ROOT_DEV) == FLOPPY_MAJOR) {
 		/* rd_doload is 2 for a dual initrd/ramload setup */
-- 
2.23.0

