Return-Path: <netdev+bounces-11835-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 91F6B734C26
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 09:15:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B8433280FC8
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 07:15:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E04633C35;
	Mon, 19 Jun 2023 07:15:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07752585
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 07:15:22 +0000 (UTC)
Received: from mail.avm.de (mail.avm.de [212.42.244.119])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3EE3E4
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 00:15:20 -0700 (PDT)
Received: from mail-auth.avm.de (unknown [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Mon, 19 Jun 2023 09:15:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1687158917; bh=Cc6aq6UkSRKV+ra7kxJ+VoLT96oDvWLxQyxgW379yRU=;
	h=From:To:Cc:Subject:Date:From;
	b=p6w8NYnrrEAatGjxR3Bgy7VBFbOMPgz7JWeUfMVIMN43oqZOyBu28KQC5h5Csr+M6
	 w3b3ySJgOz21lgFRT4yFsjp8YTTaqTJ+Uq99GLpXfrULPF1GHM1+voH6rOiQec2pvy
	 0X/7ANm4dzXyerXjXfZDDTeLy6suA6oem1OWX8W0=
Received: from u-jnixdorf.avm.de (unknown [172.17.88.63])
	by mail-auth.avm.de (Postfix) with ESMTPA id 03CE781ECE;
	Mon, 19 Jun 2023 09:15:16 +0200 (CEST)
From: Johannes Nixdorf <jnixdorf-oss@avm.de>
To: bridge@lists.linux-foundation.org
Cc: netdev@vger.kernel.org,
	David Ahern <dsahern@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Oleksij Rempel <linux@rempel-privat.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Roopa Prabhu <roopa@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Johannes Nixdorf <jnixdorf-oss@avm.de>
Subject: [PATCH net-next v2 0/3, iproute2-next 0/1] bridge: Add a limit on learned FDB entries
Date: Mon, 19 Jun 2023 09:14:40 +0200
Message-Id: <20230619071444.14625-1-jnixdorf-oss@avm.de>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-purgate-ID: 149429::1687158916-235E63F9-07484256/0/0
X-purgate-type: clean
X-purgate-size: 2743
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate: clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Introduce a limit on the amount of learned FDB entries on a bridge,
configured by netlink with a build time default on bridge creation in
the kernel config.

For backwards compatibility the kernel config default is disabling the
limit (0).

Without any limit a malicious actor may OOM a kernel by spamming packets
with changing MAC addresses on their bridge port, so allow the bridge
creator to limit the number of entries.

Currently the manual entries are identified by the bridge flags
BR_FDB_LOCAL or BR_FDB_ADDED_BY_USER, and changes to those flags are
protected under a lock. This means the limit also applies to entries
created with BR_FDB_ADDED_BY_EXT_LEARN but none of the other two,
e.g. ones added by SWITCHDEV_FDB_ADD_TO_BRIDGE.

v1: https://lore.kernel.org/netdev/20230515085046.4457-1-jnixdorf-oss@avm.de/

Changes since v1:
 - Added BR_FDB_ADDED_BY_USER earlier in fdb_add_entry to ensure the
   limit is not applied.
 - Do not initialize fdb_*_entries to 0. (from review)
 - Do not skip decrementing on 0. (from review)
 - Moved the counters to a conditional hole in struct net_bridge to
   avoid growing the struct. (from review, it still grows the struct as
   there are 2 32-bit values)
 - Add IFLA_BR_FDB_CUR_LEARNED_ENTRIES (from review)
 - Fix br_get_size() with the added attributes.
 - Only limit learned entries, rename to
   *_(CUR|MAX)_LEARNED_ENTRIES. (from review)
 - Added a default limit in Kconfig. (deemed acceptable in review
   comments, helps with embedded use-cases where a special purpose kernel
   is built anyways)
 - Added an iproute2 patch for easier testing.

Obsolete v1 review comments:
 - Return better errors to users: Due to limiting the limit to
   automatically created entries, netlink fdb add requests and changing
   bridge ports are never rejected, so they do not yet need a more
   friendly error returned.

net-next:

Johannes Nixdorf (3):
  bridge: Set BR_FDB_ADDED_BY_USER early in fdb_add_entry
  bridge: Add a limit on learned FDB entries
  net: bridge: Add a configurable default FDB learning limit

 include/uapi/linux/if_link.h |  2 +
 net/bridge/Kconfig           | 13 +++++++
 net/bridge/br_device.c       |  2 +
 net/bridge/br_fdb.c          | 73 ++++++++++++++++++++++++++++++++----
 net/bridge/br_netlink.c      | 13 ++++++-
 net/bridge/br_private.h      |  6 +++
 6 files changed, 101 insertions(+), 8 deletions(-)

iproute2-next:

Johannes Nixdorf (1):
  iplink: bridge: Add support for bridge FDB learning limits

 include/uapi/linux/if_link.h |  2 ++
 ip/iplink_bridge.c           | 21 +++++++++++++++++++++
 man/man8/ip-link.8.in        |  9 +++++++++
 3 files changed, 32 insertions(+)

-- 
2.40.1


