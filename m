Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E43C62DC0D2
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 14:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgLPNLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 08:11:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbgLPNLG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 08:11:06 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A921C061794
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 05:10:26 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id q25so22816555otn.10
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 05:10:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=zn5tMxLNWdyBP2g8xDOybQNMyG7NdDEi0yb4LPU1Tgk=;
        b=M4JNWFOS4PzQlHL1z3lLOi9Y3dAyNvCV92510hrcDPHEWUswlZzPnffcmgjA8OZdul
         jue1gTLzxMWHEI3GQkO6AejqR7CK7E8R6vlYATLo3cyZmlNRxRk+iTO2NPJmyLiuYzc+
         aQyOfcOadyoGP5xKMoUtbV4TJRmdYJ9iXdxQRh5bR2BZ6Tge5BL0OuAtt6ABV0VilLxZ
         idwbAY2PpQGMFvIGzND4o6zN6euOddNN16viUnATUkmW4mZLCLhpxCOBTpadLVAmPeWP
         0/ZYGA4MOxS76NL0Cqjz6RZPVMZdnPvcV+U/fXAKSgxVi1nulxnVzuMUTDSNxgDaiJpx
         Z9pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=zn5tMxLNWdyBP2g8xDOybQNMyG7NdDEi0yb4LPU1Tgk=;
        b=ZgeMrqijK3PQmUBTX7lJcl38QIcRRZl3OwTRWapGM2gTl5s5hrEQnMwoJNhXyJAE6W
         02LEOqwTphryrzx3Pl+cQ4ukjbvB+3Kf+W4M2mgaFvcPQVN5By2Mn3o0UT0F1bymKqYj
         4CsJh/ZvQSwuAXNFoW8BvTEALnflsGVMvy9qw25sla7N5rNoepxO1qGWWv484KDI7zIY
         GfL00YMsgECS8M99OzRitNMz9OQZi+l5yDnYI3Bi4HtINB19WACX9rTaZiacWNpt5OYn
         01iiMuoGMY865ef05MzszQWfyJjbyXuvCL7Ob5434QnPiYvKc2Jw1zPoyVU5W2rT9vve
         7Q0A==
X-Gm-Message-State: AOAM533xmBJ9WVFDmUfBEr1tS7a0IJjo32oVNYXAfeV98eBNBVXH+/zh
        1v+rGdpMBTczo536U2PfFN/M6MpRds3Eo9LYJdvkh1k19VQ=
X-Google-Smtp-Source: ABdhPJykhOYAwCLstD70DC4VGhKQqS67vhbxTig7c6MwYAca+1anjsdNYXRmTJf2uDmG1hPjcTohfUsvrmeIeFiMeSo=
X-Received: by 2002:a9d:630d:: with SMTP id q13mr25695768otk.141.1608124225148;
 Wed, 16 Dec 2020 05:10:25 -0800 (PST)
MIME-Version: 1.0
From:   David Rheinsberg <david.rheinsberg@gmail.com>
Date:   Wed, 16 Dec 2020 14:10:14 +0100
Message-ID: <CADyDSO6_ybM1-j=DqcHNt_SkQj5cPNukxT8LcbckW+OMpfWe+Q@mail.gmail.com>
Subject: [RACE] net/unix: SIOCGOUTQ returns off-by-one data
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

We currently use SIOCOUTQ on AF_UNIX+SOCK_STREAM sockets to figure out
whether data that we wrote to a socket is still pending or was
dequeued. Preferably, we would like to know whether a specific message
we queued was dequeued by the other side, but sadly SIOCOUTQ does not
report the actual payload-size, but `skb->truesize`, making it
impossible for us to predict how much data the other side has
dequeued. Hence, we simply use the value to wait for the queue to
empty.

Practically, this means under special circumstances we refrain from
writing data to a socket until SIOCOUTQ returns 0. If it does not
return 0, we wait to be woken-up by a following EPOLLOUT (which works
fine in edge-triggered mode).

This worked fine for us, until we spuriously got off-by-one errors,
where SIOCOUTQ started returning 1, but did not send a wakeup /
EPOLLOUT afterwards despite the counter at some point dropping to 0.
The culprit seems to be sock_wfree():

[slightly simplified]
void sock_wfree(struct sk_buff *skb)
{
    struct sock *sk = skb->sk;
    unsigned int len = skb->truesize;

    if (!sock_flag(sk, SOCK_USE_WRITE_QUEUE)) {
        [...]
        refcount_sub_and_test(len - 1, &sk->sk_wmem_alloc);
        sk->sk_write_space(sk);
        len = 1;
    }
    [...]
    if (refcount_sub_and_test(len, &sk->sk_wmem_alloc))
        __sk_free(sk);
}

The kernel seems to use the `sk_wmem_alloc` counter for
reference-counting. Therefore, if we check SIOCOUTQ exactly between
`sk->sk_write_space()` and the following `refcount` update, we will
see a counter of 1, but never get woken up afterwards. Some of our
users can hit this reliably on newer arm64 machines.

My question now is whether this is intended behavior? I couldn't come
up with a simple fix, as I assume this overload on sk_wmem_alloc was
done for performance reasons. We could acquire an sk_refcnt before
sk_write_space and drop it afterwards, but it would probably need
further adjustments in sk_free() and friends, and would negatively
affect performance.

As a workaround we assume a return value lower than 128 means
effectively 0, because even a single queued skb would cause the
counter to be way bigger than 128, due to the size of `struct
sk_buff`. This gives us room to deal with up to 128 temporary
references the kernel holds. However, this does feel slightly awkward,
so I wondered whether someone has a better idea to fix this? Or
whether SIOCOUTQ is just not meant to be used that way?

NOTE: Our SIOCOUTQ code is used to properly account for
inflight-file-descriptors. The kernel accounts them on the sender's
quota, so we use this to reliably track how long an inflight FD is
queued on a socket, and thus accounted on us. This way we prevent
malicious users from causing us to queue too many inflight
file-descriptors and thus exceeding our quota.

Thanks
David
