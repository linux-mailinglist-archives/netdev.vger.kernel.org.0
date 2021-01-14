Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 338D52F6D9A
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 22:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730488AbhANV6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 16:58:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728455AbhANV6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 16:58:06 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E211C061575
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 13:57:25 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id h186so4196147pfe.0
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 13:57:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XQSmigQbNrshewpWb+i1jB++SvtRhdfcAWRj2gTIWtA=;
        b=MNuxe2EtEokBqflQbiJ0PLR84ZjrQLd0Yi2xsq5ODoqqoxWu8C9jsc5ydlkK39q7nw
         oQmR/cxWMR3mdcR0EbfVxzqKqjFjIV1VJ3CrR09ajKH2UMt8WQYHuMY5dtlXSfODkjrE
         Hk3uHCH2TnVPrYvMI/Sj7CX5zRamGyNqHbWD4BSNNILpmy9Flpcla/eAKGxYg7NjEE3M
         /+Y7T1oDbHEGAF1mr6U2K9pNcWkyNN4Upfev6PWmwZsX+W58tDjX5Cd+/M7CCva2dWsP
         /67shQqcioPEGY+kRonvO/aC50qbtpaBh/Y1Z1ZnzoiS1af0PTQJ1QSqQkrnNl598NuC
         lAkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XQSmigQbNrshewpWb+i1jB++SvtRhdfcAWRj2gTIWtA=;
        b=IhQbLfTsnVDQOnEUxvgZ0oTdSZjhSVX3EW+VAbc2qGT7lP74KN2NBXm9JqyYHNtHH+
         T05WJXIdwFIgOAN729Ed9AoPWMvoCsAN/gIr9cXIucrmoaxhdaWWmNzn3BgdF8F3mQxM
         yGTd0agQ3aJXa5N7Eb20PeOzHiQJk9soAJ6q5FHVm4ccwsCRaKq7pvjgY8jsXQV51MtA
         HCUyhWxt3Cl39841D9yMGWSckGF4YEVEw5HUFirXpV2D0QRcHA84oSFmZH7FRSsRTmt/
         tTFLMttQR3NDNqG4iyAYexoPLxq8jasOU32ZnTnopIrBpf0GwcWs88wmFa/H7BtQZDx6
         GtSw==
X-Gm-Message-State: AOAM531OwdmuB9fW2K/SmC47I9Ckm8s9m/COhp7p9V0uKVj3byWL1xZt
        owncMlsimBubDe5nJz/3dawKj2hLdZVQHUP6yJE=
X-Google-Smtp-Source: ABdhPJw5SCjYOXbGvmndw8lIqxABAn59ULEMZJTYZ56QRgvOAEW9Yb12KX0il5TfXD9AMfkXEq8XpPYVeD3cc2Hq8PI=
X-Received: by 2002:a63:1707:: with SMTP id x7mr9444666pgl.266.1610661444799;
 Thu, 14 Jan 2021 13:57:24 -0800 (PST)
MIME-Version: 1.0
References: <20210114210749.61642-1-xiyou.wangcong@gmail.com> <20210114133625.0d1ea5e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210114133625.0d1ea5e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 14 Jan 2021 13:57:13 -0800
Message-ID: <CAM_iQpVAer0tBocMXGa0G_8jqJVz5oJ--woPo+TrtzVemyz+rQ@mail.gmail.com>
Subject: Re: [Patch net v3] cls_flower: call nla_ok() before nla_next()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        syzbot <syzbot+2624e3778b18fc497c92@syzkaller.appspotmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Xin Long <lucien.xin@gmail.com>, Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 1:36 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 14 Jan 2021 13:07:49 -0800 Cong Wang wrote:
> > -                     if (msk_depth)
> > -                             nla_opt_msk = nla_next(nla_opt_msk, &msk_depth);
> >                       break;
> >               default:
> >                       NL_SET_ERR_MSG(extack, "Unknown tunnel option type");
> >                       return -EINVAL;
> >               }
> > +
> > +             if (!nla_opt_msk)
> > +                     continue;
>
> Why the switch from !msk_depth to !nla_opt_msk?

It is the same, when nla_opt_msk is NULL, msk_depth is 0.
Checking nla_opt_msk is NULL is more readable to express that
mask is not provided.

>
> Seems like previously providing masks for only subset of options
> would have worked.

I don't think so, every type has this check:

                        if (key->enc_opts.len != mask->enc_opts.len) {
                                NL_SET_ERR_MSG(extack, "Key and mask
miss aligned");
                                return -EINVAL;
                        }

which guarantees the numbers are aligned.

Thanks.
