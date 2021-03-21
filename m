Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4E9F3434F9
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 22:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbhCUVHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 17:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbhCUVGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 17:06:25 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CDAC061574;
        Sun, 21 Mar 2021 14:06:24 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id h6-20020a0568300346b02901b71a850ab4so14003060ote.6;
        Sun, 21 Mar 2021 14:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7lnSeJKALgT4j/LMqHSuE2leyL1i25TlOuPhy/z6BHk=;
        b=I7+QDTmoNJWlS3kc2JtI8Mxzc2mNCYNmc/3YLjdm+kZFzO9N3WJ9l/dhuxtA3ahpV+
         hBGPzCcNeUn4J+hzn+r86FygPtbh9LjQ+0CjkgpXtNOAKqmwCJb7LRp0QQ7vto9jlILW
         r9a1LBdACMAXrO4ak7Xczr4yCClEuMqaB7U649KS4FliVo2tQRgWl606pO9M+YYqYNg8
         lm6j/wrekPwqDNsNkQtwagxd2ymQWqueDAQk4sG5fpthw0r6Qh3syPw5vBXCWmtqxLbI
         /7uUKLbYQr4Qq5jICnNdBS/DOiTP2YgcNPjhQw0unRq0+6qxDrIh/KRfb3NWaYDGxX7M
         BH4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7lnSeJKALgT4j/LMqHSuE2leyL1i25TlOuPhy/z6BHk=;
        b=plLQ5uSlVIBpODVLL0cJPNF2VEFAL6OC7n5I6xipG6LMNBLAW4JNU20mZGdQyGCu6M
         k7cTogSYJm5QyvQQD+yFpdBjwtRh1+oiLFdjrfdAWgQM93i7ISiFH8s4OkZeEjUfOgUi
         w6JMHHHHPsZp6VgX0hJXlERP7NmWJU2qORwpufGg1jxxMySBUExybYZz4gh6J3pLmKUa
         xZQa4O7zbNgYsSheKvuS/3xJxox0Xzg206gvauOJMdioy9zhkwebF13MhXEkCK6gfLAG
         nLVG8DlQM+8Usi25iAl0TqkNNX9RU7WgkyeIMZgEA9NPI6LhawUB6RbSpX5eoEZKv8gH
         X+8Q==
X-Gm-Message-State: AOAM531JXNQSDA7o436WB+6vgKe5wU0sFZzFuNPsdLq1izIaH/YtnChY
        2SyOZbj1AM69Q8UMDiHebzURNaJF7Jku0mvDF70=
X-Google-Smtp-Source: ABdhPJywDB4vs5E6zHXCXc2ZblazyXGc3laKcnX/E+IePIxn6kWVKKE4MCi8+adM/lig+4Refv2RdW+7rgMpWqi5o+s=
X-Received: by 2002:a9d:21a5:: with SMTP id s34mr6542885otb.240.1616360783979;
 Sun, 21 Mar 2021 14:06:23 -0700 (PDT)
