Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67A663C621
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 10:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391444AbfFKImf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 04:42:35 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:39190 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391404AbfFKIme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 04:42:34 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190611084232euoutp011a5583ae40aab31f73425306610558a4~nGFWrN0_y0939209392euoutp01M
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 08:42:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190611084232euoutp011a5583ae40aab31f73425306610558a4~nGFWrN0_y0939209392euoutp01M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1560242552;
        bh=zrXpkmfwxTwSrQsAQj3bDtr4OFMDsuSR1EhAI4V5gOo=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=FNYsJ2sDxJtsjDnopRbT5M9D0La/HNwsJ0w+nVcs3mk/sUymlK1Oi2Wnuan7VAVMV
         +w5dLf1ehgJ9XsFPlrCQ7XjDp7CAk6qTnpOHJvcUH8QXDXusQEc3A8gzxkDDz7vduu
         DMc9NGuJdd+TFXN2Z6rv1x+evgAAyg2sbHZ0C3z4=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190611084231eucas1p19f40a5345f3bba9117d0081b65d4eec4~nGFV2XG6A2792027920eucas1p1C;
        Tue, 11 Jun 2019 08:42:31 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id F9.8A.04298.6796FFC5; Tue, 11
        Jun 2019 09:42:30 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20190611084230eucas1p2a2370397051346a87c8b1fc3a83cedea~nGFU-NtUH2722727227eucas1p2n;
        Tue, 11 Jun 2019 08:42:30 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190611084230eusmtrp22ed78b9db7cd5aa7f35dbea536c9815c~nGFUvjCjw2927729277eusmtrp2U;
        Tue, 11 Jun 2019 08:42:30 +0000 (GMT)
X-AuditID: cbfec7f2-3615e9c0000010ca-83-5cff6976a939
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id F2.CA.04146.5796FFC5; Tue, 11
        Jun 2019 09:42:29 +0100 (BST)
