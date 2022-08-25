Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C14835A0C33
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 11:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238113AbiHYJDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 05:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237877AbiHYJDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 05:03:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5719A9268
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 02:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661418188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kz4hrITH885Cs6zefZmLfK9I9mhYf/GPXkZarsfBngk=;
        b=cJOU7KI65O3p+nTK0hy4tEYgO/lLuxfZsgH+QnTkVZik1unPevoMzIECsReATc1T3UWDUv
        RrzyJ6BBgITUhJQ8WkhNb335nbgjJJayk1HeWT7OIf7xdNj5+fZ5QI8zWOj/hgNZx4qYlq
        oaYzoGzrbq23Spgr++J6oUwcahdwF0Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-ugPwdKuFOaap44MecucDbg-1; Thu, 25 Aug 2022 05:03:02 -0400
X-MC-Unique: ugPwdKuFOaap44MecucDbg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8A6638037AA;
        Thu, 25 Aug 2022 09:03:01 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E0261121319;
        Thu, 25 Aug 2022 09:02:59 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
Subject: [PATCH net-next v3 3/3] sfc: support PTP over Ethernet
Date:   Thu, 25 Aug 2022 11:02:42 +0200
Message-Id: <20220825090242.12848-4-ihuguet@redhat.com>
In-Reply-To: <20220825090242.12848-1-ihuguet@redhat.com>
References: <20220819082001.15439-1-ihuguet@redhat.com>
 <20220825090242.12848-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous patch add support for PTP over IPv6/UDP (only for 8000
series and newer) and this one add support for PTP over 802.3.

Tested: sync as master and as slave is correct with ptp4l. PTP over IPv4
and IPv6 still works fine.

Suggested-by: Edward Cree <ecree.xilinx@gmail.com>
Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/sfc/ptp.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index 060525ac2baf..9547b2e4f7f3 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -118,13 +118,14 @@
 
 #define	PTP_MIN_LENGTH		63
 
-#define PTP_RXFILTERS_LEN	4
+#define PTP_RXFILTERS_LEN	5
 
 #define PTP_ADDR_IPV4		0xe0000181	/* 224.0.1.129 */
 #define PTP_ADDR_IPV6		{0xff, 0x0e, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, \
 				0, 0x01, 0x81}	/* ff0e::181 */
 #define PTP_EVENT_PORT		319
 #define PTP_GENERAL_PORT	320
+#define PTP_ADDR_ETHER		{0x01, 0x1b, 0x19, 0, 0, 0} /* 01-1B-19-00-00-00 */
 
 /* Annoyingly the format of the version numbers are different between
  * versions 1 and 2 so it isn't possible to simply look for 1 or 2.
@@ -1342,6 +1343,18 @@ static int efx_ptp_insert_ipv6_filter(struct efx_nic *efx, u16 port)
 	return efx_ptp_insert_filter(efx, &rxfilter);
 }
 
+static int efx_ptp_insert_eth_filter(struct efx_nic *efx)
+{
+	const u8 addr[ETH_ALEN] = PTP_ADDR_ETHER;
+	struct efx_filter_spec rxfilter;
+
+	efx_ptp_init_filter(efx, &rxfilter);
+	efx_filter_set_eth_local(&rxfilter, EFX_FILTER_VID_UNSPEC, addr);
+	rxfilter.match_flags |= EFX_FILTER_MATCH_ETHER_TYPE;
+	rxfilter.ether_type = htons(ETH_P_1588);
+	return efx_ptp_insert_filter(efx, &rxfilter);
+}
+
 static int efx_ptp_insert_multicast_filters(struct efx_nic *efx)
 {
 	struct efx_ptp_data *ptp = efx->ptp_data;
@@ -1359,7 +1372,7 @@ static int efx_ptp_insert_multicast_filters(struct efx_nic *efx)
 		goto fail;
 
 	/* if the NIC supports hw timestamps by the MAC, we can support
-	 * PTP over IPv6
+	 * PTP over IPv6 and Ethernet
 	 */
 	if (efx_ptp_use_mac_tx_timestamps(efx)) {
 		rc = efx_ptp_insert_ipv6_filter(efx, PTP_EVENT_PORT);
@@ -1369,6 +1382,10 @@ static int efx_ptp_insert_multicast_filters(struct efx_nic *efx)
 		rc = efx_ptp_insert_ipv6_filter(efx, PTP_GENERAL_PORT);
 		if (rc < 0)
 			goto fail;
+
+		rc = efx_ptp_insert_eth_filter(efx);
+		if (rc < 0)
+			goto fail;
 	}
 
 	return 0;
-- 
2.34.1

