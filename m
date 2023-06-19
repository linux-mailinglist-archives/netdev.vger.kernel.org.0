Return-Path: <netdev+bounces-11995-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1591B735A27
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 16:58:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 46DA61C20A2A
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 14:58:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0736411C93;
	Mon, 19 Jun 2023 14:58:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F098CC8FF
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 14:58:43 +0000 (UTC)
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0274D1AE;
	Mon, 19 Jun 2023 07:58:40 -0700 (PDT)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com
Subject: [PATCH net 00/14] Netfilter/IPVS fixes for net
Date: Mon, 19 Jun 2023 16:57:51 +0200
Message-Id: <20230619145805.303940-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

The following patchset contains Netfilter/IPVS fixes for net:

1) Fix UDP segmentation with IPVS tunneled traffic, from Terin Stock.

2) Fix chain binding transaction logic, add a bound flag to rule
   transactions. Remove incorrect logic in nft_data_hold() and
   nft_data_release().

3) Add a NFT_TRANS_PREPARE_ERROR deactivate state to deal with releasing
   the set/chain as a follow up to 1240eb93f061 ("netfilter: nf_tables:
   incorrect error path handling with NFT_MSG_NEWRULE")

4) Drop map element references from preparation phase instead of
   set destroy path, otherwise bogus EBUSY with transactions such as:

	flush chain ip x y
	delete chain ip x w

   where chain ip x y contains jump/goto from set elements.

5) Pipapo set type does not regard generation mask from the walk
   iteration.

6) Fix reference count underflow in set element reference to
   stateful object.

7) Several patches to tighten the nf_tables API:
   - disallow set element updates of bound anonymous set
   - disallow unbound anonymous set/chain at the end of transaction.
   - disallow updates of anonymous set.
   - disallow timeout configuration for anonymous sets.

8) Fix module reference leak in chain updates.

9) Fix nfnetlink_osf module autoload.

10) Fix deletion of basechain when NFTA_CHAIN_HOOK is specified as
    in iptables-nft.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-23-06-19

This Netfilter batch is larger than usual, I am aware we are fairly late
in the -rc cycle, if you prefer to route them through net-next, please
let me know.

Thanks.

----------------------------------------------------------------

The following changes since commit 0dbcac3a6dbb32c1de53ebebfd28452965e12950:

  Merge tag 'mlx5-fixes-2023-06-16' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux (2023-06-19 10:28:56 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-23-06-19

for you to fetch changes up to 1f30503496da3cfa0917e398c6dbda3cc2d78e79:

  netfilter: nf_tables: Fix for deleting base chains with payload (2023-06-19 16:01:09 +0200)

----------------------------------------------------------------
netfilter pull request 23-06-19

----------------------------------------------------------------
Pablo Neira Ayuso (12):
      netfilter: nf_tables: fix chain binding transaction logic
      netfilter: nf_tables: add NFT_TRANS_PREPARE_ERROR to deal with bound set/chain
      netfilter: nf_tables: drop map element references from preparation phase
      netfilter: nft_set_pipapo: .walk does not deal with generations
      netfilter: nf_tables: fix underflow in object reference counter
      netfilter: nf_tables: disallow element updates of bound anonymous sets
      netfilter: nf_tables: reject unbound anonymous set before commit phase
      netfilter: nf_tables: reject unbound chain set before commit phase
      netfilter: nf_tables: disallow updates of anonymous sets
      netfilter: nf_tables: disallow timeout for anonymous sets
      netfilter: nf_tables: drop module reference after updating chain
      netfilter: nfnetlink_osf: fix module autoload

Phil Sutter (1):
      netfilter: nf_tables: Fix for deleting base chains with payload

Terin Stock (1):
      ipvs: align inner_mac_header for encapsulation

 include/net/netfilter/nf_tables.h |  30 +++-
 net/netfilter/ipvs/ip_vs_xmit.c   |   2 +
 net/netfilter/nf_tables_api.c     | 366 ++++++++++++++++++++++++++++++--------
 net/netfilter/nfnetlink_osf.c     |   1 +
 net/netfilter/nft_immediate.c     |  78 +++++++-
 net/netfilter/nft_set_bitmap.c    |   5 +-
 net/netfilter/nft_set_hash.c      |  23 ++-
 net/netfilter/nft_set_pipapo.c    |  20 ++-
 net/netfilter/nft_set_rbtree.c    |   5 +-
 net/netfilter/xt_osf.c            |   1 -
 10 files changed, 434 insertions(+), 97 deletions(-)

