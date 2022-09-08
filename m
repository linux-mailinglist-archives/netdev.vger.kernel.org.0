Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A51F55B1187
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 02:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiIHAoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 20:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiIHAoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 20:44:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE77CBFC57;
        Wed,  7 Sep 2022 17:44:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48D7261B18;
        Thu,  8 Sep 2022 00:44:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D131C433D6;
        Thu,  8 Sep 2022 00:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662597857;
        bh=g5nR0cX0QPYzLJn1sJLMWOJPxVQFmzSG3JCsEpMQcqA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=S5OUTbCwVAhMJxMa7IGDJMDUmzz8roBfoBf3nVOAiw210yURvlh3PIKH6NhXlRpo4
         7xhR1uY9gn8axS/y26G9VJKiaRaHhmNvkZF4jm/vTkxSvu8gqXH/n+Yy8lOvXjGpPQ
         60c6Svd0wV9asXyFsVrQnkkUTS7fsvxvyXIR6NeUmcmVif0KXfQNYxsKGzpqKUaTor
         Zmpiy2Z6lD/S6DtExbJrBj8Zgl6nyQWY9LwLOIVRvbHDeKKKcXCnimMWtWHCZ4LZbj
         HT5lEWVtdVf82PWm5gGg/ReODFsX3x2SAfFK2cHxBAkvSF3OfghCMVZKdX/b2J/Gaz
         QyZnOz599W87A==
Message-ID: <e1e6519f-2e77-05c1-697c-56b174addc6e@kernel.org>
Date:   Wed, 7 Sep 2022 18:44:16 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH v3 0/6] TUN/VirtioNet USO features support.
Content-Language: en-US
To:     Andrew Melnychenko <andrew@daynix.com>, edumazet@google.com,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jasowang@redhat.com, mst@redhat.com, pabeni@redhat.com,
        yoshfuji@linux-ipv6.org
Cc:     yan@daynix.com, yuri.benditovich@daynix.com
References: <20220907125048.396126-1-andrew@daynix.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220907125048.396126-1-andrew@daynix.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-11.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/7/22 6:50 AM, Andrew Melnychenko wrote:
> Added new offloads for TUN devices TUN_F_USO4 and TUN_F_USO6.
> Technically they enable NETIF_F_GSO_UDP_L4
> (and only if USO4 & USO6 are set simultaneously).
> It allows the transmission of large UDP packets. 

Please spell out USO at least once in the cover letter to make sure the
acronym is clear.

> 
> Different features USO4 and USO6 are required for qemu where Windows guests can
> enable disable USO receives for IPv4 and IPv6 separately.
> On the other side, Linux can't really differentiate USO4 and USO6, for now.

Why is that and what is needed for Linux to differentiate between the 2
protocols?

> For now, to enable USO for TUN it requires enabling USO4 and USO6 together.
> In the future, there would be a mechanism to control UDP_L4 GSO separately.
> 
> New types for virtio-net already in virtio-net specification:
> https://github.com/oasis-tcs/virtio-spec/issues/120
> 
> Test it WIP Qemu https://github.com/daynix/qemu/tree/USOv3
> 
> Andrew (5):
>   uapi/linux/if_tun.h: Added new offload types for USO4/6.
>   driver/net/tun: Added features for USO.
>   uapi/linux/virtio_net.h: Added USO types.
>   linux/virtio_net.h: Support USO offload in vnet header.
>   drivers/net/virtio_net.c: Added USO support.
> 
> Andrew Melnychenko (1):
>   udp: allow header check for dodgy GSO_UDP_L4 packets.
> 
>  drivers/net/tap.c               | 10 ++++++++--
>  drivers/net/tun.c               |  8 +++++++-
>  drivers/net/virtio_net.c        | 19 +++++++++++++++----
>  include/linux/virtio_net.h      |  9 +++++++++
>  include/uapi/linux/if_tun.h     |  2 ++
>  include/uapi/linux/virtio_net.h |  5 +++++
>  net/ipv4/udp_offload.c          |  2 +-
>  7 files changed, 47 insertions(+), 8 deletions(-)
> 

