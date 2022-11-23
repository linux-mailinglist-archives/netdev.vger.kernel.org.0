Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C22F636E7B
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 00:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiKWXgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 18:36:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiKWXgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 18:36:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA2352EF28
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 15:36:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55FA861F64
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 23:36:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0BA9C433C1;
        Wed, 23 Nov 2022 23:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669246597;
        bh=kpidxtStqJVnKne/HHtO4Bf4eSHT2A1RmQgGL7A7W7M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f2ejHXKoJYpxTBYONVvQPsDZ8zwcVNlRsKrU8ek7No/7kDvDLVQzYFeGEU9u6QLGb
         cGokjsI+NlqxDBJmHzAsH5ouSFO9J6IWWysMfA2DkRwQdPoaHUrC9Er6Sl/rwgOpyk
         6/Eg/CqFqmLGWF/MirV0hgyf9IqUJW4zmkIaZ+vEJcAYJjZeJIHUAYbAkzsr3hI801
         gtUP2oGtfgNdHuHry7Os1+uL++0QjwuR6ZcMD5O8F2ja+5XJYRzgdykURSXrYGRC2D
         pbtI65Hxjy8mDTx6QzU0bfFgrt0VsdbKmXw7tBeY74kYBH76oNPY5pFdQOfVNEyfYD
         J1kVITwrehkAw==
Date:   Wed, 23 Nov 2022 15:36:36 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Shay Drory <shayd@nvidia.com>, Parav Pandit <parav@nvidia.com>
Subject: Re: [net 03/14] net/mlx5: SF: Fix probing active SFs during driver
 probe phase
Message-ID: <Y36uhLebt0Kx26Nc@x130.lan>
References: <20221122022559.89459-1-saeed@kernel.org>
 <20221122022559.89459-4-saeed@kernel.org>
 <Y3404H9uBoVqCQgb@boxer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y3404H9uBoVqCQgb@boxer>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23 Nov 15:57, Maciej Fijalkowski wrote:
>On Mon, Nov 21, 2022 at 06:25:48PM -0800, Saeed Mahameed wrote:
>> From: Shay Drory <shayd@nvidia.com>
>>
>> When SF devices and SF port representors are located on different
>> functions, unloading and reloading of SF parent driver doesn't recreate
>> the existing SF present in the device.
>> Fix it by querying SFs and probe active SFs during driver probe phase.
>
>Maybe shed some light on how it's actually being done? Have a few words
>that you're adding a workqueue dedicated for that etc. There is also a
>new mutex, I was always expecting that such mechanisms get a bit of
>explanation/justification why there is a need for its introduction.
>

it's needed so we can synchronize the new sync operation on load with the
pre-existing SF adding mechanism "device events" .. 

But i don't believe it's a requirement to explain the code behind a
commit, I think for this case it's self explanatory for someone who
understand how the basic mechanism of adding SFs to a PF funciton works in
mlx5. but yes I agree, some more information would've been useful, we will
be more verbose for future patches.

>Not sure if including some example reproducer in here is mandatory or not
>(and therefore splat, if any). General feeling is that commit message
>could be beefed up.
>

reproducer is really as simple as stated in the commit message, 
a devlink reload when you have SFs loaded on a dual function system 
(smart nic) where the switchdev SF admin is on a remote cpu function.

