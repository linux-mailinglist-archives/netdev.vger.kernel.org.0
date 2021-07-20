Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD24F3CF0DC
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 02:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353017AbhGSX6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 19:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377633AbhGSXfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 19:35:25 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87073C0A888D;
        Mon, 19 Jul 2021 17:03:26 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d9so6911769pfv.4;
        Mon, 19 Jul 2021 17:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z9vRT77jnRA5OE8rXggCLsHCYvsQrPIeeIhxOF+kEYI=;
        b=AlzID3X9UY2KjBVSZvvWnO9F3XqW14T9NgvDdgb8r9PdfG8qfQyeYqNw1hY1OHi2xK
         vf80kL8sugN7ExTkXXpx4yKKI0PP243tBbEgcSnHfgjcP/jESQO/vw5Aesk5+YOZ6Tcf
         Ls8XOQPaVyGtCn0KGR6LX71n3OD6yB/zUeGnBoP16HDem/BHHVqGa4cQ1ltCBGxCsptu
         s1A5FTU9wfuCmDaWbWwIrKfAZ8W5onjsApHZ/Zbu051ZqqLT51CaB46xRZGjyhPFYa62
         sfJP9ioCyqJS8OKWudazJMkN+1dBirpkFkKzSVm/Vj86BU0eF2UkRudt+maPlLeZJ16v
         7PZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z9vRT77jnRA5OE8rXggCLsHCYvsQrPIeeIhxOF+kEYI=;
        b=NDCzy/MqvIdcm1Ze8ikwpNR+EMl4qr5SaQ/NHq3DLSpAjbjOfek/VbFJSjHf507wVR
         /HsfqIeulCsj6yBnLSzB8cHmfsyUfh9aY2cDikJf8atvrxbzqRNxC+nz8VOT7WftODun
         y8RuUFC8v4CJk/ztoSHpTQuBchUQCgDVxQrXKvyaYwlaIWLCn95Za+QBVEJ+hA1563bl
         s3Hd7/FmP94e9QGsJ48t2wzTZu49EKYCH9FVzB5NRDwutqW0q2Uhs7QVBXRKEdtmKSV0
         52MGTWxddcUVwpnsfScRsAAmX/wT++Cvh3ftkJZVpZaJZmdJi26VcHMnJFOY53DUfeK9
         ruPQ==
X-Gm-Message-State: AOAM530Ci6VSOZmt/MVc+e4KcgAZ7jN/unjcA4kf5TAnGRgZMcO6Vzlq
        Urr8TWZSfUpGIO3E5T56Fevey/1gQymuqOeglYE=
X-Google-Smtp-Source: ABdhPJztEskvrX8x3Cyzu2r+a21mvdUdPyySzPZMU/SjXgEqqisXodDoIqpABeRpUSfWKE31mAOzC2hqPmo4LKKmSds=
X-Received: by 2002:a63:4302:: with SMTP id q2mr27616186pga.428.1626739406113;
 Mon, 19 Jul 2021 17:03:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210704190252.11866-1-xiyou.wangcong@gmail.com>
 <20210704190252.11866-8-xiyou.wangcong@gmail.com> <a76f89b3-0911-e1f1-d1c1-707b9bc5478a@gmail.com>
In-Reply-To: <a76f89b3-0911-e1f1-d1c1-707b9bc5478a@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 19 Jul 2021 17:03:15 -0700
Message-ID: <CAM_iQpVEHF2h58YJA7xdWifSG0dtErhkoe4rjceTR7w_1SMspA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 07/11] af_unix: implement unix_dgram_bpf_recvmsg()
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 18, 2021 at 10:49 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 7/4/21 9:02 PM, Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> > +     mutex_lock(&u->iolock);
>
> u->iolock mutex is owned here.
>
> > +     if (!skb_queue_empty(&sk->sk_receive_queue) &&
> > +         sk_psock_queue_empty(psock)) {
> > +             ret = __unix_dgram_recvmsg(sk, msg, len, flags);
>
> But __unix_dgram_recvmsg() will also try to grab this mutex ?

Good catch. I should release the lock before calling it. I will send
a patch.

Thanks.
