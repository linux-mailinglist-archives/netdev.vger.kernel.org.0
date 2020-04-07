Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EAA21A05CC
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 06:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbgDGEfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 00:35:52 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50360 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgDGEfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 00:35:52 -0400
Received: by mail-wm1-f67.google.com with SMTP id x25so383671wmc.0;
        Mon, 06 Apr 2020 21:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sSkxWTuRD0sKq21kRPoKRlna2bsz89FT8o39f/x/Qug=;
        b=qCZvQep6dpUpOavOoWOqLek+uGC/jN+RmKU7Ie0mTunDoXWrwWnqAuP3TlVFpjtQtw
         Td6SyMkG6R5RHOi73MSNlo6coqhPh3GxmVeznZZ4I1AqAdN6BF5tv2elQQNvlZo69da6
         /ZUJQUp58K19yR3lTwV6wrcqDjirIZ4XFXVeiJwyEBbjIqCqu0eFuBKCEuVSyzga3WpX
         5aoUmD/RA/KQKHZx8O8gdjAdZf8UOt2ZuuHbyIprRDHbaxjyRR8m979DwtnUzQSAZZOh
         7kzebqkC0oBk5yYezXCt0ymiSf0y3nZv+3YV9BwnaVwY91ijtD/HTSGHr5sA7x1pCFMA
         3Vpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sSkxWTuRD0sKq21kRPoKRlna2bsz89FT8o39f/x/Qug=;
        b=jI6Co5bo6xdfnGJ+PEr3Jrbamb4VRng+kuVtuu0GXahiITc6YLtJL8o+l5F3VWxHHa
         0XQAoi8RD1lGgxrSQfItAMPdn1bjslwNTEvNiFInbjqlUSwNdPsSCKpN4cjLzIGtsfeE
         FYf+uH2rWXoQwNpbZHB89MXwPwKkAob6f2uaDw61+oIKU0PkZDRGcqCjgR35tucksYlg
         07THQ8d24b9LZrxXRtjj3bk0pF2HKE10b1F+Tg3XD75vziSqGIXaBs0wrKqKqNMYXGvC
         684VLrwUdm2cro/LItOBk/i680HJuUkBCXx5yiolCZGdHTrlSyH74Ppj41Ua4IU/M9iJ
         xyjg==
X-Gm-Message-State: AGi0PuZTYVOUP8a7/0dAoBLygwUFx8PqTReYCCZYbyBVBUpRUmuaBkP9
        p5WGKAp4bY07a57RSxi2IgUr8Vhkl3l9BljIBqE=
X-Google-Smtp-Source: APiQypJHb3EeIZpJfA5vWcniz0V3Ui8OvsHNRMp3/07GMGP8kNJZZBBoH4kInyF7w5yjaGBPjaHw0dLXOZso7eoj6d8=
X-Received: by 2002:a7b:c0d5:: with SMTP id s21mr247696wmh.107.1586234150840;
 Mon, 06 Apr 2020 21:35:50 -0700 (PDT)
MIME-Version: 1.0
References: <1585813930-19712-1-git-send-email-lirongqing@baidu.com>
 <6BB0E637-B5F8-4B50-9B70-8A30F4AF6CF5@gmail.com> <CAJ+HfNjTaWp+=na14mjMzpbRzM2Ea5wK_MNJddFNEJ59XDLPNw@mail.gmail.com>
 <7dbc67e0-aaca-9809-3cda-34f3d5791337@iogearbox.net>
In-Reply-To: <7dbc67e0-aaca-9809-3cda-34f3d5791337@iogearbox.net>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 7 Apr 2020 06:35:39 +0200
Message-ID: <CAJ+HfNhYqPuX6zC3QZi=aQ0=j_z2gNPBmkYohm-hkP7q4pE_ug@mail.gmail.com>
Subject: Re: [PATCH] xsk: fix out of boundary write in __xsk_rcv_memcpy
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Li RongQing <lirongqing@baidu.com>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kevin Laatz <kevin.laatz@intel.com>,
        Ciara Loftus <ciara.loftus@intel.com>,
        Bruce Richardson <bruce.richardson@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Apr 2020 at 22:13, Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 4/3/20 10:29 AM, Bj=C3=B6rn T=C3=B6pel wrote:
> > On Fri, 3 Apr 2020 at 00:22, Jonathan Lemon <jonathan.lemon@gmail.com> =
wrote:
> >> On 2 Apr 2020, at 0:52, Li RongQing wrote:
> >>
> >>> first_len is remainder of first page, if write size is
> >>> larger than it, out of page boundary write will happen
> >>>
> >>> Fixes: c05cd3645814 "(xsk: add support to allow unaligned chunk place=
ment)"
> >>> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> >>
> >> Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> >
> > Good catch!
> > Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> Applied, thanks!
>
> Bj=C3=B6rn, Magnus, others, would be really valuable to have a proper kse=
lftest suite
> in BPF for covering everything xsk related, including such corner cases a=
s Li fixed
> here, wdyt? ;-)
>

Indeed. It's *very much* overdue. :-(


Bj=C3=B6rn

> Thanks,
> Daniel
