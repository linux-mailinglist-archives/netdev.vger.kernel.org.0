Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1172DC2C
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 13:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbfE2LuK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 29 May 2019 07:50:10 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:44004 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfE2LuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 07:50:10 -0400
Received: by mail-qk1-f195.google.com with SMTP id m14so1184149qka.10;
        Wed, 29 May 2019 04:50:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XHkHtWbVB+TvovZz7oPuGTHVIANZlI/EFu3bjVNoQjY=;
        b=lTsaY64nMnxiHD7pa9HeT5GE8YW0R8qppT6CDAvpNN2yyka/Gw4Z4VGVRix3sw0JJP
         IxNhHbE2aDTZx2X3fX2IKikOV+FLgmoja6aCH6fsaRw9yo/GB3245QClm8qM/h3V/Gyz
         wPQtO8AM/4aKa6WUGYBeEBGaNj3V3j65B8I1py2tjJsxZCnUgy0vYDEsKhPUTj7F7FPr
         slXtsG1Q6SN2qYzbj8bpVjfUnB4Yo+SpgdULwY+90vYFLtM7FmqU13JW/VyK2xmEWHwA
         EqGuYr2roFx5F0n/QzjiheaKTie0nTTu0XFx7eTqM689cdsgL5Q1ONjb6gsSDP04anTo
         XiOg==
X-Gm-Message-State: APjAAAWKj/iVdbBXWye7ZRwXxwoXcLd6rH8KccmIgIoYcQWRWZAY7tMb
        Oscfzgn9zwmDj2Cwxs/pAAs+NEY0pSo7FYc37zM=
X-Google-Smtp-Source: APXvYqwIv+NsvZQNU3e96RUtDw8gxMBWuYuQiiajDZ8QFDNiZsSZdie+JkLoe/OtQ843s/6drkk2QB+tL4D41jq4Vho=
X-Received: by 2002:a37:bb85:: with SMTP id l127mr27919584qkf.285.1559130609026;
 Wed, 29 May 2019 04:50:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190528142424.19626-1-geert@linux-m68k.org> <20190528142424.19626-3-geert@linux-m68k.org>
In-Reply-To: <20190528142424.19626-3-geert@linux-m68k.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 29 May 2019 13:49:52 +0200
Message-ID: <CAK8P3a1wTED5Aet_9AjY9VFFrutkV2xK6C13vroTLd0vpcoo9w@mail.gmail.com>
Subject: Re: [PATCH 2/5] rxrpc: Fix uninitialized error code in rxrpc_send_data_packet()
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Igor Konopko <igor.j.konopko@intel.com>,
        David Howells <dhowells@redhat.com>,
        "Mohit P . Tahiliani" <tahiliani@nitk.edu.in>,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Matias Bjorling <mb@lightnvm.io>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Clemens Ladisch <clemens@ladisch.de>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, Joe Perches <joe@perches.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-block <linux-block@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-afs@lists.infradead.org,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 4:24 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> With gcc 4.1:
>
>     net/rxrpc/output.c: In function ‘rxrpc_send_data_packet’:
>     net/rxrpc/output.c:338: warning: ‘ret’ may be used uninitialized in this function
>
> Indeed, if the first jump to the send_fragmentable label is made, and
> the address family is not handled in the switch() statement, ret will be
> used uninitialized.
>
> Fix this by initializing err to zero before the jump, like is already
> done for the jump to the done label.
>
> Fixes: 5a924b8951f835b5 ("rxrpc: Don't store the rxrpc header in the Tx queue sk_buffs")
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
> While this is not a real false-positive, I believe it cannot cause harm
> in practice, as AF_RXRPC cannot be used with other transport families
> than IPv4 and IPv6.

This looks like a variant of the infamous bug
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=18501

What I don't understand is why clang fails to warn about it with
-Wsometimes-uninitialized.
(cc clang-built-linux mailing list).

      Arnd

>  net/rxrpc/output.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
> index 004c762c2e8d063c..1473d774d67100c5 100644
> --- a/net/rxrpc/output.c
> +++ b/net/rxrpc/output.c
> @@ -403,8 +403,10 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct sk_buff *skb,
>
>         /* send the packet with the don't fragment bit set if we currently
>          * think it's small enough */
> -       if (iov[1].iov_len >= call->peer->maxdata)
> +       if (iov[1].iov_len >= call->peer->maxdata) {
> +               ret = 0;
>                 goto send_fragmentable;
> +       }
>
>         down_read(&conn->params.local->defrag_sem);
>
