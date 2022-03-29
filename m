Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E22D4EAE88
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 15:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235942AbiC2Nd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 09:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbiC2Nd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 09:33:28 -0400
X-Greylist: delayed 481 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 29 Mar 2022 06:31:44 PDT
Received: from smtp80.iad3b.emailsrvr.com (smtp80.iad3b.emailsrvr.com [146.20.161.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67042BB15
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 06:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=openvpn.net;
        s=20170822-45nk5nwl; t=1648560222;
        bh=ZIawJsh2aU9+UK7aoECynf1SOo2XPzzueqTJc+Xz6UY=;
        h=Date:To:From:Subject:From;
        b=Rknl8c/OUVKTBDSh2x/FD1n3iCViUrX71mrqlZ0k0axpsvxVlOzEMZyG24OTh5I42
         93fb6HNJwWZxsQmEHBIVmHYNCZLCnVWXvqTbNqF0nIbGhuS1Xvb8tqZC8EDSfkgTiD
         cUyLRjIPtkcDnnNlC72SOjcskwZ80bVJj9kVg7oE=
X-Auth-ID: antonio@openvpn.net
Received: by smtp19.relay.iad3b.emailsrvr.com (Authenticated sender: antonio-AT-openvpn.net) with ESMTPSA id AD2F74015D;
        Tue, 29 Mar 2022 09:23:41 -0400 (EDT)
Message-ID: <3842df54-8323-e6e7-9a06-de1e78e099ae@openvpn.net>
Date:   Tue, 29 Mar 2022 15:24:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Xin Long <lucien.xin@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        network dev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>
References: <cover.1612342376.git.lucien.xin@gmail.com>
 <fc62f5e225f83d128ea5222cc752cb1c38c92304.1612342376.git.lucien.xin@gmail.com>
From:   Antonio Quartulli <antonio@openvpn.net>
Subject: Re: [PATCHv5 net-next 1/2] udp: call udp_encap_enable for v6 sockets
 when enabling encap
Organization: OpenVPN Inc.
In-Reply-To: <fc62f5e225f83d128ea5222cc752cb1c38c92304.1612342376.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Classification-ID: 2683d040-a805-4e5d-8846-bb0112bce186-1-1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

On 03/02/2021 09:54, Xin Long wrote:
> When enabling encap for a ipv6 socket without udp_encap_needed_key
> increased, UDP GRO won't work for v4 mapped v6 address packets as
> sk will be NULL in udp4_gro_receive().
> 
> This patch is to enable it by increasing udp_encap_needed_key for
> v6 sockets in udp_tunnel_encap_enable(), and correspondingly
> decrease udp_encap_needed_key in udpv6_destroy_sock().
> 

This is a non-negligible issue that other users (in or out of tree) may 
hit as well.

At OpenVPN we are developing a kernel device driver that has the same 
problem as UDP GRO. So far the only workaround is to let users upgrade 
to v5.12+.

I would like to propose to take this patch in stable releases.
Greg, is this an option?

Commit in the linux kernel is:
a4a600dd301ccde6ea239804ec1f19364a39d643

Thanks a lot.

Best Regards,

> v1->v2:
>    - add udp_encap_disable() and export it.
> v2->v3:
>    - add the change for rxrpc and bareudp into one patch, as Alex
>      suggested.
> v3->v4:
>    - move rxrpc part to another patch.
> 
> Acked-by: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>   drivers/net/bareudp.c    | 6 ------
>   include/net/udp.h        | 1 +
>   include/net/udp_tunnel.h | 3 +--
>   net/ipv4/udp.c           | 6 ++++++
>   net/ipv6/udp.c           | 4 +++-
>   5 files changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
> index 1b8f597..7511bca 100644
> --- a/drivers/net/bareudp.c
> +++ b/drivers/net/bareudp.c
> @@ -240,12 +240,6 @@ static int bareudp_socket_create(struct bareudp_dev *bareudp, __be16 port)
>   	tunnel_cfg.encap_destroy = NULL;
>   	setup_udp_tunnel_sock(bareudp->net, sock, &tunnel_cfg);
>   
> -	/* As the setup_udp_tunnel_sock does not call udp_encap_enable if the
> -	 * socket type is v6 an explicit call to udp_encap_enable is needed.
> -	 */
> -	if (sock->sk->sk_family == AF_INET6)
> -		udp_encap_enable();
> -
>   	rcu_assign_pointer(bareudp->sock, sock);
>   	return 0;
>   }
> diff --git a/include/net/udp.h b/include/net/udp.h
> index 01351ba..5ddbb42 100644
> --- a/include/net/udp.h
> +++ b/include/net/udp.h
> @@ -467,6 +467,7 @@ void udp_init(void);
>   
>   DECLARE_STATIC_KEY_FALSE(udp_encap_needed_key);
>   void udp_encap_enable(void);
> +void udp_encap_disable(void);
>   #if IS_ENABLED(CONFIG_IPV6)
>   DECLARE_STATIC_KEY_FALSE(udpv6_encap_needed_key);
>   void udpv6_encap_enable(void);
> diff --git a/include/net/udp_tunnel.h b/include/net/udp_tunnel.h
> index 282d10e..afc7ce7 100644
> --- a/include/net/udp_tunnel.h
> +++ b/include/net/udp_tunnel.h
> @@ -181,9 +181,8 @@ static inline void udp_tunnel_encap_enable(struct socket *sock)
>   #if IS_ENABLED(CONFIG_IPV6)
>   	if (sock->sk->sk_family == PF_INET6)
>   		ipv6_stub->udpv6_encap_enable();
> -	else
>   #endif
> -		udp_encap_enable();
> +	udp_encap_enable();
>   }
>   
>   #define UDP_TUNNEL_NIC_MAX_TABLES	4
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 69ea765..48208fb 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -596,6 +596,12 @@ void udp_encap_enable(void)
>   }
>   EXPORT_SYMBOL(udp_encap_enable);
>   
> +void udp_encap_disable(void)
> +{
> +	static_branch_dec(&udp_encap_needed_key);
> +}
> +EXPORT_SYMBOL(udp_encap_disable);
> +
>   /* Handler for tunnels with arbitrary destination ports: no socket lookup, go
>    * through error handlers in encapsulations looking for a match.
>    */
> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> index b9f3dfd..d754292 100644
> --- a/net/ipv6/udp.c
> +++ b/net/ipv6/udp.c
> @@ -1608,8 +1608,10 @@ void udpv6_destroy_sock(struct sock *sk)
>   			if (encap_destroy)
>   				encap_destroy(sk);
>   		}
> -		if (up->encap_enabled)
> +		if (up->encap_enabled) {
>   			static_branch_dec(&udpv6_encap_needed_key);
> +			udp_encap_disable();
> +		}
>   	}
>   
>   	inet6_destroy_sock(sk);

-- 
Antonio Quartulli
OpenVPN Inc.
