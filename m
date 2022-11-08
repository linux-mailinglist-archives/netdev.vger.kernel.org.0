Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D257D620840
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 05:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232075AbiKHE3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 23:29:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231659AbiKHE3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 23:29:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 354E01A839
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 20:29:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C598B818B8
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 04:29:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F95CC433C1;
        Tue,  8 Nov 2022 04:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667881779;
        bh=isIrJBxi1WI0d1jUi19cA8eiPeKy3z90tsGFGFx48mE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fct6cDqd7PynAHlSgy/LthgwVsmHDwP1J//+XWxrzF2ysktHJheAVHJgpNGbW4whe
         EpcYxZ9ChKPT3j+SX7LmZZB5IHZ2mt9+T5Gp2/77FE/jk3d0chVjrykFnI/6GKcce/
         gq9VOFpmgL55Rp/Apgj+4adoyZouFKOiba64sX9UFlh1tyUFKWUGmg5bbBc0SiBFZO
         8Jt6AuYlrE10hdoqRS2MZEySYMT8QUNGIzPjn7He6kB9yVLFFfKj14+WkCAq1YkIbz
         1+yzDbrWy4jibHMoniu5DnqduBXULrS3djCFLd9JF3/CXX2613Ifsx25ddMYIew2Cq
         QH/lnqMbe4SDg==
Date:   Mon, 7 Nov 2022 20:29:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, idosch@idosch.org, bigeasy@linutronix.de,
        imagedong@tencent.com, kuniyu@amazon.com, petrm@nvidia.com
Subject: Re: [patch net-next 1/2] net: introduce a helper to move notifier
 block to different namespace
Message-ID: <20221107202937.6ec5474c@kernel.org>
In-Reply-To: <20221107145213.913178-2-jiri@resnulli.us>
References: <20221107145213.913178-1-jiri@resnulli.us>
        <20221107145213.913178-2-jiri@resnulli.us>
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

On Mon,  7 Nov 2022 15:52:12 +0100 Jiri Pirko wrote:
> +void __move_netdevice_notifier_net(struct net *src_net, struct net *dst_net,
> +				   struct notifier_block *nb)
> +{
> +	__unregister_netdevice_notifier_net(src_net, nb);
> +	__register_netdevice_notifier_net(dst_net, nb, true);
> +}

'static' missing

> +void move_netdevice_notifier_net(struct net *src_net, struct net *dst_net,
> +				 struct notifier_block *nb)
> +{
> +	rtnl_lock();
> +	__move_netdevice_notifier_net(src_net, dst_net, nb);
> +	rtnl_unlock();
> +}
> +EXPORT_SYMBOL(move_netdevice_notifier_net);

Do we need to export this?  Maybe let's wait for a module user?
