Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BAEB4D5C1B
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 08:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345209AbiCKHQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 02:16:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239140AbiCKHQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 02:16:26 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 793AC1AA05E;
        Thu, 10 Mar 2022 23:15:24 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1B6CD68AFE; Fri, 11 Mar 2022 08:15:19 +0100 (CET)
Date:   Fri, 11 Mar 2022 08:15:18 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Mingbao Sun <sunmingbao@tom.com>
Cc:     Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        tyler.sun@dell.com, ping.gan@dell.com, yanxiu.cai@dell.com,
        libin.zhang@dell.com, ao.sun@dell.com
Subject: Re: [PATCH 2/3] nvme-tcp: support specifying the congestion-control
Message-ID: <20220311071518.GB18222@lst.de>
References: <20220311030113.73384-1-sunmingbao@tom.com> <20220311030113.73384-3-sunmingbao@tom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220311030113.73384-3-sunmingbao@tom.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 11, 2022 at 11:01:12AM +0800, Mingbao Sun wrote:
> +		case NVMF_OPT_TCP_CONGESTION:
> +			p = match_strdup(args);
> +			if (!p) {
> +				ret = -ENOMEM;
> +				goto out;
> +			}
> +
> +			kfree(opts->tcp_congestion);
> +			opts->tcp_congestion = p;

We'll need to check that the string is no loner than TCP_CA_NAME_MAX
somewhere.

>  
> +	if (nctrl->opts->mask & NVMF_OPT_TCP_CONGESTION) {
> +		ret = tcp_set_congestion_control(queue->sock->sk,
> +						 nctrl->opts->tcp_congestion,
> +						 true, true);

This needs to be called under lock_sock() protection.  Maybe also
add an assert to tcp_set_congestion_control to enforce that.
