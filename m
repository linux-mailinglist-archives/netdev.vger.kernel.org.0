Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0FB942A1D5
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 12:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235910AbhJLKUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 06:20:32 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32252 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235868AbhJLKU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 06:20:26 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19CA6oVo026528;
        Tue, 12 Oct 2021 06:18:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=tw4saScUOpNGUzHaDQk0CkcUj6Le0i9z76n0F8p/444=;
 b=OmoA2m8bZpJoY0foNyhbbuQnFvN/GQ1X/BbRLreyvq3h3DjIoQjElLDgIMq8R/+gItWr
 4GcRJG5mZp3c0nRY8SjSJSjRAN3gguMPjISWLYnDmG6qQUlPoxcTK2MFDWOwBT0CaR+j
 pt9c8v0qit2H5+f7MXtfsRWYHarFhvt3uaXNDSwRbY3lBreq7ec2F5jpIWZLxk3rRdot
 atRm+ICrtX1WN/VcVZV1pdxVrvCqMbXf28TLstD5maZLuaJ02VdRrqCGvQ78UA2DrjXH
 4Yg/3SoWefjilSOLU63VjFasE1Q+dLHGk/0FwU/NqFtuKywjM6vh1oFB7sqHE+r7Dl3N Hw== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bn5apuyxv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 06:18:23 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19CABO0a011948;
        Tue, 12 Oct 2021 10:18:21 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3bk2q9wd9x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 10:18:20 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19CAIELv40173996
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 10:18:14 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BBD9DAE045;
        Tue, 12 Oct 2021 10:18:14 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EBBE8AE061;
        Tue, 12 Oct 2021 10:18:12 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Oct 2021 10:18:12 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH net-next 07/11] net/smc: retrieve v2 gid from IB device
Date:   Tue, 12 Oct 2021 12:17:39 +0200
Message-Id: <20211012101743.2282031-8-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211012101743.2282031-1-kgraul@linux.ibm.com>
References: <20211012101743.2282031-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XDxxHWpncCl-aFZ-ghwaRynhUJkcoIUn
X-Proofpoint-GUID: XDxxHWpncCl-aFZ-ghwaRynhUJkcoIUn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-12_02,2021-10-12_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 lowpriorityscore=0 phishscore=0
 clxscore=1015 mlxscore=0 priorityscore=1501 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110120058
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In smc_ib.c, scan for RoCE devices that support UDP encapsulation.
Find an eligible device and check that there is a route to the
remote peer.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_core.c |  4 ++-
 net/smc/smc_ib.c   | 77 ++++++++++++++++++++++++++++++++++++++--------
 net/smc/smc_ib.h   |  3 +-
 net/smc/smc_pnet.c | 41 +++++++++++++++---------
 4 files changed, 95 insertions(+), 30 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index a081582e5669..6bbd71de6bc0 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -715,7 +715,9 @@ int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
 	lnk->psn_initial = rndvec[0] + (rndvec[1] << 8) +
 		(rndvec[2] << 16);
 	rc = smc_ib_determine_gid(lnk->smcibdev, lnk->ibport,
-				  ini->vlan_id, lnk->gid, &lnk->sgid_index);
+				  ini->vlan_id, lnk->gid, &lnk->sgid_index,
+				  lgr->smc_version == SMC_V2 ?
+						  &ini->smcrv2 : NULL);
 	if (rc)
 		goto out;
 	rc = smc_llc_link_init(lnk);
diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index 9f72910af1d0..d15bacbd73e0 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -17,6 +17,7 @@
 #include <linux/scatterlist.h>
 #include <linux/wait.h>
 #include <linux/mutex.h>
+#include <linux/inetdevice.h>
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_cache.h>
 
@@ -62,16 +63,23 @@ static int smc_ib_modify_qp_rtr(struct smc_link *lnk)
 		IB_QP_STATE | IB_QP_AV | IB_QP_PATH_MTU | IB_QP_DEST_QPN |
 		IB_QP_RQ_PSN | IB_QP_MAX_DEST_RD_ATOMIC | IB_QP_MIN_RNR_TIMER;
 	struct ib_qp_attr qp_attr;
+	u8 hop_lim = 1;
 
 	memset(&qp_attr, 0, sizeof(qp_attr));
 	qp_attr.qp_state = IB_QPS_RTR;
 	qp_attr.path_mtu = min(lnk->path_mtu, lnk->peer_mtu);
 	qp_attr.ah_attr.type = RDMA_AH_ATTR_TYPE_ROCE;
 	rdma_ah_set_port_num(&qp_attr.ah_attr, lnk->ibport);
