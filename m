Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5908830B228
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 22:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232326AbhBAVg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 16:36:58 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:4885 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232109AbhBAVgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 16:36:53 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6018744c0000>; Mon, 01 Feb 2021 13:36:12 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 1 Feb
 2021 21:36:12 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <dsahern@gmail.com>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH iproute2-next v2 4/6] devlink: Supporting add and delete of devlink port
Date:   Mon, 1 Feb 2021 23:35:49 +0200
Message-ID: <20210201213551.8503-5-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210201213551.8503-1-parav@nvidia.com>
References: <20210129165608.134965-1-parav@nvidia.com>
 <20210201213551.8503-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612215372; bh=7g9V5bpCBjM3CGPMDLlsBYukrdkFM7IjdeR/H7j4zMs=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=R77Kvqevm268v3AOU1+FzvwqXBBCt812f1L3dbTym94Qvpxbnj5mqEeE4twcHJAq5
         jsyhFHATUwxxJGmQRyJfYQqgzjSkqJUcCKjK5aiKmfwdnmqhhH4mVeAVpITAR/KLmD
         N08RPMl/zMTuEdwYoYsLoAqnbvCr3uPdrVBWjvkQl8uLzePOnctDjqE/mHYJ7TiJsL
         gypn+Yhr7HShll8iO9ef20cdh8Y1Cqn3yCzZu551tdmPxNcDcAU5owHA6ymiYPA5nr
         w7T9l5klsvu019qgqFvI+jp0wEd2e4N9kGxOyaXveU6uA7YMQnAyJNKOMahfHG+EGE
         0zhkJS3ZbJBGw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable user to add and delete the devlink port.

Examples for adding and deleting one SF port:

Examples of add, show and delete commands:
$ devlink dev eswitch set pci/0000:06:00.0 mode switchdev

$ devlink port show
pci/0000:06:00.0/65535: type eth netdev ens2f0np0 flavour physical port 0 s=
plittable false

Add devlink port of flavour 'pcipf' for PF number 0 SF number 88:

$ devlink port add pci/0000:06:00.0 flavour pcisf pfnum 0 sfnum 88
pci/0000:06:00.0/32768: type eth netdev eth6 flavour pcisf controller 0 pfn=
um 0 sfnum 88 splittable false
  function:
    hw_addr 00:00:00:00:00:00 state inactive opstate detached

Delete newly added devlink port
$ devlink port del pci/0000:06:00.0/32768

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
changelog:
v1->v2:
 - addressed David's comment to use struct for string->num mapping
   using helper library routine
---
 devlink/devlink.c       | 108 ++++++++++++++++++++++++++++++++++++++++
 man/man8/devlink-port.8 |  63 +++++++++++++++++++++++
 2 files changed, 171 insertions(+)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 338cb035..76ea7cac 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -306,6 +306,9 @@ static void ifname_map_free(struct ifname_map *ifname_m=
ap)
 #define DL_OPT_FLASH_OVERWRITE		BIT(39)
 #define DL_OPT_RELOAD_ACTION		BIT(40)
 #define DL_OPT_RELOAD_LIMIT	BIT(41)
