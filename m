Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0C74CC2A2
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 17:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234765AbiCCQ1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 11:27:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231809AbiCCQ1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 11:27:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DADE199E2C
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 08:26:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23A05B82620
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 16:26:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E41EC004E1;
        Thu,  3 Mar 2022 16:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646324790;
        bh=5UefDW3myiAnBkceb5x2xFwgOYGjOJMXo7U/8M3x80Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pCicHbjxh3gcyFJpYdZP8YJ+vv73U4WsrM+OO0pdokZpDkm4NmU2/GNNHX7EwpoCx
         qCKjfWCwfXfuu91R28yaYLyIUhZlxYoGDNGbHmIDIhVqkpF/cVQ9N4tiJ0ybhwhikl
         y9nPrrABqFT9Dzy3nVB/NZq3OPkvREjzz3zgaTYCwr2r7u91DUzwP9pf5z5HPAL9cW
         FumtuziNzQrExUziMLiqon8dnbgHi7miQNaY+wyIRKojWOfTOffCoU7l+2nVu0kVdB
         RygVzaeEqy0Wi8DDpyxY8PchY7C/pJp6M7j/AqqPSbQyckWvWhYmfGh6rGmfpm4zgp
         3eWf/sXlMyf4g==
Date:   Thu, 3 Mar 2022 08:26:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tung Nguyen <tung.q.nguyen@dektech.com.au>
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        davem@davemloft.net, Shuang Li <shuali@redhat.com>,
        Jon Maloy <jmaloy@redhat.com>
Subject: Re: [PATCH net 1/1] tipc: fix kernel panic when enabling bearer
Message-ID: <20220303082629.6f6be6a5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220303045717.30232-1-tung.q.nguyen@dektech.com.au>
References: <20220303045717.30232-1-tung.q.nguyen@dektech.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  3 Mar 2022 04:57:17 +0000 Tung Nguyen wrote:
> diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
> index 473a790f5894..63460183440d 100644
> --- a/net/tipc/bearer.c
> +++ b/net/tipc/bearer.c
> @@ -252,7 +252,7 @@ static int tipc_enable_bearer(struct net *net, const char *name,
>  	int with_this_prio = 1;
>  	struct tipc_bearer *b;
>  	struct tipc_media *m;
> -	struct sk_buff *skb;
> +	struct sk_buff *skb = NULL;
>  	int bearer_id = 0;
>  	int res = -EINVAL;
>  	char *errstr = "";

This chunk looks unrelated and unnecessary. The had previously trusted
skb to be initialized by tipc_disc_create().
