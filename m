Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF7FB3D126
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 17:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391628AbfFKPm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 11:42:29 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:54187 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391456AbfFKPm2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 11:42:28 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190611154226euoutp01b2c37ab38aabfef9f1b887d080de1c00~nLz_jyXyJ1283912839euoutp01d
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 15:42:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190611154226euoutp01b2c37ab38aabfef9f1b887d080de1c00~nLz_jyXyJ1283912839euoutp01d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1560267746;
        bh=DzAYMUOYFVPeuXLVs2lVPNgTG8DLXSQwL678od2GAOc=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=Zjw6ulnsj39Yd5CFQPObA/1Qx35X2K2vlkzTdWLcvFReo4KR7ubk3yx/axG+uOaed
         lf5SiAjxtU+DjakyTUUKQLhrrorj899TM6Kc4miU/tsvQ8WiWyvlyPpW4yGOt2ImPb
         P2CiG/ZRcfon4Hg7lJdw0YieInVNfpJusFne5s0Y=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190611154225eucas1p2b0afef727f2bb5e8b8decb15e55e9d3a~nLz903_v22613826138eucas1p2B;
        Tue, 11 Jun 2019 15:42:25 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 3C.90.04377.1EBCFFC5; Tue, 11
        Jun 2019 16:42:25 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20190611154224eucas1p258146c0e892275093d4dec1ed5270bc4~nLz86EOy82202822028eucas1p2V;
        Tue, 11 Jun 2019 15:42:24 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190611154224eusmtrp112dec8d3cf154a53bb361dbe59f2cad1~nLz8qdm9B3041030410eusmtrp1i;
        Tue, 11 Jun 2019 15:42:24 +0000 (GMT)
X-AuditID: cbfec7f4-12dff70000001119-4a-5cffcbe102c6
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id DE.20.04140.0EBCFFC5; Tue, 11
        Jun 2019 16:42:24 +0100 (BST)