+#define DL_OPT_PORT_FLAVOUR BIT(42)
+#define DL_OPT_PORT_PFNUMBER BIT(43)
+#define DL_OPT_PORT_SFNUMBER BIT(44)
=20
 struct dl_opts {
 	uint64_t present; /* flags of present items */
@@ -356,6 +359,9 @@ struct dl_opts {
 	uint32_t overwrite_mask;
 	enum devlink_reload_action reload_action;
 	enum devlink_reload_limit reload_limit;
+	uint32_t port_sfnumber;
+	uint16_t port_flavour;
+	uint16_t port_pfnumber;
 };
=20
 struct dl {
@@ -1394,6 +1400,17 @@ static struct str_num_map port_flavour_map[] =3D {
 	{ .str =3D NULL, },
 };
=20
+static int port_flavour_parse(const char *flavour, uint16_t *value)
+{
+	int num;
+
+	num =3D str_map_lookup_str(port_flavour_map, flavour);
+	if (num < 0)
+		return num;
+	*value =3D num;
+	return 0;
+}
+
 struct dl_args_metadata {
 	uint64_t o_flag;
 	char err_msg[DL_ARGS_REQUIRED_MAX_ERR_LEN];
@@ -1425,6 +1442,8 @@ static const struct dl_args_metadata dl_args_required=
[] =3D {
 	{DL_OPT_TRAP_NAME,            "Trap's name is expected."},
 	{DL_OPT_TRAP_GROUP_NAME,      "Trap group's name is expected."},
 	{DL_OPT_PORT_FUNCTION_HW_ADDR, "Port function's hardware address is expec=
ted."},
+	{DL_OPT_PORT_FLAVOUR,          "Port flavour is expected."},
+	{DL_OPT_PORT_PFNUMBER,         "Port PCI PF number is expected."},
 };
=20
 static int dl_args_finding_required_validate(uint64_t o_required,
@@ -1843,7 +1862,29 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_r=
equired,
 			if (err)
 				return err;
 			o_found |=3D DL_OPT_PORT_FUNCTION_HW_ADDR;
+		} else if (dl_argv_match(dl, "flavour") && (o_all & DL_OPT_PORT_FLAVOUR)=
) {
+			const char *flavourstr;
=20
+			dl_arg_inc(dl);
+			err =3D dl_argv_str(dl, &flavourstr);
+			if (err)
+				return err;
+			err =3D port_flavour_parse(flavourstr, &opts->port_flavour);
+			if (err)
+				return err;
+			o_found |=3D DL_OPT_PORT_FLAVOUR;
+		} else if (dl_argv_match(dl, "pfnum") && (o_all & DL_OPT_PORT_PFNUMBER))=
 {
+			dl_arg_inc(dl);
+			err =3D dl_argv_uint16_t(dl, &opts->port_pfnumber);
+			if (err)
+				return err;
+			o_found |=3D DL_OPT_PORT_PFNUMBER;
+		} else if (dl_argv_match(dl, "sfnum") && (o_all & DL_OPT_PORT_SFNUMBER))=
 {
+			dl_arg_inc(dl);
+			err =3D dl_argv_uint32_t(dl, &opts->port_sfnumber);
+			if (err)
+				return err;
+			o_found |=3D DL_OPT_PORT_SFNUMBER;
 		} else {
 			pr_err("Unknown option \"%s\"\n", dl_argv(dl));
 			return -EINVAL;
@@ -2026,6 +2067,12 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct=
 dl *dl)
 				 opts->trap_policer_burst);
 	if (opts->present & DL_OPT_PORT_FUNCTION_HW_ADDR)
 		dl_function_attr_put(nlh, opts);
+	if (opts->present & DL_OPT_PORT_FLAVOUR)
+		mnl_attr_put_u16(nlh, DEVLINK_ATTR_PORT_FLAVOUR, opts->port_flavour);
+	if (opts->present & DL_OPT_PORT_PFNUMBER)
+		mnl_attr_put_u16(nlh, DEVLINK_ATTR_PORT_PCI_PF_NUMBER, opts->port_pfnumb=
er);
+	if (opts->present & DL_OPT_PORT_SFNUMBER)
+		mnl_attr_put_u32(nlh, DEVLINK_ATTR_PORT_PCI_SF_NUMBER, opts->port_sfnumb=
er);
 }
=20
 static int dl_argv_parse_put(struct nlmsghdr *nlh, struct dl *dl,
@@ -3713,6 +3760,8 @@ static void cmd_port_help(void)
 	pr_err("       devlink port unsplit DEV/PORT_INDEX\n");
 	pr_err("       devlink port function set DEV/PORT_INDEX [ hw_addr ADDR ]\=
n");
 	pr_err("       devlink port health show [ DEV/PORT_INDEX reporter REPORTE=
R_NAME ]\n");
+	pr_err("       devlink port add DEV/PORT_INDEX flavour FLAVOUR pfnum PFNU=
M [ sfnum SFNUM ]\n");
+	pr_err("       devlink port del DEV/PORT_INDEX\n");
 }
=20
 static const char *port_type_name(uint32_t type)
@@ -3974,6 +4023,58 @@ static int cmd_port_function(struct dl *dl)
 static int cmd_health(struct dl *dl);
 static int __cmd_health_show(struct dl *dl, bool show_device, bool show_po=
rt);
=20
+static void cmd_port_add_help(void)
+{
+	pr_err("       devlink port add { DEV | DEV/PORT_INDEX } flavour FLAVOUR =
pfnum PFNUM [ sfnum SFNUM ]\n");
+}
+
+static int cmd_port_add(struct dl *dl)
+{
+	struct nlmsghdr *nlh;
+	int err;
+
+	if (dl_argv_match(dl, "help") || dl_no_arg(dl)) {
+		cmd_port_add_help();
+		return 0;
+	}
+
+	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_PORT_NEW,
+			       NLM_F_REQUEST | NLM_F_ACK);
+
+	err =3D dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE | DL_OPT_HANDLEP |
+				DL_OPT_PORT_FLAVOUR | DL_OPT_PORT_PFNUMBER,
+				DL_OPT_PORT_SFNUMBER);
+	if (err)
+		return err;
+
+	return _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_port_show_cb, dl);
+}
+
+static void cmd_port_del_help(void)
+{
+	pr_err("       devlink port del DEV/PORT_INDEX\n");
+}
+
+static int cmd_port_del(struct dl *dl)
+{
+	struct nlmsghdr *nlh;
+	int err;
+
+	if (dl_argv_match(dl, "help") || dl_no_arg(dl)) {
+		cmd_port_del_help();
+		return 0;
+	}
+
+	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_PORT_DEL,
+			       NLM_F_REQUEST | NLM_F_ACK);
+
+	err =3D dl_argv_parse_put(nlh, dl, DL_OPT_HANDLEP, 0);
+	if (err)
+		return err;
+
+	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
+}
+
 static int cmd_port(struct dl *dl)
 {
 	if (dl_argv_match(dl, "help")) {
@@ -4004,7 +4105,14 @@ static int cmd_port(struct dl *dl)
 		} else {
 			return cmd_health(dl);
 		}
+	} else if (dl_argv_match(dl, "add")) {
+		dl_arg_inc(dl);
+		return cmd_port_add(dl);
+	} else if (dl_argv_match(dl, "del")) {
+		dl_arg_inc(dl);
+		return cmd_port_del(dl);
 	}
+
 	pr_err("Command \"%s\" not found\n", dl_argv(dl));
 	return -ENOENT;
 }
