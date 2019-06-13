Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A242843778
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 16:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732644AbfFMO7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 10:59:00 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:36350 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732620AbfFMOzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 10:55:41 -0400
Received: by mail-io1-f66.google.com with SMTP id h6so17573043ioh.3
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 07:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uup4+yu3rtMc7LeujGtatwYo2KR3g+6RsZgNCQu53+s=;
        b=dRA7kkC6r7wRPZLUONW10Np1uUb8HPBolEESaREKqFHCIt9zzjww757ZoQSNpKxNPG
         hzG+r+5YOC8bst+qIvQX3Xfyd/NIpwF/n5adKAckP6Ym7vRhL/7uWyyKnoNTat0f/nX8
         B/v+24+5LtdOQuMe3NPVEv7GWNVD6MuSM5cgFFNYRNcqOc35o62b1h/fb3YhTqQe6z0Q
         sEllM3MXFo42WWWhRLZSYtLip27DXU+a86+XbEKRZKPZ6AeIzggquANG1MUxj7B8j+C8
         bQ71VSyRSSIAU26XKUD916rOfN62mouWgp1ylR8aA9k5oYDq+qMlijPdOWeDkHHL7VBU
         o5iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uup4+yu3rtMc7LeujGtatwYo2KR3g+6RsZgNCQu53+s=;
        b=T9qEQoe3yMZhwqqdHfo+OEwt6t+k1Y4iCyYDCX8V+4MkJgqDWmWj/LntjBTNUOb2Ig
         Z+rr6guhPwjMelRY1XsWmoNdLMbOjbTabQxrzv8WCSd5pC6bvxV1KlOnWv4MO/3ja43l
         J+iajUunMQrvebsuiCyHJiRCphfpSQQgG4RV5VQkEC8bOhMFfAww3Ims37660ON5V/0p
         1C1xMu7XWpBplvvJlfiWhJvW5ogA+f981Uv5M86Vhmt7hoBo/Xu9z5VCyzYrTmz9lcbM
         0wlTem6od/Ht5XhBqGX7x/x+WoSfGgtI8MaCD6RKQRa7bD98h/RxYaAfALIRrfe6lnj3
         im/Q==
X-Gm-Message-State: APjAAAWszu8A7+K/3VI7yxVWgzKNkMjA19njFriaRVjtuY/LekZGOdeo
        8aRElclBVhFbccmK0iGhp1fvmDZvcZLGj95Tp80kzQ==
X-Google-Smtp-Source: APXvYqzndfKSRA8giBrYgV9Bq3flf7/vWqrwRTfUpglIJWfRs4WlFdnhSvBS3hk0Dee76SlakiYKGNbXkT69+kh9eqg=
X-Received: by 2002:a6b:b556:: with SMTP id e83mr46526986iof.94.1560437740323;
 Thu, 13 Jun 2019 07:55:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190613141521.424-1-hdanton@sina.com>
In-Reply-To: <20190613141521.424-1-hdanton@sina.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 13 Jun 2019 16:55:28 +0200
Message-ID: <CACT4Y+bAuAiApr9CxSH5CoDnZ5hYmU+K4kJqrSo5yBZLyrzONA@mail.gmail.com>
Subject: Re: memory leak in vhost_net_ioctl
To:     Hillf Danton <hdanton@sina.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        syzbot <syzbot+0789f0c7e45efd7bb643@syzkaller.appspotmail.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>,
        Asias He <asias@redhat.com>
Content-Type: multipart/mixed; boundary="000000000000355591058b35b99c"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000355591058b35b99c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 13, 2019 at 4:15 PM Hillf Danton <hdanton@sina.com> wrote:
>
>
> Hello Dmitry
>
> On Thu, 13 Jun 2019 20:12:06 +0800 Dmitry Vyukov wrote:
> > On Thu, Jun 13, 2019 at 2:07 PM Hillf Danton <hdanton@sina.com> wrote:
> > >
> > > Hello Jason
> > >
> > > On Thu, 13 Jun 2019 17:10:39 +0800 Jason Wang wrote:
> > > >
> > > > This is basically a kfree(ubuf) after the second vhost_net_flush() =
in
> > > > vhost_net_release().
> > > >
> > > Fairly good catch.
> > >
> > > > Could you please post a formal patch?
> > > >
> > > I'd like very much to do that; but I wont, I am afraid, until I colle=
ct a
> > > Tested-by because of reproducer without a cutting edge.
> >
> > You can easily collect Tested-by from syzbot for any bug with a reprodu=
cer;)
> > https://github.com/google/syzkaller/blob/master/docs/syzbot.md#testing-=
patches
> >
> Thank you for the light you are casting.

