Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 870A43AD603
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 01:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235128AbhFRXje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 19:39:34 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:44486 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234082AbhFRXjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 19:39:31 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id A3FF01FD40;
        Fri, 18 Jun 2021 23:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1624059440; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yIqhvW+0A/1RsRRhSqYVJGV3WsoA/CaWbqPie/1pbDY=;
        b=vgznTV1PDAzv/utWtkZuCIj26nRAY6Rx8VUNcF53vRaFR/lzXw3PW7ta6zKc4CeKEgU9GZ
        VfEqnx1CLrUZ6gjl15AW/DL9F17TMFiCPGhcp3LwHngxalgyCGw8KP8s+KKTX2+xAgruVG
        bYl85CV3gNmhZEJT+gWHxljxTAe2TdU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1624059440;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yIqhvW+0A/1RsRRhSqYVJGV3WsoA/CaWbqPie/1pbDY=;
        b=VWUg63xbRDlzMxoGQn1CrsCN6Aft2D0kLH8PUabV6uiVeQGCNITvB7bStUPIVO95Vj9vD1
        gXu2CVFXhKCvzuDQ==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 97DABA3B85;
        Fri, 18 Jun 2021 23:37:20 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 52121607E1; Sat, 19 Jun 2021 01:37:20 +0200 (CEST)
Date:   Sat, 19 Jun 2021 01:37:20 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net-next] ethtool: strset: account for nesting in reply
 size
Message-ID: <20210618233720.js4sk2xtgvf4ssn2@lion.mk-sys.cz>
References: <20210618225502.170644-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210618225502.170644-1-saeed@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 18, 2021 at 03:55:02PM -0700, Saeed Mahameed wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> The cited patch revealed a bug in strset reply size where the
> calculation didn't include the 1st nla_nest_start(), a size of 4 Bytes in
> strset_fill_reply().
> 
> To fix the issue we account for the missing nla_nest 4Bytes by reporting
> them in strset_reply_size()
> 
> Before this patch issuing "ethtool -k" command will produce the
> following call trace:
[...]
> Fixes: 4d1fb7cde0cc ("ethtool: add a stricter length check")
> Fixes: 7c87e32d2e38 ("ethtool: count header size in reply size estimate")
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> CC: Jakub Kicinski <kuba@kernel.org>
> CC: Michal Kubecek <mkubecek@suse.cz>

Actually, the history was the other way around: Jakub first fixed this
bug discovered by sysbot with commit e175aef90269 ("ethtool: strset: fix
message length calculation") in net tree and it inspired him to refine
the length check to catch such issues more likely. Unfortunately the fix
hasn't been merged into net-next yet which is why you saw the warning.
At least we know for sure now that the new version of the check works
much better than the old one.

> Note: I used nla_total_size(0); to report the missing bytes, i see in
> other places they use nla_total_size(sizeof(u32)). Since nla_nest uses a
> payload of 0, I prefer my version of nla_total_size(0); since it
> resembles what the nla_nest is actually doing. I might be wrong though
> :), comments ?

Out of the three fixes, personally I liked most the one which applied
nla_total_len() to calculated length of the nest contents as it IMHO
reflects the message structure best; but adding nla_total_size(0) also
provides the same result so either does the trick.

Michal

> ---
>  net/ethtool/strset.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
> index b3029fff715d..23d517a61e08 100644
> --- a/net/ethtool/strset.c
> +++ b/net/ethtool/strset.c
> @@ -349,8 +349,8 @@ static int strset_reply_size(const struct ethnl_req_info *req_base,
>  {
>  	const struct strset_req_info *req_info = STRSET_REQINFO(req_base);
>  	const struct strset_reply_data *data = STRSET_REPDATA(reply_base);
> +	int len = nla_total_size(0); /* account for nesting */
>  	unsigned int i;
> -	int len = 0;
>  	int ret;
>  
>  	for (i = 0; i < ETH_SS_COUNT; i++) {
> -- 
> 2.31.1
> 
