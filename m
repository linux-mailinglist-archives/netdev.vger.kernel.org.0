Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E509B327CB7
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 11:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbhCAK7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 05:59:10 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:5922 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232642AbhCAK5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 05:57:52 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603cc8850001>; Mon, 01 Mar 2021 02:57:09 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 1 Mar
 2021 10:57:08 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <dsahern@gmail.com>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH iproute2-next 2/4] utils: Introduce helper routines for generic socket recv
Date:   Mon, 1 Mar 2021 12:56:52 +0200
Message-ID: <20210301105654.291949-3-parav@nvidia.com>
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
        t=1614596229; bh=d/JITpzueBI2efuWK72XleyrEc8yUptt+elDLSBIP80=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=hIS6L2VniN2Aus7clYBUxfQJTFEILsfkMLWYoCBsytEiB6Lrne07s3016gzBtiSQT
         sue5G15sO4DvPTtIckjdCcYqcC3cedJK7jIatU2dfBfr+hGNMHSy3hMO4GKEkhVkSa
         KmgUUEllyQ1oY0XeeB2xvE8JuTjrcx+ZlXODwg/TTTGnQIJD/qmLO2hKltEa7OWC23
         EcVaiZjJTZ52Jk4L9bmugmKWUr/ZkzxUI6Gkd1vq8Ravg1h4qLJekHTlPWkeaLpz3a
         eeXgWofewsMFSQgk3PkSDNiEyOj0QRGgfdzCLIZiWACmMwK79YbWE0wokocQW+49B8
         xl53zShRsZCXw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce helper for generic socket receive helper and introduce helper
to build command with custom family and version.

Use API in subsequent devlink patch.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 include/mnl_utils.h |  6 ++++++
 lib/mnl_utils.c     | 25 +++++++++++++++++++++----
 2 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/include/mnl_utils.h b/include/mnl_utils.h
index 9e7d6879..aa5f0a9b 100644
--- a/include/mnl_utils.h
+++ b/include/mnl_utils.h
@@ -13,6 +13,10 @@ struct mnlu_gen_socket {
 int mnlu_gen_socket_open(struct mnlu_gen_socket *nlg, const char *family_n=
ame,
 			 uint8_t version);
 void mnlu_gen_socket_close(struct mnlu_gen_socket *nlg);
+struct nlmsghdr *
+_mnlu_gen_socket_cmd_prepare(struct mnlu_gen_socket *nlg,
+			     uint8_t cmd, uint16_t flags,
+			     uint32_t id, uint8_t version);
 struct nlmsghdr *mnlu_gen_socket_cmd_prepare(struct mnlu_gen_socket *nlg,
 					     uint8_t cmd, uint16_t flags);
 int mnlu_gen_socket_sndrcv(struct mnlu_gen_socket *nlg, const struct nlmsg=
hdr *nlh,
@@ -23,5 +27,7 @@ struct nlmsghdr *mnlu_msg_prepare(void *buf, uint32_t nlm=
sg_type, uint16_t flags
 				  void *extra_header, size_t extra_header_size);
 int mnlu_socket_recv_run(struct mnl_socket *nl, unsigned int seq, void *bu=
f, size_t buf_size,
 			 mnl_cb_t cb, void *data);
+int mnlu_gen_socket_recv_run(struct mnlu_gen_socket *nlg, mnl_cb_t cb,
+			     void *data);
=20
 #endif /* __MNL_UTILS_H__ */
diff --git a/lib/mnl_utils.c b/lib/mnl_utils.c
index 4f699455..d5abff58 100644
--- a/lib/mnl_utils.c
+++ b/lib/mnl_utils.c
@@ -196,19 +196,28 @@ void mnlu_gen_socket_close(struct mnlu_gen_socket *nl=
g)
 	free(nlg->buf);
 }
=20
-struct nlmsghdr *mnlu_gen_socket_cmd_prepare(struct mnlu_gen_socket *nlg,
-					     uint8_t cmd, uint16_t flags)
+struct nlmsghdr *
+_mnlu_gen_socket_cmd_prepare(struct mnlu_gen_socket *nlg,
+			     uint8_t cmd, uint16_t flags,
+			     uint32_t id, uint8_t version)
 {
 	struct genlmsghdr hdr =3D {};
 	struct nlmsghdr *nlh;
=20
 	hdr.cmd =3D cmd;
-	hdr.version =3D nlg->version;
-	nlh =3D mnlu_msg_prepare(nlg->buf, nlg->family, flags, &hdr, sizeof(hdr))=
;
+	hdr.version =3D version;
+	nlh =3D mnlu_msg_prepare(nlg->buf, id, flags, &hdr, sizeof(hdr));
 	nlg->seq =3D nlh->nlmsg_seq;
 	return nlh;
 }
=20
+struct nlmsghdr *mnlu_gen_socket_cmd_prepare(struct mnlu_gen_socket *nlg,
+					     uint8_t cmd, uint16_t flags)
+{
+	return _mnlu_gen_socket_cmd_prepare(nlg, cmd, flags, nlg->family,
+					    nlg->version);
+}
+
 int mnlu_gen_socket_sndrcv(struct mnlu_gen_socket *nlg, const struct nlmsg=
hdr *nlh,
 			   mnl_cb_t data_cb, void *data)
 {
@@ -229,3 +238,11 @@ int mnlu_gen_socket_sndrcv(struct mnlu_gen_socket *nlg=
, const struct nlmsghdr *n
 	}
 	return 0;
 }
+
+int mnlu_gen_socket_recv_run(struct mnlu_gen_socket *nlg, mnl_cb_t cb,
+			     void *data)
+{
+	return mnlu_socket_recv_run(nlg->nl, nlg->seq, nlg->buf,
+				    MNL_SOCKET_BUFFER_SIZE,
+				    cb, data);
+}
--=20
2.26.2

