Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0E941606B
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 15:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241563AbhIWN7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 09:59:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:59420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235028AbhIWN7g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 09:59:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5230160F44;
        Thu, 23 Sep 2021 13:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632405485;
        bh=KBCmgvRZ8mFtUYEqxjr94uSNKvUJebo2DMZrZfaxafs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nvfxeqqQFVHLpbarVIqhOY4ghlUK4ej5K2byCaZEEjidim953yvcjgL+jjOjMFDwL
         sK8DYh9K21sxqFDEs5O6ZxIl6vhsIOYjeSnMquoSdcB2AzvNK7uY6dvU9LeMGxZ073
         7hmSbx4oX+LLKnZy6/uEs1WYz14YtTMxNjDjTD682zzquLPYT+x78L/+rCTRgZmN2S
         ml4qKU6dyddwmIJVkvbXYs/KnEdAvW52M6ZoNdRKhbHxCe35v6ustUAaIpppiF85DX
         S17E2unCldiVPGhBykk47yicI17YPKVuAB3JqAn5yHHy2WNMibSkitnM+L7cjTPJNc
         WWgeoo4nKcfAg==
Date:   Thu, 23 Sep 2021 06:58:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leonard Crestez <cdleonard@gmail.com>
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/19] tcp: Initial support for RFC5925 auth option
Message-ID: <20210923065803.744485ce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <f84a32c9-ee7e-6e72-ccb2-69ac0210dc34@gmail.com>
References: <cover.1632240523.git.cdleonard@gmail.com>
        <20210921161327.10b29c88@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <f84a32c9-ee7e-6e72-ccb2-69ac0210dc34@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Sep 2021 10:49:53 +0300 Leonard Crestez wrote:
> Many of the patch splits were artificially created in order to ease 
> review, for example "signing packets" doesn't do anything without also 
> "hooking in the tcp stack". Some static functions will trigger warnings 
> because they're unused until the next patch, not clear what the 
> preferred solution would be here. I could remove the "static" marker 
> until the next patch or reverse the order and have the initial "tcp 
> integration" patches call crypto code that just returns an error and 
> fills-in a signature of zeros.

Ease of review is important, so although discouraged transient warnings
are acceptable if the code is much easier to read that way. The problem
here was that the build was also broken, but looking at it again I
think you're just missing exports, please make sure to build test with
IPV6 compiled as a module:

ERROR: modpost: "tcp_authopt_hash" [net/ipv6/ipv6.ko] undefined!
ERROR: modpost: "__tcp_authopt_select_key" [net/ipv6/ipv6.ko] undefined!
