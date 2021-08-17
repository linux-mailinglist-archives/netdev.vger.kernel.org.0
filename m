Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C60F23EEBEC
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 13:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236975AbhHQLxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 07:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236713AbhHQLxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 07:53:03 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA40C061764;
        Tue, 17 Aug 2021 04:52:30 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id a93so38959242ybi.1;
        Tue, 17 Aug 2021 04:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=nN5AyaSU21urRQzFotyZwpm3IJcJTP2sy/JAwDAGWyQ=;
        b=fxJdGTz6p+q9bv7T1kxaS18/q1FD3s6Cbi6FiiK5ls9ePAQV9UR7mP11PjjzGUWWpn
         MZz+mt6mQljWGI47eef1sFATjhAj9MLDHP+vAMkImSJh0/Z0OcU1pN3khkPnCnYYpMoH
         HYZ7K7lUN4gCpk9CtRtlVqyLtKSGuNgDdciz1c3lDI4Tv6wbRWQ1z+BGp5+5LMhp/gFe
         xdmRkXsWAOVcIgmFw5F/zlovnGXIoYmS33aqJmZRHndA2olmu7A1FCYyJZEYEEU9NFTM
         0Mply0unFm6qg5PtUAFxZ/mRhJXywgAQdPU/E3xvoskGQgVnC+JA06P86kMk6Ubki/08
         sYNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=nN5AyaSU21urRQzFotyZwpm3IJcJTP2sy/JAwDAGWyQ=;
        b=ZKHDEyek/hirIGlnFQHLn/ufGFDX/erjcq6GNdSB49dIpckhRtQkcEZl6Hptzz393a
         zziAHB/CzkijBF7nq63QvQyKh1J0g/L4pOqeFE3qIwUgEvHfHRVzrvMBFc1pXCJLQCLF
         MEUeL7mr0D9QUMNBtemf4ZaFVh1H+PouE0aRnnVKRRfgh6IuKtB1JKuA7Hw0Cu47MypK
         rQh0Kb9T53bGT2qK72ynY3gAl5xfsTZ4J/Y4q4y61fp17YC4vdXlhZDvxJErORWMYqFc
         DTZdU4dnBAPEgClupDylOvrrGVUUTSQ5kgC5Zj0/RpSFHCenYfN9nEMErzWQnybKY82W
         j6tw==
X-Gm-Message-State: AOAM532XnvjQ8YH9Q6SVV10J4YKtwS3FluewgCx+qPkM9ttmm/K+NtfN
        l0aHbmG/5k9Mw/42CPaRkw6b/VYBoFyKclBx2eJXOV8C4iUDGw==
X-Google-Smtp-Source: ABdhPJxqvYL2NNwPA+JOksY3X2kV+YRY6QwC8QE7YhszAS3ocKSXLtJLdunPjyJTgErxdvl5tNOoX2VNelTHWhc5fCs=
X-Received: by 2002:a25:a241:: with SMTP id b59mr3995945ybi.522.1629201149523;
 Tue, 17 Aug 2021 04:52:29 -0700 (PDT)
MIME-Version: 1.0
From:   butt3rflyh4ck <butterflyhuangxx@gmail.com>
Date:   Tue, 17 Aug 2021 19:52:19 +0800
Message-ID: <CAFcO6XOLxfHcRFVNvUTPVNiyQ4FKwZ-x9SDgL7n9EJphoxawxQ@mail.gmail.com>
Subject: Another out-of-bound Read in qrtr_endpoint_post in net/qrtr/qrtr.c
To:     mani@kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, there is another out-of-bound read in qrtr_endpoint_post in
net/qrtr/qrtr.c in 5.14.0-rc6+ and reproduced.

