Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 978CD683232
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 17:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbjAaQGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 11:06:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbjAaQGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 11:06:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0CC53AA1
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 08:05:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675181121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=kGIijiVB4uyLhC/H22+oqSs4zez7W+36IvkdXRIWV1E=;
        b=VbEQ80+OkIsLG5DQWkXL3LakDfJnTVuQxTvb0ND1Q6/GaJfB6O7LRAsLBEbGK2jSnz8vLq
        IZyN5zncHwQVgAbLFIMntgbes/Db6EX3Ud+0mdz/daBn/kiSHIYaG2OQBtNluWWpCGuiit
        wulgt6i0q4/xqmA+PrQYJWB9BjEL6VM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-580-J2wRow3_Pua3urGrD4Rqdg-1; Tue, 31 Jan 2023 11:05:18 -0500
X-MC-Unique: J2wRow3_Pua3urGrD4Rqdg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D622D3C42206;
        Tue, 31 Jan 2023 16:05:16 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.136])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F04ED492B05;
        Tue, 31 Jan 2023 16:05:14 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        richardcochran@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        Yalin Li <yalli@redhat.com>
Subject: [PATCH net 0/4] sfc: support unicast PTP
Date:   Tue, 31 Jan 2023 17:05:02 +0100
Message-Id: <20230131160506.47552-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unicast PTP was not working with sfc NICs.

The reason was that these NICs don't timestamp all incoming packets,
but instead they only timestamp packets of the queues that are selected
for that. Currently, only one RX queue is configured for timestamp: the
RX queue of the PTP channel. The packets that are put in the PTP RX
queue are selected according to firmware filters configured from the
driver.

Multicast PTP was already working because the needed filters are known
in advance, so they're inserted when PTP is enabled. This patches
add the ability to dynamically add filters for unicast addresses,
extracted from the TX PTP-event packets.

Since we don't know in advance how many filters we'll need, some info
about the filters need to be saved. This will allow to check if a filter
already exists or if a filter is too old and should be removed.

Note that the previous point is unnecessary for multicast filters, but
I've opted to change how they're handled to match the new unicast's
filters to avoid having duplicate insert/remove_filters functions,
once for each type of filter.

Tested: With ptp4l, all combinations of master/slave and unicast/multicast
Reported-by: Yalin Li <yalli@redhat.com>
Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>

Íñigo Huguet (4):
  sfc: store PTP filters in a list
  sfc: allow insertion of filters for unicast PTP
  sfc: support unicast PTP
  sfc: remove expired unicast PTP filters

 drivers/net/ethernet/sfc/ptp.c | 272 ++++++++++++++++++++++++++-------
 1 file changed, 217 insertions(+), 55 deletions(-)

--
2.34.3

