Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 541AD2194CE
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 02:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgGIACN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 20:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbgGIACN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 20:02:13 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 166A6C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 17:02:13 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id p3so136093pgh.3
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 17:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=S7Vks2nSJIH4ONzCtz2ZhNStznSixgT08eaKe4zCM54=;
        b=tcbXVBjuIaBgHpHWd9QCs58eSpQr/LiZxSBfQWkazGVsvKuqKZoRZfaylL65DSwmpx
         v6Fe5KrInBla2ajJOwtzK+fHBPXkOHc2lBgkCoCkLabInQ2utWkvaKiJ2whQjc/qZVTG
         +N4mPwLMBScWKZoDDnu4aASnj0lPciwajjppX0WmxBIlLLU9G5/6Fg40cNlOZushP+EN
         94PhNd7hEzlIH0sBVG5KhREFDZAY/gC37nCbaQmp1Btv36i3C/xWc6/TZZbcDq9YV7ks
         +MNDcx1XpoXJroq1+CWsc/Aw52rG05yfnepkE+balH+l9ns5n1/qblOgTN6LdHgsATVG
         C8jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S7Vks2nSJIH4ONzCtz2ZhNStznSixgT08eaKe4zCM54=;
        b=kHLfzgQbqxhAWf0yAZ8LWDfWZ0u9jRxznlSJV/FBHxQEAfdeuB+OfCgzXtngopltW/
         puvjA2h8g6N7YWPVoFyJ2chAyuMSjlUWrk/iAu6uC3yaRreUcsiNqeIwJpx955NawEkP
         e3uk1wVB/QkPWPL+qEJrO0uu6YdLazkAvmG63PvvJiRgK9pmC/8/pDHrsZ2MgDd4G8qr
         K15aQKzAqZuIKyOwABD2s+/3URpt7uIw4NkztmA1TEICuBkGhT9LXXarchjHxkc4lAaK
         ocDzxD4SL/C5Va5asXHWDcZPA/sUtiVQQ7mzAglbdeeEn/JZ4qvJAtEaXoRONbirAYyv
         Rfbg==
X-Gm-Message-State: AOAM5324u4dE9lM0lReuW7ogrGnrCnk5SzIt2xIH7tuvVJbUVQo8koLK
        s3UeVOSNM95Cdll+Y2d0aQ0VwTZc
X-Google-Smtp-Source: ABdhPJw2df9o9qNa9GCnjbI9NoECV6V+HsRUYDu22AJYUHYH5aCMD7ERt7imPdeqJcrMslylse/5vw==
X-Received: by 2002:a63:d944:: with SMTP id e4mr51349990pgj.376.1594252932667;
        Wed, 08 Jul 2020 17:02:12 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id s89sm545024pjj.28.2020.07.08.17.02.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 17:02:12 -0700 (PDT)
Subject: Re: [PATCH v2 net] tcp: make sure listeners don't initialize
 congestion-control state
To:     Christoph Paasch <cpaasch@apple.com>, netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Wei Wang <weiwan@google.com>,
        Eric Dumazet <edumazet@google.com>
References: <20200708231834.55194-1-cpaasch@apple.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <fd322c64-9fe6-2244-75c3-2c12fbf4503e@gmail.com>
Date:   Wed, 8 Jul 2020 17:02:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200708231834.55194-1-cpaasch@apple.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/8/20 4:18 PM, Christoph Paasch wrote:
> syzkaller found its way into setsockopt with TCP_CONGESTION "cdg".
> tcp_cdg_init() does a kcalloc to store the gradients. As sk_clone_lock
> just copies all the memory, the allocated pointer will be copied as
> well, if the app called setsockopt(..., TCP_CONGESTION) on the listener.
> If now the socket will be destroyed before the congestion-control
> has properly been initialized (through a call to tcp_init_transfer), we
> will end up freeing memory that does not belong to that particular
> socket, opening the door to a double-free:
> 


> Wei Wang fixed a part of these CDG-malloc issues with commit c12014440750
> ("tcp: memset ca_priv data to 0 properly").
> 
> This patch here fixes the listener-scenario: We make sure that listeners
> setting the congestion-control through setsockopt won't initialize it
> (thus CDG never allocates on listeners). For those who use AF_UNSPEC to
> reuse a socket, tcp_disconnect() is changed to cleanup afterwards.
> 
> (The issue can be reproduced at least down to v4.4.x.)
> 
> Cc: Wei Wang <weiwan@google.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Fixes: 2b0a8c9eee81 ("tcp: add CDG congestion control")
> Signed-off-by: Christoph Paasch <cpaasch@apple.com>
> ---
> 
> Notes:
>     v2: Rather prevent listeners from initializign congestion-control state and
>         make sure tcp_disconnect() cleans up for those that want to re-use sockets
>         with AF_UNSPEC (suggested by Eric)

SGTM, thanks.

Signed-off-by: Eric Dumazet <edumazet@google.com>

