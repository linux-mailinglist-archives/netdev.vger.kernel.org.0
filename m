Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BAB92AE735
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 04:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725884AbgKKDsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 22:48:15 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:1464 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgKKDsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 22:48:14 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fab5ef90000>; Tue, 10 Nov 2020 19:48:09 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 11 Nov
 2020 03:48:13 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net RESEND] devlink: Avoid overwriting port attributes of registered port
Date:   Wed, 11 Nov 2020 05:47:44 +0200
Message-ID: <20201111034744.35554-1-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201110185258.30576-1-parav@nvidia.com>
References: <20201110185258.30576-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605066489; bh=QNddpX4MZtczOoPX3ILe/h42UIgao/9pGSjX9V+gL8w=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=qcASHtf0K3LctTSPORkMUmwAJgkHbH6zGZzNhRKbzEDTA8fW9cjACmX22iu7dKzv/
         6MQXXDPu3khLKWsX6iyl3y42MqyXf28ZZ0kioo4SGzFgumeAYxvuprnJAqTJUKxQQR
         QTEqlFaAq+7jjPSSW23ELz74FpVsYm7nXWCUVXnFcLq1MmqyG5St36OxX8Unz5/Hsj
         t4cvKJtgbb70jHEIGD5HU5HIIDw+XJC/bc5DWZ4F1jMaLLDZFoM2naLKdkHm/1u1qx
         5oAr5K6rNLkR4wCBQv751WMnuItq51EEQ5ZO1EOqfYX+iWkpXHcQS1Kb6z4yJQ6M+F
         MU+oGnoODqJHQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cited commit in fixes tag overwrites the port attributes for the
registered port.

Avoid such error by checking registered flag before setting attributes.

Fixes: 71ad8d55f8e5 ("devlink: Replace devlink_port_attrs_set parameters wi=
th a struct")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index a932d95be798..ab4b1368904f 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -8254,8 +8254,6 @@ static int __devlink_port_attrs_set(struct devlink_po=
rt *devlink_port,
 {
 	struct devlink_port_attrs *attrs =3D &devlink_port->attrs;
=20
-	if (WARN_ON(devlink_port->registered))
-		return -EEXIST;
 	devlink_port->attrs_set =3D true;
 	attrs->flavour =3D flavour;
 	if (attrs->switch_id.id_len) {
@@ -8279,6 +8277,8 @@ void devlink_port_attrs_set(struct devlink_port *devl=
ink_port,
 {
 	int ret;
=20
+	if (WARN_ON(devlink_port->registered))
+		return;
 	devlink_port->attrs =3D *attrs;
 	ret =3D __devlink_port_attrs_set(devlink_port, attrs->flavour);
 	if (ret)
@@ -8301,6 +8301,8 @@ void devlink_port_attrs_pci_pf_set(struct devlink_por=
t *devlink_port, u32 contro
 	struct devlink_port_attrs *attrs =3D &devlink_port->attrs;
 	int ret;
=20
+	if (WARN_ON(devlink_port->registered))
+		return;
 	ret =3D __devlink_port_attrs_set(devlink_port,
 				       DEVLINK_PORT_FLAVOUR_PCI_PF);
 	if (ret)
@@ -8326,6 +8328,8 @@ void devlink_port_attrs_pci_vf_set(struct devlink_por=
t *devlink_port, u32 contro
 	struct devlink_port_attrs *attrs =3D &devlink_port->attrs;
 	int ret;
=20
+	if (WARN_ON(devlink_port->registered))
+		return;
 	ret =3D __devlink_port_attrs_set(devlink_port,
 				       DEVLINK_PORT_FLAVOUR_PCI_VF);
 	if (ret)
--=20
2.26.2

