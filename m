Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A735311064
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 19:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233259AbhBERJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 12:09:40 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:12002 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233524AbhBEQ3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 11:29:10 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601d8a2b0000>; Fri, 05 Feb 2021 10:10:51 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 5 Feb
 2021 18:10:50 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>, <mst@redhat.com>,
        <jasowang@redhat.com>
CC:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH iproute2-next v4 3/5] utils: Add generic socket helpers
Date:   Fri, 5 Feb 2021 20:10:27 +0200
Message-ID: <20210205181029.365461-4-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210205181029.365461-1-parav@nvidia.com>
References: <20210122112654.9593-3-parav@nvidia.com>
 <20210205181029.365461-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612548651; bh=0vc9oIhSCphJBgS2b+BRbxBgWC7qIQCJt2iCtMo/YR4=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=mcdjeq3O/kd4pTn9v4DzBG8i3WtPRAdiRvwIJLO5NOB70OlAnbbiCfP0A6c3xGqkZ
         lNcvXa6HlsJllpvjP+B1bgz+/OVFW2JLOtZajkNvYGhgs/nEXCxTxcTZJazcpLleOK
         18/BO/1vTq6U5LwpshF+5GqVqRu90Ms2OV6oNFepIUd7LjiUVMXzbgUoofgJgLwX1z
         65rOtdmT/YNX/CG7mhlieqxecx+b6TbH68ZRaRQM8UTGHT7uIN/BHTsPZMCwHHoc/V
         13EfCWXkuP2fHEoWuiu74A6AOKPatlBxWRN4Cd4wfR5fZbdwLLui71dmHyBcVkQ7jU
         AHliLwwDpIlew==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Subsequent patch needs to
(a) query and use socket family
(b) send/receive messages using this family

Hence add helper routines to open, close, query family and to perform
send receive operations.

Signed-off-by: Parav Pandit <parav@nvidia.com>
---
changelog:
v2->v3:
 - split patch from add vdpa tool for socket helpers
---
 include/mnl_utils.h |  16 ++++++
 lib/mnl_utils.c     | 121 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 137 insertions(+)

diff --git a/include/mnl_utils.h b/include/mnl_utils.h
index fa826ef1..9e7d6879 100644
--- a/include/mnl_utils.h
+++ b/include/mnl_utils.h
@@ -2,6 +2,22 @@
 #ifndef __MNL_UTILS_H__
 #define __MNL_UTILS_H__ 1
=20
+struct mnlu_gen_socket {
+	struct mnl_socket *nl;
+	char *buf;
+	uint32_t family;
+	unsigned int seq;
+	uint8_t version;
+};
+
+int mnlu_gen_socket_open(struct mnlu_gen_socket *nlg, const char *family_n=
ame,
+			 uint8_t version);
+void mnlu_gen_socket_close(struct mnlu_gen_socket *nlg);
+struct nlmsghdr *mnlu_gen_socket_cmd_prepare(struct mnlu_gen_socket *nlg,
+					     uint8_t cmd, uint16_t flags);
+int mnlu_gen_socket_sndrcv(struct mnlu_gen_socket *nlg, const struct nlmsg=
hdr *nlh,
+			   mnl_cb_t data_cb, void *data);
+
 struct mnl_socket *mnlu_socket_open(int bus);
 struct nlmsghdr *mnlu_msg_prepare(void *buf, uint32_t nlmsg_type, uint16_t=
 flags,
 				  void *extra_header, size_t extra_header_size);
diff --git a/lib/mnl_utils.c b/lib/mnl_utils.c
index 46384ff8..4f699455 100644
--- a/lib/mnl_utils.c
+++ b/lib/mnl_utils.c
@@ -7,6 +7,7 @@
 #include <string.h>
 #include <time.h>
 #include <libmnl/libmnl.h>
+#include <linux/genetlink.h>
=20
 #include "libnetlink.h"
 #include "mnl_utils.h"
@@ -108,3 +109,123 @@ int mnlu_socket_recv_run(struct mnl_socket *nl, unsig=
ned int seq, void *buf, siz
=20
 	return err;
 }
