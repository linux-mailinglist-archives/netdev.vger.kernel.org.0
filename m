Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1910342037A
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 20:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbhJCSrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 14:47:52 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:39507 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231319AbhJCSrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Oct 2021 14:47:45 -0400
Received: from localhost.localdomain (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 5BBD3200BBAC;
        Sun,  3 Oct 2021 20:45:54 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 5BBD3200BBAC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1633286754;
        bh=g5INV/fNAEH+1O5Nuf+8DD7WnhwQBKz5Ufz1cHB5Flw=;
        h=From:To:Cc:Subject:Date:From;
        b=bNHjiRGtm7vPR3Knr1DKCCNFQhzV+eIfaZnezNOyTUh361zzR+8rWPXADs4i67Kwd
         S69lJH16DSoy6PtjTxvJ7++7+l86KtttEnEHtVqTcL52qoJ8tVetKkGU95h1SXAwFb
         5X9RsVaeSbifyM1F6h/61rX11sdVrJM6lRlVYjCycQsqUq0/6qVZ9Ymw8JQFm82ICg
         VbS/2RvUq3UkM+BNn43nQ7mMDnYFP812i/PeMJwyirYRDNrE1XaA2BTHuWuFHV9QAA
         AhKXRVZtvKjuNoFW/SGLoujgi61row8gBRB8CIGKimQ0Sf1BGZpTncZ6JTm7RN6dmp
         0s9xQUCckvwTw==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, justin.iurman@uliege.be
Subject: [PATCH net-next v2 0/4] Support for the ip6ip6 encapsulation of IOAM
Date:   Sun,  3 Oct 2021 20:45:35 +0200
Message-Id: <20211003184539.23629-1-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2:
 - add prerequisite patches
 - keep uapi backwards compatible by adding two new attributes
 - add more comments to document the ioam6_iptunnel uapi

In the current implementation, IOAM can only be inserted directly (i.e., only
inside packets generated locally) by default, to be compliant with RFC8200.

This patch adds support for in-transit packets and provides the ip6ip6
encapsulation of IOAM (RFC8200 compliant). Therefore, three ioam6 encap modes
are defined:

 - inline: directly inserts IOAM inside packets (by default).

 - encap:  ip6ip6 encapsulation of IOAM inside packets.

 - auto:   either inline mode for packets generated locally or encap mode for
           in-transit packets.

With current iproute2 implementation, it is configured this way:

$ ip -6 r [...] encap ioam6 trace prealloc [...]

The old syntax does not change (for backwards compatibility) and implicitly uses
the inline mode. With the new syntax, an encap mode can be specified:

(inline mode)
$ ip -6 r [...] encap ioam6 mode inline trace prealloc [...]

(encap mode)
$ ip -6 r [...] encap ioam6 mode encap tundst fc00::2 trace prealloc [...]

(auto mode)
$ ip -6 r [...] encap ioam6 mode auto tundst fc00::2 trace prealloc [...]

A tunnel destination address must be configured when using the encap mode or the
auto mode.

Justin Iurman (4):
  ipv6: ioam: Distinguish input and output for hop-limit
  ipv6: ioam: Prerequisite patch for ioam6_iptunnel
  ipv6: ioam: Add support for the ip6ip6 encapsulation
  selftests: net: Test for the IOAM encapsulation with IPv6

 include/net/ioam6.h                  |   3 +-
 include/uapi/linux/ioam6_iptunnel.h  |  29 +++
 net/ipv6/Kconfig                     |   6 +-
 net/ipv6/exthdrs.c                   |   2 +-
 net/ipv6/ioam6.c                     |  11 +-
 net/ipv6/ioam6_iptunnel.c            | 300 ++++++++++++++++++++-------
 tools/testing/selftests/net/ioam6.sh | 209 ++++++++++++++-----
 7 files changed, 422 insertions(+), 138 deletions(-)

-- 
2.25.1

