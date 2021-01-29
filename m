Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 228A1308ABE
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 17:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbhA2Q6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 11:58:09 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:7925 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbhA2Q5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 11:57:32 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60143e530001>; Fri, 29 Jan 2021 08:56:51 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 29 Jan
 2021 16:56:51 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <dsahern@gmail.com>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH iproute2-next 5/5] devlink: Support set of port function state
Date:   Fri, 29 Jan 2021 18:56:08 +0200
Message-ID: <20210129165608.134965-6-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210129165608.134965-1-parav@nvidia.com>
References: <20210129165608.134965-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611939411; bh=vdRxMoWfot/LGe8p7aAL1Z+UaGnNZRBUh1OqdO7Aogw=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=QxgSFVm9tW5iWtVn/5ha//07VKvV1HACgEMwfk2UW6oR+emqroWl2qQcFx4CNUfo9
         SDnnyqlgXxApkVpQANx0L1Ss99sAAOc3ocoD486jHU9+UIsRgDJwYqPvQMA12VbeHO
         cMNx7ZQhU0elUWqxmZEG66hr6HLPXT+n+wqgwPuhxXXeKvhtS5Z3W7ookQwNDBRiEe
         sKRVg+TYMz+N2AuR9zwN3Ne5f2+ity5SSGpOYCTVe0mkZzETkoeNf6P4apaNDw85vv
         +rEAkH/9gqBALFP/5Ql2tXfva6NxxKIo86n9ta4j5PnaB/9BZ4Am3QXJiK4DWRyluE
         QDkrXL2joE0nw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support set operation of the devlink port function state.

Example of a PCI SF port function which supports the state:

$ devlink dev eswitch set pci/0000:06:00.0 mode switchdev

$ devlink port show
pci/0000:06:00.0/65535: type eth netdev ens2f0np0 flavour physical port 0 s=
plittable false

$ devlink port add pci/0000:06:00.0 flavour pcisf pfnum 0 sfnum 88
pci/0000:08:00.0/32768: type eth netdev eth6 flavour pcisf controller 0 pfn=
um 0 sfnum 88 splittable false
  function:
    hw_addr 00:00:00:00:00:00 state inactive opstate detached

$ devlink port show pci/0000:06:00.0/32768
pci/0000:06:00.0/32768: type eth netdev ens2f0npf0sf88 flavour pcisf contro=
ller 0 pfnum 0 sfnum 88 splittable false
  function:
    hw_addr 00:00:00:00:00:00 state inactive opstate detached

$ devlink port function set pci/0000:06:00.0/32768 hw_addr 00:00:00:00:88:8=
8 state active

$ devlink port show pci/0000:06:00.0/32768 -jp
{
    "port": {
        "pci/0000:06:00.0/32768": {
            "type": "eth",
            "netdev": "ens2f0npf0sf88",
            "flavour": "pcisf",
            "controller": 0,
            "pfnum": 0,
            "sfnum": 88,
            "splittable": false,
            "function": {
                "hw_addr": "00:00:00:00:88:88",
                "state": "active",
                "opstate": "attached"
            }
        }
    }
}

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 devlink/devlink.c       | 57 +++++++++++++++++++++++++++++-----
 man/man8/devlink-port.8 | 68 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 115 insertions(+), 10 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 85b9bce9..d233dcdd 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -309,6 +309,7 @@ static void ifname_map_free(struct ifname_map *ifname_m=
ap)
 #define DL_OPT_PORT_FLAVOUR BIT(42)
 #define DL_OPT_PORT_PFNUMBER BIT(43)
 #define DL_OPT_PORT_SFNUMBER BIT(44)
+#define DL_OPT_PORT_FUNCTION_STATE BIT(45)
=20
 struct dl_opts {
 	uint64_t present; /* flags of present items */
@@ -362,6 +363,7 @@ struct dl_opts {
 	uint32_t port_sfnumber;
 	uint16_t port_flavour;
 	uint16_t port_pfnumber;
+	uint8_t port_function_state;
 };
=20
 struct dl {
@@ -747,6 +749,7 @@ static int attr_stats_cb(const struct nlattr *attr, voi=
d *data)
 static const enum mnl_attr_data_type
 devlink_function_policy[DEVLINK_PORT_FUNCTION_ATTR_MAX + 1] =3D {
 	[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR ] =3D MNL_TYPE_BINARY,
+	[DEVLINK_PORT_FN_ATTR_STATE] =3D MNL_TYPE_U8,
 };
=20
 static int function_attr_cb(const struct nlattr *attr, void *data)
@@ -1420,6 +1423,22 @@ static int port_flavour_parse(const char *flavour, u=
int16_t *value)
 	}
 }
