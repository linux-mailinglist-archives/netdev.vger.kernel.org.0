Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3A8E4DA0E5
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 18:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350475AbiCORKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 13:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350372AbiCORKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 13:10:11 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53BB413D17
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 10:08:59 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id g17so34163731lfh.2
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 10:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=89AapUKE/1pFpkNlzVSvl0gcg/r2kqLZ2/9LmCBzmGw=;
        b=eIytPWVlHZG2c+3ssVjE3ER93sxCwkcHLBBjPEF/CN2OkYiJ1qyEanUT5e2Fng/dvQ
         cTz2EqvgfhPaL6KT/YJ1aKcd5EWDAWbwCu0qrNrZPRj+zxQ4mZzMCdTXGsGsPQfjic5y
         /a8HTCfZuBmRijJeDeSHHPfXo3cwN72mlQj5Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=89AapUKE/1pFpkNlzVSvl0gcg/r2kqLZ2/9LmCBzmGw=;
        b=ksstczpGdd4580Ai28YiWx+5q0tNR7Ux4QoGzOrQu8h0Hr859vzqQiCCaBZxd2cxsc
         RrDwSZhi9srm9HHSlJTT2fpJvgpG0l9XESZytoxGiI3c+qfggAK7ulP3GGFwCUC4Gb6H
         EXBBP87Czgv/PfT9oMa/adWHiucExv1H/FujMZkheCccMaY2HCmzf9VrGH0Gx+NvIow6
         dxkuzNP4Y+1uReRTLimIjANd8BGdNYW2RomfYaSYK/W1KvqoozWlBnFMSzjNQqO0WxXw
         2lUfwph2nq096sSEU4kWWn1QMXCAmdOClAHeA1WtFRmmTsxTiduAbHAGWZdaiT+BVX2A
         xbmg==
X-Gm-Message-State: AOAM5308pP+WyRSROFv68QkZ3TBelbC+2dFYgNM0FnkM/VUNXI4KYNbp
        SFD8ZP2RAr6FoevvSZQxRVzhRGVZwc3mLrU4
X-Google-Smtp-Source: ABdhPJzHlMfJgIDJjivjNdLGCi9QAZ6HD856lHRW1eyb2qFYkpmCxA9zTwVJodruCT9/I6OAQul/dg==
X-Received: by 2002:ac2:434c:0:b0:445:bfb1:c37a with SMTP id o12-20020ac2434c000000b00445bfb1c37amr16850058lfl.657.1647364137303;
        Tue, 15 Mar 2022 10:08:57 -0700 (PDT)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com. [209.85.167.52])
        by smtp.gmail.com with ESMTPSA id q7-20020a2eb4a7000000b0024801ba3d6csm4284121ljm.64.2022.03.15.10.08.53
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Mar 2022 10:08:54 -0700 (PDT)
Received: by mail-lf1-f52.google.com with SMTP id l20so34096556lfg.12
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 10:08:53 -0700 (PDT)
X-Received: by 2002:ac2:4203:0:b0:448:8053:d402 with SMTP id
 y3-20020ac24203000000b004488053d402mr10011514lfh.687.1647364132924; Tue, 15
 Mar 2022 10:08:52 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000009e7a1905b8295829@google.com> <00000000000003887a05da3e872c@google.com>
In-Reply-To: <00000000000003887a05da3e872c@google.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 15 Mar 2022 10:08:36 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj4HBk7o8_dbpk=YiTOFxvE9LTiH8Gk=1kgVxOq1jaH7g@mail.gmail.com>
Message-ID: <CAHk-=wj4HBk7o8_dbpk=YiTOFxvE9LTiH8Gk=1kgVxOq1jaH7g@mail.gmail.com>
Subject: Re: [syzbot] KASAN: out-of-bounds Read in ath9k_hif_usb_rx_cb (3)
To:     syzbot <syzbot+3f1ca6a6fec34d601788@syzkaller.appspotmail.com>
Cc:     Andrey Konovalov <andreyknvl@google.com>,
        ath9k-devel@qca.qualcomm.com, chouhan.shreyansh630@gmail.com,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:USB GADGET/PERIPHERAL SUBSYSTEM" 
        <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 15, 2022 at 2:36 AM syzbot
<syzbot+3f1ca6a6fec34d601788@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit
> 09688c0166e7 ("Linux 5.17-rc8")

No, I'm afraid that means that the bisection is broken:

> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=140283ad700000

and yeah, looking at that log it looks like every single run has

  testing commit [...]
  run #0: crashed: KASAN: use-after-free Read in ath9k_hif_usb_rx_cb
  ...
  # git bisect good [...]

and you never saw a "bad" commit that didn't have the issue, so the
top-of-tree gets marked "good" (and I suspect you intentionally mark
the broken case "good" in order to find where it got fixed, so you're
using "git bisect" in a reverse way).

I didn't look closer, but it does seem to not reproduce very reliably,
maybe that is what confused the bot originally.

                   Linus
