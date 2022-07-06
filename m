Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43FF656935C
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 22:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233573AbiGFUdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 16:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233466AbiGFUdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 16:33:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 502782183C
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 13:33:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05520B81E67
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 20:33:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD6BC3411C;
        Wed,  6 Jul 2022 20:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657139615;
        bh=V8RP1r558uUc5FQP5JY3eiHbmtJUwIlGz3bU0GZrZiM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nTN1m9U5q0PmCH/drHZ9tNq5QtSL4yjKQiFTuo+OLGcikUcEwEToUwLxV+U3qofLj
         r233uAQpKDFKP6cXHj/0Y8La1RnxVKoTQVq+qp/GsSNAPmkfZkUsgzWfE+HALdiveu
         W0Bdg1hDor9xSuDgK/Uut0l6L+x+35y4KSZciS3StICSEr6ojqN/7VOyyHRNLFllMf
         d1X6IFv/Vrf6QlbKht5f+q8MNQZbnm25CWytJ3Rzz3jzpnyvCwv//wKfjgZyNupqLw
         iT2mgMNHr22/tVprBv+3W/uSEYU5FtTSCNtvyr4O1CpkqJ7oHsS5N9cTD9sONPfUDF
         xpsHTMkL/WEVg==
Date:   Wed, 6 Jul 2022 13:33:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hoang Le <hoang.h.le@dektech.com.au>
Cc:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        tung.q.nguyen@dektech.com.au, pabeni@redhat.com,
        edumazet@google.com, tipc-discussion@lists.sourceforge.net,
        netdev@vger.kernel.org, davem@davemloft.net,
        syzbot+a73d24a22eeeebe5f244@syzkaller.appspotmail.com
Subject: Re: [net] tipc: fix uninit-value in tipc_nl_node_reset_link_stats
Message-ID: <20220706133334.0a6acab5@kernel.org>
In-Reply-To: <20220706034752.5729-1-hoang.h.le@dektech.com.au>
References: <20220706034752.5729-1-hoang.h.le@dektech.com.au>
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

On Wed,  6 Jul 2022 10:47:52 +0700 Hoang Le wrote:
> diff --git a/net/tipc/node.c b/net/tipc/node.c
> index b48d97cbbe29..80885780caa2 100644
> --- a/net/tipc/node.c
> +++ b/net/tipc/node.c
> @@ -2574,8 +2574,10 @@ int tipc_nl_node_reset_link_stats(struct sk_buff *skb, struct genl_info *info)
>  	if (!attrs[TIPC_NLA_LINK_NAME])
>  		return -EINVAL;
>  
> -	link_name = nla_data(attrs[TIPC_NLA_LINK_NAME]);
> +	if (nla_len(attrs[TIPC_NLA_LINK_NAME]) <= 0)
> +		return -EINVAL;
>  
> +	link_name = nla_data(attrs[TIPC_NLA_LINK_NAME]);
>  	err = -EINVAL;
>  	if (!strcmp(link_name, tipc_bclink_name)) {
>  		err = tipc_bclink_reset_stats(net, tipc_bc_sndlink(net));

I think you misunderstood me. Let me try to explain in more detail.

AFAICT the attrs in this function get validated using the
tipc_nl_link_policy:

https://elixir.bootlin.com/linux/v5.19-rc4/source/net/tipc/node.c#L2567

This policy specifies the type for TIPC_NLA_LINK_NAME as NLA_STRING:

https://elixir.bootlin.com/linux/v5.19-rc4/source/net/tipc/netlink.c#L91

Therefore we can assume that the attribute is a valid (but not
necessarily null-terminated) string. Otherwise
nla_parse_nested_deprecated() would have returned an error.

The code for NLA_STRING validation is here:

https://elixir.bootlin.com/linux/v5.19-rc4/source/lib/nlattr.c#L437

So we can already assume that the attribute is not empty.

The bug you're fixing is that the string is not null-terminated, 
so strcmp() can read past the end of the attribute.

What I was trying to suggest is that you change the policy from
NLA_STRING to NLA_NUL_STRING, which also checks that the string 
is NULL-terminated.

Please note that it'd be a slight uAPI change, and could break
applications which expect kernel to not require null-termination.
Perhaps tipc developers can guide us on how likely that is.
Alternative is to use strncmp(..., nla_len(attr)).
