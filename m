Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B88730AFCC
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 19:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbhBASxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 13:53:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbhBASxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 13:53:46 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76921C061573
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 10:53:05 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id w204so15083115ybg.2
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 10:53:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=w1S5A9Yt4qa7LpNAjIN2RJwcelZJ2g+S2W0ImolCCtE=;
        b=WHs34CIQ416OY/lpfka4AGEkd1yRlof1KJ+C6bsrMIrxPcie3XRXRhlM114LpZGxlg
         RzVuzaAVAHaCfKSh8S0eAyP2aBq54WLKNDwFwz+tiAuLEEDajm7tdARZbVt56r9R9jSl
         nPJQwRgO/+gWA+fs3zDRV50ZXmq9L2rWLJdRxntIAtxTwJbaAJl3/AWlJRriqLxDN0In
         Xy1DymfgpfNi2VP5F443LqlTc54SwFWGtBRSkL0L+EZKnheVXr+w0+yMLhH8GM+K65l+
         zjUeImV5S7v8iRQhG++AjOt9tKa2zL5gG0AlPqu8bSuCDN72qfGJUguS8l1qX3lOjr/x
         og4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=w1S5A9Yt4qa7LpNAjIN2RJwcelZJ2g+S2W0ImolCCtE=;
        b=jPB/eNXZlKGY/KOQ2v5YjYDLISOj3NCLReahTTA9UKaleISdETA32UpXMhaHBjtRXl
         K3J8pvdCu45HQD7OhcCo7LWRGi7FexeO6xX0Gf8e/3a6UFz8i5R29ohN1TuAGLFx0S9V
         RQvcIJhZhnR3OX2sToYB+g9uWg6ndnT1eiHKxzRX3LfmFdMbPYW5S0Vf26KxohQVjkKm
         eHfQJXvzWrF7ytDlM1gQKyuN5foUfRzVuNvnoCRilFh91OUoJW7jDtY75A4AZl3Fynke
         wzt0XDrig9K7Ecv85VJWqofaDTvPwLGpUGqhElp1II8dAlF4/Tm4ejvAnKuS+NdQAV84
         dT2g==
X-Gm-Message-State: AOAM530ljiHhYf70c5jRzmLsx8KEPtCUtZfSkdYpGyQi5/PbebRjizjx
        gR8vrRqiJfMippW6xQv0fLLg8TzdHehspp8KSG2NN0lRY/AEMw==
X-Google-Smtp-Source: ABdhPJyZepQ1bAa8eyTfU9RQ5svfRlCdV0CEXvnmo4Y2/4iRQ3Ho5acezvkpYnkIzPAq6gPRW/L0jFuxRcxSOAOHIvk=
X-Received: by 2002:a25:ba49:: with SMTP id z9mr20533882ybj.351.1612205584025;
 Mon, 01 Feb 2021 10:53:04 -0800 (PST)
MIME-Version: 1.0
References: <d4de6829f9fa4fa0b6622a330bda025d@SVR-IES-MBX-03.mgc.mentorg.com> <b0f27756-1d9f-3562-844c-85c85c20fc6c@gmail.com>
In-Reply-To: <b0f27756-1d9f-3562-844c-85c85c20fc6c@gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Mon, 1 Feb 2021 10:52:51 -0800
Message-ID: <CAEA6p_BoPxQ+paem9rWshGtZHDiBGH60gNFgfpu8bmU9QVRh5g@mail.gmail.com>
Subject: Re: Possible race in ipv4 routing
To:     David Ahern <dsahern@gmail.com>
Cc:     "Schmid, Carsten" <Carsten_Schmid@mentor.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 1, 2021 at 7:35 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 2/1/21 2:20 AM, Schmid, Carsten wrote:
> > Hi,
> >
> > on kernel 4.14(.147) i have seen something weird. The stack trace:
> >
> > [65064.457920] BUG: unable to handle kernel NULL pointer dereference at=
 0000000000000604
