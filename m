Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C99DD664DC8
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 21:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbjAJU7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 15:59:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234166AbjAJU7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 15:59:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD5312A94
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 12:59:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05A9461900
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 20:59:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8ACDC433D2;
        Tue, 10 Jan 2023 20:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673384358;
        bh=/1kDRb9S3hXvTeMZeCtzyrerTof55q9eTqR7uDooIg8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UfRm3vfTj+AeqXYeo2l56h6e5Gye0GPh0OR+txiP38piFTWL4HmsDn9KPOB+C4cyP
         mL8FhhUCOWETZZJi0vv2acShqL1C2wpz43H6mfxjAf/5JD1Zrqi/CZXSQSghg+Bobi
         Kw23m08K5tahfbPMcP3zenfItlCsbFy019O5Y3zmW7cPBr2T6ZqpP6f7JbWmrTyqdN
         DOsdNVjMmOiVPp4bhuw0xdQaUL0+WLwORa6dnyg8TkQoSLj8iDgzOBrflbHTLdvbHN
         nO5t+OuABCd0+Jc5rSSGAutwDm2LsC4WwyBrHrV5sagk9vRrRJJOKPztqQcDQN/41s
         A1s6LnU6t9LpQ==
Date:   Tue, 10 Jan 2023 12:59:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: Re: [patch net-next v3 01/11] devlink: remove devlink features
Message-ID: <20230110125915.62d428fb@kernel.org>
In-Reply-To: <Y70PyuHXJZ3gD8dG@nanopsycho>
References: <20230109183120.649825-1-jiri@resnulli.us>
        <20230109183120.649825-2-jiri@resnulli.us>
        <20230109165500.3bebda0a@kernel.org>
        <Y70PyuHXJZ3gD8dG@nanopsycho>
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

On Tue, 10 Jan 2023 08:12:10 +0100 Jiri Pirko wrote:
>> Right, but this is not 100% equivalent because we generate the
>> notifications _before_ we try to reload_down:
>>
>>	devlink_ns_change_notify(devlink, dest_net, curr_net, false);
>>	err = devlink->ops->reload_down(devlink, !!dest_net, action, limit, extack);
>>	if (err)
>>		return err;
>>
>> IDK why, I haven't investigated.  
> 
> Right, but that is done even in other cases where down can't be done. I
> I think there's a bug here, down DEL notification is sent before calling
> down which can potentially fail. I think the notification call should be
> moved after reload_down() call. Then the bahaviour would stay the same
> for the features case and will get fixed for the reload_down() reject
> cases. What do you think?

I was gonna say that it sounds reasonable, and that maybe we should 
be in fact using devlink_notify_register() instead of the custom
instance-and-params-only devlink_ns_change_notify().

But then I looked at who added this counter-intuitive code
and found out it's for a reason - see 05a7f4a8dff19.

So you gotta check if mlx5 still has this problem...
