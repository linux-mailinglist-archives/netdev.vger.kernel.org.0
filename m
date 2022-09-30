Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E35F5F0C61
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 15:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbiI3NYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 09:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231213AbiI3NYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 09:24:12 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB87518C035;
        Fri, 30 Sep 2022 06:24:09 -0700 (PDT)
Received: from [192.168.10.9] (unknown [39.45.148.204])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: usama.anjum)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 40D9066022CC;
        Fri, 30 Sep 2022 14:24:05 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1664544247;
        bh=W/Kwc4wta7KyHGZLcVb7h564UUNeE2X66AFYxu204aA=;
        h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
        b=Pspg5wlTw9kHtfwq62h/n25uJW0AEaLgY5aEzicVN/FwO3PLHWaBqmOYhJmlMuZfh
         77iOEg4jStib65HllIsiMtxsm7aUQ7Tl98F4s3IVOK846ASexDS+xr4yQqLbHOs/5b
         +kMPV8GyLUkpnrddiufHO4nyI26EfQvkpmWQEdveqKmdTuuEaWb8GLQ8ow5wCSekRl
         5Zt10Gc7Fne0nVjrl4eGz/CfJf7L8fV0r4vxiMxlzJayCZsCNZW6mBL3sd9UuCu/wW
         QiLyOEawo70ELHlkICeFoeT9SD1V7lI8LhdCXl4XNqedcS7bwFOdVFYaCHTK0HQkky
         BWiMDwyHPXsMQ==
Message-ID: <8dff3e46-6dac-af6a-1a3b-e6a8b93fdc60@collabora.com>
Date:   Fri, 30 Sep 2022 18:24:00 +0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Cc:     usama.anjum@collabora.com, LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Gofman <pgofman@codeweavers.com>
Subject: Re: [RFC] EADDRINUSE from bind() on application restart after killing
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        "open list:NETWORKING [TCP]" <netdev@vger.kernel.org>
References: <5099dc39-c6d9-115a-855b-6aa98d17eb4b@collabora.com>
From:   Muhammad Usama Anjum <usama.anjum@collabora.com>
In-Reply-To: <5099dc39-c6d9-115a-855b-6aa98d17eb4b@collabora.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

RFC 1337 describes the TIME-WAIT Assassination Hazards in TCP. Because
of this hazard we have 60 seconds timeout in TIME_WAIT state if
connection isn't closed properly. From RFC 1337:
> The TIME-WAIT delay allows all old duplicate segments time
enough to die in the Internet before the connection is reopened.

As on localhost there is virtually no delay. I think the TIME-WAIT delay
must be zero for localhost connections. I'm no expert here. On localhost
there is no delay. So why should we wait for 60 seconds to mitigate a
hazard which isn't there?

Zapping the sockets in TIME_WAIT and FIN_WAIT_2 does removes them. But
zap is required from privileged (CAP_NET_ADMIN) process. We are having
hard time finding a privileged process to do this.

Thanks,
Usama


On 5/24/22 1:18 PM, Muhammad Usama Anjum wrote:
> Hello,
> 
> We have a set of processes which talk with each other through a local
> TCP socket. If the process(es) are killed (through SIGKILL) and
> restarted at once, the bind() fails with EADDRINUSE error. This error
> only appears if application is restarted at once without waiting for 60
> seconds or more. It seems that there is some timeout of 60 seconds for
> which the previous TCP connection remains alive waiting to get closed
> completely. In that duration if we try to connect again, we get the error.
> 
> We are able to avoid this error by adding SO_REUSEADDR attribute to the
> socket in a hack. But this hack cannot be added to the application
> process as we don't own it.
> 
> I've looked at the TCP connection states after killing processes in
> different ways. The TCP connection ends up in 2 different states with
> timeouts:
> 
> (1) Timeout associated with FIN_WAIT_1 state which is set through
> `tcp_fin_timeout` in procfs (60 seconds by default)
> 
> (2) Timeout associated with TIME_WAIT state which cannot be changed. It
> seems like this timeout has come from RFC 1337.
> 
> The timeout in (1) can be changed. Timeout in (2) cannot be changed. It
> also doesn't seem feasible to change the timeout of TIME_WAIT state as
> the RFC mentions several hazards. But we are talking about a local TCP
> connection where maybe those hazards aren't applicable directly? Is it
> possible to change timeout for TIME_WAIT state for only local
> connections without any hazards?
> 
> We have tested a hack where we replace timeout of TIME_WAIT state from a
> value in procfs for local connections. This solves our problem and
> application starts to work without any modifications to it.
> 
> The question is that what can be the best possible solution here? Any
> thoughts will be very helpful.
> 
> Regards,
> 

-- 
Muhammad Usama Anjum
