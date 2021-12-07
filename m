Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09F1146C2EE
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 19:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232424AbhLGSiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 13:38:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbhLGSiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 13:38:16 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6545C061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 10:34:45 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id g17so43209379ybe.13
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 10:34:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=60eY/8ESSsKaIUZDXPHqEUj519quADjXdyt3zPqPsck=;
        b=gdAZhua4mPJGzcCrxF1IBctYBxS4ZM5cReOsSiORYbIkrLcwuPgx14+z4+qUnQfrae
         h5/p+QbMxIsXLL8fL+zt3CBsAJe2LNKPisDBTOxxgdbml9VEZMCOH7onqnQbZPr8BdCj
         19FyjNVjh+uNw43Abj51Rml8BUEmfuw01iSJJ9yQzmLmDNqWiDj4VIuegxC8sDmvHqSi
         yyn1wU9fcxVNyydsMpOTjX1zjaebF8hOcetWlnSdLcZAlc3VvheBJzCCF9f40mM1rrPW
         OTo4D5IhOKzpjELxG0kH93sNtnYhT+X14+dZP6FiL4VvoTNN4yR4et7Abnzk6WUMaPLy
         u25g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=60eY/8ESSsKaIUZDXPHqEUj519quADjXdyt3zPqPsck=;
        b=IMZZVtjvNvliyztz6LIaG8SKO70h4QGlnsNGple72haaJ1uer5l9euwWLMHpglakpL
         MvW0b+I38vaJabsWvgDLEN55T6uolP2Q03mppRQ/HhmXuUDgU4SnsWAHzczvQhm8pz0a
         UpmuWFV391n6YOUsmPGTJW0AwuHwUqs2Btaj0crzKhl9Ve2Q0LFHtjsFL2Q8Cyyis7b/
         +9bDG1ixDF8+50Vuty85N6ateUqvNZx9/dGsBIILfF8WtgN6mtOvGwV5vTZvQUpkipkU
         Dr6Z7AT2vzzJgK0tvo2BPcxuHSGQXoMc13Kfr9CecGvlhK5eaqvOO0CGJt7jAYoBaF49
         YrAw==
X-Gm-Message-State: AOAM531mna6i1ITrZpVo48UWeuEdoivsmPFoXLwaAuwdPNT3w9V7njVH
        XjXGSRzUH7rV7437LpoDw16BgVI2XtvvxQCM7EECQw==
X-Google-Smtp-Source: ABdhPJxuOkVIpzXrVTaiCHr7RERuENMZ4ZjOl8SZ8fthw9aT2Ym9ArQ1rijPiH2ieWMRg7LcQc0pFePeIfgAwwfbATM=
X-Received: by 2002:a05:6902:1025:: with SMTP id x5mr53470943ybt.156.1638902084480;
 Tue, 07 Dec 2021 10:34:44 -0800 (PST)
MIME-Version: 1.0
References: <cover.1638849511.git.lucien.xin@gmail.com> <CANn89iJyiDbGdvm-oNKBBk5r3-0+3h+3ui1pL3rOTrz2BOztmA@mail.gmail.com>
 <CADvbK_c-SpsVDgOgUO2YqcT3qS4c9BL=qHYnrEgp2S3tqvR-Zw@mail.gmail.com>
