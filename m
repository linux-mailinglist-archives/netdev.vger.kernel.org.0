Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1162307E67
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 19:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbhA1SrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 13:47:05 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:18889 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232371AbhA1Som (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 13:44:42 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601305d90000>; Thu, 28 Jan 2021 10:43:37 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 28 Jan
 2021 18:43:36 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>, <mst@redhat.com>,
        <jasowang@redhat.com>
CC:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH iproute2-next v2 2/2] vdpa: Add vdpa tool
Date:   Thu, 28 Jan 2021 20:43:19 +0200
Message-ID: <20210128184319.29174-3-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210128184319.29174-1-parav@nvidia.com>
References: <20210122112654.9593-3-parav@nvidia.com>
 <20210128184319.29174-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611859417; bh=PXCxngBNPcI1v0oC/synrunfVPln7SgLLh7rZR9j+rg=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=m/ifcZ9VdsEdqxO4lhd5A5zvo4gYy0bSD1uOL/ibNuhS+9Wg2/wJCnhSmXc0izLXj
         qq62WGTK8A1aNbO489t2Kyw3+H5uLi9FTzYPPyHEccdZb4KcMS8mzNGlo3ahrsS6St
         e4QGq24XfbL4tEajvGtkp1iV7R88jlxFoa8ohkzJ2t829OsES3r48tc8mq5JYVgYGv
         Ht8ELYYkXhEaSEM8cwuLHh4h/5bmONghswRHEGIwUuZ1wi/AqFoT8KAWPAs6w85ksZ
         VF9Hmn+M1YFeeSqzdodu0ug0cNhlU72rM7d5nww9PpoHDCDBTsb5kaXhcjqo9aen8z
         IDAkjwpomCt0w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vdpa tool is created to create, delete and query vdpa devices.
examples:
Show vdpa management device that supports creating, deleting vdpa devices.

$ vdpa mgmtdev show
vdpasim:
  supported_classes net

$ vdpa mgmtdev show -jp
{
    "show": {
        "vdpasim": {
            "supported_classes": [ "net" ]
        }
    }
}

Create a vdpa device of type networking named as "foo2" from
the management device vdpasim_net:

$ vdpa dev add mgmtdev vdpasim_net name foo2

Show the newly created vdpa device by its name:
$ vdpa dev show foo2
foo2: type network mgmtdev vdpasim_net vendor_id 0 max_vqs 2 max_vq_size 25=
6

$ vdpa dev show foo2 -jp
{
    "dev": {
        "foo2": {
            "type": "network",
            "mgmtdev": "vdpasim_net",
            "vendor_id": 0,
            "max_vqs": 2,
            "max_vq_size": 256
        }
    }
}

Delete the vdpa device after its use:
$ vdpa dev del foo2

Signed-off-by: Parav Pandit <parav@nvidia.com>
---
changelog:
v1->v2:
 - added and used library helpers for socket communication
 - added and used library functions for string processing helpers
 - added and used library functions indent processing helpers
---
 Makefile                |   2 +-
 include/mnl_utils.h     |  16 +
 include/utils.h         |  16 +
 lib/mnl_utils.c         | 121 ++++++++
 lib/utils.c             |  66 ++++
 man/man8/vdpa-dev.8     |  96 ++++++
 man/man8/vdpa-mgmtdev.8 |  53 ++++
 man/man8/vdpa.8         |  76 +++++
 vdpa/Makefile           |  24 ++
 vdpa/vdpa.c             | 669 ++++++++++++++++++++++++++++++++++++++++
 10 files changed, 1138 insertions(+), 1 deletion(-)
 create mode 100644 man/man8/vdpa-dev.8
 create mode 100644 man/man8/vdpa-mgmtdev.8
 create mode 100644 man/man8/vdpa.8
 create mode 100644 vdpa/Makefile
 create mode 100644 vdpa/vdpa.c

diff --git a/Makefile b/Makefile
index e64c6599..19bd163e 100644
--- a/Makefile
+++ b/Makefile
@@ -55,7 +55,7 @@ WFLAGS +=3D -Wmissing-declarations -Wold-style-definition=
 -Wformat=3D2
 CFLAGS :=3D $(WFLAGS) $(CCOPTS) -I../include -I../include/uapi $(DEFINES) =
$(CFLAGS)
 YACCFLAGS =3D -d -t -v
=20
-SUBDIRS=3Dlib ip tc bridge misc netem genl tipc devlink rdma dcb man
+SUBDIRS=3Dlib ip tc bridge misc netem genl tipc devlink rdma dcb man vdpa
=20
 LIBNETLINK=3D../lib/libutil.a ../lib/libnetlink.a
 LDLIBS +=3D $(LIBNETLINK)
diff --git a/include/mnl_utils.h b/include/mnl_utils.h
index fa826ef1..9e7d6879 100644
--- a/include/mnl_utils.h
+++ b/include/mnl_utils.h
@@ -2,6 +2,22 @@
 #ifndef __MNL_UTILS_H__
 #define __MNL_UTILS_H__ 1
=20
+struct mnlu_gen_socket {
+	struct mnl_socket *nl;
+	char *buf;
+	uint32_t family;
+	unsigned int seq;
+	uint8_t version;
+};
+
+int mnlu_gen_socket_open(struct mnlu_gen_socket *nlg, const char *family_n=
ame,
+			 uint8_t version);
+void mnlu_gen_socket_close(struct mnlu_gen_socket *nlg);
+struct nlmsghdr *mnlu_gen_socket_cmd_prepare(struct mnlu_gen_socket *nlg,
+					     uint8_t cmd, uint16_t flags);
+int mnlu_gen_socket_sndrcv(struct mnlu_gen_socket *nlg, const struct nlmsg=
hdr *nlh,
+			   mnl_cb_t data_cb, void *data);
+
 struct mnl_socket *mnlu_socket_open(int bus);
 struct nlmsghdr *mnlu_msg_prepare(void *buf, uint32_t nlmsg_type, uint16_t=
 flags,
 				  void *extra_header, size_t extra_header_size);
