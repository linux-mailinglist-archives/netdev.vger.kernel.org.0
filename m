Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1144D13170
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 17:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728135AbfECPuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 11:50:24 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:51966 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727228AbfECPuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 11:50:24 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hMaS6-0004Vy-MV; Fri, 03 May 2019 17:50:22 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     steffen.klassert@secunet.com
Subject: [PATCH ipsec-next 0/6] xfrm: reduce xfrm_state_afinfo size
Date:   Fri,  3 May 2019 17:46:13 +0200
Message-Id: <20190503154619.32352-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xfrm_state_afinfo is a very large struct; its over 4kbyte on 64bit systems.

The size comes from two arrays to store the l4 protocol type pointers
(esp, ah, ipcomp and so on).

There are only a handful of those, so just use pointers for protocols
that we implement instead of mostly-empty arrays.

This also removes the template init/sort related indirections.
Structure size goes down to 120 bytes on x86_64.

 include/net/xfrm.h      |   49 ++---
 net/ipv4/ah4.c          |    3 
 net/ipv4/esp4.c         |    3 
 net/ipv4/esp4_offload.c |    4 
 net/ipv4/ipcomp.c       |    3 
 net/ipv4/xfrm4_state.c  |   45 -----
 net/ipv4/xfrm4_tunnel.c |    3 
 net/ipv6/ah6.c          |    4 
 net/ipv6/esp6.c         |    3 
 net/ipv6/esp6_offload.c |    4 
 net/ipv6/ipcomp6.c      |    3 
 net/ipv6/mip6.c         |    6 
 net/ipv6/xfrm6_state.c  |  137 ----------------
 net/xfrm/xfrm_input.c   |   24 +-
 net/xfrm/xfrm_policy.c  |    2 
 net/xfrm/xfrm_state.c   |  400 +++++++++++++++++++++++++++++++++++-------------
 16 files changed, 343 insertions(+), 350 deletions(-)

Florian Westphal (6):
      xfrm: remove init_tempsel indirection from xfrm_state_afinfo
      xfrm: remove init_temprop indirection from xfrm_state_afinfo
      xfrm: remove init_flags indirection from xfrm_state_afinfo
      xfrm: remove state and template sort indirections from xfrm_state_afinfo
      xfrm: remove eth_proto value from xfrm_state_afinfo
      xfrm: remove type and offload_type map from xfrm_state_afinfo


