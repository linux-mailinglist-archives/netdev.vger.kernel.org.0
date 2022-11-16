Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0805562CDA5
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 23:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233805AbiKPW3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 17:29:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231564AbiKPW3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 17:29:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D399E1836C;
        Wed, 16 Nov 2022 14:29:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64A2461FC2;
        Wed, 16 Nov 2022 22:29:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B00B6C433C1;
        Wed, 16 Nov 2022 22:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668637745;
        bh=R2OFfv/t70H+4z3SJYV5zjieCrEVAsB96cKgnamkGSQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TrxOJPhwy4EgX6Yt2GYsf346Fif5KFYihSdWeSGdiSrBqgPdc/tfmMVF7nHUn2JgU
         r/clDpnUGuNEvv1/Coxfp/HLi11YWSAbERXV3ZtDexUDQ68f4RkJ7pXBC6F8El6QA5
         Dpf6VjZgiI27/Fj9UDIkRbfvdZ+TKV8OeXaXE3zsg6TLp2uGTyxI0hm8Ta+YH9jAvw
         E/0DSRAZ+evHgcznQRzm25dOnlq9IGPYKp/YoyLdVxNr+sGRjVHj66GFOS5tBp6Kx+
         nzdoa4DWaUEK3XOBntuM9Ld8rsJ+qriy9M9bhw4UwGgQ3HMP9F1h7AwJqYVAiy+7yl
         K3evcvjkmdUcw==
Date:   Wed, 16 Nov 2022 14:29:04 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, bpf@vger.kernel.org,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Shwetha Nagaraju <Shwetha.nagaraju@intel.com>
Subject: Re: [PATCH net 1/2] i40e: Fix failure message when XDP is configured
 in TX only mode
Message-ID: <Y3VkMPyftd//NOdp@x130.lan>
References: <20221115000324.3040207-1-anthony.l.nguyen@intel.com>
 <20221115000324.3040207-2-anthony.l.nguyen@intel.com>
 <Y3OCeXZUWpJTDIQF@boxer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y3OCeXZUWpJTDIQF@boxer>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15 Nov 13:13, Maciej Fijalkowski wrote:
>On Mon, Nov 14, 2022 at 04:03:23PM -0800, Tony Nguyen wrote:
>> From: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
>>
>> When starting xdpsock program in TX only mode:
>>
>> samples/bpf/xdpsock -i <interface> -t
>>
>> there was an error on i40e driver:
>>
>> Failed to allocate some buffers on AF_XDP ZC enabled Rx ring 0 (pf_q 81)
>>
>> It was caused by trying to allocate RX buffers even though
>> no RX buffers are available because we run in TX only mode.
>>
>> Fix this by checking for number of available buffers
>> for RX queue when allocating buffers during XDP setup.
>
>I was not sure if we want to proceed with this or not. For sure it's not a
>fix to me, behavior was not broken, txonly mode was working correctly.
>We're only getting rid of the bogus message that caused confusion within
>people.
>
>I feel that if we want that in then we should route this via -next and
>address other drivers as well. Not sure what are Magnus' thoughts on this.
>
+1

Some other driver might not have this print message issue, but it would be
nice if the driver got some indication of the TX only nature so maybe we can
cut some corners on napi and avoid even attempting to allocate the rx zc
buffers.
