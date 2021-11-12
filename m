Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E27044EC88
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 19:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235578AbhKLSWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 13:22:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235552AbhKLSWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 13:22:49 -0500
Received: from forwardcorp1o.mail.yandex.net (forwardcorp1o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A98C061766
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 10:19:57 -0800 (PST)
Received: from sas1-4cbebe29391b.qloud-c.yandex.net (sas1-4cbebe29391b.qloud-c.yandex.net [IPv6:2a02:6b8:c08:789:0:640:4cbe:be29])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id 24E722E0AF8;
        Fri, 12 Nov 2021 21:19:54 +0300 (MSK)
Received: from sas1-7470331623bb.qloud-c.yandex.net (sas1-7470331623bb.qloud-c.yandex.net [2a02:6b8:c08:bd1e:0:640:7470:3316])
        by sas1-4cbebe29391b.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id 3l2jLeXzPL-JpsWuRV6;
        Fri, 12 Nov 2021 21:19:54 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1636741194; bh=vdLH+/aot9224MhSr/EbBx7Y+DB+nESGMCdUeQ4akDY=;
        h=References:Date:Subject:To:From:Message-Id:In-Reply-To:Cc;
        b=jAyO52PzTPunsW+64Vu8/E2glvthvHI6U18640ES3MuAelfguAxKG+o/A6MiwzRKX
         cXmhU2Q5f1bbCj0i4rmpNOJQZhMDKlYTZPuhYPyWqR2Bo81BAmyvFdDXb3fFoAnXg5
         MBIhvFGi/BbWtmmj2+Sdo7SLZzCnLgtokNIzvgik=
Authentication-Results: sas1-4cbebe29391b.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from vmhmukos.sas.yp-c.yandex.net (vmhmukos.sas.yp-c.yandex.net [2a02:6b8:c07:895:0:696:abd4:0])
        by sas1-7470331623bb.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPS id vuM7zSALw5-JpxqtPD1;
        Fri, 12 Nov 2021 21:19:51 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
From:   Akhmat Karakotov <hmukos@yandex-team.ru>
To:     hmukos@yandex-team.ru
Cc:     eric.dumazet@gmail.com, mitradir@yandex-team.ru,
        netdev@vger.kernel.org, tom@herbertland.com, zeil@yandex-team.ru
Subject: [RFC PATCH v2 net-next 0/4] txhash: Make hash rethink configurable
Date:   Fri, 12 Nov 2021 21:19:35 +0300
Message-Id: <20211112181939.11329-1-hmukos@yandex-team.ru>
In-Reply-To: <20211025203521.13507-1-hmukos@yandex-team.ru>
References: <20211025203521.13507-1-hmukos@yandex-team.ru>
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

Akhmat Karakotov (4):
  txhash: Make rethinking txhash behavior configurable via sysctl
  txhash: Add socket option to control TX hash rethink behavior
  bpf: Add SO_TXREHASH setsockopt
  tcp: change SYN ACK retransmit behaviour to account for rehash

 arch/alpha/include/uapi/asm/socket.h  |  2 ++
 arch/mips/include/uapi/asm/socket.h   |  2 ++
 arch/parisc/include/uapi/asm/socket.h |  2 ++
 arch/sparc/include/uapi/asm/socket.h  |  2 ++
 include/net/netns/core.h              |  1 +
 include/net/sock.h                    | 28 ++++++++++++++-------------
 include/uapi/asm-generic/socket.h     |  2 ++
 include/uapi/linux/socket.h           |  4 ++++
 net/core/filter.c                     | 10 ++++++++++
 net/core/net_namespace.c              |  2 ++
 net/core/sock.c                       | 13 +++++++++++++
 net/core/sysctl_net_core.c            | 15 ++++++++++++--
 net/ipv4/inet_connection_sock.c       |  3 +++
 net/ipv4/tcp_output.c                 |  3 ++-
 14 files changed, 73 insertions(+), 16 deletions(-)

-- 
2.17.1

