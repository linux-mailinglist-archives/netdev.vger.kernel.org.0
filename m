Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 169C61BBC9A
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 13:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgD1Lkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 07:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726554AbgD1Lkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 07:40:36 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1868C03C1A9
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 04:40:35 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jTObK-0004PN-1N; Tue, 28 Apr 2020 13:40:34 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Subject: [PATCH ipsec-next 0/7] xfrm: remove three more indirect calls from packet path
Date:   Tue, 28 Apr 2020 13:40:21 +0200
Message-Id: <20200428114028.20693-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series removes three more indirect calls from
the state_afinfo struct:

- extract_input (no dependencies on other modules)
- output_finish (same)
- extract_output (has dependency on ipv6 module, but
  that is only needed for pmtu detection, so the indirect
  call cost is not required for each packet).

Note that the 4th patch conflicts with Sabrinas ESP-in-TCP patches
(both change ipv6_stubs).

I will send a rebased v2 once those patches are in.

Florian Westphal (7):
      xfrm: avoid extract_output indirection for ipv4
      xfrm: state: remove extract_input indirection from xfrm_state_afinfo
      xfrm: move xfrm4_extract_header to common helper
      xfrm: expose local_rxpmtu via ipv6_stubs
      xfrm: place xfrm6_local_dontfrag in xfrm.h
      xfrm: remove extract_output indirection from xfrm_state_afinfo
      xfrm: remove output_finish indirection from xfrm_state_afinfo

 include/net/ipv6_stubs.h |   3 ++
 include/net/xfrm.h       |  26 ++++++----
 net/ipv4/xfrm4_input.c   |   5 --
 net/ipv4/xfrm4_output.c  |  63 +----------------------
 net/ipv4/xfrm4_state.c   |  24 ---------
 net/ipv6/af_inet6.c      |   4 ++
 net/ipv6/xfrm6_input.c   |   5 --
 net/ipv6/xfrm6_output.c  |  98 ++---------------------------------
 net/ipv6/xfrm6_state.c   |  26 ----------
 net/xfrm/xfrm_inout.h    |  32 ++++++++++++
 net/xfrm/xfrm_input.c    |  21 ++++----
 net/xfrm/xfrm_output.c   | 129 ++++++++++++++++++++++++++++++++++++++++++++---
 12 files changed, 193 insertions(+), 243 deletions(-)


