Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1FE621B63
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 19:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234570AbiKHSCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 13:02:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234424AbiKHSCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 13:02:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF204298A
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 10:02:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77836B81BF8
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 18:02:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02641C433D6;
        Tue,  8 Nov 2022 18:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667930529;
        bh=glijBrP2SV5TU1bnOwOpFtgeJqILxw0gJ7tiBabxhU0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d/OnnPkQ1VLMBUoeGRnJcbp/di7QiUpXivG2AnOxQRxa8ZXO8LDqUNcsxVy7AIl0H
         jj0Hf7x6iNuSlU95aXHfDAGwjmwJbjpKBAIXXEsdD4Up3mLRIlb5cZYPpcAR4TBmXW
         gUsRj33yw2qnqfjNVIGffSgBOzj1HIYizkFHD316O4oZiSJkg429eAIGaTl04L5JkQ
         cOyw9mEexJh3aEqXzWYrV+2VpXSLNKTQUO5m7CFQ6AUZ++WLhBHPhL8526gL+df9dM
         nzS2Oo13VLwxvtx1sjy5T8O5HSWpqW7w698QXLJrz/ctJzkErfRtHaAwlXNxENh4/j
         ZKiOqXPiLsNXA==
Date:   Tue, 8 Nov 2022 10:02:04 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: Re: [V2 net 05/11] net/mlx5: Fix possible deadlock on
 mlx5e_tx_timeout_work
Message-ID: <Y2qZnAv0PBTb2kQ4@x130.lan>
References: <20221105071028.578594-1-saeed@kernel.org>
 <20221105071028.578594-6-saeed@kernel.org>
 <20221107202413.7de06ad1@kernel.org>
 <9515a39b692eeaadbdc0dcf8903ad2ab9b3ca64e.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <9515a39b692eeaadbdc0dcf8903ad2ab9b3ca64e.camel@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08 Nov 11:19, Paolo Abeni wrote:
>On Mon, 2022-11-07 at 20:24 -0800, Jakub Kicinski wrote:
>> On Sat,  5 Nov 2022 00:10:22 -0700 Saeed Mahameed wrote:
>> > +	/* Once deactivated, new tx_timeout_work won't be initiated. */
>> > +	if (current_work() != &priv->tx_timeout_work)
>> > +		cancel_work_sync(&priv->tx_timeout_work);
>>
>> The work takes rtnl_lock, are there no callers of
>> mlx5e_switch_priv_channels() that are under rtnl_lock()?
>>
>> This patch is definitely going onto my "expecting Fixes"
>> bingo card :S
>
>I think Jakub is right and even mlx5e_close_locked() will deadlock on
>cancel_work_sync() if the work is scheduled but it has not yet acquired
>the rtnl lock.

Yes you are absolutely correct, you can see the deadlock just by looking at
the patch diff and applying common sense that mlx5e_switch_priv_channels()
is being called under rtnl.

>
>IIRC lockdep is not able to catch this kind of situation, so you can
>only observe the deadlock when reaching the critical scenario.
>
>I'm wild guessing than a possible solution would be restrict the
>state_lock scope in mlx5e_tx_timeout_work() around the state check,
>without additional cancel_work operations.
>

Thanks, i will drop the patch for now and send v3 without it.

>Thanks,
>
>Paolo
>
