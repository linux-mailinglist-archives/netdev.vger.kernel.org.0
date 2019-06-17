Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B251489E3
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 19:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbfFQRSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 13:18:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55048 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728356AbfFQRSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 13:18:38 -0400
Received: from 162-237-133-238.lightspeed.rcsntx.sbcglobal.net ([162.237.133.238] helo=lindsey)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <tyhicks@canonical.com>)
        id 1hcvH9-0001jf-Fi; Mon, 17 Jun 2019 17:18:35 +0000
Date:   Mon, 17 Jun 2019 12:18:31 -0500
From:   Tyler Hicks <tyhicks@canonical.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Looney <jtl@netflix.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Bruce Curtis <brucec@netflix.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH net 4/4] tcp: enforce tcp_min_snd_mss in tcp_mtu_probing()
Message-ID: <20190617171830.GB5577@lindsey>
References: <20190617170354.37770-1-edumazet@google.com>
 <20190617170354.37770-5-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617170354.37770-5-edumazet@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-06-17 10:03:54, Eric Dumazet wrote:
> If mtu probing is enabled tcp_mtu_probing() could very well end up
> with a too small MSS.
> 
> Use the new sysctl tcp_min_snd_mss to make sure MSS search
> is performed in an acceptable range.
> 
> CVE-2019-11479 -- tcp mss hardcoded to 48
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> Cc: Jonathan Looney <jtl@netflix.com>
> Acked-by: Neal Cardwell <ncardwell@google.com>
> Cc: Yuchung Cheng <ycheng@google.com>
> Cc: Tyler Hicks <tyhicks@canonical.com>

As mentioned for the other sysctl patch, I've given the two sysctl
patches a close review and some testing.

Acked-by: Tyler Hicks <tyhicks@canonical.com>

Tyler

> Cc: Bruce Curtis <brucec@netflix.com>
> ---
>  net/ipv4/tcp_timer.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
> index 5bad937ce779ef8dca42a26dcbb5f1d60a571c73..c801cd37cc2a9c11f2dd4b9681137755e501a538 100644
> --- a/net/ipv4/tcp_timer.c
> +++ b/net/ipv4/tcp_timer.c
> @@ -155,6 +155,7 @@ static void tcp_mtu_probing(struct inet_connection_sock *icsk, struct sock *sk)
>  		mss = tcp_mtu_to_mss(sk, icsk->icsk_mtup.search_low) >> 1;
>  		mss = min(net->ipv4.sysctl_tcp_base_mss, mss);
>  		mss = max(mss, 68 - tcp_sk(sk)->tcp_header_len);
> +		mss = max(mss, net->ipv4.sysctl_tcp_min_snd_mss);
>  		icsk->icsk_mtup.search_low = tcp_mss_to_mtu(sk, mss);
>  	}
>  	tcp_sync_mss(sk, icsk->icsk_pmtu_cookie);
> -- 
> 2.22.0.410.gd8fdbe21b5-goog
> 
