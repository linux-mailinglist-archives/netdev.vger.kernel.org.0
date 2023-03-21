Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B70276C2DC9
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 10:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbjCUJZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 05:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjCUJZl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 05:25:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E4A20073;
        Tue, 21 Mar 2023 02:25:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89A97B81339;
        Tue, 21 Mar 2023 09:25:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EDC7C433D2;
        Tue, 21 Mar 2023 09:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679390737;
        bh=pMkkEwPQA0K6orVCJyEnzOASLLBZRpBk6jxTRKnPr3I=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=q2OlRIfj8ROG8RUg8o82dpuLwUl8rwuZqsRDKV0ElpfzgR0wRuaTafN04rtJHmun2
         A4cqk6NEdfEPWuVarW8xxDJaRL61GPk95XilHxAJEmILiQWO1eBtC2unR69nOuoMje
         5PrQAEkZUNOu9eVS2UNNN1B0d5Sup+mtZmpEik8DRxIDUvz09gEoAZmWeLyqCusPLa
         s1UMD8sBGDsT6KKdKBUP/olBgDDlnQYaF2+iHVNOD30IgTO55c9fLRlD+1v+dMS1sk
         d3Gu2pR79Egi3CiTsWJ97KDcbCj2PjutoZaQEfxQ76EDNvkSIX1ro+o6vrjNkpKZnx
         2esMlW0tfyMGQ==
Message-ID: <1dddf2d3-ea82-732b-ffaa-7e59f8617a7b@kernel.org>
Date:   Tue, 21 Mar 2023 11:25:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next] net: ethernet: ti: am65-cpts: adjust estf
 following ptp changes
Content-Language: en-US
To:     Siddharth Vadapalli <s-vadapalli@ti.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        jacob.e.keller@intel.com, richardcochran@gmail.com, leon@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, srk@ti.com
References: <20230321062600.2539544-1-s-vadapalli@ti.com>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <20230321062600.2539544-1-s-vadapalli@ti.com>
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



On 21/03/2023 08:26, Siddharth Vadapalli wrote:
> From: Grygorii Strashko <grygorii.strashko@ti.com>
> 
> When the CPTS clock is synced/adjusted by running linuxptp (ptp4l/phc2sys),
> it will cause the TSN EST schedule to drift away over time. This is because
> the schedule is driven by the EstF periodic counter whose pulse length is
> defined in ref_clk cycles and it does not automatically sync to CPTS clock.
>    _______
>  _|
>   ^
>   expected cycle start time boundary
>    _______________
>  _|_|___|_|
>   ^
>   EstF drifted away -> direction
> 
> To fix it, the same PPM adjustment has to be applied to EstF as done to the
> PHC CPTS clock, in order to correct the TSN EST cycle length and keep them
> in sync.
> 
> Drifted cycle:
> AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635968230373377017
> AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635968230373877017
> AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635968230374377017
> AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635968230374877017
> AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635968230375377017
> AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635968230375877023
> AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635968230376377018
> AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635968230376877018
> AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635968230377377018
> 
> Stable cycle:
> AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635966863193375473
> AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635966863193875473
> AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635966863194375473
> AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635966863194875473
> AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635966863195375473
> AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635966863195875473
> AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635966863196375473
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>

Reviewed-by: Roger Quadros <rogerq@kernel.org>
