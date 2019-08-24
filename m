Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 757909B9EC
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 02:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbfHXA6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 20:58:02 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60950 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbfHXA6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 20:58:01 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7O0sLhH181994;
        Sat, 24 Aug 2019 00:57:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2019-08-05;
 bh=ft8liS0AzZkiLsglAE3VIfJR640YMuYcYpeunU4FAw8=;
 b=LFQ7y++76IyFbsvRaWfns7tVXr3SIMlm4JBDAP3i2xvw8lRtwFzgJXC2Vf81kkUGNDkO
 e961U/qWlDX8loWQQTDdKg5mc6RJvcCQ5Axry1BiGATHWLZgy4jr8IM1nLlpZxE3exxK
 XMknoE4wPQcKJrrHeC+C3xOq+HhNX5rzQ1e6hQ+tUposNr0QGkst7oqc4mCnFpxW9vDK
 5BSihMvUE0TNsFMg6/iRtcsWXlH2WYuC9Z4upQ2B/llDG8STJd/9oHAbYP/u2HCZZDiX
 CCDTVRddf8ytjJ95eabh3MP98DnnHeCHSkI/hbrEGK+WsS0HnVDMmhqlF/ZxWd2xd+B4 Rg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2ue90u7p7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Aug 2019 00:57:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7O0rvm6047348;
        Sat, 24 Aug 2019 00:55:48 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 2ujtbu0yhp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 24 Aug 2019 00:55:48 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7O0tlPI050112;
        Sat, 24 Aug 2019 00:55:47 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2ujtbu0yhh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Aug 2019 00:55:47 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7O0tk02022450;
        Sat, 24 Aug 2019 00:55:46 GMT
Received: from shipfan.cn.oracle.com (/10.113.210.105)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 24 Aug 2019 00:55:45 +0000
From:   Zhu Yanjun <yanjun.zhu@oracle.com>
To:     santosh.shilimkar@oracle.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, gerd.rausch@oracle.com
Subject: [PATCHv2 1/1] net: rds: add service level support in rds-info
Date:   Fri, 23 Aug 2019 21:04:16 -0400
Message-Id: <1566608656-30836-1-git-send-email-yanjun.zhu@oracle.com>
X-Mailer: git-send-email 2.7.4
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9358 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908240007
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From IB specific 7.6.5 SERVICE LEVEL, Service Level (SL)
is used to identify different flows within an IBA subnet.
It is carried in the local route header of the packet.

Before this commit, run "rds-info -I". The outputs are as
below:
"
RDS IB Connections:
 LocalAddr  RemoteAddr Tos SL  LocalDev               RemoteDev
192.2.95.3  192.2.95.1  2   0  fe80::21:28:1a:39  fe80::21:28:10:b9
192.2.95.3  192.2.95.1  1   0  fe80::21:28:1a:39  fe80::21:28:10:b9
192.2.95.3  192.2.95.1  0   0  fe80::21:28:1a:39  fe80::21:28:10:b9
"
After this commit, the output is as below:
"
RDS IB Connections:
 LocalAddr  RemoteAddr Tos SL  LocalDev               RemoteDev
192.2.95.3  192.2.95.1  2   2  fe80::21:28:1a:39  fe80::21:28:10:b9
192.2.95.3  192.2.95.1  1   1  fe80::21:28:1a:39  fe80::21:28:10:b9
192.2.95.3  192.2.95.1  0   0  fe80::21:28:1a:39  fe80::21:28:10:b9
"

