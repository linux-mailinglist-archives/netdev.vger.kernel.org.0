Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 839996CFA13
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 06:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjC3ESz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 00:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjC3ESi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 00:18:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F51859FD;
        Wed, 29 Mar 2023 21:18:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EB54B81E4A;
        Thu, 30 Mar 2023 04:18:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A42D6C433EF;
        Thu, 30 Mar 2023 04:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680149908;
        bh=A3OE1fMs/XU35BYBG6uCfPnuEYKxavSEaRQvNf7OjwU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=a555VP3j+/IIpmuAZEv0I0CF6txP232GoRYTgzmyPbGMVyrJm38366WPT8USNaHDk
         OLss2aNaDtH9lL7jIH6uEb3F674qtbQNOUBPFcoxcPfO/+zDpcAcsNnO1Q8NLORdy8
         rFZPZLd99GGh6KD0SIkf3u4WCHxwmll+QLytD3neP3uHKGj2TSDHGNy3E0FGirf7Z4
         KheLbkMwNBZKr6jc9f+4+VP9GRS65HtWg/SFaQC/+bmRpR8H7I/ID3yLEXyAT5M7qG
         ktguB56CWftQ0SOqAu+DX4tWG5Ocj0k/lt7asiDLQfEBEban3eLYUaLQHcjQN/gR9I
         h6JTT5jU/rjsA==
Date:   Wed, 29 Mar 2023 21:18:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: Re: [PATCH 02/16] virtio_net: move struct to header file
Message-ID: <20230329211826.0657f947@kernel.org>
In-Reply-To: <20230328092847.91643-3-xuanzhuo@linux.alibaba.com>
References: <20230328092847.91643-1-xuanzhuo@linux.alibaba.com>
        <20230328092847.91643-3-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Mar 2023 17:28:33 +0800 Xuan Zhuo wrote:
> diff --git a/drivers/net/virtio/virtnet.h b/drivers/net/virtio/virtnet.h
> new file mode 100644
> index 000000000000..778a0e6af869
> --- /dev/null
> +++ b/drivers/net/virtio/virtnet.h
> @@ -0,0 +1,184 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#ifndef __VIRTNET_H__
> +#define __VIRTNET_H__
> +
> +#include <linux/ethtool.h>
> +#include <linux/average.h>

I don't want to nit pick too much but this header is missing a lot of
includes / forward declarations. At the same time on a quick look I
didn't spot anything that'd require linux/ethtool.h

> diff --git a/drivers/net/virtio/virtnet.c b/drivers/net/virtio/virtnet.c
> index e2560b6f7980..5ca354e29483 100644
> --- a/drivers/net/virtio/virtnet.c
> +++ b/drivers/net/virtio/virtnet.c
> @@ -6,7 +6,6 @@
>  //#define DEBUG
>  #include <linux/netdevice.h>
>  #include <linux/etherdevice.h>
> -#include <linux/ethtool.h>
>  #include <linux/module.h>
>  #include <linux/virtio.h>
>  #include <linux/virtio_net.h>
> @@ -16,13 +15,14 @@
>  #include <linux/if_vlan.h>
>  #include <linux/slab.h>
>  #include <linux/cpu.h>
> -#include <linux/average.h>
>  #include <linux/filter.h>
>  #include <linux/kernel.h>
>  #include <net/route.h>
>  #include <net/xdp.h>
>  #include <net/net_failover.h>

And you shouldn't remove includes if the code needs them just because
they get pulled in indirectly.
