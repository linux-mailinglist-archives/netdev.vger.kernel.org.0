Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0D0958D651
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 11:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240497AbiHIJUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 05:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239439AbiHIJUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 05:20:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AF27EF43
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 02:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660036815;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yis1n3n+f6FcTDfsUECAwl/sX2SHdakns1Mq4yRm014=;
        b=AARSdmPwXzBHJQT4xZGLvKzFuRgWuBkkJ8OglLFS9SGQjad+n1r2zhxHBTVaoai1JmwtpJ
        vzS7vfIglo3M/9+xjd5Xg+UyBeFDu1bcpk95AFgam2J/R5s+GTwLMgPxDMbhI3jBxSKAli
        sP0GrHWZwArq8UMfunW57XwRakJjDB8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-82-cc5R7WrqORKRqVPEj0qFpw-1; Tue, 09 Aug 2022 05:20:14 -0400
X-MC-Unique: cc5R7WrqORKRqVPEj0qFpw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2440A8037B3;
        Tue,  9 Aug 2022 09:20:14 +0000 (UTC)
Received: from ihuguet-laptop.redhat.com (unknown [10.39.193.75])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1902340C1288;
        Tue,  9 Aug 2022 09:20:11 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
Subject: [PATCH net-next 2/3] sfc: support PTP over IPv6/UDP
Date:   Tue,  9 Aug 2022 11:20:01 +0200
Message-Id: <20220809092002.17571-3-ihuguet@redhat.com>
In-Reply-To: <20220809092002.17571-1-ihuguet@redhat.com>
References: <20220809092002.17571-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit bd4a2697e5e2 ("sfc: use hardware tx timestamps for more than
PTP") added support for hardware timestamping on TX for cards of the
8000 series and newer, in an effort to provide support for other
transports other than IPv4/UDP.

However, timestamping was still not working on RX for these other
transports. This patch add support for PTP over IPv6/UDP.

Tested: sync as master and as slave is correct using ptp4l from linuxptp
package, both with IPv4 and IPv6.

Suggested-by: Edward Cree <ecree.xilinx@gmail.com>
Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/sfc/filter.h | 22 +++++++++++
 drivers/net/ethernet/sfc/ptp.c    | 61 ++++++++++++++++++++++++-------
 2 files changed, 69 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/sfc/filter.h b/drivers/net/ethernet/sfc/filter.h
index 4d928839d292..be72e71da027 100644
--- a/drivers/net/ethernet/sfc/filter.h
+++ b/drivers/net/ethernet/sfc/filter.h
@@ -9,6 +9,7 @@
 
 #include <linux/types.h>
 #include <linux/if_ether.h>
+#include <linux/in6.h>
 #include <asm/byteorder.h>
 
 /**
@@ -223,6 +224,27 @@ efx_filter_set_ipv4_local(struct efx_filter_spec *spec, u8 proto,
 	return 0;
 }
 
+/**
+ * efx_filter_set_ipv6_local - specify IPv6 host, transport protocol and port
+ * @spec: Specification to initialise
+ * @proto: Transport layer protocol number
+ * @host: Local host address (network byte order)
+ * @port: Local port (network byte order)
+ */
+static inline int
+efx_filter_set_ipv6_local(struct efx_filter_spec *spec, u8 proto,
+			  const struct in6_addr *host, __be16 port)
+{
+	spec->match_flags |=
+		EFX_FILTER_MATCH_ETHER_TYPE | EFX_FILTER_MATCH_IP_PROTO |
+		EFX_FILTER_MATCH_LOC_HOST | EFX_FILTER_MATCH_LOC_PORT;
+	spec->ether_type = htons(ETH_P_IPV6);
+	spec->ip_proto = proto;
+	memcpy(spec->loc_host, host, sizeof(spec->loc_host));
+	spec->loc_port = port;
+	return 0;
+}
+
 /**
  * efx_filter_set_ipv4_full - specify IPv4 hosts, transport protocol and ports
  * @spec: Specification to initialise
diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index bdf6c09cfac5..1e6a70fce77a 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -118,9 +118,11 @@
 
 #define	PTP_MIN_LENGTH		63
 
-#define PTP_RXFILTERS_LEN	2
+#define PTP_RXFILTERS_LEN	4
 
-#define PTP_ADDRESS		htonl(0xe0000181)	/* 224.0.1.129 */
+#define PTP_ADDR_IPV4		htonl(0xe0000181)	/* 224.0.1.129 */
+#define PTP_ADDR_IPV6		{0xff, 0x0e, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, \
+				0, 0x01, 0x81}		/* ff0e::181 */
 #define PTP_EVENT_PORT		htons(319)
 #define PTP_GENERAL_PORT	htons(320)
 
