Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F23776BAA4
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 12:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731664AbfGQKxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 06:53:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37620 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731586AbfGQKxh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 06:53:37 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 95C1659474;
        Wed, 17 Jul 2019 10:53:37 +0000 (UTC)
Received: from hp-dl380pg8-01.lab.eng.pek2.redhat.com (hp-dl380pg8-01.lab.eng.pek2.redhat.com [10.73.8.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AB25B1001DC0;
        Wed, 17 Jul 2019 10:53:34 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jfreimann@redhat.com, tiwei.bie@intel.com,
        maxime.coquelin@redhat.com
Subject: [PATCH V3 07/15] vhost_net: calculate last used length once for mergeable buffer
Date:   Wed, 17 Jul 2019 06:52:47 -0400
Message-Id: <20190717105255.63488-8-jasowang@redhat.com>
In-Reply-To: <20190717105255.63488-1-jasowang@redhat.com>
References: <20190717105255.63488-1-jasowang@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Wed, 17 Jul 2019 10:53:37 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch tries to calculate last used length once instead of
twice. This can help to convert to use shadow used ring API for
RX.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/net.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index cf47e6e348f4..1a67f889cbc1 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1065,12 +1065,12 @@ static int get_rx_bufs(struct vhost_virtqueue *vq,
 		}
 		heads[headcount].id = cpu_to_vhost32(vq, d);
 		len = iov_length(vq->iov + seg, in);
-		heads[headcount].len = cpu_to_vhost32(vq, len);
 		datalen -= len;
+		heads[headcount].len = cpu_to_vhost32(vq,
+				       datalen >= 0 ? len : len + datalen);
 		++headcount;
 		seg += in;
 	}
-	heads[headcount - 1].len = cpu_to_vhost32(vq, len + datalen);
 	*iovcount = seg;
 	if (unlikely(log))
 		*log_num = nlogs;
-- 
2.18.1