diff --git a/include/utils.h b/include/utils.h
index f1403f73..a35e5103 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -340,4 +340,20 @@ int parse_mapping(int *argcp, char ***argvp, bool allo=
w_all,
 		  int (*mapping_cb)(__u32 key, char *value, void *data),
 		  void *mapping_cb_data);
=20
+unsigned int get_str_char_count(const char *str, int match);
+int str_split_by_char(char *str, char **before, char **after, int match);
+
+#define INDENT_STR_MAXLEN 32
+
+struct indent_mem {
+	int indent_level;
+	char indent_str[INDENT_STR_MAXLEN + 1];
+};
+=20
+struct indent_mem *alloc_indent_mem(void);
+void free_indent_mem(struct indent_mem *mem);
+void inc_indent(struct indent_mem *mem);
+void dec_indent(struct indent_mem *mem);
+void print_indent(struct indent_mem *mem);
+
 #endif /* __UTILS_H__ */
diff --git a/lib/mnl_utils.c b/lib/mnl_utils.c
index 46384ff8..4f699455 100644
--- a/lib/mnl_utils.c
+++ b/lib/mnl_utils.c
@@ -7,6 +7,7 @@
 #include <string.h>
 #include <time.h>
 #include <libmnl/libmnl.h>
+#include <linux/genetlink.h>
=20
 #include "libnetlink.h"
 #include "mnl_utils.h"
@@ -108,3 +109,123 @@ int mnlu_socket_recv_run(struct mnl_socket *nl, unsig=
ned int seq, void *buf, siz
=20
 	return err;
 }
+
+static int get_family_id_attr_cb(const struct nlattr *attr, void *data)
+{
+	int type =3D mnl_attr_get_type(attr);
+	const struct nlattr **tb =3D data;
+
+	if (mnl_attr_type_valid(attr, CTRL_ATTR_MAX) < 0)
+		return MNL_CB_ERROR;
+
+	if (type =3D=3D CTRL_ATTR_FAMILY_ID &&
+	    mnl_attr_validate(attr, MNL_TYPE_U16) < 0)
+		return MNL_CB_ERROR;
+	tb[type] =3D attr;
+	return MNL_CB_OK;
+}
+
+static int get_family_id_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct genlmsghdr *genl =3D mnl_nlmsg_get_payload(nlh);
+	struct nlattr *tb[CTRL_ATTR_MAX + 1] =3D {};
+	uint32_t *p_id =3D data;
+
+	mnl_attr_parse(nlh, sizeof(*genl), get_family_id_attr_cb, tb);
+	if (!tb[CTRL_ATTR_FAMILY_ID])
+		return MNL_CB_ERROR;
+	*p_id =3D mnl_attr_get_u16(tb[CTRL_ATTR_FAMILY_ID]);
+	return MNL_CB_OK;
+}
+
+static int family_get(struct mnlu_gen_socket *nlg, const char *family_name=
)
+{
+	struct genlmsghdr hdr =3D {};
+	struct nlmsghdr *nlh;
+	int err;
+
+	hdr.cmd =3D CTRL_CMD_GETFAMILY;
+	hdr.version =3D 0x1;
+
+	nlh =3D mnlu_msg_prepare(nlg->buf, GENL_ID_CTRL,
+			       NLM_F_REQUEST | NLM_F_ACK,
+			       &hdr, sizeof(hdr));
+
+	mnl_attr_put_strz(nlh, CTRL_ATTR_FAMILY_NAME, family_name);
+
+	err =3D mnl_socket_sendto(nlg->nl, nlh, nlh->nlmsg_len);
+	if (err < 0)
+		return err;
+
+	err =3D mnlu_socket_recv_run(nlg->nl, nlh->nlmsg_seq, nlg->buf,
+				   MNL_SOCKET_BUFFER_SIZE,
+				   get_family_id_cb, &nlg->family);
+	return err;
+}
+
+int mnlu_gen_socket_open(struct mnlu_gen_socket *nlg, const char *family_n=
ame,
+			 uint8_t version)
+{
+	int err;
+
+	nlg->buf =3D malloc(MNL_SOCKET_BUFFER_SIZE);
+	if (!nlg->buf)
+		goto err_buf_alloc;
+
+	nlg->nl =3D mnlu_socket_open(NETLINK_GENERIC);
+	if (!nlg->nl)
+		goto err_socket_open;
+
+	err =3D family_get(nlg, family_name);
+	if (err)
+		goto err_socket;
+
+	return 0;
+
+err_socket:
+	mnl_socket_close(nlg->nl);
+err_socket_open:
+	free(nlg->buf);
+err_buf_alloc:
+	return -1;
+}
+
+void mnlu_gen_socket_close(struct mnlu_gen_socket *nlg)
+{
+	mnl_socket_close(nlg->nl);
+	free(nlg->buf);
+}
+
+struct nlmsghdr *mnlu_gen_socket_cmd_prepare(struct mnlu_gen_socket *nlg,
+					     uint8_t cmd, uint16_t flags)
+{
+	struct genlmsghdr hdr =3D {};
+	struct nlmsghdr *nlh;
+
+	hdr.cmd =3D cmd;
+	hdr.version =3D nlg->version;
+	nlh =3D mnlu_msg_prepare(nlg->buf, nlg->family, flags, &hdr, sizeof(hdr))=
;
+	nlg->seq =3D nlh->nlmsg_seq;
+	return nlh;
+}
+
+int mnlu_gen_socket_sndrcv(struct mnlu_gen_socket *nlg, const struct nlmsg=
hdr *nlh,
+			   mnl_cb_t data_cb, void *data)
+{
+	int err;
+
+	err =3D mnl_socket_sendto(nlg->nl, nlh, nlh->nlmsg_len);
+	if (err < 0) {
+		perror("Failed to send data");
+		return -errno;
+	}
+
+	err =3D mnlu_socket_recv_run(nlg->nl, nlh->nlmsg_seq, nlg->buf,
+				   MNL_SOCKET_BUFFER_SIZE,
+				   data_cb, data);
+	if (err < 0) {
+		fprintf(stderr, "kernel answers: %s\n", strerror(errno));
+		return -errno;
+	}
+	return 0;
+}
diff --git a/lib/utils.c b/lib/utils.c
index 90e58fa3..3c544fd3 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -1937,3 +1937,69 @@ int parse_mapping(int *argcp, char ***argvp, bool al=
low_all,
 		return parse_mapping_gen(argcp, argvp, parse_mapping_num,
 					 mapping_cb, mapping_cb_data);
 }
