Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B79AF422BF1
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 17:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbhJEPMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 11:12:40 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:51141 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235075AbhJEPMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 11:12:35 -0400
Received: from localhost.localdomain (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id DA5DB200F498;
        Tue,  5 Oct 2021 17:10:43 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be DA5DB200F498
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1633446644;
        bh=hY865fCCIDdqf0VnY3r1KEDzT40QXuEZRetzxZyb23Y=;
        h=From:To:Cc:Subject:Date:From;
        b=pI1jNGzKG610R7OoUtUKXWB1UHnSfgR07WQAWIOmZyzr5Vtg+Z8Irsn7EHlV1Y2Yp
         Xn1dajMTyk1Cl6GRGBhczgqmso987Bm2aUd6/I9nEXGyXJpVcfHP7fZnLYuO/UCV84
         X3UUhnik1yCQwbqBd7wF7RArCxgK6QR68nbbH7yL8bvPpbgGwC1yHy/ew4Q94Lc9UR
         fOIp1CkWRVcE6YWZfYPB2s7VFQGnMmn5DKAy/AMH7jIoEd4DKy+/U9kqxoz0FlB8L2
         bzVPEUWuvWWXTzVL9LQlq0Qe+9ucQBNSwPB1PdJKY5lytptx5aenNb/hMFsaMhMSyR
         fsgIZrbFa1jAw==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@kernel.org,
        stephen@networkplumber.org, justin.iurman@uliege.be
Subject: [PATCH iproute2-next v2 0/2] Support for IOAM encap modes
Date:   Tue,  5 Oct 2021 17:10:18 +0200
Message-Id: <20211005151020.32533-1-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2:
 - Fix the size of ioam6_mode_types (thanks David Ahern)
 - Remove uapi diff from patch #1 (already merged inside iproute2-next)

Following the series applied to net-next (see [1]), here are the corresponding
changes to iproute2.

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

  [1] https://lore.kernel.org/netdev/163335001045.30570.12527451523558030753.git-patchwork-notify@kernel.org/T/#m3b428d4142ee3a414ec803466c211dfdec6e0c09

Justin Iurman (2):
  Add support for IOAM encap modes
  Update documentation

 ip/iproute_lwtunnel.c  | 142 +++++++++++++++++++++++++++++------------
 man/man8/ip-route.8.in |  39 +++++++++--
 2 files changed, 132 insertions(+), 49 deletions(-)

-- 
2.25.1

