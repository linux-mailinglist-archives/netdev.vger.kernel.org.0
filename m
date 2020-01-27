Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0D8B149FC2
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 09:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728921AbgA0IWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 03:22:07 -0500
Received: from correo.us.es ([193.147.175.20]:36420 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbgA0IWH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 03:22:07 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1D68DB1920
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 09:22:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0CA53DA720
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 09:22:06 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 012ADDA71A; Mon, 27 Jan 2020 09:22:05 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 39E4FDA710;
        Mon, 27 Jan 2020 09:22:02 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 27 Jan 2020 09:22:02 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 17DE942EFB81;
        Mon, 27 Jan 2020 09:22:02 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 0/6] Netfilter updates for net-next
Date:   Mon, 27 Jan 2020 09:20:48 +0100
Message-Id: <20200127082054.318263-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This batch contains Netfilter updates for net-next:

1) Add nft_setelem_parse_key() helper function.

2) Add NFTA_SET_ELEM_KEY_END to specify a range with one single element.

3) Add NFTA_SET_DESC_CONCAT to describe the set element concatenation,
   from Stefano Brivio.

4) Add bitmap_cut() to copy n-bits from source to destination,
   from Stefano Brivio.

5) Add set to match on arbitrary concatenations, from Stefano Brivio.

6) Add selftest for this new set type. An extract of Stefano's
   description follows:

"Existing nftables set implementations allow matching entries with
interval expressions (rbtree), e.g. 192.0.2.1-192.0.2.4, entries
specifying field concatenation (hash, rhash), e.g. 192.0.2.1:22,
but not both.

In other words, none of the set types allows matching on range
expressions for more than one packet field at a time, such as ipset
does with types bitmap:ip,mac, and, to a more limited extent
(netmasks, not arbitrary ranges), with types hash:net,net,
hash:net,port, hash:ip,port,net, and hash:net,port,net.

As a pure hash-based approach is unsuitable for matching on ranges,
and "proxying" the existing red-black tree type looks impractical as
elements would need to be shared and managed across all employed
trees, this new set implementation intends to fill the functionality
gap by employing a relatively novel approach.

The fundamental idea, illustrated in deeper detail in patch 5/9, is to
use lookup tables classifying a small number of grouped bits from each
field, and map the lookup results in a way that yields a verdict for
the full set of specified fields.

The grouping bit aspect is loosely inspired by the Grouper algorithm,
by Jay Ligatti, Josh Kuhn, and Chris Gage (see patch 5/9 for the full
reference).

A reference, stand-alone implementation of the algorithm itself is
available at:
        https://pipapo.lameexcu.se

Some notes about possible future optimisations are also mentioned
there. This algorithm reduces the matching problem to, essentially,
a repetitive sequence of simple bitwise operations, and is
particularly suitable to be optimised by leveraging SIMD instruction
sets."

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thank you.

----------------------------------------------------------------

The following changes since commit 32efcc06d2a15fa87585614d12d6c2308cc2d3f3:

  tcp: export count for rehash attempts (2020-01-26 15:28:47 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to 611973c1e06faef31d034deeb3ae7b7960b1f043:

  selftests: netfilter: Introduce tests for sets with range concatenation (2020-01-27 08:54:30 +0100)

----------------------------------------------------------------
Pablo Neira Ayuso (2):
      netfilter: nf_tables: add nft_setelem_parse_key()
      netfilter: nf_tables: add NFTA_SET_ELEM_KEY_END attribute

Stefano Brivio (4):
      netfilter: nf_tables: Support for sets with multiple ranged fields
      bitmap: Introduce bitmap_cut(): cut bits and shift remaining
      nf_tables: Add set type for arbitrary concatenation of ranges
      selftests: netfilter: Introduce tests for sets with range concatenation

 include/linux/bitmap.h                             |    4 +
 include/net/netfilter/nf_tables.h                  |   22 +-
 include/net/netfilter/nf_tables_core.h             |    1 +
 include/uapi/linux/netfilter/nf_tables.h           |   17 +
 lib/bitmap.c                                       |   66 +
 net/netfilter/Makefile                             |    3 +-
 net/netfilter/nf_tables_api.c                      |  260 ++-
 net/netfilter/nf_tables_set_core.c                 |    2 +
 net/netfilter/nft_dynset.c                         |    2 +-
 net/netfilter/nft_set_pipapo.c                     | 2102 ++++++++++++++++++++
 net/netfilter/nft_set_rbtree.c                     |    3 +
 tools/testing/selftests/netfilter/Makefile         |    3 +-
 .../selftests/netfilter/nft_concat_range.sh        | 1481 ++++++++++++++
 13 files changed, 3896 insertions(+), 70 deletions(-)
 create mode 100644 net/netfilter/nft_set_pipapo.c
 create mode 100755 tools/testing/selftests/netfilter/nft_concat_range.sh
