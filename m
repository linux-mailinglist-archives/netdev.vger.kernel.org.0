Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD023726FE
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 10:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbhEDINa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 04:13:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:49248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229848AbhEDIN2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 May 2021 04:13:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98BBD611EE;
        Tue,  4 May 2021 08:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620115951;
        bh=v/cdWpMoKiZ8IsK8Q2dHcztejYNLQ3gt96WJiB04ugY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pRoxLug+3JCfrdaQgz34gp3QPPGUSTmyH802t1wdkjr7ptc9p2NpKZBs7UMSv6lni
         D0MNxA6QYZkIASCzGDTWUB8zFmMXD0E6g45Jmg25V3Sqm8preLmOn0XG1ZcSUY1CZ/
         yqNrl+8dAbvskL8qRPr+OEYqJwbJk35uYeQc9WqhsOw+eoT2fhEw2KO+oyidVZBTNP
         bibblxshs+S/pWCPzwiF5ZvqTqhx4UQhbdVO03uo1ULykLaLrzP0ekFZQdcHlnEwDE
         biHrqmfHWzka6cSFA432wiCcpEod14cE6unYl0eBNevd6AxAujIB99NSOVqqADtFJ4
         HRy9svEjBIrYQ==
Date:   Tue, 4 May 2021 11:12:27 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Or Cohen <orcohen@paloaltonetworks.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        nixiaoming@huawei.com, matthieu.baerts@tessares.net,
        mkl@pengutronix.de, nmarkus@paloaltonetworks.com
Subject: Re: [PATCH] net/nfc: fix use-after-free llcp_sock_bind/connect
Message-ID: <YJEB6+K0RaPg8KD6@unreal>
References: <20210504071525.28342-1-orcohen@paloaltonetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210504071525.28342-1-orcohen@paloaltonetworks.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 04, 2021 at 10:15:25AM +0300, Or Cohen wrote:
> Commits 8a4cd82d ("nfc: fix refcount leak in llcp_sock_connect()")
> and c33b1cc62 ("nfc: fix refcount leak in llcp_sock_bind()")
> fixed a refcount leak bug in bind/connect but introduced a
> use-after-free if the same local is assigned to 2 different sockets.
> 
> This can be triggered by the following simple program:
>     int sock1 = socket( AF_NFC, SOCK_STREAM, NFC_SOCKPROTO_LLCP );
>     int sock2 = socket( AF_NFC, SOCK_STREAM, NFC_SOCKPROTO_LLCP );
>     memset( &addr, 0, sizeof(struct sockaddr_nfc_llcp) );
>     addr.sa_family = AF_NFC;
>     addr.nfc_protocol = NFC_PROTO_NFC_DEP;
>     bind( sock1, (struct sockaddr*) &addr, sizeof(struct sockaddr_nfc_llcp) )
>     bind( sock2, (struct sockaddr*) &addr, sizeof(struct sockaddr_nfc_llcp) )
>     close(sock1);
>     close(sock2);
> 
> Fix this by assigning NULL to llcp_sock->local after calling
> nfc_llcp_local_put.
> 
> This addresses CVE-2021-23134.
> 
> Reported-by: Or Cohen <orcohen@paloaltonetworks.com>
> Reported-by: Nadav Markus <nmarkus@paloaltonetworks.com>
> Fixes: c33b1cc62 ("nfc: fix refcount leak in llcp_sock_bind()")
> Signed-off-by: Or Cohen <orcohen@paloaltonetworks.com>
> ---
> 
>  net/nfc/llcp_sock.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
> index a3b46f888803..53dbe733f998 100644
> --- a/net/nfc/llcp_sock.c
> +++ b/net/nfc/llcp_sock.c
> @@ -109,12 +109,14 @@ static int llcp_sock_bind(struct socket *sock, struct sockaddr *addr, int alen)
>  					  GFP_KERNEL);
>  	if (!llcp_sock->service_name) {
>  		nfc_llcp_local_put(llcp_sock->local);
> +		llcp_sock->local = NULL;

This "_put() -> set to NULL" pattern can't be correct.

You need to fix nfc_llcp_local_get() to use kref_get_unless_zero()
and prevent any direct use of llcp_sock->local without taking kref
first. The nfc_llcp_local_put() isn't right either.

Thanks
