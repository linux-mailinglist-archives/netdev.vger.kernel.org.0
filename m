Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7640B272DA5
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 18:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729476AbgIUQmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 12:42:02 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:15086 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729462AbgIUQlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 12:41:45 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f68d7bc0002>; Mon, 21 Sep 2020 09:41:32 -0700
Received: from sw-mtx-036.mtx.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 21 Sep
 2020 16:41:44 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next 2/2] devlink: Enhance policy to validate port type input value
Date:   Mon, 21 Sep 2020 19:41:30 +0300
Message-ID: <20200921164130.83720-3-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200921164130.83720-1-parav@nvidia.com>
References: <20200921164130.83720-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600706492; bh=cUlrYjAnKT7H82kOLwHGK8j1rSD5DHVrv8T0r9D1Y1s=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=Bwix/f3wM8WjUmxT+QzS1zUFD8zk7TdZGJVpfczAOs/JO8w/ypvGJCgAE6vTeh6GV
         nPDbUR6jU6KYXx9iTboyVzAIuHWYDOEzaYnOx4q2bTdf/umIsp86hXQ+4c57T0GHu+
         zFRKwM4CPElEWuVoGWeQ1fHp4/HxCNqpbTRicQ8XEkpF6BJbvQPGs3H4NF1xOpTV3l
         sHIfpkbSVtoHaeamLWzWVEeg1CHhGMsBt/Qv5W+tGHuAioqhczB1O4yfNs9sHNeBl2
         KeL9W3oboMMNRFhwUboYlQGVJb3neVDKh+cvVu5gAjThJ7zX78y05G2AGMB/a/WC4H
         c5mGil4c4p4Rw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use range checking facility of nla_policy to validate port type
attribute input value is valid or not.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 4ecc68a9c7df..4494937df7eb 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -867,8 +867,6 @@ static int devlink_port_type_set(struct devlink *devlin=
k,
 	int err;
=20
 	if (devlink->ops->port_type_set) {
-		if (port_type =3D=3D DEVLINK_PORT_TYPE_NOTSET)
-			return -EINVAL;
 		if (port_type =3D=3D devlink_port->type)
 			return 0;
 		err =3D devlink->ops->port_type_set(devlink_port, port_type);
@@ -7193,7 +7191,8 @@ static const struct nla_policy devlink_nl_policy[DEVL=
INK_ATTR_MAX + 1] =3D {
 	[DEVLINK_ATTR_BUS_NAME] =3D { .type =3D NLA_NUL_STRING },
 	[DEVLINK_ATTR_DEV_NAME] =3D { .type =3D NLA_NUL_STRING },
 	[DEVLINK_ATTR_PORT_INDEX] =3D { .type =3D NLA_U32 },
-	[DEVLINK_ATTR_PORT_TYPE] =3D { .type =3D NLA_U16 },
+	[DEVLINK_ATTR_PORT_TYPE] =3D NLA_POLICY_RANGE(NLA_U16, DEVLINK_PORT_TYPE_=
AUTO,
+						    DEVLINK_PORT_TYPE_IB),
 	[DEVLINK_ATTR_PORT_SPLIT_COUNT] =3D { .type =3D NLA_U32 },
 	[DEVLINK_ATTR_SB_INDEX] =3D { .type =3D NLA_U32 },
 	[DEVLINK_ATTR_SB_POOL_INDEX] =3D { .type =3D NLA_U16 },
--=20
2.26.2

