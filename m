Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A97603804AA
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 09:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233287AbhENHwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 03:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233244AbhENHwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 03:52:02 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0388C061574
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 00:50:51 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id g13so21671219qts.4
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 00:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kOfBJat+mqyQtxfMSdBFqXn3AB6r0NiX2/D+7z9FVyo=;
        b=oBvVTruIns4DBa2mnrwIcWIU4SJx73VtUiBhpiZiiQ4AgdcUXLULLIJjdLp156rle+
         hbbOl8MNj27y0QoSF1Sxomo69kVzLSL/Sn8XQDn9ubtKa/5+AML8FGLfW/8V90tU7YZh
         HmvAJ+pCRWihBeTP8mSMCXhjLvgR/v/c9nMjDfspMVYG6TkRoM8EBz0hFJ14/zsHyqRv
         Huyyff6Uq5YpEHTn+MOVWTugf14j65wzj96QL+NMlGTb3vufHVjTADePtQW55oPqg7H8
         /YaTx+TDc++XoUxZOxnXzxjw2VNHP5VV0DZnLKPXpsQHPPdEsbTWrO8Fe9dl71d8KmL/
         yOxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kOfBJat+mqyQtxfMSdBFqXn3AB6r0NiX2/D+7z9FVyo=;
        b=ab1ef1gLmx2acCuPIB3jKac1NiICHukWG7uZf5jQGHyAD7aG0CtOMT6WH7Oycp2ieq
         hY5UdRvVQitC8HeeG1CZSNeu4KtMQ7v7+hgKqTq+hOCfTqboLockuxSsS1Q4xoT0z+Yj
         LgPZROKzKmLbwJvX34Kq4Fns0zLJxkJ6qDif5qAAtk4q7F85FPBLQxsVCHXMsK0FJ1tg
         e0pjBnmRP8TQO+qghdtbRBjirL3PgD/UPFDqXTvrZR1Y9lr1UynH9ZGA7RIWmFTQAic8
         fnVbEfClhrH980dua4dzWH6q2xc6VTUNqUspf9AeR5bwihQDLrB4dGkoH5Jx8HqdSczg
         S9BQ==
X-Gm-Message-State: AOAM531c4azBKMUW0t68ckQXLQ3aXEwqWkArRFLNE2lXZAYufMoJHyo4
        QLo0XU8OYsOIa11kN38gpsB05ptB5NfMAb99WMTzbA==
X-Google-Smtp-Source: ABdhPJwO2h2BkNL/icMM2Oo2w/4OPTUpvyJcOesVWoDMUs+CyOXTk6AsniBs441KSzBS+qWlvmbJDR9FhZma/QKevLg=
X-Received: by 2002:ac8:7c8a:: with SMTP id y10mr3974414qtv.337.1620978650818;
 Fri, 14 May 2021 00:50:50 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000aaa4a905ac646223@google.com> <000000000000fd05a005c2389844@google.com>
In-Reply-To: <000000000000fd05a005c2389844@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 14 May 2021 09:50:39 +0200
Message-ID: <CACT4Y+aAhVHiDyuiwxAh4KfHp3UnquQPGBJ52fa46Cm7LT_hdw@mail.gmail.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in __queue_work (3)
To:     syzbot <syzbot+77e5e02c6c81136cdaff@syzkaller.appspotmail.com>
Cc:     Markus Elfring <Markus.Elfring@web.de>,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hillf Danton <hdanton@sina.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, linma@zju.edu.cn,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, luiz.dentz@gmail.com,
        Marcel Holtmann <marcel@holtmann.org>, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 13, 2021 at 6:27 PM syzbot
<syzbot+77e5e02c6c81136cdaff@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit e2cb6b891ad2b8caa9131e3be70f45243df82a80
> Author: Lin Ma <linma@zju.edu.cn>
> Date:   Mon Apr 12 11:17:57 2021 +0000
>
>     bluetooth: eliminate the potential race condition when removing the HCI controller
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=127b3593d00000
> start commit:   c0842fbc random32: move the pseudo-random 32-bit definitio..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=cf567e8c7428377e
> dashboard link: https://syzkaller.appspot.com/bug?extid=77e5e02c6c81136cdaff
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=140e36a4900000
>
> If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: bluetooth: eliminate the potential race condition when removing the HCI controller
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection


Looks reasonable based on the commit and bisection log.
Unfortunately I cannot easily send this as my email client will wrap
the commit title line (longer than 80 chars)...