Received: from [106.109.129.180] (unknown [106.109.129.180]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20190611154223eusmtip1fae0adbce5465c447324119815c1e77d~nLz7_lD_P1154111541eusmtip1q;
        Tue, 11 Jun 2019 15:42:23 +0000 (GMT)
Subject: Re: [PATCH bpf v3] xdp: fix hang while unregistering device bound
 to xdp socket
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
From:   Ilya Maximets <i.maximets@samsung.com>
Message-ID: <625663fb-1b2b-c7b9-1af9-68bb80a3c12b@samsung.com>
Date:   Tue, 11 Jun 2019 18:42:22 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CAJ+HfNgsxwDFdsfsNkpendnc=uwrkXakLBRw=WnjLMCG93z_3w@mail.gmail.com>
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUhTYRTHe3a3u7vV5HFaHrQXGFaU5Vt9uB90JgUtqKg+lUm58maim7I5
        0wJbU0tWVBg5mgmDLHX2OufSIZFT1BS8Rgq+koZkLxrYFqGNrW3XyG+/8z//85zzh4cipJ2C
        aCpXXcRo1Mp8GSnmO3qW2N0zA/7MxHaWpNmafpL2Xn+JaHd3L0k/ZCv49PCNJSHd86WCpJ3P
        HxD0B+dDkm509QU0ywb69Z03aN9ahb1pjKdoN08JFY86vvIUppszhOK23YoUbtvmY2SGOCWb
        yc8tZjQJ8izxRXdNJa9wOb2kbtrF06PqRCMSUYD3ws/6RmREYkqKGxEYmj0kV3gQDBnuCbnC
        jeCtcY78NzKvb+EFWYobELR4UznTIgLTUEPIFIEzoKWLJYIciVPg863J0EsEXubB4HRlaJrE
        u6C/uRsFWYLlsFDHBpii+HgreKtjgvJ6fBI87bYVSzi8ezDLD7IIH4e+X2xIJ3AUGDxNAo63
        QHlrLRHcBXhcCIY7T/jc1Qegp+uVkOMI+NZrX+GNMHDv1ornKnys+Iq44apAGpePxzXSwP59
        UBg8jsA74IUzIYiA08E2v43DMBhdCOdOCINqh4ngZAlUXZdyb8TCn84GguNoGPvhFt5FMvOq
        YOZVYcyrwpj/r7UgvhVFMTqtKofRJquZS/FapUqrU+fEny9Q2VDgYw34ej1tyOk950KYQrJ1
        krcmf6ZUoCzWlqpcCChCFikx/vZlSiXZytLLjKbgrEaXz2hdKIbiy6IkV9ZMn5biHGURk8cw
        hYzmX5dHiaL1KO7N4z15EwcFz60Tv963efXKEnado681OXeTdf/hzUnyLWTdiR+p9Za7T32C
        U2wNNVo2FRH2eOORrsmkqpHLs21zusX+4U+xZz5kXPBn3TceMpX7Y0UXLNuXD3fYkxdOlNWz
        N+NSXA565NK+Z3LBwu3xa6Ppa44aamt1jtNpKC1VxtdeVCbtJDRa5V+q0nbKVAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t/xu7oPTv+PMXjwjcvi/LRTbBZ/2jYw
        Wnw+cpzNYs75FhaLK+0/2S2OvWhhs9i1biazxeVdc9gsVhw6ARRbIGaxvX8fowO3x5aVN5k8
        ds66y+6xeM9LJo/p3Q+ZPfq2rGL0+LxJLoAtSs+mKL+0JFUhI7+4xFYp2tDCSM/Q0kLPyMRS
        z9DYPNbKyFRJ384mJTUnsyy1SN8uQS/j87RWpoJfjhVzHxxiamCcZNDFyMkhIWAi8aZhM1MX
        IxeHkMBSRonnt2ayQySkJH78usAKYQtL/LnWxQZR9J5R4t63h0BFHBzCAlES15t5QGpEBGwk
        nvXcYQepYRb4xSRxaPJzdoiGVmaJE5MfMIJUsQnoSJxafQTM5hWwk3g79zwjyCAWAVWJP5Ok
        QcKiAhESs3c1sECUCEqcnPkEzOYUCJQ48fU8WCuzgLrEn3mXmCFscYmmLytZIWx5ieats5kn
        MArNQtI+C0nLLCQts5C0LGBkWcUoklpanJueW2ykV5yYW1yal66XnJ+7iREYpduO/dyyg7Hr
        XfAhRgEORiUe3gPT/8cIsSaWFVfmHmKU4GBWEuHt+v4vRog3JbGyKrUoP76oNCe1+BCjKdBv
        E5mlRJPzgQkkryTe0NTQ3MLS0NzY3NjMQkmct0PgYIyQQHpiSWp2ampBahFMHxMHp1QD4wTD
        LTXbtATsauX1XNY96Vr5bIPCTce/97vaWCzfca5dniq6jpvV6P93Oz2bBYJuC3aq/LtttLHB
        62UJy7Iullszps0wPLjZd6r8j7szl60IaNNZX/ztcLNYmIfUl+nzmSX3+J6a+WqW9Ldba59b
        RhpwxPwoEtxfa7b6teSzFbZsqx8sbuNtz1ViKc5INNRiLipOBAANDLE36AIAAA==
X-CMS-MailID: 20190611154224eucas1p258146c0e892275093d4dec1ed5270bc4
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
        <e2313edb-6617-cd52-1a40-4712c9f20127@samsung.com>
        <CAJ+HfNgsxwDFdsfsNkpendnc=uwrkXakLBRw=WnjLMCG93z_3w@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.06.2019 15:13, Björn Töpel wrote:
> On Tue, 11 Jun 2019 at 10:42, Ilya Maximets <i.maximets@samsung.com> wrote:
>>
>> On 11.06.2019 11:09, Björn Töpel wrote:
>>> On Mon, 10 Jun 2019 at 22:49, Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>>>>
>>>> On 10 Jun 2019, at 9:15, Ilya Maximets wrote:
>>>>
>>>>> Device that bound to XDP socket will not have zero refcount until the
>>>>> userspace application will not close it. This leads to hang inside
>>>>> 'netdev_wait_allrefs()' if device unregistering requested:
>>>>>
>>>>>   # ip link del p1
>>>>>   < hang on recvmsg on netlink socket >
>>>>>
>>>>>   # ps -x | grep ip
>>>>>   5126  pts/0    D+   0:00 ip link del p1
>>>>>
>>>>>   # journalctl -b
>>>>>
>>>>>   Jun 05 07:19:16 kernel:
>>>>>   unregister_netdevice: waiting for p1 to become free. Usage count = 1
>>>>>
>>>>>   Jun 05 07:19:27 kernel:
>>>>>   unregister_netdevice: waiting for p1 to become free. Usage count = 1
>>>>>   ...
>>>>>
>>>>> Fix that by implementing NETDEV_UNREGISTER event notification handler
>>>>> to properly clean up all the resources and unref device.
>>>>>
>>>>> This should also allow socket killing via ss(8) utility.
>>>>>
>>>>> Fixes: 965a99098443 ("xsk: add support for bind for Rx")
>>>>> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
>>>>> ---
>>>>>
>>>>> Version 3:
>>>>>
>>>>>     * Declaration lines ordered from longest to shortest.
>>>>>     * Checking of event type moved to the top to avoid unnecessary
>>>>>       locking.
>>>>>
>>>>> Version 2:
>>>>>
>>>>>     * Completely re-implemented using netdev event handler.
>>>>>
>>>>>  net/xdp/xsk.c | 65
>>>>> ++++++++++++++++++++++++++++++++++++++++++++++++++-
>>>>>  1 file changed, 64 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
>>>>> index a14e8864e4fa..273a419a8c4d 100644
>>>>> --- a/net/xdp/xsk.c
>>>>> +++ b/net/xdp/xsk.c
>>>>> @@ -693,6 +693,57 @@ static int xsk_mmap(struct file *file, struct
>>>>> socket *sock,
>>>>>                              size, vma->vm_page_prot);
>>>>>  }
>>>>>
>>>>> +static int xsk_notifier(struct notifier_block *this,
>>>>> +                     unsigned long msg, void *ptr)
>>>>> +{
>>>>> +     struct net_device *dev = netdev_notifier_info_to_dev(ptr);
>>>>> +     struct net *net = dev_net(dev);
>>>>> +     int i, unregister_count = 0;
>>>>> +     struct sock *sk;
>>>>> +
>>>>> +     switch (msg) {
>>>>> +     case NETDEV_UNREGISTER:
>>>>> +             mutex_lock(&net->xdp.lock);
>>>>
>>>> The call is under the rtnl lock, and we're not modifying
>>>> the list, so this mutex shouldn't be needed.
>>>>
>>>
>>> The list can, however, be modified outside the rtnl lock (e.g. at
>>> socket creation). AFAIK the hlist cannot be traversed lock-less,
>>> right?
>>
>> We could use 'rcu_read_lock' instead and iterate with 'sk_for_each_rcu',
>> but we'll not be able to synchronize inside.
>>
>>>
>>>>
>>>>> +             sk_for_each(sk, &net->xdp.list) {
>>>>> +                     struct xdp_sock *xs = xdp_sk(sk);
>>>>> +
>>>>> +                     mutex_lock(&xs->mutex);
>>>>> +                     if (dev != xs->dev) {
>>>>> +                             mutex_unlock(&xs->mutex);
>>>>> +                             continue;
>>>>> +                     }
>>>>> +
>>>>> +                     sk->sk_err = ENETDOWN;
>>>>> +                     if (!sock_flag(sk, SOCK_DEAD))
>>>>> +                             sk->sk_error_report(sk);
>>>>> +
>>>>> +                     /* Wait for driver to stop using the xdp socket. */
>>>>> +                     xdp_del_sk_umem(xs->umem, xs);
>>>>> +                     xs->dev = NULL;
>>>>> +                     synchronize_net();
>>>> Isn't this by handled by the unregister_count case below?
>>>>
>>>
>>> To clarify, setting dev to NULL and xdp_del_sk_umem() + sync makes
>>> sure that a driver doesn't touch the Tx and Rx rings. Nothing can be
>>> assumed about completion + fill ring (umem), until zero-copy has been
>>> disabled via ndo_bpf.
>>>
>>>>> +
>>>>> +                     /* Clear device references in umem. */
>>>>> +                     xdp_put_umem(xs->umem);
>>>>> +                     xs->umem = NULL;
>>>>
>>>> This makes me uneasy.  We need to unregister the umem from
>>>> the device (xdp_umem_clear_dev()) but this can remove the umem
>>>> pages out from underneath the xsk.
>>>>
>>>
>>> Yes, this is scary. The socket is alive, and userland typically has
>>> the fill/completion rings mmapped. Then the umem refcount is decreased
>>> and can potentially free the umem (fill rings etc.), as Jonathan says,
>>> underneath the xsk. Also, setting the xs umem/dev to zero, while the
>>> socket is alive, would allow a user to re-setup the socket, which we
>>> don't want to allow.
>>>
>>>> Perhaps what's needed here is the equivalent of an unbind()
>>>> call that just detaches the umem/sk from the device, but does
>>>> not otherwise tear them down.
>>>>
>>>
>>> Yeah, I agree. A detached/zombie state is needed during the socket lifetime.
>>
>>
>> I could try to rip the 'xdp_umem_release()' apart so the 'xdp_umem_clear_dev()'
>> could be called separately. This will allow to not tear down the 'umem'.
>> However, it seems that it'll not be easy to synchronize all parts.
>> Any suggestions are welcome.
>>
> 
> Thanks for continuing to work on this, Ilya.
> 
> What need to be done is exactly an "unbind()", i.e. returning the
> socket to the state prior bind, but disallowing any changes from
> userland (e.g. setsockopt/bind). So, unbind() + track that we're in
> "unbound" mode. :-) I think breaking up xdp_umem_release() is good way
> to go.

Thanks, I'll move in this direction.

BTW, I'll be out of office from tomorrow until the end of the week.
So, I'll most probably return to this on Monday.

> 
>> Also, there is no way to not clear the 'dev' as we have to put the reference.
>> Maybe we could add the additional check to 'xsk_bind()' for current device
>> state (dev->reg_state == NETREG_REGISTERED). This will allow us to avoid
>> re-setup of the socket.
>>
> 
> Yes, and also make sure that the rest of the syscall implementations
> don't allow for re-setup.

OK.

> 
> 
> Björn
> 
>>>
>>>>
>>>>> +                     mutex_unlock(&xs->mutex);
>>>>> +                     unregister_count++;
>>>>> +             }
>>>>> +             mutex_unlock(&net->xdp.lock);
>>>>> +
>>>>> +             if (unregister_count) {
>>>>> +                     /* Wait for umem clearing completion. */
>>>>> +                     synchronize_net();
>>>>> +                     for (i = 0; i < unregister_count; i++)
>>>>> +                             dev_put(dev);
>>>>> +             }
>>>>> +
>>>>> +             break;
>>>>> +     }
>>>>> +
>>>>> +     return NOTIFY_DONE;
>>>>> +}
>>>>> +
>>>>>  static struct proto xsk_proto = {
>>>>>       .name =         "XDP",
>>>>>       .owner =        THIS_MODULE,
>>>>> @@ -727,7 +778,8 @@ static void xsk_destruct(struct sock *sk)
>>>>>       if (!sock_flag(sk, SOCK_DEAD))
>>>>>               return;
>>>>>
>>>>> -     xdp_put_umem(xs->umem);
>>>>> +     if (xs->umem)
>>>>> +             xdp_put_umem(xs->umem);
>>>> Not needed - xdp_put_umem() already does a null check.
>>
>> Indeed. Thanks.
>>
>>>> --
>>>> Jonathan
>>>>
>>>>
>>>>>
>>>>>       sk_refcnt_debug_dec(sk);
>>>>>  }
>>>>> @@ -784,6 +836,10 @@ static const struct net_proto_family
>>>>> xsk_family_ops = {
>>>>>       .owner  = THIS_MODULE,
>>>>>  };
>>>>>
>>>>> +static struct notifier_block xsk_netdev_notifier = {
>>>>> +     .notifier_call  = xsk_notifier,
>>>>> +};
>>>>> +
>>>>>  static int __net_init xsk_net_init(struct net *net)
>>>>>  {
>>>>>       mutex_init(&net->xdp.lock);
>>>>> @@ -816,8 +872,15 @@ static int __init xsk_init(void)
>>>>>       err = register_pernet_subsys(&xsk_net_ops);
>>>>>       if (err)
>>>>>               goto out_sk;
>>>>> +
>>>>> +     err = register_netdevice_notifier(&xsk_netdev_notifier);
>>>>> +     if (err)
>>>>> +             goto out_pernet;
>>>>> +
>>>>>       return 0;
>>>>>
>>>>> +out_pernet:
>>>>> +     unregister_pernet_subsys(&xsk_net_ops);
>>>>>  out_sk:
>>>>>       sock_unregister(PF_XDP);
>>>>>  out_proto:
>>>>> --
>>>>> 2.17.1
>>>
>>>
> 
> 
