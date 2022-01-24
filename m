Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF9F498879
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 19:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245283AbiAXSjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 13:39:42 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42898 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiAXSjf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 13:39:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD7F861480;
        Mon, 24 Jan 2022 18:39:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EF8DC340E5;
        Mon, 24 Jan 2022 18:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643049574;
        bh=wtnMK1/PnKkXRPibVwQq/p8YTvI52RSABlhYxeqqrnM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ESfn/4wPty1DGAuUQm6HHBtZ4Wfk6BDpfLDkL4XeKGGdCVLcyJxIEQjaItV5glwOV
         AgnrCwhmhCHgJ30ic5SRCAAux7JRxF6jbjTT+wDW4JHvh1FvXVCAnPWJ99v8AnZOTF
         sYG7WiGKoKLljU1koxaaYJX5/3MIwbHEWL0g4c6c+AANqPZzrbyuqT3n4aJyOFgRLN
         euO0laQHumh9HDhizJwYzK6xIfudhIkaIwXkaNs9ptbpBWoeLsuQO2cpyGuYn8yP2w
         6eMLsAVzGRFaKn07FB93xlR30flBz1icWl7L+XRWcTMwK2a4+hPEQOmpCJf6+2rFgQ
         NLTlbEOpWTpWg==
Date:   Mon, 24 Jan 2022 10:39:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leonard Crestez <cdleonard@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Philip Paeps <philip@trouble.is>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 00/20] tcp: Initial support for RFC5925 auth option
Message-ID: <20220124103932.5d22fad2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <cover.1643026076.git.cdleonard@gmail.com>
References: <cover.1643026076.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Jan 2022 14:12:46 +0200 Leonard Crestez wrote:
> This is similar to TCP-MD5 in functionality but it's sufficiently
> different that packet formats and interfaces are incompatible.
> Compared to TCP-MD5 more algorithms are supported and multiple keys
> can be used on the same connection but there is still no negotiation
> mechanism.
> 
> [...]

Could you make sure that each individual patch builds cleanly with W=1
C=1? There is a bunch of missing "static" and unused function warnings 
in the first few patches. I presume they are made moot by later patches
but with kernel defaulting to Werror now it's a dangerous game to play,
we don't want to break bisection.

Also I spotted this:

include/net/tcp_authopt.h:59: warning: Function parameter or member 'prefixlen' not described in 'tcp_authopt_key_info'
