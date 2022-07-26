Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFE6F581602
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 17:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239583AbiGZPG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 11:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239587AbiGZPGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 11:06:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6392F3A8
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 08:06:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FA6960688
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 15:06:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD9AC433C1;
        Tue, 26 Jul 2022 15:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658848004;
        bh=/0n9PETRYpVa0C1ESH5lHpHTVh+U+IbolZS2Z3a9ezE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=lwDNXIJSnrWMmZh125X6lHiZTHju2SYvcKMpSirNy34cGwaA/UTDIIYP9AA1ypDGV
         MmUKNvYRXMJux3h+8XgKbgf6tqqK5odrpLGRd+Zltn8ReaU5XbXDP13GmcvHtOe2cJ
         abB4IaAcg3II4T48PXt9Br1g8mhc4TljhujIL3HUYacfp7H+FGxeZMyrhhsyo3uNER
         hOMRUzTrh/RS6R8Kl1Jh1KoQjYEpaqPCKzyx9uwf2iHlf8uCrdBO/OI6IDKaQjCpt/
         oOpVGsr07xJpLNLPFZ/sx9XMuWnLrI99pG4mlMnDMHBDvn2NO8GmdtWdRxohwl3Fzn
         vENkb9p83lccA==
Message-ID: <7c1b68b2-a00d-88a0-45a7-a276fdf4539c@kernel.org>
Date:   Tue, 26 Jul 2022 09:06:41 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH net] tcp: md5: fix IPv4-mapped support
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Brian Vazquez <brianvv@google.com>,
        Dmitry Safonov <dima@arista.com>,
        Leonard Crestez <cdleonard@gmail.com>
References: <20220726115743.2759832-1-edumazet@google.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220726115743.2759832-1-edumazet@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/26/22 5:57 AM, Eric Dumazet wrote:
> After the blamed commit, IPv4 SYN packets handled
> by a dual stack IPv6 socket are dropped, even if
> perfectly valid.
> 
> $ nstat | grep MD5
> TcpExtTCPMD5Failure             5                  0.0
> 
> For a dual stack listener, an incoming IPv4 SYN packet
> would call tcp_inbound_md5_hash() with @family == AF_INET,
> while tp->af_specific is pointing to tcp_sock_ipv6_specific.
> 
> Only later when an IPv4-mapped child is created, tp->af_specific
> is changed to tcp_sock_ipv6_mapped_specific.
> 
> Fixes: 7bbb765b7349 ("net/tcp: Merge TCP-MD5 inbound callbacks")
> Reported-by: Brian Vazquez <brianvv@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Dmitry Safonov <dima@arista.com>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Leonard Crestez <cdleonard@gmail.com>
> ---
>  net/ipv4/tcp.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 002a4a04efbe076ba603d7d42eb85e60d9bf4fb8..766881775abb795c884d048d51c361e805b91989 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -4459,9 +4459,18 @@ tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
>  		return SKB_DROP_REASON_TCP_MD5UNEXPECTED;
>  	}
>  
> -	/* check the signature */
> -	genhash = tp->af_specific->calc_md5_hash(newhash, hash_expected,
> -						 NULL, skb);
> +	/* Check the signature.
> +	 * To support dual stack listeners, we need to handle
> +	 * IPv4-mapped case.
> +	 */
> +	if (family == AF_INET)
> +		genhash = tcp_v4_md5_hash_skb(newhash,
> +					      hash_expected,
> +					      NULL, skb);
> +	else
> +		genhash = tp->af_specific->calc_md5_hash(newhash,
> +							 hash_expected,
> +							 NULL, skb);
>  
>  	if (genhash || memcmp(hash_location, newhash, 16) != 0) {
>  		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5FAILURE);

We should get v4-mapped cases added to the fcnal-test.sh permutations.

Reviewed-by: David Ahern <dsahern@kernel.org>

