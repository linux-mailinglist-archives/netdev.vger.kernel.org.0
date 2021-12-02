Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60C7046687C
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 17:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359173AbhLBQo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 11:44:27 -0500
Received: from forwardcorp1o.mail.yandex.net ([95.108.205.193]:60262 "EHLO
        forwardcorp1o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1359565AbhLBQo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 11:44:26 -0500
Received: from sas1-3cba3404b018.qloud-c.yandex.net (sas1-3cba3404b018.qloud-c.yandex.net [IPv6:2a02:6b8:c08:bd26:0:640:3cba:3404])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id 666602E0A47;
        Thu,  2 Dec 2021 19:41:02 +0300 (MSK)
Received: from sas1-9d43635d01d6.qloud-c.yandex.net (sas1-9d43635d01d6.qloud-c.yandex.net [2a02:6b8:c08:793:0:640:9d43:635d])
        by sas1-3cba3404b018.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id 3OUYIHfCMw-f1LqJsHN;
        Thu, 02 Dec 2021 19:41:02 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1638463262; bh=DknSf8+Q57iLVy5u3KL/AY4KRE4Sk8q7xlsPvBOI8ow=;
        h=References:Date:Subject:To:From:Message-Id:In-Reply-To:Cc;
        b=c3mQp6pLlDUkkZd9QbJxTB11Id5BCyrBpEUcDVs8l6O80XPUyhjA5B3NKReinRUZO
         iE5ZyhkCTy5ikZEMTHSHXHWDsXWkLx+e1AQdpSr+WMfwaupLAFrZI9ok/dAELwR8wN
         jpXfV5kGJst3MqhUoj4sNNbmm4SN9sD+4YmiDA40=
Authentication-Results: sas1-3cba3404b018.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from vmhmukos.sas.yp-c.yandex.net (vmhmukos.sas.yp-c.yandex.net [2a02:6b8:c07:895:0:696:abd4:0])
        by sas1-9d43635d01d6.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id gTxR2E9Wq2-f1PiJfix;
        Thu, 02 Dec 2021 19:41:01 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
From:   Akhmat Karakotov <hmukos@yandex-team.ru>
To:     edumazet@google.com
Cc:     eric.dumazet@gmail.com, mitradir@yandex-team.ru,
        netdev@vger.kernel.org, tom@herbertland.com, zeil@yandex-team.ru,
        hmukos@yandex-team.ru
Subject: [RFC PATCH v2 net-next 0/4] txhash: Make hash rethink configurable
Date:   Thu,  2 Dec 2021 19:40:27 +0300
Message-Id: <20211202164031.18134-1-hmukos@yandex-team.ru>
In-Reply-To: <5c7100d2-8327-1e5d-d04b-3db1bb86227a@gmail.com>
References: <5c7100d2-8327-1e5d-d04b-3db1bb86227a@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>Sorry, your patches did not reach me. Can you resend them, adding
>
>"Eric Dumazet <edumazet@google.com>"  address to make sure I can catch 
>them ?
>
>
>Thanks !

Hi Eric,

Resending patch, as you asked. Hope it reaches you well.

---

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

