Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE22C3CF657
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 10:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234972AbhGTIMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 04:12:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51969 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233890AbhGTIFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 04:05:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626770703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=425wuTtOcHExhMXwIaZzvoSqg6Zv0oRhz0fN9NinKFs=;
        b=hrPP6Lp3lVNRnumNaiHeXFZ0RAJsE0ZKBzPI0yfJrSXrIQqzSoVchEbXNJ/66r9VYhbzi2
        8RYIla65aN4KtyNIIjSjPHjF50nW5yH8Z8EhJYi0K7FUiE3ZkAs8mY+KSY+D/VsE68XG0Q
        aYVLs8JMVOR7sA2c9MiiyY6rGO5Ll2M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-XBDzKip6NIqcDN95h0fNKw-1; Tue, 20 Jul 2021 04:45:01 -0400
X-MC-Unique: XBDzKip6NIqcDN95h0fNKw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 97F3E1940920;
        Tue, 20 Jul 2021 08:45:00 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-114-77.ams2.redhat.com [10.36.114.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 209A760BD8;
        Tue, 20 Jul 2021 08:44:58 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, toke@redhat.com
Subject: [PATCH net-next 1/5] veth: always report zero combined channels
Date:   Tue, 20 Jul 2021 10:41:48 +0200
Message-Id: <bcd1b935c04c220c0c7135a0a489e1bd34b8ad7e.1626768072.git.pabeni@redhat.com>
In-Reply-To: <cover.1626768072.git.pabeni@redhat.com>
References: <cover.1626768072.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

veth get_channel currently reports for channels being both RX/TX and
combined. As Jakub noted:

"""
ethtool man page is relatively clear, unfortunately the kernel code
is not and few read the man page. A channel is approximately an IRQ,
not a queue, and IRQ can't be dedicated and combined simultaneously
"""

This patch changes the information exposed by veth_get_channels,
setting max_combined to zero, being more consistent with the above
statement. The ethtool_channels is always cleared by the caller, we just
need to avoid setting the 'combined' fields.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 drivers/net/veth.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index bdb7ce3cb054..4b3e2617fdb5 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -226,8 +226,6 @@ static void veth_get_channels(struct net_device *dev,
 	channels->rx_count = dev->real_num_rx_queues;
 	channels->max_tx = dev->real_num_tx_queues;
 	channels->max_rx = dev->real_num_rx_queues;
-	channels->combined_count = min(dev->real_num_rx_queues, dev->real_num_tx_queues);
-	channels->max_combined = min(dev->real_num_rx_queues, dev->real_num_tx_queues);
 }
 
 static const struct ethtool_ops veth_ethtool_ops = {
-- 
2.26.3