> > [65064.466677] IP: ip_route_output_key_hash_rcu+0x755/0x850
> > [65064.472599] PGD 0 P4D 0
> > [65064.475422] Oops: 0000 [#1] PREEMPT SMP NOPTI
> > [65064.480277] Modules linked in: bcmdhd(O) nls_cp437 nls_utf8 ebt_ip6 =
ebt_ip ebtable_filter ebtables squashfs zlib_inflate xz_dec veth lzo lzo_co=
mpress lzo_decompress nls_iso8859_1 nls_cp850 vfat fat cfq_iosched sd_mod a=
h4 esp4 xfrm4_mode_transport tntfs(PO) texfat(PO) usb_storage xfrm_user xfr=
m_algo cls_u32 cdc_acm sch_htb intel_tfm_governor snd_soc_apl_mgu_hu ecrypt=
fs intel_xhci_usb_role_switch roles dwc3 udc_core intel_ipu4_psys intel_ipu=
4_psys_csslib adv728x coretemp snd_soc_skl intel_ipu4_isys videobuf2_dma_co=
ntig videobuf2_memops sdw_cnl ipu4_acpi snd_soc_acpi_intel_match intel_ipu4=
_isys_csslib videobuf2_v4l2 snd_soc_acpi videobuf2_core sbi_apl i2c_i801 sn=
d_soc_core snd_compress snd_soc_skl_ipc sdw_bus xhci_pci crc8 ahci snd_soc_=
sst_ipc xhci_hcd libahci snd_soc_sst_dsp cfg80211 snd_hda_ext_core
> > [65064.559290]  libata snd_hda_core intel_ipu4_mmu usbcore rfkill usb_c=
ommon snd_pcm scsi_mod dwc3_pci snd_timer mei_me snd intel_ipu4 soundcore m=
ei iova nfsd auth_rpcgss lockd grace sunrpc zram zsmalloc loop fuse 8021q b=
ridge stp llc inap560t(O) i915 video backlight intel_gtt i2c_algo_bit drm_k=
ms_helper drm firmware_class igb_avb(O) ptp hwmon pps_core spi_pxa2xx_platf=
orm [last unloaded: bcmdhd]
> > [65064.598123] CPU: 0 PID: 249 Comm: 6310_io01 Tainted: P     U     O  =
  4.14.147-apl #1
> > [65064.606860] task: ffff96e9f19a3200 task.stack: ffffb3cb80450000
> > [65064.613465] RIP: 0010:ip_route_output_key_hash_rcu+0x755/0x850
> > [65064.619859] Blocking unknown connection: IN=3D OUT=3Dwlan_bridge SRC=
=3D172.16.222.97 DST=3D224.0.0.22 LEN=3D40 TOS=3D0x00 PREC=3D0xC0 TTL=3D1 I=
D=3D0 DF PROTO=3D2 MARK=3D0x1000d4
> > [65064.619972] RSP: 0018:ffffb3cb80453940 EFLAGS: 00010246
> > [65064.641436] RAX: ffff96e866eebf00 RBX: ffff96e800e5a238 RCX: 0000000=
000000000
> > [65064.649397] RDX: 0000000000000001 RSI: 0000000026c730a0 RDI: 0000000=
000000000
> > [65064.657363] RBP: ffffb3cb80453990 R08: 0000000000000000 R09: ffff96e=
9f5bdf000
> > [65064.665326] R10: 0000000000000000 R11: ffff96e875740540 R12: ffff96e=
866eebf00
> > [65064.673290] R13: ffffb3cb804539a0 R14: ffff96e9f1ba7000 R15: 0000000=
000000000
> > [65064.681252] FS:  00007efc327fc700(0000) GS:ffff96e9fdc00000(0000) kn=
lGS:0000000000000000
> > [65064.690284] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [65064.696697] CR2: 0000000000000604 CR3: 00000001f4d44000 CR4: 0000000=
0003406b0
> > [65064.704653] Call Trace:
> > [65064.707384]  ip_route_output_key_hash+0x82/0xb0
> > [65064.712438]  ip_route_output_flow+0x19/0x50
> > [65064.717104]  ip_queue_xmit+0x389/0x3c0
> > [65064.721286]  __tcp_transmit_skb+0x598/0x9f0
> > [65064.725956]  tcp_write_xmit+0x1ab/0xf40
> > [65064.730234]  __tcp_push_pending_frames+0x30/0xd0
> > [65064.735387]  tcp_push+0xe7/0x110
> > [65064.738985]  tcp_sendmsg_locked+0x9a3/0xe40
> > [65064.743652]  tcp_sendmsg+0x27/0x40
> > [65064.747444]  inet_sendmsg+0x2f/0xf0
> > [65064.751332]  sock_sendmsg+0x31/0x40
> > [65064.755221]  ___sys_sendmsg+0x28d/0x2a0
> > [65064.759500]  ? do_iter_readv_writev+0x103/0x160
> > [65064.764557]  ? try_to_wake_up+0x25c/0x460
> > [65064.769024]  ? default_wake_function+0xd/0x10
> > [65064.773893]  ? __wake_up_common+0x6e/0x120
> > [65064.778460]  ? __fget+0x71/0xa0
> > [65064.781962]  __sys_sendmsg+0x4f/0x90
> > [65064.785946]  ? __sys_sendmsg+0x4f/0x90
> > [65064.790125]  SyS_sendmsg+0x9/0x10
> > [65064.793818]  do_syscall_64+0x79/0x350
> > [65064.797900]  ? schedule+0x2e/0x90
> > [65064.801594]  ? exit_to_usermode_loop+0x5a/0x90
> > [65064.806549]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> > [65064.812183] RIP: 0033:0x7efc3c549807
> > [65064.816167] RSP: 002b:00007efc327f9500 EFLAGS: 00000293 ORIG_RAX: 00=
0000000000002e
> > [65064.824616] RAX: ffffffffffffffda RBX: 0000000000000233 RCX: 00007ef=
c3c549807
> > [65064.832575] RDX: 0000000000004000 RSI: 00007efc327f9570 RDI: 0000000=
000000233
> > [65064.840543] RBP: 00007efc327f9570 R08: 0000000000000000 R09: 0000000=
000000001
> > [65064.848500] R10: 00007efc2c087548 R11: 0000000000000293 R12: 0000000=
000004000
> > [65064.856459] R13: 0000000000000233 R14: 00007efc327fc5c0 R15: 00007ef=
c24bf7810
> > [65064.864419] Code: b1 72 e9 bc fe ff ff 4c 89 4d c8 4c 89 45 d0 e8 a2=
 08 be ff 4c 8b 45 d0 4c 8b 4d c8 e9 88 fa ff ff 48 8b 08 48 8b 89 98 04 00=
 00 <8b> 89 04 06 00 00 39 88 a0 00 00 00 0f 85 9c fe ff ff 8b 80 80
> > [65064.885531] RIP: ip_route_output_key_hash_rcu+0x755/0x850 RSP: ffffb=
3cb80453940
> > [65064.893689] CR2: 0000000000000604
> >
> > Fortunately i have a core dump, and analyzed that.
> > Finally in the analysis i came to that point:
> > (net/ipv4/route.c around line 1520):
> >
> > static bool rt_cache_valid(const struct rtable *rt)
> > {
> > returnrt &&
> > rt->dst.obsolete =3D=3D DST_OBSOLETE_FORCE_CHK &&
> > !rt_is_expired(rt); <<<< crash here, see below
> > }
> >
> > The code was executing to the check !rt_is_expired(rt); and the disasse=
mbly looks like
> > ffffffff814f1ba0:48 85 c0             test   rax,rax // (1127, check fo=
r rt not NULL)
> > ffffffff814f1ba3:74 0e                je     ffffffff814f1bb3 <ip_route=
_output_key_hash_rcu+0x603>
> > /usr/src/kernel/net/ipv4/route.c:1524
> > ffffffff814f1ba5:66 83 78 64 ff       cmp    WORD PTR [rax+0x64],0xffff=
 // rt->dst.obsolete accessed
