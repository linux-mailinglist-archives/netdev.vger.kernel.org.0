Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00E6C126F4A
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 22:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbfLSVBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 16:01:51 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:38674 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726981AbfLSVBv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 16:01:51 -0500
Received: by mail-oi1-f195.google.com with SMTP id l9so972562oii.5;
        Thu, 19 Dec 2019 13:01:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Rho6KjCVdHcPa3Pm2Hwz5ompKB2MxkmWTphxamICN90=;
        b=M5+N8u8FaZK7fB6OwNaLikLBB06Y0ZSktbKgydW/Anfr4fdEQ4afgx645i9Q8LfnbL
         6qQK1ub5YZTpS12B0tTU/xb2bXZ9VjrdmLzdXmKg+Zt7PT8kzEQ9q0OJ7+M+aQ6PKUsl
         yC1jBBAJUdNmoU06wcbI135LVBDsoCTlGpC+3saYWZFRp8d6obtviMxiDZjD4hjmGAxF
         tYHz4+x2+0PK/QspSZ/+1dSHJiYF2kPoDwUuGUxjL/FSHE0Ok0HcpuiLkDz0zm2i6F6Y
         cPkoQ2FT//AI1H7S+/vlwaXZZzIy2klD3l5EAAqlxVAvMi3rweN4ElWAF4yCZRs8Qvkb
         Z+eQ==
X-Gm-Message-State: APjAAAUhY2tC/hHaGcAyh/XgSVLAYdG65d2XXCEta+doDM+6SvPCQrn8
        JZgjrs0qaqRzFv1qhjKB5pv4RXZ2hl0EHZdFgXc=
X-Google-Smtp-Source: APXvYqwvA2BdXJ663aG+aWaAPgh2yntk+PKY9MC7GuJ4Ik36+blLWmshsTxHv/oZTHyJy/hEoDKwfxQJ4yQDOuTxN9I=
X-Received: by 2002:aca:36c5:: with SMTP id d188mr3157965oia.54.1576789310327;
 Thu, 19 Dec 2019 13:01:50 -0800 (PST)
MIME-Version: 1.0
References: <git-mailbomb-linux-master-8ffb055beae58574d3e77b4bf9d4d15eace1ca27@kernel.org>
 <CAMuHMdVgF0PVmqXbaWqkrcML0O-hhWB3akj8UAn8Q_hN2evm+A@mail.gmail.com> <CAM_iQpWOhXR=x10i0S88qXTfG2nv9EypONTp6_vpBzs=iOySRQ@mail.gmail.com>
In-Reply-To: <CAM_iQpWOhXR=x10i0S88qXTfG2nv9EypONTp6_vpBzs=iOySRQ@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 19 Dec 2019 22:01:39 +0100
Message-ID: <CAMuHMdXL8kycJm5EG6Ubx4aYGVGJH9JuJzP-vSM55wZ6RtyT+w@mail.gmail.com>
Subject: Re: refcount_warn_saturate WARNING (was: Re: cls_flower: Fix the
 behavior using port ranges with hw-offload)
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Cong,

On Thu, Dec 19, 2019 at 9:50 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> On Thu, Dec 19, 2019 at 2:12 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > I still see the below warning on m68k/ARAnyM during boot with v5.5-rc2
> > and next-20191219.
> > Reverting commit 8ffb055beae58574 ("cls_flower: Fix the behavior using
> > port ranges with hw-offload") fixes that.
> >
> > As this is networking, perhaps this is seen on big-endian only?
> > Or !CONFIG_SMP?
> >
> > Do you have a clue?
> > I'm especially worried as this commit is already being backported to stable.
> > Thanks!
>
> I did a quick look at the offending commit, I can't even connect it to
> any dst refcnt.
>
> Do you have any more information? Like what happened before the
> warning? Does your system use cls_flower filters at all? If so, please
> share your tc configurations.

No, I don't use clf_flower filters.  This is just a normal old Debian boot,
where the root file system is being remounted, followed by the warning.

To me, it also looks very strange.  But it's 100% reproducible for me.
Git bisect pointed to this commit, and reverting it fixes the issue.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
