Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3198B7E34
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 17:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391295AbfISPbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 11:31:24 -0400
Received: from mx.cjr.nz ([51.158.111.142]:37450 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391251AbfISPbR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 11:31:17 -0400
X-Greylist: delayed 588 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Sep 2019 11:31:14 EDT
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 62CE5810ED;
        Thu, 19 Sep 2019 15:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1568906484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bqBW/6HCxHbOBX6UDF4RraSrWtlbtoyENDx4W6h26Kg=;
        b=eDALsFLbAo9CuvAL6iYqBxDnPZQ5yxZuGMFlzDm81QqgfMb0+AqMXKB57oHX9hbUCVND4I
        +oMR0Y/rj7fO+FVRvQ/hlADpHYEqJ+EA984Xk1mlAeDtNKO/hbs+pwaaPcNnA/c89KzPou
        PCRlWN/zd0DsV4GCgvtH9HfrV87DSFRV2JN60L1ARXdcfYF9sCEnMhGZ7gyGd+U/ibLcsU
        KCRjC0lRHSotu7vUr9gdNttsWeUumM6tACJxx+VsulKAgyEr/Y3bxwVIveUaljjiwcvYe3
        KMYnOywW1scfol5T/kiRoYfOuNUCKmUU04sFUWjdUNb4ktGwg41TESwBmNcXsQ==
From:   "Paulo Alcantara (SUSE)" <pc@cjr.nz>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Cc:     "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH v2 1/3] cifs: Add support for root file systems
Date:   Thu, 19 Sep 2019 12:21:14 -0300
Message-Id: <20190919152116.27076-1-pc@cjr.nz>
In-Reply-To: <20190716220452.3382-1-paulo@paulo.ac>
References: <20190716220452.3382-1-paulo@paulo.ac>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz;
        s=dkim; t=1568906484; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bqBW/6HCxHbOBX6UDF4RraSrWtlbtoyENDx4W6h26Kg=;
        b=DmcqcYhEsHjSAYpnAcK1PahDzeulb5DnK2pA2FSoZzoiSFxw3ffmYHrkGUBASJYE9q9iWJ
        xPD0BUTLnObSoybZPiknpiqHhVuSUiVwrhvrqshMofZaambb5W+BEyDZwuVt+iy9IL90uV
        FZQMC6xvD7WOhy5D5m/hRjLu7jtel4vfWGrtTt9WTJ8XOsUJvbu5umgP3TTkSXoigvky3Y
        wGEG7oE0DrnOc14WXayZu8EMtDknr6cZTr8r9BSUMRr0MpmW6+SB6AyExyzv1ogUUje6oe
        6ZQUjT2LCuvGAE8wpsQBpnMI8s5ogm3JLJkKVA/TxXuWdUKxSoyQeBkUmSOG0g==
ARC-Seal: i=1; s=dkim; d=cjr.nz; t=1568906484; a=rsa-sha256; cv=none;
        b=oxoOiCUmVmK+tImSDrJlhmULbGkVNtjuNKm1JlIbr7TMuEyDVjbhmcRvRcMyfoI8dMhdyu
        JI1psD58zgNgG2AMjMn38RRCC2QLlUNedNEWuj0C9cXdYdnxAREfvB+XGWxUBIAR89xXcQ
        nEIMMdO53DNI/yBmt8PhKvMf7wC68DlVs8sw/KU3MEsMnhdzJHa9R7FrC6tQDovScbAMKc
        zHp2He8jJ8mvZOntPH4UfHI8dMTQJd/Yg51vCu+xCJPMZieZt0zCiJYl8Tu4UDFPMzjqr1
        UtpMsI5IeuQWQSr4M146LnEiJBRyBE5I5A5GmOgxRvfL2QJjFIasMqo/2kWABw==
ARC-Authentication-Results: i=1;
        mx.cjr.nz;
        auth=pass smtp.auth=pc smtp.mailfrom=pc@cjr.nz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a new CONFIG_CIFS_ROOT option to handle root file systems
over a SMB share.

In order to mount the root file system during the init process, make
cifs.ko perform non-blocking socket operations while mounting and
accessing it.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Aurelien Aptel <aaptel@suse.com>
---
 Documentation/filesystems/cifs/cifsroot.txt | 97 +++++++++++++++++++++
 fs/cifs/Kconfig                             |  8 ++
 fs/cifs/Makefile                            |  2 +
 fs/cifs/cifsglob.h                          |  2 +
 fs/cifs/cifsroot.c                          | 94 ++++++++++++++++++++
 fs/cifs/connect.c                           | 17 +++-
 include/linux/root_dev.h                    |  1 +
 7 files changed, 218 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/filesystems/cifs/cifsroot.txt
 create mode 100644 fs/cifs/cifsroot.c

diff --git a/Documentation/filesystems/cifs/cifsroot.txt b/Documentation/filesystems/cifs/cifsroot.txt
new file mode 100644
index 000000000000..0fa1a2c36a40
--- /dev/null
+++ b/Documentation/filesystems/cifs/cifsroot.txt
@@ -0,0 +1,97 @@
+Mounting root file system via SMB (cifs.ko)
+===========================================
+
+Written 2019 by Paulo Alcantara <palcantara@suse.de>
+Written 2019 by Aurelien Aptel <aaptel@suse.com>
+
+The CONFIG_CIFS_ROOT option enables experimental root file system
+support over the SMB protocol via cifs.ko.
+
+It introduces a new kernel command-line option called 'cifsroot='
+which will tell the kernel to mount the root file system over the
+network by utilizing SMB or CIFS protocol.
+
+In order to mount, the network stack will also need to be set up by
+using 'ip=' config option. For more details, see
+Documentation/filesystems/nfs/nfsroot.txt.
+
+A CIFS root mount currently requires the use of SMB1+UNIX Extensions
+which is only supported by the Samba server. SMB1 is the older
+deprecated version of the protocol but it has been extended to support
+POSIX features (See [1]). The equivalent extensions for the newer
+recommended version of the protocol (SMB3) have not been fully
+implemented yet which means SMB3 doesn't support some required POSIX
+file system objects (e.g. block devices, pipes, sockets).
+
+As a result, a CIFS root will default to SMB1 for now but the version
+to use can nonetheless be changed via the 'vers=' mount option.  This
+default will change once the SMB3 POSIX extensions are fully
+implemented.
+
+Server configuration
+====================
+
+To enable SMB1+UNIX extensions you will need to set these global
+settings in Samba smb.conf:
+
+    [global]
+    server min protocol = NT1
+    unix extension = yes        # default
+
+Kernel command line
+===================
+
+root=/dev/cifs
+
+This is just a virtual device that basically tells the kernel to mount
+the root file system via SMB protocol.
+
+cifsroot=//<server-ip>/<share>[,options]
+
+Enables the kernel to mount the root file system via SMB that are
+located in the <server-ip> and <share> specified in this option.
+
+The default mount options are set in fs/cifs/cifsroot.c.
+
+server-ip
+	IPv4 address of the server.
+
+share
+	Path to SMB share (rootfs).
+
+options
+	Optional mount options. For more information, see mount.cifs(8).
+
+Examples
+========
+
+Export root file system as a Samba share in smb.conf file.
+
+...
+[linux]
+	path = /path/to/rootfs
+	read only = no
+	guest ok = yes
+	force user = root
+	force group = root
+	browseable = yes
+	writeable = yes
+	admin users = root
+	public = yes
+	create mask = 0777
+	directory mask = 0777
+...
+
+Restart smb service.
+
+# systemctl restart smb
+
+Test it under QEMU on a kernel built with CONFIG_CIFS_ROOT and
+CONFIG_IP_PNP options enabled.
+
+# qemu-system-x86_64 -enable-kvm -cpu host -m 1024 \
+  -kernel /path/to/linux/arch/x86/boot/bzImage -nographic \
+  -append "root=/dev/cifs rw ip=dhcp cifsroot=//10.0.2.2/linux,username=foo,password=bar console=ttyS0 3"
+
+
+1: https://wiki.samba.org/index.php/UNIX_Extensions
diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index 350bc3061656..22cf04fb32d3 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -211,3 +211,11 @@ config CIFS_FSCACHE
 	  Makes CIFS FS-Cache capable. Say Y here if you want your CIFS data
 	  to be cached locally on disk through the general filesystem cache
 	  manager. If unsure, say N.
+
+config CIFS_ROOT
+	bool "SMB root file system (Experimental)"
+	depends on CIFS=y && IP_PNP
+	help
+	  Enables root file system support over SMB protocol.
+
+	  Most people say N here.
diff --git a/fs/cifs/Makefile b/fs/cifs/Makefile
index 41332f20055b..51bae9340842 100644
--- a/fs/cifs/Makefile
+++ b/fs/cifs/Makefile
@@ -21,3 +21,5 @@ cifs-$(CONFIG_CIFS_DFS_UPCALL) += dns_resolve.o cifs_dfs_ref.o dfs_cache.o
 cifs-$(CONFIG_CIFS_FSCACHE) += fscache.o cache.o
 
 cifs-$(CONFIG_CIFS_SMB_DIRECT) += smbdirect.o
+
+cifs-$(CONFIG_CIFS_ROOT) += cifsroot.o
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index fe610e7e3670..08c19e134f76 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -602,6 +602,7 @@ struct smb_vol {
 	__u32 handle_timeout; /* persistent and durable handle timeout in ms */
 	unsigned int max_credits; /* smb3 max_credits 10 < credits < 60000 */
 	__u16 compression; /* compression algorithm 0xFFFF default 0=disabled */
+	bool rootfs:1; /* if it's a SMB root file system */
 };
 
 /**
@@ -755,6 +756,7 @@ struct TCP_Server_Info {
 	 * reconnect.
 	 */
 	int nr_targets;
+	bool noblockcnt; /* use non-blocking connect() */
 };
 
 struct cifs_credits {
diff --git a/fs/cifs/cifsroot.c b/fs/cifs/cifsroot.c
new file mode 100644
index 000000000000..37edbfb8e096
--- /dev/null
+++ b/fs/cifs/cifsroot.c
@@ -0,0 +1,94 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * SMB root file system support
+ *
+ * Copyright (c) 2019 Paulo Alcantara <palcantara@suse.de>
+ */
+#include <linux/init.h>
+#include <linux/fs.h>
+#include <linux/types.h>
+#include <linux/ctype.h>
+#include <linux/string.h>
+#include <linux/root_dev.h>
+#include <linux/kernel.h>
+#include <linux/in.h>
+#include <linux/inet.h>
+#include <net/ipconfig.h>
+
+#define DEFAULT_MNT_OPTS \
+	"vers=1.0,cifsacl,mfsymlinks,rsize=1048576,wsize=65536,uid=0,gid=0," \
+	"hard,rootfs"
+
+static char root_dev[2048] __initdata = "";
+static char root_opts[1024] __initdata = DEFAULT_MNT_OPTS;
+
+static __be32 __init parse_srvaddr(char *start, char *end)
+{
+	/* TODO: ipv6 support */
+	char addr[sizeof("aaa.bbb.ccc.ddd")];
+	int i = 0;
+
+	while (start < end && i < sizeof(addr) - 1) {
+		if (isdigit(*start) || *start == '.')
+			addr[i++] = *start;
+		start++;
+	}
+	addr[i] = '\0';
+	return in_aton(addr);
+}
+
+/* cifsroot=//<server-ip>/<share>[,options] */
+static int __init cifs_root_setup(char *line)
+{
+	char *s;
+	int len;
+	__be32 srvaddr = htonl(INADDR_NONE);
+
+	ROOT_DEV = Root_CIFS;
+
+	if (strlen(line) > 3 && line[0] == '/' && line[1] == '/') {
+		s = strchr(&line[2], '/');
+		if (!s || s[1] == '\0')
+			return 1;
+
+		/* make s point to ',' or '\0' at end of line */
+		s = strchrnul(s, ',');
+		/* len is strlen(unc) + '\0' */
+		len = s - line + 1;
+		if (len > sizeof(root_dev)) {
+			printk(KERN_ERR "Root-CIFS: UNC path too long\n");
+			return 1;
+		}
+		strlcpy(root_dev, line, len);
+		srvaddr = parse_srvaddr(&line[2], s);
+		if (*s) {
+			int n = snprintf(root_opts,
+					 sizeof(root_opts), "%s,%s",
+					 DEFAULT_MNT_OPTS, s + 1);
+			if (n >= sizeof(root_opts)) {
+				printk(KERN_ERR "Root-CIFS: mount options string too long\n");
+				root_opts[sizeof(root_opts)-1] = '\0';
+				return 1;
+			}
+		}
+	}
+
+	root_server_addr = srvaddr;
+
+	return 1;
+}
+
+__setup("cifsroot=", cifs_root_setup);
+
+int __init cifs_root_data(char **dev, char **opts)
+{
+	if (!root_dev[0] || root_server_addr == htonl(INADDR_NONE)) {
+		printk(KERN_ERR "Root-CIFS: no SMB server address\n");
+		return -1;
+	}
+
+	*dev = root_dev;
+	*opts = root_opts;
+
+	return 0;
+}
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 5299effa6f7d..d1c7b128df53 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -96,7 +96,7 @@ enum {
 	Opt_multiuser, Opt_sloppy, Opt_nosharesock,
 	Opt_persistent, Opt_nopersistent,
 	Opt_resilient, Opt_noresilient,
-	Opt_domainauto, Opt_rdma, Opt_modesid,
+	Opt_domainauto, Opt_rdma, Opt_modesid, Opt_rootfs,
 	Opt_compress,
 
 	/* Mount options which take numeric value */
@@ -262,6 +262,7 @@ static const match_table_t cifs_mount_option_tokens = {
 	{ Opt_ignore, "nomand" },
 	{ Opt_ignore, "relatime" },
 	{ Opt_ignore, "_netdev" },
+	{ Opt_rootfs, "rootfs" },
 
 	{ Opt_err, NULL }
 };
@@ -1748,6 +1749,11 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 		case Opt_nodfs:
 			vol->nodfs = 1;
 			break;
+		case Opt_rootfs:
+#ifdef CONFIG_CIFS_ROOT
+			vol->rootfs = true;
+#endif
+			break;
 		case Opt_posixpaths:
 			vol->posix_paths = 1;
 			break;
@@ -2681,7 +2687,8 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 		goto out_err_crypto_release;
 	}
 
-	tcp_ses->noblocksnd = volume_info->noblocksnd;
+	tcp_ses->noblockcnt = volume_info->rootfs;
+	tcp_ses->noblocksnd = volume_info->noblocksnd || volume_info->rootfs;
 	tcp_ses->noautotune = volume_info->noautotune;
 	tcp_ses->tcp_nodelay = volume_info->sockopt_tcp_nodelay;
 	tcp_ses->rdma = volume_info->rdma;
@@ -3814,7 +3821,11 @@ generic_ip_connect(struct TCP_Server_Info *server)
 		 socket->sk->sk_sndbuf,
 		 socket->sk->sk_rcvbuf, socket->sk->sk_rcvtimeo);
 
-	rc = socket->ops->connect(socket, saddr, slen, 0);
+	rc = socket->ops->connect(socket, saddr, slen,
+				  server->noblockcnt ? O_NONBLOCK : 0);
+
+	if (rc == -EINPROGRESS)
+		rc = 0;
 	if (rc < 0) {
 		cifs_dbg(FYI, "Error %d connecting to server\n", rc);
 		sock_release(socket);
diff --git a/include/linux/root_dev.h b/include/linux/root_dev.h
index bab671b0782f..4e78651371ba 100644
--- a/include/linux/root_dev.h
+++ b/include/linux/root_dev.h
@@ -8,6 +8,7 @@
 
 enum {
 	Root_NFS = MKDEV(UNNAMED_MAJOR, 255),
+	Root_CIFS = MKDEV(UNNAMED_MAJOR, 254),
 	Root_RAM0 = MKDEV(RAMDISK_MAJOR, 0),
 	Root_RAM1 = MKDEV(RAMDISK_MAJOR, 1),
 	Root_FD0 = MKDEV(FLOPPY_MAJOR, 0),
-- 
2.23.0