+
+unsigned int get_str_char_count(const char *str, int match)
+{
+	unsigned int count =3D 0;
+	const char *pos =3D str;
+
+	while ((pos =3D strchr(pos, match))) {
+		count++;
+		pos++;
+	}
+	return count;
+}
+
+int str_split_by_char(char *str, char **before, char **after, int match)
+{
+	char *slash;
+
+	slash =3D strrchr(str, match);
+	if (!slash)
+		return -EINVAL;
+	*slash =3D '\0';
+	*before =3D str;
+	*after =3D slash + 1;
+	return 0;
+}
+
+struct indent_mem *alloc_indent_mem(void)
+{
+	struct indent_mem *mem =3D malloc(sizeof(*mem));
+
+	if (!mem)
+		return NULL;
+	strcpy(mem->indent_str, "");
+	mem->indent_level =3D 0;
+	return mem;
+}
+
+void free_indent_mem(struct indent_mem *mem)
+{
+	free(mem);
+}
+
+#define INDENT_STR_STEP 2
+
+void inc_indent(struct indent_mem *mem)
+{
+	if (mem->indent_level + INDENT_STR_STEP > INDENT_STR_MAXLEN)
+		return;
+	mem->indent_level +=3D INDENT_STR_STEP;
+	memset(mem->indent_str, ' ', sizeof(mem->indent_str));
+	mem->indent_str[mem->indent_level] =3D '\0';
+}
+
+void dec_indent(struct indent_mem *mem)
+{
+	if (mem->indent_level - INDENT_STR_STEP < 0)
+		return;
+	mem->indent_level -=3D INDENT_STR_STEP;
+	mem->indent_str[mem->indent_level] =3D '\0';
+}
+
+void print_indent(struct indent_mem *mem)
+{
+	if (mem->indent_level)
+		printf("%s", mem->indent_str);
+}
diff --git a/man/man8/vdpa-dev.8 b/man/man8/vdpa-dev.8
new file mode 100644
index 00000000..36433519
--- /dev/null
+++ b/man/man8/vdpa-dev.8
@@ -0,0 +1,96 @@
+.TH DEVLINK\-DEV 8 "5 Jan 2021" "iproute2" "Linux"
+.SH NAME
+vdpa-dev \- vdpa device configuration
+.SH SYNOPSIS
+.sp
+.ad l
+.in +8
+.ti -8
+.B vdpa
+.B dev
+.RI "[ " OPTIONS " ] "
+.RI  " { " COMMAND | " "
+.BR help " }"
+.sp
+
+.ti -8
+.IR OPTIONS " :=3D { "
+\fB\-V\fR[\fIersion\fR]
+}
+
+.ti -8
+.B vdpa dev show
+.RI "[ " DEV " ]"
+
+.ti -8
+.B vdpa dev help
+
+.ti -8
+.B vdpa dev add
+.B name
+.I NAME
+.B mgmtdev
+.I MGMTDEV
+
+.ti -8
+.B vdpa dev del
+.I DEV
+
+.SH "DESCRIPTION"
+.SS vdpa dev show - display vdpa device attributes
+
+.PP
+.I "DEV"
+- specifies the vdpa device to show.
+If this argument is omitted all devices are listed.
+
+.in +4
+Format is:
+.in +2
+VDPA_DEVICE_NAME
+
+.SS vdpa dev add - add a new vdpa device.
+
+.TP
+.BI name " NAME"
+Name of the new vdpa device to add.
+
+.TP
+.BI mgmtdev " MGMTDEV"
+Name of the management device to use for device addition.
+
+.SS vdpa dev del - Delete the vdpa device.
+
+.PP
+.I "DEV"
+- specifies the vdpa device to delete.
+
+.SH "EXAMPLES"
+.PP
+vdpa dev show
+.RS 4
+Shows the all vdpa devices on the system.
+.RE
+.PP
+vdpa dev show foo
+.RS 4
+Shows the specified vdpa device.
+.RE
+.PP
+vdpa dev add name foo mgmtdev vdpa_sim_net
+.RS 4
+Add the vdpa device named foo on the management device vdpa_sim_net.
+.RE
+.PP
+vdpa dev del foo
+.RS 4
+Delete the vdpa device named foo which was previously created.
+.RE
+
+.SH SEE ALSO
+.BR vdpa (8),
+.BR vdpa-mgmtdev (8),
+.br
+
+.SH AUTHOR
+Parav Pandit <parav@nvidia.com>
diff --git a/man/man8/vdpa-mgmtdev.8 b/man/man8/vdpa-mgmtdev.8
new file mode 100644
index 00000000..cae2cbd0
--- /dev/null
+++ b/man/man8/vdpa-mgmtdev.8
@@ -0,0 +1,53 @@
+.TH DEVLINK\-DEV 8 "5 Jan 2021" "iproute2" "Linux"
+.SH NAME
+vdpa-dev \- vdpa management device view
+.SH SYNOPSIS
+.sp
+.ad l
+.in +8
+.ti -8
+.B vdpa
+.B mgmtdev
+.RI  " { " COMMAND | " "
+.BR help " }"
+.sp
+
+.ti -8
+.IR OPTIONS " :=3D { "
+\fB\-V\fR[\fIersion\fR]
+}
+
+.ti -8
+.B vdpa mgmtdev show
+.RI "[ " MGMTDEV " ]"
+
+.ti -8
+.B vdpa mgmtdev help
+
+.SH "DESCRIPTION"
+.SS vdpa mgmtdev show - display vdpa management device attributes
+
+.PP
+.I "MGMTDEV"
+- specifies the vdpa management device to show.
+If this argument is omitted all management devices are listed.
+
+.SH "EXAMPLES"
+.PP
+vdpa mgmtdev show
+.RS 4
+Shows all the vdpa management devices on the system.
+.RE
+.PP
+vdpa mgmtdev show bar
+.RS 4
+Shows the specified vdpa management device.
+.RE
+
+.SH SEE ALSO
+.BR vdpa (8),
+.BR vdpa-dev (8),
+.br
+
+.SH AUTHOR
+Parav Pandit <parav@nvidia.com>
diff --git a/man/man8/vdpa.8 b/man/man8/vdpa.8
new file mode 100644
index 00000000..d1aaecec
--- /dev/null
+++ b/man/man8/vdpa.8
@@ -0,0 +1,76 @@
+.TH VDPA 8 "5 Jan 2021" "iproute2" "Linux"
+.SH NAME
+vdpa \- vdpa management tool
+.SH SYNOPSIS
+.sp
+.ad l
+.in +8
+.ti -8
+.B vdpa
+.RI "[ " OPTIONS " ] { " dev | mgmtdev " } { " COMMAND " | "
+.BR help " }"
+.sp
+
+.SH OPTIONS
+
+.TP
+.BR "\-V" , " --Version"
+Print the version of the
+.B vdpa
+utility and exit.
+
+.TP
+.BR "\-j" , " --json"
+Generate JSON output.
+
+.TP
+.BR "\-p" , " --pretty"
+When combined with -j generate a pretty JSON output.
+
+.SS
+.I OBJECT
+
+.TP
+.B dev
+- vdpa device.
+
+.TP
+.B mgmtdev
+- vdpa management device.
+
+.SS
+.I COMMAND
+
+Specifies the action to perform on the object.
+The set of possible actions depends on the object type.
+It is possible to
+.B show
+(or
+.B list
+) objects. The
+.B help
+command is available for all objects. It prints
+out a list of available commands and argument syntax conventions.
+.sp
+If no command is given, some default command is assumed.
+Usually it is
+.B show
+or, if the objects of this class cannot be listed,
+.BR "help" .
+
+.SH EXIT STATUS
+Exit status is 0 if command was successful or a positive integer upon fail=
ure.
+
+.SH SEE ALSO
+.BR vdpa-dev (8),
+.BR vdpa-mgmtdev (8),
+.br
+
+.SH REPORTING BUGS
+Report any bugs to the Network Developers mailing list
+.B <netdev@vger.kernel.org>
+where the development and maintenance is primarily done.
+You do not have to be subscribed to the list to send a message there.
+
+.SH AUTHOR
+Parav Pandit <parav@nvidia.com>
diff --git a/vdpa/Makefile b/vdpa/Makefile
new file mode 100644
index 00000000..275f9ded
--- /dev/null
+++ b/vdpa/Makefile
@@ -0,0 +1,24 @@
+# SPDX-License-Identifier: GPL-2.0
+include ../config.mk
+
+TARGETS :=3D
+
+ifeq ($(HAVE_MNL),y)
+
+VDPAOBJ =3D vdpa.o
+TARGETS +=3D vdpa
+
+endif
+
+all: $(TARGETS) $(LIBS)
+
+vdpa: $(VDPAOBJ)
+	$(QUIET_LINK)$(CC) $^ $(LDFLAGS) $(LDLIBS) -o $@
+
+install: all
+	for i in $(TARGETS); \
+	do install -m 0755 $$i $(DESTDIR)$(SBINDIR); \
+	done
+
+clean:
+	rm -f $(VDPAOBJ) $(TARGETS)
diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
new file mode 100644
index 00000000..2d17cb39
--- /dev/null
+++ b/vdpa/vdpa.c
@@ -0,0 +1,669 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#include <stdio.h>
+#include <getopt.h>
+#include <errno.h>
+#include <linux/genetlink.h>
+#include <linux/vdpa.h>
+#include <linux/virtio_ids.h>
+#include <linux/netlink.h>
+#include <libmnl/libmnl.h>
+#include "mnl_utils.h"
+
+#include "version.h"
+#include "json_print.h"
+#include "utils.h"
+
+#define VDPA_OPT_MGMTDEV_HANDLE		BIT(0)
+#define VDPA_OPT_VDEV_MGMTDEV_HANDLE	BIT(1)
+#define VDPA_OPT_VDEV_NAME 		BIT(2)
+#define VDPA_OPT_VDEV_HANDLE 		BIT(3)
+
+struct vdpa_opts {
+	uint64_t present; /* flags of present items */
+	char *mdev_bus_name;
+	char *mdev_name;
+	const char *vdev_name;
+	unsigned int device_id;
+};
+
+struct vdpa {
+	struct mnlu_gen_socket nlg;
+	struct vdpa_opts opts;
+	bool json_output;
+	struct indent_mem *indent;
+};
+
+static void pr_out_section_start(struct vdpa *vdpa, const char *name)
+{
+	open_json_object(NULL);
+	open_json_object(name);
+}
+
+static void pr_out_section_end(struct vdpa *vdpa)
+{
+	close_json_object();
+	close_json_object();
+}
+
+static void pr_out_array_start(struct vdpa *vdpa, const char *name)
+{
+	if (!vdpa->json_output) {
+		print_nl();
+		inc_indent(vdpa->indent);
+		print_indent(vdpa->indent);
+	}
+	open_json_array(PRINT_ANY, name);
+}
+
+static void pr_out_array_end(struct vdpa *vdpa)
+{
+	close_json_array(PRINT_JSON, NULL);
+	if (!vdpa->json_output)
+		dec_indent(vdpa->indent);
+}
+
+static const enum mnl_attr_data_type vdpa_policy[VDPA_ATTR_MAX + 1] =3D {
+	[VDPA_ATTR_MGMTDEV_BUS_NAME] =3D MNL_TYPE_NUL_STRING,
+	[VDPA_ATTR_MGMTDEV_DEV_NAME] =3D MNL_TYPE_NUL_STRING,
+	[VDPA_ATTR_DEV_NAME] =3D MNL_TYPE_STRING,
+	[VDPA_ATTR_DEV_ID] =3D MNL_TYPE_U32,
+	[VDPA_ATTR_DEV_VENDOR_ID] =3D MNL_TYPE_U32,
+	[VDPA_ATTR_DEV_MAX_VQS] =3D MNL_TYPE_U32,
+	[VDPA_ATTR_DEV_MAX_VQ_SIZE] =3D MNL_TYPE_U16,
+};
+
+static int attr_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb =3D data;
+	int type;
+
+	if (mnl_attr_type_valid(attr, VDPA_ATTR_MAX) < 0)
+		return MNL_CB_OK;
+
+	type =3D mnl_attr_get_type(attr);
+	if (mnl_attr_validate(attr, vdpa_policy[type]) < 0)
+		return MNL_CB_ERROR;
+
+	tb[type] =3D attr;
+	return MNL_CB_OK;
+}
+
+static int vdpa_argv_handle(struct vdpa *vdpa, int argc, char **argv,
+			    char **p_mdev_bus_name,
+			    char **p_mdev_name)
+{
+	unsigned int slashcount;
+	char *str;
+
+	if (argc <=3D 0 || *argv =3D=3D NULL) {
+		fprintf(stderr,
+			"vdpa identification (\"mgmtdev_bus_name/mgmtdev_name\") expected\n");
+		return -EINVAL;
+	}
+	str =3D *argv;
+	slashcount =3D get_str_char_count(str, '/');
+	if (slashcount > 1) {
+		fprintf(stderr,
+			"Wrong vdpa mgmtdev identification string format\n");
+		fprintf(stderr, "Expected \"mgmtdev_bus_name/mgmtdev_name\"\n");
+		fprintf(stderr, "Expected \"mgmtdev_name\"\n");
+		return -EINVAL;
+	}
+	switch (slashcount) {
+	case 0:
+		*p_mdev_bus_name =3D NULL;
+		*p_mdev_name =3D str;
+		return 0;
+	case 1:
+		str_split_by_char(str, p_mdev_bus_name, p_mdev_name, '/');
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
+static int vdpa_argv_str(struct vdpa *vdpa, int argc, char **argv,
+			 const char **p_str)
+{
+	if (argc <=3D 0 || *argv =3D=3D NULL) {
+		fprintf(stderr, "String parameter expected\n");
+		return -EINVAL;
+	}
+	*p_str =3D *argv;
+	return 0;
+}
+
+struct vdpa_args_metadata {
+	uint64_t o_flag;
+	const char *err_msg;
+};
+
+static const struct vdpa_args_metadata vdpa_args_required[] =3D {
+	{VDPA_OPT_VDEV_MGMTDEV_HANDLE, "management device handle not set."},
+	{VDPA_OPT_VDEV_NAME, "device name is not set."},
+	{VDPA_OPT_VDEV_HANDLE, "device name is not set."},
+};
+
+static int vdpa_args_finding_required_validate(uint64_t o_required,
+					       uint64_t o_found)
+{
+	uint64_t o_flag;
+	int i;
+
+	for (i =3D 0; i < ARRAY_SIZE(vdpa_args_required); i++) {
+		o_flag =3D vdpa_args_required[i].o_flag;
+		if ((o_required & o_flag) && !(o_found & o_flag)) {
+			fprintf(stderr, "%s\n", vdpa_args_required[i].err_msg);
+			return -EINVAL;
+		}
+	}
+	if (o_required & ~o_found) {
+		fprintf(stderr,
+			"BUG: unknown argument required but not found\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static void vdpa_opts_put(struct nlmsghdr *nlh, struct vdpa *vdpa)
+{
+	struct vdpa_opts *opts =3D &vdpa->opts;
+
+	if ((opts->present & VDPA_OPT_MGMTDEV_HANDLE) ||
+	    (opts->present & VDPA_OPT_VDEV_MGMTDEV_HANDLE)) {
+		if (opts->mdev_bus_name)
+			mnl_attr_put_strz(nlh, VDPA_ATTR_MGMTDEV_BUS_NAME,
+					  opts->mdev_bus_name);
+		mnl_attr_put_strz(nlh, VDPA_ATTR_MGMTDEV_DEV_NAME,
+				  opts->mdev_name);
+	}
+	if ((opts->present & VDPA_OPT_VDEV_NAME) ||
+	    (opts->present & VDPA_OPT_VDEV_HANDLE))
+		mnl_attr_put_strz(nlh, VDPA_ATTR_DEV_NAME, opts->vdev_name);
+}
+
+static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
+			   uint64_t o_required)
+{
+	struct vdpa_opts *opts =3D &vdpa->opts;
+	uint64_t o_all =3D o_required;
+	uint64_t o_found =3D 0;
+	int err;
+
+	if (o_required & VDPA_OPT_MGMTDEV_HANDLE) {
+		err =3D vdpa_argv_handle(vdpa, argc, argv, &opts->mdev_bus_name,
+				       &opts->mdev_name);
+		if (err)
+			return err;
+
+		NEXT_ARG_FWD();
+		o_found |=3D VDPA_OPT_MGMTDEV_HANDLE;
+	} else if (o_required & VDPA_OPT_VDEV_HANDLE) {
+		err =3D vdpa_argv_str(vdpa, argc, argv, &opts->vdev_name);
+		if (err)
+			return err;
+
+		NEXT_ARG_FWD();
+		o_found |=3D VDPA_OPT_VDEV_HANDLE;
+	}
+
+	while (NEXT_ARG_OK()) {
+		if ((matches(*argv, "name") =3D=3D 0) &&
+		    (o_all & VDPA_OPT_VDEV_NAME)) {
+			const char *namestr;
+
+			NEXT_ARG_FWD();
+			err =3D vdpa_argv_str(vdpa, argc, argv, &namestr);
+			if (err)
+				return err;
+			opts->vdev_name =3D namestr;
+			NEXT_ARG_FWD();
+			o_found |=3D VDPA_OPT_VDEV_NAME;
+		} else if ((matches(*argv, "mgmtdev")  =3D=3D 0) &&
+			   (o_all & VDPA_OPT_VDEV_MGMTDEV_HANDLE)) {
+			NEXT_ARG_FWD();
+			err =3D vdpa_argv_handle(vdpa, argc, argv,
+					       &opts->mdev_bus_name,
+					       &opts->mdev_name);
+			if (err)
+				return err;
+
+			NEXT_ARG_FWD();
+			o_found |=3D VDPA_OPT_VDEV_MGMTDEV_HANDLE;
+		} else {
+			fprintf(stderr, "Unknown option \"%s\"\n", *argv);
+			return -EINVAL;
+		}
+	}
+
+	opts->present =3D o_found;
+
+	return vdpa_args_finding_required_validate(o_required, o_found);
+}
+
+static int vdpa_argv_parse_put(struct nlmsghdr *nlh, struct vdpa *vdpa,
+			       int argc, char **argv,
+			       uint64_t o_required)
+{
+	int err;
+
+	err =3D vdpa_argv_parse(vdpa, argc, argv, o_required);
+	if (err)
+		return err;
+	vdpa_opts_put(nlh, vdpa);
+	return 0;
+}
+
+static void cmd_mgmtdev_help(void)
+{
+	fprintf(stderr, "Usage: vdpa mgmtdev show [ DEV ]\n");
+}
+
+static void pr_out_handle_start(struct vdpa *vdpa, struct nlattr **tb)
+{
+	const char *mdev_bus_name =3D NULL;
+	const char *mdev_name;
+	SPRINT_BUF(buf);
+
+	mdev_name =3D mnl_attr_get_str(tb[VDPA_ATTR_MGMTDEV_DEV_NAME]);
+	if (tb[VDPA_ATTR_MGMTDEV_BUS_NAME]) {
+		mdev_bus_name =3D mnl_attr_get_str(tb[VDPA_ATTR_MGMTDEV_BUS_NAME]);
+		sprintf(buf, "%s/%s", mdev_bus_name, mdev_name);
+	} else {
+		sprintf(buf, "%s", mdev_name);
+	}
+
+	if (vdpa->json_output)
+		open_json_object(buf);
+	else
+		printf("%s: ", buf);
+}
+
+static void pr_out_handle_end(struct vdpa *vdpa)
+{
+	if (vdpa->json_output)
+		close_json_object();
+	else
+		print_nl();
+}
+
+static void __pr_out_vdev_handle_start(struct vdpa *vdpa, const char *vdev=
_name)
+{
+	SPRINT_BUF(buf);
+
+	sprintf(buf, "%s", vdev_name);
+	if (vdpa->json_output)
+		open_json_object(buf);
+	else
+		printf("%s: ", buf);
+}
+
+static void pr_out_vdev_handle_start(struct vdpa *vdpa, struct nlattr **tb=
)
+{
+	const char *vdev_name;
+
+	vdev_name =3D mnl_attr_get_str(tb[VDPA_ATTR_DEV_NAME]);
+	__pr_out_vdev_handle_start(vdpa, vdev_name);
+}
+
+static void pr_out_vdev_handle_end(struct vdpa *vdpa)
+{
+	if (vdpa->json_output)
+		close_json_object();
+	else
+		print_nl();
+}
+
+static void pr_out_mgmtdev_show(struct vdpa *vdpa, const struct nlmsghdr *=
nlh,
+				  struct nlattr **tb)
+{
+	int i;
+
+	pr_out_handle_start(vdpa, tb);
+
+	if (tb[VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES]) {
+		uint64_t classes =3D mnl_attr_get_u64(tb[VDPA_ATTR_MGMTDEV_SUPPORTED_CLA=
SSES]);
+
+		pr_out_array_start(vdpa, "supported_classes");
+
+		for (i =3D 1; i < 64; i++) {
+			if ((classes & (1ULL << i)) =3D=3D 0)
+				continue;
+
+			switch (i) {
+			case VIRTIO_ID_NET:
+				print_string(PRINT_ANY, NULL, " %s", "net");
+				break;
+			case VIRTIO_ID_BLOCK:
+				print_string(PRINT_ANY, NULL, " %s", "block");
+				break;
+			default:
+				print_string(PRINT_ANY, NULL, " %s", "unknown");
+				break;
+			}
+		}
+		pr_out_array_end(vdpa);
+	}
+
+	pr_out_handle_end(vdpa);
+}
+
+static int cmd_mgmtdev_show_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct genlmsghdr *genl =3D mnl_nlmsg_get_payload(nlh);
+	struct nlattr *tb[VDPA_ATTR_MAX + 1] =3D {};
+	struct vdpa *vdpa =3D data;
+
+	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
+
+	if (!tb[VDPA_ATTR_MGMTDEV_DEV_NAME])
+		return MNL_CB_ERROR;
+
+	pr_out_mgmtdev_show(vdpa, nlh, tb);
+
+	return MNL_CB_OK;
+}
+
+static int cmd_mgmtdev_show(struct vdpa *vdpa, int argc, char **argv)
+{
+	uint16_t flags =3D NLM_F_REQUEST | NLM_F_ACK;
+	struct nlmsghdr *nlh;
+	int err;
+
+	if (argc =3D=3D 0)
+		flags |=3D NLM_F_DUMP;
+
+	nlh =3D mnlu_gen_socket_cmd_prepare(&vdpa->nlg, VDPA_CMD_MGMTDEV_GET,
+					  flags);
+	if (argc > 0) {
+		err =3D vdpa_argv_parse_put(nlh, vdpa, argc, argv,
+					  VDPA_OPT_MGMTDEV_HANDLE);
+		if (err)
+			return err;
+	}
+
+	pr_out_section_start(vdpa, "mgmtdev");
+	err =3D mnlu_gen_socket_sndrcv(&vdpa->nlg, nlh, cmd_mgmtdev_show_cb, vdpa=
);
+	pr_out_section_end(vdpa);
+	return err;
+}
+
+static int cmd_mgmtdev(struct vdpa *vdpa, int argc, char **argv)
+{
+	if (!argc || matches(*argv, "help") =3D=3D 0) {
+		cmd_mgmtdev_help();
+		return 0;
+	} else if (matches(*argv, "show") =3D=3D 0 ||
+		   matches(*argv, "list") =3D=3D 0) {
+		return cmd_mgmtdev_show(vdpa, argc - 1, argv + 1);
+	}
+	fprintf(stderr, "Command \"%s\" not found\n", *argv);
+	return -ENOENT;
+}
+
+static void cmd_dev_help(void)
+{
+	fprintf(stderr, "Usage: vdpa dev show [ DEV ]\n");
+	fprintf(stderr, "       vdpa dev add name NAME mgmtdev MANAGEMENTDEV\n");
+	fprintf(stderr, "       vdpa dev del DEV\n");
+}
+
+static const char *device_type_name(uint32_t type)
+{
+	switch (type) {
+	case 0x1: return "network";
+	case 0x2: return "block";
+	default: return "<unknown type>";
+	}
+}
+
+static void pr_out_dev(struct vdpa *vdpa, struct nlattr **tb)
+{
+	const char *mdev_name =3D mnl_attr_get_str(tb[VDPA_ATTR_MGMTDEV_DEV_NAME]=
);
+	uint32_t device_id =3D mnl_attr_get_u32(tb[VDPA_ATTR_DEV_ID]);
+	const char *mdev_bus_name =3D NULL;
+	char mgmtdev_buf[128];
+
+	if (tb[VDPA_ATTR_MGMTDEV_BUS_NAME])
+		mdev_bus_name =3D mnl_attr_get_str(tb[VDPA_ATTR_MGMTDEV_BUS_NAME]);
+
+	if (mdev_bus_name)
+		sprintf(mgmtdev_buf, "%s/%s", mdev_bus_name, mdev_name);
+	else
+		sprintf(mgmtdev_buf, "%s", mdev_name);
+	pr_out_vdev_handle_start(vdpa, tb);
+	print_string(PRINT_ANY, "type", "type %s", device_type_name(device_id));
+	print_string(PRINT_ANY, "mgmtdev", " mgmtdev %s", mgmtdev_buf);
+
+	if (tb[VDPA_ATTR_DEV_VENDOR_ID])
+		print_uint(PRINT_ANY, "vendor_id", " vendor_id %u",
+			   mnl_attr_get_u32(tb[VDPA_ATTR_DEV_VENDOR_ID]));
+	if (tb[VDPA_ATTR_DEV_MAX_VQS])
+		print_uint(PRINT_ANY, "max_vqs", " max_vqs %u",
+			   mnl_attr_get_u32(tb[VDPA_ATTR_DEV_MAX_VQS]));
+	if (tb[VDPA_ATTR_DEV_MAX_VQ_SIZE])
+		print_uint(PRINT_ANY, "max_vq_size", " max_vq_size %u",
+			   mnl_attr_get_u16(tb[VDPA_ATTR_DEV_MAX_VQ_SIZE]));
+	pr_out_vdev_handle_end(vdpa);
+}
+
+static int cmd_dev_show_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct genlmsghdr *genl =3D mnl_nlmsg_get_payload(nlh);
+	struct nlattr *tb[VDPA_ATTR_MAX + 1] =3D {};
+	struct vdpa *vdpa =3D data;
+
+	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
+	if (!tb[VDPA_ATTR_MGMTDEV_DEV_NAME] ||
+	    !tb[VDPA_ATTR_DEV_NAME] || !tb[VDPA_ATTR_DEV_ID])
+		return MNL_CB_ERROR;
+	pr_out_dev(vdpa, tb);
+	return MNL_CB_OK;
+}
+
+static int cmd_dev_show(struct vdpa *vdpa, int argc, char **argv)
+{
+	uint16_t flags =3D NLM_F_REQUEST | NLM_F_ACK;
+	struct nlmsghdr *nlh;
+	int err;
+
+	if (argc <=3D 0)
+		flags |=3D NLM_F_DUMP;
+
+	nlh =3D mnlu_gen_socket_cmd_prepare(&vdpa->nlg, VDPA_CMD_DEV_GET, flags);
+	if (argc > 0) {
+		err =3D vdpa_argv_parse_put(nlh, vdpa, argc, argv,
+					  VDPA_OPT_VDEV_HANDLE);
+		if (err)
+			return err;
+	}
+
+	pr_out_section_start(vdpa, "dev");
+	err =3D mnlu_gen_socket_sndrcv(&vdpa->nlg, nlh, cmd_dev_show_cb, vdpa);
+	pr_out_section_end(vdpa);
+	return err;
+}
+
+static int cmd_dev_add(struct vdpa *vdpa, int argc, char **argv)
+{
+	struct nlmsghdr *nlh;
+	int err;
+
+	nlh =3D mnlu_gen_socket_cmd_prepare(&vdpa->nlg, VDPA_CMD_DEV_NEW,
+					  NLM_F_REQUEST | NLM_F_ACK);
+	err =3D vdpa_argv_parse_put(nlh, vdpa, argc, argv,
+				  VDPA_OPT_VDEV_MGMTDEV_HANDLE | VDPA_OPT_VDEV_NAME);
+	if (err)
+		return err;
+
+	return mnlu_gen_socket_sndrcv(&vdpa->nlg, nlh, NULL, NULL);
+}
+
+static int cmd_dev_del(struct vdpa *vdpa,  int argc, char **argv)
+{
+	struct nlmsghdr *nlh;
+	int err;
+
+	nlh =3D mnlu_gen_socket_cmd_prepare(&vdpa->nlg, VDPA_CMD_DEV_DEL,
+					  NLM_F_REQUEST | NLM_F_ACK);
+	err =3D vdpa_argv_parse_put(nlh, vdpa, argc, argv, VDPA_OPT_VDEV_HANDLE);
+	if (err)
+		return err;
+
+	return mnlu_gen_socket_sndrcv(&vdpa->nlg, nlh, NULL, NULL);
+}
+
+static int cmd_dev(struct vdpa *vdpa, int argc, char **argv)
+{
+	if (!argc)
+		return cmd_dev_show(vdpa, argc - 1, argv + 1);
+
+	if (matches(*argv, "help") =3D=3D 0) {
+		cmd_dev_help();
+		return 0;
+	} else if (matches(*argv, "show") =3D=3D 0 ||
+		   matches(*argv, "list") =3D=3D 0) {
+		return cmd_dev_show(vdpa, argc - 1, argv + 1);
+	} else if (matches(*argv, "add") =3D=3D 0) {
+		return cmd_dev_add(vdpa, argc - 1, argv + 1);
+	} else if (matches(*argv, "del") =3D=3D 0) {
+		return cmd_dev_del(vdpa, argc - 1, argv + 1);
+	}
+	fprintf(stderr, "Command \"%s\" not found\n", *argv);
+	return -ENOENT;
+}
+
+static void help(void)
+{
+	fprintf(stderr,
+		"Usage: vdpa [ OPTIONS ] OBJECT { COMMAND | help }\n"
+		"where  OBJECT :=3D { mgmtdev | dev }\n"
+		"       OPTIONS :=3D { -V[ersion] | -n[o-nice-names] | -j[son] | -p[rett=
y] | -v[erbose] }\n");
+}
+
+static int vdpa_cmd(struct vdpa *vdpa, int argc, char **argv)
+{
+	if (!argc || matches(*argv, "help") =3D=3D 0) {
+		help();
+		return 0;
+	} else if (matches(*argv, "mgmtdev") =3D=3D 0) {
+		return cmd_mgmtdev(vdpa, argc - 1, argv + 1);
+	} else if (matches(*argv, "dev") =3D=3D 0) {
+		return cmd_dev(vdpa, argc - 1, argv + 1);
+	}
+	fprintf(stderr, "Object \"%s\" not found\n", *argv);
+	return -ENOENT;
+}
+
+static int vdpa_init(struct vdpa *vdpa)
+{
+	int err;
+
+	err =3D mnlu_gen_socket_open(&vdpa->nlg, VDPA_GENL_NAME,
+				   VDPA_GENL_VERSION);
+	if (err) {
+		fprintf(stderr, "Failed to connect to vdpa Netlink\n");
+		return -errno;
+	}
+	new_json_obj_plain(vdpa->json_output);
+	return 0;
+}
+
+static void vdpa_fini(struct vdpa *vdpa)
+{
+	delete_json_obj_plain();
+	mnlu_gen_socket_close(&vdpa->nlg);
+}
+
+static struct vdpa *vdpa_alloc(void)
+{
+	struct vdpa *vdpa =3D calloc(1, sizeof(struct vdpa));
+
+	if (!vdpa)
+		return NULL;
+
+	vdpa->indent =3D alloc_indent_mem();
+	if (!vdpa->indent)
+		goto indent_err;
+
+	return vdpa;
+
+indent_err:
+	free(vdpa);
+	return NULL;
+}
+
+static void vdpa_free(struct vdpa *vdpa)
+{
+	free_indent_mem(vdpa->indent);
+	free(vdpa);
+}
+
+int main(int argc, char **argv)
+{
+	static const struct option long_options[] =3D {
+		{ "Version",		no_argument,	NULL, 'V' },
+		{ "json",		no_argument,	NULL, 'j' },
+		{ "pretty",		no_argument,	NULL, 'p' },
+		{ "help",		no_argument,	NULL, 'h' },
+		{ NULL, 0, NULL, 0 }
+	};
+	struct vdpa *vdpa;
+	int opt;
+	int err;
+	int ret;
+
+	vdpa =3D vdpa_alloc();
+	if (!vdpa) {
+		fprintf(stderr, "Failed to allocate memory for vdpa\n");
+		return EXIT_FAILURE;
+	}
+
+	while ((opt =3D getopt_long(argc, argv, "Vjpsh", long_options, NULL)) >=
=3D 0) {
+		switch (opt) {
+		case 'V':
+			printf("vdpa utility, iproute2-%s\n", version);
+			ret =3D EXIT_SUCCESS;
+			goto vdpa_free;
+		case 'j':
+			vdpa->json_output =3D true;
+			break;
+		case 'p':
+			pretty =3D true;
+			break;
+		case 'h':
+			help();
+			ret =3D EXIT_SUCCESS;
+			goto vdpa_free;
+		default:
+			fprintf(stderr, "Unknown option.\n");
+			help();
+			ret =3D EXIT_FAILURE;
+			goto vdpa_free;
+		}
+	}
+
+	argc -=3D optind;
+	argv +=3D optind;
+
+	err =3D vdpa_init(vdpa);
+	if (err) {
+		ret =3D EXIT_FAILURE;
+		goto vdpa_free;
+	}
+
+	err =3D vdpa_cmd(vdpa, argc, argv);
+	if (err) {
+		ret =3D EXIT_FAILURE;
+		goto vdpa_fini;
+	}
+
+	ret =3D EXIT_SUCCESS;
+
+vdpa_fini:
+	vdpa_fini(vdpa);
+vdpa_free:
+	vdpa_free(vdpa);
+	return ret;
+}
--=20
2.26.2

