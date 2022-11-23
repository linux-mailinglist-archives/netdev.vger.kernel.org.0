Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBD96369B3
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 20:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239802AbiKWTOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 14:14:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239796AbiKWTOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 14:14:37 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF77A8152;
        Wed, 23 Nov 2022 11:14:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 200BECE264A;
        Wed, 23 Nov 2022 19:14:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 929C3C433C1;
        Wed, 23 Nov 2022 19:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669230873;
        bh=KbrG34cmabGhC68gT1YoUcErf4n0xzOwCvNVvok0PiI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FQ3vf9Yt/Tqn291D7wwpELSG8JKOA34K8tluIpaiJn5Mqb2sX9jb7Dy0WZmPtFAm9
         ggumioiygzhDro/VU74pJOJInsUJXa9LeTDt25ipb92OLGeEQxZIL8tJm021oclbS+
         +iT7d9OCNwS5e4UuNYq/IEoo0IXSjaQIwr4RLQT+HXwzE/jTNU/PS1grcY6NJ5/Zxi
         YpBf2YB1cZHkwtl7wwP3TzNVknTtC6dtsvWDnAnRNy9UYnhdq7QhUTZq/7NqCPXHWN
         q+/EX7kviPpHFA7vXjHdGM/6I4/WHLQpSuF27YqxpdtOSq+LDxbGR5HVQH/n9FZwcQ
         inkC8LYvJUpVg==
Date:   Wed, 23 Nov 2022 11:14:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Subject: Re: [xdp-hints] [PATCH bpf-next v2 6/8] mlx4: Introduce
 mlx4_xdp_buff wrapper for xdp_buff
Message-ID: <20221123111431.7b54668e@kernel.org>
In-Reply-To: <CAKH8qBuF_1UoUPzh_X6FMrJ61zCNDroqSuc-Pp2uH7Q4azmN8Q@mail.gmail.com>
References: <20221121182552.2152891-1-sdf@google.com>
        <20221121182552.2152891-7-sdf@google.com>
        <874jupviyc.fsf@toke.dk>
        <CAKH8qBuF_1UoUPzh_X6FMrJ61zCNDroqSuc-Pp2uH7Q4azmN8Q@mail.gmail.com>
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

On Wed, 23 Nov 2022 10:26:41 -0800 Stanislav Fomichev wrote:
> > This embedding trick works for drivers that put xdp_buff on the stack,
> > but mlx5 supports XSK zerocopy, which uses the xsk_buff_pool for
> > allocating them. This makes it a bit awkward to do the same thing there;
> > and since it's probably going to be fairly common to do something like
> > this, how about we just add a 'void *drv_priv' pointer to struct
> > xdp_buff that the drivers can use? The xdp_buff already takes up a full
> > cache line anyway, so any data stuffed after it will spill over to a new
> > one; so I don't think there's much difference performance-wise.  
> 
> I guess the alternative is to extend xsk_buff_pool with some new
> argument for xdp_buff tailroom? (so it can kmalloc(sizeof(xdp_buff) +
> xdp_buff_tailroom))
> But it seems messy because there is no way of knowing what the target
> device's tailroom is, so it has to be a user setting :-/
> I've started with a priv pointer in xdp_buff initially, it seems fine
> to go back. I'll probably convert veth/mlx4 to the same mode as well
> to avoid having different approaches in different places..

Can we not do this please? Add 16B of "private driver space" after
the xdp_buff in xdp_buff_xsk (we have 16B to full cacheline), the
drivers decide how they use it. Drivers can do BUILD_BUG_ON() for their
expected size and cast that to whatever struct they want. This is how
various offloads work, the variable size tailroom would be an over
design IMO.

And this way non XSK paths can keep its normal typing.

> > I'll send my patch to add support to mlx5 (using the drv_priv pointer
> > approach) separately.  
> 
> Saw them, thanks! Will include them in v3+.
