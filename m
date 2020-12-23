Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEE9A2E17CA
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 04:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbgLWDfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 22:35:17 -0500
Received: from mx0b-00190b01.pphosted.com ([67.231.157.127]:4788 "EHLO
        mx0b-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726387AbgLWDfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 22:35:17 -0500
X-Greylist: delayed 2325 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Dec 2020 22:35:16 EST
Received: from pps.filterd (m0050102.ppops.net [127.0.0.1])
        by m0050102.ppops.net-00190b01. (8.16.0.43/8.16.0.43) with SMTP id 0BN2sm2P023335;
        Wed, 23 Dec 2020 02:54:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=jan2016.eng;
 bh=DgrY6qCoqWi+YhMnrptnnl8bfOZQ2OvTKc2L4lgpPos=;
 b=oNMojHZ8kFkQIQzWDGFn16T9EHDj6qp/XP1HKq5rxbi7QzWABYrNBROsLjBtmASx9jmu
 Oxee5DaKo5m+E9urrCXPsz/zs7lkvzBfpStP1LjuTCNCtweIE+2okDX/wjQjyPWNMwLD
 KFu1S/TRnn5M/44NjIr9dl9RzaLiRfA1vD+4YBpokOSfnyNGoZdnr2/77qAb6cylOmwV
 H0q2Mm5inaDaaKZQkJjAEfTn8vTDMnsA4Bpo7VgHdvcEkhr6EH9iq53AGyNSrOE1ByxQ
 dpMwgauxypaomZVUcJsAa0L00UXhEjOQyCXmC0MafuGIEcvqONGovrFE/OE1XzGW9fWS 1Q== 
Received: from prod-mail-ppoint5 (prod-mail-ppoint5.akamai.com [184.51.33.60] (may be forged))
        by m0050102.ppops.net-00190b01. with ESMTP id 35k0e3emkk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Dec 2020 02:54:48 +0000
Received: from pps.filterd (prod-mail-ppoint5.akamai.com [127.0.0.1])
        by prod-mail-ppoint5.akamai.com (8.16.0.43/8.16.0.43) with SMTP id 0BN2pRfn009175;
        Tue, 22 Dec 2020 18:54:47 -0800
Received: from email.msg.corp.akamai.com ([172.27.123.30])
        by prod-mail-ppoint5.akamai.com with ESMTP id 35k0ftkj6q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 22 Dec 2020 18:54:47 -0800
Received: from usma1ex-cas4.msg.corp.akamai.com (172.27.123.57) by
 usma1ex-dag3mb4.msg.corp.akamai.com (172.27.123.56) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Tue, 22 Dec 2020 21:54:47 -0500
Received: from bos-lp1yy.kendall.corp.akamai.com (172.28.3.205) by
 usma1ex-cas4.msg.corp.akamai.com (172.27.123.57) with Microsoft SMTP Server
 id 15.0.1497.2 via Frontend Transport; Tue, 22 Dec 2020 21:54:47 -0500
Received: by bos-lp1yy.kendall.corp.akamai.com (Postfix, from userid 45189)
        id 051D715F777; Tue, 22 Dec 2020 21:54:46 -0500 (EST)
From:   Jeff Dike <jdike@akamai.com>
To:     <netdev@vger.kernel.org>
CC:     <jdike@akamai.com>, <virtualization@lists.linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, <stable@vger.kernel.org>
Subject: [PATCH Repost to netdev] virtio_net: Fix recursive call to cpus_read_lock()
Date:   Tue, 22 Dec 2020 21:54:21 -0500
Message-ID: <20201223025421.671-1-jdike@akamai.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-22_13:2020-12-21,2020-12-22 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012230020
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-23_01:2020-12-21,2020-12-23 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 clxscore=1011 lowpriorityscore=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012230021
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 184.51.33.60)
 smtp.mailfrom=jdike@akamai.com smtp.helo=prod-mail-ppoint5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

virtnet_set_channels can recursively call cpus_read_lock if CONFIG_XPS
and CONFIG_HOTPLUG are enabled.

The path is:
    virtnet_set_channels - calls get_online_cpus(), which is a trivial
wrapper around cpus_read_lock()
    netif_set_real_num_tx_queues
    netif_reset_xps_queues_gt
    netif_reset_xps_queues - calls cpus_read_lock()

This call chain and potential deadlock happens when the number of TX
queues is reduced.

This commit the removes netif_set_real_num_[tr]x_queues calls from
inside the get/put_online_cpus section, as they don't require that it
be held.

Signed-off-by: Jeff Dike <jdike@akamai.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Cc: stable@vger.kernel.org
---
 drivers/net/virtio_net.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 052975ea0af4..e02c7e0f1cf9 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2093,14 +2093,16 @@ static int virtnet_set_channels(struct net_device *dev,
 
 	get_online_cpus();
 	err = _virtnet_set_queues(vi, queue_pairs);
-	if (!err) {
-		netif_set_real_num_tx_queues(dev, queue_pairs);
-		netif_set_real_num_rx_queues(dev, queue_pairs);
-
-		virtnet_set_affinity(vi);
+	if (err){
+		put_online_cpus();
+		goto err;
 	}
+	virtnet_set_affinity(vi);
 	put_online_cpus();
 
+	netif_set_real_num_tx_queues(dev, queue_pairs);
+	netif_set_real_num_rx_queues(dev, queue_pairs);
+ err:
 	return err;
 }
 
-- 
2.17.1

