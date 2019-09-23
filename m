Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8A4BAC59
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 03:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390685AbfIWBPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 21:15:22 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:39478 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388216AbfIWBPW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Sep 2019 21:15:22 -0400
Received: by mail-vs1-f65.google.com with SMTP id f15so8338879vsq.6;
        Sun, 22 Sep 2019 18:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mjWndcryqOX85+Cl/ZBhZksAs81/4i5F7cy9Sy/VIEA=;
        b=r1f/hW1FopkZ9TKvw+vnXPGV3Fh0TzYRgcbFSflJkOWCunh0FU2AX3jOmVzsl9DEdm
         tjZa2cAMCyifh316xrjjSnmJBzkSsaIv35SbXj9I4bNS06VKVdr3qilaQdLW/fBasPf5
         hMxftAjFho8oZIhriGI1R51biipkv9Yz5pdkKpbhoh/u1zfpAynje29s+l4TqAjvfz92
         at2zmLKWIU9e4fMFw4/oXS7M3xDUO11e0oPl5pU9sMQMrQpnpGvE8UG3SonsX0b2ichz
         erGPMdkR6Kb1j7g+l7DUDobI0PfmXYve7VIPAYf2DmvJbiEHYXdZ0KTmFJv6HDk5b1xq
         O6uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mjWndcryqOX85+Cl/ZBhZksAs81/4i5F7cy9Sy/VIEA=;
        b=Yz6fK4z7qE0WK6NTre5XaLnjWlamWuxdH3Dv6iMDqeNlSNe/p5A2lNV9mDYE3nEZRW
         Erq2AQ40tYTh9XiNcnBwODTK/F8YguPOQ6Rk1e7HbxYj7idiwl7r0CfgYUtbG6nKiDdN
         p1YgOcro2IMpAo6afqrFoV8KCPn91By8KeaCVi7lhAbarqiSTmIeNGWKFRsJKHYI5oMf
         b8ymnumgtyjv0ep8hKyMZGIrKILmuRx69YmRNJEyyd25V5UHGzYz3rmb+lqaRbAZ72mO
         lq8mHOcl3NvV9VL+TkJuwVgID66nJyAVcuzNDwdBY4E7qPoeZJp77tAczwcS49PL+/8s
         y+XA==
X-Gm-Message-State: APjAAAVUN0uOylOaHUH1oLlWqnzM9UKaE/zmIVW46oeMBQhFou9zvHeD
        DL/FPV6GGBK48rLd+GEO8p5YdYTR2z8ds34ejxk=
X-Google-Smtp-Source: APXvYqz2oPjar9wR5sV2t9u7L5MQM82VFumZLQLW5vXsAWemw7XCIi6O2tTtyZTB9nj9FijIOsoArggujfdRWdVHOHc=
X-Received: by 2002:a67:4306:: with SMTP id q6mr8804202vsa.36.1569201320583;
 Sun, 22 Sep 2019 18:15:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190920185843.4096-1-matthew.cover@stackpath.com>
 <20190922080326-mutt-send-email-mst@kernel.org> <CAGyo_hqGbFdt1PoDrmo=S5iTO8TwbrbtOJtbvGT1WrFFMLwk-Q@mail.gmail.com>
 <20190922162546-mutt-send-email-mst@kernel.org> <CAGyo_hr+_oSwVSKSqKTXaouaMK-6b8+NVLTxWmZD3vn07GEGWA@mail.gmail.com>
 <f2e5b3d5-f38c-40e7-dda9-e1ed737a0135@redhat.com>
In-Reply-To: <f2e5b3d5-f38c-40e7-dda9-e1ed737a0135@redhat.com>
From:   Matt Cover <werekraken@gmail.com>
Date:   Sun, 22 Sep 2019 18:15:08 -0700
Message-ID: <CAGyo_hohbFP+=eu3jWL954hrOgqu4upaw6HTH2=1qC9jcENWxQ@mail.gmail.com>
Subject: Re: [PATCH net-next] tuntap: Fallback to automq on TUNSETSTEERINGEBPF
 prog negative return
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com,
        Eric Dumazet <edumazet@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Matthew Cover <matthew.cover@stackpath.com>,
        mail@timurcelik.de, pabeni@redhat.com,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        wangli39@baidu.com, lifei.shirley@bytedance.com,
        tglx@linutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 22, 2019 at 5:51 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2019/9/23 =E4=B8=8A=E5=8D=886:30, Matt Cover wrote:
