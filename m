Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA4C62583B
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 11:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233643AbiKKK0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 05:26:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233567AbiKKKZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 05:25:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC36129;
        Fri, 11 Nov 2022 02:25:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 339B4B82510;
        Fri, 11 Nov 2022 10:25:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50033C433D6;
        Fri, 11 Nov 2022 10:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668162355;
        bh=bnQXfus7E3RasnI8EALEGVL0v9ZykMY0xEISNFgDZyY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=hh3ztc+RCjIOVNp7TMdIES2gXjy0XYR4dt6yqtM+cn4UBAlsDNM5WziMvrhhEs3j5
         PmF/nBb1QhXPIPNUM6vN589es2xw6VCutcpdDmh++Y+8SdL4t2Icz3OQJ6XTUnzFqv
         gTjoFUYOG1P06YcGf82o41rCjMHWfcSRNSfdHLlA8p88Ev/l+M2QHa3owp4vGOGGSV
         yrvlLtTyGPzVrmcMDxpIgjZj6d+Z0vZ9Uno2OcF0FzOO3h9sf/rkbhiJXrx5erhJzB
         JGPOEO10jta2PFXZyM1ZQnzYWrCoSjW8UrUFscHIRfmiG42No2Xw6/1POmUDJzVFkF
         5OVNLYHLZgc/Q==
Message-ID: <48804ac2-e5aa-bb48-3a44-922e0bd3b688@kernel.org>
Date:   Fri, 11 Nov 2022 12:25:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] net: ethernet: ti: cpsw_ale: optimize cpsw_ale_restore()
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ido Schimmel <idosch@idosch.org>,
        Nikolay Aleksandrov <razor@blackwall.org>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        vigneshr@ti.com, srk@ti.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221108135643.15094-1-rogerq@kernel.org>
 <20221109191941.6af4f71d@kernel.org>
 <32eacc9d-3866-149a-579a-41f8e405123f@kernel.org>
 <20221110123249.5f0e19df@kernel.org>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <20221110123249.5f0e19df@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On 10/11/2022 22:32, Jakub Kicinski wrote:
> On Thu, 10 Nov 2022 11:39:47 +0200 Roger Quadros wrote:
>>> Maybe my tree is old but I see we clear only if there is a netdev that  
>>
>> This patch depends on this series
>> https://lore.kernel.org/netdev/20221104132310.31577-3-rogerq@kernel.org/T/
> 
> I do have those in my tree.
> 
>>> needs to be opened but then always call ale_restore(). Is that okay?  
>>
>> If netdev is closed and opened ale_restore() is not called.
>> ale_restore() is only called during system suspend/resume path
>> since CPSW-ALE might have lost context during suspend and we want to restore
>> all valid ALE entries.
> 
> Ack, what I'm referring to is the contents of am65_cpsw_nuss_resume().
> 
> I'm guessing that ALE_CLEAR is expected to be triggered by
> cpsw_ale_start().
> 
> Assuming above is true and that ALE_CLEAR comes from cpsw_ale_start(),
> the call stack is:
> 
>  cpsw_ale_start()
>  am65_cpsw_nuss_common_open()
>  am65_cpsw_nuss_ndo_slave_open()
>  am65_cpsw_nuss_resume()
> 
> but resume() only calls ndo_slave_open under certain conditions:
> 
>         for (i = 0; i < common->port_num; i++) {                                  
>                 if (netif_running(ndev)) {                                      
>                         rtnl_lock();                                            
>                         ret = am65_cpsw_nuss_ndo_slave_open(ndev);    
> 
> Is there another path? Or perhaps there's nothing to restore 
> if all netdevs are down?

I see your point now. We are missing a ALE_CLEAR if all interfaces were
down during suspend/resume.
In this case the call to cpsw_ale_restore() is pointless as ALE will be
cleared again when one of the interfaces is brought up.

I'll revise the patch to call cpsw_ale_restore only if any interface
was running.

> 
>> I have a question here. How should ageable entries be treated in this case?
> 
> Ah, no idea :) Let's me add experts to To:

Thanks.

cheers,
-roger
