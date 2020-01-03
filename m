Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7148912F4A1
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 07:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbgACGm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 01:42:57 -0500
Received: from mail-io1-f44.google.com ([209.85.166.44]:38971 "EHLO
        mail-io1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgACGm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 01:42:57 -0500
Received: by mail-io1-f44.google.com with SMTP id c16so10629271ioh.6
        for <netdev@vger.kernel.org>; Thu, 02 Jan 2020 22:42:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=GXRrWVRXxQSkvms00APKrJdsAUTRC8dmWXHdSaPman4=;
        b=vkI7/C9JhnN4NSFKlGNvSYWKMmIvvlaLuKY5/kwqvrAMlszeeADQpFAEEJCA32BDuU
         mmJOG/ZtaL13t345XMY+tCk1mY76vL9ezi0jfyAaipDwW9wSNYsTqSMbD8L9EIIP0BL7
         4iOBQ06KaRV/xlRm34Gm9aCPDyCA83v2Suc9E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=GXRrWVRXxQSkvms00APKrJdsAUTRC8dmWXHdSaPman4=;
        b=hnmNbZpT/yVTyDu6OHDfb1lDPZd0GYhcutYrET5xe0Br71LZQ4FtNvtrViQnjz+d5s
         EvwxBQ9ZhenGwOaCSUbUR3Ro73D/yeO5mQ2/MDnnTLoY3AR//yzSvU1WYCgJ3lwbaCRU
         62tcmFec8nCNWeqquGj+qcTPGqkLlWkwBjolZyYDPimhID6n2Sr8T47xTmQh/+29ryzw
         qnBdCOGoingoEDCcWnxRNsSDtTWmh9/bKi8lreRxUgkCoSTQ5WuuVSdrX1Dt8yvTepCR
         V7iKOX/9DNE6k7RHAbJP0fF1+wx68Udhl20TMxdLAh4AaHY53dBcypZ1nBI47m6uzDsb
         IHZA==
X-Gm-Message-State: APjAAAVibC5fjtBfS2OOVjJ/NJx1thfcDIPsLbI0Jn0e1vMFqB6Fn34e
        xebMGaFTmvr19EtaNwDboaKSUoZgBqEpTRwMZEG10Z2Kuxw51w==
X-Google-Smtp-Source: APXvYqx/p0vGgwimQn6/N9nkQGc9iuCIQQ7Zd9kNtiQVnlqPG/SSvtkBTPjoFOFY0RyWh6eX9RM5YyvI5HyTzuS09dg=
X-Received: by 2002:a5d:88c8:: with SMTP id i8mr51901870iol.176.1578033776311;
 Thu, 02 Jan 2020 22:42:56 -0800 (PST)
MIME-Version: 1.0
From:   Yan Zhai <yan@cloudflare.com>
Date:   Thu, 2 Jan 2020 22:42:45 -0800
Message-ID: <CAO3-PboKFJm_RmrExrUidg8t-E5efvDg7+HDzsMO6R5V1G5cAA@mail.gmail.com>
Subject: Peer losing IP address after moving veth into namespace
To:     netdev@vger.kernel.org, kernel-team <kernel-team@cloudflare.com>,
        Ivan Babrou <ivan@cloudflare.com>,
        Erich Heine <erich@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi netdev folks,

  we have encountered a situation where moving veth into network
namespace can drop address on its peer.
 In the first case, I run following command:

yan@133m23:~$ sudo ip netns add foo
yan@133m23:~$ sudo ip link add dev foo type veth peer name Ifoo
yan@133m23:~$ sudo ip link set foo up
yan@133m23:~$ sudo ip addr add 10.1.128.2/31 dev foo
yan@133m23:~$ sudo ip addr show dev foo
437: foo@Ifoo: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc
noqueue state UP group default qlen 1000
    link/ether f2:6a:39:d1:2b:75 brd ff:ff:ff:ff:ff:ff
    inet 10.1.128.2/31 scope global foo
       valid_lft forever preferred_lft forever
    inet6 fe80::f06a:39ff:fed1:2b75/64 scope link
       valid_lft forever preferred_lft forever
yan@133m23:~$ sudo ip link set Ifoo netns foo
yan@133m23:~$ sudo ip addr show dev foo
437: foo@if436: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc
noqueue state LOWERLAYERDOWN group default qlen 1000
    link/ether f2:6a:39:d1:2b:75 brd ff:ff:ff:ff:ff:ff link-netns foo
    inet6 fe80::f06a:39ff:fed1:2b75/64 scope link
       valid_lft forever preferred_lft forever

If I add address to a veth, it always gets lost after its peer is moved into ns.

Somehow interesting thing is, if I set its peer to "Down" state, then
things seem to be OK!

yan@133m23:~$ sudo ip netns add foo
yan@133m23:~$ sudo ip link add dev foo type veth peer name Ifoo
yan@133m23:~$ sudo ip link set Ifoo down
yan@133m23:~$ sudo ip addr add 10.1.128.2/31 dev foo
yan@133m23:~$ sudo ip addr show dev foo
439: foo@Ifoo: <NO-CARRIER,BROADCAST,MULTICAST,UP,M-DOWN> mtu 1500
qdisc noqueue state LOWERLAYERDOWN group default qlen 1000
    link/ether 3a:94:12:d8:01:30 brd ff:ff:ff:ff:ff:ff
    inet 10.1.128.2/31 scope global foo
       valid_lft forever preferred_lft forever
    inet6 fe80::3894:12ff:fed8:130/64 scope link
       valid_lft forever preferred_lft forever
yan@133m23:~$ sudo ip link set Ifoo netns foo
yan@133m23:~$ sudo ip addr show dev foo
439: foo@if438: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc
noqueue state LOWERLAYERDOWN group default qlen 1000
    link/ether 3a:94:12:d8:01:30 brd ff:ff:ff:ff:ff:ff link-netns foo
    inet 10.1.128.2/31 scope global foo
       valid_lft forever preferred_lft forever
    inet6 fe80::3894:12ff:fed8:130/64 scope link
       valid_lft forever preferred_lft forever

The address is still on the device after its peer moved. But if I put
these commands in a shell, then it is not working again:

yan@133m23:~$ cat up.sh
#!/bin/sh -x

ip netns add foo
ip link add dev foo type veth peer name Ifoo
ip link set Ifoo down
ip addr add 10.1.128.2/31 dev foo
ip link set Ifoo netns foo
sleep 1
ip addr show dev foo
yan@133m23:~$ sudo bash up.sh
451: foo@if450: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc
noqueue state LOWERLAYERDOWN group default qlen 1000
    link/ether 86:24:e7:5b:d8:f0 brd ff:ff:ff:ff:ff:ff link-netns foo

If I add a "sleep 1" after dev creation, then it seems to be fine again.

Question: what is the expected behavior on a freshly created veth
pair? It seems to me that there is some race condition regarding the
2nd and 3rd case. Is this a known thing, or I accidentally triggered
some buggy path? Can someone help me sort out what is happening in
these cases? I am happy to provide more information if needed.

Thanks!

-- 
Yan
