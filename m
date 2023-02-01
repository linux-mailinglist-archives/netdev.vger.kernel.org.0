Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17CF9686DF1
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 19:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbjBASax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 13:30:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbjBASaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 13:30:52 -0500
X-Greylist: delayed 424 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 01 Feb 2023 10:30:43 PST
Received: from ms11p00im-qufo17291901.me.com (ms11p00im-qufo17291901.me.com [17.58.38.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 519E37F6A1
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 10:30:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1675275818;
        bh=61bB8txn8pVEN9RkIQW0FGkMPIouSxnXNYo9QxWnrjQ=;
        h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:To;
        b=e8fHH62e49rx51BqlaGdrFJY3usOLWTs5A2jyrUmz7myrXVszUxQAjdkx0yUeeoun
         gHL7S1gfo3rbu7ZgLfFZw29Ztab8XI3wU1NwZZgpgOq2pW00JgZyqKI2NcTGB+hGT7
         CT4Itraaav7f7idD/YJoPoGtQo8lyAxclT3PUTZlY8GeDG1YSQKBjIS64K/6jFE1XP
         Yx8HE5GA4vkNpzvtsktPIKJNCGmz8+SGZDWre06H6tDrPkrZCYMymlHlPevd64BRJk
         4+dxolFueXhrL1TLuSGslKHDy0aBQ0QzXh0NPbAr0SPsodyqLZR/KsMwN4duSfbZUy
         Rtqez6M5/lzFw==
Received: from smtpclient.apple (ms11p00im-dlb-asmtpmailmevip.me.com [17.57.154.19])
        by ms11p00im-qufo17291901.me.com (Postfix) with ESMTPSA id 6CC5DBC09B6;
        Wed,  1 Feb 2023 18:23:37 +0000 (UTC)
From:   Christoph Paasch <christophpaasch@icloud.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.161\))
Subject: WARNING in sk_stream_kill_queues due to inet6_destroy_sock()-changes
Message-Id: <39725AB4-88F1-41B3-B07F-949C5CAEFF4F@icloud.com>
Date:   Wed, 1 Feb 2023 10:22:42 -0800
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Matthieu Baerts <notifications@github.com>,
        netdev <netdev@vger.kernel.org>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
X-Mailer: Apple Mail (2.3731.500.161)
X-Proofpoint-ORIG-GUID: 9-Usv4rqi_Ghdj590i9PlIex2bPm-erO
X-Proofpoint-GUID: 9-Usv4rqi_Ghdj590i9PlIex2bPm-erO
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.138,18.0.572,17.0.605.474.0000000_definitions?=
 =?UTF-8?Q?=3D2020-02-14=5F11:2020-02-14=5F02,2020-02-14=5F11,2020-01-23?=
 =?UTF-8?Q?=5F02_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 adultscore=0 mlxlogscore=843 clxscore=1011 suspectscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2302010158
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I am running a syzkaller instance and hit an issue where =
sk_forward_alloc is not 0 in sk_stream_kill_queues().

I bisected this issue down to the set of changes from the "inet6: Remove =
inet6_destroy_sock() calls=E2=80=9D-series (see below for the commit =
hashes).

The reproducer is:
Reproducer:
# {Threaded:false Repeat:false RepeatTimes:0 Procs:1 Slowdown:1 Sandbox: =
SandboxArg:0 Leak:false NetInjection:false NetDevices:false =
NetReset:false Cgroups:false BinfmtMisc:false CloseFDs:false KCSAN:false =
DevlinkPCI:false NicVF:false USB:false VhciInjection:false Wifi:false =
IEEE802154:false Sysctl:false UseTmpDir:false HandleSegv:false =
Repro:false Trace:false LegacyOptions:{Collide:false Fault:false =
FaultCall:0 FaultNth:0}}
r0 =3D socket$inet6_tcp(0xa, 0x1, 0x0)
bind$inet6(r0, &(0x7f00000002c0)=3D{0xa, 0x4e22, 0x0, @loopback}, 0x1c)
setsockopt$inet6_IPV6_HOPOPTS(r0, 0x29, 0x36, &(0x7f0000000080), 0x8)
setsockopt$inet6_int(r0, 0x29, 0x35, &(0x7f0000000040)=3D0x8, 0x4)
sendmsg$inet6(r0, &(0x7f00000003c0)=3D{&(0x7f0000000000)=3D{0xa, 0x4e22, =
0x0, @loopback}, 0x1c, 0x0}, 0x200880c0)

What ends up happening is that np->pktoptions is not emptied thus the =
skb=E2=80=99s that have been added there are still accounted in =
sk_forward_alloc.


I=E2=80=99m not sure what would be the best way to fix this, besides a =
plain revert of this patchset as sk_stream_kill_queues() does rely on =
the things to have been free=E2=80=99d.


More information on the syzkaller issue can be found at =
https://github.com/multipath-tcp/mptcp_net-next/issues/341.


Cheers,
Christoph


b45a337f061e ("inet6: Clean up failure path in do_ipv6_setsockopt().")  =
(3 months ago) <Kuniyuki Iwashima>
1f8c4eeb9455 ("inet6: Remove inet6_destroy_sock().")  (3 months ago) =
<Kuniyuki Iwashima>
6431b0f6ff16 ("sctp: Call inet6_destroy_sock() via sk->sk_destruct().")  =
(3 months ago) <Kuniyuki Iwashima>
1651951ebea5 ("dccp: Call inet6_destroy_sock() via sk->sk_destruct().")  =
(3 months ago) <Kuniyuki Iwashima>
b5fc29233d28 ("inet6: Remove inet6_destroy_sock() in =
sk->sk_prot->destroy().")  (3 months ago) <Kuniyuki Iwashima>=
