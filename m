Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE34523391
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 14:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242705AbiEKM7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 08:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242947AbiEKM7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 08:59:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 41571231CB1
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 05:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652273989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=3p27JUN6WexvgcQGehVpQLQ7l3ELWLXcUCUsIkEVgko=;
        b=OrAA0eXnnjxLe3Z9UwHKPTbEuVePWnu4TSFOplnGve3IoDDBnvRMHqtR7rRV5RJgwWF7DI
        jEhhhpVhZnQpcgwGECVoiE14pJg1tUh4NsUq7HVe11tmjP+yTuTgqPZQ8AzzyFqxfn/fTC
        lCgQzn0IonCKNr59erJp6eZmTzLKzJ4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-606-bG5JBxYDPyKfqsTQmVORwQ-1; Wed, 11 May 2022 08:59:48 -0400
X-MC-Unique: bG5JBxYDPyKfqsTQmVORwQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C92CB85A5A8;
        Wed, 11 May 2022 12:59:47 +0000 (UTC)
Received: from ihuguet-laptop.redhat.com (unknown [10.39.192.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A5A64438EE3;
        Wed, 11 May 2022 12:59:45 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        amaftei@solarflare.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
Subject: [PATCH net 0/2] sfc: fix some efx_separate_tx_channels errors
Date:   Wed, 11 May 2022 14:59:39 +0200
Message-Id: <20220511125941.55812-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches fix some errors that happens at NIC's probe when using the
modparam efx_separate_tx_channels. However, there are still some other
errors that prevent from using the NIC with that modparam and I haven't
been able to find the cause (see the 2nd patch).

Anyway, my opinion is that this parameter should be better removed: it
has been completely broken for years and no users have complained, so I
don't think it's used anywhere. Discussed this with Edward and he was of
the opinion that removing a modparam is problematic because it breaks
compatibility, but I still think it should because of the reason above.

Íñigo Huguet (2):
  sfc: fix wrong tx channel offset with efx_separate_tx_channels
  sfc: do not initialize non existing queues with
    efx_separate_tx_channels

 drivers/net/ethernet/sfc/efx_channels.c | 39 ++++++++++++-------------
 1 file changed, 18 insertions(+), 21 deletions(-)

-- 
2.34.1