> > On Sun, Sep 22, 2019 at 1:36 PM Michael S. Tsirkin <mst@redhat.com> wro=
te:
> >> On Sun, Sep 22, 2019 at 10:43:19AM -0700, Matt Cover wrote:
> >>> On Sun, Sep 22, 2019 at 5:37 AM Michael S. Tsirkin <mst@redhat.com> w=
rote:
> >>>> On Fri, Sep 20, 2019 at 11:58:43AM -0700, Matthew Cover wrote:
> >>>>> Treat a negative return from a TUNSETSTEERINGEBPF bpf prog as a sig=
nal
> >>>>> to fallback to tun_automq_select_queue() for tx queue selection.
> >>>>>
> >>>>> Compilation of this exact patch was tested.
> >>>>>
> >>>>> For functional testing 3 additional printk()s were added.
> >>>>>
> >>>>> Functional testing results (on 2 txq tap device):
> >>>>>
> >>>>>    [Fri Sep 20 18:33:27 2019] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D tun no=
 prog =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>>>>    [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() retur=
ned '-1'
> >>>>>    [Fri Sep 20 18:33:27 2019] tuntap: tun_automq_select_queue() ran
> >>>>>    [Fri Sep 20 18:33:27 2019] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D tun pr=
og -1 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>>>>    [Fri Sep 20 18:33:27 2019] tuntap: bpf_prog_run_clear_cb() retur=
ned '-1'
> >>>>>    [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() retur=
ned '-1'
> >>>>>    [Fri Sep 20 18:33:27 2019] tuntap: tun_automq_select_queue() ran
> >>>>>    [Fri Sep 20 18:33:27 2019] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D tun pr=
og 0 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>>>>    [Fri Sep 20 18:33:27 2019] tuntap: bpf_prog_run_clear_cb() retur=
ned '0'
> >>>>>    [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() retur=
ned '0'
> >>>>>    [Fri Sep 20 18:33:27 2019] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D tun pr=
og 1 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>>>>    [Fri Sep 20 18:33:27 2019] tuntap: bpf_prog_run_clear_cb() retur=
ned '1'
> >>>>>    [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() retur=
ned '1'
> >>>>>    [Fri Sep 20 18:33:27 2019] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D tun pr=
og 2 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>>>>    [Fri Sep 20 18:33:27 2019] tuntap: bpf_prog_run_clear_cb() retur=
ned '2'
> >>>>>    [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() retur=
ned '0'
> >>>>>
> >>>>> Signed-off-by: Matthew Cover <matthew.cover@stackpath.com>
> >>>>
> >>>> Could you add a bit more motivation data here?
> >>> Thank you for these questions Michael.
> >>>
> >>> I'll plan on adding the below information to the
> >>> commit message and submitting a v2 of this patch
> >>> when net-next reopens. In the meantime, it would
> >>> be very helpful to know if these answers address
> >>> some of your concerns.
> >>>
> >>>> 1. why is this a good idea
> >>> This change allows TUNSETSTEERINGEBPF progs to
> >>> do any of the following.
> >>>   1. implement queue selection for a subset of
> >>>      traffic (e.g. special queue selection logic
> >>>      for ipv4, but return negative and use the
> >>>      default automq logic for ipv6)
> >>>   2. determine there isn't sufficient information
> >>>      to do proper queue selection; return
> >>>      negative and use the default automq logic
> >>>      for the unknown
> >>>   3. implement a noop prog (e.g. do
> >>>      bpf_trace_printk() then return negative and
> >>>      use the default automq logic for everything)
> >>>
> >>>> 2. how do we know existing userspace does not rely on existing behav=
iour
> >>> Prior to this change a negative return from a
> >>> TUNSETSTEERINGEBPF prog would have been cast
> >>> into a u16 and traversed netdev_cap_txqueue().
> >>>
> >>> In most cases netdev_cap_txqueue() would have
> >>> found this value to exceed real_num_tx_queues
> >>> and queue_index would be updated to 0.
> >>>
> >>> It is possible that a TUNSETSTEERINGEBPF prog
> >>> return a negative value which when cast into a
> >>> u16 results in a positive queue_index less than
> >>> real_num_tx_queues. For example, on x86_64, a
> >>> return value of -65535 results in a queue_index
> >>> of 1; which is a valid queue for any multiqueue
> >>> device.
> >>>
> >>> It seems unlikely, however as stated above is
> >>> unfortunately possible, that existing
> >>> TUNSETSTEERINGEBPF programs would choose to
> >>> return a negative value rather than return the
> >>> positive value which holds the same meaning.
> >>>
> >>> It seems more likely that future
> >>> TUNSETSTEERINGEBPF programs would leverage a
> >>> negative return and potentially be loaded into
> >>> a kernel with the old behavior.
> >> OK if we are returning a special
> >> value, shouldn't we limit it? How about a special
> >> value with this meaning?
> >> If we are changing an ABI let's at least make it
> >> extensible.
> >>
> > A special value with this meaning sounds
> > good to me. I'll plan on adding a define
> > set to -1 to cause the fallback to automq.
>
>
> Can it really return -1?
>
> I see:
>
> static inline u32 bpf_prog_run_clear_cb(const struct bpf_prog *prog,
>                                          struct sk_buff *skb)
> ...
>
>
> >
> > The way I was initially viewing the old
> > behavior was that returning negative was
> > undefined; it happened to have the
> > outcomes I walked through, but not
> > necessarily by design.
>
>
> Having such fallback may bring extra troubles, it requires the eBPF
> program know the existence of the behavior which is not a part of kernel
> ABI actually. And then some eBPF program may start to rely on that which
> is pretty dangerous. Note, one important consideration is to have
> macvtap support where does not have any stuffs like automq.
>
> Thanks
>

How about we call this TUN_SSE_ABORT
instead of TUN_SSE_DO_AUTOMQ?

TUN_SSE_ABORT could be documented as
falling back to the default queue
selection method in either space
(presumably macvtap has some queue
selection method when there is no prog).

>
> >
> > In order to keep the new behavior
> > extensible, how should we state that a
> > negative return other than -1 is
> > undefined and therefore subject to
> > change. Is something like this
> > sufficient?
> >
> >    Documentation/networking/tc-actions-env-rules.txt
> >
> > Additionally, what should the new
> > behavior implement when a negative other
> > than -1 is returned? I would like to have
> > it do the same thing as -1 for now, but
> > with the understanding that this behavior
> > is undefined. Does this sound reasonable?
> >
> >>>> 3. why doesn't userspace need a way to figure out whether it runs on=
 a kernel with and
> >>>>     without this patch
> >>> There may be some value in exposing this fact
> >>> to the ebpf prog loader. What is the standard
> >>> practice here, a define?
> >>
> >> We'll need something at runtime - people move binaries between kernels
> >> without rebuilding then. An ioctl is one option.
> >> A sysfs attribute is another, an ethtool flag yet another.
> >> A combination of these is possible.
> >>
> >> And if we are doing this anyway, maybe let userspace select
> >> the new behaviour? This way we can stay compatible with old
> >> userspace...
> >>
> > Understood. I'll look into adding an
> > ioctl to activate the new behavior. And
> > perhaps a method of checking which is
> > behavior is currently active (in case we
> > ever want to change the default, say
> > after some suitably long transition
> > period).
> >
> >>>>
> >>>> thanks,
> >>>> MST
> >>>>
> >>>>> ---
> >>>>>   drivers/net/tun.c | 20 +++++++++++---------
> >>>>>   1 file changed, 11 insertions(+), 9 deletions(-)
> >>>>>
> >>>>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> >>>>> index aab0be4..173d159 100644
> >>>>> --- a/drivers/net/tun.c
> >>>>> +++ b/drivers/net/tun.c
> >>>>> @@ -583,35 +583,37 @@ static u16 tun_automq_select_queue(struct tun=
_struct *tun, struct sk_buff *skb)
> >>>>>        return txq;
> >>>>>   }
> >>>>>
> >>>>> -static u16 tun_ebpf_select_queue(struct tun_struct *tun, struct sk=
_buff *skb)
> >>>>> +static int tun_ebpf_select_queue(struct tun_struct *tun, struct sk=
_buff *skb)
> >>>>>   {
> >>>>>        struct tun_prog *prog;
> >>>>>        u32 numqueues;
> >>>>> -     u16 ret =3D 0;
> >>>>> +     int ret =3D -1;
> >>>>>
> >>>>>        numqueues =3D READ_ONCE(tun->numqueues);
> >>>>>        if (!numqueues)
> >>>>>                return 0;
> >>>>>
> >>>>> +     rcu_read_lock();
> >>>>>        prog =3D rcu_dereference(tun->steering_prog);
> >>>>>        if (prog)
> >>>>>                ret =3D bpf_prog_run_clear_cb(prog->prog, skb);
> >>>>> +     rcu_read_unlock();
> >>>>>
> >>>>> -     return ret % numqueues;
> >>>>> +     if (ret >=3D 0)
> >>>>> +             ret %=3D numqueues;
> >>>>> +
> >>>>> +     return ret;
> >>>>>   }
> >>>>>
> >>>>>   static u16 tun_select_queue(struct net_device *dev, struct sk_buf=
f *skb,
> >>>>>                            struct net_device *sb_dev)
> >>>>>   {
> >>>>>        struct tun_struct *tun =3D netdev_priv(dev);
> >>>>> -     u16 ret;
> >>>>> +     int ret;
> >>>>>
> >>>>> -     rcu_read_lock();
> >>>>> -     if (rcu_dereference(tun->steering_prog))
> >>>>> -             ret =3D tun_ebpf_select_queue(tun, skb);
> >>>>> -     else
> >>>>> +     ret =3D tun_ebpf_select_queue(tun, skb);
> >>>>> +     if (ret < 0)
> >>>>>                ret =3D tun_automq_select_queue(tun, skb);
> >>>>> -     rcu_read_unlock();
> >>>>>
> >>>>>        return ret;
> >>>>>   }
> >>>>> --
> >>>>> 1.8.3.1