In-Reply-To: <CADvbK_c-SpsVDgOgUO2YqcT3qS4c9BL=qHYnrEgp2S3tqvR-Zw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 7 Dec 2021 10:34:33 -0800
Message-ID: <CANn89iJE94zTJNKmNivHcy9zK_hyXNnXf2OYH1+HxVNo1m0T=Q@mail.gmail.com>
Subject: Re: [PATCH net-next 0/5] net: add refcnt tracking for some common objects
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 7, 2021 at 10:17 AM Xin Long <lucien.xin@gmail.com> wrote:
>
> On Mon, Dec 6, 2021 at 11:41 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Mon, Dec 6, 2021 at 8:02 PM Xin Long <lucien.xin@gmail.com> wrote:
> > >
> > > This patchset provides a simple lib(obj_cnt) to count the operatings on any
> > > objects, and saves them into a gobal hashtable. Each node in this hashtable
> > > can be identified with a calltrace and an object pointer. A calltrace could
> > > be a function called from somewhere, like dev_hold() called by:
> > >
> > >     inetdev_init+0xff/0x1c0
> > >     inetdev_event+0x4b7/0x600
> > >     raw_notifier_call_chain+0x41/0x50
> > >     register_netdevice+0x481/0x580
> > >
> > > and an object pointer would be the dev that this function is accessing:
> > >
> > >     dev_hold(dev).
> > >
> > > When this call comes to this object, a node including calltrace + object +
> > > counter will be created if it doesn't exist, and the counter in this node
> > > will increment if it already exists. Pretty simple.
> > >
> > > So naturally this lib can be used to track the refcnt of any objects, all
> > > it has to do is put obj_cnt_track() to the place where this object is
> > > held or put. It will count how many times this call has operated this
> > > object after checking if this object and this type(hold/put) accessing
> > > are being tracked.
> > >
> > > After the 1st lib patch, the other patches add the refcnt tracking for
> > > netdev, dst, in6_dev and xfrm_state, and each has example how to use
> > > in the changelog. The common use is:
> > >
> > >     # sysctl -w obj_cnt.control="clear" # clear the old result
> > >
> > >     # sysctl -w obj_cnt.type=0x1     # track type 0x1 operating
> > >     # sysctl -w obj_cnt.name=test    # match name == test or
> > >     # sysctl -w obj_cnt.index=1      # match index == 1
> > >     # sysctl -w obj_cnt.nr_entries=4 # save 4 frames' calltrace
> > >
> > >     ... (reproduce the issue)
> > >
> > >     # sysctl -w obj_cnt.control="scan"  # print the new result
> > >
> > > Note that after seeing Eric's another patchset for refcnt tracking I
> > > decided to post this patchset. As in this implemenation, it has some
> > > benefits which I think worth sharing:
> > >
> >
> > How can your code coexist with ref_tracker ?
> Hi, Eric, Thanks for your checking
>
> It won't affect ref_tracker, one can even use both at the same time.
>
> >
> > >   - it runs fast:
> > >     1. it doesn't create nodes for the repeatitive calls to the same
> > >        objects, and it saves memory and time.
> > >     2. the depth of the calltrace to record is configurable, at most
> > >        time small calltrace also saves memory and time, but will not
> > >        affect the analysis.
> > >     3. kmem_cache used also contributes to the performance.
> >
> > Points 2/3 can be implemented right away in the ref_tracker infra,
> > please send patches.
> >
> > Quite frankly using a global hash table seems wrong, stack_depot
> > already has this logic, why reimplement it ?
> > stack_depot is damn fast (no spinlock in fast path)
> What this patchset is trying to add is a calltrace+object counter.
> I was looking at stack_depot after seeing you patch, stack_depot saves
> calltrace only, no object(I guess this is okay, I can save object to
> to entries[0] if I want to use it), but also it's not a counter.
>
> I'm not sure if it's allowed to do some change and add a counter to
> the node of stack_depot, like when it's found in saving, the counter
> increments. That will be perfect for this patchset.
>
> This global spinlock will eventually be used only to protect the new
> node's insertion. For the fast path (lookup), rcu_read_lock() will take
> care of it. I haven't got time to add it. but this won't be a problem.
>
> >
> > Seeing that your patches add chunks in lib/obj_cnt.c, I do not see how
> > you can claim this is generic code.
> I planned it as a obj operating counter, it can be used for counting any
> operatings, not just for the refcnt tracker which is only _put and _hold
> operatings.
>
> >
> > I don't know, it seems very strange to send this patch series now I
> > have done about 60 patches on these issues.
> This patch is not to do exactly the same things as your patchset, I think your
> patch saves more information into the objects in the kernel memory, it will
> be useful for vmcore analysis.
>
> This patchset is working in a different way, it's going to target a
> specific object with index or name or pointer matched and some types
> of function calls to it, we have to plan in advance after we know
> which object (like it's name, index or string to match) is leaked.
>
> >
> > And by doing this work, I found already two bugs in our stack.
> Great effects!
> I can see that you must go over all networking stack for dev operations.
>
> >
> > You can be sure syzbot will send us many reports, most syzbot repros
> > use a very limited number of objects.
> >
> > About performance : You use a single spinlock to protect your hash table.
> > In my implementation, there is a spinlock per 'directory (eg one
> > spinlock per struct net_device, one spinlock per struct net), it is
> > more scalable.
> I used per net spinlock at first, but I want to make the code more generic,
> and not only for the network, then I decided to make it not related to net.
>
> After using rcu_lock in the fast path, I think this single spinlock won't
> affect much, besides, this single lock can be replaced by a per hlist lock
> on each hlist_head, it will also save some.
>
> >
> > My tests have not shown a significant cost of the ref_tracker
> > (the major cost comes from stack_trace_save() which you also use)
> I added "run fast" in cover, mostly because it won't create many nodes
> if dev_hold/put are called many times, it only increments the count if it's
> the same call to the same object already existing in the hashtable.
>
> dev could be fine, thinking about tracking dst, when sending packets, dst
> can be hold/put too many times, creating nodes for each call is not a good
> idea, especially for some leak only occurs once for few months which I've
> seen quite a few times in our customer envs.

That is why I chose to not automatically track all dev_hold()/dev_put()

For the ones that are contained in a short function, with clear
contract, there is
no need for adding tracking.

But before taking this decision, I am looking at each case, very carefully.

>
>
> Other things are:
> most net_dev leaks I've met are actually dst leak, some are in6_dev leak,
> only tracking net_dev is not enough to address it, do you have plans to
> add dst track for dst too? That may be a lot of changes too?

Yes, the plan is to add trackers when we think there is a high
probability of having leaks.

I think you missed the one major point of the exercise :

By carefully doing the pairing, we can spot bugs already, even without
turning the CONFIG_ options.

Once this (patient) work done, it is done, the infra will catch future
bugs right away.

>
> I think adding new members into core structures only for debugging
> may not be a good choice, as it will bring troubles to downstream for
> the backport because of kABI.

The main point of this stuff, is to allow syzbot to simply turn on a
few CONFIG options and let
it discover past/new issues. No special sysctls magics.

I see you added introspection, to list all active references, I think
this could be added on a per object
basis, to help developers have ways to better understand the kernel behavior.

Again, I think there is no reason your work can not complement mine.
They serve different purposes.