Received: from [106.109.129.180] (unknown [106.109.129.180]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20190611084229eusmtip13f54f1e3e1cb19745494f9dfd6d27055~nGFUDnkDK2720627206eusmtip1p;
        Tue, 11 Jun 2019 08:42:29 +0000 (GMT)
Subject: Re: [PATCH bpf v3] xdp: fix hang while unregistering device bound
 to xdp socket
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
From:   Ilya Maximets <i.maximets@samsung.com>
Message-ID: <e2313edb-6617-cd52-1a40-4712c9f20127@samsung.com>
Date:   Tue, 11 Jun 2019 11:42:28 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CAJ+HfNgdiutAwpnc3LDDEGXs2SFCu3UtMnao79sFNyZZpQ2ETw@mail.gmail.com>
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAKsWRmVeSWpSXmKPExsWy7djP87plmf9jDO6ctrI4P+0Um8Wftg2M
        Fp+PHGezmHO+hcXiSvtPdotjL1rYLHatm8lscXnXHDaLFYdOAMUWiFls79/H6MDtsWXlTSaP
        nbPusnss3vOSyWN690Nmj74tqxg9Pm+SC2CL4rJJSc3JLEst0rdL4Mr4tC2nYLdFxet3i5ga
        GLs1uhg5OSQETCR2vtrB0sXIxSEksIJR4v/Mh6wQzhdGiXsLpzJBOJ8ZJabN/swO09K3bD8b
        RGI5o0T7tOPsEM5HRokFs+4zglQJC0RJbD58nhnEFhHIlLjd8J0ZpIhZ4CyTxPuZHUwgCTYB
        HYlTq4+ANfAK2Els/nECaDkHB4uAqsTdSUEgYVGBCIkvOzdBlQhKnJz5hAXE5hQIlFj//gjY
        RcwC4hJNX1ayQtjyEs1bZzNDXHqJXeLlj0II20Xi08xVUB8IS7w6vgXKlpH4v3M+E4RdL3G/
        5SUjyJ0SAh2MEtMP/YNK2EtseX2OHeQ2ZgFNifW79EFMCQFHiU1v1CBMPokbbwUhLuCTmLRt
        OjNEmFeio00IYoaKxO+Dy6EOk5K4+e4z+wRGpVlI/pqF5JdZSH6ZhbB2ASPLKkbx1NLi3PTU
        YsO81HK94sTc4tK8dL3k/NxNjMB0dfrf8U87GL9eSjrEKMDBqMTDGxH9L0aINbGsuDL3EKME
        B7OSCG/Xd6AQb0piZVVqUX58UWlOavEhRmkOFiVx3mqGB9FCAumJJanZqakFqUUwWSYOTqkG
        xgPuRwoWndi38tiyjy9YDn3vubym3u4aD5dO5Pqty90SHi6T+Wb3YMrTorUzZ29fVLeDT7Tj
        X5rm7xhfz/zzXOob9198M8czwsn8XZ58b9+P3/88j8WfE3y0KOLk1YMd96YbbWdPvRnncqvS
        Jd48fumceWdT/f6dyUtaX/pYc6NqnOPzKdKXxPmUWIozEg21mIuKEwFbq/mFUwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t/xu7qlmf9jDHpn2licn3aKzeJP2wZG
        i89HjrNZzDnfwmJxpf0nu8WxFy1sFrvWzWS2uLxrDpvFikMngGILxCy29+9jdOD22LLyJpPH
        zll32T0W73nJ5DG9+yGzR9+WVYwenzfJBbBF6dkU5ZeWpCpk5BeX2CpFG1oY6RlaWugZmVjq
        GRqbx1oZmSrp29mkpOZklqUW6dsl6GV82pZTsNui4vW7RUwNjN0aXYycHBICJhJ9y/azdTFy
        cQgJLGWU2Lu0kxkiISXx49cFVghbWOLPtS6ooveMErN6P7J0MXJwCAtESVxv5gGpERHIlNi4
        8TdYL7PAWSaJoxONIeo7mSRm7J3OBJJgE9CROLX6CCOIzStgJ7H5xwlWkDksAqoSdycFgYRF
        BSIkZu9qYIEoEZQ4OfMJmM0pECix/v0Rdoj56hJ/5l2C2iUu0fRlJSuELS/RvHU28wRGoVlI
        2mchaZmFpGUWkpYFjCyrGEVSS4tz03OLDfWKE3OLS/PS9ZLzczcxAiN027Gfm3cwXtoYfIhR
        gINRiYc3IvpfjBBrYllxZe4hRgkOZiUR3q7vQCHelMTKqtSi/Pii0pzU4kOMpkC/TWSWEk3O
        ByaPvJJ4Q1NDcwtLQ3Njc2MzCyVx3g6BgzFCAumJJanZqakFqUUwfUwcnFINjCKvlOVca6aK
        bvjTWByYmBN3S/3T+7YJH0K23Fv12fSGxgO/q69/pjWErisoXKyhPOVfrNjGYoVcLp+9f37J
        zvwe8TJ3c6XS4sN3V96353w1I/x3uHM1gzPTsa+NTpP9j0y+ISQkLM+3voz52cdqzesXmKM2
        r39teC+tM8Df/tbvvBf/vblXhCuxFGckGmoxFxUnAgB8x+2T5gIAAA==
X-CMS-MailID: 20190611084230eucas1p2a2370397051346a87c8b1fc3a83cedea
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190610161551eucas1p1f370190ee6d0d5e921de1a21f3da72df
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190610161551eucas1p1f370190ee6d0d5e921de1a21f3da72df
References: <CGME20190610161551eucas1p1f370190ee6d0d5e921de1a21f3da72df@eucas1p1.samsung.com>
        <20190610161546.30569-1-i.maximets@samsung.com>
        <06C99519-64B9-4A91-96B9-0F99731E3857@gmail.com>
        <CAJ+HfNgdiutAwpnc3LDDEGXs2SFCu3UtMnao79sFNyZZpQ2ETw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.06.2019 11:09, Björn Töpel wrote:
> On Mon, 10 Jun 2019 at 22:49, Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>>
>> On 10 Jun 2019, at 9:15, Ilya Maximets wrote:
>>
>>> Device that bound to XDP socket will not have zero refcount until the
>>> userspace application will not close it. This leads to hang inside
>>> 'netdev_wait_allrefs()' if device unregistering requested:
>>>
>>>   # ip link del p1
>>>   < hang on recvmsg on netlink socket >
>>>
>>>   # ps -x | grep ip
>>>   5126  pts/0    D+   0:00 ip link del p1
>>>
>>>   # journalctl -b
>>>
>>>   Jun 05 07:19:16 kernel:
>>>   unregister_netdevice: waiting for p1 to become free. Usage count = 1
>>>
>>>   Jun 05 07:19:27 kernel:
>>>   unregister_netdevice: waiting for p1 to become free. Usage count = 1
>>>   ...
>>>
>>> Fix that by implementing NETDEV_UNREGISTER event notification handler
>>> to properly clean up all the resources and unref device.
>>>
>>> This should also allow socket killing via ss(8) utility.
>>>
>>> Fixes: 965a99098443 ("xsk: add support for bind for Rx")
>>> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
>>> ---
>>>
>>> Version 3:
>>>
>>>     * Declaration lines ordered from longest to shortest.
>>>     * Checking of event type moved to the top to avoid unnecessary
>>>       locking.
>>>
>>> Version 2:
>>>
>>>     * Completely re-implemented using netdev event handler.
>>>
>>>  net/xdp/xsk.c | 65
>>> ++++++++++++++++++++++++++++++++++++++++++++++++++-
>>>  1 file changed, 64 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
>>> index a14e8864e4fa..273a419a8c4d 100644
>>> --- a/net/xdp/xsk.c
>>> +++ b/net/xdp/xsk.c
>>> @@ -693,6 +693,57 @@ static int xsk_mmap(struct file *file, struct
>>> socket *sock,
>>>                              size, vma->vm_page_prot);
>>>  }
>>>
>>> +static int xsk_notifier(struct notifier_block *this,
>>> +                     unsigned long msg, void *ptr)
>>> +{
>>> +     struct net_device *dev = netdev_notifier_info_to_dev(ptr);
>>> +     struct net *net = dev_net(dev);
>>> +     int i, unregister_count = 0;
>>> +     struct sock *sk;
>>> +
>>> +     switch (msg) {
>>> +     case NETDEV_UNREGISTER:
>>> +             mutex_lock(&net->xdp.lock);
>>
>> The call is under the rtnl lock, and we're not modifying
>> the list, so this mutex shouldn't be needed.
>>
> 
> The list can, however, be modified outside the rtnl lock (e.g. at
> socket creation). AFAIK the hlist cannot be traversed lock-less,
> right?

We could use 'rcu_read_lock' instead and iterate with 'sk_for_each_rcu',
but we'll not be able to synchronize inside.

> 
>>
>>> +             sk_for_each(sk, &net->xdp.list) {
>>> +                     struct xdp_sock *xs = xdp_sk(sk);
>>> +
>>> +                     mutex_lock(&xs->mutex);
>>> +                     if (dev != xs->dev) {
>>> +                             mutex_unlock(&xs->mutex);
>>> +                             continue;
>>> +                     }
>>> +
>>> +                     sk->sk_err = ENETDOWN;
>>> +                     if (!sock_flag(sk, SOCK_DEAD))
>>> +                             sk->sk_error_report(sk);
>>> +
>>> +                     /* Wait for driver to stop using the xdp socket. */
>>> +                     xdp_del_sk_umem(xs->umem, xs);
>>> +                     xs->dev = NULL;
>>> +                     synchronize_net();
>> Isn't this by handled by the unregister_count case below?
>>
> 
> To clarify, setting dev to NULL and xdp_del_sk_umem() + sync makes
> sure that a driver doesn't touch the Tx and Rx rings. Nothing can be
> assumed about completion + fill ring (umem), until zero-copy has been
> disabled via ndo_bpf.
> 
>>> +
>>> +                     /* Clear device references in umem. */
>>> +                     xdp_put_umem(xs->umem);
>>> +                     xs->umem = NULL;
>>
>> This makes me uneasy.  We need to unregister the umem from
>> the device (xdp_umem_clear_dev()) but this can remove the umem
>> pages out from underneath the xsk.
>>
> 
> Yes, this is scary. The socket is alive, and userland typically has
> the fill/completion rings mmapped. Then the umem refcount is decreased
> and can potentially free the umem (fill rings etc.), as Jonathan says,
> underneath the xsk. Also, setting the xs umem/dev to zero, while the
> socket is alive, would allow a user to re-setup the socket, which we
> don't want to allow.
> 
>> Perhaps what's needed here is the equivalent of an unbind()
>> call that just detaches the umem/sk from the device, but does
>> not otherwise tear them down.
>>
> 
> Yeah, I agree. A detached/zombie state is needed during the socket lifetime.


I could try to rip the 'xdp_umem_release()' apart so the 'xdp_umem_clear_dev()'
could be called separately. This will allow to not tear down the 'umem'.
However, it seems that it'll not be easy to synchronize all parts.
Any suggestions are welcome.

Also, there is no way to not clear the 'dev' as we have to put the reference.
Maybe we could add the additional check to 'xsk_bind()' for current device
state (dev->reg_state == NETREG_REGISTERED). This will allow us to avoid
re-setup of the socket.

> 
>>
>>> +                     mutex_unlock(&xs->mutex);
>>> +                     unregister_count++;
>>> +             }
>>> +             mutex_unlock(&net->xdp.lock);
>>> +
>>> +             if (unregister_count) {
>>> +                     /* Wait for umem clearing completion. */
>>> +                     synchronize_net();
>>> +                     for (i = 0; i < unregister_count; i++)
>>> +                             dev_put(dev);
>>> +             }
>>> +
>>> +             break;
>>> +     }
>>> +
>>> +     return NOTIFY_DONE;
>>> +}
>>> +
>>>  static struct proto xsk_proto = {
>>>       .name =         "XDP",
>>>       .owner =        THIS_MODULE,
>>> @@ -727,7 +778,8 @@ static void xsk_destruct(struct sock *sk)
>>>       if (!sock_flag(sk, SOCK_DEAD))
>>>               return;
>>>
>>> -     xdp_put_umem(xs->umem);
>>> +     if (xs->umem)
>>> +             xdp_put_umem(xs->umem);
>> Not needed - xdp_put_umem() already does a null check.

Indeed. Thanks.

>> --
>> Jonathan
>>
>>
>>>
>>>       sk_refcnt_debug_dec(sk);
>>>  }
>>> @@ -784,6 +836,10 @@ static const struct net_proto_family
>>> xsk_family_ops = {
>>>       .owner  = THIS_MODULE,
>>>  };
>>>
>>> +static struct notifier_block xsk_netdev_notifier = {
>>> +     .notifier_call  = xsk_notifier,
>>> +};
>>> +
>>>  static int __net_init xsk_net_init(struct net *net)
>>>  {
>>>       mutex_init(&net->xdp.lock);
>>> @@ -816,8 +872,15 @@ static int __init xsk_init(void)
>>>       err = register_pernet_subsys(&xsk_net_ops);
>>>       if (err)
>>>               goto out_sk;
>>> +
>>> +     err = register_netdevice_notifier(&xsk_netdev_notifier);
>>> +     if (err)
>>> +             goto out_pernet;
>>> +
>>>       return 0;
>>>
>>> +out_pernet:
>>> +     unregister_pernet_subsys(&xsk_net_ops);
>>>  out_sk:
>>>       sock_unregister(PF_XDP);
>>>  out_proto:
>>> --
>>> 2.17.1
> 
> 
