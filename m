Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C627F6BBE89
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 22:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232332AbjCOVJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 17:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232891AbjCOVJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 17:09:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C326D539
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 14:09:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8E7161E01
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 21:09:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C40AC433EF;
        Wed, 15 Mar 2023 21:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678914545;
        bh=2o4geO+YcsDdfYKORiUSRJ2clZGGzXUUWJlWtCVxlME=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cUNbOu7urbL3mCD/CZZwXY0yaQuSmvI1jd0lmFiElnjYZbS5apGOzOohfJjaYbZ1/
         X/ygLOatkdxvEKcDWKQYFKRZbY+BsSxSPTISQREqmn9qIHBw63hAun1C11wX3ZDVDW
         SgmbcuUEtK9mE7AKQacahC32Z/u+CjvEBeThsw99SZJWGqKHxNxCmh7IxbEhORkZI2
         dil6Ul4nkw5jB8b1dEFPYAqiSRGzxoy+BU2/ZFhhZ9yX7tGLOFTNCp0VmLsCg0iB7N
         y3ryfYxIyVDwpVFxx9kzTaTRxY8jz0gCcFez1l8wK+n2S3HbHjOyQQmB5YGsRbh8Lf
         +BTGCzRdV5QLw==
Date:   Wed, 15 Mar 2023 14:09:03 -0700
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Piotr Raczynski <piotr.raczynski@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Daniel Jurgens <danielj@nvidia.com>
Subject: Re: [net 03/14] net/mlx5: Fix setting ec_function bit in MANAGE_PAGES
Message-ID: <ZBIz7yxaeDOiV4xk@x130>
References: <20230314174940.62221-1-saeed@kernel.org>
 <20230314174940.62221-4-saeed@kernel.org>
 <ZBHD2J8I1WGf9gnB@nimitz>
 <ZBIv4oGgtWbTGkaS@x130>
 <20230315140454.4329d99e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230315140454.4329d99e@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15 Mar 14:04, Jakub Kicinski wrote:
>On Wed, 15 Mar 2023 13:51:46 -0700 Saeed Mahameed wrote:
>> >> +static u32 get_ec_function(u32 function)
>> >> +{
>> >> +	return function >> 16;
>> >> +}
>> >> +
>> >> +static u32 get_func_id(u32 function)
>> >> +{
>> >> +	return function & 0xffff;
>> >> +}
>> >> +
>> >Some code in this file is mlx5 'namespaced', some is not. It may be a
>> >little easier to follow the code knowing explicitly whether it is driver
>> >vs core code, just something to consider.
>>
>> For static local file functions we prefer to avoid mlx5 perfix.
>
>FWIW the lack of consistent namespacing does make mlx5 code harder
>for me to read, so it's definitely something to reconsider long term.

When looking from a larger scope of multiple drivers and stack, yes it
makes total sense.

Ack, will enforce adding mlx5 prefix to static functions as well..

Let me know if you want me to fix this series for the time being, 
I see another comment from leon on a blank line in one of the commit
messages.

I can handle both and post v2 at the same time.

Thanks.


