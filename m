Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34E46420CFA
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 15:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235486AbhJDNKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 09:10:49 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:45343 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234881AbhJDNJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 09:09:06 -0400
Received: from ubuntu.home (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 1AA23200E2A5;
        Mon,  4 Oct 2021 15:07:15 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 1AA23200E2A5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1633352835;
        bh=HifNznjauFK0fX6GIX8XbylBiof8SR/BfGojRjxpX0U=;
        h=From:To:Cc:Subject:Date:From;
        b=GW0UX4sFJSnE3AMLGkAs8B/+lRPo5ZFevgneMPLP3V3L5NFBF7z1n+ynhjkHXkoME
         ZWR2HzpYB9/zFDBFp90iVIpebznV9vn83pQvhr1V+i+IJ/4DOtEDMb6s14CKPBUTgo
         kGH40ton+d8O/vk+IhohlN+oUGU73+nKn1dl8DHssee0qtG7kTaN6JeM4fobRZoovs
         il+V610pxaek/Wgyq6/GzU/ggUtKx9mN7if8Q7gvWeCZEolq5Z4Hk20j94yv3BAldX
         hGK1Qf2IvhgI/7LHd+wUGvlX+FVCDyjI3bSYxRIOkb04mPS7l9BycZClwqcNvIk2z/
         YXtaU4oORIshg==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@kernel.org,
        stephen@networkplumber.org, justin.iurman@uliege.be
Subject: [PATCH iproute2-next 0/2] Support for IOAM encap modes
Date:   Mon,  4 Oct 2021 15:06:49 +0200
Message-Id: <20211004130651.13571-1-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

 include/uapi/linux/ioam6_iptunnel.h |  29 ++++++
 ip/iproute_lwtunnel.c               | 142 ++++++++++++++++++++--------
 man/man8/ip-route.8.in              |  39 ++++++--
 3 files changed, 161 insertions(+), 49 deletions(-)

-- 
2.25.1

