Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 611F922878B
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730697AbgGURlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:41:18 -0400
Received: from mail.katalix.com ([3.9.82.81]:53318 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730588AbgGURlG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 13:41:06 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 879E7914BB;
        Tue, 21 Jul 2020 18:32:54 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595352774; bh=vwMbCnt3f/fHhPaWek2bM8rCqWbUUHAHPSn7/02ai7I=;
        h=From:To:Cc:Subject:Date:Message-Id:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20Tom=20Parkin=20<tparkin@katalix.com>|Subject:=20[PA
         TCH=20net-next=2000/29]=20l2tp:=20cleanup=20checkpatch.pl=20warnin
         gs|Date:=20Tue,=2021=20Jul=202020=2018:31:52=20+0100|Message-Id:=2
         0<20200721173221.4681-1-tparkin@katalix.com>;
        b=hf5seBHs8LQLgvV12GP52qiw3inKj/IF3OEQKIJ/X+hZQJckEnd4sVbBZTR7MnaaF
         6k3/iDfBLffk7Z7e5YHO5H9UFO/IzuqMTcfrw8trKCZ24PFCS8aUytbpkLF+CVYwHb
         J0KPd91YqVRBgGSR2c/w8ePUAu6KZqKlM+VSGvcZzwcrX25qg7IwcgFNJ1gIqMoRc4
         KUtY2k17LnO+2egE8c0bzGiQVG4+S5rq09XztW3ftmf9cppynDmLYa86ZEWwPTg5np
         0M8TSTBu2TNbx/7IYQP8mTmj65t9HAcvFy/aNKBJyTZr+7a1KZbGC5enLJkxNoDSQz
         CcZAJawzQLO5w==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     Tom Parkin <tparkin@katalix.com>
Subject: [PATCH net-next 00/29] l2tp: cleanup checkpatch.pl warnings
Date:   Tue, 21 Jul 2020 18:31:52 +0100
Message-Id: <20200721173221.4681-1-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

l2tp hasn't been kept up to date with the static analysis checks offered
by checkpatch.pl.

This patchset makes l2tp checkpatch-clean, with some exceptions as
described below.

The majority of these issues are trivial: for example small whitespace
tweaks, comment style, line breaks and indentation.  The first patches
in the series deal with these.

The more substantive patches fall into two categories:

 * Some rearrangement of code to better deal with CONFIG_IPV6 ifdefs,
   thereby avoiding checkpatch warnings.

 * Removal of BUG_ON in l2tp.  Some uses of BUG_ON offered little or no
   benefit in the current codebase: these have been removed.  Others do
   help to flag an unexpected condition; and these have been replaced
   with a WARN_ON and appropriate recovery code.

The following checkpatch warnings are not addressed:

 * Two line length warnings for lines of 103 and 101 characters.  These
   lines are more readable without a linebreak so I prefer to leave them
   as-is.

 * Two warnings about unbalanced braces around an else statement in
   l2tp_core.c.  These result from conditionally-compiled code providing
   IPv6 support.  In other areas I have resolved similar warnings by
   breaking code out into functions, but in these remaining cases it'd
   be more difficult to do this without significant modifications to the
   code.  For this patchset at least I prefer to not make such invasive
   changes.

 * Two warnings about use of ENOSYS in l2tp_ppp.c.  This error code is
   returned when session-specific ioctl calls are made on a tunnel socket.
   Arguably a different code would be more appropriate; however changing
   this could be seen to be changing the userspace API.  It's unlikely
   that any code is relying on this particular error being returned in
   this scenario, but again, I prefer not to make such a change in this
   patchset.

Tom Parkin (29):
  l2tp: cleanup whitespace around operators
  l2tp: tweak comment style for consistency
  l2tp: add a blank line following declarations
  l2tp: cleanup excessive blank lines
  l2tp: cleanup difficult-to-read line breaks
  l2tp: cleanup wonky alignment of line-broken function calls
  l2tp: cleanup suspect code indent
  l2tp: add identifier name in function pointer prototype
  l2tp: prefer using BIT macro
  l2tp: cleanup comparisons to NULL
  l2tp: cleanup unnecessary braces in if statements
  l2tp: prefer seq_puts for unformatted output
  l2tp: avoid multiple assignments
  l2tp: line-break long function prototypes
  l2tp: comment per net spinlock instances
  l2tp: fix up incorrect comment in l2tp_recv_common
  l2tp: avoid precidence issues in L2TP_SKB_CB macro
  l2tp: WARN_ON rather than BUG_ON in l2tp_debugfs.c
  l2tp: use a function to render tunnel address in l2tp_debugfs
  l2tp: cleanup netlink send of tunnel address information
  l2tp: cleanup netlink tunnel create address handling
  l2tp: cleanup kzalloc calls
  l2tp: remove BUG_ON in l2tp_session_queue_purge
  l2tp: remove BUG_ON in l2tp_tunnel_closeall
  l2tp: don't BUG_ON session magic checks in l2tp_ppp
  l2tp: don't BUG_ON seqfile checks in l2tp_ppp
  l2tp: WARN_ON rather than BUG_ON in l2tp_session_queue_purge
  l2tp: remove BUG_ON refcount value in l2tp_session_free
  l2tp: WARN_ON rather than BUG_ON in l2tp_session_free

 net/l2tp/l2tp_core.c    | 123 +++++++++----------
 net/l2tp/l2tp_core.h    |  82 ++++++-------
 net/l2tp/l2tp_debugfs.c |  66 ++++++-----
 net/l2tp/l2tp_eth.c     |  19 ++-
 net/l2tp/l2tp_ip.c      |  31 +++--
 net/l2tp/l2tp_ip6.c     |  37 +++---
 net/l2tp/l2tp_netlink.c | 257 +++++++++++++++++++++-------------------
 net/l2tp/l2tp_ppp.c     |  97 ++++++++-------
 8 files changed, 362 insertions(+), 350 deletions(-)

-- 
2.17.1