MIME-Version: 1.0
References: <13aed72.61c7.17853a6a5cd.Coremail.linma@zju.edu.cn>
In-Reply-To: <13aed72.61c7.17853a6a5cd.Coremail.linma@zju.edu.cn>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Sun, 21 Mar 2021 14:06:13 -0700
Message-ID: <CABBYNZKwHEXK680Xz+W=2qXdkO2eEzTBu38Hc=5DaxggkaTSsg@mail.gmail.com>
Subject: Re: BUG: Out of bounds read in hci_le_ext_adv_report_evt()
To:     =?UTF-8?B?6ams6bqf?= <linma@zju.edu.cn>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        yajin_zhou@zju.edu.cn, syzkaller@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sun, Mar 21, 2021 at 12:19 AM =E9=A9=AC=E9=BA=9F <linma@zju.edu.cn> wrot=
e:
>
> Hi there:
>
> Our team, zjublocksec, found the following problem during fuzzing, which =
seems undiscovered in previous.
>
> =3D=3D=3D=3D Basic Information =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> HEAD commit: 1e28eed17697bcf343c6743f0028cc3b5dd88bf0 (tag: v5.12-rc3, ma=
ster)
> Kernel config: refer to attached file (config)
> C POC code: refer to attached file (poc.c)
>
> =3D=3D=3D=3D KASAN Output =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> [   20.294394] BUG: KASAN: slab-out-of-bounds in hci_le_meta_evt+0x310b/0=
x3850
> [   20.300333] Read of size 2 at addr ffff888013805819 by task kworker/u5=
:0/53
> [   20.306227]
> [   20.307601] CPU: 0 PID: 53 Comm: kworker/u5:0 Not tainted 5.12.0-rc3+ =
#5
> [   20.313304] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIO=
S rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
> [   20.323006] Workqueue: hci0 hci_rx_work
> [   20.326303] Call Trace:
> [   20.328466]  dump_stack+0xdd/0x137
> [   20.331425]  ? hci_le_meta_evt+0x310b/0x3850
> [   20.335099]  ? hci_le_meta_evt+0x310b/0x3850
> [   20.338773]  print_address_description.constprop.0+0x18/0x130
> [   20.343697]  ? hci_le_meta_evt+0x310b/0x3850
> [   20.347383]  ? hci_le_meta_evt+0x310b/0x3850
> [   20.351059]  kasan_report.cold+0x7f/0x111
> [   20.354512]  ? hci_le_meta_evt+0x310b/0x3850
> [   20.358187]  hci_le_meta_evt+0x310b/0x3850
> [   20.361722]  ? run_timer_softirq+0x120/0x120
> [   20.365402]  ? queue_work_on+0x69/0xa0
> [   20.368654]  ? del_timer+0xb6/0x100
> [   20.371673]  ? kasan_set_track+0x1c/0x30
> [   20.375062]  ? le_conn_complete_evt+0x16e0/0x16e0
> [   20.379092]  ? skb_release_data+0x519/0x610
> [   20.382686]  ? kfree+0x91/0x270
> [   20.385413]  ? kasan_set_track+0x1c/0x30
> [   20.388797]  ? mutex_lock+0x89/0xd0
> [   20.391835]  ? __mutex_lock_slowpath+0x10/0x10
> [   20.395651]  ? hci_event_packet+0x436/0xa100
> [   20.399327]  ? bt_dbg+0xe1/0x130
> [   20.402118]  hci_event_packet+0x3213/0xa100
> [   20.405712]  ? _raw_write_lock_irqsave+0xd0/0xd0
> [   20.409672]  ? bt_dbg+0xe1/0x130
> [   20.412489]  ? bt_dbg+0xe1/0x130
> [   20.415304]  ? bt_err_ratelimited+0x140/0x140
> [   20.419059]  ? hci_cmd_status_evt+0x46a0/0x46a0
> [   20.422955]  ? bt_dbg+0xe1/0x130
> [   20.425754]  ? bt_err_ratelimited+0x50/0x140
> [   20.429429]  ? __wake_up_common_lock+0xde/0x130
> [   20.433333]  ? __wake_up_common+0x5d0/0x5d0
> [   20.436926]  ? _raw_spin_lock_irqsave+0x7b/0xd0
> [   20.440844]  ? hci_chan_sent+0x23/0x800
> [   20.444167]  ? __sanitizer_cov_trace_switch+0x50/0x90
> [   20.448504]  ? _raw_spin_lock_irqsave+0x7b/0xd0
> [   20.452396]  ? bt_dbg+0xe1/0x130
> [   20.455205]  ? bt_err_ratelimited+0x140/0x140
> [   20.458961]  ? _raw_spin_lock_irqsave+0x7b/0xd0
> [   20.462847]  ? _raw_write_lock_irqsave+0xd0/0xd0
> [   20.466832]  ? copy_fpregs_to_fpstate+0x14f/0x1d0
> [   20.470904]  hci_rx_work+0x2b9/0x8e0
> [   20.473993]  ? strscpy+0xa0/0x2a0
> [   20.476905]  process_one_work+0x747/0xfe0
> [   20.480392]  ? kthread_data+0x4f/0xc0
> [   20.483561]  worker_thread+0x641/0x1190
> [   20.486883]  ? rescuer_thread+0xd00/0xd00
> [   20.490332]  kthread+0x344/0x410
> [   20.493127]  ? kthread_create_worker_on_cpu+0xf0/0xf0
> [   20.497457]  ret_from_fork+0x22/0x30
> [   20.500563]
> [   20.501919] Allocated by task 223:
> [   20.504882]  kasan_save_stack+0x1b/0x40
> [   20.508212]  __kasan_kmalloc+0x7a/0x90
> [   20.511459]  load_elf_phdrs+0x103/0x210
> [   20.514763]  load_elf_binary+0x1dc/0x4dd0
> [   20.518220]  bprm_execve+0x741/0x1460
> [   20.521401]  do_execveat_common+0x621/0x7c0
> [   20.525013]  __x64_sys_execve+0x8f/0xc0
> [   20.528354]  do_syscall_64+0x33/0x40
> [   20.531465]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   20.535791]
> [   20.537154] The buggy address belongs to the object at ffff88801380560=
0
> [   20.537154]  which belongs to the cache kmalloc-512 of size 512
> [   20.547717] The buggy address is located 25 bytes to the right of
> [   20.547717]  512-byte region [ffff888013805600, ffff888013805800)
> [   20.557963] The buggy address belongs to the page:
> [   20.562066] page:00000000ef0b1214 refcount:1 mapcount:0 mapping:000000=
0000000000 index:0xffff888013802000 pfn:0x13800
> [   20.571028] head:00000000ef0b1214 order:3 compound_mapcount:0 compound=
_pincount:0
> [   20.577371] flags: 0x100000000010200(slab|head)
> [   20.581264] raw: 0100000000010200 ffff888006441450 ffffea0000473408 ff=
ff888006443940
> [   20.587833] raw: ffff888013802000 000000000015000c 00000001ffffffff 00=
00000000000000
> [   20.594388] page dumped because: kasan: bad access detected
> [   20.599157]
> [   20.600503] Memory state around the buggy address:
> [   20.604598]  ffff888013805700: 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00
> [   20.610722]  ffff888013805780: 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00
> [   20.616835] >ffff888013805800: fc fc fc fc fc fc fc fc fc fc fc fc fc =
fc fc fc
> [   20.622963]                             ^
> [   20.626401]  ffff888013805880: fc fc fc fc fc fc fc fc fc fc fc fc fc =
fc fc fc
> [   20.632507]  ffff888013805900: fc fc fc fc fc fc fc fc fc fc fc fc fc =
fc fc fc
>
> =3D=3D=3D=3D Bug Analysis =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> In fact, this out-of-bounds read is quite similar to an old found bug (KA=
SAN: out-of-bounds read in hci_le_direct_adv_report_evt). You can check thi=
s link to get useful information: https://groups.google.com/g/syzkaller-bug=
s/c/Z9-x9udEIxk/m/0NsClcU4BAAJ
>
> Anyhow, the buggy code for this time is shown below:
>
> static void hci_le_ext_adv_report_evt(struct hci_dev *hdev, struct sk_buf=
f *skb)
> {
>         u8 num_reports =3D skb->data[0];
>         void *ptr =3D &skb->data[1];
>
>         hci_dev_lock(hdev);
>
>         while (num_reports--) {
>                 struct hci_ev_le_ext_adv_report *ev =3D ptr;
>                 u8 legacy_evt_type;
>                 u16 evt_type;
>
>                 evt_type =3D __le16_to_cpu(ev->evt_type);
>                 legacy_evt_type =3D ext_evt_type_to_legacy(hdev, evt_type=
);
>                 if (legacy_evt_type !=3D LE_ADV_INVALID) {
>                         process_adv_report(hdev, legacy_evt_type, &ev->bd=
addr,
>                                            ev->bdaddr_type, NULL, 0, ev->=
rssi,
>                                            ev->data, ev->length,
>                                            !(evt_type & LE_EXT_ADV_LEGACY=
_PDU));
>                 }
>
>                 ptr +=3D sizeof(*ev) + ev->length;
>         }
>
>         hci_dev_unlock(hdev);
> }
>
> As you can see, the variable `num_reports` is not being properly checked.=
 The malformed event packet can fake a huge `num_reports` and cause `proces=
s_adv_report` to access invalid memory space. Yeah, the internal of this bu=
g is almost equivalent to the already found bug.
>
> =3D=3D=3D=3D Suggested Patch =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> As this bug is quite similar to that found one, it's recommended to adopt=
 a similar patch here like below (also in the attached file: patch.diff).
