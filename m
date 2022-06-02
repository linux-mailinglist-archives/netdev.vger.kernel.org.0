Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5424B53B114
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 03:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232883AbiFBAxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 20:53:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232856AbiFBAxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 20:53:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CE911175
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 17:53:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39C42615AF
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 00:53:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 511D9C385B8;
        Thu,  2 Jun 2022 00:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654131199;
        bh=P7KeeP0epy1eE8Z46PTCmAybrEemmjyM1IdYYDiq1LQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kCzA9gpTjXmEc+8zEYG3Ksl8KleEHTOGqoIkcDRYhI70tVJO1fEQQ0sdE0uYYYure
         jztK9zBuTYP0+z2fvBYoT5c4AX0MfmqIl2aowEOzZKoQaYwjJiVYNxGbiIplVG+Afo
         dXKgxHLvc5FFfsAs1GmFFNlsEuv1xB5zkILzdyBw0CJ6RbxMksSRbg5naSX7AZkdtF
         Wh8nOO/VDm4qbLumSMBnZGGzhueHmUh0wG3EQ3PyJmNG2N5Dkxk6QfAgjlqwWSARaH
         +qTe3sHX4jj+ALgUelx6mma/V742qicRXZM9zHBd9Jv/Si4HN7VGjE6zAiCpozditn
         SbLXrS6nuCs2Q==
Date:   Wed, 1 Jun 2022 17:53:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hoang Le <hoang.h.le@dektech.com.au>
Cc:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        tung.q.nguyen@dektech.com.au, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        syzbot+e820fdc8ce362f2dea51@syzkaller.appspotmail.com
Subject: Re: [net] tipc: check attribute length for bearer name
Message-ID: <20220601175318.1117f8dc@kernel.org>
In-Reply-To: <20220601014853.4904-1-hoang.h.le@dektech.com.au>
References: <20220601014853.4904-1-hoang.h.le@dektech.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  1 Jun 2022 08:48:53 +0700 Hoang Le wrote:
> diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
> index 6d39ca05f249..0fd7554c7cde 100644
> --- a/net/tipc/bearer.c
> +++ b/net/tipc/bearer.c
> @@ -258,10 +258,10 @@ static int tipc_enable_bearer(struct net *net, const char *name,
>  	char *errstr = "";
>  	u32 i;
>  
> -	if (!bearer_name_validate(name, &b_names)) {
> -		errstr = "illegal name";
> +	if (strlen(name) > TIPC_MAX_BEARER_NAME ||
> +	    !bearer_name_validate(name, &b_names)) {

The strlen() check looks unnecessary, the first thing
bearer_name_validate() does is:

	/* copy bearer name & ensure length is OK */
	if (strscpy(name_copy, name, TIPC_MAX_BEARER_NAME) < 0)
		return 0;

So it will handle non-terminated or over-sized names correctly already.

>  		NL_SET_ERR_MSG(extack, "Illegal name");
> -		goto rejected;
> +		return res;

Seems like we only need the change of goto to return for the fix.
