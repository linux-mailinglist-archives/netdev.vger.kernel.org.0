Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1E3B6B36E5
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 07:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjCJGxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 01:53:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbjCJGxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 01:53:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D4321556C
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 22:53:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75CEBB82144
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 06:53:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B8CFC433EF;
        Fri, 10 Mar 2023 06:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678431208;
        bh=X6qJZ/jMsa96FanTrGthb1XjslSTbruCNKybAhJTK/o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m1LF4RrE8EFS2n78/Fx7MHeQftwsU6169J4eGEnWHRKO/RiYmdi5huZIK0pJo/Z2b
         3QvB09M6k8I4ZgSulA7dbCgt+O+uZl1cmpxnkExOirOpHZpWxWKw18D/0JgWHaZdUt
         F248i47gaoaVtqB4vo38RfZtMido4yJivGOcS3+degGG4hM/G5wnVqT0tD07yPoQWC
         EPLbSZR5/CcWpD39M6JqeTO5A0Duz8n/OUJJGmxoqnNES7uZwm8IJvqlHsSND8lO84
         qiHi7L8Ws71Lx2ONXZ3jdTqT+aU40dka6eukYJm5zjduYbnsM6rnT651LmWbGaki8K
         LLHnEWfmWrK2g==
Date:   Thu, 9 Mar 2023 22:53:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gal Pressman <gal@nvidia.com>
Cc:     Shay Agroskin <shayagr@amazon.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
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
Subject: Re: [PATCH v4 net-next 1/5] ethtool: Add support for configuring
 tx_push_buf_len
Message-ID: <20230309225326.2976d514@kernel.org>
In-Reply-To: <316ee596-e184-8613-d136-cd2cb13a589f@nvidia.com>
References: <20230309131319.2531008-1-shayagr@amazon.com>
        <20230309131319.2531008-2-shayagr@amazon.com>
        <316ee596-e184-8613-d136-cd2cb13a589f@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Mar 2023 19:15:43 +0200 Gal Pressman wrote:
> I know Jakub prefers the new parameter, but the description of this
> still sounds extremely similar to TX copybreak to me..
> TX copybreak was traditionally used to copy packets to preallocated DMA
> buffers, but this could be implemented as copying the packet to the
> (preallocated) WQE's inline part. That usually means DMA memory, but
> could also be device memory in this ENA LLQ case.
> 
> Are we drawing a line that TX copybreak is the threshold for DMA memory
> and tx_push_buf_len is the threshold for device memory?

Pretty much, yes. Not an amazing distinction but since TX copybreak can
already mean two different things (inline or DMA buf) I'd err on 
the side of not overloading it with another one. 
And Pensando needed a similar knob? Maybe I'm misremembering now.

> Are they mutually exclusive?

Not sure.

> BTW, as I mentioned in v1, ENA doesn't advertise tx_push, which is a bit
> strange given the fact that it now adds tx_push_buf_len support.

Fair point.
