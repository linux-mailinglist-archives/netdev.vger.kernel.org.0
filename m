Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBAB2CF649
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 22:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730241AbgLDVhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 16:37:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:54596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729268AbgLDVhQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 16:37:16 -0500
Date:   Fri, 4 Dec 2020 13:36:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607117791;
        bh=U04B3pDX8jFTZKxagPn+lmF/MY9A/p0Uvp3pJNgnx8s=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=kohVDdvJOBJoL7UDt5bjD8I/yfGVRi8rYwIcC4E3D4wc82HuMQjS6sW7jNOxKPdFW
         KVEmFXx/wKk4BRbtlALz66BY3ZRsCwm6LCkuGbX0QCZERzp913WfV6WkRA1s71JYrs
         xuJjFd8mj2HQFux64nB1BEwdxb9W71AcloEMWFTc/NAFAUe4NIeWGKwxCbVL9a1fj7
         hbqBivV0EBhywARFiQMl3u6vHWmQ2bPOQ2u+o4HRyE8tdgo2BFjOY3py1eF9x/jAco
         B6xZZepnuaundzpZ+MZKSF8/1GLIZCqNfqyt7J8S8BxEU6BGPQTAmF8iceo8vADeZi
         5kPJAm2GR3JVA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrea Mayer <andrea.mayer@uniroma2.it>
Cc:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
Subject: Re: [net-next v4 0/8] seg6: add support for SRv6 End.DT4/DT6
 behavior
Message-ID: <20201204133629.19549345@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201202130517.4967-1-andrea.mayer@uniroma2.it>
References: <20201202130517.4967-1-andrea.mayer@uniroma2.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  2 Dec 2020 14:05:09 +0100 Andrea Mayer wrote:
> This patchset provides support for the SRv6 End.DT4 and End.DT6 (VRF mode)
> behaviors.
> 
> The SRv6 End.DT4 behavior is used to implement multi-tenant IPv4 L3 VPNs. It
> decapsulates the received packets and performs IPv4 routing lookup in the
> routing table of the tenant. The SRv6 End.DT4 Linux implementation leverages a
> VRF device in order to force the routing lookup into the associated routing
> table.
> The SRv6 End.DT4 behavior is defined in the SRv6 Network Programming [1].
> 
> The Linux kernel already offers an implementation of the SRv6 End.DT6 behavior
> which allows us to set up IPv6 L3 VPNs over SRv6 networks. This new
> implementation of DT6 is based on the same VRF infrastructure already exploited
> for implementing the SRv6 End.DT4 behavior. The aim of the new SRv6 End.DT6 in
> VRF mode consists in simplifying the construction of IPv6 L3 VPN services in
> the multi-tenant environment.
> Currently, the two SRv6 End.DT6 implementations (legacy and VRF mode)
> coexist seamlessly and can be chosen according to the context and the user
> preferences.
> 
> - Patch 1 is needed to solve a pre-existing issue with tunneled packets
>   when a sniffer is attached;
> 
> - Patch 2 improves the management of the seg6local attributes used by the
>   SRv6 behaviors;
> 
> - Patch 3 adds support for optional attributes in SRv6 behaviors;
> 
> - Patch 4 introduces two callbacks used for customizing the
>   creation/destruction of a SRv6 behavior;
> 
> - Patch 5 is the core patch that adds support for the SRv6 End.DT4
>   behavior;
> 
> - Patch 6 introduces the VRF support for SRv6 End.DT6 behavior;
> 
> - Patch 7 adds the selftest for SRv6 End.DT4 behavior;
> 
> - Patch 8 adds the selftest for SRv6 End.DT6 (VRF mode) behavior.
> 
> Regarding iproute2, the support for the new "vrftable" attribute, required by
> both SRv6 End.DT4 and End.DT6 (VRF mode) behaviors, is provided in a different
> patchset that will follow shortly.
> 
> I would like to thank David Ahern for his support during the development of
> this patchset.

Applied, thank you!
