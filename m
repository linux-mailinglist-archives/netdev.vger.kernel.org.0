Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54A98503671
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 14:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231828AbiDPLw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 07:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbiDPLwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 07:52:21 -0400
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E3B563C3;
        Sat, 16 Apr 2022 04:49:49 -0700 (PDT)
Received: by mail-vs1-xe2a.google.com with SMTP id i186so8894634vsc.9;
        Sat, 16 Apr 2022 04:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/pFssxoLZmPuWgKi5vncIMSo1DCdax1EcoWBNQif+HM=;
        b=D+xkEg1a6hjF1V3UTFFTmAqCKPMeLHkneGOn8hpsmi57kTSwyip+IMCZrj+bER4Duk
         7v4NA8FQMiEUz6XzVEOxu+E8Lj9Dauk/WdZI52PlGVbMNo8QArXOZoJQRVcaug2ySAq7
         DnBrKrjR5D3dtThLWaHXkpg/aCaur5J7NdvtsHEizAs4AOkTeygAgYIuq/Ww0Ovh+zzs
         uHuYtYF0W8DrUNDC1Pj3cYALQF0w9AGPkBuFBfBpow1WomPdiJsKmw6BUnqiIgYPMe2W
         r4JxsTdMAV5dbdj2VnLno8e3cMna5cgyt3XIk3V/QxUdFB8KoUa9W1KkDKzacrMCCogA
         kHBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/pFssxoLZmPuWgKi5vncIMSo1DCdax1EcoWBNQif+HM=;
        b=LaLqS9ABqkDC80eKzcyj69ohKFcVhF58E2ZzW9qTBOwUykszinhXk//+QCyFe4B8fD
         tuvgRtWbSdBUDskdbXMEmPFMztlQXwMfWC91pOurZyZAbVhG5l3kQ4dRK7C7Mx/AKnKf
         a1UxwGV4gdEhSTReHAoaru4l01TteMdGrAFY1ad+GOX6k8vpU7+0h50M5WrjPwkI+42g
         8bsJt3ysnda6L+nQZsr88zA4Fe9OWVeKqofRlpD3yCRmjfrNgmWV8pPGhm4oClv9ReoL
         knueG6ghplpWruDP02h8YUOs64yV0AsGxXrCkxe5g7ti+tFykjluJtTrtcxswET00WVA
         vXeQ==
X-Gm-Message-State: AOAM533FnDfx7HR5+l7UbmUnfYskWKg4qu+Zq/hL6nGktJ6KoBk3ia3i
        IpWWb14Ksk8dSmdK1d9pb+rNBa0ViT/plEoSg90=
X-Google-Smtp-Source: ABdhPJzV0vJqdRlkVn0eXLetCb0I4Oj/t7WT0wQIPKQWRfA8TMOAoDvltO8LyX0LPgc4HoeBZl/BvARKr7B62um/xHU=
X-Received: by 2002:a67:2d51:0:b0:32a:c2b:78c4 with SMTP id
 t78-20020a672d51000000b0032a0c2b78c4mr758801vst.36.1650109788662; Sat, 16 Apr
 2022 04:49:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220416074817.571160-1-k.kahurani@gmail.com> <65c52645-26e8-ff2b-86dc-b5dd697317f9@gmail.com>
In-Reply-To: <65c52645-26e8-ff2b-86dc-b5dd697317f9@gmail.com>
From:   David Kahurani <k.kahurani@gmail.com>
Date:   Sat, 16 Apr 2022 14:49:37 +0300
Message-ID: <CAAZOf27Q-QQ51pGO1gFETNR0ASg6zmxF4HUFUVn77oL3Cs7LEg@mail.gmail.com>
Subject: Re: [PATCH] net: ax88179: add proper error handling of usb read errors
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     netdev@vger.kernel.org,
        syzbot <syzbot+d3dbdf31fbe9d8f5f311@syzkaller.appspotmail.com>,
        davem@davemloft.net, jgg@ziepe.ca, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Phillip Potter <phil@philpotter.co.uk>,
        syzkaller-bugs@googlegroups.com, arnd@arndb.de,
        Dan Carpenter <dan.carpenter@oracle.com>
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

On Sat, Apr 16, 2022 at 2:10 PM Pavel Skripkin <paskripkin@gmail.com> wrote:
>
> Hi David,

Hi Pavel.

>
> one more small comment
>
> On 4/16/22 10:48, David Kahurani wrote:
> > Reads that are lesser than the requested size lead to uninit-value bugs.
> > In this particular case a variable which was supposed to be initialized
> > after a read is left uninitialized after a partial read.
> >
> > Qualify such reads as errors and handle them correctly and while at it
> > convert the reader functions to return zero on success for easier error
> > handling.
> >
> > Fixes: e2ca90c276e1 ("ax88179_178a: ASIX AX88179_178A USB 3.0/2.0 to
> > gigabit ethernet adapter driver")
> > Signed-off-by: David Kahurani <k.kahurani@gmail.com>
> > Reported-and-tested-by: syzbot+d3dbdf31fbe9d8f5f311@syzkaller.appspotmail.com
> > ---
>
> [code snip]
>
> > @@ -1295,6 +1439,7 @@ static int ax88179_led_setting(struct usbnet *dev)
> >   static void ax88179_get_mac_addr(struct usbnet *dev)
> >   {
> >       u8 mac[ETH_ALEN];
> > +     int ret;
> >
> >       memset(mac, 0, sizeof(mac));
> >
> > @@ -1303,8 +1448,12 @@ static void ax88179_get_mac_addr(struct usbnet *dev)
> >               netif_dbg(dev, ifup, dev->net,
> >                         "MAC address read from device tree");
> >       } else {
> > -             ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_NODE_ID, ETH_ALEN,
> > -                              ETH_ALEN, mac);
> > +             ret = ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_NODE_ID, ETH_ALEN,
> > +                                    ETH_ALEN, mac);
> > +
> > +             if (ret)
> > +                     netdev_dbg(dev->net, "Failed to read NODE_ID: %d", ret);
> > +
> >               netif_dbg(dev, ifup, dev->net,
> >                         "MAC address read from ASIX chip");
> >       }
>
>
> This message sequence is confusing.
>
> In case of ax88179_read_cmd() failure mac read from device actually
> failed, but message says, that it was successfully finished.

I suppose the code should return in case of an error that way the next
message does not get executed.

Thanks for the review! Will fix it and the other issue in the next version.

>
>
>
>
>
> With regards,
> Pavel Skripkin
