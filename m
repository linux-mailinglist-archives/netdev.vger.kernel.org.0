Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17AF0447D5
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 19:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729788AbfFMRCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 13:02:10 -0400
Received: from mx0b-00190b01.pphosted.com ([67.231.157.127]:51224 "EHLO
        mx0b-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729526AbfFLXOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 19:14:55 -0400
Received: from pps.filterd (m0122331.ppops.net [127.0.0.1])
        by mx0b-00190b01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5CMvjjN027726;
        Thu, 13 Jun 2019 00:14:44 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id; s=jan2016.eng;
 bh=3/9fVxMqp4e6sql3CZJJK3vMtaZhSRLm+iq0QWzMWr8=;
 b=QZW7xno+qkUEYa293pBpsYdZZ5fwt/rkQ/TFPnNcWc9sbWrJHmeuZynKf8Jlx6Ev8td5
 kKqjqb2gFQ/fDoZNfbdSRsBS6Qd2xHFIuARY0wgCsR850MXfzZd46XXaHqy6m8Gp5EaO
 0RCLxKrY0dDNNlv8Eva9ejavRnl4lvDJWzlWcS/SwfMDJIVrUuM+uRP0x/GPk2Pk55WU
 TkHgCtP9r1pmqe27LQIWOSP2KaF9ReRRhBHAFQYiTVlmVfF7ouBrgzvItATAzRHg9OiS
 gPd6Tql8C557Y0okqFce9gBLjMJ1dt/fBvvG0i5jsdkUv5TrJ+duqlC+tJrw+iRa5C9M bQ== 
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18] (may be forged))
        by mx0b-00190b01.pphosted.com with ESMTP id 2t2macmg6g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jun 2019 00:14:44 +0100
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
        by prod-mail-ppoint1.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x5CN2lHU013869;
        Wed, 12 Jun 2019 19:14:43 -0400
Received: from prod-mail-relay10.akamai.com ([172.27.118.251])
        by prod-mail-ppoint1.akamai.com with ESMTP id 2t08bwyvv7-1;
        Wed, 12 Jun 2019 19:14:43 -0400
Received: from bos-lpjec.kendall.corp.akamai.com (bos-lpjec.kendall.corp.akamai.com [172.29.170.83])
        by prod-mail-relay10.akamai.com (Postfix) with ESMTP id F1E4F1FCD8;
        Wed, 12 Jun 2019 23:14:41 +0000 (GMT)
From:   Jason Baron <jbaron@akamai.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Joshua Hunt <johunt@akamai.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next] gso: enable udp gso for virtual devices
Date:   Wed, 12 Jun 2019 19:12:40 -0400
Message-Id: <1560381160-19584-1-git-send-email-jbaron@akamai.com>
X-Mailer: git-send-email 2.7.4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-12_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906120162
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-12_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906120162
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the stack supports UDP GRO, we can enable udp gso for virtual
devices. If packets are looped back locally, and UDP GRO is not enabled
then they will be segmented to gso_size via udp_rcv_segment(). This
essentiallly just reverts: 8eea1ca gso: limit udp gso to egress-only
virtual devices.

Tested by connecting two namespaces via macvlan and then ran
udpgso_bench_tx:

before:
udp tx:   2068 MB/s    35085 calls/s  35085 msg/s

after (no UDP_GRO):
udp tx:   3438 MB/s    58319 calls/s  58319 msg/s

after (UDP_GRO):
udp tx:   8037 MB/s   136314 calls/s 136314 msg/s

Signed-off-by: Jason Baron <jbaron@akamai.com>
Co-developed-by: Joshua Hunt <johunt@akamai.com>
Signed-off-by: Joshua Hunt <johunt@akamai.com>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
---
 drivers/net/bonding/bond_main.c | 5 ++---
 drivers/net/team/team.c         | 5 ++---
 include/linux/netdev_features.h | 1 +
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 4f5b3ba..c4260be 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1120,8 +1120,7 @@ static void bond_compute_features(struct bonding *bond)
 
 done:
 	bond_dev->vlan_features = vlan_features;
-	bond_dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL |
-				    NETIF_F_GSO_UDP_L4;
+	bond_dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL;
 	bond_dev->mpls_features = mpls_features;
 	bond_dev->gso_max_segs = gso_max_segs;
 	netif_set_gso_max_size(bond_dev, gso_max_size);
@@ -4308,7 +4307,7 @@ void bond_setup(struct net_device *bond_dev)
 				NETIF_F_HW_VLAN_CTAG_RX |
 				NETIF_F_HW_VLAN_CTAG_FILTER;
 
-	bond_dev->hw_features |= NETIF_F_GSO_ENCAP_ALL | NETIF_F_GSO_UDP_L4;
+	bond_dev->hw_features |= NETIF_F_GSO_ENCAP_ALL;
 	bond_dev->features |= bond_dev->hw_features;
 }
 
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index b48006e..30299e3 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1003,8 +1003,7 @@ static void __team_compute_features(struct team *team)
 	}
 
 	team->dev->vlan_features = vlan_features;
-	team->dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL |
-				     NETIF_F_GSO_UDP_L4;
+	team->dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL;
 	team->dev->hard_header_len = max_hard_header_len;
 
 	team->dev->priv_flags &= ~IFF_XMIT_DST_RELEASE;
@@ -2132,7 +2131,7 @@ static void team_setup(struct net_device *dev)
 			   NETIF_F_HW_VLAN_CTAG_RX |
 			   NETIF_F_HW_VLAN_CTAG_FILTER;
 
-	dev->hw_features |= NETIF_F_GSO_ENCAP_ALL | NETIF_F_GSO_UDP_L4;
+	dev->hw_features |= NETIF_F_GSO_ENCAP_ALL;
 	dev->features |= dev->hw_features;
 }
 
diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 4b19c54..188127c 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -237,6 +237,7 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
 				 NETIF_F_GSO_GRE_CSUM |			\
 				 NETIF_F_GSO_IPXIP4 |			\
 				 NETIF_F_GSO_IPXIP6 |			\
+				 NETIF_F_GSO_UDP_L4 |			\
 				 NETIF_F_GSO_UDP_TUNNEL |		\
 				 NETIF_F_GSO_UDP_TUNNEL_CSUM)
 
-- 
2.7.4