=20
+static int port_function_state_parse(const char *statestr, uint8_t *state)
+{
+	if (!statestr)
+		return -EINVAL;
+
+	if (strcmp(statestr, "inactive") =3D=3D 0) {
+		*state =3D DEVLINK_PORT_FN_STATE_INACTIVE;
+		return 0;
+	} else if (strcmp(statestr, "active") =3D=3D 0) {
+		*state =3D DEVLINK_PORT_FN_STATE_ACTIVE;
+		return 0;
+	} else {
+		return -EINVAL;
+	}
+}
+
 struct dl_args_metadata {
 	uint64_t o_flag;
 	char err_msg[DL_ARGS_REQUIRED_MAX_ERR_LEN];
@@ -1871,6 +1890,19 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_r=
equired,
 			if (err)
 				return err;
 			o_found |=3D DL_OPT_PORT_FUNCTION_HW_ADDR;
+		} else if (dl_argv_match(dl, "state") &&
+			   (o_all & DL_OPT_PORT_FUNCTION_STATE)) {
+			const char *statestr;
+
+			dl_arg_inc(dl);
+			err =3D dl_argv_str(dl, &statestr);
+			if (err)
+				return err;
+			err =3D port_function_state_parse(statestr, &opts->port_function_state)=
;
+			if (err)
+				return err;
+
+			o_found |=3D DL_OPT_PORT_FUNCTION_STATE;
 		} else if (dl_argv_match(dl, "flavour") && (o_all & DL_OPT_PORT_FLAVOUR)=
) {
 			const char *flavourstr;
=20
@@ -1916,9 +1948,14 @@ dl_function_attr_put(struct nlmsghdr *nlh, const str=
uct dl_opts *opts)
 	struct nlattr *nest;
=20
 	nest =3D mnl_attr_nest_start(nlh, DEVLINK_ATTR_PORT_FUNCTION);
-	mnl_attr_put(nlh, DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR,
-		     opts->port_function_hw_addr_len,
-		     opts->port_function_hw_addr);
+
+	if (opts->present & DL_OPT_PORT_FUNCTION_HW_ADDR)
+		mnl_attr_put(nlh, DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR,
+			     opts->port_function_hw_addr_len,
+			     opts->port_function_hw_addr);
+	if (opts->present & DL_OPT_PORT_FUNCTION_STATE)
+		mnl_attr_put_u8(nlh, DEVLINK_PORT_FN_ATTR_STATE,
+				opts->port_function_state);
 	mnl_attr_nest_end(nlh, nest);
 }
=20
@@ -2074,7 +2111,7 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct =
dl *dl)
 	if (opts->present & DL_OPT_TRAP_POLICER_BURST)
 		mnl_attr_put_u64(nlh, DEVLINK_ATTR_TRAP_POLICER_BURST,
 				 opts->trap_policer_burst);
-	if (opts->present & DL_OPT_PORT_FUNCTION_HW_ADDR)
+	if (opts->present & (DL_OPT_PORT_FUNCTION_HW_ADDR | DL_OPT_PORT_FUNCTION_=
STATE))
 		dl_function_attr_put(nlh, opts);
 	if (opts->present & DL_OPT_PORT_FLAVOUR)
 		mnl_attr_put_u16(nlh, DEVLINK_ATTR_PORT_FLAVOUR, opts->port_flavour);
@@ -3767,7 +3804,7 @@ static void cmd_port_help(void)
 	pr_err("       devlink port set DEV/PORT_INDEX [ type { eth | ib | auto} =
]\n");
 	pr_err("       devlink port split DEV/PORT_INDEX count COUNT\n");
 	pr_err("       devlink port unsplit DEV/PORT_INDEX\n");
