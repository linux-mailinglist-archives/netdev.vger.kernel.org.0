Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD4A5048E4
	for <lists+netdev@lfdr.de>; Sun, 17 Apr 2022 20:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234771AbiDQS1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Apr 2022 14:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbiDQS1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Apr 2022 14:27:09 -0400
Received: from mail-out.m-online.net (mail-out.m-online.net [212.18.0.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27677E03D
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 11:24:31 -0700 (PDT)
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4KhJPM52k7z1s75P;
        Sun, 17 Apr 2022 20:24:23 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4KhJPL6Sqmz1qqkB;
        Sun, 17 Apr 2022 20:24:22 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id G-Hvpshs1IND; Sun, 17 Apr 2022 20:24:21 +0200 (CEST)
X-Auth-Info: h/nxvWeh3Fn3FvTFadRcT0ESIMk2jD2OP8lSZm1MxCpBcrBKXWtPJcpmfeBnvkQ2
Received: from igel.home (ppp-46-244-167-248.dynamic.mnet-online.de [46.244.167.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sun, 17 Apr 2022 20:24:21 +0200 (CEST)
Received: by igel.home (Postfix, from userid 1000)
        id C64CA2C3979; Sun, 17 Apr 2022 20:24:20 +0200 (CEST)
From:   Andreas Schwab <schwab@linux-m68k.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net-next] tcp: fix signed/unsigned comparison
References: <20220417171027.3888810-1-eric.dumazet@gmail.com>
X-Yow:  I LIKE Aisle 7a.
Date:   Sun, 17 Apr 2022 20:24:20 +0200
In-Reply-To: <20220417171027.3888810-1-eric.dumazet@gmail.com> (Eric Dumazet's
        message of "Sun, 17 Apr 2022 10:10:27 -0700")
Message-ID: <87czhfy3e3.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Apr 17 2022, Eric Dumazet wrote:

> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index cf2dc19bb8c766c1d33406053fd61c0873f15489..0d88984e071531fb727bdee178b0c01fd087fe5f 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -5959,7 +5959,7 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
>  
>  step5:
>  	reason = tcp_ack(sk, skb, FLAG_SLOWPATH | FLAG_UPDATE_TS_RECENT);
> -	if (reason < 0)
> +	if ((int)reason < 0)
>  		goto discard;
>  
>  	tcp_rcv_rtt_measure_ts(sk, skb);

Shouldn't reason be negated before passing it to tcp_drop_reason?

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 7578 EB47 D4E5 4D69 2510  2552 DF73 E780 A9DA AEC1
"And now for something completely different."
