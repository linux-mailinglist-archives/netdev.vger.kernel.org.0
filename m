Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A78427E706
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 12:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729353AbgI3Ktv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 06:49:51 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:5197 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbgI3Kto (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 06:49:44 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f7462620000>; Wed, 30 Sep 2020 03:48:02 -0700
Received: from localhost.localdomain (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 30 Sep
 2020 10:49:41 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 4/6] selftests: mlxsw: qos_lib: Add a wrapper for running mlnx_qos
Date:   Wed, 30 Sep 2020 12:49:10 +0200
Message-ID: <4d06176354d79a574c63b3ed255f988f20053c2a.1601462261.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1601462261.git.petrm@nvidia.com>
References: <cover.1601462261.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601462882; bh=8WRI6atJG+3oeVWkigOZBWVCOSBYWfaIQ2LmQIiPuLI=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=pTRZ+RayqY+ceJKBS44TtEWBZlREtrJ99J+UjcC6rQyVr8zHRpjSR4G55gWtddGWM
         AmG14lJ/wmG8Stf/XZPJ4rhB3qDRhEqJ5AVsXlQRwat/bYfLOOaVrSuFa/dKECTFjF
         YCSBwtAEgaPT2DSXDJo6QUoMxrENp+8V3YRgHDnsTvMCyUF3S5UIcJ1+Lp6j7sX19e
         5L0x14UWl3v8Asgl5UDpRanEKc8IAK1UMOfvzwd8KcDqnj9eG9N4hGxeZATg9wRKvM
         XPAsLTEnktl9Si92tUVUgMRArvjV9XkR7rPihqdplA8Ie5jF4Ty2pBfm/xCwIBLnBq
         TWgopUWUtJH5A==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mlnx_qos is a script for configuration of DCB. Despite the name it is not
actually Mellanox-specific in any way. It is currently the only ad-hoc tool
available (in contrast to a daemon that manages an interface on an ongoing
basis). However, it is very verbose and parsing out error messages is not
really possible. Add a wrapper that makes it easier to use the tool.

Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 .../testing/selftests/drivers/net/mlxsw/qos_lib.sh | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_lib.sh b/tools/t=
esting/selftests/drivers/net/mlxsw/qos_lib.sh
index faa51012cdac..0bf76f13c030 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/qos_lib.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_lib.sh
@@ -82,3 +82,17 @@ bail_on_lldpad()
 		fi
 	fi
 }
+
+__mlnx_qos()
+{
+	local err
+
+	mlnx_qos "$@" 2>/dev/null
+	err=3D$?
+
+	if ((err)); then
+		echo "Error ($err) in mlnx_qos $@" >/dev/stderr
+	fi
+
+	return $err
+}
--=20
2.20.1

