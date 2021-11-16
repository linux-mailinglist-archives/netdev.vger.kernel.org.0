Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E08D4535B0
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 16:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238223AbhKPPZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 10:25:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238262AbhKPPZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 10:25:18 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C89EC061200
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 07:22:16 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id i5so38342993wrb.2
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 07:22:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BRoTzAi8DELPagI4OEPtjrVPhqomnGXRwr1h/q3kitA=;
        b=hLcEIX9LM53HadnNd9WMN3oBF/ZkBzarHhwWwFWvgKEdWnsjTdTTxDBxYoZ5m44Z14
         WYcW62eOnhT9vSh1Z3PgH28z8LF3PGwhGKjS6IhS7z6qKKC21fcCEdqsA14YPmpWfVFh
         skfwKR/qtQh5lpJIrsaOPSNg5km+Pr4V0MS1wNIxC8PFtlrsnG+hH+rJtpe+8mUzC0aV
         P3ZW7ymqMQS3eY2Bji3GPyUkbrq+qRZD9wfQ2q2I8KpdxLHnj3ZgE8yuWiiWTEtiu6hW
         7Hy77iHuDXXvFL7bDYNq54gz/z9Zn834tVz35ZVRLmiD+1M5UP9ApAkx/BIO2TD4U681
         PUYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BRoTzAi8DELPagI4OEPtjrVPhqomnGXRwr1h/q3kitA=;
        b=uAxyLWcoJZ2N0Cr62rjG1XPlqsUSPKU9wajQLsv4vAZy3t07c/sBdyxln8lIzcmU0O
         Gs6lfFO7W77iwyFXwbif2HH2qfMQUON7DOOA8q3h+UndEmIJmC9qCeaK/4F788NvW2ms
         /mrvec0Dfeq7aVnAjQlDKW70UxmY6JLK36TaO0sM79F/7wYsuuTRMmUxYjy/VwOOGZGH
         oltMrvOv+mTlMxWkcAJqgjD1XwP0dHRdXUK892EqjJ7hd57CwuP7sXLXYllwMBGqA2YI
         4dsrYr+UQY6Nj1s3qgGGbVpsC5Ldris4ghzPQ70waSMSVqtimf7zLaby5+neuPfZDgE2
         yRzA==
X-Gm-Message-State: AOAM532ZqBJZd8T0kdm0xEDMPjkJAgAYYPY+x64DpxNpmycJW4ArdVls
        kA2DB9TNJdDUQQ9J9XjY+Q6YqKDPaS6FyMYLJ2UjLA==
X-Google-Smtp-Source: ABdhPJwpRV7jv4f9lVAw34wNCbHo6pfdDak70///IYeMGozpZOuklLvKuH7AIKXRPfMLofDSc+zDzBKz4ci5Ycc+c7A=
X-Received: by 2002:adf:f40b:: with SMTP id g11mr10589064wro.296.1637076134003;
 Tue, 16 Nov 2021 07:22:14 -0800 (PST)
MIME-Version: 1.0
References: <20211115190249.3936899-1-eric.dumazet@gmail.com>
 <20211115190249.3936899-18-eric.dumazet@gmail.com> <20211116062732.60260cd2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89iJL=pGQDgqqKDrL5scxs_S5yMP013ch3-5zwSkMqfMn3A@mail.gmail.com>
In-Reply-To: <CANn89iJL=pGQDgqqKDrL5scxs_S5yMP013ch3-5zwSkMqfMn3A@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 16 Nov 2021 07:22:02 -0800
Message-ID: <CANn89iJ5kWdq+agqif+72mrvkBSyHovphrHOUxb2rj-vg5EL8w@mail.gmail.com>
Subject: Re: [PATCH net-next 17/20] tcp: defer skb freeing after socket lock
 is released
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Arjun Roy <arjunroy@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 16, 2021 at 7:05 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Nov 16, 2021 at 6:27 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Mon, 15 Nov 2021 11:02:46 -0800 Eric Dumazet wrote:
> > > One cpu can now be fully utilized for the kernel->user copy,
> > > and another cpu is handling BH processing and skb/page
> > > allocs/frees (assuming RFS is not forcing use of a single CPU)
> >
> > Are you saying the kernel->user copy is not under the socket lock
> > today? I'm working on getting the crypto & copy from under the socket
> > lock for ktls, and it looked like tcp does the copy under the lock.
>
> Copy is done currently with socket lock owned.
>
> But each skb is freed one at a time, after its payload has been consumed.
>
> Note that I am also working on performing the copy while still allowing BH
> to process incoming packets.
>
> This is a bit more complex, but I think it is doable.

Here is the perf top profile on cpu used by user thread doing the
recvmsg(), at 96 Gbit/s

We no longer see skb freeing related costs, but we still see costs of
having to process the backlog.

   81.06%  [kernel]       [k] copy_user_enhanced_fast_string
     2.50%  [kernel]       [k] __skb_datagram_iter
     2.25%  [kernel]       [k] _copy_to_iter
     1.45%  [kernel]       [k] tcp_recvmsg_locked
     1.39%  [kernel]       [k] tcp_rcv_established
     0.93%  [kernel]       [k] skb_try_coalesce
     0.79%  [kernel]       [k] sock_rfree
     0.72%  [kernel]       [k] tcp_v6_do_rcv
     0.57%  [kernel]       [k] skb_release_data
     0.50%  [kernel]       [k] tcp_queue_rcv
     0.43%  [kernel]       [k] __direct_call_clocksource_read1
     0.43%  [kernel]       [k] __release_sock
     0.39%  [kernel]       [k] _raw_spin_lock
     0.25%  [kernel]       [k] __direct_call_hrtimer_clock_base_get_time1
     0.20%  [kernel]       [k] __tcp_transmit_skb
     0.19%  [kernel]       [k] __dev_queue_xmit
     0.18%  [kernel]       [k] __tcp_select_window
     0.18%  [kernel]       [k] _raw_spin_lock_bh
