Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43F426D1ED1
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 13:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbjCaLPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 07:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbjCaLPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 07:15:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83FC768C
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 04:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680261256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=/lpFBmgTnTC5mRvHi9o6vh05ejz1edVAQrw5kTK7wbA=;
        b=LB7lLpuE1rZ5Y7FteA5JI/3A8Q6KgpEXo3/qlcckfHlJLiVLJgTE5+YxgsQ1raD33N4wU/
        hpiw/axKqzXhDd54weUv8l71xbpqCbT+Ht+3Dys9SSpbuZNNNLeRO34W7dFyulabJuUjaN
        7iQyFgglcaHsHy3SNlUJFJpaZgHbFLs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-vSP39KKHP6uEomE8JBTS-g-1; Fri, 31 Mar 2023 07:14:13 -0400
X-MC-Unique: vSP39KKHP6uEomE8JBTS-g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0FB2E382C96C;
        Fri, 31 Mar 2023 11:14:13 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.194.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5928C40B3ED9;
        Fri, 31 Mar 2023 11:14:11 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com,
        netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        Yalin Li <yalli@redhat.com>
Subject: [PATCH v6 net-next 0/4] sfc: support unicast PTP
Date:   Fri, 31 Mar 2023 13:14:00 +0200
Message-Id: <20230331111404.17256-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
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
v5: per Edward's suggestions:
 - moved local variable declaration from patch 4 to patch 2
 - changed argument variable names ptp_list for more descriptive filter_list
 - don't remove unicast filter if one insertion fails: they're still valid
 - run unicast filters cleanup in dedicated work every 30s if there are active
   filters. This avoid having to check for expiration on every PTP TX packet. It
   also allows to cleanup the filters if PTP operations have stopped.
v6:
 - added missing kdoc for work_cleanup
 - added missing +1 in queue_delayed_work delay argument

Íñigo Huguet (4):
  sfc: store PTP filters in a list
  sfc: allow insertion of filters for unicast PTP
  sfc: support unicast PTP
  sfc: remove expired unicast PTP filters

 drivers/net/ethernet/sfc/ptp.c | 274 +++++++++++++++++++++++++++------
 1 file changed, 226 insertions(+), 48 deletions(-)

--
2.39.2

