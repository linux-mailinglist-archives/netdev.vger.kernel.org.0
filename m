Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3200622069
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 00:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbiKHXmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 18:42:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiKHXmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 18:42:00 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE59156565;
        Tue,  8 Nov 2022 15:41:59 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id l8so23388849ljh.13;
        Tue, 08 Nov 2022 15:41:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eT7O5eQLDvzcmFKSKwK9EoVR3gZts5XZRjZirOo18Eo=;
        b=LIj/+aGozaURloAOaqWAmoVEXdQCpqeinYmHbcDRz3f3JCiQd1nzoPwn8wPYJ/VsT4
         Wj3jA3+DjTOUCf0c9PmtjyLztWOq4UVULnAVis7OJCja37TjU+q+BOXuDwMYf+9VWpCz
         MocMTq617Ocoha4ggogmK/eLLa+8XcM7Axrjjg+jAnCK0/i5/UeCEQLc2cDIoVagbsLC
         POql4GpimOx9j+2MS384YdDJSNqwbzwEFfA8nuKgkhhmlCibcbKgtyI3NarTpbOOE0Vc
         vRvLAgAftCt9/Mat1ae1vsH2Wp5J8t0Gek8Ao1KnjynfUdjB7jPP3SFmZDck1eG9DqIo
         kqTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eT7O5eQLDvzcmFKSKwK9EoVR3gZts5XZRjZirOo18Eo=;
        b=e2zRLwiWYQo2DF9/c3PP6roxX9bQhwHtvige5P7uVu1MCMyGS50emt4xD6x7BekyuT
         52wqvd2LmFfakyrLJD2vkdQjH4NRjRVUJIIbJS6/zJcAYEbEnyOfVxTrcV3JaooOts0U
         PPsklqqJLLGsjxhS33GN/CHjzk2MJvwXjuS3CofYAI0E/u09fMe5ViL9FChX6KqzxG3i
         K7P1OiblK8dnc1AxmN3pCyM9EiUIykyS0oAUcLT7lY5RxX7hPrjjKQNPZk/bMjV4utHO
         Zt3Wiy4i2rEDUspuAMmMG8MVOORME6iNtraW0hRPn4am6KZiJkM+n23kt7UmCIOWX0gQ
         irMw==
X-Gm-Message-State: ACrzQf0TD9+KadvPaXLXE2uRhRXj0d7jajfPZv8QqWavOLAdDyUJbR0z
        2ALuHepvh78JGBDr8Fsjj0DEgTBnPEgfTIsHJw0qd0TZZTU=
X-Google-Smtp-Source: AMsMyM7QtmFUyDVKVR+auY0BKjNsydH3B0PKIE+OAwmDI7DkgaifUG09/juueV9iEgjva8KEGzDdpzkX5xdXUeD6DdI=
X-Received: by 2002:a2e:8743:0:b0:277:10a8:3e8f with SMTP id
 q3-20020a2e8743000000b0027710a83e8fmr18875031ljj.423.1667950918091; Tue, 08
 Nov 2022 15:41:58 -0800 (PST)
MIME-Version: 1.0
References: <20221108112308.3910185-1-bobo.shaobowang@huawei.com>
In-Reply-To: <20221108112308.3910185-1-bobo.shaobowang@huawei.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Tue, 8 Nov 2022 15:41:46 -0800
Message-ID: <CABBYNZJxkkrmuq+2LS3PAbhBCdE5oAkMuw_yggsXW=X0j8CCTw@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: hci_conn: Fix potential memleak in iso_listen_bis()
To:     Wang ShaoBo <bobo.shaobowang@huawei.com>
Cc:     luiz.von.dentz@intel.com, pabeni@redhat.com, liwei391@huawei.com,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wang,

On Tue, Nov 8, 2022 at 3:24 AM Wang ShaoBo <bobo.shaobowang@huawei.com> wrote:
>
> When hci_pa_create_sync() failed, hdev should be freed as there
> was no place to handle its recycling after.

The patch itself seems fine but the description is misleading since we
are not freeing the hdev instead we are jus releasing the reference we
got.

> Fixes: f764a6c2c1e4 ("Bluetooth: ISO: Add broadcast support")
> Signed-off-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
> ---
>  net/bluetooth/iso.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
> index f825857db6d0..4e3867110dc1 100644
> --- a/net/bluetooth/iso.c
> +++ b/net/bluetooth/iso.c
> @@ -880,6 +880,9 @@ static int iso_listen_bis(struct sock *sk)
>
>         hci_dev_unlock(hdev);
>
> +       if (err)
> +               hci_dev_put(hdev);

Not sure why you are not always calling hci_dev_put?

>         return err;
>  }
>
> --
> 2.25.1
>


-- 
Luiz Augusto von Dentz
