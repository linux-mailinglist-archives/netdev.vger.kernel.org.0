Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0636C1C3400
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 10:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbgEDIGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 04:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726750AbgEDIGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 04:06:22 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB536C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 01:06:21 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jVW7H-00065O-BP; Mon, 04 May 2020 10:06:19 +0200
From:   Florian Westphal <fw@strlen.de>
To:     steffen.klassert@secunet.com
Cc:     <netdev@vger.kernel.org>
Subject: [PATCH ipsec-next v2 0/7] xfrm: remove three more indirect calls from packet path
Date:   Mon,  4 May 2020 10:06:02 +0200
Message-Id: <20200504080609.14648-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2: rebase on top of ipsec-next, no other changes.

This patch series removes three more indirect calls from the state_afinfo
struct.

These are:
- extract_input (no dependencies on other modules)
- output_finish (same)
- extract_output (has dependency on ipv6 module, but
  that is only needed for pmtu detection, so the indirect
  call cost is not required for each packet).

Functions get moved to net/xfrm and the indirections are removed.
pmtu detection will be handled via ipv6_stubs.

Florian Westphal (7):
      xfrm: avoid extract_output indirection for ipv4
      xfrm: state: remove extract_input indirection from xfrm_state_afinfo
      xfrm: move xfrm4_extract_header to common helper
      xfrm: expose local_rxpmtu via ipv6_stubs
      xfrm: place xfrm6_local_dontfrag in xfrm.h
      xfrm: remove extract_output indirection from xfrm_state_afinfo
      xfrm: remove output_finish indirection from xfrm_state_afinfo

 include/net/ipv6_stubs.h |   1 +
 include/net/xfrm.h       |  26 ++++++----
 net/ipv4/xfrm4_input.c   |   5 --
 net/ipv4/xfrm4_output.c  |  63 +----------------------
 net/ipv4/xfrm4_state.c   |  24 ---------
 net/ipv6/af_inet6.c      |   1 +
 net/ipv6/xfrm6_input.c   |   5 --
 net/ipv6/xfrm6_output.c  |  98 ++---------------------------------
 net/ipv6/xfrm6_state.c   |  26 ----------
 net/xfrm/xfrm_inout.h    |  32 ++++++++++++
 net/xfrm/xfrm_input.c    |  21 ++++----
 net/xfrm/xfrm_output.c   | 129 ++++++++++++++++++++++++++++++++++++++++++++---
 12 files changed, 188 insertions(+), 243 deletions(-)

