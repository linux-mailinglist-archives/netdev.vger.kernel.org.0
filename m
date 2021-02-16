Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B487131C66F
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 06:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbhBPFvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 00:51:49 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:5226 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbhBPFvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 00:51:47 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602b5d4a0000>; Mon, 15 Feb 2021 21:51:06 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 16 Feb
 2021 05:51:06 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 16 Feb 2021 05:51:04 +0000
From:   Eli Cohen <elic@nvidia.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>,
        <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
CC:     <si-wei.liu@oracle.com>, <elic@nvidia.com>
Subject: [PATCH] vdpa/mlx5: Extract correct pointer from driver data
Date:   Tue, 16 Feb 2021 07:50:22 +0200
Message-ID: <20210216055022.25248-2-elic@nvidia.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210216055022.25248-1-elic@nvidia.com>
References: <20210216055022.25248-1-elic@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613454666; bh=Emqf4hRPWOz3zcBqDWDIklUs7r/QR5F0BAA/Zmha8aY=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        b=g04IISlDRh+s9XUrmUzy2fnhKBGdTvzfFC7tJvdB3MoBd/bVuTY0TtSK2s0jyYEnj
         qV2j23sXeWGYEcO6st/ZlDRrhuxUrOyk9SlZ+1i1ouPZq/XeZWXLjJdED9oAFgWBif
         LoxuCCnt3afF2X3vHiqtGmlgXGIFgntOMamoMMEqOacnqYyCMnuMfKUWb9Bl1Ifkm5
         NBKgrz3sgOVTKiKn6/tew8iF4bzXhdPlmQ9s78oKzyrgv+BFHlrhRO8xiUEMZ9v5+z
         QkAd6CiVc/JDktCTyaxgu7SlA1a4BVEqBodozN4HgevK+UFM7I0k2tpeC4tNgAvpeg
         Mjw2Mqm0cMk8A==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct mlx5_vdpa_net pointer was stored in drvdata. Extract it as well
in mlx5v_remove().

Fixes: 74c9729dd892 ("vdpa/mlx5: Connect mlx5_vdpa to auxiliary bus")
Signed-off-by: Eli Cohen <elic@nvidia.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5=
_vnet.c
index 6b0a42183622..4103d3b64a2a 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -2036,9 +2036,9 @@ static int mlx5v_probe(struct auxiliary_device *adev,
=20
 static void mlx5v_remove(struct auxiliary_device *adev)
 {
-	struct mlx5_vdpa_dev *mvdev =3D dev_get_drvdata(&adev->dev);
+	struct mlx5_vdpa_net *ndev =3D dev_get_drvdata(&adev->dev);
=20
-	vdpa_unregister_device(&mvdev->vdev);
+	vdpa_unregister_device(&ndev->mvdev.vdev);
 }
=20
 static const struct auxiliary_device_id mlx5v_id_table[] =3D {
--=20
2.29.2

