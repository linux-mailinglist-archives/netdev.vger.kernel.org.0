Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90F825EBA5B
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 08:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiI0GIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 02:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiI0GIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 02:08:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B9BA6C3B;
        Mon, 26 Sep 2022 23:08:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA358B8198C;
        Tue, 27 Sep 2022 06:08:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 462F4C433D6;
        Tue, 27 Sep 2022 06:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664258921;
        bh=w3EvjEl2w444FDkaGcaMBXMqh4XDEqATPXWfLB6KEW0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=YKKUWOvSvMzWpNaacN2UVJA4PX7oufPHofneTilffSjT4Fj3xUmlNzRxgVHyY48jr
         hZ5s9JI3Dvor6THtpCV7We5LRWzaR2PGDGxvlUcmwszSC6OVx5euWXmHvjzX8fOdYb
         fV2xLKOROR0hgvldaacPTH1mzNTSm4Mc92plqZQNg9eFOzlpNL4aY/y+JvKdUWk3RR
         n/alSKAvdD1V1c5zPdEhITCAacedWPEsnpYs5bD0p82weORCpqJGCPRz3P/cmOYz47
         QquJiLxjTPYo2ek3kLxyVhkwPUsggi5djOYObxBnkTy4FnvKtwJ37PNsGorTIFOeHq
         l4GhyMEWXVqMg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3] cw1200: fix incorrect check to determine if no element
 is
 found in list
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220413091723.17596-1-xiam0nd.tong@gmail.com>
References: <20220413091723.17596-1-xiam0nd.tong@gmail.com>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     pizza@shaftnet.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166425891751.10854.17954228621330378644.kvalo@kernel.org>
Date:   Tue, 27 Sep 2022 06:08:39 +0000 (UTC)
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xiaomeng Tong <xiam0nd.tong@gmail.com> wrote:

> The bug is here: "} else if (item) {".
> 
> The list iterator value will *always* be set and non-NULL by
> list_for_each_entry(), so it is incorrect to assume that the iterator
> value will be NULL if the list is empty or no element is found in list.
> 
> Use a new value 'iter' as the list iterator, while use the old value
> 'item' as a dedicated pointer to point to the found element, which
> 1. can fix this bug, due to now 'item' is NULL only if it's not found.
> 2. do not need to change all the uses of 'item' after the loop.
> 3. can also limit the scope of the list iterator 'iter' *only inside*
>    the traversal loop by simply declaring 'iter' inside the loop in the
>    future, as usage of the iterator outside of the list_for_each_entry
>    is considered harmful. https://lkml.org/lkml/2022/2/17/1032
> 
> Fixes: a910e4a94f692 ("cw1200: add driver for the ST-E CW1100 & CW1200 WLAN chipsets")
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>

Patch applied to wireless-next.git, thanks.

86df5de5c632 cw1200: fix incorrect check to determine if no element is found in list

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220413091723.17596-1-xiam0nd.tong@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

