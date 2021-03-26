Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6EB34A2F2
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 09:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbhCZIGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 04:06:37 -0400
Received: from mail-ua1-f47.google.com ([209.85.222.47]:45704 "EHLO
        mail-ua1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbhCZIGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 04:06:14 -0400
Received: by mail-ua1-f47.google.com with SMTP id l15so1344709uao.12
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 01:06:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aoGYqDQgbPkpmbJqEyyVy5NpZrzn//YXVSwX7faHNqw=;
        b=JW9JkoWlwFvsAsbZ6UjhaA8gI5EM2SmZ3f/2iaB6Ri9s4D/cIrJob2itnX0Mjhgn5U
         DteJKoBxH8WOGVg7RNx9qU2gbTgoZ7MYjcAk9GHggvInja4zmh4Fzig3ufLIOTvF6dUp
         6Pf538P4M/9h4AcTL/mQzdUdado2ndgieWlFVLf9zuP2RHirneuHu+AF+wT39KkrA0mb
         sWIUIQlbkOE/WPncu9K6p+SyQphlcHJkiICl2Mwq1Es1yg54LGyt5F6NuOL3xplHLUnU
         R0tRj187FY4Zad2F2HQPDtFdvZf+vPQd2sWDjQBdfTLP1YjU9nyLDMepDnAGQQmLIdbl
         d2FQ==
X-Gm-Message-State: AOAM532gu3cuJmBh4RE/WpDUjePWJZPQsO0E+NPsboA71UJ3buNoioKY
        9SUzl2FB7doEtB5HUgzvfxcFf+PJRGLxNBpQtso=
X-Google-Smtp-Source: ABdhPJybVlT253guWOL/vfEOlRK22SuGCqzMqptZtrbfUDAXwcvPLgM6dE9MUyb9VrQLx8Gd+FvQo+ddbATWlxV18H8=
X-Received: by 2002:ab0:64cf:: with SMTP id j15mr7219184uaq.4.1616745974091;
 Fri, 26 Mar 2021 01:06:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210325223119.3991796-1-anthony.l.nguyen@intel.com> <20210325223119.3991796-2-anthony.l.nguyen@intel.com>
In-Reply-To: <20210325223119.3991796-2-anthony.l.nguyen@intel.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 26 Mar 2021 09:06:02 +0100
Message-ID: <CAMuHMdXo_UOf_QLKSxtgm5ByvSAo_Uy_h2RTpy8B=xqdUGaBNQ@mail.gmail.com>
Subject: Re: [PATCH net 1/4] virtchnl: Fix layout of RSS structures
To:     anthony.l.nguyen@intel.com,
        Norbert Ciosek <norbertx.ciosek@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, sassmann@redhat.com,
        sridhar.samudrala@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Anthony, Norbert,

Thanks for your patch!

On Thu, Mar 25, 2021 at 11:29 PM Tony Nguyen <anthony.l.nguyen@intel.com> wrote:
> From: Norbert Ciosek <norbertx.ciosek@intel.com>
>
> Remove padding from RSS structures. Previous layout
> could lead to unwanted compiler optimizations
> in loops when iterating over key and lut arrays.

From an earlier private conversation with Mateusz, I understand the real
explanation is that key[] and lut[] must be at the end of the
structures, because they are used as flexible array members?

> Fixes: 65ece6de0114 ("virtchnl: Add missing explicit padding to structures")
> Signed-off-by: Norbert Ciosek <norbertx.ciosek@intel.com>
> Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

> --- a/include/linux/avf/virtchnl.h
> +++ b/include/linux/avf/virtchnl.h
> @@ -476,7 +476,6 @@ struct virtchnl_rss_key {
>         u16 vsi_id;
>         u16 key_len;
>         u8 key[1];         /* RSS hash key, packed bytes */
> -       u8 pad[1];
>  };
>
>  VIRTCHNL_CHECK_STRUCT_LEN(6, virtchnl_rss_key);
> @@ -485,7 +484,6 @@ struct virtchnl_rss_lut {
>         u16 vsi_id;
>         u16 lut_entries;
>         u8 lut[1];        /* RSS lookup table */
> -       u8 pad[1];
>  };

If you use a flexible array member, it should be declared without a size,
i.e.

    u8 key[];

Everything else is (trying to) fool the compiler, and leading to undefined
behavior, and people (re)adding explicit padding.



--
Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
