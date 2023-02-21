Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C35A69E0D4
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 13:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232894AbjBUMxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 07:53:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232874AbjBUMxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 07:53:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3278926CF0
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 04:52:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676983966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=VBwMjUbEAjPiBrvG91FbVm6G6l1VXLdCxV/FCWDC8LM=;
        b=RywR00PzuIe93b9HW32oxZTpU6DWAIQQM49BrFe5Dn968XrRgCMxEJ+5pRdlG6IQ6xXkwc
        0H5q6oj+ig29C0tMLBKabZYhzft5+X5qRjhJNzvyGkI6tP4f2YnPPvyzOjn+Dh0Rk08YEv
        pAutTg6TdHU9xV8BdkfPorE+IF6Y1pk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-223-K39kThHSNdiAOsR2E9E6qQ-1; Tue, 21 Feb 2023 07:52:42 -0500
X-MC-Unique: K39kThHSNdiAOsR2E9E6qQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D2673101A521;
        Tue, 21 Feb 2023 12:52:41 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.194.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 19FA3492B05;
        Tue, 21 Feb 2023 12:52:39 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com,
        netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        Yalin Li <yalli@redhat.com>
Subject: [PATCH net-next v4 0/4] sfc: support unicast PTP
Date:   Tue, 21 Feb 2023 13:52:13 +0100
Message-Id: <20230221125217.20775-1-ihuguet@redhat.com>
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

