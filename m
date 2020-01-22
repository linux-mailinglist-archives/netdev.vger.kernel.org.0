Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8F74145B2F
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 18:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729300AbgAVRxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 12:53:54 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42302 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgAVRxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 12:53:53 -0500
Received: by mail-pl1-f194.google.com with SMTP id p9so70101plk.9
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 09:53:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=j21FK+jgariTRVthEq+lQ6n54TMB2BSG8XTErcHbHU0=;
        b=vXVQCKqcM8RKsWUtdi24woJ/zKRGIOTqllTK/Ilu/Qn85g20SXdwEyU0lDUUauLOqB
         niWjCSU0SgcgTKRkjT4Q44XQsA2ezvT7Mq9EUgjZx/MVTTFEGTgb5666Avgxu56AscT+
         v5qfOEac2rGQ0JZyKxdNZEjIFwJBOjDp/Z673HanpmFsXBehNIqcahxs9xD+BAoNv3tp
         ltczVZFiAKSOrLS/NtgejKiP5XNq1eWvOPIp+bjaCWjfzirOvmFaOArAEX5uPn6rM7E7
         LCeAOW9HOYJUmFcNXJlG78p2BBallFDFAT44zKx564GWXpOLtffHjdExFb49upYio6/C
         3Z1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=j21FK+jgariTRVthEq+lQ6n54TMB2BSG8XTErcHbHU0=;
        b=BMRTxddItcVthdJApErZolaed7mhGnZ20pRnT+SDatmZnGRb6D53RipODUVvE9Vg/H
         427Bx+ZuyAqtvp+lc6/V5EN2D/0o5tNjiNQBCB5ejwTQt6ImV3bPT3xg+KAVCY+ttoaB
         iuzzZ694q0IhUCFUekTXcZi9fKT3MosUuC6rxVgrFYvOibPisRvq/z/Ub3ZLkwoRm/17
         QadX3Qzza7J+1JdVANtfxwOuMkwM18G8wmXQHxM8fKe46reHQVY/7vzllcBQn4L0Zge9
         02HCEdY0dFPyv60gcRGbwQJ4oNNK+pQlNdNs7xPcrfj9w7iM2JdezTYijRvEKNnDyQ3v
         a2+g==
X-Gm-Message-State: APjAAAWKHzAk7/r2CIAdcvef3yD3GN1o80xBGBF1rsag8zK8+lX8nwBw
        TaFVEHvV3hpUm+DdduT7tME=
X-Google-Smtp-Source: APXvYqxX858/8QZubwNvW5nsgGbMaD6Cj/RDeyIlRH/W51qPeRT6qtvp0v3gKQYlYyPMxWHzrjfa0A==
X-Received: by 2002:a17:902:6904:: with SMTP id j4mr12415127plk.88.1579715633148;
        Wed, 22 Jan 2020 09:53:53 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id d3sm46326208pfn.113.2020.01.22.09.53.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 09:53:52 -0800 (PST)
Date:   Wed, 22 Jan 2020 09:53:44 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, netdev@vger.kernel.org
Cc:     John Fastabend <john.fastabend@gmail.com>,
        syzbot+d73682fcf7fee6982fe3@syzkaller.appspotmail.com
Message-ID: <5e288c28c0289_1de22aea94eb45c0bb@john-XPS-13-9370.notmuch>
In-Reply-To: <20200121123147.706666-1-jakub@cloudflare.com>
References: <20200121123147.706666-1-jakub@cloudflare.com>
Subject: RE: [PATCH net] net, sk_msg: Don't check if sock is locked when
 tearing down psock
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> As John Fastabend reports [0], psock state tear-down can happen on receive
> path *after* unlocking the socket, if the only other psock user, that is
> sockmap or sockhash, releases its psock reference before tcp_bpf_recvmsg
> does so:
> 
>  tcp_bpf_recvmsg()
>   psock = sk_psock_get(sk)                         <- refcnt 2
>   lock_sock(sk);
>   ...
>                                   sock_map_free()  <- refcnt 1
>   release_sock(sk)
>   sk_psock_put()                                   <- refcnt 0
> 
> Remove the lockdep check for socket lock in psock tear-down that got
> introduced in 7e81a3530206 ("bpf: Sockmap, ensure sock lock held during
> tear down").
> 
> [0] https://lore.kernel.org/netdev/5e25dc995d7d_74082aaee6e465b441@john-XPS-13-9370.notmuch/
> 
> Fixes: 7e81a3530206 ("bpf: Sockmap, ensure sock lock held during tear down")
> Reported-by: syzbot+d73682fcf7fee6982fe3@syzkaller.appspotmail.com
> Suggested-by: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  net/core/skmsg.c | 2 --
>  1 file changed, 2 deletions(-)

Thanks Jakub, this was not needed I got a bit carried away. I'll add
a selftest to catch this case by duplicating the reproducer into
test_sockmap.c

Acked-by: John Fastabend <john.fastabend@gmail.com>
