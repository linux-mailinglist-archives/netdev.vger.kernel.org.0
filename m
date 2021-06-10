Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7B453A213E
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 02:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbhFJAU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 20:20:59 -0400
Received: from mail-ej1-f46.google.com ([209.85.218.46]:34771 "EHLO
        mail-ej1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhFJAU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 20:20:59 -0400
Received: by mail-ej1-f46.google.com with SMTP id g8so41145949ejx.1
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 17:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j7IcI9VJP2BguQvB5gjuhQ5NXqzEG9228b/F0nOmB+c=;
        b=qQdr5G7qxgumOjDLDyP0fe+MVCthFHzm1PpL8j2YbvsiurDlFaGzyktzcTyiUnSdT5
         TlQh3oBruZUe3irt4yMfcpZBZwhYYVP59qICP3YSu0cxdgZgcyI69WJLGy7CDHTS7D5Q
         So69OaiwiqkjShjxQc1nPaPsSYTAe45CmDvmJcqxEtFkTe8KBP0F9zu/Z0Dd1fWMzHa8
         dRm4hKipw9LZYXTbjI117Nj+gTatXIpanX10PP8vbhz4u1w5XapxNTfU44IeP+wzy9Xs
         pYPoHIw2t8m7KsDsU9J00qba3QAMq3mB5FP/dJvXPdHAU74isMsDqSZztGY6QS+uWows
         ztRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j7IcI9VJP2BguQvB5gjuhQ5NXqzEG9228b/F0nOmB+c=;
        b=LTeeJwdk/ZiR9F25y0qjB2E1se1Y/EtbBpMucg2S/TUAYiOMvGM5KRq0+5wGCCMQpS
         NO8ICu1f2X/xm3h016FCppY6+eicafNF3J/eeJrGoajp69tlvdHIcfW/KVuv4FDZNwwi
         17V3y527y8EhuIKiwIejiSzsPqaHjKSNVPKgzWY3qJllgbNijoiFs8uYtk1DS37UYJ7g
         6EibfPzEkaNlgq0dnmWUpp+//Y2Jv3kUltsPYdoKZ+enl02r2dqGHIVRd1lm0UxfDtTw
         wG5sWUl6oIi8Dow5VJGafYA1Bddh4tBfezLt0VUIfwtqDX5HFBwOzsSQcrKkeLodOqAh
         bbDg==
X-Gm-Message-State: AOAM531elKPT8Q9qClrWCTeaxb2H64jnaFm2Lw0x6ADjAbsfuCg3cqUv
        Lvz9YqrZ5ThwDSmO/4dAWiAHj9AXeceRh88LiZJwGA==
X-Google-Smtp-Source: ABdhPJwVJpeYHWVDqPjVtfLIsVc2F6faX4u2rIoIuu9A/sMsMwOoTUyNrFzHjGFxrGzekNh5JjwdseXM72h/48acctI=
X-Received: by 2002:a17:906:c2d6:: with SMTP id ch22mr2048967ejb.227.1623284282762;
 Wed, 09 Jun 2021 17:18:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210609224157.1800831-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20210609224157.1800831-1-willemdebruijn.kernel@gmail.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Wed, 9 Jun 2021 20:17:26 -0400
Message-ID: <CACSApvYC29Xsx_2Ex9xtUgq-SmVRoe3gs2COqmo9evcb0uQS3w@mail.gmail.com>
Subject: Re: [PATCH net] skbuff: fix incorrect msg_zerocopy copy notifications
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Talal Ahmad <talalahmad@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 9, 2021 at 6:42 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> From: Willem de Bruijn <willemb@google.com>
>
> msg_zerocopy signals if a send operation required copying with a flag
> in serr->ee.ee_code.
>
> This field can be incorrect as of the below commit, as a result of
> both structs uarg and serr pointing into the same skb->cb[].
>
> uarg->zerocopy must be read before skb->cb[] is reinitialized to hold
> serr. Similar to other fields len, hi and lo, use a local variable to
> temporarily hold the value.
>
> This was not a problem before, when the value was passed as a function
> argument.
>
> Fixes: 75518851a2a0 ("skbuff: Push status and refcounts into sock_zerocopy_callback")
> Reported-by: Talal Ahmad <talalahmad@google.com>
> Signed-off-by: Willem de Bruijn <willemb@google.com>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

Thank you for the fix!

> ---
>  net/core/skbuff.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 3ad22870298c..bbc3b4b62032 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -1253,6 +1253,7 @@ static void __msg_zerocopy_callback(struct ubuf_info *uarg)
>         struct sock *sk = skb->sk;
>         struct sk_buff_head *q;
>         unsigned long flags;
> +       bool is_zerocopy;
>         u32 lo, hi;
>         u16 len;
>
> @@ -1267,6 +1268,7 @@ static void __msg_zerocopy_callback(struct ubuf_info *uarg)
>         len = uarg->len;
>         lo = uarg->id;
>         hi = uarg->id + len - 1;
> +       is_zerocopy = uarg->zerocopy;
>
>         serr = SKB_EXT_ERR(skb);
>         memset(serr, 0, sizeof(*serr));
> @@ -1274,7 +1276,7 @@ static void __msg_zerocopy_callback(struct ubuf_info *uarg)
>         serr->ee.ee_origin = SO_EE_ORIGIN_ZEROCOPY;
>         serr->ee.ee_data = hi;
>         serr->ee.ee_info = lo;
> -       if (!uarg->zerocopy)
> +       if (!is_zerocopy)
>                 serr->ee.ee_code |= SO_EE_CODE_ZEROCOPY_COPIED;
>
>         q = &sk->sk_error_queue;
> --
> 2.32.0.rc1.229.g3e70b5a671-goog
>
