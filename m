Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5E86091C2
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 10:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbiJWIMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 04:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiJWIMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 04:12:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6565165802;
        Sun, 23 Oct 2022 01:12:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2576FB80880;
        Sun, 23 Oct 2022 08:12:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FBACC433C1;
        Sun, 23 Oct 2022 08:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666512751;
        bh=yrbIrltqvuMTOCDW4SzsBNFjGyhtASZcnictWS3bInM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tkpUrVXkyTS+qYo9vuZOkpVQ77vcd0ybGPEIpbg9VPAiIT+6H2rxsvJZi9BCguFDD
         1868HNYVt48DqLwULpHwuUhcakWZII/rV1EOEKzCEjTekeK2wVgBBPILAAjBFaXiVM
         xxC0h82d75cx4CnV2bdiCPFU6JZaad+yEPo5y7XGos/gsxN7G4ex6YXjcryV0oaAfJ
         u8IE6vJLB1OYHXmaqvP7Rot0EGGGm6ohFi/SDoiJOOgnhjYexkpZ1hgrcS1VXHvbHS
         t92Y5zOTaNf3dXvah6bVWlGi7f842gd163NGVsON62EDq0ktWBy5dupvZZPY9j7Q19
         oqpIXnsASSeqg==
Date:   Sun, 23 Oct 2022 11:12:27 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        johannes@sipsolutions.net
Subject: Re: [PATCH -next] rfkill: remove BUG_ON() in core.c
Message-ID: <Y1T3a1y/pWdbt2ow@unreal>
References: <20221021130104.469966-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021130104.469966-1-yangyingliang@huawei.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 21, 2022 at 09:01:04PM +0800, Yang Yingliang wrote:
> Replace BUG_ON() with pointer check to handle fault more gracefully.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  net/rfkill/core.c | 29 ++++++++++++++---------------
>  1 file changed, 14 insertions(+), 15 deletions(-)
> 
> diff --git a/net/rfkill/core.c b/net/rfkill/core.c
> index dac4fdc7488a..5fc96fa24eda 100644
> --- a/net/rfkill/core.c
> +++ b/net/rfkill/core.c
> @@ -150,9 +150,8 @@ EXPORT_SYMBOL(rfkill_get_led_trigger_name);
>  
>  void rfkill_set_led_trigger_name(struct rfkill *rfkill, const char *name)
>  {
> -	BUG_ON(!rfkill);
> -
> -	rfkill->ledtrigname = name;
> +	if (rfkill)

In all these places, rfkill shouldn't be NULL from the beginning. By
adding these if (rfkill), you are saying to reviewers and code authors
that it is correct thing to do something like this
rfkill_set_led_trigger_name(NULL, "new_name"), which is of course not
true.

Thanks
