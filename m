Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 661912B0DDC
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgKLTYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:24:51 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:11325 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726807AbgKLTYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 14:24:49 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fad8c080001>; Thu, 12 Nov 2020 11:24:56 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 12 Nov
 2020 19:24:47 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
CC:     <jiri@nvidia.com>, <jgg@nvidia.com>, <dledford@redhat.com>,
        <leonro@nvidia.com>, <saeedm@nvidia.com>, <kuba@kernel.org>,
        <davem@davemloft.net>, Parav Pandit <parav@nvidia.com>,
        Vu Pham <vuhuong@nvidia.com>
Subject: [PATCH net-next 01/13] devlink: Prepare code to fill multiple port function attributes
Date:   Thu, 12 Nov 2020 21:24:11 +0200
Message-ID: <20201112192424.2742-2-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201112192424.2742-1-parav@nvidia.com>
References: <20201112192424.2742-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605209096; bh=CGowwf6WxKONC1zCiFLEXwuhX6atWac00OfQ2pv/YUQ=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=XnnnZp1Z+U/N8UBbjLSsWikJ4a+Lg+Q5RvOQOGEIUC+b9hDqOmFNubeyF+cVI2358
         C21rmiCEMrAiK8mh0nvSfauII/ZRxbKoGfbivqPuatOiUR3mJEILPjHTkaUrxkPEa7
         7f5Kx7xYdz9jkiCKKkmh8YSUep0VK7Z/Tcv7DLeKLtYoRlsYtBe3eYC3NivAdCpQ/s
         hZG1XfGpu6BG6QRq+Z1pdt7zQnYwHpazAunZC+55CtCTFSIP8QGS7aRFF3uQWyk5zC
         e0TX84/Royas0a00VTeebaPihLXneGknYm23FLLdhciEyNxa/dnmN4GmCX4llxq7zm
         g74rVFPzXXVrQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prepare code to fill zero or more port function optional attributes.
Subsequent patch makes use of this to fill more port function
attributes.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Vu Pham <vuhuong@nvidia.com>
---
 net/core/devlink.c | 63 +++++++++++++++++++++++-----------------------
 1 file changed, 32 insertions(+), 31 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index a578634052a3..75cca9cbb9d9 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -695,6 +695,31 @@ static int devlink_nl_port_attrs_put(struct sk_buff *m=
sg,
 	return 0;
 }
=20
+static int
+devlink_port_function_hw_addr_fill(struct devlink *devlink, const struct d=
evlink_ops *ops,
+				   struct devlink_port *port, struct sk_buff *msg,
+				   struct netlink_ext_ack *extack, bool *msg_updated)
+{
+	u8 hw_addr[MAX_ADDR_LEN];
+	int hw_addr_len;
+	int err;
+
+	if (!ops->port_function_hw_addr_get)
+		return 0;
+
+	err =3D ops->port_function_hw_addr_get(devlink, port, hw_addr, &hw_addr_l=
en, extack);
+	if (err) {
+		if (err =3D=3D -EOPNOTSUPP)
+			return 0;
+		return err;
+	}
+	err =3D nla_put(msg, DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR, hw_addr_len, hw_=
addr);
+	if (err)
+		return err;
+	*msg_updated =3D true;
+	return 0;
+}
+
 static int
 devlink_nl_port_function_attrs_put(struct sk_buff *msg, struct devlink_por=
t *port,
 				   struct netlink_ext_ack *extack)
@@ -702,36 +727,16 @@ devlink_nl_port_function_attrs_put(struct sk_buff *ms=
g, struct devlink_port *por
 	struct devlink *devlink =3D port->devlink;
 	const struct devlink_ops *ops;
 	struct nlattr *function_attr;
-	bool empty_nest =3D true;
-	int err =3D 0;
+	bool msg_updated =3D false;
+	int err;
=20
 	function_attr =3D nla_nest_start_noflag(msg, DEVLINK_ATTR_PORT_FUNCTION);
 	if (!function_attr)
 		return -EMSGSIZE;
=20
 	ops =3D devlink->ops;
-	if (ops->port_function_hw_addr_get) {
-		int hw_addr_len;
-		u8 hw_addr[MAX_ADDR_LEN];
-
-		err =3D ops->port_function_hw_addr_get(devlink, port, hw_addr, &hw_addr_=
len, extack);
-		if (err =3D=3D -EOPNOTSUPP) {
-			/* Port function attributes are optional for a port. If port doesn't
-			 * support function attribute, returning -EOPNOTSUPP is not an error.
-			 */
-			err =3D 0;
-			goto out;
-		} else if (err) {
-			goto out;
-		}
-		err =3D nla_put(msg, DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR, hw_addr_len, hw=
_addr);
-		if (err)
-			goto out;
-		empty_nest =3D false;
-	}
-
-out:
-	if (err || empty_nest)
+	err =3D devlink_port_function_hw_addr_fill(devlink, ops, port, msg, extac=
k, &msg_updated);
+	if (err || !msg_updated)
 		nla_nest_cancel(msg, function_attr);
 	else
 		nla_nest_end(msg, function_attr);
@@ -964,7 +969,6 @@ devlink_port_function_hw_addr_set(struct devlink *devli=
nk, struct devlink_port *
 	const struct devlink_ops *ops;
 	const u8 *hw_addr;
 	int hw_addr_len;
-	int err;
=20
 	hw_addr =3D nla_data(attr);
 	hw_addr_len =3D nla_len(attr);
@@ -989,12 +993,7 @@ devlink_port_function_hw_addr_set(struct devlink *devl=
ink, struct devlink_port *
 		return -EOPNOTSUPP;
 	}
=20
-	err =3D ops->port_function_hw_addr_set(devlink, port, hw_addr, hw_addr_le=
n, extack);
-	if (err)
-		return err;
-
-	devlink_port_notify(port, DEVLINK_CMD_PORT_NEW);
-	return 0;
+	return ops->port_function_hw_addr_set(devlink, port, hw_addr, hw_addr_len=
, extack);
 }
=20
 static int
@@ -1015,6 +1014,8 @@ devlink_port_function_set(struct devlink *devlink, st=
ruct devlink_port *port,
 	if (attr)
 		err =3D devlink_port_function_hw_addr_set(devlink, port, attr, extack);
=20
+	if (!err)
+		devlink_port_notify(port, DEVLINK_CMD_PORT_NEW);
 	return err;
 }
=20
--=20
2.26.2

