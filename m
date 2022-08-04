Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E652958961D
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 04:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238947AbiHDC3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 22:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiHDC3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 22:29:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA83A11A14;
        Wed,  3 Aug 2022 19:29:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65CF5B82443;
        Thu,  4 Aug 2022 02:29:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9D6CC433D6;
        Thu,  4 Aug 2022 02:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659580173;
        bh=95WjuixEmtHqhYyk/ABrqWxCLjjTXMoyiH05pW4cDXs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=log592zbAttTQGaPBe/B5hf6vBENLIjZf5kNZ6TnkfmDarOI47TqHdPRjQPhPK5HG
         yWcDekPTUQSrB2TtxeVw2Nm7mC4aSIutboh73vb91Re9Shr2ts1CqL0OEza5LZbFO6
         4x2573IdVvA2/FK4DFKqBbgkAR8n/+LbwolqdNQqBR1IXk9Wf/wWmRhpxbEoZ5d0rk
         nYBFKJFdymy0jJFo/Qu+1b6KPlumTtD7UsDYQUrjFZytRqJeS5WuQxuhtjB6GKsxkK
         cCDvP+hnblhw4KuzRaeBQTE+QMdvdc7SdSBReN6EudyOFpZ8Qwlm63tbq/1pQayOUC
         LVPb8HemVkNXg==
Date:   Wed, 3 Aug 2022 19:29:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     studentxswpy@163.com
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hacash Robot <hacashRobot@santino.com>
Subject: Re: [PATCH] net: check the return value of ioremap() in
 mhz_mfc_config()
Message-ID: <20220803192931.52900f69@kernel.org>
In-Reply-To: <20220802072826.3212612-1-studentxswpy@163.com>
References: <20220802072826.3212612-1-studentxswpy@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  2 Aug 2022 15:28:26 +0800 studentxswpy@163.com wrote:
> From: Xie Shaowen <studentxswpy@163.com>
> 
> The function ioremap() in mhz_mfc_config() can fail, so
> its return value should be checked.
> 
> Fixes: cdb138080b781 ("pcmcia: do not use win_req_t when calling pcmcia_request_window()")

The check seems fine, but that's not the commit which added the
ioremap() without checking the result. You need to find the fix 
commit in the git history where the bug exists, not just run
git blame on the line in question.

> Reported-by: Hacash Robot <hacashRobot@santino.com>
> Signed-off-by: Xie Shaowen <studentxswpy@163.com>
> ---
>  drivers/net/ethernet/smsc/smc91c92_cs.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/smsc/smc91c92_cs.c b/drivers/net/ethernet/smsc/smc91c92_cs.c
> index 37c822e27207..14333f5bdcdc 100644
> --- a/drivers/net/ethernet/smsc/smc91c92_cs.c
> +++ b/drivers/net/ethernet/smsc/smc91c92_cs.c
> @@ -446,6 +446,8 @@ static int mhz_mfc_config(struct pcmcia_device *link)
>  
>      smc->base = ioremap(link->resource[2]->start,
>  		    resource_size(link->resource[2]));
> +    if (!smc->base)
> +	    return -ENOMEM;
>      offset = (smc->manfid == MANFID_MOTOROLA) ? link->config_base : 0;
>      i = pcmcia_map_mem_page(link, link->resource[2], offset);
>      if ((i == 0) &&

