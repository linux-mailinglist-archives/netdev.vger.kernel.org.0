Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 838784D6894
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 19:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245718AbiCKSmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 13:42:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233634AbiCKSmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 13:42:32 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87CD15F8EB
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 10:41:28 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id w12so16499807lfr.9
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 10:41:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=grwJQHpTejzQ9PPbrhyRjQ3f2c8M8MaXreOB3JRCzH4=;
        b=XHp3iURq9OeJVvf+OfCRzT7E/cMt2KAuZNAwrYLyP/pzLenBGQ8uLEBnp3WmTUS8nh
         xRLufqDVNmGWux/1S1hgA4vH49obaGQ9jwyXIaQ1y0Zy8eIP792BUl2Cewf+liru22iE
         i3hJ3p85HmBfcmjySUXC47mkMZJ5BchuXf6Xk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=grwJQHpTejzQ9PPbrhyRjQ3f2c8M8MaXreOB3JRCzH4=;
        b=SxOCLoX4N/uSF7gsqyCcLVFZFFlHXCZD6kc2RRFwqw5qVA8UTRtAaQn+YfNlVNRDI0
         aNbKDl5FcimoK+WqRFe+gx7B7e7LdF+pMKpa37aSCCBuGUtY5e1V4vKQ/+Or81jIrXK6
         iwrFhk2dBnSy9kfT2lkDjpwMW0/Mk+pnvQpRL3P0AZq+MkDLLQOm1UnrUR0aaHd99T7R
         WksH+BScuysJ6dQxbV6g4n5K7witqpyNDGcfAptOuu6KWpIiLzt8ucW2etKfsa9zXqXB
         9L+daeOzXwOq91JTf+MLwNJLeBvpBPvJU5nnLB3D1BdtvfotW2PbDopDpPxj6PQfoV/B
         w2+g==
X-Gm-Message-State: AOAM531/AzueA8PnNbYoJpP/6ivBoPvKsn9w8fOfAR9NhrFt7DU5szLa
        LBfpB9/eH5dd+5afe0ZaanqPw/w27CI67ztBews=
X-Google-Smtp-Source: ABdhPJwDu5S/ug6YZuZg5LaE4CA5eTaWdFI3W48MZR13nh3/7Q54P8PgvcwFLES1wM8WqtZHN6IlYg==
X-Received: by 2002:ac2:58d8:0:b0:442:bc4b:afb7 with SMTP id u24-20020ac258d8000000b00442bc4bafb7mr6686340lfo.99.1647024086597;
        Fri, 11 Mar 2022 10:41:26 -0800 (PST)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id f9-20020a05651232c900b0044377158635sm1750722lfg.37.2022.03.11.10.41.23
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Mar 2022 10:41:23 -0800 (PST)
Received: by mail-lf1-f41.google.com with SMTP id s25so16514258lfs.10
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 10:41:23 -0800 (PST)
X-Received: by 2002:a05:6512:3a83:b0:447:da72:43f1 with SMTP id
 q3-20020a0565123a8300b00447da7243f1mr6931391lfu.542.1647024082921; Fri, 11
 Mar 2022 10:41:22 -0800 (PST)
MIME-Version: 1.0
References: <CAHk-=whJX52b1jNsmzXeVr6Z898R=9rBcSYx2oLt69XKDbqhOg@mail.gmail.com>
 <20220304025109.15501-1-xiam0nd.tong@gmail.com> <CAHk-=wjesxw9U6JvTw34FREFAsayEE196Fi=VHtJXL8_9wgi=A@mail.gmail.com>
 <CAHk-=wiacQM76xec=Hr7cLchVZ8Mo9VDHmXRJzJ_EX4sOsApEA@mail.gmail.com> <20220311142754.a3jnnjqxpok75qgp@maple.lan>
In-Reply-To: <20220311142754.a3jnnjqxpok75qgp@maple.lan>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 11 Mar 2022 10:41:06 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi58pvQhMX2sRt7nKqwHAFAmn27MrJg3XbeJgio6ONgdA@mail.gmail.com>
Message-ID: <CAHk-=wi58pvQhMX2sRt7nKqwHAFAmn27MrJg3XbeJgio6ONgdA@mail.gmail.com>
Subject: Re: [PATCH 2/6] list: add new MACROs to make iterator invisiable
 outside the loop
To:     Daniel Thompson <daniel.thompson@linaro.org>
Cc:     Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        Jann Horn <jannh@google.com>,
        Kees Cook <keescook@chromium.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 11, 2022 at 6:27 AM Daniel Thompson
<daniel.thompson@linaro.org> wrote:
>
> It is possible simply to use spelling to help uncover errors in
> list_traverse()?

I'd love to, and thought that would be a lovely idea, but in another
thread ("") Barnab=C3=A1s P=C5=91cze pointed out that we actually have a fa=
ir
number of cases where the list member entries are embedded in internal
structures and have a '.' in them:

  https://lore.kernel.org/all/wKlkWvCGvBrBjshT6gHT23JY9kWImhFPmTKfZWtN5Bkv_=
OtIFHTy7thr5SAEL6sYDthMDth-rvFETX-gCZPPCb9t2bO1zilj0Q-OTTSbe00=3D@protonmai=
l.com/

which means that you can't actually append the target_member name
except in the simplest cases, because it wouldn't result in one single
identifier.

Otherwise it would be a lovely idea.

> For architectures without HAVE_LD_DEAD_CODE_DATA_ELIMINATION then the
> "obvious" extension of list_traversal_head() ends up occupying bss
> space. Even replacing the pointer with a zero length array is still
> provoking gcc-11 (arm64) to allocate a byte from bss (often with a lot
> of padding added).

I think compilers give objects at least one byte of space, so that two
different objects get different addresses, and don't compare equal.

That said, I'm not seeing your issue. list_traversal_head() is a
union, and always has that 'struct list_head' in it, and that's the
biggest part of the union.

IOW, the other parts are (a) never used for anything but their type
and (b) will not take up any new space that isn't already used by the
list_head itself.

                  Linus
