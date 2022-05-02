Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67E6D516C56
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 10:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383745AbiEBIuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 04:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359517AbiEBIuE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 04:50:04 -0400
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 44BE521800;
        Mon,  2 May 2022 01:46:35 -0700 (PDT)
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 2428kGoX024172;
        Mon, 2 May 2022 10:46:16 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Moshe Kol <moshe.kol@mail.huji.ac.il>,
        Yossi Gilad <yossi.gilad@mail.huji.ac.il>,
        Amit Klein <aksecurity@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        linux-kernel@vger.kernel.org, Willy Tarreau <w@1wt.eu>
Subject: [PATCH v3 net 0/7] insufficient TCP source port randomness
Date:   Mon,  2 May 2022 10:46:07 +0200
Message-Id: <20220502084614.24123-1-w@1wt.eu>
X-Mailer: git-send-email 2.17.5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

In a not-yet published paper, Moshe Kol, Amit Klein, and Yossi Gilad
report being able to accurately identify a client by forcing it to emit
only 40 times more connections than the number of entries in the
table_perturb[] table, which is indexed by hashing the connection tuple.
The current 2^8 setting allows them to perform that attack with only 10k
connections, which is not hard to achieve in a few seconds.

Eric, Amit and I have been working on this for a few weeks now imagining,
testing and eliminating a number of approaches that Amit and his team were
still able to break or that were found to be too risky or too expensive,
and ended up with the simple improvements in this series that resists to
the attack, doesn't degrade the performance, and preserves a reliable port
selection algorithm to avoid connection failures, including the odd/even
port selection preference that allows bind() to always find a port quickly
even under strong connect() stress.

The approach relies on several factors:
  - resalting the hash secret that's used to choose the table_perturb[]
    entry every 10 seconds to eliminate slow attacks and force the
    attacker to forget everything that was learned after this delay.
    This already eliminates most of the problem because if a client
    stays silent for more than 10 seconds there's no link between the
    previous and the next patterns, and 10s isn't yet frequent enough
    to cause too frequent repetition of a same port that may induce a
    connection failure ;

  - adding small random increments to the source port. Previously, a
    random 0 or 1 was added every 16 ports. Now a random 0 to 7 is
    added after each port. This means that with the default 32768-60999
    range, a worst case rollover happens after 1764 connections, and
    an average of 3137. This doesn't stop statistical attacks but
    requires significantly more iterations of the same attack to
    confirm a guess.

  - increasing the table_perturb[] size from 2^8 to 2^16, which Amit
    says will require 2.6 million connections to be attacked with the
    changes above, making it pointless to get a fingerprint that will
    only last 10 seconds. Due to the size, the table was made dynamic.

  - a few minor improvements on the bits used from the hash, to eliminate
    some unfortunate correlations that may possibly have been exploited
    to design future attack models.

These changes were tested under the most extreme conditions, up to
1.1 million connections per second to one and a few targets, showing no
performance regression, and only 2 connection failures within 13 billion,
which is less than 2^-32 and perfectly within usual values.

The series is split into small reviewable changes and was already reviewed
by Amit and Eric.

Regards,
Willy

---
v3:
  - fix field ordering in secure_ipv6_port_ephemeral() so that the
    timeseed is really part of the hashed array. Spotted by Jason.

v2:
  - fixed build issue reported by lkp@intel.com on 32-bit archs due
    to the 64-by-32 divide; it's now correctly 32-by-32 as suggested
    by Eric
  - addressed the IPv6 hash size as well that was overlooked, as
    reported by Jason

---
Eric Dumazet (1):
  tcp: resalt the secret every 10 seconds

Willy Tarreau (6):
  secure_seq: use the 64 bits of the siphash for port offset calculation
  tcp: use different parts of the port_offset for index and offset
  tcp: add small random increments to the source port
  tcp: dynamically allocate the perturb table used by source ports
  tcp: increase source port perturb table to 2^16
  tcp: drop the hash_32() part from the index calculation

 include/net/inet_hashtables.h |  2 +-
 include/net/secure_seq.h      |  4 ++--
 net/core/secure_seq.c         | 16 ++++++++-----
 net/ipv4/inet_hashtables.c    | 42 ++++++++++++++++++++++-------------
 net/ipv6/inet6_hashtables.c   |  4 ++--
 5 files changed, 43 insertions(+), 25 deletions(-)

-- 
2.17.5