-	rdma_ah_set_grh(&qp_attr.ah_attr, NULL, 0, lnk->sgid_index, 1, 0);
+	if (lnk->lgr->smc_version == SMC_V2 && lnk->lgr->uses_gateway)
+		hop_lim = IPV6_DEFAULT_HOPLIMIT;
+	rdma_ah_set_grh(&qp_attr.ah_attr, NULL, 0, lnk->sgid_index, hop_lim, 0);
 	rdma_ah_set_dgid_raw(&qp_attr.ah_attr, lnk->peer_gid);
-	memcpy(&qp_attr.ah_attr.roce.dmac, lnk->peer_mac,
-	       sizeof(lnk->peer_mac));
+	if (lnk->lgr->smc_version == SMC_V2 && lnk->lgr->uses_gateway)
+		memcpy(&qp_attr.ah_attr.roce.dmac, lnk->lgr->nexthop_mac,
+		       sizeof(lnk->lgr->nexthop_mac));
+	else
+		memcpy(&qp_attr.ah_attr.roce.dmac, lnk->peer_mac,
+		       sizeof(lnk->peer_mac));
 	qp_attr.dest_qp_num = lnk->peer_qpn;
 	qp_attr.rq_psn = lnk->peer_psn; /* starting receive packet seq # */
 	qp_attr.max_dest_rd_atomic = 1; /* max # of resources for incoming
@@ -210,9 +218,54 @@ int smc_ib_find_route(__be32 saddr, __be32 daddr,
 	return -ENOENT;
 }
 
+static int smc_ib_determine_gid_rcu(const struct net_device *ndev,
+				    const struct ib_gid_attr *attr,
+				    u8 gid[], u8 *sgid_index,
+				    struct smc_init_info_smcrv2 *smcrv2)
+{
+	if (!smcrv2 && attr->gid_type == IB_GID_TYPE_ROCE) {
+		if (gid)
+			memcpy(gid, &attr->gid, SMC_GID_SIZE);
+		if (sgid_index)
+			*sgid_index = attr->index;
+		return 0;
+	}
+	if (smcrv2 && attr->gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP &&
+	    smc_ib_gid_to_ipv4((u8 *)&attr->gid) != cpu_to_be32(INADDR_NONE)) {
+		struct in_device *in_dev = __in_dev_get_rcu(ndev);
+		const struct in_ifaddr *ifa;
+		bool subnet_match = false;
+
+		if (!in_dev)
+			goto out;
+		in_dev_for_each_ifa_rcu(ifa, in_dev) {
+			if (!inet_ifa_match(smcrv2->saddr, ifa))
+				continue;
+			subnet_match = true;
+			break;
+		}
+		if (!subnet_match)
+			goto out;
+		if (smcrv2->daddr && smc_ib_find_route(smcrv2->saddr,
+						       smcrv2->daddr,
+						       smcrv2->nexthop_mac,
+						       &smcrv2->uses_gateway))
+			goto out;
+
+		if (gid)
+			memcpy(gid, &attr->gid, SMC_GID_SIZE);
+		if (sgid_index)
+			*sgid_index = attr->index;
+		return 0;
+	}
+out:
+	return -ENODEV;
+}
+
 /* determine the gid for an ib-device port and vlan id */
 int smc_ib_determine_gid(struct smc_ib_device *smcibdev, u8 ibport,
-			 unsigned short vlan_id, u8 gid[], u8 *sgid_index)
+			 unsigned short vlan_id, u8 gid[], u8 *sgid_index,
+			 struct smc_init_info_smcrv2 *smcrv2)
 {
 	const struct ib_gid_attr *attr;
 	const struct net_device *ndev;
@@ -228,15 +281,13 @@ int smc_ib_determine_gid(struct smc_ib_device *smcibdev, u8 ibport,
 		if (!IS_ERR(ndev) &&
 		    ((!vlan_id && !is_vlan_dev(ndev)) ||
 		     (vlan_id && is_vlan_dev(ndev) &&
-		      vlan_dev_vlan_id(ndev) == vlan_id)) &&
-		    attr->gid_type == IB_GID_TYPE_ROCE) {
-			rcu_read_unlock();
-			if (gid)
-				memcpy(gid, &attr->gid, SMC_GID_SIZE);
-			if (sgid_index)
-				*sgid_index = attr->index;
-			rdma_put_gid_attr(attr);
-			return 0;
+		      vlan_dev_vlan_id(ndev) == vlan_id))) {
+			if (!smc_ib_determine_gid_rcu(ndev, attr, gid,
+						      sgid_index, smcrv2)) {
+				rcu_read_unlock();
+				rdma_put_gid_attr(attr);
+				return 0;
+			}
 		}
 		rcu_read_unlock();
 		rdma_put_gid_attr(attr);
