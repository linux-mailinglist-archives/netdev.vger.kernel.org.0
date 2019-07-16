Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2B766B1A0
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 00:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388804AbfGPWLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 18:11:32 -0400
Received: from mx.paulo.ac ([212.47.230.6]:38836 "EHLO mx.paulo.ac"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728587AbfGPWLa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jul 2019 18:11:30 -0400
From:   "Paulo Alcantara (SUSE)" <paulo@paulo.ac>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=paulo.ac; s=dkim;
        t=1563314701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4w+8xqkk33dItflCbCDCNicoHPwi4U9yOC7tuXyPHfw=;
        b=gQczIURMsqhf4D8wzaBC60Ch4bbvfwQGvcz6Zw2v4/5kuHGn5CWs8fvi0A0gbu2yD8A0Gx
        CNcCegoXGCnXt58d+8u+gvke1Ju8a9MnLEsfOWgxzfiz7BHjMP1vhMnzMJiul56IhEyf1Z
        llrxu8/6oGJE+a8FaBilCKTqa+tJN+o36p8jbZvqzontkmwWstmKjkztu+EpSTGE/ile7I
        tDkq6zthL4cMXb25zjRQVwueE9niqpcTj5qOO+kuUEJqWBfWy2CLoyZa27GotC/u9TY5Ea
        MWZHaVYmynUsY3pO4PPEp/2qgMxBLmsNwyaaJjWmOMIapVDbtUK4nDOlf/MBLA==
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Cc:     "Paulo Alcantara (SUSE)" <paulo@paulo.ac>,
        Steve French <smfrench@gmail.com>
Subject: [PATCH 1/3] cifs: Add support for root file systems
Date:   Tue, 16 Jul 2019 19:04:50 -0300
Message-Id: <20190716220452.3382-1-paulo@paulo.ac>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=paulo.ac;
        s=dkim; t=1563314701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4w+8xqkk33dItflCbCDCNicoHPwi4U9yOC7tuXyPHfw=;
        b=Ded0mKnu2UjsLMeo/bCL3mc+FCXnUoSrq4mw5gmWnpq/+EawHE3Cgsz5T9RCbDFygQ2+Q8
        c/iUme1HppxqCOHOO6z+igXFhjeJ4MFPFwfSHkinP/m/CM7ijF7/pCtpn+oOpKWa1Y9tx8
        QOJarUhfI/ssiRMOAgLrmTkR4fhMmfRyKe1XNFGUIzVSL4HgEelFSeCXAxSxhO7WdRD74S
        jXMbc5WG0idDyeX3v1TNlEDgxzEox5SUG+/n1qi22rIyzdmD/r13/KVNYBKgjH7DurNn5o
        uT284b2apQE9LCe37XtD+wlUm6L+/nGmhWirKolSMVxmBa3iZdgMGEr9RmnGwA==
ARC-Seal: i=1; s=dkim; d=paulo.ac; t=1563314701; a=rsa-sha256; cv=none;
        b=LFiE+45226kp2ZejThnmbsIMhekYTWIoxfwJOhdJyu9vLIfqDxcdrY6zdfrlqQ9n/8ZM45
        VeqFPl49u0ZRSYvcMyh+/O6Db+ccYDMpUYzPqemSc42WMEqonXkbVBwupA1jZ0oa+m3Y0e
        e383FVUVjOEVv7mQr4LpAmldKIQpyKKkZ1TJtdfLJrbuiCAbp6nCDSf7E6esOxqXDBge3v
        U01G9InO08CwYS84gVTplpiXv5rYGZjsL7tZpGAGFCQTrq+W2xw1AaS8PDwM+gSr5GJON0
        pgoqr8/Ur2yIdjo/+D/a8CU6RHQ9QcYGxnW7wRFpOQVZe9yLQF+/f+uGYCrekw==
ARC-Authentication-Results: i=1;
        mx.paulo.ac;
        auth=pass smtp.auth=paulo smtp.mailfrom=paulo@paulo.ac
Authentication-Results: mx.paulo.ac;
        auth=pass smtp.auth=paulo smtp.mailfrom=paulo@paulo.ac
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a new CONFIG_CIFS_ROOT option to handle root file systems
over a SMB share.

In order to mount the root file system during the init process, make
cifs.ko perform non-blocking socket operations while mounting and
accessing it.

Cc: Steve French <smfrench@gmail.com>
Signed-off-by: Paulo Alcantara (SUSE) <paulo@paulo.ac>
---
 Documentation/filesystems/cifs/cifsroot.txt | 97 +++++++++++++++++++++
 fs/cifs/Kconfig                             |  8 ++
 fs/cifs/Makefile                            |  2 +
 fs/cifs/cifsglob.h                          |  2 +
 fs/cifs/cifsroot.c                          | 83 ++++++++++++++++++
 fs/cifs/connect.c                           | 17 +++-
 include/linux/root_dev.h                    |  1 +
 7 files changed, 207 insertions(+), 3 deletions(-)
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
index 523e9ea78a28..d28d62532318 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -217,3 +217,11 @@ config CIFS_FSCACHE
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
index 51af69a1a328..45cf67f37487 100644
--- a/fs/cifs/Makefile
+++ b/fs/cifs/Makefile
@@ -22,3 +22,5 @@ cifs-$(CONFIG_CIFS_DFS_UPCALL) += dns_resolve.o cifs_dfs_ref.o dfs_cache.o
 cifs-$(CONFIG_CIFS_FSCACHE) += fscache.o cache.o
 
 cifs-$(CONFIG_CIFS_SMB_DIRECT) += smbdirect.o
+
+cifs-$(CONFIG_CIFS_ROOT) += cifsroot.o
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 4777b3c4a92c..ac7e433a5b94 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -600,6 +600,7 @@ struct smb_vol {
 	__u64 snapshot_time; /* needed for timewarp tokens */
 	__u32 handle_timeout; /* persistent and durable handle timeout in ms */
 	unsigned int max_credits; /* smb3 max_credits 10 < credits < 60000 */
+	bool rootfs:1; /* if it's a SMB root file system */
 };
 
 /**
@@ -752,6 +753,7 @@ struct TCP_Server_Info {
 	 * reconnect.
 	 */
 	int nr_targets;
+	bool noblockcnt; /* use non-blocking connect() */
 };
 
 struct cifs_credits {
diff --git a/fs/cifs/cifsroot.c b/fs/cifs/cifsroot.c
new file mode 100644
index 000000000000..8760d9cbf25e
--- /dev/null
+++ b/fs/cifs/cifsroot.c
@@ -0,0 +1,83 @@
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
+		s = strchrnul(s, ',');
+		len = s - line + 1;
+		if (len <= sizeof(root_dev)) {
+			strlcpy(root_dev, line, len);
+			srvaddr = parse_srvaddr(&line[2], s);
+			if (*s) {
+				snprintf(root_opts, sizeof(root_opts), "%s,%s",
+					 DEFAULT_MNT_OPTS, s + 1);
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
index 714a359c7c8d..ca6b04af727f 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -96,7 +96,7 @@ enum {
 	Opt_multiuser, Opt_sloppy, Opt_nosharesock,
 	Opt_persistent, Opt_nopersistent,
 	Opt_resilient, Opt_noresilient,
-	Opt_domainauto, Opt_rdma,
+	Opt_domainauto, Opt_rdma, Opt_rootfs,
 
 	/* Mount options which take numeric value */
 	Opt_backupuid, Opt_backupgid, Opt_uid,
@@ -259,6 +259,7 @@ static const match_table_t cifs_mount_option_tokens = {
 	{ Opt_ignore, "nomand" },
 	{ Opt_ignore, "relatime" },
 	{ Opt_ignore, "_netdev" },
+	{ Opt_rootfs, "rootfs" },
 
 	{ Opt_err, NULL }
 };
@@ -1744,6 +1745,11 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
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
@@ -2662,7 +2668,8 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 		goto out_err_crypto_release;
 	}
 
-	tcp_ses->noblocksnd = volume_info->noblocksnd;
+	tcp_ses->noblockcnt = volume_info->rootfs;
+	tcp_ses->noblocksnd = volume_info->noblocksnd || volume_info->rootfs;
 	tcp_ses->noautotune = volume_info->noautotune;
 	tcp_ses->tcp_nodelay = volume_info->sockopt_tcp_nodelay;
 	tcp_ses->rdma = volume_info->rdma;
@@ -3768,7 +3775,11 @@ generic_ip_connect(struct TCP_Server_Info *server)
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
2.22.0

