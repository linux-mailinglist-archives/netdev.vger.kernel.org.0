Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15EB42C91E8
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 00:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730239AbgK3XCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 18:02:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgK3XCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 18:02:53 -0500
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F6D8C0613D3
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 15:02:13 -0800 (PST)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4ClLMZ4kDmzQlMq;
        Tue,  1 Dec 2020 00:01:46 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1606777304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=JoYbq9prnkAJmDlVLysF1HPxDUrHXc/9E4Q5kfCvEfE=;
        b=EtUPxAzhF/8UGgcGanbEdwfyH/p6BoHDomaBeHQpjgkYbJEJl2CNLYeLnl/SxPQhBYIvGD
        Jgxdyh1bFObUxIhSVf30iWuC9eHRuRsxxfVi9Fg6QOJOY4SjWGdxE6OofEgsSFjmK7yD4R
        9mRxXZQYmnplj5o1vtx/0qQuSqHyDYMjWPu1Vg1qKnq8joACsXtKWoeCXyaGXFan9GertM
        VwHPAc0AUD4f2mJfRY/mvd5IC139QW1Xf7dc2RSgn1jS6pDzetxDxOKEC7OQwQI93U1y4q
        CXPwRDyUTt2rIPV01YwCJ1Sh9z32LCD7opkKNkOjXnkSozDvAAyrzBZZYhCtuA==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id 1pDWeFvp4QvO; Tue,  1 Dec 2020 00:01:42 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Po.Liu@nxp.com, toke@toke.dk, dave.taht@gmail.com,
        edumazet@google.com, tahiliani@nitk.edu.in, vtlam@google.com,
        leon@kernel.org, Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 0/6] Move rate and size parsing and output to lib
Date:   Mon, 30 Nov 2020 23:59:36 +0100
Message-Id: <cover.1606774951.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: ****
X-Rspamd-Score: 5.89 / 15.00 / 15.00
X-Rspamd-Queue-Id: 868CC1825
X-Rspamd-UID: 0e84b7
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DCB tool will have commands that deal with buffers sizes and traffic
rates. TC is another tool that has a number of such commands, and functions
to support them: get_size(), get_rate/64(), s/print_size() and
s/print_rate(). In this patchset, these functions are moved to lib/ for
possible reuse.

s/print_rate() has a hidden parameter of a global variable use_iec, which
made the conversion non-trivial. The parameter was made explicit,
print_rate() converted to a mostly json_print-like function, and
sprint_rate() retired in favor of the new print_rate. Patches #1 and #2
deal with this.

The intention was to treat s/print_size() similarly, but unfortunately two
use cases of sprint_size() cannot be converted to a json_print-like
print_size(), and the function sprint_size() had to remain as a discouraged
backdoor to print_size(). This is done in patch #3.

Patches #4 and #5 handle a routine movement of, respectively,
get_rate/64() and get_size() from tc to lib.

Patch #6 fixes a buglet in formatting small rates in IEC mode.

This patchset does not actually add any new uses of these functions. A
follow-up patchset will add subtools for management of DCB buffer and DCB
maxrate objects that will make use of them.

Petr Machata (6):
  Move the use_iec declaration to the tools
  lib: Move print_rate() from tc here; modernize
  lib: Move sprint_size() from tc here, add print_size()
  lib: Move get_rate(), get_rate64() from tc here
  lib: Move get_size() from tc here
  lib: print_rate(): Fix formatting small rates in IEC mode

 include/json_print.h |  14 ++++
 include/utils.h      |   4 +-
 ip/ip_common.h       |   2 +
 lib/json_print.c     |  61 +++++++++++++++
 lib/utils.c          | 114 +++++++++++++++++++++++++++
 tc/m_gate.c          |   6 +-
 tc/m_police.c        |  14 ++--
 tc/q_cake.c          |  44 +++++------
 tc/q_cbq.c           |  14 +---
 tc/q_drr.c           |  10 +--
 tc/q_fifo.c          |  10 +--
 tc/q_fq.c            |  34 +++-----
 tc/q_fq_codel.c      |   5 +-
 tc/q_fq_pie.c        |   9 +--
 tc/q_gred.c          |  39 ++--------
 tc/q_hfsc.c          |   4 +-
 tc/q_hhf.c           |   9 +--
 tc/q_htb.c           |  23 +++---
 tc/q_mqprio.c        |   8 +-
 tc/q_netem.c         |   4 +-
 tc/q_red.c           |  13 +---
 tc/q_sfq.c           |  15 +---
 tc/q_tbf.c           |  32 +++-----
 tc/tc_common.h       |   1 +
 tc/tc_util.c         | 180 +++----------------------------------------
 tc/tc_util.h         |   8 +-
 26 files changed, 307 insertions(+), 370 deletions(-)

-- 
2.25.1

