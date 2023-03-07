Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A68E6ADB92
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 11:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbjCGKQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 05:16:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbjCGKQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 05:16:20 -0500
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A0462B72
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 02:16:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1678184174; x=1709720174;
  h=references:from:to:cc:date:in-reply-to:message-id:
   mime-version:subject;
  bh=fe5AFXPkBQc+GwaPNxb7sMKhvEWebfkjUEq0pZoUqks=;
  b=kVtj6Vtx4nMMiCZNkJjIWmNTO1oO76EwPrdYjFmN0kNEFwgWPiBKqTdh
   OdKqO3jFqKbDsYf1HQ17/h3/MBy1xGo5Iy5o8mVe75ba2jH2ru3fxbNmE
   uSTpJ0DBdxHJsiCwscKNhCjIfwV1zwyeWNlq4mykrov+f7qXn70GrpHMo
   4=;
X-IronPort-AV: E=Sophos;i="5.98,240,1673913600"; 
   d="scan'208";a="267642635"
Subject: Re: [PATCH RFC v2 net-next 1/4] ethtool: Add support for configuring
 tx_push_buf_len
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-189d700f.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 10:16:07 +0000
Received: from EX19D002EUA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-m6i4x-189d700f.us-west-2.amazon.com (Postfix) with ESMTPS id 3507F40DD2;
        Tue,  7 Mar 2023 10:16:05 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX19D002EUA001.ant.amazon.com (10.252.50.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Tue, 7 Mar 2023 10:16:04 +0000
Received: from u570694869fb251.ant.amazon.com.amazon.com (10.85.143.174) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Tue, 7 Mar 2023 10:15:56 +0000
References: <20230302203045.4101652-1-shayagr@amazon.com>
 <20230302203045.4101652-2-shayagr@amazon.com>
 <20230303155058.2041c83a@kernel.org>
User-agent: mu4e 1.8.13; emacs 28.0.91
From:   Shay Agroskin <shayagr@amazon.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
Date:   Tue, 7 Mar 2023 12:09:59 +0200
In-Reply-To: <20230303155058.2041c83a@kernel.org>
Message-ID: <pj41zlh6uw27ft.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.85.143.174]
X-ClientProxiedBy: EX19D036UWB003.ant.amazon.com (10.13.139.172) To
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


Jakub Kicinski <kuba@kernel.org> writes:

> CAUTION: This email originated from outside of the 
> organization. Do not click links or open attachments unless you 
> can confirm the sender and know the content is safe.
>
>
>
> On Thu, 2 Mar 2023 22:30:42 +0200 Shay Agroskin wrote:
>> +         nla_put_u32(skb, ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN_MAX,
>> +                     kr->tx_push_buf_max_len) ||
>> +         nla_put_u32(skb, ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN,
>> +                     kr->tx_push_buf_len))
>
> Only report these if driver declares support, please

Added a check in next patchset, lemme know if that is what you 
meant
