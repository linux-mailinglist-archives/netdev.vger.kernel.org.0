Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 975D3520FE8
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 10:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238173AbiEJItE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 04:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232706AbiEJItB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 04:49:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 16FB42A28DF
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 01:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652172303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o0lRJEI5xRVDCzoq7NyFraR7DjcCFB8ST4qUSGCXOLk=;
        b=F9x3N0FfbCWCAIzyri2K36E1OVPbN5kyipAd93sDfHI9WlmP+HISlN9RawjyG+9fcYNuQF
        QSmvbY/LmaM5ZMJsgCE+oXEKURq3bq6alSBB03q/TuKpPY5qUk4I0YKk7dybmgnya4ZbXY
        mlJ1pzoIgQnvkFV087IxOn+HU5pw+Xs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-618-KEemUh1rO422wjobinvFmA-1; Tue, 10 May 2022 04:44:59 -0400
X-MC-Unique: KEemUh1rO422wjobinvFmA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8FC6D185A7BA;
        Tue, 10 May 2022 08:44:58 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E9240413721;
        Tue, 10 May 2022 08:44:56 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        ap420073@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
Subject: [PATCH net-next 1/5] sfc: add new helper macros to iterate channels by type
Date:   Tue, 10 May 2022 10:44:39 +0200
Message-Id: <20220510084443.14473-2-ihuguet@redhat.com>
In-Reply-To: <20220510084443.14473-1-ihuguet@redhat.com>
References: <20220510084443.14473-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sometimes in the driver it's needed to iterate a subset of the channels
depending on whether it is an rx, tx or xdp channel. Now it's done
iterating over all channels and checking if it's of the desired type,
leading to too much nested and a bit complex to understand code.

Add new iterator macros to allow iterating only over a single type of
channel.

Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/sfc/net_driver.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 318db906a154..7f665ba6a082 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -1501,6 +1501,27 @@ efx_get_channel(struct efx_nic *efx, unsigned index)
 	     _channel = (_channel->channel + 1 < (_efx)->n_channels) ?	\
 		     (_efx)->channel[_channel->channel + 1] : NULL)
 
+#define efx_for_each_rx_channel(_channel, _efx)				    \
+	for (_channel = (_efx)->channel[0];				    \
+	     _channel;							    \
+	     _channel = (_channel->channel + 1 < (_efx)->n_rx_channels) ?   \
+		     (_efx)->channel[_channel->channel + 1] : NULL)
+
+#define efx_for_each_tx_channel(_channel, _efx)				    \
+	for (_channel = (_efx)->channel[efx->tx_channel_offset];	    \
+	     _channel;							    \
+	     _channel = (_channel->channel + 1 <			    \
+		     (_efx)->tx_channel_offset + (_efx)->n_tx_channels) ?   \
+		     (_efx)->channel[_channel->channel + 1] : NULL)
+
+#define efx_for_each_xdp_channel(_channel, _efx)			    \
+	for (_channel = ((_efx)->n_xdp_channels > 0) ?			    \
+		     (_efx)->channel[efx->xdp_channel_offset] : NULL;	    \
+	     _channel;							    \
+	     _channel = (_channel->channel + 1 <			    \
+		     (_efx)->xdp_channel_offset + (_efx)->n_xdp_channels) ? \
+		     (_efx)->channel[_channel->channel + 1] : NULL)
+
 /* Iterate over all used channels in reverse */
 #define efx_for_each_channel_rev(_channel, _efx)			\
 	for (_channel = (_efx)->channel[(_efx)->n_channels - 1];	\
-- 
2.34.1

