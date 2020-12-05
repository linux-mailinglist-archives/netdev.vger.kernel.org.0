Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5B42CFF22
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 22:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727375AbgLEVPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 16:15:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbgLEVPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 16:15:42 -0500
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [IPv6:2001:67c:2050::465:103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E7DC061A52
        for <netdev@vger.kernel.org>; Sat,  5 Dec 2020 13:14:43 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4CpMlD2586zQl9C;
        Sat,  5 Dec 2020 22:14:16 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1607202854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/lX/HqKL0be5XlDvicDZmjd6WfUQfGmi2UuDAXU4AD8=;
        b=qiXpJT5TL8opGZTba4TS46uAe9cO+ERxDw3IDb00tHIHBgnsTNuKpc44PXNQm7l9nU8j5U
        zVxK6AuaDPMQnMrPDJ/zltyD1TmWhWMofTIHmL1fG01s6qT0YkZGcv2r2agW5Itx6+7y7/
        DLG8cQOfjYEia7L8g+h1T4syeR3oMRo6Wu5zzvJEAlRyxOTnpGyhsXC9Tq0yw5fLvSkbv6
        Yutl7WxmPL4yT33xpGM5PePkDp06KOiqnwfihOUj3nAf3MAYTpCmMAlkaTh5pPH/i2CDcs
        oVuilYIUstdX3a4R3D1LFaBYfPM92E/Ujo5NFWbBtOtQYIfyna/sZXhf8SKjXA==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter03.heinlein-hosting.de (spamfilter03.heinlein-hosting.de [80.241.56.117]) (amavisd-new, port 10030)
        with ESMTP id jOGPcXkJF4Ws; Sat,  5 Dec 2020 22:14:11 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Po.Liu@nxp.com, toke@toke.dk, dave.taht@gmail.com,
        edumazet@google.com, tahiliani@nitk.edu.in, leon@kernel.org,
        Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next v2 0/7] Move rate and size parsing and output to lib
Date:   Sat,  5 Dec 2020 22:13:28 +0100
Message-Id: <cover.1607201857.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: ***
X-Rspamd-Score: 3.92 / 15.00 / 15.00
X-Rspamd-Queue-Id: 785561718
X-Rspamd-UID: fef2aa
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DCB tool will have commands that deal with buffer sizes and traffic
rates. TC is another tool that has a number of such commands, and functions
to support them: get_size(), get_rate/64(), s/print_size() and
s/print_rate(). In this patchset, these functions are moved from TC to lib/
for possible reuse and modernized.

s/print_rate() has a hidden parameter of a global variable use_iec, which
made the conversion non-trivial. The parameter was made explicit,
print_rate() converted to a mostly json_print-like function, and
sprint_rate() retired in favor of the new print_rate. Patches #1 and #2
deal with this.

The intention was to treat s/print_size() similarly, but unfortunately two
use cases of sprint_size() cannot be converted to a json_print-like
print_size(), and the function sprint_size() had to remain as a discouraged
backdoor to print_size(). This is done in patch #3.

Patch #4 then improves the code of sprint_size() a little bit.

Patch #5 fixes a buglet in formatting small rates in IEC mode.

Patches #6 and #7 handle a routine movement of, respectively,
get_rate/64() and get_size() from tc to lib.

This patchset does not actually add any new uses of these functions. A
follow-up patchset will add subtools for management of DCB buffer and DCB
maxrate objects that will make use of them.

v2:
- Patch #2:
    - Adapt q_mqprio.c patch, the file changed since v1.
- Patch #4:
    - This patch is new. It addresses a request from Stephen Hemminger to
      clean up the sprint_size() function.


Petr Machata (7):
  Move the use_iec declaration to the tools
  lib: Move print_rate() from tc here; modernize
  lib: Move sprint_size() from tc here, add print_size()
  lib: sprint_size(): Uncrustify the code a bit
  lib: print_color_rate(): Fix formatting small rates in IEC mode
  lib: Move get_rate(), get_rate64() from tc here
  lib: Move get_size() from tc here

 include/json_print.h |  14 ++++
 include/utils.h      |   4 +-
 ip/ip_common.h       |   2 +
 lib/json_print.c     |  63 +++++++++++++++
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
 tc/q_mqprio.c        |   6 +-
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

