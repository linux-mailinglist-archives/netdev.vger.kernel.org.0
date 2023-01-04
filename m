Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 808C565D2F5
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 13:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239248AbjADMnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 07:43:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234944AbjADMnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 07:43:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16623186CE;
        Wed,  4 Jan 2023 04:43:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B64D1B8162F;
        Wed,  4 Jan 2023 12:43:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9CEAC433EF;
        Wed,  4 Jan 2023 12:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672836226;
        bh=gKK35ke75uzbLNdiFo+ZUF6+OSLS2q0DB62aiLXqFus=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R/7nfHYE0649pnd56Dza8eBumthC+1bmiU/8A0efpKWDA9tLXbh+bR/ew+v+6yt7S
         r98T4XdbtBoNszBgq6/jjGeVS955ekatwSuOgQ1l1gBR4yVM8M/H57jlug9U8wYQrd
         rhqBIzXzaf6LhifUtNuy4PDCFiCNOYwIwU6c2XNs=
Date:   Wed, 4 Jan 2023 13:43:43 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tudor Ambarus <tudor.ambarus@linaro.org>
Cc:     stable@vger.kernel.org, willemdebruijn.kernel@gmail.com,
        mst@redhat.com, jasowang@redhat.com, edumazet@google.com,
        virtualization@lists.linux-foundation.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        willemb@google.com, syzkaller@googlegroups.com,
        liuhangbin@gmail.com, linux-kernel@vger.kernel.org,
        joneslee@google.com
Subject: Re: [PATCH 0/2] net/af_packet: Fix kernel BUG in __skb_gso_segment
Message-ID: <Y7V0f77yhwYplQQz@kroah.com>
References: <20221222083545.1972489-1-tudor.ambarus@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221222083545.1972489-1-tudor.ambarus@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 22, 2022 at 10:35:43AM +0200, Tudor Ambarus wrote:
> The series is intended for stable@vger.kernel.org # 5.4+
> 
> Syzkaller reported the following bug on linux-5.{4, 10, 15}.y:
> https://syzkaller.appspot.com/bug?id=ce5575575f074c33ff80d104f5baee26f22e95f5
> 
> The upstream commit that introduces this bug is:
> 1ed1d5921139 ("net: skip virtio_net_hdr_set_proto if protocol already set")
> 
> Upstream fixes the bug with the following commits, one of which introduces
> new support:
> e9d3f80935b6 ("net/af_packet: make sure to pull mac header")
> dfed913e8b55 ("net/af_packet: add VLAN support for AF_PACKET SOCK_RAW GSO") 
> 
> The additional logic and risk backported seems manageable.
> 
> The blammed commit introduces a kernel BUG in __skb_gso_segment for
> AF_PACKET SOCK_RAW GSO VLAN tagged packets. What happens is that
> virtio_net_hdr_set_proto() exists early as skb->protocol is already set to
> ETH_P_ALL. Then in packet_parse_headers() skb->protocol is set to
> ETH_P_8021AD, but neither the network header position is adjusted, nor the
> mac header is pulled. Thus when we get to validate the xmit skb and enter
> skb_mac_gso_segment(), skb->mac_len has value 14, but vlan_depth gets
> updated to 18 after skb_network_protocol() is called. This causes the
> BUG_ON from __skb_pull(skb, vlan_depth) to be hit, as the mac header has
> not been pulled yet.
> 
> The fixes from upstream backported cleanly without conflicts. I updated
> the commit message of the first patch to describe the problem encountered,
> and added Cc, Fixes, Reported-by and Tested-by tags. For the second patch
> I just added Cc to stable indicating the versions to be fixed, and added
> my Tested and Signed-off-by tags.
> 
> I tested the patches on linux-5.{4, 10, 15}.y.
> 
> Eric Dumazet (1):
>   net/af_packet: make sure to pull mac header
> 
> Hangbin Liu (1):
>   net/af_packet: add VLAN support for AF_PACKET SOCK_RAW GSO
> 
>  net/packet/af_packet.c | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)

Now queued up, thanks.

greg k-h
