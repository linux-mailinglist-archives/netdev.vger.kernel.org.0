Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 770D023A328
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 13:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgHCLOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 07:14:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbgHCLOa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 07:14:30 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9156CC06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 04:14:29 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id b11so20257284lfe.10
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 04:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=7iv+Ath52lwSmJ+JoracmdU2g3zIf/GjHFE2xoezSwc=;
        b=mma7dnnopczzpwlYRdRFvWgzebRsTTWery0IM0pyFM3JpnQO5h3w0jYpK11tvp5HI9
         bKxmtytl0WC/n6R+Vu/pZQt5egEW9PupE3nmxjwiXXKM40mBn5sRRG19MWd9JGij0+eW
         2aTyc2/Lb6r9GEFrWgJDlVO1Up8ubM2ZNbiNx/FZtEq1BLUf+gUqDzHh/N93grMG+xuo
         danjV2H3rHB/xL/P4HlLio3I1TzryUSdvs5RlXpMm/X6XeNETpRWsf6i7tbxmc6SaT2i
         ByqjW8/glu+toU4frtJDWFGvqt4Haaz6fQPIKQ0xklkAXIa5FHV/jNpKEmjpugBm4N4o
         2vOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=7iv+Ath52lwSmJ+JoracmdU2g3zIf/GjHFE2xoezSwc=;
        b=e9Vua1658D/QMmqqAuRd8UJDFasG10jrYzuRM93M2f2WmgtX6bsZTpOgcpVqXt7O+7
         cshyxLlJjtsmZc/kkZcSKBQG7ZUJxLC6+DvCvvkLJa8RV4VBVinbsP0geyIKxoGmA2qs
         ZGyOCa+y5TwVARm/v4gfmHaUbVZcjg+oElS5mQzPz7J/6wfUKZajFW/5YdyjfwwfwKoZ
         oMSBkv7LSponwzVTvkaK3ja+KW8FvarRJO3ChJ2hQnKBR3ddAVc6ocmJ+dcy6v3CCiKB
         suoMw/V4lMxKTDl1QiIZkJIfFUA/neHgVC55ruRHVwCcoj156U/cVQ0w/MYCMh3wsqt0
         QRxA==
X-Gm-Message-State: AOAM532BO3YrkDR8gJNF6nDdT4dzuncTm2Q6zgSXG1OXAlTN5QJoeTlD
        x/jkSRPIOHD4+gsVGVkBNf2QWAyuhTZxigFps++B3BlW
X-Google-Smtp-Source: ABdhPJydCBeo3cLf1X5tZK0k3cDX5/pB/J972u59/RZcIpfGjPEv9RxK9AZSdPqeuDUDC/Z8AkbeW+ueloCEbUQ+jjk=
X-Received: by 2002:ac2:4436:: with SMTP id w22mr8461981lfl.176.1596453267000;
 Mon, 03 Aug 2020 04:14:27 -0700 (PDT)
MIME-Version: 1.0
From:   mastertheknife <mastertheknife@gmail.com>
Date:   Mon, 3 Aug 2020 14:14:15 +0300
Message-ID: <CANXY5y+iuzMg+4UdkPJW_Efun30KAPL1+h2S7HeSPp4zOrVC7g@mail.gmail.com>
Subject: PMTUD broken inside network namespace with multipath routing
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I have observed that PMTUD (Path MTU discovery) is broken using
multipath routing inside a network namespace. This breaks TCP, because
it keeps trying to send oversized packets.
Observed on kernel 5.4.44, other kernels weren't tested. However i
went through net/ipv4/route.c and haven't spotted changes in this
area, so i believe this bug is still there.

Host test with multipath routing:
---------------------------------
root@host1:~# ip route add 192.168.247.100/32 dev vmbr2 nexthop via
192.168.252.250 dev vmbr2 nexthop via 192.168.252.252 dev vmbr2
root@host1:~# ip route | grep -A2 192.168.247.100
192.168.247.100
 nexthop via 192.168.252.250 dev vmbr2 weight 1
 nexthop via 192.168.252.252 dev vmbr2 weight 1
root@host1:~# ping -M do -s 1380 192.168.247.100
PING 192.168.247.100 (192.168.247.100) 1380(1408) bytes of data.
From 192.168.252.252 icmp_seq=1 Frag needed and DF set (mtu = 1406)
ping: local error: Message too long, mtu=1406
ping: local error: Message too long, mtu=1406
ping: local error: Message too long, mtu=1406
ping: local error: Message too long, mtu=1406
^C
--- 192.168.247.100 ping statistics ---
5 packets transmitted, 0 received, +5 errors, 100% packet loss, time 80ms
root@host1:~# ip route get 192.168.247.100
192.168.247.100 via 192.168.252.250 dev vmbr2 src 192.168.252.15 uid 0
    cache expires 583sec mtu 1406

LXC container inside that host with multipath routing:
------------------------------------------------------
[root@lxctest ~]# ip route add 192.168.247.100/32 dev eth0 nexthop via
192.168.252.250 dev eth0 nexthop via 192.168.252.252 dev eth0
[root@lxctest ~]# ip route
default via 192.168.252.100 dev eth0 proto static metric 100
192.168.247.100
 nexthop via 192.168.252.250 dev eth0 weight 1
 nexthop via 192.168.252.252 dev eth0 weight 1
192.168.252.0/24 dev eth0 proto kernel scope link src 192.168.252.207 metric 100
[root@lxctest ~]# ping -M do -s 1380 192.168.247.100
PING 192.168.247.100 (192.168.247.100) 1380(1408) bytes of data.
From 192.168.252.252 icmp_seq=1 Frag needed and DF set (mtu = 1406)
From 192.168.252.252 icmp_seq=2 Frag needed and DF set (mtu = 1406)
From 192.168.252.252 icmp_seq=3 Frag needed and DF set (mtu = 1406)
From 192.168.252.252 icmp_seq=4 Frag needed and DF set (mtu = 1406)
[root@lxctest ~]# ip route get 192.168.247.100
192.168.247.100 via 192.168.252.252 dev eth0 src 192.168.252.207 uid 0
    cache

LXC container inside that host with regular routing:
----------------------------------------------------
[root@lxctest ~]# ip route add 192.168.247.100/32 via 192.168.252.252 dev eth0
[root@lxctest ~]# ip route
default via 192.168.252.100 dev eth0 proto static metric 100
192.168.247.100 via 192.168.252.252 dev eth0
192.168.252.0/24 dev eth0 proto kernel scope link src 192.168.252.207 metric 100
[root@lxctest ~]# ping -M do -s 1380 192.168.247.100
PING 192.168.247.100 (192.168.247.100) 1380(1408) bytes of data.
From 192.168.252.252 icmp_seq=1 Frag needed and DF set (mtu = 1406)
ping: local error: Message too long, mtu=1406
ping: local error: Message too long, mtu=1406
ping: local error: Message too long, mtu=1406
^C
--- 192.168.247.100 ping statistics ---
4 packets transmitted, 0 received, +4 errors, 100% packet loss, time 82ms
[root@lxctest ~]# ip route get 192.168.247.100
192.168.247.100 via 192.168.252.252 dev eth0 src 192.168.252.207 uid 0
    cache expires 591sec mtu 1406


What seems to be happening, is that when multipath routing is used
inside LXC (or any network namespace), the kernel doesn't generate a
routing exception to force the lower MTU.
I believe this is a bug inside the kernel.


Kfir Itzhak