diff --git a/man/man8/devlink-port.8 b/man/man8/devlink-port.8
index 966faae6..4a1d3800 100644
--- a/man/man8/devlink-port.8
+++ b/man/man8/devlink-port.8
@@ -43,6 +43,23 @@ devlink-port \- devlink port configuration
 .B devlink port health
 .RI "{ " show " | " recover " | " diagnose " | " dump " | " set " }"
=20
+.ti -8
+.BI "devlink port add"
+.RB "["
+.IR "DEV | DEV/PORT_INDEX"
+.RB "] "
+.RB "[ " flavour
+.IR FLAVOUR " ]"
+.RB "[ " pcipf
+.IR PFNUMBER " ]"
+.RB "{ " pcisf
+.IR SFNUMBER " }"
+.br
+
+.ti -8
+.B devlink port del
+.IR DEV/PORT_INDEX
+
 .ti -8
 .B devlink port help
=20
@@ -99,6 +116,42 @@ If this argument is omitted all ports are listed.
 Is an alias for
 .BR devlink-health (8).
=20
+.ti -8
+.SS devlink port add - add a devlink port
+.PP
+.B "DEV"
+- specifies the devlink device to operate on. or
+
+.PP
+.B "DEV/PORT_INDEX"
+- specifies the devlink port index to use for the requested new port.
+This is optional. When ommited, driver allocates unique port index.
+
+.TP
+.BR flavour " { " pcipf " | " pcisf " } "
+set port flavour
+
+.I pcipf
+- PCI PF port
+
+.I pcisf
+- PCI SF port
+
+.TP
+.BR pfnum " { " pfnumber " } "
+Specifies PCI pfnumber to use on which a SF device to create
+
+.TP
+.BR sfnum " { " sfnumber " } "
+Specifies sfnumber to assign to the device of the SF.
+This field is optional for those devices which supports auto assignment of=
 the SF number.
+
+.ti -8
+.SS devlink port del - delete a devlink port
+.PP
+.B "DEV/PORT_INDEX"
+- specifies the devlink port to delete.
+
 .SH "EXAMPLES"
 .PP
 devlink port show
@@ -135,6 +188,16 @@ devlink port health show pci/0000:01:00.0/1 reporter t=
x
 .RS 4
 Shows status and configuration of tx reporter registered on pci/0000:01:00=
.0/1 devlink port.
 .RE
+.PP
+devlink port add pci/0000:06:00.0 flavour pcisf pfnum 0 sfnum 88
+.RS 4
+Add a devlink port of flavour PCI SF on PCI PF having number 0 with SF num=
ber 88.
+.RE
+.PP
+devlink port del pci/0000:06:00.0/1
+.RS 4
+Delete previously created devlink port.
+.RE
=20
 .SH SEE ALSO
 .BR devlink (8),
--=20
2.26.2

