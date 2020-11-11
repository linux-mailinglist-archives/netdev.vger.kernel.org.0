Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDC8C2AF2FF
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 15:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbgKKODw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 09:03:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbgKKODB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 09:03:01 -0500
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 674DDC0613D1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 06:03:01 -0800 (PST)
Received: by mail-qt1-x843.google.com with SMTP id b16so1069197qtb.6
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 06:03:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=fop/5FcBYqp1EBb0J0yxC9ZD7voBHevk86AMf6jgdxM=;
        b=sn1NyOykSACfdi1Rv5XhNBLkcQi2W0ropTn56ckWh2Z2KVCVK3yXxwJbCZJm2c/vhI
         zbe2xJsdNM+uIpP3LQ0V5l2RGIU2aMd05Q/q2KfqQ7i2EY+Kg4k6Lwkb9uWtMRN41lUN
         PCSAkL+gWA8a50M6AyKD0N/amtzM047JQHF00Zyb5lfAtwjDAX1zFJcYyBRtVsd5JvY7
         kNaHujbmHIa0FIYGLRGYD7Hmw3o03XRoeTu9c6N7dGiMigWtNSuzRRDgQnHfZ7iOA8mR
         RvH4LMS8iyo2d12iTMdnaU5b8bCUkIQpXjHdmxu11pwc8i31tK2fL1MJ4913Lqz34TQb
         G3mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=fop/5FcBYqp1EBb0J0yxC9ZD7voBHevk86AMf6jgdxM=;
        b=C1ecWu09op+iz126IonIdXizyzzPT9UykoCRFOuQ6uIZm68nSNlfpHfULqvHXK9fEQ
         Nf1bN3eeGHkEJMk8F1O1SMm/BkFTp9fK4huAjTUgn8NDPKDtqyp5sbxm+MmiuxI04qaZ
         0WjiHA90xqtyL4J65AYryTqUeq1wPMjLt3KQVt2Rx3POD0LiP4GIgCXcB38jr7hG/rmi
         yAzIZgmdC6gye6Kfp+p/eU/DMVUoAnJ5L9TFEMugy4iSa5rU2IXo3npEeok8OvWHXE9c
         26s01NMbwkCIizu6dVUpyPHExptAsHYZj/LBosYnvslU58wdw+ZefJne5GzzFgX/AjWh
         wDRw==
X-Gm-Message-State: AOAM531x0Ad9E8EGyng+Ry309OBJ7hWqeJgHlpIVkquRm7kbXCZkpaSN
        NzC6/Ocd2/887IemxFpzorNqOq8GQEz8uHHUCT4vIg==
X-Google-Smtp-Source: ABdhPJxLT6erSrr/ltStEmpl/WsryKcih7RpQd6VHdCsY8O7dVsTLr6/S5PXbuRITY7bFVeU3jawQrrHHe0eqpMqHUI=
X-Received: by 2002:aed:2b47:: with SMTP id p65mr22176340qtd.337.1605103380353;
 Wed, 11 Nov 2020 06:03:00 -0800 (PST)
MIME-Version: 1.0
References: <0000000000000a9cca057cd141bd@google.com> <000000000000f472ee05a6764e46@google.com>
In-Reply-To: <000000000000f472ee05a6764e46@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 11 Nov 2020 15:02:49 +0100
Message-ID: <CACT4Y+Zr6aEahp+jQhCoZCLQ4CY10oHUKB8yGfZxE+6WujeyNg@mail.gmail.com>
Subject: Re: inconsistent lock state in icmp_send
To:     syzbot <syzbot+251ec6887ada6eac4921@syzkaller.appspotmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        tipc-discussion@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 25, 2020 at 12:19 PM syzbot
<syzbot+251ec6887ada6eac4921@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this bug was fixed by commit:
>
> commit 1378817486d6860f6a927f573491afe65287abf1
> Author: Eric Dumazet <edumazet@google.com>
> Date:   Thu May 21 18:29:58 2020 +0000
>
>     tipc: block BH before using dst_cache
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10cbef06100000
> start commit:   f5d58277 Merge branch 'for-linus' of git://git.kernel.org/..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c8970c89a0efbb23
> dashboard link: https://syzkaller.appspot.com/bug?extid=251ec6887ada6eac4921
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10ab6ba3400000
>
> If the result looks correct, please mark the bug fixed by replying with:
>
> #syz fix: tipc: block BH before using dst_cache
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

#syz fix: tipc: block BH before using dst_cache
