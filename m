Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79F8B1B357
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 11:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728125AbfEMJ4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 05:56:38 -0400
Received: from mail.us.es ([193.147.175.20]:34078 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727458AbfEMJ4i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 05:56:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 375C14DE723
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 11:56:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 28427DA708
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 11:56:36 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 123EADA717; Mon, 13 May 2019 11:56:36 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EC435DA702;
        Mon, 13 May 2019 11:56:33 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 13 May 2019 11:56:33 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id BA1884265A31;
        Mon, 13 May 2019 11:56:33 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 00/13] Netfilter fixes for net
Date:   Mon, 13 May 2019 11:56:17 +0200
Message-Id: <20190513095630.32443-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following patchset contains Netfilter fixes for net:

1) Postpone chain policy update to drop after transaction is complete,
   from Florian Westphal.

2) Add entry to flowtable after confirmation to fix UDP flows with
   packets going in one single direction.

3) Reference count leak in dst object, from Taehee Yoo.

4) Check for TTL field in flowtable datapath, from Taehee Yoo.

5) Fix h323 conntrack helper due to incorrect boundary check,
   from Jakub Jankowski.

6) Fix incorrect rcu dereference when fetching basechain stats,
   from Florian Westphal.

7) Missing error check when adding new entries to flowtable,
   from Taehee Yoo.

8) Use version field in nfnetlink message to honor the nfgen_family
   field, from Kristian Evensen.

9) Remove incorrect configuration check for CONFIG_NF_CONNTRACK_IPV6,
   from Subash Abhinov Kasiviswanathan.

10) Prevent dying entries from being added to the flowtable,
    from Taehee Yoo.

11) Don't hit WARN_ON() with malformed blob in ebtables with
    trailing data after last rule, reported by syzbot, patch
    from Florian Westphal.

12) Remove NFT_CT_TIMEOUT enumeration, never used in the kernel
    code.

13) Fix incorrect definition for NFT_LOGLEVEL_MAX, from Florian
    Westphal.

This batch comes with a conflict that can be fixed with this patch:

diff --cc include/uapi/linux/netfilter/nf_tables.h
index 7bdb234f3d8c,f0cf7b0f4f35..505393c6e959
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@@ -966,6 -966,8 +966,7 @@@ enum nft_socket_keys 
   * @NFT_CT_DST_IP: conntrack layer 3 protocol destination (IPv4 address)
   * @NFT_CT_SRC_IP6: conntrack layer 3 protocol source (IPv6 address)
   * @NFT_CT_DST_IP6: conntrack layer 3 protocol destination (IPv6 address)
 - * @NFT_CT_TIMEOUT: connection tracking timeout policy assigned to conntrack
+  * @NFT_CT_ID: conntrack id
   */
  enum nft_ct_keys {
  	NFT_CT_STATE,
@@@ -991,6 -993,8 +992,7 @@@
  	NFT_CT_DST_IP,
  	NFT_CT_SRC_IP6,
  	NFT_CT_DST_IP6,
 -	NFT_CT_TIMEOUT,
+ 	NFT_CT_ID,
  	__NFT_CT_MAX
  };
  #define NFT_CT_MAX		(__NFT_CT_MAX - 1)

That replaces the unused NFT_CT_TIMEOUT definition by NFT_CT_ID. If you prefer,
I can also solve this conflict here, just let me know.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks!

----------------------------------------------------------------

The following changes since commit 6c0afef5fb0c27758f4d52b2210c61b6bd8b4470:

  ipv6/flowlabel: wait rcu grace period before put_pid() (2019-04-29 23:30:13 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 92285a079eedfe104a773a7c4293f77a01f456fb:

  netfilter: nf_tables: correct NFT_LOGLEVEL_MAX value (2019-05-12 21:08:04 +0200)

----------------------------------------------------------------
Florian Westphal (4):
      netfilter: nf_tables: delay chain policy update until transaction is complete
      netfilter: nf_tables: fix base chain stat rcu_dereference usage
      netfilter: ebtables: CONFIG_COMPAT: reject trailing data after last rule
      netfilter: nf_tables: correct NFT_LOGLEVEL_MAX value

Jakub Jankowski (1):
      netfilter: nf_conntrack_h323: restore boundary check correctness

Kristian Evensen (1):
      netfilter: ctnetlink: Resolve conntrack L3-protocol flush regression

Pablo Neira Ayuso (2):
      netfilter: nft_flow_offload: add entry to flowtable after confirmation
      netfilter: nf_tables: remove NFT_CT_TIMEOUT

Subash Abhinov Kasiviswanathan (1):
      netfilter: nf_conntrack_h323: Remove deprecated config check

Taehee Yoo (4):
      netfilter: nf_flow_table: fix netdev refcnt leak
      netfilter: nf_flow_table: check ttl value in flow offload data path
      netfilter: nf_flow_table: fix missing error check for rhashtable_insert_fast
      netfilter: nf_flow_table: do not flow offload deleted conntrack entries

 include/uapi/linux/netfilter/nf_tables.h |  4 +--
 net/bridge/netfilter/ebtables.c          |  4 ++-
 net/netfilter/nf_conntrack_h323_asn1.c   |  2 +-
 net/netfilter/nf_conntrack_h323_main.c   | 11 ++----
 net/netfilter/nf_conntrack_netlink.c     |  2 +-
 net/netfilter/nf_flow_table_core.c       | 34 +++++++++++++-----
 net/netfilter/nf_flow_table_ip.c         |  6 ++++
 net/netfilter/nf_tables_api.c            | 59 +++++++++++++++++++++++++-------
 net/netfilter/nft_flow_offload.c         |  4 +--
 9 files changed, 89 insertions(+), 37 deletions(-)

