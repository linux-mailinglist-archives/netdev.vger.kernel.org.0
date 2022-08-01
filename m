Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43B53586D6E
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 17:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233072AbiHAPIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 11:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiHAPIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 11:08:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF632AE26;
        Mon,  1 Aug 2022 08:08:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EFB06147B;
        Mon,  1 Aug 2022 15:08:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47B0C433C1;
        Mon,  1 Aug 2022 15:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659366519;
        bh=AqruWdRdzFUO73wzzBKn5xGprtjbDadpunKpXdhVebc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=tYO6GXrHSmgf6b5UQaNoTIguI0zkkMemEFQ6hijAg3nrK3UfBlhy2E7ZW/XQiJoqt
         JK26CNqSlHs46WPjTHiQGo/zPxY0XTa42EIph2gXg+xxT9ZjnXP5kLSm2D/xmlKZgB
         VpkuPuQzH28KgHkJoP/TbAYsxBaYFK0UXf72ADuzoHBjnngGbdmYnYxA+sefpYE9zC
         qtiWB83TVbbeqnUhMwvlVIY7D81qggakd6ueXzM1imWqaidHOaK+sa33aw6nV6CneJ
         9dOeezBvQN/bTw1eloPA9vhDe2jT+7f8ZDRI012YqVrHRnbLFq1x6k79W3BCx9JRN0
         MM1sHKdfRAz9Q==
Message-ID: <09ac06d6-4373-0953-5ed0-ed85ef25c999@kernel.org>
Date:   Mon, 1 Aug 2022 09:08:37 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH 1/2] neigh: fix possible DoS due to net iface start/stop
 loop
Content-Language: en-US
To:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        netdev@vger.kernel.org
Cc:     "Denis V. Lunev" <den@openvz.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yajun Deng <yajun.deng@linux.dev>,
        Roopa Prabhu <roopa@nvidia.com>, linux-kernel@vger.kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Konstantin Khorenko <khorenko@virtuozzo.com>, kernel@openvz.org
References: <20220729103559.215140-1-alexander.mikhalitsyn@virtuozzo.com>
 <20220729103559.215140-2-alexander.mikhalitsyn@virtuozzo.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220729103559.215140-2-alexander.mikhalitsyn@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/29/22 4:35 AM, Alexander Mikhalitsyn wrote:
> The patch proposed doing very simple thing. It drops only packets from

it does 2 things - adds a namespace check and a performance based change
with the way the list is walked.

> the same namespace in the pneigh_queue_purge() where network interface
> state change is detected. This is enough to prevent the problem for the
> whole node preserving original semantics of the code.
> 


> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index 54625287ee5b..213ec0be800b 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c

> @@ -386,8 +396,7 @@ static int __neigh_ifdown(struct neigh_table *tbl, struct net_device *dev,
>  	neigh_flush_dev(tbl, dev, skip_perm);
>  	pneigh_ifdown_and_unlock(tbl, dev);
>  
> -	del_timer_sync(&tbl->proxy_timer);

why are you removing this line too?

> -	pneigh_queue_purge(&tbl->proxy_queue);
> +	pneigh_queue_purge(&tbl->proxy_queue, dev_net(dev));
>  	return 0;
>  }
>  
