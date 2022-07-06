Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C225568C72
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 17:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232214AbiGFPOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 11:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbiGFPOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 11:14:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A4D23144
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 08:14:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8BC1B81AF1
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 15:14:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E2DC3411C;
        Wed,  6 Jul 2022 15:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657120459;
        bh=xDD55etx+dPiDvb0CqQYVLOzfYORnctiAqag8dtPv9M=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=gzrnH8sIqzgaLjDQYL2q+FxObS7jeho5sqePtK8237kNPLjBJ/WckH3rTCEN3SgZI
         GmCKTiuWuAQ+/CriGSA1owTr2ddrFBMmUGlTlDcyEgWV+Iw1EiHfPiP4+BRSefc6j0
         AxBH/5DMJchddWi3qXX6OompdlQ5ZEPFmqEbsInHQpNoRlDvM/0oFpcs419aO5BIFI
         IPgWCzh381xwSIr/jKi1Df4te8E57NOhFHrxQljFiiksWybt/5UgYIGVViEwbvaAP+
         blHSBGSam48gYW55hyal2++KG10CKycOPrTL7kY/1jD5KG30iY19JE9atJqeDQuxl8
         FjR92ELnGv6uA==
Message-ID: <7be18dc0-4d2c-283d-eedb-123ab99197d3@kernel.org>
Date:   Wed, 6 Jul 2022 09:14:17 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH] net: Fix IP_UNICAST_IF option behavior for connected
 sockets
Content-Language: en-US
To:     Richard Gobert <richardbgobert@gmail.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
References: <20220627085219.GA9597@debian>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220627085219.GA9597@debian>
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

On 6/27/22 2:52 AM, Richard Gobert wrote:
> The IP_UNICAST_IF socket option is used to set the outgoing interface for
> outbound packets.
> The IP_UNICAST_IF socket option was added as it was needed by the Wine
> project, since no other existing option (SO_BINDTODEVICE socket option,
> IP_PKTINFO socket option or the bind function) provided the needed
> characteristics needed by the IP_UNICAST_IF socket option. [1]
> The IP_UNICAST_IF socket option works well for unconnected sockets, that
> is, the interface specified by the IP_UNICAST_IF socket option is taken
> into consideration in the route lookup process when a packet is being
> sent.
> However, for connected sockets, the outbound interface is chosen when
> connecting the socket, and in the route lookup process which is done when
> a packet is being sent, the interface specified by the IP_UNICAST_IF
> socket option is being ignored.
> 
> This inconsistent behavior was reported and discussed in an issue opened
> on systemd's GitHub project [2]. Also, a bug report was submitted in the
> kernel's bugzilla [3].
> 
> To understand the problem in more detail, we can look at what happens
> for UDP packets over IPv4 (The same analysis was done separately in
> the referenced systemd issue).
> When a UDP packet is sent the udp_sendmsg function gets called and the
> following happens:
> 
> 1. The oif member of the struct ipcm_cookie ipc (which stores the output
> interface of the packet) is initialized by the ipcm_init_sk function to
> inet->sk.sk_bound_dev_if (the device set by the SO_BINDTODEVICE socket
> option).
> 
> 2. If the IP_PKTINFO socket option was set, the oif member gets overridden
> by the call to the ip_cmsg_send function.
> 
> 3. If no output interface was selected yet, the interface specified by the
> IP_UNICAST_IF socket option is used.
> 
> 4. If the socket is connected and no destination address is specified in
> the send function, the struct ipcm_cookie ipc is not taken into
> consideration and the cached route, that was calculated in the connect
> function is being used.
> 
> Thus, for a connected socket, the IP_UNICAST_IF sockopt isn't taken into
> consideration.
> 
> This patch corrects the behavior of the IP_UNICAST_IF socket option for
> connect()ed sockets by taking into consideration the IP_UNICAST_IF sockopt
> when connecting the socket.
> 
> In order to avoid reconnecting the socket, this option is still ignored 
> when applied on an already connected socket until connect() is called
> again by the user.
> 
> Change the __ip4_datagram_connect function, which is called during socket
> connection, to take into consideration the interface set by the
> IP_UNICAST_IF socket option, in a similar way to what is done in the
> udp_sendmsg function.
> 
> [1] https://lore.kernel.org/netdev/1328685717.4736.4.camel@edumazet-laptop/T/
> [2] https://github.com/systemd/systemd/issues/11935#issuecomment-618691018
> [3] https://bugzilla.kernel.org/show_bug.cgi?id=210255
> 
> Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
> ---
>  net/ipv4/datagram.c | 2 ++
>  1 file changed, 2 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

if the maintainers decide to pick it up.
