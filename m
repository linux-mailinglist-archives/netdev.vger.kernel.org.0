Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 411D3366D61
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 15:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243103AbhDUN60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 09:58:26 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:40039 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238217AbhDUN60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 09:58:26 -0400
X-Originating-IP: 78.45.89.65
Received: from im-t490s.redhat.com (ip-78-45-89-65.net.upcbroadband.cz [78.45.89.65])
        (Authenticated sender: i.maximets@ovn.org)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 89E21240007;
        Wed, 21 Apr 2021 13:57:49 +0000 (UTC)
From:   Ilya Maximets <i.maximets@ovn.org>
To:     Pravin B Shelar <pshelar@ovn.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andy Zhou <azhou@ovn.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dev@openvswitch.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        William Tu <u9012063@gmail.com>,
        Jean Tourrilhes <jean.tourrilhes@hpe.com>,
        Ilya Maximets <i.maximets@ovn.org>
Subject: [PATCH net] openvswitch: meter: remove rate from the bucket size calculation
Date:   Wed, 21 Apr 2021 15:57:47 +0200
Message-Id: <20210421135747.312095-1-i.maximets@ovn.org>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implementation of meters supposed to be a classic token bucket with 2
typical parameters: rate and burst size.

Burst size in this schema is the maximum number of bytes/packets that
could pass without being rate limited.

Recent changes to userspace datapath made meter implementation to be
in line with the kernel one, and this uncovered several issues.

The main problem is that maximum bucket size for unknown reason
accounts not only burst size, but also the numerical value of rate.
This creates a lot of confusion around behavior of meters.

For example, if rate is configured as 1000 pps and burst size set to 1,
this should mean that meter will tolerate bursts of 1 packet at most,
i.e. not a single packet above the rate should pass the meter.
However, current implementation calculates maximum bucket size as
(rate + burst size), so the effective bucket size will be 1001.  This
means that first 1000 packets will not be rate limited and average
rate might be twice as high as the configured rate.  This also makes
it practically impossible to configure meter that will have burst size
lower than the rate, which might be a desirable configuration if the
rate is high.

Inability to configure low values of a burst size and overall inability
for a user to predict what will be a maximum and average rate from the
configured parameters of a meter without looking at the OVS and kernel
code might be also classified as a security issue, because drop meters
are frequently used as a way of protection from DoS attacks.

This change removes rate from the calculation of a bucket size, making
it in line with the classic token bucket algorithm and essentially
making the rate and burst tolerance being predictable from a users'
perspective.

Same change proposed for the userspace implementation.

Fixes: 96fbc13d7e77 ("openvswitch: Add meter infrastructure")
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
---

The same patch for the userspace datapath:
  https://patchwork.ozlabs.org/project/openvswitch/patch/20210421134816.311584-1-i.maximets@ovn.org/

 net/openvswitch/meter.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
index 15424d26e85d..96b524ceabca 100644
--- a/net/openvswitch/meter.c
+++ b/net/openvswitch/meter.c
@@ -392,7 +392,7 @@ static struct dp_meter *dp_meter_create(struct nlattr **a)
 		 *
 		 * Start with a full bucket.
 		 */
-		band->bucket = (band->burst_size + band->rate) * 1000ULL;
+		band->bucket = band->burst_size * 1000ULL;
 		band_max_delta_t = div_u64(band->bucket, band->rate);
 		if (band_max_delta_t > meter->max_delta_t)
 			meter->max_delta_t = band_max_delta_t;
@@ -641,7 +641,7 @@ bool ovs_meter_execute(struct datapath *dp, struct sk_buff *skb,
 		long long int max_bucket_size;
 
 		band = &meter->bands[i];
-		max_bucket_size = (band->burst_size + band->rate) * 1000LL;
+		max_bucket_size = band->burst_size * 1000LL;
 
 		band->bucket += delta_ms * band->rate;
 		if (band->bucket > max_bucket_size)
-- 
2.26.3

