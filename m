Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 875A4158A7
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 06:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfEGEzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 00:55:11 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42373 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbfEGEzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 00:55:11 -0400
Received: by mail-pf1-f194.google.com with SMTP id 13so7664051pfw.9
        for <netdev@vger.kernel.org>; Mon, 06 May 2019 21:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MR7XbqBxgoiR5jur+6kzx8lYjwYsLH0pb56IJHyA2us=;
        b=cM22ZqOjKPKpscYe146iLTummDR1f+RTRa3YYv54VA76zCJ5YELT0pzil6gtkir2mk
         YYYD+Ab8xYsJlqpd1K7EEHks8L/LqCtOYMvzuR20aEfzPBICwNGobQAmeDA8WmvEPl2e
         pNEKuzU0YYQtZbT57xjCBmyKSlwz0sqmY+t3jfImvFjLGQkyz53iGlmzC+VYzZWdWd70
         kI1nZgRgWZP3oI7F/RqMIrUenZXnN/VvfvEzTZOLzuyi9nOE3QzecxqNCfBOy8ZMnjk6
         +5FoH64WZZ4jT3f2vwjdgUuveL17wqy9GCWvaOOeG8cAkxQqlOFEZSsXY9td1ZSVs4u+
         mkXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MR7XbqBxgoiR5jur+6kzx8lYjwYsLH0pb56IJHyA2us=;
        b=U07jX/cqOrsR8Xhzxg7aQRF75/L9wYKqAGLCCn4I+WlVndg9MxHqoz/tns3q6oM47p
         s8V0p04iP9DGsGdRKgnfGuUYQEIEYYKKV/2jbiF4CMN3NuzDAe9XvAaXqQ2pwhvmbrBd
         P2qA7V5VhsG2B0DxNFcZULbUCtLaTlgmnTh+zAksN4frWQvyIOqVWI7XPztyedjsnoGG
         5YJMGMgfh6TbyrB1HbmeYwSD06rZEttR0sm0uYD/Gug2DEUKMFG0rKEYHAeYtT2NBr0U
         lTgnugLEH0Braz23t1nw0RFSoOK1z737DAtu3KF3suSaRSdpdA6F7tQXyeYtF5n7urvp
         MhXA==
X-Gm-Message-State: APjAAAWZStNhj0rdvsRdBcFFtL344hcYcotXuz3uS7uzQ1rr6Z5ksbOt
        TjiK2+unGYgzQp+eLuuM1q6kPuNxE9tW0MUykJ1KPA==
X-Google-Smtp-Source: APXvYqyTLdTHJoEmZnyxvWU5STzNQPGU+UHy4NEM48qdPzaTPHiuAMMP1q+VmucPypES23vbZNzGnZiUrMOjjhzT3LI=
X-Received: by 2002:a62:e101:: with SMTP id q1mr38745835pfh.160.1557204910828;
 Mon, 06 May 2019 21:55:10 -0700 (PDT)
MIME-Version: 1.0
References: <1557201816-19945-1-git-send-email-jasowang@redhat.com>
In-Reply-To: <1557201816-19945-1-git-send-email-jasowang@redhat.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 6 May 2019 21:54:59 -0700
Message-ID: <CAM_iQpURdiJv9GqkEyk=MPokacvtJVfHUpBb3=6EWA0e1yiTZQ@mail.gmail.com>
Subject: Re: [PATCH net V2] tuntap: synchronize through tfiles array instead
 of tun->numqueues
To:     Jason Wang <jasowang@redhat.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        YueHaibing <yuehaibing@huawei.com>,
        "weiyongjun (A)" <weiyongjun1@huawei.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 6, 2019 at 9:03 PM Jason Wang <jasowang@redhat.com> wrote:
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index e9ca1c0..32a0b23 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -700,6 +700,8 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
>                                    tun->tfiles[tun->numqueues - 1]);
>                 ntfile = rtnl_dereference(tun->tfiles[index]);
>                 ntfile->queue_index = index;
> +               rcu_assign_pointer(tun->tfiles[tun->numqueues - 1],
> +                                  NULL);
>

How does this work? Existing readers could still read this
tun->tfiles[tun->numqueues - 1] before you NULL it. And,
_if_ the following sock_put() is the one frees it, you still miss
a RCU grace period.

                if (clean) {
                        RCU_INIT_POINTER(tfile->tun, NULL);
                        sock_put(&tfile->sk);


Thanks.
