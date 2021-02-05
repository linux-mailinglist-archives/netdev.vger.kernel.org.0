Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47DF4310FB0
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 19:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233735AbhBEQbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 11:31:37 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:12005 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233594AbhBEQ3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 11:29:11 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601d8a2c0000>; Fri, 05 Feb 2021 10:10:52 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 5 Feb
 2021 18:10:51 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>, <mst@redhat.com>,
        <jasowang@redhat.com>
CC:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH iproute2-next v4 5/5] vdpa: Add vdpa tool
Date:   Fri, 5 Feb 2021 20:10:29 +0200
Message-ID: <20210205181029.365461-6-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210205181029.365461-1-parav@nvidia.com>
References: <20210122112654.9593-3-parav@nvidia.com>
 <20210205181029.365461-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612548652; bh=oT1cdlZAMAYKVC9lTRh6+SY/tSU4tDToomW7DcDdm0U=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=kQ2BEpllAdZ1zgS+zLnv09HIZX3peHhvpyjea8LvD7g/aOYajJZWMD+Rjzz7zZVyE
         PWwAyAkRrAnllNenVCcrIdiXrW4fc6AmGsWj3Eu8QvVr9nG4tV9Cb7kfAabkA/z/Td
         rtL2m0ZCXd95U/HIPtOh8cVAEjGGhTNV1rStc9Z0/McEnXDufccnhq5QRGSJQCG5X1
         afu8UbyB2jBKeOuL+rrS5TkQVBUh6eiv4INhJDsA8uBrY2UA8gvhNbuVDQ71a2p3P9
         RiJsQffNOryMmmrUf8QN+cpvp1Eu80KIsXrb90sd8GzPRSiO0s1PiST6G3U/64NKDX
         rugZfymjMPWPA==
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
 Makefile                |   2 +-
 man/man8/vdpa-dev.8     |  96 ++++++
 man/man8/vdpa-mgmtdev.8 |  53 ++++
 man/man8/vdpa.8         |  76 +++++
 vdpa/Makefile           |  25 ++
 vdpa/vdpa.c             | 675 ++++++++++++++++++++++++++++++++++++++++
 6 files changed, 926 insertions(+), 1 deletion(-)
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
index 00000000..253e20a7
--- /dev/null
+++ b/vdpa/Makefile
@@ -0,0 +1,25 @@
+# SPDX-License-Identifier: GPL-2.0
+include ../config.mk
+
+TARGETS :=3D
+
+ifeq ($(HAVE_MNL),y)
+
+CFLAGS +=3D -I./include/uapi/
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
index 00000000..7fdb36b9
--- /dev/null
+++ b/vdpa/vdpa.c
@@ -0,0 +1,675 @@
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
+#define VDPA_OPT_VDEV_NAME		BIT(2)
+#define VDPA_OPT_VDEV_HANDLE		BIT(3)
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
+static struct str_num_map class_map[] =3D {
+	{ .str =3D "net", .num =3D VIRTIO_ID_NET },
+	{ .str =3D "block", .num =3D VIRTIO_ID_BLOCK },
+	{ .str =3D NULL, },
+};
+
+static const char *parse_class(int num)
+{
+	const char *class;
+
+	class =3D str_map_lookup_uint(class_map, num);
+	return class ? class : "< unknown class >";
+}
+
+static void pr_out_mgmtdev_show(struct vdpa *vdpa, const struct nlmsghdr *=
nlh,
+				struct nlattr **tb)
+{
+	const char *class;
+	unsigned int i;
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
+			class =3D parse_class(i);
+			print_string(PRINT_ANY, NULL, " %s", class);
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