>
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -5685,10 +5685,14 @@ static void hci_le_ext_adv_report_evt(struct hci_=
dev *hdev, struct sk_buff *skb)
>  {
>         u8 num_reports =3D skb->data[0];
>         void *ptr =3D &skb->data[1];
> +       u32 len_processed =3D 0;
>
>         hci_dev_lock(hdev);
>
>         while (num_reports--) {
> +               if (len_processed > skb->len)
> +                       break;
> +
>                 struct hci_ev_le_ext_adv_report *ev =3D ptr;
>                 u8 legacy_evt_type;
>                 u16 evt_type;
> @@ -5703,6 +5707,7 @@ static void hci_le_ext_adv_report_evt(struct hci_de=
v *hdev, struct sk_buff *skb)
>                 }
>
>                 ptr +=3D sizeof(*ev) + ev->length;
> +               len_processed +=3D sizeof(*ev) + ev->length;
>         }
>
>         hci_dev_unlock(hdev);
>
> The idea here is just to prevent the `ptr` to go over bound of the `skb->=
len`. After testing, the reproducer code will not work out against this fix=
. :)

Or we do something like
https://lore.kernel.org/linux-bluetooth/20201024002251.1389267-1-luiz.dentz=
@gmail.com/,
that said the reason we didn't applied my patches was that the
controller would be the one generating invalid data, but it seems you
are reproducing with vhci controller which is only used for emulating
a controller and requires root privileges so it is unlikely these
conditions would happens with hardware itself, in the other hand as
there seems to be more and more reports using vhci to emulate broken
events it perhaps more productive to introduce proper checks for all
events so we don't have to deal with more reports like this in the
future.

> =3D=3D=3D=3D Others =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
>
> Please let me know if there is any confuses.
> Best wishes!



--=20
Luiz Augusto von Dentz
