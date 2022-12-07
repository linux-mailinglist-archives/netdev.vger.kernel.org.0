Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 191636451EA
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 03:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiLGCUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 21:20:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiLGCUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 21:20:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB7350D69;
        Tue,  6 Dec 2022 18:20:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DD4C611E6;
        Wed,  7 Dec 2022 02:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFB85C433D7;
        Wed,  7 Dec 2022 02:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670379621;
        bh=M7DAFgr5ThBCqevusk/kXC0uBMdqkqiwzdl12Q/57kw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rFPttW95JTwhqxZFIY8aR9h89fCfvy0+8zfWbk4Q9vxKFtM/rNjAZ9iAQ3Rts4vML
         AQcYlGB1fwroNhmKI9Ydv6DkEEO1xjeHcPUEHSU/9Axf7fgWDV9jLz7i3HrkIPqltK
         9ai4HwyLFrfyUZiqft0qI05s7IyyGpsVbw/ozpxCqGwTSlWNGvd2kTka1yQeOGLYtM
         e9YOhUWqAuNO+ctyN7JZ6btBIYaj3X+ZUowF1rPBhlgAl4izdX3aPAhaBCAB/84d9t
         4R/fDHWV5PRGDbvfdPkOw67hdFfomR9Tk4z2V/biDNAQpycQxaUqEsfzd577/3Vzs7
         i+E39xfpUIwgQ==
Date:   Tue, 6 Dec 2022 21:20:18 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Jacob Keller <jacob.e.keller@intel.com>,
        "David S . Miller" <davem@davemloft.net>, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.0 09/13] net: loopback: use
 NET_NAME_PREDICTABLE for name_assign_type
Message-ID: <Y4/4Yts6nwDCqC1q@sashalap>
References: <20221206094916.987259-1-sashal@kernel.org>
 <20221206094916.987259-9-sashal@kernel.org>
 <20221206114956.4c5a3605@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221206114956.4c5a3605@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 11:49:56AM -0800, Jakub Kicinski wrote:
>On Tue,  6 Dec 2022 04:49:12 -0500 Sasha Levin wrote:
>> From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
>>
>> [ Upstream commit 31d929de5a112ee1b977a89c57de74710894bbbf ]
>>
>> When the name_assign_type attribute was introduced (commit
>> 685343fc3ba6, "net: add name_assign_type netdev attribute"), the
>> loopback device was explicitly mentioned as one which would make use
>> of NET_NAME_PREDICTABLE:
>>
>>     The name_assign_type attribute gives hints where the interface name of a
>>     given net-device comes from. These values are currently defined:
>> ...
>>       NET_NAME_PREDICTABLE:
>>         The ifname has been assigned by the kernel in a predictable way
>>         that is guaranteed to avoid reuse and always be the same for a
>>         given device. Examples include statically created devices like
>>         the loopback device [...]
>>
>> Switch to that so that reading /sys/class/net/lo/name_assign_type
>> produces something sensible instead of returning -EINVAL.
>
>Yeah... we should have applied it to -next, I think backporting it is
>a good idea but I wish it had more time in the -next tree since it's
>a "uAPI alignment" :(
>
>Oh, well, very unlikely it will break anything, tho, so let's do it.

Want me to push it back a week to the next batch? It'll give it two
weeks instead of the usual week.

-- 
Thanks,
Sasha
