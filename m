Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 014A664E6CB
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 05:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiLPEoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 23:44:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiLPEow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 23:44:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B57654F6
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 20:44:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DEAD3B81C34
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 04:44:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 331F0C433EF;
        Fri, 16 Dec 2022 04:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671165888;
        bh=gK2wJSadgaC7OS+qpGKqFFoSL6Kgyc2SNZnLaTfLGN0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tUEMbZ3JbfWtednPYllJjxHtQiTDNo3c0vz/RZIFRB+kQeZ4R16jCHfmUKICdKaJD
         ojzg2UAQnDEEP1OtIRK4n2zZUDWXiIoKlZzgeyB5gSUNTVhHkYKGw4P0YGyoE7rZgx
         95/azqd2YjZ3+lwMeJpEUIUqfrA2kMso0ByWckFJFgvnoCMePXFhx6aVbtGGGUeuq9
         faf4mFdtaU6PzknRjbfe1hakV10xSQjDUracS12GuuFuIFQHuacEPdOKEzzaGg/14t
         6k1FXCLooXqr6/jof8Ae5TXOBrS/gL1+YpIAlobkbOpj3vFLgHVJKU8gCm/+sgyqnQ
         N6plsxdX04nsw==
Date:   Thu, 15 Dec 2022 20:44:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jacob.e.keller@intel.com, jiri@nvidia.com, moshe@mellanox.com
Subject: Re: [PATCH net] devlink: protect devlink dump by the instance lock
Message-ID: <20221215204447.149b00e6@kernel.org>
In-Reply-To: <20221216044122.1863550-1-kuba@kernel.org>
References: <20221216044122.1863550-1-kuba@kernel.org>
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

On Thu, 15 Dec 2022 20:41:22 -0800 Jakub Kicinski wrote:
> Take the instance lock around devlink_nl_fill() when dumping,
> doit takes it already.
> 
> We are only dumping basic info so in the worst case we were risking
> data races around the reload statistics. Also note that the reloads
> themselves had not been under the instance lock until recently, so
> the selection of the Fixes tag is inherently questionable.
> 
> Fixes: a254c264267e ("devlink: Add reload stats")

On second thought, the drivers can't call reload, so until we got rid
of the big bad mutex there could have been no race. I'll swap the tag
for:

Fixes: d3efc2a6a6d8 ("net: devlink: remove devlink_mutex")

when/if applying.

> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: jiri@nvidia.com
> CC: moshe@mellanox.com
> ---
>  net/core/devlink.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index d2df30829083..032d6d0a5ce6 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -1648,10 +1648,13 @@ static int devlink_nl_cmd_get_dumpit(struct sk_buff *msg,
>  			continue;
>  		}
>  
> +		devl_lock(devlink);
>  		err = devlink_nl_fill(msg, devlink, DEVLINK_CMD_NEW,
>  				      NETLINK_CB(cb->skb).portid,
>  				      cb->nlh->nlmsg_seq, NLM_F_MULTI);
> +		devl_unlock(devlink);
>  		devlink_put(devlink);
> +
>  		if (err)
>  			goto out;
>  		idx++;

