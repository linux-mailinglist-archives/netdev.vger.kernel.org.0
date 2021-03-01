Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE89B327CB3
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 11:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232672AbhCAK6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 05:58:11 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:5533 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232631AbhCAK5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 05:57:49 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603cc8840000>; Mon, 01 Mar 2021 02:57:08 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 1 Mar
 2021 10:57:07 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <dsahern@gmail.com>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH iproute2-next 1/4] devlink: Use library provided string processing APIs
Date:   Mon, 1 Mar 2021 12:56:51 +0200
Message-ID: <20210301105654.291949-2-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210301105654.291949-1-parav@nvidia.com>
References: <20210301105654.291949-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614596228; bh=wWVKI1M2miRXpwR/7NdBQrEe/pSVfIrwI05Y78HJyRQ=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=Oag2XaXBPxGh5XrlcCFoopXQaJmDAQUdKoUx4wi8d3HDTTJg7qxmo2AVDOjN278DG
         5oesQ+MhBlPvA21Vw++JzuIy/hZ0N/Z91wOZGdHrJamkDKGyZJBpMEEED4ICi/WJTv
         YY5Podt+gaeNQOXaC0Fuo0wzbZrqXzJ2RMD6hxMZvoWtGFbtziZjtbFb4nh7u9fcZc
         d4N2Bm2syxdjIBRMol2fKbBJZuGzCNhEAFcm3HWW48/M3P/R3fWHNM/gdAN/qTR0Ev
         HH5NE+1YyBnN7gnofB88v9n1gHUqHFTkVZ7WHnZq5s1cCPBA60hdrU3/AiPGAFFUQB
         V7SxHX1fxNQVQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

User helper routines provided by library for counting slash and
splitting string on delimiter.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 devlink/devlink.c | 43 +++++++++----------------------------------
 1 file changed, 9 insertions(+), 34 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index c6e85ff9..85f90baf 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -866,31 +866,6 @@ static int ifname_map_rev_lookup(struct dl *dl, const =
char *bus_name,
 	return -ENOENT;
 }
=20
-static unsigned int strslashcount(char *str)
-{
-	unsigned int count =3D 0;
-	char *pos =3D str;
-
-	while ((pos =3D strchr(pos, '/'))) {
-		count++;
-		pos++;
-	}
-	return count;
-}
-
-static int strslashrsplit(char *str, char **before, char **after)
-{
-	char *slash;
-
-	slash =3D strrchr(str, '/');
-	if (!slash)
-		return -EINVAL;
-	*slash =3D '\0';
-	*before =3D str;
-	*after =3D slash + 1;
-	return 0;
-}
-
 static int strtouint64_t(const char *str, uint64_t *p_val)
 {
 	char *endptr;
@@ -965,7 +940,7 @@ static int strtobool(const char *str, bool *p_val)
=20
 static int __dl_argv_handle(char *str, char **p_bus_name, char **p_dev_nam=
e)
 {
-	strslashrsplit(str, p_bus_name, p_dev_name);
+	str_split_by_char(str, p_bus_name, p_dev_name, '/');
 	return 0;
 }
=20
@@ -977,7 +952,7 @@ static int dl_argv_handle(struct dl *dl, char **p_bus_n=
ame, char **p_dev_name)
 		pr_err("Devlink identification (\"bus_name/dev_name\") expected\n");
 		return -EINVAL;
 	}
-	if (strslashcount(str) !=3D 1) {
+	if (get_str_char_count(str, '/') !=3D 1) {
 		pr_err("Wrong devlink identification string format.\n");
 		pr_err("Expected \"bus_name/dev_name\".\n");
 		return -EINVAL;
@@ -993,7 +968,7 @@ static int __dl_argv_handle_port(char *str,
 	char *portstr;
 	int err;
=20
-	err =3D strslashrsplit(str, &handlestr, &portstr);
+	err =3D str_split_by_char(str, &handlestr, &portstr, '/');
 	if (err) {
 		pr_err("Port identification \"%s\" is invalid\n", str);
 		return err;
@@ -1004,7 +979,7 @@ static int __dl_argv_handle_port(char *str,
 		       portstr);
 		return err;
 	}
-	err =3D strslashrsplit(handlestr, p_bus_name, p_dev_name);
+	err =3D str_split_by_char(handlestr, p_bus_name, p_dev_name, '/');
 	if (err) {
 		pr_err("Port identification \"%s\" is invalid\n", str);
 		return err;
@@ -1037,7 +1012,7 @@ static int dl_argv_handle_port(struct dl *dl, char **=
p_bus_name,
 		pr_err("Port identification (\"bus_name/dev_name/port_index\" or \"netde=
v ifname\") expected.\n");
 		return -EINVAL;
 	}
-	slash_count =3D strslashcount(str);
+	slash_count =3D get_str_char_count(str, '/');
 	switch (slash_count) {
 	case 0:
 		return __dl_argv_handle_port_ifname(dl, str, p_bus_name,
@@ -1066,7 +1041,7 @@ static int dl_argv_handle_both(struct dl *dl, char **=
p_bus_name,
 		       "Port identification (\"bus_name/dev_name/port_index\" or \"netde=
v ifname\")\n");
 		return -EINVAL;
 	}
-	slash_count =3D strslashcount(str);
+	slash_count =3D get_str_char_count(str, '/');
 	if (slash_count =3D=3D 1) {
 		err =3D __dl_argv_handle(str, p_bus_name, p_dev_name);
 		if (err)
@@ -1098,12 +1073,12 @@ static int __dl_argv_handle_region(char *str, char =
**p_bus_name,
 	char *handlestr;
 	int err;
=20
-	err =3D strslashrsplit(str, &handlestr, p_region);
+	err =3D str_split_by_char(str, &handlestr, p_region, '/');
 	if (err) {
 		pr_err("Region identification \"%s\" is invalid\n", str);
 		return err;
 	}
-	err =3D strslashrsplit(handlestr, p_bus_name, p_dev_name);
+	err =3D str_split_by_char(handlestr, p_bus_name, p_dev_name, '/');
 	if (err) {
 		pr_err("Region identification \"%s\" is invalid\n", str);
 		return err;
@@ -1122,7 +1097,7 @@ static int dl_argv_handle_region(struct dl *dl, char =
**p_bus_name,
 		return -EINVAL;
 	}
=20
-	slash_count =3D strslashcount(str);
+	slash_count =3D get_str_char_count(str, '/');
 	if (slash_count !=3D 2) {
 		pr_err("Wrong region identification string format.\n");
 		pr_err("Expected \"bus_name/dev_name/region\" identification.\n"".\n");
--=20
2.26.2

