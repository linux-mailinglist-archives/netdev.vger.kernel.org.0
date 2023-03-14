Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBCA26B8F51
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 11:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbjCNKKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 06:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbjCNKK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 06:10:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2A0296F00
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 03:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678788579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=VBwMjUbEAjPiBrvG91FbVm6G6l1VXLdCxV/FCWDC8LM=;
        b=Se2kBtYKezVLIyZLO1ceF9NEORpvJ1QUY4+gMHMYiSrv/pPgGALjlEL/mNkZnn3A2yttRN
        uWWEv+2ccDwN2xKz/EK+NhD162rAI2zKRdJ9cFs+m+MO02yqQsnEedvIA1I4yCrKJbr4PH
        6ypi7fPEiLQyBqbU7Bz+txV2JC7xAEs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-571-KziswL9DO16DgowowPcwOQ-1; Tue, 14 Mar 2023 06:09:34 -0400
X-MC-Unique: KziswL9DO16DgowowPcwOQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 21AA185A5B1;
        Tue, 14 Mar 2023 10:09:34 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.146])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4B0D1492B00;
        Tue, 14 Mar 2023 10:09:32 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        richardcochran@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        Yalin Li <yalli@redhat.com>
Subject: [PATCH RESEND net-next v4 0/4] sfc: support unicast PTP
Date:   Tue, 14 Mar 2023 11:09:21 +0100
Message-Id: <20230314100925.12040-1-ihuguet@redhat.com>
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

Tested: With ptp4l, all combinations of IPv4/IPv6, master/slave and
unicast/multicast

Reported-by: Yalin Li <yalli@redhat.com>
Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>

v2:
 - fixed missing IS_ERR
 - added doc of missing fields in efx_ptp_rxfilter
v3:
 - dropped pointless static inline in source file
 - removed the now unused PTP_RXFILTERS_LEN
 - follow reverse xmas tree convention in xmit_skb_mc
 - pass expiry as argument to the insert_filter functions and keep returning an
   integer error code from them, and not pointers, as suggested by Martin
 - moved the unicast filters expiration check to the end of the worker function
   to avoid increasing TX latency, as suggested by Martin
 - added check to avoid inserting unicast filters when doing multicast PTP
v4:
 - fixed filter leak, catched by Edward

Íñigo Huguet (4):
  sfc: store PTP filters in a list
  sfc: allow insertion of filters for unicast PTP
  sfc: support unicast PTP
  sfc: remove expired unicast PTP filters

 drivers/net/ethernet/sfc/ptp.c | 272 +++++++++++++++++++++++++++------
 1 file changed, 223 insertions(+), 49 deletions(-)

--
2.34.3