-	pr_err("       devlink port function set DEV/PORT_INDEX [ hw_addr ADDR ]\=
n");
+	pr_err("       devlink port function set DEV/PORT_INDEX [ hw_addr ADDR ] =
[ state STATE ]\n");
 	pr_err("       devlink port health show [ DEV/PORT_INDEX reporter REPORTE=
R_NAME ]\n");
 	pr_err("       devlink port add DEV/PORT_INDEX flavour FLAVOUR [ controll=
er CNUM ] pfnum PFNUM [ sfnum SFNUM ]\n");
 	pr_err("       devlink port del DEV/PORT_INDEX\n");
@@ -3897,7 +3934,6 @@ static void pr_out_port_function(struct dl *dl, struc=
t nlattr **tb_port)
=20
 		print_string(PRINT_ANY, "opstate", " opstate %s", port_function_opstate(=
state));
 	}
-
 	if (!dl->json_output)
 		__pr_out_indent_dec();
 	pr_out_object_end(dl);
@@ -4052,7 +4088,7 @@ static int cmd_port_unsplit(struct dl *dl)
=20
 static void cmd_port_function_help(void)
 {
-	pr_err("Usage: devlink port function set DEV/PORT_INDEX [ hw_addr ADDR ]\=
n");
+	pr_err("Usage: devlink port function set DEV/PORT_INDEX [ hw_addr ADDR ] =
[ state STATE ]\n");
 }
=20
 static int cmd_port_function_set(struct dl *dl)
@@ -4060,9 +4096,14 @@ static int cmd_port_function_set(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
=20
+	if (dl_no_arg(dl)) {
+		cmd_port_function_help();
+		return 0;
+	}
 	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_PORT_SET, NLM_F_REQUEST | N=
LM_F_ACK);
=20
-	err =3D dl_argv_parse_put(nlh, dl, DL_OPT_HANDLEP | DL_OPT_PORT_FUNCTION_=
HW_ADDR, 0);
+	err =3D dl_argv_parse_put(nlh, dl, DL_OPT_HANDLEP,
+				DL_OPT_PORT_FUNCTION_HW_ADDR | DL_OPT_PORT_FUNCTION_STATE);
 	if (err)
 		return err;
=20
diff --git a/man/man8/devlink-port.8 b/man/man8/devlink-port.8
index 4a1d3800..55f1cce6 100644
--- a/man/man8/devlink-port.8
+++ b/man/man8/devlink-port.8
@@ -60,6 +60,16 @@ devlink-port \- devlink port configuration
 .B devlink port del
 .IR DEV/PORT_INDEX
=20
+.ti -8
+.BR "devlink port function set "
+.IR DEV/PORT_INDEX
+.RI "{ "
+.BR "hw_addr "
+.RI "ADDR }"
+.RI "{ "
+.BR "state"
+.RI "STATE }"
+
 .ti -8
 .B devlink port help
=20
@@ -144,7 +154,30 @@ Specifies PCI pfnumber to use on which a SF device to =
create
 .TP
 .BR sfnum " { " sfnumber " } "
 Specifies sfnumber to assign to the device of the SF.
-This field is optional for those devices which supports auto assignment of=
 the SF number.
+This field is optional for those devices which supports auto assignment of=
 the
+SF number.
+
+.ti -8
+.SS devlink port function set - Set the port function attribute(s).
+
+.PP
+.B "DEV/PORT_INDEX"
+- specifies the devlink port to operate on.
+
+.TP
+.BR hw_addr " ADDR"
+- hardware address of the function to set. This is a Ethernet MAC address =
when
+port type is Ethernet.
+
+.TP
+.BR state " { " active " | " inactive " } "
+- new state of the function to change to.
+
+.I active
+- Once configuration of the function is done, activate the function.
+
+.I inactive
+- To inactivate the function and its device(s), set to inactive.
=20
 .ti -8
 .SS devlink port del - delete a devlink port
@@ -192,11 +225,42 @@ Shows status and configuration of tx reporter registe=
red on pci/0000:01:00.0/1 d
 devlink port add pci/0000:06:00.0 flavour pcisf pfnum 0 sfnum 88
 .RS 4
 Add a devlink port of flavour PCI SF on PCI PF having number 0 with SF num=
ber 88.
+To make use of the function an example sequence is to add a port, configur=
e the
+function attribute and activate the function. Once function usage is compl=
eted,
+inactivate the function and finally delete the port. When there is desire =
to
+reuse the port without deletion, it can be reconfigured and activated agai=
n when
+function is in inactive state and function's operational state is detached=
.
 .RE
 .PP
 devlink port del pci/0000:06:00.0/1
 .RS 4
-Delete previously created devlink port.
+Delete previously created devlink port. It is recommended to first deactiv=
ate
+the function if the function supports state management.
+.RE
+.PP
+devlink port function set pci/0000:01:00.0/1 hw_addr 00:00:00:11:22:33
+.RS 4
+Configure hardware address of the PCI function represented by devlink port=
.
+If the port supports change in function state, hardware address must be co=
nfigured
+before activating the function.
+.RE
+.PP
+devlink port function set pci/0000:01:00.0/1 state active
+.RS 4
+Activate the function. This will initiate the function enumeration and dri=
ver loading.
+.RE
+.PP
+devlink port function set pci/0000:01:00.0/1 state inactive
+.RS 4
+Deactivate the function. This will initiate the function teardown which re=
sults
+in driver unload and device removal.
+.RE
+.PP
+devlink port function set pci/0000:01:00.0/1 hw_addr 00:00:00:11:22:33 sta=
te active
+.RS 4
+Configure hardware address and also active the function. When a function i=
s
+activated together with other configuration in a single command, all the
+configuration is applied first before changing the state to active.
 .RE
=20
 .SH SEE ALSO
--=20
2.26.2

