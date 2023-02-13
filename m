Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D194B693CCE
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 04:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjBMDO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 22:14:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBMDOZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 22:14:25 -0500
Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E23DE9EF7
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 19:14:24 -0800 (PST)
From:   Sam James <sam@gentoo.org>
Content-Type: multipart/signed;
        boundary="Apple-Mail=_E939B0BA-C694-44F0-8573-E664FE354FF7";
        protocol="application/pgp-signature";
        micalg=pgp-sha512
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Iproute2 crashes with glibc-2.37, caused by UB in print_route
 (overlapping strncpy arguments)
Message-Id: <0011AC38-4823-4D0A-8580-B108D08959C2@gentoo.org>
Date:   Mon, 13 Feb 2023 03:14:10 +0000
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Frederik Schwan <freswa@archlinux.org>,
        Doug Freed <dwfreed@mtu.edu>,
        Gentoo Toolchain <toolchain@gentoo.org>
To:     netdev@vger.kernel.org
X-Mailer: Apple Mail (2.3731.300.101.1.3)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Apple-Mail=_E939B0BA-C694-44F0-8573-E664FE354FF7
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Hi,

[Apologies if this isn't the right venue for a bug report in the =
iproute2 userland tool.]

(Resending to right address...)

This was originally reported to the glibc folks at =
https://sourceware.org/bugzilla/show_bug.cgi?id=3D30112.

With glibc-2.37, ip -6 route gives invalid output as follows:
```
$ ip route add dev eth0 fd8d:4d6d:3ccb:500:c79:2339:edce:ece1 proto =
static
$ ip -6 route
```

With:
"""
bad output:
fd8d:4d6d:3ccb:500:c79:2339:edc dev eth0 proto static metric 1024 pref =
medium

good output:
fd8d:4d6d:3ccb:500:c79:2339:edce:ece1 dev eth0 proto static metric 1024 =
pref medium
"""

But it looks like iproute's code is suspicious here, as it calls strncpy =
with overlapping
source & destination. It appears to have worked by chance until now.

iproute2 should use a different buffer in the call to format_host_rta_r, =
so that
b1 and hostname stop overlapping.

Thanks to freswa@archlinux.org <mailto:freswa@archlinux.org> for =
reporting this initially on the glibc bug tracker and
finding the reproducer and Doug Freed (dwfreed) after I threw the ASAN =
output at him.

This output is from glibc-2.36, but I got the same w/ glibc-2.37:
```
$ valgrind ip -6 route
=3D=3D122592=3D=3D Memcheck, a memory error detector
=3D=3D122592=3D=3D Copyright (C) 2002-2022, and GNU GPL'd, by Julian =
Seward et al.
=3D=3D122592=3D=3D Using Valgrind-3.20.0 and LibVEX; rerun with -h for =
copyright info
=3D=3D122592=3D=3D Command: ip -6 route
=3D=3D122592=3D=3D
=3D=3D122592=3D=3D Source and destination overlap in =
strncpy(0x1ffefff283, 0x1ffefff283, 63)
=3D=3D122592=3D=3D at 0x48493DA: strncpy (vg_replace_strmem.c:604)
=3D=3D122592=3D=3D by 0x1200EC: strncpy (string_fortified.h:95)
=3D=3D122592=3D=3D by 0x1200EC: print_route (iproute.c:819)
=3D=3D122592=3D=3D by 0x17C3C5: rtnl_dump_filter_l (libnetlink.c:925)
=3D=3D122592=3D=3D by 0x17D8FF: rtnl_dump_filter_errhndlr_nc =
(libnetlink.c:987)
=3D=3D122592=3D=3D by 0x11E3D3: iproute_list_flush_or_save =
(iproute.c:1981)
=3D=3D122592=3D=3D by 0x113C54: do_cmd (ip.c:137)
=3D=3D122592=3D=3D by 0x1136F8: main (ip.c:327)
=3D=3D122592=3D=3D
::1 dev lo proto kernel metric 256 pref medium
[my network bits here]
=3D=3D122592=3D=3D
=3D=3D122592=3D=3D HEAP SUMMARY:
=3D=3D122592=3D=3D in use at exit: 206 bytes in 3 blocks
=3D=3D122592=3D=3D total heap usage: 10 allocs, 7 frees, 165,174 bytes =
allocated
=3D=3D122592=3D=3D
=3D=3D122592=3D=3D LEAK SUMMARY:
=3D=3D122592=3D=3D definitely lost: 0 bytes in 0 blocks
=3D=3D122592=3D=3D indirectly lost: 0 bytes in 0 blocks
=3D=3D122592=3D=3D possibly lost: 0 bytes in 0 blocks
=3D=3D122592=3D=3D still reachable: 206 bytes in 3 blocks
=3D=3D122592=3D=3D suppressed: 0 bytes in 0 blocks
=3D=3D122592=3D=3D Rerun with --leak-check=3Dfull to see details of =
leaked memory
=3D=3D122592=3D=3D
=3D=3D122592=3D=3D For lists of detected and suppressed errors, rerun =
with: -s
=3D=3D122592=3D=3D ERROR SUMMARY: 3 errors from 1 contexts (suppressed: =
0 from 0)
```

