Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB81D173A8F
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 16:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgB1PCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 10:02:32 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:36171 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726720AbgB1PCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 10:02:32 -0500
Received: by mail-qk1-f194.google.com with SMTP id f3so3223740qkh.3
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 07:02:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=+CnCmB8tSdrmygybkPCxFWrTQ8K8h2tfh7dYR5aj8mU=;
        b=rbtSBJkNwSr0jMSD26GwtyPalXgy0YkzxH/5U3q0qUxnMPHWMGc/McinmH9119AZk8
         d67932NOI3AGQvumzOOty6wRsOCxUYEyiS+MjUWFcploHMRWLPdE6rTtQ1tNkaqQa9Kw
         KHbwdhDMUEDU12ZR+ISnPLucIR6ZPcBAhVmAVy4SP6ReNty0rDW+Jq24lYCxg08CLQWr
         cnPOm2cGqN+Q/7X8zXD30bVBZGDzEXhMGQP9zU7ApJ7ELV3eeZK/kEJgY9h7zWnKXlQX
         eg+jhUCDYI/c4I3Xipn/M0JL0PaCCQEr/AVTX+Q85Ke9dWfgTMtvZbCf/CamNJo9oSPs
         DbYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=+CnCmB8tSdrmygybkPCxFWrTQ8K8h2tfh7dYR5aj8mU=;
        b=XGS7KYJIb9snp/yF8vHBqbeJyEEfa2LMYQRBGsBz6M79Bdmj35X1TEah6AmcN1es5y
         BJl7jbKy/hAoicSeOp7jApbrvZi5dD+W8Xp7fVKd1yu4hIgEVDXFkO93QIh3H5Ull6Up
         L5I/luhUF/xsTUeh2Z41KWSPUyQJplwzO4lcmpTeImFsk75QAlQ1vVtVgYpPMfBBUgDD
         aYPFuGGioIY6a9GnWbZw+LFB7XyW/ENtScAyHZDKymYU92kjj0X6d9k2fdc0ZZZZcDwg
         6jFRzHRUTonobvijKgN2B1s4+0oNVdLj6ZpeCK1EyIYO7kRGDVyPiN4Bq9ovwUhgwjiI
         kQqw==
X-Gm-Message-State: APjAAAVaUcE7Q8X6lcT+Jw+sgeg4BdNatovRIN0OCc5OreZ3F147sfkR
        Yvce2seUPbbQ9i4mSMKOQfWN7svvaqoyRUPq7AGp8dyN
X-Google-Smtp-Source: APXvYqyiRrcwe7O1tBBZGleAsm/X22EdjiflWl608hXHhE/Tjus4/5N6w9F9rYgSaZ3PY3miiIKTDk4J/UY40L/Zlmc=
X-Received: by 2002:a05:620a:16d4:: with SMTP id a20mr2715347qkn.168.1582902150986;
 Fri, 28 Feb 2020 07:02:30 -0800 (PST)
MIME-Version: 1.0
From:   Ian Kumlien <ian.kumlien@gmail.com>
Date:   Fri, 28 Feb 2020 16:02:19 +0100
Message-ID: <CAA85sZsO9EaS8fZJqx6=QJA+7epe88UE2zScqw-KHZYDRMjk5A@mail.gmail.com>
Subject: [VXLAN] [MLX5] Lost traffic and issues
To:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>, kliteyn@mellanox.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Including netdev - to see if someone else has a clue.

We have a few machines in a cloud and when upgrading from 4.16.7 ->
5.4.15 we ran in to
unexpected and intermittent problems.
(I have tested 5.5.6 and the problems persists)

What we saw, using several monitoring points, was that traffic
disappeared after what we can see when tcpdumping on "bond0"

We had tcpdump running on:
1, DHCP nodes (local tap interfaces)
2, Router instances on L3 node
3, Local node (where the VM runs) (tap, bridge and eventually tap
interface dumping VXLAN traffic)
4, Using port mirroring on the 100gbit switch to see what ended up on
the physical wire.

What we can see is that from the four step handshake for DHCP only two
steps works, the forth step will be dropped "on the nic".

We can see it go out bond0, in tagged VLAN and within a VXLAN packet -
however the switch never sees it.

There has been a few mlx5 changes wrt VXLAN which can be culprits but
it's really hard to judge.

dmesg |grep mlx
[    2.231399] mlx5_core 0000:0b:00.0: firmware version: 16.26.1040
[    2.912595] mlx5_core 0000:0b:00.0: Rate limit: 127 rates are
supported, range: 0Mbps to 97656Mbps
[    2.935012] mlx5_core 0000:0b:00.0: Port module event: module 0,
Cable plugged
[    2.949528] mlx5_core 0000:0b:00.1: firmware version: 16.26.1040
[    3.638647] mlx5_core 0000:0b:00.1: Rate limit: 127 rates are
supported, range: 0Mbps to 97656Mbps
[    3.661206] mlx5_core 0000:0b:00.1: Port module event: module 1,
Cable plugged
[    3.675562] mlx5_core 0000:0b:00.0: MLX5E: StrdRq(1) RqSz(8)
StrdSz(64) RxCqeCmprss(0)
[    3.846149] mlx5_core 0000:0b:00.1: MLX5E: StrdRq(1) RqSz(8)
StrdSz(64) RxCqeCmprss(0)
[    4.021738] mlx5_core 0000:0b:00.0 enp11s0f0: renamed from eth0
[    4.021962] mlx5_ib: Mellanox Connect-IB Infiniband driver v5.0-0

I have tried turning all offloads off, but the problem persists as
well - it's really weird that it seems to be only some packets.

To be clear, the bond0 interface is 2*100gbit, using 802.1ad (LACP)
with layer2+3 hashing.
This seems to be offloaded in to the nic (can it be turned off?) and
messages about modifying the "lag map" was
quite frequent until we did a firmware upgrade - even with upgraded
firmware, it continued but to a lesser extent.

With 5.5.7 approaching, we would want a path forward to handle this...
