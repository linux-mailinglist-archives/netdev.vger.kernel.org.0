Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 916524AC7F5
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236082AbiBGRv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:51:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236842AbiBGRon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:44:43 -0500
X-Greylist: delayed 176 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Feb 2022 09:44:43 PST
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.164])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A2FAC0401D9
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 09:44:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1644255701;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=cv+wHq6STQlbGV1k5/wWk5bkAyJ9s7GzLsoBeS1Q7FM=;
    b=Kyd5cfVe6ah0PnHPNlvqn1BFP4dNexVd1YGRNbs5a+D/L36hkZPU7cMg5eDruBqI4B
    SoIJ+nPN4Zm5Vs0GfS0sf07LnmWvzfTpJlJ7JsBW4fNIYPF3EisDx8iw1J9feIbu2ux2
    WwlRNHYoCT13je2otQrkhTWFr4sSPmwsht84aFzMJcUr35Zk082y6EtShWxx0RfxJ8bL
    zX5s1tRKRxqKsk7ZKUt2RWel18iXb8op4LSGqPiX8DLPKavNMBHGHIWcf62fOUbTFdAA
    qf0ZLRliZe/4SVF3q1j1hKD7sLZcMpN72QiO1EDXBGLKL7ns9F8DUxeTfFBy7VgXWqq1
    O1/w==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdd0DIgVuBOfXTKq7w=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfa:f900::bd7]
    by smtp.strato.de (RZmta 47.39.0 AUTH)
    with ESMTPSA id L7379cy17HffJNb
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 7 Feb 2022 18:41:41 +0100 (CET)
Message-ID: <c81703cb-a2b1-4a45-3c5f-0833576f4785@hartkopp.net>
Date:   Mon, 7 Feb 2022 18:41:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next 09/11] can: gw: switch cangw_pernet_exit() to
 batch mode
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
References: <20220207171756.1304544-1-eric.dumazet@gmail.com>
 <20220207171756.1304544-10-eric.dumazet@gmail.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20220207171756.1304544-10-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 07.02.22 18:17, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> cleanup_net() is competing with other rtnl users.
> 
> Avoiding to acquire rtnl for each netns before calling
> cgw_remove_all_jobs() gives chance for cleanup_net()
> to progress much faster, holding rtnl a bit longer.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Oliver Hartkopp <socketcan@hartkopp.net>
> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> ---
>   net/can/gw.c | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/net/can/gw.c b/net/can/gw.c
> index d8861e862f157aec36c417b71eb7e8f59bd064b9..24221352e059be9fb9aca3819be6a7ac4cdef144 100644
> --- a/net/can/gw.c
> +++ b/net/can/gw.c
> @@ -1239,16 +1239,19 @@ static int __net_init cangw_pernet_init(struct net *net)
>   	return 0;
>   }
>   
> -static void __net_exit cangw_pernet_exit(struct net *net)
> +static void __net_exit cangw_pernet_exit_batch(struct list_head *net_list)
>   {
> +	struct net *net;
> +
>   	rtnl_lock();
> -	cgw_remove_all_jobs(net);
> +	list_for_each_entry(net, net_list, exit_list)
> +		cgw_remove_all_jobs(net);

Instead of removing the jobs for ONE net namespace it seems you are 
remove removing the jobs for ALL net namespaces?

Looks wrong to me.

Best regards,
Oliver


>   	rtnl_unlock();
>   }
>   
>   static struct pernet_operations cangw_pernet_ops = {
>   	.init = cangw_pernet_init,
> -	.exit = cangw_pernet_exit,
> +	.exit_batch = cangw_pernet_exit_batch,
>   };
>   
>   static __init int cgw_module_init(void)
