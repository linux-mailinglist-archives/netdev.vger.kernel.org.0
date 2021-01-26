Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD0353050BE
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:25:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234376AbhA0EYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:24:48 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:5000 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388669AbhAZXZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 18:25:22 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6010a4b80002>; Tue, 26 Jan 2021 15:24:40 -0800
Received: from sx1.mtl.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 23:24:39 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Aya Levin <ayal@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/14] devlink: Add DMAC filter generic packet trap
Date:   Tue, 26 Jan 2021 15:24:06 -0800
Message-ID: <20210126232419.175836-2-saeedm@nvidia.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210126232419.175836-1-saeedm@nvidia.com>
References: <20210126232419.175836-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611703480; bh=uQEwLeCHLX9XsTcnWMTK0PGYsZs63XegrXUVageMV18=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=R8dvpdBKGbyJCONxobrZipiuqFchtvZ/l/r6RTjclVZ4zLaAFLnbsofS2UaznKjPc
         88MGFWSQ8AwfTQMbtZJmj7CsHwUway4qeIwUpRZNRIq/kLTK/tO6QczwfG7ssxOI1t
         9am77mEpUeDY4IZ2xGo+32/ZZp4JUaXCxWCFHsULmUDNSaxg2bOyfyszFlbR/5OUgi
         KyCmasszSo3hU/wHxRvriTMyELL++90gqZql1YYDhLfEWrYUe41wQh1eTfH0boZ8Du
         K/x9ZB8XdUwE50GCOsqiCj29sDwjzy+H2WefsVZ95xDp7Kv9EExM6DI+dBrmZCUizE
         7zy6JQJLULk4Q==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Add packet trap that can report packets that were dropped due to
destination MAC filtering.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 Documentation/networking/devlink/devlink-trap.rst | 5 +++++
 include/net/devlink.h                             | 3 +++
 net/core/devlink.c                                | 1 +
 3 files changed, 9 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-trap.rst b/Documentat=
ion/networking/devlink/devlink-trap.rst
index d875f3e1e9cf..1dd86976ecf8 100644
--- a/Documentation/networking/devlink/devlink-trap.rst
+++ b/Documentation/networking/devlink/devlink-trap.rst
@@ -480,6 +480,11 @@ be added to the following table:
      - ``drop``
      - Traps packets that the device decided to drop in case they hit a
        blackhole nexthop
+   * - ``dmac_filter``
+     - ``drop``
+     - Traps incoming packets that the device decided to drop in case
+       the destination MAC is not configured in the MAC table
+
=20
 Driver-specific Packet Traps
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
diff --git a/include/net/devlink.h b/include/net/devlink.h
index d12ed2854c34..426b98e74b6e 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -838,6 +838,7 @@ enum devlink_trap_generic_id {
 	DEVLINK_TRAP_GENERIC_ID_GTP_PARSING,
 	DEVLINK_TRAP_GENERIC_ID_ESP_PARSING,
 	DEVLINK_TRAP_GENERIC_ID_BLACKHOLE_NEXTHOP,
+	DEVLINK_TRAP_GENERIC_ID_DMAC_FILTER,
=20
 	/* Add new generic trap IDs above */
 	__DEVLINK_TRAP_GENERIC_ID_MAX,
@@ -1063,6 +1064,8 @@ enum devlink_trap_group_generic_id {
 	"esp_parsing"
 #define DEVLINK_TRAP_GENERIC_NAME_BLACKHOLE_NEXTHOP \
 	"blackhole_nexthop"
+#define DEVLINK_TRAP_GENERIC_NAME_DMAC_FILTER \
+	"dest_mac_filter"
=20
 #define DEVLINK_TRAP_GROUP_GENERIC_NAME_L2_DROPS \
 	"l2_drops"
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 72ea79879762..f6e6445b9801 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -9512,6 +9512,7 @@ static const struct devlink_trap devlink_trap_generic=
[] =3D {
 	DEVLINK_TRAP(GTP_PARSING, DROP),
 	DEVLINK_TRAP(ESP_PARSING, DROP),
 	DEVLINK_TRAP(BLACKHOLE_NEXTHOP, DROP),
+	DEVLINK_TRAP(DMAC_FILTER, DROP),
 };
=20
 #define DEVLINK_TRAP_GROUP(_id)						      \
--=20
2.29.2

