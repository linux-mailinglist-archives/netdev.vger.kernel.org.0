Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43D3618EB5A
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 19:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgCVSHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 14:07:00 -0400
Received: from mail-qt1-f176.google.com ([209.85.160.176]:35229 "EHLO
        mail-qt1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbgCVSHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 14:07:00 -0400
Received: by mail-qt1-f176.google.com with SMTP id v15so9776543qto.2
        for <netdev@vger.kernel.org>; Sun, 22 Mar 2020 11:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tlapnet.cz; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=wJWYFbw+bmOF5x25RmHgMkOjRFtRrw+uaSGy1bz18Nc=;
        b=VJTL/x90hK1hx5wDHnbGVmZMUTNFvdUQJXz2Qsk6SZvwilnw4jY+rW6twwVQR2128A
         uTer/qVbVDHB647jg1agTQ8AUtHWyLDR8/59iralpJjV049A5fFUx0d5rO9ehlpVmh+8
         ZxY5c0PBpQmL6BO4GBPU/hAdFM4T7yiQMR6DPWpDc3I8JdsmYKWXey8iizUW0HyDMURL
         fZV02lF++9Jw6G/HHIZ4HPWRYUlvilRabD7hEqcKQMqLzjtieZWnLsH/0D5XrlTb47jm
         JIVsZtaatklcgjKMp5EH8QNM3JupuJp69+PysCxfwp75tnRdB5NI00fW/s+g6KfrL3lS
         TMyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=wJWYFbw+bmOF5x25RmHgMkOjRFtRrw+uaSGy1bz18Nc=;
        b=cPPK/eK2ivvTujzAPHb9prnQERdXGXQ91IE7BfpBvQtFqrE4tZ58fDc2d/WNxXzNMC
         97He6hq+y3W4JF8ShbcsytJYT/jJPi2uuQx0YiCBsY8D4MCR5OIq7QPYhz6Q9u/mq+bp
         TOS1frexPw+5cAZA4mk2ZNtONwBlCzhQfWtC1TjAYJTf5T8qeV3r/GcWNN+PWasQFMMr
         lDCVegdi8AitBSaX7xmp/75qZjvrdjF2xD20y+fTLSVllnmChBtaWaMmCy+zfGDMOs4s
         pIkSHSWUjYF3gfL6V9RiIayAVDrU1Dzxc7YqzFIc0fcJtQEuUTqQn7Nesl3QXeN2wdOc
         oApQ==
X-Gm-Message-State: ANhLgQ2zVlycfpfRuSB5Z0Zo+fCsNU0LVtyf+wiKkmLQtJhqlbAHJOm3
        A3+QxE7y3nf9ScjFlZ8znl9oNT8rd4lJ8dCTqb43bGK5ZkK8VQ==
X-Google-Smtp-Source: ADFU+vtjs9S6C/A1WAABk9SEekCKYOJX5+rtsoAIR1r4cbitk7UhiD6sFueJEn0QpGvf+BjkLWIUqrnAkWMmDAlhuEM=
X-Received: by 2002:ac8:708b:: with SMTP id y11mr17704401qto.195.1584900416214;
 Sun, 22 Mar 2020 11:06:56 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?Q?V=C3=A1clav_Zindulka?= <vaclav.zindulka@tlapnet.cz>
Date:   Sun, 22 Mar 2020 19:06:44 +0100
Message-ID: <CANxWus8WiqQZBZF9aWF_wc-57OJcEb-MoPS5zup+JFY_oLwHGA@mail.gmail.com>
Subject: iproute2: tc deletion freezes whole server
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I've discovered problem with tc deletion when rules are defined in
egress of physical interface (dual port SFP+ card). I'm working on
shaping solution for medium sized ISP. I was moving from tc filter
setup to nftables classification and abandoned long used ifb
interfaces. Problem is that sometimes during deletion of tc class or
tc qdisc rules whole server freezes for some time. Mostly above 20s,
but not every server behaves this way. It causes BGP peers to fail
with Hold timer expired error. I'm unable to access server even via
IPMI console during that time. It took me a lot of time before I
discovered the cause of the problem and tried to move back to ifb. But
it was a dead end since ifb precedes netlink in packet path and there
is no way to classify packets and redirect them to ifb for shaping.
I'm in touch with nftables developer, but so far we have had no luck
doing packet classification in ifb ingress.

Recently I discovered the existence of perf tool and discovered that
delay was between tc and kernel. This is perf trace of tc qdisc del
dev enp1s0f0 root. Notice the 11s delay at the end. (Similar problem
is during deletion of minor tc class and qdiscs) This was done on
fresh Debian Stretch installation, but mostly the delay is much
greater. This problem is not limited to Debian Stretch. It happens
with Debian Buster and even with Ubuntu 19.10. It happens on kernels
4.9, 4.19, 5.1.2, 5.2.3, 5.4.6 as far as I've tested. It is not caused
by one manufacturer or device driver. We mostly use dual port Intel
82599ES cards made by SuperMicro and I've tried kernel drivers as well
as latest ixgbe driver. Exactly the same problem is with dual port
Mellanox ConnectX-4 LX, Myricom 10G-PCIE-8B cards too. Whole network
adapter resets after the deletion of rules.

perf trace tc qdisc del dev enp1s0f0 root
           ? (     ?   ): tc/9491  ... [continued]: execve()) = 0
     0.028 ( 0.002 ms): tc/9491 brk(
                               ) = 0x559328a6e000
     0.049 ( 0.004 ms): tc/9491 access(filename: 0x59eec4e7
                               ) = -1 ENOENT No such file or directory
     0.056 ( 0.002 ms): tc/9491 access(filename: 0x59eeec70, mode: R
                               ) = -1 ENOENT No such file or directory
     0.065 ( 0.004 ms): tc/9491 open(filename: 0x59eec988, flags:
CLOEXEC                             ) = 3
     0.071 ( 0.002 ms): tc/9491 fstat(fd: 3<socket:[151207]>, statbuf:
0x7ffe5cf5f8b0                 ) = 0
     0.074 ( 0.004 ms): tc/9491 mmap(len: 40805, prot: READ, flags:
PRIVATE, fd: 3                    ) = 0x7f425a0e8000
     0.080 ( 0.001 ms): tc/9491 close(fd: 3<socket:[151207]>
                               ) = 0
     0.086 ( 0.002 ms): tc/9491 access(filename: 0x59eec4e7
                               ) = -1 ENOENT No such file or directory
     0.092 ( 0.004 ms): tc/9491 open(filename: 0x5a0f4d68, flags:
CLOEXEC                             ) = 3
     0.097 ( 0.003 ms): tc/9491 read(fd: 3<socket:[151207]>, buf:
0x7ffe5cf5fa58, count: 832          ) = 832
     0.102 ( 0.002 ms): tc/9491 fstat(fd: 3<socket:[151207]>, statbuf:
0x7ffe5cf5f8f0                 ) = 0
     0.106 ( 0.003 ms): tc/9491 mmap(len: 8192, prot: READ|WRITE,
flags: PRIVATE|ANONYMOUS, fd: -1    ) = 0x7f425a0e6000
     0.113 ( 0.004 ms): tc/9491 mmap(len: 2191816, prot: EXEC|READ,
flags: PRIVATE|DENYWRITE, fd: 3   ) = 0x7f4259cb7000
     0.119 ( 0.006 ms): tc/9491 mprotect(start: 0x7f4259cce000, len:
2093056                          ) = 0
     0.126 ( 0.005 ms): tc/9491 mmap(addr: 0x7f4259ecd000, len: 8192,
prot: READ|WRITE, flags: PRIVATE|DENYWRITE|FIXED, fd: 3, off: 90112) =
0x7f4259ecd000
     0.141 ( 0.002 ms): tc/9491 close(fd: 3<socket:[151207]>
                               ) = 0
     0.149 ( 0.002 ms): tc/9491 access(filename: 0x59eec4e7
                               ) = -1 ENOENT No such file or directory
     0.154 ( 0.004 ms): tc/9491 open(filename: 0x5a0e64c8, flags:
CLOEXEC                             ) = 3
     0.160 ( 0.002 ms): tc/9491 read(fd: 3<socket:[151207]>, buf:
0x7ffe5cf5fa28, count: 832          ) = 832
     0.164 ( 0.002 ms): tc/9491 fstat(fd: 3<socket:[151207]>, statbuf:
0x7ffe5cf5f8c0                 ) = 0
     0.168 ( 0.004 ms): tc/9491 mmap(len: 3158248, prot: EXEC|READ,
flags: PRIVATE|DENYWRITE, fd: 3   ) = 0x7f42599b3000
     0.174 ( 0.005 ms): tc/9491 mprotect(start: 0x7f4259ab6000, len:
2093056                          ) = 0
     0.181 ( 0.004 ms): tc/9491 mmap(addr: 0x7f4259cb5000, len: 8192,
prot: READ|WRITE, flags: PRIVATE|DENYWRITE|FIXED, fd: 3, off: 1056768)
= 0x7f4259cb5000
     0.194 ( 0.001 ms): tc/9491 close(fd: 3<socket:[151207]>
                               ) = 0
     0.200 ( 0.002 ms): tc/9491 access(filename: 0x59eec4e7
                               ) = -1 ENOENT No such file or directory
     0.205 ( 0.003 ms): tc/9491 open(filename: 0x5a0e69a8, flags:
CLOEXEC                             ) = 3
     0.210 ( 0.002 ms): tc/9491 read(fd: 3<socket:[151207]>, buf:
0x7ffe5cf5f9f8, count: 832          ) = 832
     0.213 ( 0.002 ms): tc/9491 fstat(fd: 3<socket:[151207]>, statbuf:
0x7ffe5cf5f890                 ) = 0
     0.217 ( 0.004 ms): tc/9491 mmap(len: 2109680, prot: EXEC|READ,
flags: PRIVATE|DENYWRITE, fd: 3   ) = 0x7f42597af000
     0.223 ( 0.006 ms): tc/9491 mprotect(start: 0x7f42597b2000, len:
2093056                          ) = 0
     0.230 ( 0.004 ms): tc/9491 mmap(addr: 0x7f42599b1000, len: 8192,
prot: READ|WRITE, flags: PRIVATE|DENYWRITE|FIXED, fd: 3, off: 8192) =
0x7f42599b1000
     0.243 ( 0.001 ms): tc/9491 close(fd: 3<socket:[151207]>
                               ) = 0
     0.248 ( 0.002 ms): tc/9491 access(filename: 0x59eec4e7
                               ) = -1 ENOENT No such file or directory
     0.253 ( 0.004 ms): tc/9491 open(filename: 0x5a0e6e98, flags:
CLOEXEC                             ) = 3
     0.259 ( 0.002 ms): tc/9491 read(fd: 3<socket:[151207]>, buf:
0x7ffe5cf5f9c8, count: 832          ) = 832
     0.263 ( 0.002 ms): tc/9491 fstat(fd: 3<socket:[151207]>, statbuf:
0x7ffe5cf5f860                 ) = 0
     0.268 ( 0.004 ms): tc/9491 mmap(len: 3795296, prot: EXEC|READ,
flags: PRIVATE|DENYWRITE, fd: 3   ) = 0x7f4259410000
     0.274 ( 0.006 ms): tc/9491 mprotect(start: 0x7f42595a5000, len:
2097152                          ) = 0
     0.282 ( 0.005 ms): tc/9491 mmap(addr: 0x7f42597a5000, len: 24576,
prot: READ|WRITE, flags: PRIVATE|DENYWRITE|FIXED, fd: 3, off: 1658880)
= 0x7f42597a5000
     0.292 ( 0.003 ms): tc/9491 mmap(addr: 0x7f42597ab000, len: 14688,
prot: READ|WRITE, flags: PRIVATE|ANONYMOUS|FIXED, fd: -1) =
0x7f42597ab000
     0.302 ( 0.001 ms): tc/9491 close(fd: 3<socket:[151207]>
                               ) = 0
     0.312 ( 0.002 ms): tc/9491 access(filename: 0x59eec4e7
                               ) = -1 ENOENT No such file or directory
     0.317 ( 0.003 ms): tc/9491 open(filename: 0x5a0e7378, flags:
CLOEXEC                             ) = 3
     0.322 ( 0.002 ms): tc/9491 read(fd: 3<socket:[151207]>, buf:
0x7ffe5cf5f878, count: 832          ) = 832
     0.326 ( 0.002 ms): tc/9491 fstat(fd: 3<socket:[151207]>, statbuf:
0x7ffe5cf5f710                 ) = 0
     0.329 ( 0.004 ms): tc/9491 mmap(len: 2200072, prot: EXEC|READ,
flags: PRIVATE|DENYWRITE, fd: 3   ) = 0x7f42591f6000
     0.335 ( 0.004 ms): tc/9491 mprotect(start: 0x7f425920f000, len:
2093056                          ) = 0
     0.341 ( 0.004 ms): tc/9491 mmap(addr: 0x7f425940e000, len: 8192,
prot: READ|WRITE, flags: PRIVATE|DENYWRITE|FIXED, fd: 3, off: 98304) =
0x7f425940e000
     0.354 ( 0.001 ms): tc/9491 close(fd: 3<socket:[151207]>
                               ) = 0
     0.376 ( 0.003 ms): tc/9491 mmap(len: 8192, prot: READ|WRITE,
flags: PRIVATE|ANONYMOUS, fd: -1    ) = 0x7f425a0e4000
     0.387 ( 0.002 ms): tc/9491 arch_prctl(option: 4098, arg2:
139922955456576, arg3: 139922955458896, arg4: 139922955453744, arg5:
120) = 0
     0.453 ( 0.006 ms): tc/9491 mprotect(start: 0x7f42597a5000, len:
16384, prot: READ                ) = 0
     0.463 ( 0.004 ms): tc/9491 mprotect(start: 0x7f425940e000, len:
4096, prot: READ                 ) = 0
     0.473 ( 0.004 ms): tc/9491 mprotect(start: 0x7f42599b1000, len:
4096, prot: READ                 ) = 0
     0.491 ( 0.004 ms): tc/9491 mprotect(start: 0x7f4259cb5000, len:
4096, prot: READ                 ) = 0
     0.499 ( 0.003 ms): tc/9491 mprotect(start: 0x7f4259ecd000, len:
4096, prot: READ                 ) = 0
     0.526 ( 0.004 ms): tc/9491 mprotect(start: 0x559326baa000, len:
4096, prot: READ                 ) = 0
     0.534 ( 0.004 ms): tc/9491 mprotect(start: 0x7f425a0f2000, len:
4096, prot: READ                 ) = 0
     0.540 ( 0.010 ms): tc/9491 munmap(addr: 0x7f425a0e8000, len:
40805                               ) = 0
     0.634 ( 0.002 ms): tc/9491 brk(
                               ) = 0x559328a6e000
     0.638 ( 0.003 ms): tc/9491 brk(brk: 0x559328a8f000
                               ) = 0x559328a8f000
     0.650 ( 0.024 ms): tc/9491 open(filename: 0x269a18d1, mode:
IRUGO|IWUGO                          ) = 3
     0.681 ( 0.002 ms): tc/9491 fstat(fd: 3<socket:[151207]>, statbuf:
0x7ffe5cf5f9a0                 ) = 0
     0.685 ( 0.004 ms): tc/9491 read(fd: 3<socket:[151207]>, buf:
0x559328a6e240, count: 1024         ) = 36
     0.696 ( 0.002 ms): tc/9491 close(fd: 3<socket:[151207]>
                               ) = 0
     0.705 ( 0.007 ms): tc/9491 socket(family: NETLINK, type:
RAW|CLOEXEC                             ) = 3
     0.715 ( 0.002 ms): tc/9491 setsockopt(fd: 3<socket:[151207]>,
level: 1, optname: 7, optval: 0x7ffe5cf60294, optlen: 4) = 0
     0.719 ( 0.002 ms): tc/9491 setsockopt(fd: 3<socket:[151207]>,
level: 1, optname: 8, optval: 0x559326bac8c8, optlen: 4) = 0
     0.723 ( 0.003 ms): tc/9491 bind(fd: 3<socket:[151207]>, umyaddr:
0x559326bb8004, addrlen: 12     ) = 0
     0.728 ( 0.002 ms): tc/9491 getsockname(fd: 3<socket:[151207]>,
usockaddr: 0x559326bb8004, usockaddr_len: 0x7ffe5cf60290) = 0
     0.781 ( 0.033 ms): tc/9491 sendto(fd: 3<socket:[151207]>, buff:
0x7ffe5cf50180, len: 40          ) = 40
     0.819 ( 0.031 ms): tc/9491 recvmsg(fd: 3<socket:[151207]>, msg:
0x7ffe5cf480e0                   ) = 3752
     0.864 ( 0.005 ms): tc/9491 recvmsg(fd: 3<socket:[151207]>, msg:
0x7ffe5cf480e0                   ) = 5036
     0.872 ( 0.002 ms): tc/9491 recvmsg(fd: 3<socket:[151207]>, msg:
0x7ffe5cf480e0                   ) = 20
     0.888 (11260.106 ms): tc/9491 sendmsg(fd: 3<socket:[151207]>,
msg: 0x7ffe5cf48140                   ) = 36
 11261.021 ( 0.007 ms): tc/9491 recvmsg(fd: 3<socket:[151207]>, msg:
0x7ffe5cf48140                   ) = 36
 11261.037 ( 0.003 ms): tc/9491 close(fd: 3<socket:[151207]>
                               ) = 0
 11261.100 (     ?   ): tc/9491 exit_group(
                               )

