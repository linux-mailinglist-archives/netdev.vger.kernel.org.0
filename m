Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1245A0C3E
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 11:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237822AbiHYJIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 05:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238468AbiHYJIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 05:08:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94DB8991B
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 02:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661418481;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UdCiWiUwYniCuC1UtRJWnQ4XsbULdePHfNjb8vtiuwk=;
        b=P428IpDfFlqtAoB/RLisEFJ82VVMotZ3JGn0ySBpv8SsdtDi62XwmEwTZb0Hk2QNvxQkB1
        Ef0C/jEmZskOTjaj7vVFWCEapza9Zl4Yl5AYO/0qMd+kxjAfFqJVmOg723avrLCJ3Et5Ow
        pvqCRAu5G011+XY54Qr3u/0Bfncsy48=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-183-8eL3AO-iM36TOVVd8RdfkQ-1; Thu, 25 Aug 2022 05:07:58 -0400
X-MC-Unique: 8eL3AO-iM36TOVVd8RdfkQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D01DB8039A1;
        Thu, 25 Aug 2022 09:02:56 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB0F51121315;
        Thu, 25 Aug 2022 09:02:54 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
Subject: [PATCH net-next v3 1/3] sfc: allow more flexible way of adding filters for PTP
Date:   Thu, 25 Aug 2022 11:02:40 +0200
Message-Id: <20220825090242.12848-2-ihuguet@redhat.com>
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

In preparation for the support of PTP over IPv6/UDP and Ethernet in next
patches, allow a more flexible way of adding and removing RX filters for
PTP. Right now, only 2 filters are allowed, which are the ones needed
for PTP over IPv4/UDP.

Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/sfc/ptp.c | 67 ++++++++++++++++------------------
 1 file changed, 31 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index 10ad0b93d283..719005d79943 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -118,6 +118,8 @@
 
 #define	PTP_MIN_LENGTH		63
 
+#define PTP_RXFILTERS_LEN	2
+
 #define PTP_ADDRESS		0xe0000181	/* 224.0.1.129 */
 #define PTP_EVENT_PORT		319
 #define PTP_GENERAL_PORT	320
@@ -224,9 +226,8 @@ struct efx_ptp_timeset {
  * @work: Work task
  * @reset_required: A serious error has occurred and the PTP task needs to be
  *                  reset (disable, enable).
- * @rxfilter_event: Receive filter when operating
- * @rxfilter_general: Receive filter when operating
- * @rxfilter_installed: Receive filter installed
+ * @rxfilters: Receive filters when operating
+ * @rxfilters_count: Num of installed rxfilters, should be == PTP_RXFILTERS_LEN
  * @config: Current timestamp configuration
  * @enabled: PTP operation enabled
  * @mode: Mode in which PTP operating (PTP version)
@@ -295,9 +296,8 @@ struct efx_ptp_data {
 	struct workqueue_struct *workwq;
 	struct work_struct work;
 	bool reset_required;
-	u32 rxfilter_event;
-	u32 rxfilter_general;
-	bool rxfilter_installed;
+	u32 rxfilters[PTP_RXFILTERS_LEN];
+	size_t rxfilters_count;
 	struct hwtstamp_config config;
 	bool enabled;
 	unsigned int mode;
@@ -1290,61 +1290,56 @@ static void efx_ptp_remove_multicast_filters(struct efx_nic *efx)
 {
 	struct efx_ptp_data *ptp = efx->ptp_data;
 
-	if (ptp->rxfilter_installed) {
-		efx_filter_remove_id_safe(efx, EFX_FILTER_PRI_REQUIRED,
-					  ptp->rxfilter_general);
+	while (ptp->rxfilters_count) {
+		ptp->rxfilters_count--;
 		efx_filter_remove_id_safe(efx, EFX_FILTER_PRI_REQUIRED,
-					  ptp->rxfilter_event);
-		ptp->rxfilter_installed = false;
+					  ptp->rxfilters[ptp->rxfilters_count]);
 	}
 }
 
-static int efx_ptp_insert_multicast_filters(struct efx_nic *efx)
+static int efx_ptp_insert_ipv4_filter(struct efx_nic *efx, u16 port)
 {
 	struct efx_ptp_data *ptp = efx->ptp_data;
 	struct efx_filter_spec rxfilter;
 	int rc;
 
-	if (!ptp->channel || ptp->rxfilter_installed)
-		return 0;
-
-	/* Must filter on both event and general ports to ensure
-	 * that there is no packet re-ordering.
-	 */
 	efx_filter_init_rx(&rxfilter, EFX_FILTER_PRI_REQUIRED, 0,
 			   efx_rx_queue_index(
 				   efx_channel_get_rx_queue(ptp->channel)));
-	rc = efx_filter_set_ipv4_local(&rxfilter, IPPROTO_UDP,
-				       htonl(PTP_ADDRESS),
-				       htons(PTP_EVENT_PORT));
-	if (rc != 0)
-		return rc;
+
+	efx_filter_set_ipv4_local(&rxfilter, IPPROTO_UDP, htonl(PTP_ADDRESS),
+				  htons(port));
 
 	rc = efx_filter_insert_filter(efx, &rxfilter, true);
 	if (rc < 0)
 		return rc;
-	ptp->rxfilter_event = rc;
 
-	efx_filter_init_rx(&rxfilter, EFX_FILTER_PRI_REQUIRED, 0,
-			   efx_rx_queue_index(
-				   efx_channel_get_rx_queue(ptp->channel)));
-	rc = efx_filter_set_ipv4_local(&rxfilter, IPPROTO_UDP,
-				       htonl(PTP_ADDRESS),
-				       htons(PTP_GENERAL_PORT));
-	if (rc != 0)
+	ptp->rxfilters[ptp->rxfilters_count] = rc;
+	ptp->rxfilters_count++;
+
+	return 0;
+}
+
+static int efx_ptp_insert_multicast_filters(struct efx_nic *efx)
+{
+	struct efx_ptp_data *ptp = efx->ptp_data;
+	int rc;
+
+	if (!ptp->channel || ptp->rxfilters_count)
+		return 0;
+
+	rc = efx_ptp_insert_ipv4_filter(efx, PTP_EVENT_PORT);
+	if (rc < 0)
 		goto fail;
 
-	rc = efx_filter_insert_filter(efx, &rxfilter, true);
+	rc = efx_ptp_insert_ipv4_filter(efx, PTP_GENERAL_PORT);
 	if (rc < 0)
 		goto fail;
-	ptp->rxfilter_general = rc;
 
-	ptp->rxfilter_installed = true;
 	return 0;
 
 fail:
-	efx_filter_remove_id_safe(efx, EFX_FILTER_PRI_REQUIRED,
-				  ptp->rxfilter_event);
+	efx_ptp_remove_multicast_filters(efx);
 	return rc;
 }
 
-- 
2.34.1

