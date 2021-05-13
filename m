Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB8437F869
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 15:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233463AbhEMNJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 09:09:32 -0400
Received: from mail-m2454.qiye.163.com ([220.194.24.54]:25454 "EHLO
        mail-m2454.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229466AbhEMNJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 09:09:29 -0400
Received: from localhost.localdomain (unknown [106.75.220.3])
        by mail-m2454.qiye.163.com (Hmail) with ESMTPA id 9EE7CC00202;
        Thu, 13 May 2021 21:08:14 +0800 (CST)
From:   Tao Liu <thomas.liu@ucloud.cn>
To:     pshelar@ovn.org
Cc:     dev@openvswitch.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, i.maximets@ovn.org,
        jean.tourrilhes@hpe.com, kuba@kernel.org, davem@davemloft.net,
        thomas.liu@ucloud.cn, wenxu@ucloud.cn
Subject: [ovs-dev] [PATCH net v2] openvswitch: meter: fix race when getting now_ms.
Date:   Thu, 13 May 2021 21:08:00 +0800
Message-Id: <20210513130800.31913-1-thomas.liu@ucloud.cn>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZQx1MSlZMQ0NCSB5JTEodQx9VGRETFhoSFyQUDg9ZV1kWGg8SFR0UWUFZT0tIVUpKS0
        hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OE06LTo4OT0yKBQrEh9CKTgC
        HigKCUhVSlVKTUlLQkpKSUJOSUlIVTMWGhIXVQ8TFBYaCFUXEg47DhgXFA4fVRgVRVlXWRILWUFZ
        SktNVUxOVUlJS1VIWVdZCAFZQUlNQk83Bg++
X-HM-Tid: 0a7965d789ec8c13kuqt9ee7cc00202
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

OpenVswitch userspace datapath has fixed the same issue[1] some
time ago, and we port the implementation to kernel datapath.

[1] https://patchwork.ozlabs.org/project/openvswitch/patch/20191025114436.9746-1-i.maximets@ovn.org/

Fixes: 96fbc13d7e77 ("openvswitch: Add meter infrastructure")
Signed-off-by: Tao Liu <thomas.liu@ucloud.cn>
Suggested-by: Ilya Maximets <i.maximets@ovn.org>
---
Changelog:
v2: just set negative long_delta_ms to zero in case of race for meter lock.
v1: make now_ms protected by meter lock.
---
 net/openvswitch/meter.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
index 96b524c..896b8f5 100644
--- a/net/openvswitch/meter.c
+++ b/net/openvswitch/meter.c
@@ -611,6 +611,14 @@ bool ovs_meter_execute(struct datapath *dp, struct sk_buff *skb,
 	spin_lock(&meter->lock);
 
 	long_delta_ms = (now_ms - meter->used); /* ms */
+	if (long_delta_ms < 0) {
+		/* This condition means that we have several threads fighting
+		 * for a meter lock, and the one who received the packets a
+		 * bit later wins. Assuming that all racing threads received
+		 * packets at the same time to avoid overflow.
+		 */
+		long_delta_ms = 0;
+	}
 
 	/* Make sure delta_ms will not be too large, so that bucket will not
 	 * wrap around below.
-- 
1.8.3.1