#analyze
In qrtr_endpoint_post, it would post incoming data from the user, the
=E2=80=98len=E2=80=99 is the size of data, the problem is in 'size'.
```
case QRTR_PROTO_VER_1:
if (len < sizeof(*v1))   // just  judge len < sizeof(*v1)
goto err;
v1 =3D data;
hdrlen =3D sizeof(*v1);
[...]
size =3D le32_to_cpu(v1->size);
break;
```
If the version of qrtr proto  is QRTR_PROTO_VER_1, hdrlen is
sizeof(qrtr_hdr_v1) and size is le32_to_cpu(v1->size).
```
if (len < sizeof(*v2))  // just judge len < sizeof(*v2)
goto err;
v2 =3D data;
hdrlen =3D sizeof(*v2) + v2->optlen;
[...]
size =3D le32_to_cpu(v2->size);
break;
```
if version of qrtr proto is QRTR_PROTO_VER_2, hdrlen is
sizeof(qrtr_hdr_v2) and size is le32_to_cpu(v2->size).

the code as below can be bypassed.
```
if (len !=3D ALIGN(size, 4) + hdrlen)
goto err;
```
if we set size zero and  make 'len' equal to 'hdrlen', the judgement
is bypassed.

```
if (cb->type =3D=3D QRTR_TYPE_NEW_SERVER) {
/* Remote node endpoint can bridge other distant nodes */
const struct qrtr_ctrl_pkt *pkt =3D data + hdrlen;

qrtr_node_assign(node, le32_to_cpu(pkt->server.node)); //[1]
}
```
*pkt =3D data + hdrlen =3D data + len, so pkt pointer the end of data.
[1]le32_to_cpu(pkt->server.node) could read out of bound.

#crash log:
[ 2436.657182][ T8433]
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[ 2436.658615][ T8433] BUG: KASAN: slab-out-of-bounds in
qrtr_endpoint_post+0x478/0x5b0
[ 2436.659971][ T8433] Read of size 4 at addr ffff88800ef30a2c by task
qrtr_endpoint_p/8433
[ 2436.661476][ T8433]
[ 2436.661964][ T8433] CPU: 1 PID: 8433 Comm: qrtr_endpoint_p Not
tainted 5.14.0-rc6+ #7
[ 2436.663431][ T8433] Hardware name: QEMU Standard PC (i440FX + PIIX,
1996), BIOS 1.13.0-1ubuntu1 04/01/2014
[ 2436.665220][ T8433] Call Trace:
[ 2436.665870][ T8433]  dump_stack_lvl+0x57/0x7d
[ 2436.666748][ T8433]  print_address_description.constprop.0.cold+0x93/0x3=
34
[ 2436.668054][ T8433]  ? qrtr_endpoint_post+0x478/0x5b0
[ 2436.669072][ T8433]  ? qrtr_endpoint_post+0x478/0x5b0
[ 2436.669957][ T8433]  kasan_report.cold+0x83/0xdf
[ 2436.670833][ T8433]  ? qrtr_endpoint_post+0x478/0x5b0
[ 2436.671780][ T8433]  kasan_check_range+0x14e/0x1b0
[ 2436.672707][ T8433]  qrtr_endpoint_post+0x478/0x5b0
[ 2436.673646][ T8433]  qrtr_tun_write_iter+0x8b/0xe0
[ 2436.674587][ T8433]  new_sync_write+0x245/0x360
[ 2436.675462][ T8433]  ? new_sync_read+0x350/0x350
[ 2436.676353][ T8433]  ? policy_view_capable+0x3b0/0x6d0
[ 2436.677266][ T8433]  ? apparmor_task_setrlimit+0x4d0/0x4d0
[ 2436.678251][ T8433]  vfs_write+0x344/0x4e0
[ 2436.679024][ T8433]  ksys_write+0xc4/0x160
[ 2436.679758][ T8433]  ? __ia32_sys_read+0x40/0x40
[ 2436.680605][ T8433]  ? syscall_enter_from_user_mode+0x21/0x70
[ 2436.681661][ T8433]  do_syscall_64+0x35/0xb0
[ 2436.682445][ T8433]  entry_SYSCALL_64_after_hwframe+0x44/0xae

#fix suggestion
'size' should not be zero, it is length of packet, excluding this
header or (excluding this header and optlen).


Regards,
 butt3rflyh4ck.
--
Active Defense Lab of Venustech
