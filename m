Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 778CB4FF6E9
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 14:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233186AbiDMMjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 08:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232694AbiDMMjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 08:39:31 -0400
Received: from mail-vk1-xa36.google.com (mail-vk1-xa36.google.com [IPv6:2607:f8b0:4864:20::a36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C14E434B7;
        Wed, 13 Apr 2022 05:37:09 -0700 (PDT)
Received: by mail-vk1-xa36.google.com with SMTP id o14so769167vkf.13;
        Wed, 13 Apr 2022 05:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l91PaoNzkraHqeajdUVuvzQMezggMyac9Bnl2PBAwYE=;
        b=GY+Nx/NLjsUDY2KpKhXCF0f+wm3O1zKwOqSZqRMwSH/56LljWI42nzXFPSbOLyCzgT
         38WLFUE7x1wXVcgpN+m50/DObAWM4TnxUxxRmFhI/C9OoGZK4NuzYTGMq2Rm5gfC2W59
         5NLo7/rvy6vTcgAgP/s6fT6oILUlEPqJR7TkH7m5VJYlOAMtELQhO2QUn7l50LFhFp3p
         v6oSBLHRPNRnN3wVuNHT3YkYnjj2RPzO9KpRP3DWjy1xFP4HW+Br7ccBiLlarZcjMUVS
         U6i/JaRu2U861B3HZ466iOe9s1qpyrndnCtwiKI+X1ic2HRWNvuQH1WT8I3bhjPSOUIu
         CFHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l91PaoNzkraHqeajdUVuvzQMezggMyac9Bnl2PBAwYE=;
        b=K/9w5RqodWriEVvuKJ+pEH4qI4xncynenFD3UvhoB/swI2yswB1sTEYy3YcZDN7oQp
         dYp6UQhjUPh4RABVdSpizJpPeFnPtWiqMSgu2A6bHmtbsKKj4M3wIkjrAlUgo/u+HFRz
         67kkLnEGxV3x30urhkrXa8/fzukfWgN/czoQT0+Z8TklKwJj3E1ud2+4BOqHRuGQKW2V
         0r5PSrZoFLN5956z6+DGKX2iIfQoITySOijvaEyOMaA4ovF8Xub5rJgxtULBvXpv8sMF
         RLmKzmHHQSxZc8kRcY6KWLTOGMyyB22VLlG2ePJ62EpZe/9ZBHi4+JZrIpDZgDcrOh8t
         kz8A==
X-Gm-Message-State: AOAM5320VnjBgaWSL1kURKVF/+yVcKOIpCpDMjVMdMz80TE6cqcN+OgO
        YJGu5KcMZDv24xi8o/Mt1ep0tyZVrO0X7KZK1lg=
X-Google-Smtp-Source: ABdhPJxGJlkfPgu8vJf3w4y+p8nnMcci1I50j/3AishPt40LSnppecm72DbL0epYWf0Sht2/EZHHGcU9xC0srQzNp3g=
X-Received: by 2002:a1f:ac95:0:b0:345:2ade:e54b with SMTP id
 v143-20020a1fac95000000b003452adee54bmr8524580vke.3.1649853428705; Wed, 13
 Apr 2022 05:37:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220404151036.265901-1-k.kahurani@gmail.com> <20220404153151.GF3293@kadam>
In-Reply-To: <20220404153151.GF3293@kadam>
From:   David Kahurani <k.kahurani@gmail.com>
Date:   Wed, 13 Apr 2022 15:36:57 +0300
Message-ID: <CAAZOf25i_mLO9igOY5wiUaxLOsxMt3jrvytSm1wm95R-bdKysA@mail.gmail.com>
Subject: Re: [PATCH] net: ax88179: add proper error handling of usb read errors
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     netdev@vger.kernel.org,
        syzbot <syzbot+d3dbdf31fbe9d8f5f311@syzkaller.appspotmail.com>,
        davem@davemloft.net, jgg@ziepe.ca, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Phillip Potter <phil@philpotter.co.uk>,
        syzkaller-bugs@googlegroups.com, arnd@arndb.de,
        Pavel Skripkin <paskripkin@gmail.com>
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

On Mon, Apr 4, 2022 at 6:32 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:

Hi Dan

> >       int ret;
> >       int (*fn)(struct usbnet *, u8, u8, u16, u16, void *, u16);
> > @@ -201,9 +202,12 @@ static int __ax88179_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
> >       ret = fn(dev, cmd, USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> >                value, index, data, size);
> >
> > -     if (unlikely(ret < 0))
> > +     if (unlikely(ret < size)) {
> > +             ret = ret < 0 ? ret : -ENODATA;
> > +
> >               netdev_warn(dev->net, "Failed to read reg index 0x%04x: %d\n",
> >                           index, ret);
> > +     }
> >
> >       return ret;
>
> It would be better to make __ax88179_read_cmd() return 0 on success
> instead of returning size on success.  Non-standard returns lead to bugs.
>

I don't suppose this would have much effect on the structure of the
code and indeed plan to do this but just some minor clarification.

Isn't it standard for reader functions to return the number of bytes read?

Regards,
David.

>
> > @@ -1060,16 +1151,30 @@ static int ax88179_check_eeprom(struct usbnet *dev)
> >
> >               jtimeout = jiffies + delay;
> >               do {
> > -                     ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_SROM_CMD,
> > -                                      1, 1, &buf);
> > +                 ret = ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_SROM_CMD,
> > +                                        1, 1, &buf);
> > +
> > +                 if (ret < 0) {
> > +                         netdev_dbg(dev->net,
> > +                                    "Failed to read SROM_CMD: %d\n",
> > +                                    ret);
> > +                         return ret;
> > +                 }
> >
> >                       if (time_after(jiffies, jtimeout))
> >                               return -EINVAL;
>
> The indenting here is wrong.  Run scripts/checkpatch.pl on your patches.
>
> regards,
> dan carpenter
>
