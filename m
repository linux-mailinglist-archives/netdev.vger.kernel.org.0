Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 640F85F52FB
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 12:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiJEK5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 06:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiJEK5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 06:57:24 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2B16AA3F;
        Wed,  5 Oct 2022 03:57:22 -0700 (PDT)
Received: from [IPV6:2003:e9:d724:a710:a294:cd8d:ff93:7c57] (p200300e9d724a710a294cd8dff937c57.dip0.t-ipconnect.de [IPv6:2003:e9:d724:a710:a294:cd8d:ff93:7c57])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 3CB3BC040D;
        Wed,  5 Oct 2022 12:57:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1664967440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qJuvd9GyyxrOcK+Txh/TI4nlVjPKD52wmljtPw6SviQ=;
        b=W4h9xosbHfRHtOw96Wt/o08+k9vBEbs+bGaLbLMazEczdK7HQOeuH1pm2VUkPOQ4+C0slx
        Gz5yq/uao/wEe0hE3Gn4A1irea0rxz5r/Qutqu3yqWtO5lmR/2kH3rgeCj9Uo2G/TOF+Qm
        06ff9ftobWrfgV42tBrGpm34ZyDmBmXeNjfdNmp4ric5pUNl679ppAbqZ1ZBczb/ItXJeu
        24PfmOu/nKGQhdttrfS5LEhjVDUAcEmYmOFvuwiEG97XnOkdZ3LErzWmB8hiuZk1aEY5pg
        Nr0IKWZuuP5UkdWrBUyLwn+efNqdDNuVjQodUX2LV+Q5V+OuM6gEcQyjRCxgQQ==
Message-ID: <3f77669d-7238-b1f8-a37c-302e68a8962a@datenfreihafen.org>
Date:   Wed, 5 Oct 2022 12:57:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH net 1/2] Revert "net/ieee802154: reject zero-sized
 raw_sendmsg()"
Content-Language: en-US
To:     Alexander Aring <aahringo@redhat.com>,
        penguin-kernel@i-love.sakura.ne.jp
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
References: <20221005014750.3685555-1-aahringo@redhat.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20221005014750.3685555-1-aahringo@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 05.10.22 03:47, Alexander Aring wrote:
> This reverts commit 3a4d061c699bd3eedc80dc97a4b2a2e1af83c6f5.
> 
> There is a v2 which does return zero if zero length is given.
> 
> Signed-off-by: Alexander Aring <aahringo@redhat.com>
> ---
>   net/ieee802154/socket.c | 3 ---
>   1 file changed, 3 deletions(-)
> 
> diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
> index cbd0e2ac4ffe..7889e1ef7fad 100644
> --- a/net/ieee802154/socket.c
> +++ b/net/ieee802154/socket.c
> @@ -251,9 +251,6 @@ static int raw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
>   		return -EOPNOTSUPP;
>   	}
>   
> -	if (!size)
> -		return -EINVAL;
> -
>   	lock_sock(sk);
>   	if (!sk->sk_bound_dev_if)
>   		dev = dev_getfirstbyhwtype(sock_net(sk), ARPHRD_IEEE802154);

This patch has been applied to the wpan tree and will be
part of the next pull request to net. Thanks!

regards
Stefan Schmidt
