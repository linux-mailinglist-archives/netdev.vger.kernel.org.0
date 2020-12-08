Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 622062D31C3
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 19:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730521AbgLHSKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 13:10:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728893AbgLHSKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 13:10:37 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378AFC061793
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 10:09:51 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id g15so16925154ybq.6
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 10:09:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2BQx0M9EcN4biPtizI0suJoYIlnqoDVRXenaNtVc/TM=;
        b=W/VZABxz/FA25orombIF9Q3LoMgAcXEyES7jxaQAXQRIlxEu7QZ4yP1a+NqeMUHevL
         dd7Bcmky3e+b8mrKpYd3bAoA0OLojSmTgAuoEgOiRt4dcv40lqtGbWE5miISIcPt039F
         nmHToAFGt8UQdgPJ/i5Ym9GUG9QOyEb8KCkNVl+yULpjQmsB52Gm+EAxn8nCeNZHRbBM
         tvWZNySidwMWi8noD2A+ybfC5zIx1s/NOiMyiDWcCuWS+FsMBz8B8d8Ywrf/q1zeqHAW
         yegxg3XSEgzVAz2dQLLl9vWT5wCN2OAZVg/xvgX+jVqNfrMBtD4OLLUukWZpDGxN9Re+
         9rMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2BQx0M9EcN4biPtizI0suJoYIlnqoDVRXenaNtVc/TM=;
        b=XG/KJnqKQYoUNtZAWH4sI5sFJjNWYyHuLv3GAFcfct7zx7oShB2PV9zwUaBmTBw1Vt
         3o69yn9V8ZXGazfcMrLoCc1mvRx7Mnr1bESOccZmHcAR8gpjW/c+fGYSwH7fFyMDaNDI
         rV63BplUhIxJJd+2Q/KUode9q7nlgbN+MF3eUUDK8C6/hQigYOfwS2v5uxWmDqoUaCen
         QhNGSD+6x2JdbPCwjIDn4/Skg1T+EJr2FrluSpDtLfYGUOkE1UQFZWPtPrszcNS4hm0c
         H5MHvUg4f50ovcnJQqhiWzS/JD4gDyy0vMVVUZJmGBX3TrjlU9/h5EEa5VahAoHB+NgV
         qlOg==
X-Gm-Message-State: AOAM531dTKlLefdqCbL9H7ioHwHf5QnGRk5ONJqareuA0wc3RX8Unb+O
        mfK7x+071bgGihnpEwt5V0156nMJYj6ILEIZ+sPsdA==
X-Google-Smtp-Source: ABdhPJyF124zLvMMlQAHqWhi3Qp41Zw9cHido1XoDyVhY/wFY5+daSGmNZ2Or+EP7kwx3BVfQNYRw3h8/a806fS9A70=
X-Received: by 2002:a25:fc20:: with SMTP id v32mr29654988ybd.351.1607450990288;
 Tue, 08 Dec 2020 10:09:50 -0800 (PST)
MIME-Version: 1.0
References: <ca64de092db5a2ac80d22eaa9d662520@codeaurora.org> <56e72b72-685f-925d-db2d-d245c1557987@gmail.com>
In-Reply-To: <56e72b72-685f-925d-db2d-d245c1557987@gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Tue, 8 Dec 2020 10:09:39 -0800
Message-ID: <CAEA6p_D+diS7jnpoGk6cncWL8qiAGod2EAp=Vcnc-zWNPg04Jg@mail.gmail.com>
Subject: Re: Refcount mismatch when unregistering netdevice from kernel
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     stranche@codeaurora.org, David Ahern <dsahern@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sean,

Thanks for reporting the issue. Like Eric said, if you could provide
the kernel version you are using, that would be great. And if you have
a reproducer, that would be even better.
I have a few comments inline below.

On Tue, Dec 8, 2020 at 7:08 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 12/8/20 4:55 AM, stranche@codeaurora.org wrote:
> > Hi everyone,
> >
> > We've recently been investigating a refcount problem when unregistering=
 a netdevice from the kernel. It seems that the IPv6 module is still holdin=
g various references to the inet6_dev associated with the main netdevice st=
ruct that are not being released, preventing the unregistration from comple=
ting.
> >
> > After tracing the various locations that take/release refcounts to thes=
e two structs, we see that there are mismatches in the refcount for the ine=
t6_dev in the DST path when there are routes flushed with the rt6_uncached_=
list_flush_dev() function during rt6_disable_ip() when the device is unregi=
stering. It seems that usually these references are freed via ip6_dst_ifdow=
n() in the dst_ops->ifdown callback from dst_dev_put(), but this callback i=
s not executed in the rt6_uncached_list_flush_dev() function. Instead, a re=
ference to the inet6_dev is simply dropped to account for the inet6_dev_get=
() in ip6_rt_copy_init().
> >

rt6_uncached_list_flush_dev() actually tries to replace the inet6_dev
with loopback_dev, and release the reference to the previous inet6_dev
by calling in6_dev_put(), which is actually doing the same thing as
ip6_dst_ifdown(). I don't understand why you say " a reference to the
inet6_dev is simply dropped".

> > Unfortunately, this does not seem to be sufficient, as these uncached r=
outes have an additional refcount on the inet6_device attached to them from=
 the DST allocation. In the normal case, this reference from the DST alloca=
tion will happen in the dst_ops->destroy() callback in the dst_destroy() fu=
nction when the DST is being freed. However, since rt6_uncached_list_flush_=
dev() changes the inet6_device stored in the DST to the loopback device, th=
e dst_ops->destroy() callback doesn't decrement the refcount on the correct=
 inet6_dev struct.
> >

The additional refcount to the DST is also released by doing the following:
                        if (rt_dev =3D=3D dev) {
                                rt->dst.dev =3D blackhole_netdev;
                                dev_hold(rt->dst.dev);
                                dev_put(rt_dev);
                        }
Am I missing something?


> > We're wondering if it would be appropriate to put() the refcount additi=
onally for the uncached routes when flushing out the list for the unregiste=
ring device. Perhaps something like the following?
> >
>
> dev refcount imbalances are quite common, particularly on old kernel vers=
ions, lacking few fixes.
>
> First thing is to let us know on which kernel version you see this, and h=
ow you reproduce it.
>