And from ASAN:
```
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=3D=3D108934=3D=3DERROR: AddressSanitizer: strncpy-param-overlap: memory =
ranges [0x7f3651200380,0x7f3651200384) and [0x7f3651200380, =
0x7f3651200384) overlap
#0 0x7f36533fe03c in __interceptor_strncpy =
/usr/src/debug/sys-devel/gcc-13.0.1_pre20230212/gcc-13-20230212/libsanitiz=
er/asan/asan_interceptors.cpp:483
#1 0x5616e76ac5b2 in strncpy /usr/include/bits/string_fortified.h:95
#2 0x5616e76ac5b2 in print_route =
/usr/src/debug/sys-apps/iproute2-6.1.0/iproute2-6.1.0/ip/iproute.c:819
#3 0x5616e7784705 in rtnl_dump_filter_l =
/usr/src/debug/sys-apps/iproute2-6.1.0/iproute2-6.1.0/lib/libnetlink.c:925=

#4 0x5616e778a598 in rtnl_dump_filter_errhndlr_nc =
/usr/src/debug/sys-apps/iproute2-6.1.0/iproute2-6.1.0/lib/libnetlink.c:987=

#5 0x5616e76a8e89 in iproute_list_flush_or_save =
/usr/src/debug/sys-apps/iproute2-6.1.0/iproute2-6.1.0/ip/iproute.c:1981
#6 0x5616e76afcca in do_iproute =
/usr/src/debug/sys-apps/iproute2-6.1.0/iproute2-6.1.0/ip/iproute.c:2358
#7 0x5616e768f3bf in do_cmd =
/usr/src/debug/sys-apps/iproute2-6.1.0/iproute2-6.1.0/ip/ip.c:137
#8 0x5616e768d992 in main =
/usr/src/debug/sys-apps/iproute2-6.1.0/iproute2-6.1.0/ip/ip.c:327
#9 0x7f365318274f (/usr/lib64/libc.so.6+0x2374f)
#10 0x7f3653182808 in __libc_start_main (/usr/lib64/libc.so.6+0x23808)
#11 0x5616e768f244 in _start (/usr/bin/ip+0x11244)

Address 0x7f3651200380 is located in stack of thread T0 at offset 896 in =
frame
#0 0x5616e76aa38f in print_route =
/usr/src/debug/sys-apps/iproute2-6.1.0/iproute2-6.1.0/ip/iproute.c:746

This frame has 4 object(s):
[48, 192) 'mxrta' (line 599)
[256, 504) 'tb' (line 750)
[576, 824) 'tb' (line 680)
[896, 960) 'b1' (line 755) <=3D=3D Memory access at offset 896 is inside =
this variable
HINT: this may be a false positive if your program uses some custom =
stack unwind mechanism, swapcontext or vfork
(longjmp and C++ exceptions *are* supported)
Address 0x7f3651200380 is located in stack of thread T0 at offset 896 in =
frame
#0 0x5616e76aa38f in print_route =
/usr/src/debug/sys-apps/iproute2-6.1.0/iproute2-6.1.0/ip/iproute.c:746

This frame has 4 object(s):
[48, 192) 'mxrta' (line 599)
[256, 504) 'tb' (line 750)
[576, 824) 'tb' (line 680)
[896, 960) 'b1' (line 755) <=3D=3D Memory access at offset 896 is inside =
this variable
HINT: this may be a false positive if your program uses some custom =
stack unwind mechanism, swapcontext or vfork
(longjmp and C++ exceptions *are* supported)
SUMMARY: AddressSanitizer: strncpy-param-overlap =
/usr/src/debug/sys-devel/gcc-13.0.1_pre20230212/gcc-13-20230212/libsanitiz=
er/asan/asan_interceptors.cpp:483 in __interceptor_strncpy
=3D=3D108934=3D=3DABORTING
```

best,
sam

--Apple-Mail=_E939B0BA-C694-44F0-8573-E664FE354FF7
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iNUEARYKAH0WIQQlpruI3Zt2TGtVQcJzhAn1IN+RkAUCY+mrA18UgAAAAAAuAChp
c3N1ZXItZnByQG5vdGF0aW9ucy5vcGVucGdwLmZpZnRoaG9yc2VtYW4ubmV0MjVB
NkJCODhERDlCNzY0QzZCNTU0MUMyNzM4NDA5RjUyMERGOTE5MAAKCRBzhAn1IN+R
kC/EAP9HJB22KQjTeAhpIZNIleYoHap6qyXf10lhn0CSHDVexQD/UEEE66W3He5z
OzaCEQ6zLUUHHNizRfYQa/Jmgs8dPwI=
=Noy9
-----END PGP SIGNATURE-----

--Apple-Mail=_E939B0BA-C694-44F0-8573-E664FE354FF7--
