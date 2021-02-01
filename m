Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4966030B22A
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 22:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232411AbhBAVhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 16:37:05 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:2065 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbhBAVgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 16:36:54 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6018744e0000>; Mon, 01 Feb 2021 13:36:14 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 1 Feb
 2021 21:36:13 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <dsahern@gmail.com>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH iproute2-next v2 6/6] devlink: Support set of port function state
Date:   Mon, 1 Feb 2021 23:35:51 +0200
Message-ID: <20210201213551.8503-7-parav@nvidia.com>
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
        t=1612215374; bh=aYy0C4euUzwMXPH1AO6VdvD+yFt7JCk+F9kQ3A7Vd6M=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=d4OGAJDHUV8dUHXItKB1ydCWdB7N5Wq0jE5HWCUuPKfUUqmnD1XVp6yPRWEQfh54M
         jxzA5rILEMGsEhxBB7m+UVn6mvoYh2JkmqwSwrXOQHvxrSW+HMj/SXLxcEBSnFJwbj
         s/ZBlCWPP8unuy4NZAcKySBN6isU5CIv/iQ+nGLXjtgvmB/rnfvvp2bQITakJkszXw
         0OBO5bhyWZWHzTUPJWvqrs1FpjgyLU+p3aHnWo5n1Sr55Ntg4oa6yMMpbNMOuFgRXR
         HvM9YwpamjIFpuejRjiPRRciVUf4XeSPAbaFTSUwnUUlsgMFSgcdBVmRNC9HONjsRv
         9l0Vhf/1N1n0w==
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
changelog:
v1->v2:
 - using sting<->num mapping helper routine for state and operational
   state
 - change port_function_state to shoter name port_fn_state
---
 devlink/devlink.c       | 51 ++++++++++++++++++++++++++-----
 man/man8/devlink-port.8 | 68 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 110 insertions(+), 9 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 17db8623..10398f77 100644
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
+	uint8_t port_fn_state;
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
@@ -1423,6 +1426,17 @@ static int port_flavour_parse(const char *flavour, u=
int16_t *value)
 	return 0;
 }
=20
+static int port_fn_state_parse(const char *statestr, uint8_t *state)
+{
+	int num;
+
+	num =3D str_map_lookup_str(port_fn_state_map, statestr);
+	if (num < 0)
+		return num;
+	*state =3D num;
+	return 0;
+}
+
 struct dl_args_metadata {
 	uint64_t o_flag;
 	char err_msg[DL_ARGS_REQUIRED_MAX_ERR_LEN];
@@ -1874,6 +1888,19 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_r=
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
+			err =3D port_fn_state_parse(statestr, &opts->port_fn_state);
+			if (err)
+				return err;
+
+			o_found |=3D DL_OPT_PORT_FUNCTION_STATE;
 		} else if (dl_argv_match(dl, "flavour") && (o_all & DL_OPT_PORT_FLAVOUR)=
) {
 			const char *flavourstr;
=20
@@ -1919,9 +1946,14 @@ dl_function_attr_put(struct nlmsghdr *nlh, const str=
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
+				opts->port_fn_state);
 	mnl_attr_nest_end(nlh, nest);
 }
=20
@@ -2077,7 +2109,7 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct =
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
@@ -3770,7 +3802,7 @@ static void cmd_port_help(void)
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
 	pr_err("       devlink port add DEV/PORT_INDEX flavour FLAVOUR pfnum PFNU=
M [ sfnum SFNUM ]\n");
 	pr_err("       devlink port del DEV/PORT_INDEX\n");
@@ -4035,7 +4067,7 @@ static int cmd_port_unsplit(struct dl *dl)
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
@@ -4043,9 +4075,14 @@ static int cmd_port_function_set(struct dl *dl)
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

