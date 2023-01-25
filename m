Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39CAB67B4D9
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 15:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235857AbjAYOh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 09:37:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235860AbjAYOhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 09:37:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B3A859B50
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 06:35:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674657331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Zh+6gmQc2OcM2p0vunj0fWhO4siNVxvMbbYRdrPo12M=;
        b=Sj+HFQliWee9BhVbOiYKHREP3cvozB2xRcpHuXRWhaNb/kRp+61fosLTI+F3ITL3vyan0M
        317glZy4APVP0wvO7WZsF4zBe+zu797yDvcoxpBrASjcToVgnPoXsRJf1RYEYj3qqekgTG
        xzxlfL1P7cgOiqbn7SlSOiq8exYhLds=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-HbjLZs0-PZeedEkEPwS7QA-1; Wed, 25 Jan 2023 09:35:26 -0500
X-MC-Unique: HbjLZs0-PZeedEkEPwS7QA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A0A9857F41;
        Wed, 25 Jan 2023 14:35:25 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.195.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BFF052026D4B;
        Wed, 25 Jan 2023 14:35:23 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        Tianhao Zhao <tizhao@redhat.com>
Subject: [PATCH net] sfc: correctly advertise tunneled IPv6 segmentation
Date:   Wed, 25 Jan 2023 15:35:13 +0100
Message-Id: <20230125143513.25841-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recent sfc NICs are TSO capable for some tunnel protocols. However, it
was not working properly because the feature was not advertised in
hw_enc_features, but in hw_features only.

Setting up a GENEVE tunnel and using iperf3 to send IPv4 and IPv6 traffic
to the tunnel show, with tcpdump, that the IPv4 packets still had ~64k
size but the IPv6 ones had only ~1500 bytes (they had been segmented by
software, not offloaded). With this patch segmentation is offloaded as
expected and the traffic is correctly received at the other end.

Fixes: 24b2c3751aa3 ("sfc: advertise encapsulated offloads on EF10")
Reported-by: Tianhao Zhao <tizhao@redhat.com>
Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/sfc/efx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 0556542d7a6b..3a86f1213a05 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1003,8 +1003,11 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	/* Determine netdevice features */
 	net_dev->features |= (efx->type->offload_features | NETIF_F_SG |
 			      NETIF_F_TSO | NETIF_F_RXCSUM | NETIF_F_RXALL);
-	if (efx->type->offload_features & (NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM))
+	if (efx->type->offload_features & (NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM)) {
 		net_dev->features |= NETIF_F_TSO6;
+		if (efx_has_cap(efx, TX_TSO_V2_ENCAP))
+			net_dev->hw_enc_features |= NETIF_F_TSO6;
+	}
 	/* Check whether device supports TSO */
 	if (!efx->type->tso_versions || !efx->type->tso_versions(efx))
 		net_dev->features &= ~NETIF_F_ALL_TSO;
-- 
2.34.3