> > __mkroute_output():
> >
> > /usr/src/kernel/net/ipv4/route.c:2276
> > rth =3D rcu_dereference(*prth);
> > ffffffff814f1baa:49 89 c4             mov    r12,rax // r12=3D rt
> > rt_cache_valid():
> > /usr/src/kernel/net/ipv4/route.c:1524
> > ffffffff814f1bad:0f 84 48 01 00 00    je     ffffffff814f1cfb <ip_route=
_output_key_hash_rcu+0x74b> goes to ***1***
> >
> > the only reference reaching this point is after the DST_OBSOLETE_FORCE_=
CHK above:
> > read_pnet():
> > /usr/src/kernel/include/net/net_namespace.h:282
> > ffffffff814f1cfb:48 8b 08             mov    rcx,QWORD PTR [rax]       =
<<<<<<***1*** need to come in here because previous instruction is a "jmp"
> > fetches net_device *dev into rcx, value is ffff96e866eeb000
> >
> > ffffffff814f1cfe:48 8b 89 98 04 00 00 mov    rcx,QWORD PTR [rcx+0x498]
> >     crash> rd 0xffff96e866eeb490 4
> >     ffff96e866eeb490:  0000000000000000 0000000000000000   ............=
.... that's a NULL pointer here
> >     ffff96e866eeb4a0:  8000000000025287 0000000000010002   .R..........=
....
> > crash>__read_once_size():
> > /usr/src/kernel/include/linux/compiler.h:183
> > ffffffff814f1d05:8b 89 04 06 00 00    mov    ecx,DWORD PTR [rcx+0x604] =
<<<<<<***** crash here. rcx =3D NULL, offset 0x604
> >
> > Looking at the data i can see that dst.obsolete=3D0x0002 (i ordered the=
 memdump into the struct), so why did we reach that point?
