Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8EB84A4831
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 14:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378780AbiAaNdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 08:33:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379086AbiAaNcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 08:32:54 -0500
Received: from forwardcorp1o.mail.yandex.net (forwardcorp1o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3379C061714
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 05:32:53 -0800 (PST)
Received: from sas1-3cba3404b018.qloud-c.yandex.net (sas1-3cba3404b018.qloud-c.yandex.net [IPv6:2a02:6b8:c08:bd26:0:640:3cba:3404])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id 6F9872E0C6A;
        Mon, 31 Jan 2022 16:31:40 +0300 (MSK)
Received: from sas1-9d43635d01d6.qloud-c.yandex.net (sas1-9d43635d01d6.qloud-c.yandex.net [2a02:6b8:c08:793:0:640:9d43:635d])
        by sas1-3cba3404b018.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id 50xm73fQr6-VaGiP9N4;
        Mon, 31 Jan 2022 16:31:40 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1643635900; bh=/QTiU1RXcrb5KfRgFKqKXsNjxtJAMyFB7TOvTGUsdCk=;
        h=Date:Subject:To:From:Message-Id:Cc;
        b=eLj6tEpTScTeJWaxbo0zVoiA7ZeYuvn3xN3RjyD9SpBIx2/lnKLNMjCzWnr5WA0/4
         BejLm7DnhFmnBem2l/t/N5Q50wIrbw8rTH/sKen57DIxWJzrAExAuYg10WmfCEE/oX
         Tt0ncmqHiqPqLeB7qnVBBr7CJ9tGfmgQizZGRfSI=
Authentication-Results: sas1-3cba3404b018.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from vmhmukos.sas.yp-c.yandex.net (vmhmukos.sas.yp-c.yandex.net [2a02:6b8:c10:288:0:696:6af:0])
        by sas1-9d43635d01d6.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id KT3glRaQ9Z-VaIONEH0;
        Mon, 31 Jan 2022 16:31:36 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
From:   Akhmat Karakotov <hmukos@yandex-team.ru>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        eric.dumazet@gmail.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, tom@herbertland.com,
        hmukos@yandex-team.ru, zeil@yandex-team.ru, mitradir@yandex-team.ru
Subject: [PATCH net-next v5 0/5] Make hash rethink configurable
Date:   Mon, 31 Jan 2022 16:31:20 +0300
Message-Id: <20220131133125.32007-1-hmukos@yandex-team.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As it was shown in the report by Alexander Azimov, hash rethink at the
client-side may lead to connection timeout toward stateful anycast
services. Tom Herbert created a patchset to address this issue by applying
hash rethink only after a negative routing event (3RTOs) [1]. This change
also affects server-side behavior, which we found undesirable. This
patchset changes defaults in a way to make them safe: hash rethink at the
client-side is disabled and enabled at the server-side upon each RTO
event or in case of duplicate acknowledgments.

This patchset provides two options to change default behaviour. The hash
rethink may be disabled at the server-side by the new sysctl option.
Changes in the sysctl option don't affect default behavior at the
client-side.

Hash rethink can also be enabled/disabled with socket option or bpf
syscalls which ovewrite both default and sysctl settings. This socket
option is available on both client and server-side. This should provide
mechanics to enable hash rethink inside administrative domain, such as DC,
where hash rethink at the client-side can be desirable.

[1] https://lore.kernel.org/netdev/20210809185314.38187-1-tom@herbertland.com/

v2:
	- Changed sysctl default to ENABLED in all patches. Reduced sysctl
	  and socket option size to u8. Fixed netns bug reported by kernel
	  test robot.

v3:
	- Fixed bug with bad u8 comparison. Moved sk_txrehash to use less
	  bytes in struct. Added WRITE_ONCE() in setsockopt in and
	  READ_ONCE() in tcp_rtx_synack.

v4:
	- Rebase and add documentation for sysctl option.

v5:
	- Move sk_txrehash out of busy poll ifdef.


Akhmat Karakotov (5):
  txhash: Make rethinking txhash behavior configurable via sysctl
  txhash: Add socket option to control TX hash rethink behavior
  txhash: Add txrehash sysctl description
  bpf: Add SO_TXREHASH setsockopt
  tcp: Change SYN ACK retransmit behaviour to account for rehash

 Documentation/admin-guide/sysctl/net.rst |  9 ++++++++
 arch/alpha/include/uapi/asm/socket.h     |  2 ++
 arch/mips/include/uapi/asm/socket.h      |  2 ++
 arch/parisc/include/uapi/asm/socket.h    |  2 ++
 arch/sparc/include/uapi/asm/socket.h     |  2 ++
 include/net/netns/core.h                 |  1 +
 include/net/sock.h                       | 28 +++++++++++++-----------
 include/uapi/asm-generic/socket.h        |  2 ++
 include/uapi/linux/socket.h              |  4 ++++
 net/core/filter.c                        | 10 +++++++++
 net/core/net_namespace.c                 |  2 ++
 net/core/sock.c                          | 14 ++++++++++++
 net/core/sysctl_net_core.c               | 14 ++++++++++--
 net/ipv4/inet_connection_sock.c          |  3 +++
 net/ipv4/tcp_output.c                    |  4 +++-
 15 files changed, 83 insertions(+), 16 deletions(-)

-- 
2.17.1

