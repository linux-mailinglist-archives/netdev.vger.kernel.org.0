Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 221F737F56B
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 12:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232454AbhEMKOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 06:14:40 -0400
Received: from mail-m2454.qiye.163.com ([220.194.24.54]:12032 "EHLO
        mail-m2454.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbhEMKOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 06:14:34 -0400
X-Greylist: delayed 604 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 May 2021 06:14:31 EDT
Received: from localhost.localdomain (unknown [106.75.220.3])
        by mail-m2454.qiye.163.com (Hmail) with ESMTPA id 38B70C0027F;
        Thu, 13 May 2021 18:03:11 +0800 (CST)
From:   Tao Liu <thomas.liu@ucloud.cn>
To:     pshelar@ovn.org
Cc:     dev@openvswitch.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, i.maximets@ovn.org,
        jean.tourrilhes@hpe.com, kuba@kernel.org, davem@davemloft.net,
        thomas.liu@ucloud.cn
Subject: [ovs-dev] [PATCH net] openvswitch: meter: fix race when getting now_ms.
Date:   Thu, 13 May 2021 18:03:00 +0800
Message-Id: <20210513100300.22735-1-thomas.liu@ucloud.cn>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZQ0pIQlZOGENIT05PTxgfSk9VGRETFhoSFyQUDg9ZV1kWGg8SFR0UWUFZT0tIVUpKS0
        hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NxA6Hio4Nz0yLBUWDRJWDi0i
        GQkwFDRVSlVKTUlLQktLSkJKTEtPVTMWGhIXVQ8TFBYaCFUXEg47DhgXFA4fVRgVRVlXWRILWUFZ
        SktNVUxOVUlJS1VIWVdZCAFZQUlIQkk3Bg++
X-HM-Tid: 0a79652e1d078c13kuqt38b70c0027f
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have observed meters working unexpected if traffic is 3+Gbit/s
with multiple connections.

now_ms is not pretected by meter->lock, we may get a negative
long_delta_ms when another cpu updated meter->used, then:
    delta_ms = (u32)long_delta_ms;
which will be a large value.

    band->bucket += delta_ms * band->rate;
then we get a wrong band->bucket.

Fixes: 96fbc13d7e77 ("openvswitch: Add meter infrastructure")
Signed-off-by: Tao Liu <thomas.liu@ucloud.cn>
---
 net/openvswitch/meter.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
index 96b524c..c50ab7f 100644
--- a/net/openvswitch/meter.c
+++ b/net/openvswitch/meter.c
@@ -593,7 +593,7 @@ static int ovs_meter_cmd_del(struct sk_buff *skb, struct genl_info *info)
 bool ovs_meter_execute(struct datapath *dp, struct sk_buff *skb,
 		       struct sw_flow_key *key, u32 meter_id)
 {
-	long long int now_ms = div_u64(ktime_get_ns(), 1000 * 1000);
+	long long int now_ms;
 	long long int long_delta_ms;
 	struct dp_meter_band *band;
 	struct dp_meter *meter;
@@ -610,6 +610,7 @@ bool ovs_meter_execute(struct datapath *dp, struct sk_buff *skb,
 	/* Lock the meter while using it. */
 	spin_lock(&meter->lock);
 
+	now_ms = div_u64(ktime_get_ns(), 1000 * 1000);
 	long_delta_ms = (now_ms - meter->used); /* ms */
 
 	/* Make sure delta_ms will not be too large, so that bucket will not
-- 
1.8.3.1

