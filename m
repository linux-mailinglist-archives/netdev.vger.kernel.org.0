Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38E0F567BAF
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 03:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbiGFBwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 21:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiGFBwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 21:52:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B26A18E24
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 18:52:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D47CD6185A
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 01:52:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C114BC341C7;
        Wed,  6 Jul 2022 01:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657072360;
        bh=t5D40nU9TTh98U9FXuS7j3NG1FC8HQOisAFYAUt47Ao=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rNtHyc5pH2dS+0WB8gDQnQ8gnqMSA7pIa2zBrfNH/PgEhtN3CdlkhsM2G7YlNz588
         yXasEMVbK3ka4WhqjtVlk53cxJ5LtJQEJ5Zxajd0jXrqQvi8BqzG15362qdZQMc5/d
         Z/rqxZptivziTBcVBhZFbTHNIvruRawDEsmgsUcLXXaB1qVWaaypOZ4n9okxp+j/9r
         4wXgsKrDEvT7UFonT9rhBe4Iuao5aqKL7wFDNPRCadeZOQHun+TV8SIrVlC/wn3baF
         vsCpktnrErNlUPjJaBKHz2pYX/yaWnnyU9dvXnO0Xfhak72OopdSARu3cRCcZYQHPe
         sGrVNsebjiRjw==
Date:   Tue, 5 Jul 2022 18:52:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hoang Le <hoang.h.le@dektech.com.au>
Cc:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        tung.q.nguyen@dektech.com.au, pabeni@redhat.com,
        edumazet@google.com, tipc-discussion@lists.sourceforge.net,
        netdev@vger.kernel.org, davem@davemloft.net,
        syzbot+a73d24a22eeeebe5f244@syzkaller.appspotmail.com
Subject: Re: [net-next] tipc: fix uninit-value in
 tipc_nl_node_reset_link_stats
Message-ID: <20220705185238.1c287512@kernel.org>
In-Reply-To: <20220705005058.3971-1-hoang.h.le@dektech.com.au>
References: <20220705005058.3971-1-hoang.h.le@dektech.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  5 Jul 2022 07:50:57 +0700 Hoang Le wrote:
> Reported-by: syzbot+a73d24a22eeeebe5f244@syzkaller.appspotmail.com
> Acked-by: Jon Maloy <jmaloy@redhat.com>
> Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>

Can we get a Fixes tag please?

> diff --git a/net/tipc/node.c b/net/tipc/node.c
> index b48d97cbbe29..23419a599471 100644
> --- a/net/tipc/node.c
> +++ b/net/tipc/node.c
> @@ -2561,6 +2561,7 @@ int tipc_nl_node_reset_link_stats(struct sk_buff *skb, struct genl_info *info)
>  	struct net *net = sock_net(skb->sk);
>  	struct tipc_net *tn = tipc_net(net);
>  	struct tipc_link_entry *le;
> +	int len;
>  
>  	if (!info->attrs[TIPC_NLA_LINK])
>  		return -EINVAL;
> @@ -2574,7 +2575,14 @@ int tipc_nl_node_reset_link_stats(struct sk_buff *skb, struct genl_info *info)
>  	if (!attrs[TIPC_NLA_LINK_NAME])
>  		return -EINVAL;
>  
> +	len = nla_len(attrs[TIPC_NLA_LINK_NAME]);
> +	if (len <= 0)
> +		return -EINVAL;
> +
>  	link_name = nla_data(attrs[TIPC_NLA_LINK_NAME]);
> +	len = min_t(int, len, TIPC_MAX_LINK_NAME);
> +	if (!memchr(link_name, '\0', len))
> +		return -EINVAL;

Should we just change the netlink policy for this attribute to
NLA_NUL_STRING, then?
