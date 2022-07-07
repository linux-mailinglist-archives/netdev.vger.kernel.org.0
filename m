Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B34D569ABE
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 08:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234701AbiGGGvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 02:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233015AbiGGGvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 02:51:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7BDF2C119
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 23:51:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 811CB6224E
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 06:51:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7573C341C0;
        Thu,  7 Jul 2022 06:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657176675;
        bh=RUHIOV+zZfBZYZGQ9dOUIz7woMK0GkVfePFskY3dM7w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HcLMQxlpaZynkr66OKvb3hUmaCvFSTXbn7bKrSBngEkxkrF2ne5gAkVwcaexUnaej
         eBadmze7Y1xTYAFJuNBMqdLgXsixG2VwI9M6HeSJ3tP7Yc0gU7kDLlZeAe0UCPUeO0
         4BO3Pumpmy0uodvkLRCimAmPYKJGwy5ybJ8XTx0TnO/IWuq5DCRW1D3wNsV3Zas9/w
         HuEk6zvM8EA6CoNRzb81QgrUpNGAXifFaKpQAMEm+SiR4gE2qYZhnX+1cMEqqDwDZa
         qZeqv18KJUPEN3512yt71359/SycepvNSIyCN8WrYy+iKH36PnnoKWyw97p4+50ol7
         xMw4jDLIABdVg==
Date:   Wed, 6 Jul 2022 23:51:14 -0700
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: Re: [net-next 10/15] net/tls: Perform immediate device ctx cleanup
 when possible
Message-ID: <20220707065114.4tdx6f2lxig6lsof@sx1>
References: <20220706232421.41269-1-saeed@kernel.org>
 <20220706232421.41269-11-saeed@kernel.org>
 <20220706192107.0b6fe869@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220706192107.0b6fe869@kernel.org>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06 Jul 19:21, Jakub Kicinski wrote:
>On Wed,  6 Jul 2022 16:24:16 -0700 Saeed Mahameed wrote:
>> From: Tariq Toukan <tariqt@nvidia.com>
>>
>> TLS context destructor can be run in atomic context. Cleanup operations
>> for device-offloaded contexts could require access and interaction with
>> the device callbacks, which might sleep. Hence, the cleanup of such
>> contexts must be deferred and completed inside an async work.
>>
>> For all others, this is not necessary, as cleanup is atomic. Invoke
>> cleanup immediately for them, avoiding queueuing redundant gc work.
>>
>> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
>> Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
>> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
>
>Not sure if posting core patches as part of driver PRs is a good idea,
>if I ack this now the tag will not propagate.

I agree, how about the devlink lock removal  ? same thing ? 
