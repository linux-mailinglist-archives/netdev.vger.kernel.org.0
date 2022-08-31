Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4F475A7B29
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 12:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbiHaKQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 06:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiHaKQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 06:16:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D9C2229A
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 03:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661941005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yK9JZgh1xNOu5DllYy/hGdGwd05Pmel/GEBjn1wEKYw=;
        b=EUzqUDdusNpzIfJT4mCDZasY8VZZhhygsVi+h8Rkct6OvjLFy+GUN9R92gMXZgVNozD6sL
        U01FFiZEQKIE3SwXdI2yqeonApt4UaFlBN1Y1PNALHmj/3U/8w2Fk+BuOx+UAQZsZR6yD5
        JM6Tudn/vVZq0M1DJScZ3rpzTNncJr8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-645-Q2IbwuLuNQKHJtlVfNHVyg-1; Wed, 31 Aug 2022 06:16:42 -0400
X-MC-Unique: Q2IbwuLuNQKHJtlVfNHVyg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 79AC380418F;
        Wed, 31 Aug 2022 10:16:41 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.194.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C75AC2026D4C;
        Wed, 31 Aug 2022 10:16:38 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        richardcochran@gmail.com,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
Subject: [PATCH net-next v4 0/3] sfc: add support for PTP over IPv6 and 802.3
Date:   Wed, 31 Aug 2022 12:16:28 +0200
Message-Id: <20220831101631.13585-1-ihuguet@redhat.com>
In-Reply-To: <20220825090242.12848-1-ihuguet@redhat.com>
References: <20220825090242.12848-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most recent cards (8000 series and newer) had enough hardware support
for this, but it was not enabled in the driver. The transmission of PTP
packets over these protocols was already added in commit bd4a2697e5e2
("sfc: use hardware tx timestamps for more than PTP"), but receiving
them was already unsupported so synchronization didn't happen.

These patches add support for timestamping received packets over
IPv6/UPD and IEEE802.3.

v2: fixed weird indentation in efx_ptp_init_filter
v3: fixed bug caused by usage of htons in PTP_EVENT_PORT definition.
    It was used in more places, where htons was used too, so using it
    2 times leave it again in host order. I didn't detected it in my
    tests because it only affected if timestamping through the MC, but
    the model I used do it through the MAC. Detected by kernel test
    robot <lkp@intel.com>
v4: removed `inline` specifiers from 2 local functions

Íñigo Huguet (3):
  sfc: allow more flexible way of adding filters for PTP
  sfc: support PTP over IPv6/UDP
  sfc: support PTP over Ethernet

 drivers/net/ethernet/sfc/filter.h |  22 +++++
 drivers/net/ethernet/sfc/ptp.c    | 131 ++++++++++++++++++++----------
 2 files changed, 111 insertions(+), 42 deletions(-)

-- 
2.34.1

