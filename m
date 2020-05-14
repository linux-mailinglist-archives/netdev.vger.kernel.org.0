Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C36831D3BB6
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 21:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730131AbgENTEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 15:04:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:54474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729059AbgENSy1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 14:54:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 140CD207BB;
        Thu, 14 May 2020 18:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482466;
        bh=NsPSAbL2NEHBGWRcisY+QXXL4SZ8ZjaKEls/vGosqCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sEjy6XTjwC3mdGXXzhjh+D/Cs1vse8q2TDV0GTxyA5hQryG613FPtTwEBmwyH/oDn
         y2GuTqY6p2fhy0iAZTEUIS+KK/Cj9JK3r0CVA2kIeuXsv3En0Rukfe9zEAX0Ygptvc
         Wk4jN8IS9DXzNJdA83uGvJTCcwTT3KaJWac7tCbU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 10/31] vhost/vsock: fix packet delivery order to monitoring devices
Date:   Thu, 14 May 2020 14:53:52 -0400
Message-Id: <20200514185413.20755-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185413.20755-1-sashal@kernel.org>
References: <20200514185413.20755-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>

[ Upstream commit 107bc0766b9feb5113074c753735a3f115c2141f ]

We want to deliver packets to monitoring devices before it is
put in the virtqueue, to avoid that replies can appear in the
packet capture before the transmitted packet.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vsock.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index bac1365cc81b5..7891bd40ebd82 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -182,14 +182,14 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 			break;
 		}
 
-		vhost_add_used(vq, head, sizeof(pkt->hdr) + payload_len);
-		added = true;
-
-		/* Deliver to monitoring devices all correctly transmitted
-		 * packets.
+		/* Deliver to monitoring devices all packets that we
+		 * will transmit.
 		 */
 		virtio_transport_deliver_tap_pkt(pkt);
 
+		vhost_add_used(vq, head, sizeof(pkt->hdr) + payload_len);
+		added = true;
+
 		pkt->off += payload_len;
 		total_len += payload_len;
 
-- 
2.20.1

