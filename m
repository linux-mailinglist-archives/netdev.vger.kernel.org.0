Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4053261A6E3
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 03:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiKECZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 22:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiKECZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 22:25:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E6A2317E2
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 19:25:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D25FE6239C
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 02:25:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 046A7C433C1;
        Sat,  5 Nov 2022 02:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667615111;
        bh=h5jdexuvHxXBy3Isi7dQv5eQ3FpOOjycrq12KDz61X0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cPLw/25Gi3fza8J0cDjl28BclICC7Wjq06B3ULJlNbzEsySGF2T8gsjYWrpXSAh/l
         tI6jw5goLYBbWke+M9v+NCMcYZi2l/hx/blrk7bC8VcQqwazyr6eC7IBKz9xWElRgy
         wTPNHaBfzlTuA14cpB0SnGUXAHGva+ce9pjcyy+ns7ezVpFbeBxcPCjUzzr3JeYq3d
         gEYfDhm5VE/7jkTqDEhpXl6TTuzDqGjmLYlQcchjlthHyeTSNpOVQ0kixHSubk7Ctp
         P7LzfgUotUDQGDYSBdVkwiQyPxd6MTc+aG1GGNtbpv2eLaSZPX+PUr+NObMTZcWJJ0
         Ql+Tu82ZWzbrA==
Date:   Fri, 4 Nov 2022 19:25:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com
Subject: Re: [patch net-next] net: devlink: expose the info about version
 representing a component
Message-ID: <20221104192510.32193898@kernel.org>
In-Reply-To: <20221104152425.783701-1-jiri@resnulli.us>
References: <20221104152425.783701-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  4 Nov 2022 16:24:25 +0100 Jiri Pirko wrote:
> If certain version exposed by a driver is marked to be representing a
> component, expose this info to the user.
> 
> Example:
> $ devlink dev info
> netdevsim/netdevsim10:
>   driver netdevsim
>   versions:
>       running:
>         fw.mgmt 10.20.30
>       flash_components:
>         fw.mgmt

Didn't I complain that this makes no practical sense because
user needs to know what file to flash, to which component?
Or was that a different flag that I was complaining about?

> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
> index 2f24b53a87a5..7f2874189188 100644
> --- a/include/uapi/linux/devlink.h
> +++ b/include/uapi/linux/devlink.h
> @@ -607,6 +607,8 @@ enum devlink_attr {
>  
>  	DEVLINK_ATTR_SELFTESTS,			/* nested */
>  
> +	DEVLINK_ATTR_INFO_VERSION_IS_COMPONENT,	/* u8 0 or 1 */

In the interest of fairness I should complain about the use of u8/u16

devlink is genetlink so user will know kernel supports the attribute 
(by looking at family->maxattr). So this can be a flag.
