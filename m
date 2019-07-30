Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9CC17A4AA
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 11:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731785AbfG3Ji1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 05:38:27 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:34696 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728830AbfG3Ji1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 05:38:27 -0400
Received: by mail-io1-f68.google.com with SMTP id k8so126642137iot.1;
        Tue, 30 Jul 2019 02:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ou13JSb7APrBhtuQv/5kmhMM+zV7koQaR2bgg5AZQlY=;
        b=j0EFIzRfAw0lRTK+yYPE5ulbxWukeaSAp3cdW3OtkvwySlKqShPEX+esUskyEmaz91
         smWqM1KuHFepV/SlIWOSjqsSdg8Rx2XmuuZpOHigBAW4QSrFVXmG7MdUVnC6R9ajU2hm
         xm15gw005bdAhMxcfib8hbYxQCjB7VN7JpsJ94/H0hBwuKq/94Av/hGYlmwDR0GJvrEI
         Zl60nLCHPxaRhKZmHADpAje0zxwvLZx/J8L99Ybb886lm1oPeQxkk9KtTFwsj/jRh7zE
         tWatY/3twGR0P+54g2zzWwAK/Iz5zfAqGrFuLR2sUEL4/fHqysGsmSGKYK1dOCJ3nW0G
         TeUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ou13JSb7APrBhtuQv/5kmhMM+zV7koQaR2bgg5AZQlY=;
        b=Y7lKTsJDyBa1QlcMkslkasyaY5LhfA1oDvCsNxCnSLxkyV3AgEoZl2jkg7MP5QDMEp
         UXuOxk5Vd7T6ZNVdvpMyEgoCa81OrACqqwGob3tyYtj0N5GE5vo1tIhJoW2aWjNQvITH
         grGmFTIAVErnezdS0fgHF9bOfSGM0d8I+6pnUH14IL+P6Atd7FXhD4OpIOWoWZxY7pVa
         M2Vkypyvrg0AA8kQ+0pn8WbswoEXyVxSKafKjLJdyEZFkNjZGfKvgvULStwaGsvp1jsb
         Mf0p0KEJ1POZcSKcVXhs+P5DYsbV/7WYXvBnvO6k//dNCeElbxHAB+5BYxAMkzeHdwdN
         2YZA==
X-Gm-Message-State: APjAAAUKlUmRl25Uy5oiaeDvscNmdfmEBDvdu39dpTnrazFU08TgNYSM
        ptr+OFtgSnC7mGuviRSKtzSpaLRuXrvGJbWq7Ss=
X-Google-Smtp-Source: APXvYqwl+CcolgEuiHDJ5d3iGImkrYA0AzcC+jBZlbomvM4WeZ0E72xKKPGki6Miq7I+qMQaYqL0tAiTMKCmbUnR/FY=
X-Received: by 2002:a5e:d817:: with SMTP id l23mr6112819iok.282.1564479506244;
 Tue, 30 Jul 2019 02:38:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190724094306.1866-1-baijiaju1990@gmail.com>
In-Reply-To: <20190724094306.1866-1-baijiaju1990@gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 30 Jul 2019 11:41:20 +0200
Message-ID: <CAOi1vP8Q=fYZWv9qFZcyBdKV1VYq_yr3qWyAb44W=jHZ6zfYrA@mail.gmail.com>
Subject: Re: [PATCH] net: ceph: Fix a possible null-pointer dereference in ceph_crypto_key_destroy()
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 11:43 AM Jia-Ju Bai <baijiaju1990@gmail.com> wrote:
>
> In set_secret(), key->tfm is assigned to NULL on line 55, and then
> ceph_crypto_key_destroy(key) is executed.
>
> ceph_crypto_key_destroy(key)
>     crypto_free_sync_skcipher(key->tfm)
>         crypto_skcipher_tfm(tfm)
>             return &tfm->base;
>
> Thus, a possible null-pointer dereference may occur.
>
> To fix this bug, key->tfm is checked before calling
> crypto_free_sync_skcipher().
>
> This bug is found by a static analysis tool STCheck written by us.
>
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
>  net/ceph/crypto.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/ceph/crypto.c b/net/ceph/crypto.c
> index 5d6724cee38f..ac28463bcfd8 100644
> --- a/net/ceph/crypto.c
> +++ b/net/ceph/crypto.c
> @@ -136,7 +136,8 @@ void ceph_crypto_key_destroy(struct ceph_crypto_key *key)
>         if (key) {
>                 kfree(key->key);
>                 key->key = NULL;
> -               crypto_free_sync_skcipher(key->tfm);
> +               if (key->tfm)
> +                       crypto_free_sync_skcipher(key->tfm);
>                 key->tfm = NULL;
>         }
>  }

Hi Jia-Ju,

Yeah, looks like the only reason this continued to work after
69d6302b65a8 ("libceph: Remove VLA usage of skcipher") is because
crypto_sync_skcipher is a trivial wrapper around crypto_skcipher
added just for type checking AFAICT.

struct crypto_sync_skcipher {
    struct crypto_skcipher base;
};

Before that ceph_crypto_key_destroy() used crypto_free_skcipher(),
which is safe to call on a NULL tfm.

Applied with a slight modification -- I moved key->tfm = NULL under
the new if and amended the changelog.

https://github.com/ceph/ceph-client/commit/b3d79916ff99074d289d66f1643b423ae0008c50

Thanks,

                Ilya
