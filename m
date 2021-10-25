Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2F443A4CD
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 22:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbhJYUkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 16:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbhJYUkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 16:40:01 -0400
X-Greylist: delayed 94 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 25 Oct 2021 13:37:38 PDT
Received: from forwardcorp1o.mail.yandex.net (forwardcorp1o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F182C061745
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 13:37:38 -0700 (PDT)
Received: from sas1-3cba3404b018.qloud-c.yandex.net (sas1-3cba3404b018.qloud-c.yandex.net [IPv6:2a02:6b8:c08:bd26:0:640:3cba:3404])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id 06A8E2E0A0D;
        Mon, 25 Oct 2021 23:36:00 +0300 (MSK)
Received: from sas1-db2fca0e44c8.qloud-c.yandex.net (2a02:6b8:c14:6696:0:640:db2f:ca0e [2a02:6b8:c14:6696:0:640:db2f:ca0e])
        by sas1-3cba3404b018.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id ZsF3DNCFlW-Zxu4lE7a;
        Mon, 25 Oct 2021 23:35:59 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1635194159; bh=8zYiBK9WEp1aLwVdPRmZCGTqQJrGoiCc1JS3dwEQLDk=;
        h=Date:Subject:To:From:Message-Id:Cc;
        b=g5SE7AoOqnOjd5Mx2hnpRRr+EdgkKsdvIyNKLk16PtIl88afInU6vAOfiMpcxhrI5
         sRtlhXtkFMyQ8/+b7MYcXZOyrBlSUO4mdKmp96JKPavpx2mZ02EtUbXwc7/WHWAB3o
         5t6MmVzfZULDHHAGaqgL8w5GuCE0gg8JidMNWNyo=
Authentication-Results: sas1-3cba3404b018.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from vmhmukos.sas.yp-c.yandex.net (2a02:6b8:c07:895:0:696:abd4:0 [2a02:6b8:c07:895:0:696:abd4:0])
        by sas1-db2fca0e44c8.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPS id mklMLk28bQ-Zx0aJgFq;
        Mon, 25 Oct 2021 23:35:59 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
From:   Akhmat Karakotov <hmukos@yandex-team.ru>
To:     netdev@vger.kernel.org
Cc:     eric.dumazet@gmail.com, tom@herbertland.com,
        mitradir@yandex-team.ru, zeil@yandex-team.ru, hmukos@yandex-team.ru
Subject: [RFC PATCH net-next 0/4] txhash: Make hash rethink configurable
Date:   Mon, 25 Oct 2021 23:35:17 +0300
Message-Id: <20211025203521.13507-1-hmukos@yandex-team.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As it was shown in the report by Alexander Azimov, hash rethink at the client-side may lead to connection timeout toward stateful anycast services. Tom Herbert created a patchset to address this issue by applying hash rethink only after a negative routing event (3RTOs) [1]. This change also affects server-side behavior, which we found undesirable. This patchset changes defaults in a way to make them safe: hash rethink at the client-side is disabled and enabled at the server-side upon each RTO event or in case of duplicate acknowledgments.
This patchset provides two options to change default behaviour. The hash rethink may be disabled at the server-side by the new sysctl option. Changes in the sysctl option don't affect default behavior at the client-side.
Hash rethink can also be enabled/disabled with socket option or bpf syscalls which ovewrite both default and sysctl settings. This socket option is available on both client and server-side. This should provide mechanics to enable hash rethink inside administrative domain, such as DC, where hash rethink at the client-side can be desirable.

[1] https://lore.kernel.org/netdev/20210809185314.38187-1-tom@herbertland.com/

Akhmat Karakotov (4):
  txhash: Make rethinking txhash behavior configurable via sysctl
  txhash: Add socket option to control TX hash rethink behavior
  bpf: Add SO_TXREHASH setsockopt
  tcp: change SYN ACK retransmit behaviour to account for rehash

 arch/alpha/include/uapi/asm/socket.h  |  2 ++
 arch/mips/include/uapi/asm/socket.h   |  2 ++
 arch/parisc/include/uapi/asm/socket.h |  2 ++
 arch/sparc/include/uapi/asm/socket.h  |  2 ++
 include/net/netns/core.h              |  2 ++
 include/net/sock.h                    | 28 ++++++++++++++-------------
 include/uapi/asm-generic/socket.h     |  2 ++
 include/uapi/linux/socket.h           |  4 ++++
 net/core/filter.c                     | 10 ++++++++++
 net/core/net_namespace.c              |  3 +++
 net/core/sock.c                       | 13 +++++++++++++
 net/core/sysctl_net_core.c            |  7 +++++++
 net/ipv4/inet_connection_sock.c       |  3 +++
 net/ipv4/tcp_output.c                 |  3 ++-
 14 files changed, 69 insertions(+), 14 deletions(-)

-- 
2.17.1

