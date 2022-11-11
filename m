Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8384625B51
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 14:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231778AbiKKNfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 08:35:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbiKKNfy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 08:35:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A582213FB8;
        Fri, 11 Nov 2022 05:35:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46B3561FB9;
        Fri, 11 Nov 2022 13:35:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03BDEC433C1;
        Fri, 11 Nov 2022 13:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668173752;
        bh=CaRWFQiIEk3LaLCfHVLBit9YNmh0dMLE9iEL18b83rU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=hfsWscfQevV1MMDKPneC9LR/rjZe4/oQJjeVp5jQN/y5d9QKQBb8gIwJukxN8etsp
         GG7UWqx9E+6h37zbMTMTzc9huTz4Ym/eZYuCGXuoRDNYtm6PtfJ9mSs6Nry7T1ktBC
         YIAJiXygu+qgANsYedd7jpejnc+i9GyArejbXQpTVv48RlbcTzK1Xlz8q0imDumlDE
         GeyuVVY/yKX9yqAygpVzXofsBPe6kajCmQmBYW21tJTdVYteb9BEp5S02wOG9Dj1rP
         knY6Ji4F76flOWGmMHsyRTKBcncPz0sz1SOntyFp421LPXehWeZqhM/R54yNTr65I0
         W3N+dD8x9lj3w==
Message-ID: <8958bf63-d5e4-9f3c-ad61-b85068cb2fd3@kernel.org>
Date:   Fri, 11 Nov 2022 15:35:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] net: ethernet: ti: cpsw_ale: optimize cpsw_ale_restore()
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "vigneshr@ti.com" <vigneshr@ti.com>, "srk@ti.com" <srk@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20221108135643.15094-1-rogerq@kernel.org>
 <20221109191941.6af4f71d@kernel.org>
 <32eacc9d-3866-149a-579a-41f8e405123f@kernel.org>
 <20221110123249.5f0e19df@kernel.org> <20221111120350.waumn6x35vwfnrfc@skbuf>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <20221111120350.waumn6x35vwfnrfc@skbuf>
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



On 11/11/2022 14:03, Vladimir Oltean wrote:
> On Thu, Nov 10, 2022 at 12:32:49PM -0800, Jakub Kicinski wrote:
>>> I have a question here. How should ageable entries be treated in this case?
>>
>> Ah, no idea :) Let's me add experts to To:
> 
> Not a real expert, but if suspend/resume loses the Ethernet link,
> I expect that no dynamically learned entries are preserved across
> a link loss event.

Understood. We loose the link in this particular case.

> 
> In DSA for example, we only keep ageable entries in hardware as long as
> the port STP state, plus BR_LEARNING port flag, are compatible with
> having such FDB entries. Otherwise, any transition to such a state
> flushes the ageable FDB entries.
> 
> A link loss generates a bridge port transition to the DISABLED state,
> which DSA uses to generate a SWITCHDEV_FDB_FLUSH_TO_BRIDGE event.
> 
> I'm not sure if it would even be possible to accurately do the right
> thing and update the ageing timer of the FDB entries with the amount of
> time that the system was suspended.

In that case I'll leave the entries as they are and let the Switch logic
deal with the stale entries. They should eventually get flushed out.

cheers,
-roger