When I call this command on ifb interface or RJ45 interface everything
is done within one second.

perf trace tc qdisc del dev ifb0 root
           ? (     ?   ): tc/9400  ... [continued]: execve()) = 0
     0.017 ( 0.001 ms): tc/9400 brk(
                               ) = 0x5569cb9ca000
     0.030 ( 0.003 ms): tc/9400 access(filename: 0xe2fbc4e7
                               ) = -1 ENOENT No such file or directory
     0.035 ( 0.001 ms): tc/9400 access(filename: 0xe2fbec70, mode: R
                               ) = -1 ENOENT No such file or directory
     0.041 ( 0.002 ms): tc/9400 open(filename: 0xe2fbc988, flags:
CLOEXEC                             ) = 3
     0.044 ( 0.002 ms): tc/9400 fstat(fd: 3<socket:[148457]>, statbuf:
0x7fff37870d50                 ) = 0
     0.047 ( 0.002 ms): tc/9400 mmap(len: 40805, prot: READ, flags:
PRIVATE, fd: 3                    ) = 0x7fa6e31b8000
     0.050 ( 0.001 ms): tc/9400 close(fd: 3<socket:[148457]>
                               ) = 0
     0.054 ( 0.001 ms): tc/9400 access(filename: 0xe2fbc4e7
                               ) = -1 ENOENT No such file or directory
     0.057 ( 0.003 ms): tc/9400 open(filename: 0xe31c4d68, flags:
CLOEXEC                             ) = 3
     0.060 ( 0.002 ms): tc/9400 read(fd: 3<socket:[148457]>, buf:
0x7fff37870ef8, count: 832          ) = 832
     0.064 ( 0.001 ms): tc/9400 fstat(fd: 3<socket:[148457]>, statbuf:
0x7fff37870d90                 ) = 0
     0.065 ( 0.002 ms): tc/9400 mmap(len: 8192, prot: READ|WRITE,
flags: PRIVATE|ANONYMOUS, fd: -1    ) = 0x7fa6e31b6000
     0.070 ( 0.002 ms): tc/9400 mmap(len: 2191816, prot: EXEC|READ,
flags: PRIVATE|DENYWRITE, fd: 3   ) = 0x7fa6e2d87000
     0.073 ( 0.004 ms): tc/9400 mprotect(start: 0x7fa6e2d9e000, len:
2093056                          ) = 0
     0.078 ( 0.003 ms): tc/9400 mmap(addr: 0x7fa6e2f9d000, len: 8192,
prot: READ|WRITE, flags: PRIVATE|DENYWRITE|FIXED, fd: 3, off: 90112) =
0x7fa6e2f9d000
     0.087 ( 0.001 ms): tc/9400 close(fd: 3<socket:[148457]>
                               ) = 0
     0.091 ( 0.001 ms): tc/9400 access(filename: 0xe2fbc4e7
                               ) = -1 ENOENT No such file or directory
     0.094 ( 0.002 ms): tc/9400 open(filename: 0xe31b64c8, flags:
CLOEXEC                             ) = 3
     0.097 ( 0.001 ms): tc/9400 read(fd: 3<socket:[148457]>, buf:
0x7fff37870ec8, count: 832          ) = 832
     0.100 ( 0.001 ms): tc/9400 fstat(fd: 3<socket:[148457]>, statbuf:
0x7fff37870d60                 ) = 0
     0.102 ( 0.003 ms): tc/9400 mmap(len: 3158248, prot: EXEC|READ,
flags: PRIVATE|DENYWRITE, fd: 3   ) = 0x7fa6e2a83000
     0.106 ( 0.004 ms): tc/9400 mprotect(start: 0x7fa6e2b86000, len:
2093056                          ) = 0
     0.110 ( 0.003 ms): tc/9400 mmap(addr: 0x7fa6e2d85000, len: 8192,
prot: READ|WRITE, flags: PRIVATE|DENYWRITE|FIXED, fd: 3, off: 1056768)
= 0x7fa6e2d85000
     0.118 ( 0.001 ms): tc/9400 close(fd: 3<socket:[148457]>
                               ) = 0
     0.122 ( 0.001 ms): tc/9400 access(filename: 0xe2fbc4e7
                               ) = -1 ENOENT No such file or directory
     0.124 ( 0.002 ms): tc/9400 open(filename: 0xe31b69a8, flags:
CLOEXEC                             ) = 3
     0.127 ( 0.001 ms): tc/9400 read(fd: 3<socket:[148457]>, buf:
0x7fff37870e98, count: 832          ) = 832
     0.130 ( 0.001 ms): tc/9400 fstat(fd: 3<socket:[148457]>, statbuf:
0x7fff37870d30                 ) = 0
     0.132 ( 0.003 ms): tc/9400 mmap(len: 2109680, prot: EXEC|READ,
flags: PRIVATE|DENYWRITE, fd: 3   ) = 0x7fa6e287f000
     0.135 ( 0.003 ms): tc/9400 mprotect(start: 0x7fa6e2882000, len:
2093056                          ) = 0
     0.139 ( 0.003 ms): tc/9400 mmap(addr: 0x7fa6e2a81000, len: 8192,
prot: READ|WRITE, flags: PRIVATE|DENYWRITE|FIXED, fd: 3, off: 8192) =
0x7fa6e2a81000
     0.147 ( 0.001 ms): tc/9400 close(fd: 3<socket:[148457]>
                               ) = 0
     0.150 ( 0.001 ms): tc/9400 access(filename: 0xe2fbc4e7
                               ) = -1 ENOENT No such file or directory
     0.153 ( 0.002 ms): tc/9400 open(filename: 0xe31b6e98, flags:
CLOEXEC                             ) = 3
     0.156 ( 0.001 ms): tc/9400 read(fd: 3<socket:[148457]>, buf:
0x7fff37870e68, count: 832          ) = 832
     0.158 ( 0.001 ms): tc/9400 fstat(fd: 3<socket:[148457]>, statbuf:
0x7fff37870d00                 ) = 0
     0.161 ( 0.003 ms): tc/9400 mmap(len: 3795296, prot: EXEC|READ,
flags: PRIVATE|DENYWRITE, fd: 3   ) = 0x7fa6e24e0000
     0.165 ( 0.004 ms): tc/9400 mprotect(start: 0x7fa6e2675000, len:
2097152                          ) = 0
     0.169 ( 0.003 ms): tc/9400 mmap(addr: 0x7fa6e2875000, len: 24576,
prot: READ|WRITE, flags: PRIVATE|DENYWRITE|FIXED, fd: 3, off: 1658880)
= 0x7fa6e2875000
     0.175 ( 0.002 ms): tc/9400 mmap(addr: 0x7fa6e287b000, len: 14688,
prot: READ|WRITE, flags: PRIVATE|ANONYMOUS|FIXED, fd: -1) =
0x7fa6e287b000
     0.182 ( 0.001 ms): tc/9400 close(fd: 3<socket:[148457]>
                               ) = 0
     0.187 ( 0.001 ms): tc/9400 access(filename: 0xe2fbc4e7
                               ) = -1 ENOENT No such file or directory
     0.190 ( 0.002 ms): tc/9400 open(filename: 0xe31b7378, flags:
CLOEXEC                             ) = 3
     0.193 ( 0.001 ms): tc/9400 read(fd: 3<socket:[148457]>, buf:
0x7fff37870d18, count: 832          ) = 832
     0.195 ( 0.001 ms): tc/9400 fstat(fd: 3<socket:[148457]>, statbuf:
0x7fff37870bb0                 ) = 0
     0.197 ( 0.003 ms): tc/9400 mmap(len: 2200072, prot: EXEC|READ,
flags: PRIVATE|DENYWRITE, fd: 3   ) = 0x7fa6e22c6000
     0.201 ( 0.003 ms): tc/9400 mprotect(start: 0x7fa6e22df000, len:
2093056                          ) = 0
     0.205 ( 0.002 ms): tc/9400 mmap(addr: 0x7fa6e24de000, len: 8192,
prot: READ|WRITE, flags: PRIVATE|DENYWRITE|FIXED, fd: 3, off: 98304) =
0x7fa6e24de000
     0.213 ( 0.001 ms): tc/9400 close(fd: 3<socket:[148457]>
                               ) = 0
     0.226 ( 0.002 ms): tc/9400 mmap(len: 8192, prot: READ|WRITE,
flags: PRIVATE|ANONYMOUS, fd: -1    ) = 0x7fa6e31b4000
     0.232 ( 0.001 ms): tc/9400 arch_prctl(option: 4098, arg2:
140354751516736, arg3: 140354751519056, arg4: 140354751513904, arg5:
120) = 0
     0.273 ( 0.004 ms): tc/9400 mprotect(start: 0x7fa6e2875000, len:
16384, prot: READ                ) = 0
     0.279 ( 0.002 ms): tc/9400 mprotect(start: 0x7fa6e24de000, len:
4096, prot: READ                 ) = 0
     0.285 ( 0.002 ms): tc/9400 mprotect(start: 0x7fa6e2a81000, len:
4096, prot: READ                 ) = 0
     0.295 ( 0.002 ms): tc/9400 mprotect(start: 0x7fa6e2d85000, len:
4096, prot: READ                 ) = 0
     0.299 ( 0.002 ms): tc/9400 mprotect(start: 0x7fa6e2f9d000, len:
4096, prot: READ                 ) = 0
     0.316 ( 0.002 ms): tc/9400 mprotect(start: 0x5569cb616000, len:
4096, prot: READ                 ) = 0
     0.321 ( 0.002 ms): tc/9400 mprotect(start: 0x7fa6e31c2000, len:
4096, prot: READ                 ) = 0
     0.324 ( 0.006 ms): tc/9400 munmap(addr: 0x7fa6e31b8000, len:
40805                               ) = 0
     0.379 ( 0.001 ms): tc/9400 brk(
                               ) = 0x5569cb9ca000
     0.381 ( 0.002 ms): tc/9400 brk(brk: 0x5569cb9eb000
                               ) = 0x5569cb9eb000
     0.387 ( 0.013 ms): tc/9400 open(filename: 0xcb40d8d1, mode:
IRUGO|IWUGO                          ) = 3
     0.404 ( 0.001 ms): tc/9400 fstat(fd: 3<socket:[148457]>, statbuf:
0x7fff37870e40                 ) = 0
     0.407 ( 0.002 ms): tc/9400 read(fd: 3<socket:[148457]>, buf:
0x5569cb9ca240, count: 1024         ) = 36
     0.413 ( 0.001 ms): tc/9400 close(fd: 3<socket:[148457]>
                               ) = 0
     0.419 ( 0.005 ms): tc/9400 socket(family: NETLINK, type:
RAW|CLOEXEC                             ) = 3
     0.426 ( 0.002 ms): tc/9400 setsockopt(fd: 3<socket:[148457]>,
level: 1, optname: 7, optval: 0x7fff37871734, optlen: 4) = 0
     0.429 ( 0.001 ms): tc/9400 setsockopt(fd: 3<socket:[148457]>,
level: 1, optname: 8, optval: 0x5569cb6188c8, optlen: 4) = 0
     0.431 ( 0.002 ms): tc/9400 bind(fd: 3<socket:[148457]>, umyaddr:
0x5569cb624004, addrlen: 12     ) = 0
     0.434 ( 0.001 ms): tc/9400 getsockname(fd: 3<socket:[148457]>,
usockaddr: 0x5569cb624004, usockaddr_len: 0x7fff37871730) = 0
     0.466 ( 0.024 ms): tc/9400 sendto(fd: 3<socket:[148457]>, buff:
0x7fff37861620, len: 40          ) = 40
     0.493 ( 0.020 ms): tc/9400 recvmsg(fd: 3<socket:[148457]>, msg:
0x7fff37859580                   ) = 3752
     0.521 ( 0.002 ms): tc/9400 recvmsg(fd: 3<socket:[148457]>, msg:
0x7fff37859580                   ) = 5032
     0.525 ( 0.001 ms): tc/9400 recvmsg(fd: 3<socket:[148457]>, msg:
0x7fff37859580                   ) = 20
     0.535 (516.200 ms): tc/9400 sendmsg(fd: 3<socket:[148457]>, msg:
0x7fff378595e0                   ) = 36
   516.744 ( 0.008 ms): tc/9400 recvmsg(fd: 3<socket:[148457]>, msg:
0x7fff378595e0                   ) = 36
   516.761 ( 0.002 ms): tc/9400 close(fd: 3<socket:[148457]>
                               ) = 0
   516.823 (     ?   ): tc/9400 exit_group(
                               )

My testing setup consists of approx. 18k tc class rules and approx.
13k tc qdisc rules and was altered only with different interface name.
Everything works OK with ifb interfaces and with metallic interfaces.
I don't know how to diagnose the problem further. It is most likely
that it will work with regular network cards. All problems begin with
SFP+ interfaces. I do a lot of dynamic operations and I modify shaping
tree according to real situation and changes in network so I'm doing
deletion of tc rules regularly. It is a matter of hours or days before
the whole server freezes due to tc deletion problem. I have reproducer
batches for tc ready if anybody will be willing to have a look at this
issue. I may offer one server which has this problem every time to
debug and test it. Or at least I would appreciate some advice on how
to diagnose process of tc deletion further.

Thank you
----
S pozdravem / Best Regards

Vaclav Zindulka
