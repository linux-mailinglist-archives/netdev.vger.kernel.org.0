Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C88CE3870FA
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 07:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241655AbhEREwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 00:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237133AbhEREwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 00:52:32 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A48C061573;
        Mon, 17 May 2021 21:51:14 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id i5so6189526pgm.0;
        Mon, 17 May 2021 21:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p7nAupXvuLIolK4e+vCaQH3SXBCSQE4RKFPGffMyTV0=;
        b=hLGfAjvrm9QVSDtG7FnDbEiH0lvR7QnHTaCMQu3eUGBPtzMr5ZgjMFUTRZcM1fQ+Bp
         01qIMEdWTSrEBsYL6wGbf0NE7odwDOybZWDARYOvA4GuA0pS9jJrrGcwlM+1yH8Ji7Fh
         nkQeXKQVmTAZ16G/sLcJHalTxyO0UW/nE7JMYoG0Ffus33HJ6d1Vo8ZrYQXcpwxU5pax
         jYNN8vcjYxMZ2jHPyaHSA+Yh2euu/qSn/8YbyVhPf36AGWPlB7dajHYp7jA5S7dO3jLs
         FyvZoM1uX9M/6aML8yE2RzcqlXw3fAP8/agWnUzp0RcuMutwRl+DEdyyUpQ6PgyyH/ZD
         hPOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p7nAupXvuLIolK4e+vCaQH3SXBCSQE4RKFPGffMyTV0=;
        b=kyQ4QUmf5Wjam7dYPLjCoU4cL1hIu3yB6yg7OHXV7BJQ864LGBsFpKUCXUpQ5CRFqo
         yKsmybWlux3RVEVC7rptw4QbjF7MeNnQ/66anmqdVCVq3KEVvqPIB9LNlQSJ/L+udZzv
         TYJNKA8nCxKXo29uqc7r0/A8lACLaTwnliverrxd91F1G6/31Q8qnvctEPIOI7wTIpKL
         TjVht4NMWq3uZR3c1bEMU3wgo+vdykpGQsA1V4i4ogTOo/Lf4lu37C5JYw1eA506JfX9
         Czv8whg9CgbCjhkQrm0sYoCDzYhBBhId0K0SNO6nNzWgVp5vJ2dr9P1t7VkiADtUOMLH
         JK0w==
X-Gm-Message-State: AOAM5309oksoFRfh8I//5dLZ2u9SWqjQ51/QeQjrcQbwVCsYq6YwFV+w
        c+EzYRB9Cb5h6VLj1btuxVopHcR/QuX7Th7zRCm1fPIz6JVKhA==
X-Google-Smtp-Source: ABdhPJxbAe7nT6BcW0UEHMAQ44/kFVaeZfxkfawqcJiBfgMpCbfaYalOYM4mnK0Ca7EsR1t0KHb9vVqBht97GLwROjs=
X-Received: by 2002:a62:ee07:0:b029:2d8:dea3:7892 with SMTP id
 e7-20020a62ee070000b02902d8dea37892mr3084704pfi.78.1621313473869; Mon, 17 May
 2021 21:51:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210508220835.53801-1-xiyou.wangcong@gmail.com> <20210508220835.53801-3-xiyou.wangcong@gmail.com>
In-Reply-To: <20210508220835.53801-3-xiyou.wangcong@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 17 May 2021 21:51:03 -0700
Message-ID: <CAM_iQpU5Nw6SkRBQ9XthaQNSwVbqpuUpWNgBRZwj=uzcx=LaBQ@mail.gmail.com>
Subject: Re: [Patch bpf-next v4 02/12] af_unix: implement ->read_sock() for sockmap
To:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Jiang Wang <jiang.wang@bytedance.com>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 8, 2021 at 3:09 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> +static int unix_read_sock(struct sock *sk, read_descriptor_t *desc,
> +                         sk_read_actor_t recv_actor)
> +{
> +       int copied = 0;
> +
> +       while (1) {
> +               struct unix_sock *u = unix_sk(sk);
> +               struct sk_buff *skb;
> +               int used, err;
> +
> +               mutex_lock(&u->iolock);
> +               skb = skb_recv_datagram(sk, 0, 1, &err);
> +               mutex_unlock(&u->iolock);
> +               if (!skb)
> +                       return err;
> +
> +               used = recv_actor(desc, skb, 0, skb->len);
> +               if (used <= 0) {
> +                       if (!copied)
> +                               copied = used;
> +                       break;
> +               } else if (used <= skb->len) {
> +                       copied += used;
> +               }
> +

Like udp_read_sock(), we should also free the skb here.
I will update this and send V5 soon.

Thanks.
