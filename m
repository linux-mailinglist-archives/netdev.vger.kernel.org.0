Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 554F81153A0
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 15:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbfLFOt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 09:49:56 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:41010 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726258AbfLFOt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 09:49:56 -0500
Received: by mail-oi1-f195.google.com with SMTP id i1so6362135oie.8
        for <netdev@vger.kernel.org>; Fri, 06 Dec 2019 06:49:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p5CUqgxkU/D1I8Ax7w9X3G/Y0CeB90XIOs7ZbBuzTaQ=;
        b=v84ypwp3RgWojJ/UCrJNG3Gadzhqs6pkh/jX2tZfwJIothdGzpZHs/H++7P3XiRM3o
         Ov9mmU12Xg11c50dZz0D4BFjyoi5Xc1f38VAQM2H6F8D4Zh/mW41GU6N+EN/aUBDuUKX
         SQykeSbXpKe11irveqLXTTgD3E0M6k9rcDfHE6dJlLuDKFs/eyEbFaytJ4GzGoIYTo5W
         5s9ZVwoa4d8Pt+rt+qhXHI31gvSqwXPmKHYv1YgS0Il8UNqGkDtaIk4SvitP8+qJUGRF
         uFXwDmaag1aWhmSje3aXA7xLuHURwWy0VPa/rdq+TYsGR8XN0FkCG28tnuATobPGlZv8
         lEtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p5CUqgxkU/D1I8Ax7w9X3G/Y0CeB90XIOs7ZbBuzTaQ=;
        b=UCgPLTFOaY2DoY+XNIsFQSbF4ogKm9gNpyKe467gtU+eG0KTGsVI34tDb2BC2KLayJ
         ACmHT1doMQlrj2XL4YiU7E+Wv1XxYpTXlbY4CiVnfYvBilzpinEmMjVAIBeErdmp+X9h
         MW2ypFMiwsXokIuSmR59RnOhbWX/+dIk1uCgtVYc+deb4VBKdoSO58flYD1zCLCeFOae
         NSajQtuVbncjIsnQsTfm0FPe7lCbvkbdDQFjn1nEIWQ2MH4NScj0qmcU3TB+XrRbhsNv
         CSm3IH640RV6YHfs5cUO+XwaKIp8dWlkrU8zH89D7X+KtzdVIOpzWPZ2jDGAvLTnFsYS
         E7jA==
X-Gm-Message-State: APjAAAWGd/EU4oGbPzR7CBKNFjXGEPp9WQAA9Th+GnDylxTB9ZwtoNwO
        0edN+vP7uK+5r4M0jtzJuoIa7HdznNXfP7t7ImSlaw==
X-Google-Smtp-Source: APXvYqyhlLBI5avsGMp6kWoRcXKlO8bjH5aFEUOrWNJlc2FgPC3jjqPVU8tuP+W+4AfuA8fJ5NWjU7tj2KVRQ0VJtps=
X-Received: by 2002:aca:4911:: with SMTP id w17mr6505733oia.22.1575643795449;
 Fri, 06 Dec 2019 06:49:55 -0800 (PST)
MIME-Version: 1.0
References: <20191205181015.169651-1-edumazet@google.com>
In-Reply-To: <20191205181015.169651-1-edumazet@google.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Fri, 6 Dec 2019 09:49:39 -0500
Message-ID: <CADVnQy=xkpckodjF16YF=tZ34bMB2QLQ=BTJeGyaidcPaTiAGQ@mail.gmail.com>
Subject: Re: [PATCH net] tcp: md5: fix potential overestimation of TCP option space
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 5, 2019 at 1:10 PM Eric Dumazet <edumazet@google.com> wrote:
>
> Back in 2008, Adam Langley fixed the corner case of packets for flows
> having all of the following options : MD5 TS SACK
>
> Since MD5 needs 20 bytes, and TS needs 12 bytes, no sack block
> can be cooked from the remaining 8 bytes.
>
> tcp_established_options() correctly sets opts->num_sack_blocks
> to zero, but returns 36 instead of 32.
>
> This means TCP cooks packets with 4 extra bytes at the end
> of options, containing unitialized bytes.
>
> Fixes: 33ad798c924b ("tcp: options clean up")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> ---

Acked-by: Neal Cardwell <ncardwell@google.com>

Thanks, Eric!

neal