> > R12 =3D rt =3D ffff96e866eebf00 =3D struct rtable
> > SIZE: 216
> > struct rtable {
> >    [0x0] struct dst_entry dst;
> >         struct dst_entry {
> >            [0x0] struct net_device *dev;                        ffff96e=
866eeb000
> >            [0x8] struct callback_head callback_head;
> >                 struct callback_head {
> >                     [0x0] struct callback_head *next;           0000000=
000000000
> >                     [0x8] void (*func)(struct callback_head *); 0101003=
800000500
> >         }
> >         SIZE: 0x10
> >           [0x18] struct dst_entry *child;                       0000000=
000000000
> >           [0x20] struct dst_ops *ops;                           fffffff=
f8dcb28c0
> >           [0x28] unsigned long _metrics;                        fffffff=
f8da66d41
> >           [0x30] unsigned long expires;                         0000000=
000000000
> >           [0x38] struct dst_entry *path;                        ffff96e=
866eebf00
> >           [0x40] struct dst_entry *from;                        0000000=
000000000
> >           [0x48] struct xfrm_state *xfrm;                       0000000=
000000000
> >           [0x50] int (*input)(struct sk_buff *);                fffffff=
f8d49f640
> >           [0x58] int (*output)(struct net *, struct sock *, struct sk_b=
uff *);ffffffff8d49f6d0
> >           [0x60] unsigned short flags;                          0000
> >           [0x62] short error;                                   0000
> >           [0x64] short obsolete;                                0002 <<=
<< we have not ffff here, but 0x02
> >           [0x66] unsigned short header_len;                     0000
> >           [0x68] unsigned short trailer_len;                    0000
> >           [0x6a] unsigned short __pad3;                         0000
> >           [0x6c] __u32 __pad2;                                  0000000=
0
> >           [0x70] long __pad_to_align_refcnt[2];                 0000000=
000000000 0000000000000000
> >           [0x80] atomic_t __refcnt;                             0000000=
00
> >           [0x84] int __use;                                     0000000=
00
> >           [0x88] unsigned long lastuse;                         0000000=
103dc0d11
> >           [0x90] struct lwtunnel_state *lwtstate;               0000000=
000000000
> >                  union {
> >           [0x98]     struct dst_entry *next;                    0000000=
000000000
> >           [0x98]     struct rtable *rt_next;
> >           [0x98]     struct rt6_info *rt6_next;
> >           [0x98]     struct dn_route *dn_next;
> >                  };
> >         }
> >         SIZE: 0xa0
> > --- snip ---
> >
> > crash> rd 0xffff96e866eebf00 32 (=3Dr12=3Drt)
> > ffff96e866eebf00:  ffff96e866eeb000 0000000000000000   ...f............
> > ffff96e866eebf10:  0101003800000500 0000000000000000   ....8...........
> > ffff96e866eebf20:  ffffffff8dcb28c0 ffffffff8da66d41   .(......Am......
> > ffff96e866eebf30:  0000000000000000 ffff96e866eebf00   ...........f....
> > ffff96e866eebf40:  0000000000000000 0000000000000000   ................
> > ffff96e866eebf50:  ffffffff8d49f640 ffffffff8d49f6d0   @.I.......I.....
> > ffff96e866eebf60:  0000000200000000 0000000000000000   ................=
 <-- here is the "obsolete"
> > ffff96e866eebf70:  0000000000000000 0000000000000000   ................
> > ffff96e866eebf80:  0000000000000000 0000000103dc0d11   ................
> > ffff96e866eebf90:  0000000000000000 0000000000000000   ................
> > ffff96e866eebfa0:  0000000000025287 0000000000000001   .R..............
> > ffff96e866eebfb0:  0000000000000000 00000000000000fe   ................
> > ffff96e866eebfc0:  ffff96e866eebfc0 ffff96e866eebfc0   ...f.......f....
> > ffff96e866eebfd0:  ffff96e8388dfc00 ffff96e8388dfc82   ...8.......8....
> >
> > Looks like a race somewhere, but i am not familiar with the TCPIP code.
> > What i have found is a patch that was submitted for 4.14 and could have=
 somethig to do with that:
> > https://www.spinics.net/lists/stable-commits/msg133055.html
> > But this patch didn't make it into 4.14.
> >
> > Can someone check this race condition?
> >
>
> dst->dev is NULL. Adding author of the patch for thoughts.

It definitely looks like the race described in
https://www.spinics.net/lists/stable-commits/msg133055.html, from all
the evidence above.
However, I am not very sure, how rt_is_expired() could crash with NULL
ptr. I don't think dst->dev could be NULL even after calling
dst_dev_put(), cause we assign loopback_dev to dst->dev there.
Also, Carsten mentioned the memdump shows 'dst.obsolete=3D0x0002'. In
rt_is_expired(), if 'dst.obsolete=3D0x0002', we should not call
rt_is_expired(). So there might be some memory barrier that is
required in dst_dev_put()?
But anyway, since the fix above replaced dst_dev_put() with
rt_add_uncached_list(), I believe this crash should also be fixed.
