Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC4A6343622
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 02:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbhCVBIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 21:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbhCVBHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 21:07:49 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E369EC061574;
        Sun, 21 Mar 2021 18:07:48 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id il9-20020a17090b1649b0290114bcb0d6c2so2245688pjb.0;
        Sun, 21 Mar 2021 18:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xhXt1FGcb/LZno/gC2lXGpxdzYQ5CNgHFefjTz8i1cE=;
        b=W/gvUx583+bd2MCxyqj0q6RMqNs8nRP96JWMlaeB+CPksNRS7jz7Hbu+rpex8aBHDl
         +MP3riYtIzJVWQzocy2aX2HdbP56o6XWo96mYKJTzsURpHZGgMfESES5joojfP9yg/3l
         cWlzikLethtROV29IExdJXobOqd3QfjdI5lKQmBxrJRlHkHzB+MDwyscck4aA/FvlWqa
         /3S0jA8JsXeSEeBof7qWCUkmKq0QyfvAmi+4leTcx47a0yrtm0/DYUyWZOEnZMKwav/y
         yfmwF4V0SxuzwQaYFXl9XBhvTCbVHdzIEkDKUv2naukdSM1pxKEemiAlxgpRbTxNCW+N
         iw2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xhXt1FGcb/LZno/gC2lXGpxdzYQ5CNgHFefjTz8i1cE=;
        b=JNyBZDhxllQyIjF5DJhxqC4PlzF5EQEUHK58u/H+BLI1UOKkisce2Ed5CuM3L8BQZ1
         ZdTTu0dRBNU17j/Qafr/1zRerZ9OzVlUU3Cq62i8qeD64xSg/5/lTKVKRiDbJWi9euFP
         vFmdxJ8UPGEicj+AWRRieTvQ4YZs8fR+ebvlLWhRnx1oNI1LkLef3+SM/uqcX9zKy/1k
         iVd6K7XDJ6q8ig4ofdxDxE04f1f67u2dAEghgxW8VFyVx26o12QySaorso4hZ7UlEHhN
         3E/UUfiuK58Tp6H9ymChXI4Hgh4PsG8Oh4wzlIfHQNaPHwZxCoTodLHM52briWHZUntd
         Z4yA==
X-Gm-Message-State: AOAM530GbezsisP9djtEBsdpXqV2Ep0xnwv8pE9CSXXdloK/ZTVhDziM
        +DUc3z00Yo5bYh/0KFQxU7KOU0/xRquSAohGfKQ=
X-Google-Smtp-Source: ABdhPJzM4mWum4CATQ6jSa3DgF4hrMhWV7EmwvEB8HKCGtmzK9wK5E6A5Yd2+J6PovpQnYNp7qYtzPPzzPJ1O/wizuw=
X-Received: by 2002:a17:90a:ce92:: with SMTP id g18mr10704541pju.52.1616375268541;
 Sun, 21 Mar 2021 18:07:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210321163210.GC26497@amd>
In-Reply-To: <20210321163210.GC26497@amd>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 21 Mar 2021 18:07:37 -0700
Message-ID: <CAM_iQpWb_s_rPzi-i=Fhgk4xCPSY7N8FBjt_p_6qoZLr5HgAwA@mail.gmail.com>
Subject: Re: net/dev: fix information leak to userspace
To:     Pavel Machek <pavel@denx.de>
Cc:     kernel list <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 21, 2021 at 9:34 AM Pavel Machek <pavel@denx.de> wrote:
>
> dev_get_mac_address() does not always initialize whole
> structure. Unfortunately, other code copies such structure to
> userspace, leaking information. Fix it.

Well, most callers already initialize it with a memset() or copy_from_user(),
for example, __tun_chr_ioctl():

        if (cmd == TUNSETIFF || cmd == TUNSETQUEUE ||
            (_IOC_TYPE(cmd) == SOCK_IOC_TYPE && cmd != SIOCGSKNS)) {
                if (copy_from_user(&ifr, argp, ifreq_len))
                        return -EFAULT;
        } else {
                memset(&ifr, 0, sizeof(ifr));
        }

Except tap_ioctl(), but we can just initialize 'sa' there instead of doing
it in dev_get_mac_address().

Thanks.
