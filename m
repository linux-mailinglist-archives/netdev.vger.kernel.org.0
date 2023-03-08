Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8D826B0443
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 11:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbjCHK3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 05:29:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbjCHK2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 05:28:36 -0500
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A565A6DC;
        Wed,  8 Mar 2023 02:28:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1678271303; x=1709807303;
  h=references:from:to:cc:subject:date:in-reply-to:
   message-id:mime-version;
  bh=ERuDuGcRTL804Rbo3GS7kLtS9og5lGMsy9rw0XXi7wc=;
  b=Y1MHhVb9cYSzK8ooS8iRmAAvUI1aBjPiBMobuwdlNUaIB6rz1Wo9rSWZ
   pHFqFuKm13ipvrwF751nGdXXilS2axyHpahFejMtuKSEOdVUJccIAqMnm
   VC8zGqW8o9Gc2whR8c1qrfVTb5djBtorepPRSXjsGe5j+ibdh4yiSqbJX
   c=;
X-IronPort-AV: E=Sophos;i="5.98,243,1673913600"; 
   d="scan'208";a="316081795"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-153b24bc.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2023 10:28:14 +0000
Received: from EX19D016EUA004.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-m6i4x-153b24bc.us-east-1.amazon.com (Postfix) with ESMTPS id EEB1BCCA0A;
        Wed,  8 Mar 2023 10:28:08 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX19D016EUA004.ant.amazon.com (10.252.50.4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Wed, 8 Mar 2023 10:28:07 +0000
Received: from u570694869fb251.ant.amazon.com.amazon.com (10.85.143.179) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Wed, 8 Mar 2023 10:28:00 +0000
References: <cover.1678200041.git.lorenzo@kernel.org>
 <dfa9327874de41c5efa44001518d4432f9afe304.1678200041.git.lorenzo@kernel.org>
User-agent: mu4e 1.8.13; emacs 28.0.91
From:   Shay Agroskin <shayagr@amazon.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>, <saeedm@nvidia.com>,
        <tariqt@nvidia.com>, <leon@kernel.org>, <akiyano@amazon.com>,
        <darinzon@amazon.com>, <sgoutham@marvell.com>,
        <lorenzo.bianconi@redhat.com>, <toke@redhat.com>,
        <teknoraver@meta.com>
Subject: Re: [PATCH net-next 5/8] net: ena: take into account xdp_features
 setting tx/rx queues
Date:   Wed, 8 Mar 2023 12:25:00 +0200
In-Reply-To: <dfa9327874de41c5efa44001518d4432f9afe304.1678200041.git.lorenzo@kernel.org>
Message-ID: <pj41zla60n1qs7.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.85.143.179]
X-ClientProxiedBy: EX19D044UWA002.ant.amazon.com (10.13.139.11) To
 EX19D028EUB003.ant.amazon.com (10.252.61.31)
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Lorenzo Bianconi <lorenzo@kernel.org> writes:

> ena nic allows xdp just if enough hw queues are available for 
> XDP.
> Take into account queues configuration setting xdp_features.
>
> Fixes: 66c0e13ad236 ("drivers: net: turn on XDP features")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/amazon/ena/ena_ethtool.c | 15 
>  ++++++++++++---
>  drivers/net/ethernet/amazon/ena/ena_netdev.c  |  6 ++++--
>  2 files changed, 16 insertions(+), 5 deletions(-)
>

For the ENA driver changes and the non-driver changes
Reviewed-by: Shay Agroskin <shayagr@amazon.com>

Thank you for doing that (:
