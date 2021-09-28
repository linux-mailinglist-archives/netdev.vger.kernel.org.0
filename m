Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69AA141B6DC
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 21:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242341AbhI1TFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 15:05:32 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:36822 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242311AbhI1TFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 15:05:30 -0400
Received: from localhost.localdomain (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 21D50200CD1C;
        Tue, 28 Sep 2021 21:03:49 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 21D50200CD1C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1632855829;
        bh=nNdJDHzJ11HHTRWmkfElBVdgHrXfcBTP98tev6aCnQE=;
        h=From:To:Cc:Subject:Date:From;
        b=U5zWehLU2xe93xb9HcH+u8zAfg5UUealjA7rT+mm/UgugjvhQ3H8FE6V4MP1tsEcX
         hVzUTM9srJ7Dwf7bo5/NXQ3FvoH6/R3Jlynjiam/1AY7cQ6AeADdwMybFHnVZJi8Uj
         cgHHsHj3fmk1C7Kax08WfHFgBYA8u1/EmxxYK8dgGO897XlJprQhz3Ny65bOzn+Qz6
         /btJ514WlZUd/MqqGU+bXlZ8LZi9lbLpoZ324Pzn++eNDhpU/sNZqC8BkmVR7SetKv
         pnbt0Z2hiuGqeM3EyLfeW/79b/qRybpWS9UxWYLQs7QRu1LpZcrL07agrt2SA4plw0
         GETamBnJSDEmQ==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, justin.iurman@uliege.be
Subject: [PATCH net-next 0/2] Support for the ip6ip6 encapsulation of IOAM
Date:   Tue, 28 Sep 2021 21:03:26 +0200
Message-Id: <20210928190328.24097-1-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the current implementation, IOAM can only be inserted directly (i.e., only
inside packets generated locally) by default, to be compliant with RFC8200.

This patch adds support for in-transit packets and provides the ip6ip6
encapsulation of IOAM. Therefore, three explicit encap modes are defined:

 - inline: directly inserts IOAM inside packets.

 - encap:  ip6ip6 encapsulation of IOAM inside packets.

 - auto:   either inline mode for packets generated locally or encap mode for
           in-transit packets.

With current iproute2 implementation, it is configured this way:

$ ip -6 r [...] encap ioam6 trace prealloc type 0x800000 ns 1 size 12 [...]

Now, an encap mode must be specified:

(inline mode)
$ [...] encap ioam6 mode inline trace prealloc [...]

(encap mode)
$ [...] encap ioam6 mode encap tundst fc00::2 trace prealloc [...]

(auto mode)
$ [...] encap ioam6 mode auto tundst fc00::2 trace prealloc [...]

A tunnel destination address must be configured when using the encap mode or the
auto mode.

Justin Iurman (2):
  ipv6: ioam: Add support for the ip6ip6 encapsulation
  selftests: net: Test for the IOAM encapsulation with IPv6

 include/net/ioam6.h                  |   3 +-
 include/uapi/linux/ioam6_iptunnel.h  |  19 +-
 net/ipv6/Kconfig                     |   6 +-
 net/ipv6/exthdrs.c                   |   2 +-
 net/ipv6/ioam6.c                     |  11 +-
 net/ipv6/ioam6_iptunnel.c            | 299 ++++++++++++++++++++-------
 tools/testing/selftests/net/ioam6.sh | 209 ++++++++++++++-----
 7 files changed, 409 insertions(+), 140 deletions(-)

-- 
2.25.1