The commit fe3475af3bdf ("net: rds: add per rds connection cache
statistics") adds cache_allocs in struct rds_info_rdma_connection
as below:
struct rds_info_rdma_connection {
...
        __u32           rdma_mr_max;
        __u32           rdma_mr_size;
        __u8            tos;
        __u32           cache_allocs;
 };
The peer struct in rds-tools of struct rds_info_rdma_connection is as
below:
struct rds_info_rdma_connection {
...
        uint32_t        rdma_mr_max;
        uint32_t        rdma_mr_size;
        uint8_t         tos;
        uint8_t         sl;
        uint32_t        cache_allocs;
};
The difference between userspace and kernel is the member variable sl.
In the kernel struct, the member variable sl is missing. This will
introduce risks. So it is necessary to use this commit to avoid this risk.

Fixes: fe3475af3bdf ("net: rds: add per rds connection cache statistics")
CC: Joe Jin <joe.jin@oracle.com>
CC: JUNXIAO_BI <junxiao.bi@oracle.com>
Suggested-by: Gerd Rausch <gerd.rausch@oracle.com>
Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
---
V1->V2: fix typos in commit logs.
---
 include/uapi/linux/rds.h |    2 ++
 net/rds/ib.c             |   16 ++++++++++------
 net/rds/ib.h             |    1 +
 net/rds/ib_cm.c          |    3 +++
 net/rds/rdma_transport.c |   10 ++++++++--
 5 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/rds.h b/include/uapi/linux/rds.h
index fd6b5f6..cba368e 100644
--- a/include/uapi/linux/rds.h
+++ b/include/uapi/linux/rds.h
@@ -250,6 +250,7 @@ struct rds_info_rdma_connection {
 	__u32		rdma_mr_max;
 	__u32		rdma_mr_size;
 	__u8		tos;
+	__u8		sl;
 	__u32		cache_allocs;
 };
 
@@ -265,6 +266,7 @@ struct rds6_info_rdma_connection {
 	__u32		rdma_mr_max;
 	__u32		rdma_mr_size;
 	__u8		tos;
+	__u8		sl;
 	__u32		cache_allocs;
 };
 
diff --git a/net/rds/ib.c b/net/rds/ib.c
index ec05d91..45acab2 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -291,7 +291,7 @@ static int rds_ib_conn_info_visitor(struct rds_connection *conn,
 				    void *buffer)
 {
 	struct rds_info_rdma_connection *iinfo = buffer;
-	struct rds_ib_connection *ic;
+	struct rds_ib_connection *ic = conn->c_transport_data;
 
 	/* We will only ever look at IB transports */
 	if (conn->c_trans != &rds_ib_transport)
@@ -301,15 +301,16 @@ static int rds_ib_conn_info_visitor(struct rds_connection *conn,
 
 	iinfo->src_addr = conn->c_laddr.s6_addr32[3];
 	iinfo->dst_addr = conn->c_faddr.s6_addr32[3];
-	iinfo->tos = conn->c_tos;
+	if (ic) {
+		iinfo->tos = conn->c_tos;
+		iinfo->sl = ic->i_sl;
+	}
 
 	memset(&iinfo->src_gid, 0, sizeof(iinfo->src_gid));
 	memset(&iinfo->dst_gid, 0, sizeof(iinfo->dst_gid));
 	if (rds_conn_state(conn) == RDS_CONN_UP) {
 		struct rds_ib_device *rds_ibdev;
 
-		ic = conn->c_transport_data;
-
 		rdma_read_gids(ic->i_cm_id, (union ib_gid *)&iinfo->src_gid,
 			       (union ib_gid *)&iinfo->dst_gid);
 
@@ -329,7 +330,7 @@ static int rds6_ib_conn_info_visitor(struct rds_connection *conn,
 				     void *buffer)
 {
 	struct rds6_info_rdma_connection *iinfo6 = buffer;
-	struct rds_ib_connection *ic;
+	struct rds_ib_connection *ic = conn->c_transport_data;
 
 	/* We will only ever look at IB transports */
 	if (conn->c_trans != &rds_ib_transport)
@@ -337,6 +338,10 @@ static int rds6_ib_conn_info_visitor(struct rds_connection *conn,
 
 	iinfo6->src_addr = conn->c_laddr;
 	iinfo6->dst_addr = conn->c_faddr;
+	if (ic) {
+		iinfo6->tos = conn->c_tos;
+		iinfo6->sl = ic->i_sl;
+	}
 
 	memset(&iinfo6->src_gid, 0, sizeof(iinfo6->src_gid));
 	memset(&iinfo6->dst_gid, 0, sizeof(iinfo6->dst_gid));
@@ -344,7 +349,6 @@ static int rds6_ib_conn_info_visitor(struct rds_connection *conn,
 	if (rds_conn_state(conn) == RDS_CONN_UP) {
 		struct rds_ib_device *rds_ibdev;
 
-		ic = conn->c_transport_data;
 		rdma_read_gids(ic->i_cm_id, (union ib_gid *)&iinfo6->src_gid,
 			       (union ib_gid *)&iinfo6->dst_gid);
 		rds_ibdev = ic->rds_ibdev;
diff --git a/net/rds/ib.h b/net/rds/ib.h
index 303c6ee..f2b558e 100644
--- a/net/rds/ib.h
+++ b/net/rds/ib.h
@@ -220,6 +220,7 @@ struct rds_ib_connection {
 	/* Send/Recv vectors */
 	int			i_scq_vector;
 	int			i_rcq_vector;
+	u8			i_sl;
 };
 
 /* This assumes that atomic_t is at least 32 bits */
diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index fddaa09..233f136 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -152,6 +152,9 @@ void rds_ib_cm_connect_complete(struct rds_connection *conn, struct rdma_cm_even
 		  RDS_PROTOCOL_MINOR(conn->c_version),
 		  ic->i_flowctl ? ", flow control" : "");
 
+	/* receive sl from the peer */
+	ic->i_sl = ic->i_cm_id->route.path_rec->sl;
+
 	atomic_set(&ic->i_cq_quiesce, 0);
 
 	/* Init rings and fill recv. this needs to wait until protocol
diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
index ff74c4b..28668ad 100644
--- a/net/rds/rdma_transport.c
+++ b/net/rds/rdma_transport.c
@@ -43,6 +43,9 @@
 static struct rdma_cm_id *rds6_rdma_listen_id;
 #endif
 
+/* Per IB specification 7.7.3, service level is a 4-bit field. */
+#define TOS_TO_SL(tos)		((tos) & 0xF)
+
 static int rds_rdma_cm_event_handler_cmn(struct rdma_cm_id *cm_id,
 					 struct rdma_cm_event *event,
 					 bool isv6)
@@ -97,10 +100,13 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_cm_id *cm_id,
 			struct rds_ib_connection *ibic;
 
 			ibic = conn->c_transport_data;
-			if (ibic && ibic->i_cm_id == cm_id)
+			if (ibic && ibic->i_cm_id == cm_id) {
+				cm_id->route.path_rec[0].sl =
+					TOS_TO_SL(conn->c_tos);
 				ret = trans->cm_initiate_connect(cm_id, isv6);
-			else
+			} else {
 				rds_conn_drop(conn);
+			}
 		}
 		break;
 
-- 
1.7.1

