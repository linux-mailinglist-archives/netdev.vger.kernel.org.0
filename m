Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A82DE4FC019
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 17:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344650AbiDKPSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 11:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347749AbiDKPRn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 11:17:43 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440861B1;
        Mon, 11 Apr 2022 08:15:29 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id r13so31605194ejd.5;
        Mon, 11 Apr 2022 08:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ly8qeDVw7zF5NU0RjXFxoEFBwNsxc6leMxYfyV7Srm4=;
        b=HhWEYM04cPm9rnN/yhveILDzOYkGL91YRYmt95vUt0Xgv++KwaofLEaM+QYcg1VQim
         eI+8pQNXd05xIfuyLgsNNEIRoBfHBpm81KD1h9KGUNXdIidTIjE6gnQJF1fsgYdka6Ju
         eDSXwT4zR9shC7vOcScpbX51j52JcYAxZVzsof3ujKii8CZ63XEujKBEgQA+cDmAoiEF
         ZPqeex0+BC9vd3sSSnsu7Z+BphG/Rxxx2IK1tra+rv8ssyh3ViK3TvtaezpGues37FuD
         djGUgqnavIroXqKNC5F7CcH0V0Fkv+6gZe2SaPp9o3MRi4T49ZUOZwP32XVOtHoHkG5f
         U5Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ly8qeDVw7zF5NU0RjXFxoEFBwNsxc6leMxYfyV7Srm4=;
        b=xC7uQUS59FKcySJ5xwxG2m96rRCmozoJWHO81YK9k7SsXPXy6ifZLhV10XsqysI/2K
         qp9wgjl5FhtFQ524msdGINg0rbPIoVvL+IyoYxH/le4Mut1ZKeHs/Pz1y6fGcNKqrvFj
         8c34nv/DsKruSZFOZCWa2HSB0uKeNDelRejgnuBhoPpVm1INuC0AwoC4stV0hJM4bdUC
         r+fNb0l88luKufha1h95eaBCzr0lRJOcC5r+Am+Qz2sWpcFPsTjmwJff1urjZRXWlzyI
         XzrzgEGs8DJUhbB1LD18wPINMNqjfO4LoxggCIzVHnpcFMYEFmUh8t9xKOPiFfNBwHwl
         P/Lg==
X-Gm-Message-State: AOAM5321Azab5BTryhtLkcZpS8C3W1hNmvPpI5bh6rVLXP3KPJXvj7yO
        ipnnKDPK2RyH1sdM87JGNsCSWUNFAyf2MFsRzU/c6Py8srs=
X-Google-Smtp-Source: ABdhPJzEBVQ3sO6Q6oQG9NLtTLt17jGA872K66xLcQMJiFjD4HIZRf8vEChLi9Dy3MT+eDvoptY6zRn18WvVv8eAb78=
X-Received: by 2002:a17:907:968e:b0:6db:aed5:43c8 with SMTP id
 hd14-20020a170907968e00b006dbaed543c8mr30685289ejc.636.1649690127832; Mon, 11
 Apr 2022 08:15:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220404151036.265901-1-k.kahurani@gmail.com> <6b6a8f5c-ceb9-ce97-bf79-d7634b433135@gmail.com>
In-Reply-To: <6b6a8f5c-ceb9-ce97-bf79-d7634b433135@gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 11 Apr 2022 18:11:14 +0300
Message-ID: <CAHp75VdkPJuHLFfQzPS==G_K1fqai53eT-=Gh-kL9mTED1x2fw@mail.gmail.com>
Subject: Re: [PATCH] net: ax88179: add proper error handling of usb read errors
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     David Kahurani <k.kahurani@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        syzbot+d3dbdf31fbe9d8f5f311@syzkaller.appspotmail.com,
        "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB <linux-usb@vger.kernel.org>,
        Phillip Potter <phil@philpotter.co.uk>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 5, 2022 at 3:05 AM Pavel Skripkin <paskripkin@gmail.com> wrote:
> On 4/4/22 18:10, David Kahurani wrote:
> > Reads that are lesser than the requested size lead to uninit-value bugs. Qualify
> > such reads as errors and handle them correctly.

> I'd personally cut this log a bit and would add this part of the initial
> report
>
> Local variable eeprom.i created at:
>   ax88179_check_eeprom drivers/net/usb/ax88179_178a.c:1045 [inline]
>   ax88179_led_setting+0x2e2/0x30b0 drivers/net/usb/ax88179_178a.c:1168
>   ax88179_bind+0xe75/0x1990 drivers/net/usb/ax88179_178a.c:1411
>
> Since it shows exactly where problem comes from.
>
> I do not insist, just IMO

I insist though. It will reduce the resource consumption (i.e. storage
and network load on cloning / pulling) a lot (taking into account
multiplier of how many Linux kernel source copies are around the
globe) and hence become more environmentally friendly.

-- 
With Best Regards,
Andy Shevchenko