diff --git a/net/smc/smc_ib.h b/net/smc/smc_ib.h
index c55cbd7be67a..07585937370e 100644
--- a/net/smc/smc_ib.h
+++ b/net/smc/smc_ib.h
@@ -101,7 +101,8 @@ void smc_ib_sync_sg_for_device(struct smc_link *lnk,
 			       struct smc_buf_desc *buf_slot,
 			       enum dma_data_direction data_direction);
 int smc_ib_determine_gid(struct smc_ib_device *smcibdev, u8 ibport,
-			 unsigned short vlan_id, u8 gid[], u8 *sgid_index);
+			 unsigned short vlan_id, u8 gid[], u8 *sgid_index,
+			 struct smc_init_info_smcrv2 *smcrv2);
 int smc_ib_find_route(__be32 saddr, __be32 daddr,
 		      u8 nexthop_mac[], u8 *uses_gateway);
 bool smc_ib_is_valid_local_systemid(void);
diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index 4a964e9190b0..67e9d9fde085 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -953,6 +953,26 @@ static int smc_pnet_find_ndev_pnetid_by_table(struct net_device *ndev,
 	return rc;
 }
 
+static int smc_pnet_determine_gid(struct smc_ib_device *ibdev, int i,
+				  struct smc_init_info *ini)
+{
+	if (!ini->check_smcrv2 &&
+	    !smc_ib_determine_gid(ibdev, i, ini->vlan_id, ini->ib_gid, NULL,
+				  NULL)) {
+		ini->ib_dev = ibdev;
+		ini->ib_port = i;
+		return 0;
+	}
+	if (ini->check_smcrv2 &&
+	    !smc_ib_determine_gid(ibdev, i, ini->vlan_id, ini->smcrv2.ib_gid_v2,
+				  NULL, &ini->smcrv2)) {
+		ini->smcrv2.ib_dev_v2 = ibdev;
+		ini->smcrv2.ib_port_v2 = i;
+		return 0;
+	}
+	return -ENODEV;
+}
+
 /* find a roce device for the given pnetid */
 static void _smc_pnet_find_roce_by_pnetid(u8 *pnet_id,
 					  struct smc_init_info *ini,
@@ -961,7 +981,6 @@ static void _smc_pnet_find_roce_by_pnetid(u8 *pnet_id,
 	struct smc_ib_device *ibdev;
 	int i;
 
-	ini->ib_dev = NULL;
 	mutex_lock(&smc_ib_devices.mutex);
 	list_for_each_entry(ibdev, &smc_ib_devices.list, list) {
 		if (ibdev == known_dev)
@@ -971,12 +990,9 @@ static void _smc_pnet_find_roce_by_pnetid(u8 *pnet_id,
 				continue;
 			if (smc_pnet_match(ibdev->pnetid[i - 1], pnet_id) &&
 			    smc_ib_port_active(ibdev, i) &&
-			    !test_bit(i - 1, ibdev->ports_going_away) &&
-			    !smc_ib_determine_gid(ibdev, i, ini->vlan_id,
-						  ini->ib_gid, NULL)) {
-				ini->ib_dev = ibdev;
-				ini->ib_port = i;
-				goto out;
+			    !test_bit(i - 1, ibdev->ports_going_away)) {
+				if (!smc_pnet_determine_gid(ibdev, i, ini))
+					goto out;
 			}
 		}
 	}
@@ -1016,12 +1032,9 @@ static void smc_pnet_find_rdma_dev(struct net_device *netdev,
 			dev_put(ndev);
 			if (netdev == ndev &&
 			    smc_ib_port_active(ibdev, i) &&
-			    !test_bit(i - 1, ibdev->ports_going_away) &&
-			    !smc_ib_determine_gid(ibdev, i, ini->vlan_id,
-						  ini->ib_gid, NULL)) {
-				ini->ib_dev = ibdev;
-				ini->ib_port = i;
-				break;
+			    !test_bit(i - 1, ibdev->ports_going_away)) {
+				if (!smc_pnet_determine_gid(ibdev, i, ini))
+					break;
 			}
 		}
 	}
@@ -1083,8 +1096,6 @@ void smc_pnet_find_roce_resource(struct sock *sk, struct smc_init_info *ini)
 {
 	struct dst_entry *dst = sk_dst_get(sk);
 
-	ini->ib_dev = NULL;
-	ini->ib_port = 0;
 	if (!dst)
 		goto out;
 	if (!dst->dev)
-- 
2.25.1