+
+static int get_family_id_attr_cb(const struct nlattr *attr, void *data)
+{
+	int type =3D mnl_attr_get_type(attr);
+	const struct nlattr **tb =3D data;
+
+	if (mnl_attr_type_valid(attr, CTRL_ATTR_MAX) < 0)
+		return MNL_CB_ERROR;
+
+	if (type =3D=3D CTRL_ATTR_FAMILY_ID &&
+	    mnl_attr_validate(attr, MNL_TYPE_U16) < 0)
+		return MNL_CB_ERROR;
+	tb[type] =3D attr;
+	return MNL_CB_OK;
+}
+
+static int get_family_id_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct genlmsghdr *genl =3D mnl_nlmsg_get_payload(nlh);
+	struct nlattr *tb[CTRL_ATTR_MAX + 1] =3D {};
+	uint32_t *p_id =3D data;
+
+	mnl_attr_parse(nlh, sizeof(*genl), get_family_id_attr_cb, tb);
+	if (!tb[CTRL_ATTR_FAMILY_ID])
+		return MNL_CB_ERROR;
+	*p_id =3D mnl_attr_get_u16(tb[CTRL_ATTR_FAMILY_ID]);
+	return MNL_CB_OK;
+}
+
+static int family_get(struct mnlu_gen_socket *nlg, const char *family_name=
)
+{
+	struct genlmsghdr hdr =3D {};
+	struct nlmsghdr *nlh;
+	int err;
+
+	hdr.cmd =3D CTRL_CMD_GETFAMILY;
+	hdr.version =3D 0x1;
+
+	nlh =3D mnlu_msg_prepare(nlg->buf, GENL_ID_CTRL,
+			       NLM_F_REQUEST | NLM_F_ACK,
+			       &hdr, sizeof(hdr));
+
+	mnl_attr_put_strz(nlh, CTRL_ATTR_FAMILY_NAME, family_name);
+
+	err =3D mnl_socket_sendto(nlg->nl, nlh, nlh->nlmsg_len);
+	if (err < 0)
+		return err;
+
+	err =3D mnlu_socket_recv_run(nlg->nl, nlh->nlmsg_seq, nlg->buf,
+				   MNL_SOCKET_BUFFER_SIZE,
+				   get_family_id_cb, &nlg->family);
+	return err;
+}
+
+int mnlu_gen_socket_open(struct mnlu_gen_socket *nlg, const char *family_n=
ame,
+			 uint8_t version)
+{
+	int err;
+
+	nlg->buf =3D malloc(MNL_SOCKET_BUFFER_SIZE);
+	if (!nlg->buf)
+		goto err_buf_alloc;
+
+	nlg->nl =3D mnlu_socket_open(NETLINK_GENERIC);
+	if (!nlg->nl)
+		goto err_socket_open;
+
+	err =3D family_get(nlg, family_name);
+	if (err)
+		goto err_socket;
+
+	return 0;
+
+err_socket:
+	mnl_socket_close(nlg->nl);
+err_socket_open:
+	free(nlg->buf);
+err_buf_alloc:
+	return -1;
+}
+
+void mnlu_gen_socket_close(struct mnlu_gen_socket *nlg)
+{
+	mnl_socket_close(nlg->nl);
+	free(nlg->buf);
+}
+
+struct nlmsghdr *mnlu_gen_socket_cmd_prepare(struct mnlu_gen_socket *nlg,
+					     uint8_t cmd, uint16_t flags)
+{
+	struct genlmsghdr hdr =3D {};
+	struct nlmsghdr *nlh;
+
+	hdr.cmd =3D cmd;
+	hdr.version =3D nlg->version;
+	nlh =3D mnlu_msg_prepare(nlg->buf, nlg->family, flags, &hdr, sizeof(hdr))=
;
+	nlg->seq =3D nlh->nlmsg_seq;
+	return nlh;
+}
+
+int mnlu_gen_socket_sndrcv(struct mnlu_gen_socket *nlg, const struct nlmsg=
hdr *nlh,
+			   mnl_cb_t data_cb, void *data)
+{
+	int err;
+
+	err =3D mnl_socket_sendto(nlg->nl, nlh, nlh->nlmsg_len);
+	if (err < 0) {
+		perror("Failed to send data");
+		return -errno;
+	}
+
+	err =3D mnlu_socket_recv_run(nlg->nl, nlh->nlmsg_seq, nlg->buf,
+				   MNL_SOCKET_BUFFER_SIZE,
+				   data_cb, data);
+	if (err < 0) {
+		fprintf(stderr, "kernel answers: %s\n", strerror(errno));
+		return -errno;
+	}
+	return 0;
+}
--=20
2.26.2

