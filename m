Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B65486DD652
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 11:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbjDKJLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 05:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbjDKJK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 05:10:59 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709403C11
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 02:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681204250; x=1712740250;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JuaFGXBQo2eOm57w5hQz1C8qQlWDN2O+Id+2cSGIQu8=;
  b=Oscv4uCslY0i7vINrZJE9wu2buZPNnAnWU6vCeyvR7KdibqGJBWDqQox
   /0AfTETc0tZA5XfCn0oY8iqEr9QlgFMtsMY+N6Ftra2gFZ41SNz+cXB+t
   zuPcN2YzW8noFjiNqwSeaNC8WXotYqCtkBRjTAdc0TUT8hAs8GePL2Kvd
   gqoq+0wtG1uHJsC0l2evHa1JIJ5okN9eIHKIJgslEY6AxjqcONWk3YVwU
   NRjUu62hc1prp6i6pmGHBE6X/4b9Er6ctRKbdXPHPmcBBlTiR7s6yDcPy
   IAYjiWEUnb8DB1Pf/kZnz7mfa7Skl1+mb05RglrMpQCVjtS9IqiXDe7kd
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="327665010"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="327665010"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 02:10:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="682005212"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="682005212"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga007.jf.intel.com with ESMTP; 11 Apr 2023 02:10:46 -0700
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 4D30869A; Tue, 11 Apr 2023 12:10:49 +0300 (EEST)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Simon Horman <simon.horman@corigine.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        netdev@vger.kernel.org
Subject: [PATCH v2 2/3] net: thunderbolt: Fix sparse warnings in tbnet_xmit_csum_and_map()
Date:   Tue, 11 Apr 2023 12:10:48 +0300
Message-Id: <20230411091049.12998-3-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230411091049.12998-1-mika.westerberg@linux.intel.com>
References: <20230411091049.12998-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following warning when the driver is built with sparse checks
enabled:

main.c:993:23: warning: incorrect type in initializer (different base types)
main.c:993:23:    expected restricted __wsum [usertype] wsum
main.c:993:23:    got restricted __be32 [usertype]

No functional changes intended.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/thunderbolt/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/thunderbolt/main.c b/drivers/net/thunderbolt/main.c
index 27f8573a2b6e..6a43ced74881 100644
--- a/drivers/net/thunderbolt/main.c
+++ b/drivers/net/thunderbolt/main.c
@@ -991,8 +991,10 @@ static bool tbnet_xmit_csum_and_map(struct tbnet *net, struct sk_buff *skb,
 {
 	struct thunderbolt_ip_frame_header *hdr = page_address(frames[0]->page);
 	struct device *dma_dev = tb_ring_dma_device(net->tx_ring.ring);
-	__wsum wsum = htonl(skb->len - skb_transport_offset(skb));
 	unsigned int i, len, offset = skb_transport_offset(skb);
+	/* Remove payload length from checksum */
+	u32 paylen = skb->len - skb_transport_offset(skb);
+	__wsum wsum = (__force __wsum)htonl(paylen);
 	__be16 protocol = skb->protocol;
 	void *data = skb->data;
 	void *dest = hdr + 1;
-- 
2.39.2

