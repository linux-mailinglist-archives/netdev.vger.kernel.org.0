Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42EA82ADED3
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 19:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731142AbgKJSxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 13:53:16 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:10886 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbgKJSxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 13:53:16 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5faae1a20000>; Tue, 10 Nov 2020 10:53:22 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 10 Nov
 2020 18:53:15 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net] devlink: Avoid overwriting port attributes of registered port
Date:   Tue, 10 Nov 2020 20:52:58 +0200
Message-ID: <20201110185258.30576-1-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605034402; bh=GjQJGd9e1sDvsnE2pN0SD7K/8l7LP8R7rqGQ5ZExBuU=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=XsI0X2M5TeMANdG9LD+JuCnig7kRsn6i0T5x0QX7pkvLMNWk+wLQCUe/40nrRQ+Ap
         4E0BqqqW2SCZk9jS9tyRT6OxHtDU0webOxODBTUMC2rNONj0kcOHHLonC1S06VP5ex
         UamXzQ4rX9Qdw0+JjnKyuNRf8bJCxM70CO641jn5dKxA7TOQSmllOfxxKR69qWqaR/
         ANYrQ434vPVACLdTAoFGcVNyvn9fu770MYXn9x6m6N4sEAlFt/2ZfyG29BCTBTcupZ
         t9AQqdfhCkkRy//i226Y+/Wu/N2iHVNpobaQ5wknOmKAcl9vN5zTDOUNToiA5PQLm3
         a4Y/tKi3vU9Xg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cited commit in fixes tag overwrites the port attributes for the
registered port.

Avoid such error by checking registered flag before setting attributes.

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