:)

But you did not ask syzbot to test. That would be something like this
(keeping syzbot email in CC):

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
master

(I've attached the patch because my email client is incapable of
sending non-corrupted patches inline, but otherwise inline patches
should work too).


> Here it goes.
> --->8--------
> From: Hillf Danton <hdanton@sina.com>
> Subject: [PATCH] vhost: fix memory leak in vhost_net_release
>
> syzbot found the following crash on:
>
> HEAD commit:    788a0249 Merge tag 'arc-5.2-rc4' of git://git.kernel.org/=
p..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x dc9ea6a00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=C3=95c73825cbdc=
7326
> dashboard link: https://syzkaller.appspot.com/bug?extid 89f0c7e45efd7bb64=
3
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x b31761a00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x 4892c1a00000
>
>
> udit: type 00 audit(1559768703.229:36): avc:  denied  { map } for
> pidq16 comm=3D"syz-executor330" path=3D"/root/syz-executor330334897"
> dev=3D"sda1" ino 461 scontext=3Dunconfined_u:system_r:insmod_t:s0-s0:c0.c=
1023
> tcontext=3Dunconfined_u:object_r:user_home_t:s0 tclass=3Dfile permissive=
=3D1
> executing program
> executing program
>
> BUG: memory leak
> unreferenced object 0xffff88812421fe40 (size 64):
>    comm "syz-executor330", pid 7117, jiffies 4294949245 (age 13.030s)
>    hex dump (first 32 bytes):
>      01 00 00 00 20 69 6f 63 00 00 00 00 64 65 76 2f  .... ioc....dev/
>      50 fe 21 24 81 88 ff ff 50 fe 21 24 81 88 ff ff  P.!$....P.!$....
>    backtrace:
>      [<00000000ae0c4ae0>] kmemleak_alloc_recursive include/linux/kmemleak=
.h:55 [inline]
>      [<00000000ae0c4ae0>] slab_post_alloc_hook mm/slab.h:439 [inline]
>      [<00000000ae0c4ae0>] slab_alloc mm/slab.c:3326 [inline]
>      [<00000000ae0c4ae0>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:35=
53
>      [<0000000079ebab38>] kmalloc include/linux/slab.h:547 [inline]
>      [<0000000079ebab38>] vhost_net_ubuf_alloc drivers/vhost/net.c:241 [i=
nline]
>      [<0000000079ebab38>] vhost_net_set_backend drivers/vhost/net.c:1534 =
[inline]
>      [<0000000079ebab38>] vhost_net_ioctl+0xb43/0xc10 drivers/vhost/net.c=
:1716
>      [<000000009f6204a2>] vfs_ioctl fs/ioctl.c:46 [inline]
>      [<000000009f6204a2>] file_ioctl fs/ioctl.c:509 [inline]
>      [<000000009f6204a2>] do_vfs_ioctl+0x62a/0x810 fs/ioctl.c:696
>      [<00000000b45866de>] ksys_ioctl+0x86/0xb0 fs/ioctl.c:713
>      [<00000000dfb41eb8>] __do_sys_ioctl fs/ioctl.c:720 [inline]
>      [<00000000dfb41eb8>] __se_sys_ioctl fs/ioctl.c:718 [inline]
>      [<00000000dfb41eb8>] __x64_sys_ioctl+0x1e/0x30 fs/ioctl.c:718
>      [<0000000049c1f547>] do_syscall_64+0x76/0x1a0 arch/x86/entry/common.=
c:301
>      [<0000000029cc8ca7>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> BUG: memory leak
> unreferenced object 0xffff88812421fa80 (size 64):
>    comm "syz-executor330", pid 7130, jiffies 4294949755 (age 7.930s)
>    hex dump (first 32 bytes):
>      01 00 00 00 01 00 00 00 00 00 00 00 2f 76 69 72  ............/vir
>      90 fa 21 24 81 88 ff ff 90 fa 21 24 81 88 ff ff  ..!$......!$....
>    backtrace:
>      [<00000000ae0c4ae0>] kmemleak_alloc_recursive  include/linux/kmemlea=
k.h:55 [inline]
>      [<00000000ae0c4ae0>] slab_post_alloc_hook mm/slab.h:439 [inline]
>      [<00000000ae0c4ae0>] slab_alloc mm/slab.c:3326 [inline]
>      [<00000000ae0c4ae0>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:35=
53
>      [<0000000079ebab38>] kmalloc include/linux/slab.h:547 [inline]
>      [<0000000079ebab38>] vhost_net_ubuf_alloc drivers/vhost/net.c:241  [=
inline]
>      [<0000000079ebab38>] vhost_net_set_backend drivers/vhost/net.c:1534 =
 [inline]
>      [<0000000079ebab38>] vhost_net_ioctl+0xb43/0xc10  drivers/vhost/net.=
c:1716
>      [<000000009f6204a2>] vfs_ioctl fs/ioctl.c:46 [inline]
>      [<000000009f6204a2>] file_ioctl fs/ioctl.c:509 [inline]
>      [<000000009f6204a2>] do_vfs_ioctl+0x62a/0x810 fs/ioctl.c:696
>      [<00000000b45866de>] ksys_ioctl+0x86/0xb0 fs/ioctl.c:713
>      [<00000000dfb41eb8>] __do_sys_ioctl fs/ioctl.c:720 [inline]
>      [<00000000dfb41eb8>] __se_sys_ioctl fs/ioctl.c:718 [inline]
>      [<00000000dfb41eb8>] __x64_sys_ioctl+0x1e/0x30 fs/ioctl.c:718
>      [<0000000049c1f547>] do_syscall_64+0x76/0x1a0  arch/x86/entry/common=
.c:301
>      [<0000000029cc8ca7>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> End of syzbot report.
>
> The function vhost_net_ubuf_alloc() appears in the two cases of dump info=
, for
> pid 7130 and 7117, suggesting that it is ubuf leak.
>
> Since commit c38e39c378f4 ("vhost-net: fix use-after-free in vhost_net_fl=
ush")
> the function vhost_net_flush() had been no longer releasing ubuf.
>
> Freeing the slab after the last flush in the release path fixes it.
>
>
> Fixes: c38e39c378f4 ("vhost-net: fix use-after-free in vhost_net_flush")
> Reported-by: Syzbot <syzbot+0789f0c7e45efd7bb643@syzkaller.appspotmail.co=
m>
> Suggested-by: Jason Wang <jasowang@redhat.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: Asias He <asias@redhat.com>
> Signed-off-by: Hillf Danton <hdanton@sina.com>
> ---
> This is sent only for collecting Tested-by.
>
>  drivers/vhost/net.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 3beb401..22fae0a 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -1404,6 +1404,7 @@ static int vhost_net_release(struct inode *inode, s=
truct file *f)
>         /* We do an extra flush before freeing memory,
>          * since jobs can re-queue themselves. */
>         vhost_net_flush(n);
> +       kfree(n->vqs[VHOST_NET_VQ_TX].ubufs);
>         kfree(n->vqs[VHOST_NET_VQ_RX].rxq.queue);
>         kfree(n->vqs[VHOST_NET_VQ_TX].xdp);
>         kfree(n->dev.vqs);
> --
>

--000000000000355591058b35b99c
Content-Type: application/octet-stream; name=patch
Content-Disposition: attachment; filename=patch
Content-Transfer-Encoding: base64
Content-ID: <f_jwus9oj40>
X-Attachment-Id: f_jwus9oj40

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmhvc3QvbmV0LmMgYi9kcml2ZXJzL3Zob3N0L25ldC5jCmlu
ZGV4IDNiZWI0MDEuLjIyZmFlMGEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvdmhvc3QvbmV0LmMKKysr
IGIvZHJpdmVycy92aG9zdC9uZXQuYwpAQCAtMTQwNCw2ICsxNDA0LDcgQEAgc3RhdGljIGludCB2
aG9zdF9uZXRfcmVsZWFzZShzdHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgZmlsZSAqZikKIAkv
KiBXZSBkbyBhbiBleHRyYSBmbHVzaCBiZWZvcmUgZnJlZWluZyBtZW1vcnksCiAJICogc2luY2Ug
am9icyBjYW4gcmUtcXVldWUgdGhlbXNlbHZlcy4gKi8KIAl2aG9zdF9uZXRfZmx1c2gobik7CisJ
a2ZyZWUobi0+dnFzW1ZIT1NUX05FVF9WUV9UWF0udWJ1ZnMpOwogCWtmcmVlKG4tPnZxc1tWSE9T
VF9ORVRfVlFfUlhdLnJ4cS5xdWV1ZSk7CiAJa2ZyZWUobi0+dnFzW1ZIT1NUX05FVF9WUV9UWF0u
eGRwKTsKIAlrZnJlZShuLT5kZXYudnFzKTsKLS0K
--000000000000355591058b35b99c--
