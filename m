Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 543F4628EB2
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 01:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237428AbiKOAuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 19:50:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232105AbiKOAut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 19:50:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F306157
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 16:50:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A467B614E9
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 00:50:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F8DC433C1;
        Tue, 15 Nov 2022 00:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668473448;
        bh=Y8GxwJq3gBhaRfuAl5WcaMPUNpeGpL/jsPXi4636VJg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LhWhKuuzyu1ii6YJw6ggCgmpAOfagZy618UQahAN3HKPuvwEQP0zxHZ1TSuAdN7e6
         cod0MoE2YA2ylSsKEK2qyLqRdQSJajwt956vAc14dR99Rog8GJA03TibDu7YUhzqAF
         QmHJHsmBKpQgF5AZMMn9pLVAH15OZTCACAQQJICcSa8xpa0MqwRfDhpKL8EvUtgK5x
         fgcrBaNk9ka1FTmBls4j0ZXrD1+MhFJdxgcFbflWhWroXOz9Z3p/tatsJh8e9lIkjJ
         5VNm6IsB/wOt6KXyl8wzwcF5WyiwhRLeOzhz7ddADj6kYVjhcsOOqfwFcZ3nJZiUxJ
         RqXmuw+4kDbHA==
Date:   Mon, 14 Nov 2022 16:50:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        David Thompson <davthompson@nvidia.com>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        cai.huoqing@linux.dev, brgl@bgdev.pl, limings@nvidia.com,
        chenhao288@hisilicon.com, huangguangbin2@huawei.com,
        Asmaa Mnebhi <asmaa@nvidia.com>
Subject: Re: [PATCH net-next v2 3/4] mlxbf_gige: add BlueField-3 Serdes
 configuration
Message-ID: <20221114165046.43d4afbf@kernel.org>
In-Reply-To: <Y29s74Qt6z56lcLB@x130.lan>
References: <20221109224752.17664-1-davthompson@nvidia.com>
        <20221109224752.17664-4-davthompson@nvidia.com>
        <Y2z9u4qCsLmx507g@lunn.ch>
        <20221111213418.6ad3b8e7@kernel.org>
        <Y29s74Qt6z56lcLB@x130.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 12 Nov 2022 01:52:47 -0800 Saeed Mahameed wrote:
> >Well, the patch was marked as Changes Requested so it seems that DaveM
> >concurs :) (I'm slightly desensitized to those tables because they
> >happen in WiFi relatively often.)
> >
> >The recommendation is to come up with a format for a binary file, load
> >it via FW loader and then parse in the kernel?  
> 
> By FW loader you mean request_firmware() functionality ?

Yes, that's what I meant.

> I am not advocating for black magic tables of course :), but how do we
> avoid them if request_firmware() will be an overkill to configure such a
> simple device? Express such data in a developer friendly c structures
> with somewhat sensible field names?

I don't feel particularly strongly but seems like something worth
exploring. A minor advantage is that once the init is done the tables
can be discarded from memory.

> >We did have a recommendation against parsing FW files in the kernel at
> >some point, too, but perhaps this is simple enough to pass.
> >
> >Should this be shared infra? The problem is fairly common.  
> 
> Infrastructure to parse vendor Firmware ? we can't get vendors to agree on
> ethtool interface, you want them to agree on one firmware format :)?

We can keep the table format pretty much as is. What I had in mind was
basically creating a binary file format with u64 address, and u64 data.
Plus file sections to pack multiple tables into one file.
Pretty pleasant coding exercise if you ask me :)

> BTW i don't think the issue here is firmware at all, this is device
> specific config space.
