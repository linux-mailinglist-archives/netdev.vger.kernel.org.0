Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D55C6534044
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 17:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241850AbiEYPTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 11:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236085AbiEYPTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 11:19:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440881403E
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 08:19:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE4A0B81DDA
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 15:19:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A67CC385B8;
        Wed, 25 May 2022 15:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653491974;
        bh=I0GBiumw6VdUPgUOGLUA+7POQ46FYz4nedxE8B5qmhQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=lqoOLivuf+0elic3aynjRTGxhOoE1V9PZUI6SSYFMMQVpavWvUD+6r7tBRmYHi0gf
         b/k5sECKgxuDsMlZMIO580M8k28iuo6rAtMIt2m03j1m9hg8/wVenqx3yTy9NGS2GI
         gSSJr08ALFqWDYabJE0dupwKq5O8YmidgP8lU/W7jFM/W/nhpTBmdc6KZHcM26jybl
         rHS5wZkii3Cn3SrFhSHVipk2txXvGY6GAADvBvQqcL5W8gfKPkYIyNK0DMUzwjkR/r
         9O11YN+fZgmTQ6qATCSl9eaTzxqHDCE5MWQUD5F2ntgeBIiKiLXfiTuyeQ/lZsRVOJ
         KleK5dTyc+ewA==
Message-ID: <d8a28a59-79ca-e1fc-7768-a91f8033ce0e@kernel.org>
Date:   Wed, 25 May 2022 09:19:33 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH v2 net-next] net: neigh: add netlink filtering based on
 LLADDR for dump
Content-Language: en-US
To:     Florent Fourcot <florent.fourcot@wifirst.fr>,
        netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>
References: <20220509205646.20814-1-florent.fourcot@wifirst.fr>
 <b84e51fa-f410-956e-7304-7a49d297f254@kernel.org>
 <8653ac99-4c5a-b596-7109-7622c125088a@wifirst.fr>
 <af7b9565-ca70-0c36-4695-a0705825468d@wifirst.fr>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <af7b9565-ca70-0c36-4695-a0705825468d@wifirst.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/24/22 2:49 PM, Florent Fourcot wrote:
> Hello David,
> 
> This patch has been marked as rejected after your comment.
> Could you perhaps have a second look on it? And on my response above? I
> still think that my patch is relevant and add a currently not available
> feature.
> 
> I can work on alternative approach if necessary. Since neighbour tables
> are sometimes huge, performance overhead of userspace filtering for a
> simple MAC address lookup is currently high. And GET does not provide
> same feature.
> 

Kernel side filtering has always been kept to simple, coarse grained
checks - like a device index or upper device index. It's a fine line
managing kernel cycles holding the rtnl vs cycles shipping the data to
userspace. e.g., a memcmp has a higher cost than a dev->index
comparison. I see the point about GET only - potential for many matches
and a lookup of the ll address is basically a filtered dump. Mixed
thoughts on whether this should be merged.
