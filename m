Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C27495391F1
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 15:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243995AbiEaNkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 09:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243734AbiEaNku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 09:40:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4983B49F85
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 06:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654004448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rnjHCoXkxaIVJAArYuM4FowDPfP67GElwgqRDadry7c=;
        b=bb9CMM0ne0HlhswxBV+XaYahramIzCjDUNi3X85b9Yy4Hq5MsnRhMGH/oV6CtGOCMs9YNa
        DCU4R+Ukwr4GQcQr5lJY9R4ZaWsiPwgnD3axcrVQo/RGgmXgysTzAr7Y2mbJ18u0W0Vczl
        kanpSJMKy2mrZjIyJTTgpiDd6oxfjoA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-119-lGiL0nNbOLKxd5t3bILm5Q-1; Tue, 31 May 2022 09:40:43 -0400
X-MC-Unique: lGiL0nNbOLKxd5t3bILm5Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A6A73811E7A;
        Tue, 31 May 2022 13:40:42 +0000 (UTC)
Received: from ihuguet-laptop.redhat.com (unknown [10.39.195.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 64C8240885A1;
        Tue, 31 May 2022 13:40:40 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, cmclachlan@solarflare.com, brouer@redhat.com,
        netdev@vger.kernel.org, Tianhao Zhao <tizhao@redhat.com>,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
Subject: [PATCH net 1/2] sfc/siena: fix considering that all channels have TX queues
Date:   Tue, 31 May 2022 15:40:33 +0200
Message-Id: <20220531134034.389792-2-ihuguet@redhat.com>
In-Reply-To: <20220531134034.389792-1-ihuguet@redhat.com>
References: <20220531134034.389792-1-ihuguet@redhat.com>
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

From: Martin Habets <habetsm.xilinx@gmail.com>

Normally, all channels have RX and TX queues, but this is not true if
modparam efx_separate_tx_channels=1 is used. In that cases, some
channels only have RX queues and others only TX queues (or more
preciselly, they have them allocated, but not initialized).

Fix efx_channel_has_tx_queues to return the correct value for this case
too.

This has been already done for sfc, do it also for sfc_siena.

Messages shown at probe time before the fix:
 sfc 0000:03:00.0 ens6f0np0: MC command 0x82 inlen 544 failed rc=-22 (raw=0) arg=0
 ------------[ cut here ]------------
 netdevice: ens6f0np0: failed to initialise TXQ -1
 WARNING: CPU: 1 PID: 626 at drivers/net/ethernet/sfc/ef10.c:2393 efx_ef10_tx_init+0x201/0x300 [sfc]
 [...] stripped
 RIP: 0010:efx_ef10_tx_init+0x201/0x300 [sfc]
 [...] stripped
 Call Trace:
  efx_init_tx_queue+0xaa/0xf0 [sfc]
  efx_start_channels+0x49/0x120 [sfc]
  efx_start_all+0x1f8/0x430 [sfc]
  efx_net_open+0x5a/0xe0 [sfc]
  __dev_open+0xd0/0x190
  __dev_change_flags+0x1b3/0x220
  dev_change_flags+0x21/0x60
 [...] stripped

Messages shown at remove time before the fix:
 sfc 0000:03:00.0 ens6f0np0: failed to flush 10 queues
 sfc 0000:03:00.0 ens6f0np0: failed to flush queues

Fixes: 8700aff08984 ("sfc: fix channel allocation with brute force")
Reported-by: Tianhao Zhao <tizhao@redhat.com>
Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
Tested-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/sfc/net_driver.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/siena/net_driver.h b/drivers/net/ethernet/sfc/siena/net_driver.h
index 318db906a154..723bbeea5d0c 100644
--- a/drivers/net/ethernet/sfc/siena/net_driver.h
+++ b/drivers/net/ethernet/sfc/siena/net_driver.h
@@ -1530,7 +1530,7 @@ static inline bool efx_channel_is_xdp_tx(struct efx_channel *channel)
 
 static inline bool efx_channel_has_tx_queues(struct efx_channel *channel)
 {
-	return true;
+	return channel && channel->channel >= channel->efx->tx_channel_offset;
 }
 
 static inline unsigned int efx_channel_num_tx_queues(struct efx_channel *channel)
-- 
2.34.1