@@ -1297,28 +1299,46 @@ static void efx_ptp_remove_multicast_filters(struct efx_nic *efx)
 	}
 }
 
-static int efx_ptp_insert_ipv4_filter(struct efx_nic *efx, __be16 port)
+static inline void efx_ptp_init_filter(struct efx_nic *efx,
+				       struct efx_filter_spec *rxfilter)
 {
-	struct efx_ptp_data *ptp = efx->ptp_data;
-	struct efx_filter_spec rxfilter;
-	int rc;
-
-	efx_filter_init_rx(&rxfilter, EFX_FILTER_PRI_REQUIRED, 0,
-			   efx_rx_queue_index(
-				   efx_channel_get_rx_queue(ptp->channel)));
+	efx_filter_init_rx(rxfilter, EFX_FILTER_PRI_REQUIRED, 0,
+			   efx_rx_queue_index(efx_channel_get_rx_queue(
+					      efx->ptp_data->channel)));
+}
 
-	efx_filter_set_ipv4_local(&rxfilter, IPPROTO_UDP, PTP_ADDRESS, port);
+static inline int efx_ptp_insert_filter(struct efx_nic *efx,
+					struct efx_filter_spec *rxfilter)
+{
+	struct efx_ptp_data *ptp = efx->ptp_data;
 
-	rc = efx_filter_insert_filter(efx, &rxfilter, true);
+	int rc = efx_filter_insert_filter(efx, rxfilter, true);
 	if (rc < 0)
 		return rc;
-
 	ptp->rxfilters[ptp->rxfilters_count] = rc;
 	ptp->rxfilters_count++;
-
 	return 0;
 }
 
+static int efx_ptp_insert_ipv4_filter(struct efx_nic *efx, __be16 port)
+{
+	struct efx_filter_spec rxfilter;
+
+	efx_ptp_init_filter(efx, &rxfilter);
+	efx_filter_set_ipv4_local(&rxfilter, IPPROTO_UDP, PTP_ADDR_IPV4, port);
+	return efx_ptp_insert_filter(efx, &rxfilter);
+}
+
+static int efx_ptp_insert_ipv6_filter(struct efx_nic *efx, __be16 port)
+{
+	const struct in6_addr addr = {{PTP_ADDR_IPV6}};
+	struct efx_filter_spec rxfilter;
+
+	efx_ptp_init_filter(efx, &rxfilter);
+	efx_filter_set_ipv6_local(&rxfilter, IPPROTO_UDP, &addr, port);
+	return efx_ptp_insert_filter(efx, &rxfilter);
+}
+
 static int efx_ptp_insert_multicast_filters(struct efx_nic *efx)
 {
 	struct efx_ptp_data *ptp = efx->ptp_data;
@@ -1335,6 +1355,19 @@ static int efx_ptp_insert_multicast_filters(struct efx_nic *efx)
 	if (rc < 0)
 		goto fail;
 
+	/* if the NIC supports hw timestamps by the MAC, we can support
+	 * PTP over IPv6
+	 */
+	if (efx_ptp_use_mac_tx_timestamps(efx)) {
+		rc = efx_ptp_insert_ipv6_filter(efx, PTP_EVENT_PORT);
+		if (rc < 0)
+			goto fail;
+
+		rc = efx_ptp_insert_ipv6_filter(efx, PTP_GENERAL_PORT);
+		if (rc < 0)
+			goto fail;
+	}
+
 	return 0;
 
 fail:
-- 
2.34.1

