Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 986AE33F168
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 14:46:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbhCQNqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 09:46:22 -0400
Received: from mail.zx2c4.com ([104.131.123.232]:33626 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230525AbhCQNpw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 09:45:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1615988747;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=icCM8Brb8CxRsIpo4ZpowHznQi3f2D+TRUb3EkCgpQs=;
        b=jlobSmtuwbDKLfSYm/RXYsxlWXKl+cOCHkuh00s49RDJn48Gw6bZW6dP05O+dpDreNKhYS
        4WuNAmSfzMsaDH2hsDUUqetD3/7PyCqP3hORjntTk2nbqCthetB7MfnlyV3bjesleAaZx1
        JUYT2h61MUiILiNoCNZucGVq2Ha0eEI=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 3c796d71 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 17 Mar 2021 13:45:47 +0000 (UTC)
Received: by mail-yb1-f176.google.com with SMTP id y133so2096814ybe.12;
        Wed, 17 Mar 2021 06:45:47 -0700 (PDT)
X-Gm-Message-State: AOAM533AAxtFE+D16tnUlIWoaJRgoGpnP7IwfPg7OCa/6NaIciVMk7j+
        0kJmugicIFoGUCSpcXAoluGdm7MuXNP23Nnrsgo=
X-Google-Smtp-Source: ABdhPJwnrrF8whYK/Ba4FN2UHQKlzh/IOodKUW1edfr5uX0ICQK7qEPoDsenYic4sbIHwuuSUdYtLx86aOl5E5wg2Es=
X-Received: by 2002:a25:4d02:: with SMTP id a2mr3833184ybb.49.1615988745966;
 Wed, 17 Mar 2021 06:45:45 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7110:5424:b029:39:213a:1a2e with HTTP; Wed, 17 Mar 2021
 06:45:45 -0700 (PDT)
In-Reply-To: <87eegddhsj.fsf@toke.dk>
References: <1615603667-22568-1-git-send-email-linyunsheng@huawei.com>
 <1615777818-13969-1-git-send-email-linyunsheng@huawei.com>
 <20210315115332.1647e92b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAM_iQpXvVZxBRHF6PBDOYSOSCj08nPyfcY0adKuuTg=cqffV+w@mail.gmail.com> <87eegddhsj.fsf@toke.dk>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 17 Mar 2021 07:45:45 -0600
X-Gmail-Original-Message-ID: <CAHmME9qDU7VRmBV+v0tzLiUpMJykjswSDwqc9P43ZwG1UD7mzw@mail.gmail.com>
Message-ID: <CAHmME9qDU7VRmBV+v0tzLiUpMJykjswSDwqc9P43ZwG1UD7mzw@mail.gmail.com>
Subject: Re: [RFC v2] net: sched: implement TCQ_F_CAN_BYPASS for lockless qdisc
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        David Miller <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        "Cong Wang ." <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linuxarm@openeuler.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/17/21, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:
> Cong Wang <xiyou.wangcong@gmail.com> writes:
>
>> On Mon, Mar 15, 2021 at 2:07 PM Jakub Kicinski <kuba@kernel.org> wrote:
>>>
>>> I thought pfifo was supposed to be "lockless" and this change
>>> re-introduces a lock between producer and consumer, no?
>>
>> It has never been truly lockless, it uses two spinlocks in the ring
>> buffer
>> implementation, and it introduced a q->seqlock recently, with this patch
>> now we have priv->lock, 4 locks in total. So our "lockless" qdisc ends
>> up having more locks than others. ;) I don't think we are going to a
>> right direction...
>
> Just a thought, have you guys considered adopting the lockless MSPC ring
> buffer recently introduced into Wireguard in commit:
>
> 8b5553ace83c ("wireguard: queueing: get rid of per-peer ring buffers")
>
> Jason indicated he was willing to work on generalising it into a
> reusable library if there was a use case for it. I haven't quite though
> through the details of whether this would be such a use case, but
> figured I'd at least mention it :)

That offer definitely still stands. Generalization sounds like a lot of fun=
.

Keep in mind though that it's an eventually consistent queue, not an
immediately consistent one, so that might not match all use cases. It
works with wg because we always trigger the reader thread anew when it
finishes, but that doesn't apply to everyone's queueing setup.
