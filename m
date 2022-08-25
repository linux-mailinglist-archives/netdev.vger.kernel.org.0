Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6C65A0C34
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 11:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237971AbiHYJDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 05:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237877AbiHYJDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 05:03:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90341A98DC
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 02:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661418185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=snNkElZ51Lx4FApy/R/SlDLQ/7X/K5wKYP2ueBUfxrA=;
        b=LyGWnAOj5/fls/SqUV3tQFl52p5VIkCcEVYrW8Z7kdGd1h5HR5xMfkptljwrFRSru6MPNM
        RO0UE6rCyYwYMyU+IGlE0InhhN/K4VaavEeRhMh4aecJpC3/SsnExQuUl3ON2I7mErS5hv
        Wt7b63DrRO6sXaAfaSRQsudX0LtHZqA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-451-d1-dmNJ8PKCfLkwVDTXU2w-1; Thu, 25 Aug 2022 05:02:59 -0400
X-MC-Unique: d1-dmNJ8PKCfLkwVDTXU2w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4DAE48037AA;
        Thu, 25 Aug 2022 09:02:59 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 553D01121315;
        Thu, 25 Aug 2022 09:02:57 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
Subject: [PATCH net-next v3 2/3] sfc: support PTP over IPv6/UDP
Date:   Thu, 25 Aug 2022 11:02:41 +0200
Message-Id: <20220825090242.12848-3-ihuguet@redhat.com>
In-Reply-To: <20220825090242.12848-1-ihuguet@redhat.com>
References: <20220819082001.15439-1-ihuguet@redhat.com>
 <20220825090242.12848-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
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
 drivers/net/ethernet/sfc/ptp.c    | 63 ++++++++++++++++++++++++-------
 2 files changed, 71 insertions(+), 14 deletions(-)

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
index 719005d79943..060525ac2baf 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -118,9 +118,11 @@
 
 #define	PTP_MIN_LENGTH		63
 
-#define PTP_RXFILTERS_LEN	2
+#define PTP_RXFILTERS_LEN	4
 
-#define PTP_ADDRESS		0xe0000181	/* 224.0.1.129 */
+#define PTP_ADDR_IPV4		0xe0000181	/* 224.0.1.129 */
+#define PTP_ADDR_IPV6		{0xff, 0x0e, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, \
+				0, 0x01, 0x81}	/* ff0e::181 */
 #define PTP_EVENT_PORT		319
 #define PTP_GENERAL_PORT	320
 
@@ -1297,29 +1299,49 @@ static void efx_ptp_remove_multicast_filters(struct efx_nic *efx)
 	}
 }
 
-static int efx_ptp_insert_ipv4_filter(struct efx_nic *efx, u16 port)
+static inline void efx_ptp_init_filter(struct efx_nic *efx,
+				       struct efx_filter_spec *rxfilter)
 {
-	struct efx_ptp_data *ptp = efx->ptp_data;
-	struct efx_filter_spec rxfilter;
-	int rc;
+	struct efx_channel *channel = efx->ptp_data->channel;
+	struct efx_rx_queue *queue = efx_channel_get_rx_queue(channel);
 
-	efx_filter_init_rx(&rxfilter, EFX_FILTER_PRI_REQUIRED, 0,
-			   efx_rx_queue_index(
-				   efx_channel_get_rx_queue(ptp->channel)));
+	efx_filter_init_rx(rxfilter, EFX_FILTER_PRI_REQUIRED, 0,
+			   efx_rx_queue_index(queue));
+}
 
-	efx_filter_set_ipv4_local(&rxfilter, IPPROTO_UDP, htonl(PTP_ADDRESS),
-				  htons(port));
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
 
+static int efx_ptp_insert_ipv4_filter(struct efx_nic *efx, u16 port)
+{
+	struct efx_filter_spec rxfilter;
+
+	efx_ptp_init_filter(efx, &rxfilter);
+	efx_filter_set_ipv4_local(&rxfilter, IPPROTO_UDP, htonl(PTP_ADDR_IPV4),
+				  htons(port));
+	return efx_ptp_insert_filter(efx, &rxfilter);
+}
+
+static int efx_ptp_insert_ipv6_filter(struct efx_nic *efx, u16 port)
+{
+	const struct in6_addr addr = {{PTP_ADDR_IPV6}};
+	struct efx_filter_spec rxfilter;
+
+	efx_ptp_init_filter(efx, &rxfilter);
+	efx_filter_set_ipv6_local(&rxfilter, IPPROTO_UDP, &addr, htons(port));
+	return efx_ptp_insert_filter(efx, &rxfilter);
+}
+
 static int efx_ptp_insert_multicast_filters(struct efx_nic *efx)
 {
 	struct efx_ptp_data *ptp = efx->ptp_data;
@@ -1336,6 +1358,19 @@ static int efx_ptp_insert_multicast_filters(struct efx_nic *efx)
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

