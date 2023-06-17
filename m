Return-Path: <netdev+bounces-11714-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D8D637340A0
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 14:12:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BEE951C20A62
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 12:12:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EAB68BE7;
	Sat, 17 Jun 2023 12:12:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE057481
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 12:12:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A12E1B7
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 05:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687003940;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=CIFvrHvC056VcufsrygMkIPyFYfy/shs5eQcVwUSd4I=;
	b=ZZC3YQdY6IkbVY7mMt2Y5Uru1dSKpt+ZrrAn5ZI70/oyzOBy9DS6/2YIQEfemS8WBO/Zz/
	ni9Lox9UUkCtarbwr+Jcs+Ako6iX1yKwl8liIPfxaV4qbzSew0FtrY/ypGrHDSkSBSVcjO
	BsHOvuE82IG/K1L9mVR4XIskuKOTrFs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-BgbjYCF3MIWN8EEgN_BVSg-1; Sat, 17 Jun 2023 08:12:15 -0400
X-MC-Unique: BgbjYCF3MIWN8EEgN_BVSg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 991D7857AAA;
	Sat, 17 Jun 2023 12:12:10 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.51])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 174A4141511A;
	Sat, 17 Jun 2023 12:12:09 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Alexander Duyck <alexander.duyck@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 00/17] splice, net: Switch over users of sendpage() and remove it
Date: Sat, 17 Jun 2023 13:11:29 +0100
Message-ID: <20230617121146.716077-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Here's the final set of patches towards the removal of sendpage.  All the
drivers that use sendpage() get switched over to using sendmsg() with
MSG_SPLICE_PAGES.

skb_splice_from_iter() is given the facility to copy slab data() into
fragments - or to coalesce them (in future) with other unspliced buffers in
the target skbuff.  This means that the caller can work the same way, no
matter whether MSG_SPLICE_PAGES is supplied or not and no matter if the
protocol just ignores it.  If MSG_SPLICE_PAGES is not supplied or if it is
just ignored, the data will get copied as normal rather than being spliced.

For the moment, skb_splice_from_iter() is equipped with its own fragment
allocator - one that has percpu pages to allocate from to deal with
parallel callers but that can also drop the percpu lock around calling the
page allocator.

The following changes are made:

 (1) Introduce an SMP-safe shared fragment allocator and make
     skb_splice_from_iter() use it.  The allocator is exported so that
     ocfs2 can use it.

     This now doesn't alter the existing page_frag_cache allocator.

 (2) Expose information from the allocator in /proc/.  This is useful for
     debugging it, but could be dropped.

 (3) Make the protocol drivers behave according to MSG_MORE, not
     MSG_SENDPAGE_NOTLAST.  The latter is restricted to turning on MSG_MORE
     in the sendpage() wrappers.

 (4) Make siw, ceph/rds, skb_send_sock, dlm, nvme, smc, ocfs2, drbd and
     iscsi use sendmsg(), not sendpage and make them specify MSG_MORE
     instead of MSG_SENDPAGE_NOTLAST.

     ocfs2 now allocates fragments for a couple of cases where it would
     otherwise pass in a pointer to shared data that doesn't seem to
     sufficient locking.

 (5) Make drbd coalesce its entire message into a single sendmsg().

 (6) Kill off sendpage and clean up MSG_SENDPAGE_NOTLAST.

I've pushed the patches here also:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=sendpage-3-frag

David

Changes
=======
ver #2)
 - Wrapped some lines at 80.
 - Fixed parameter to put_cpu_ptr() to have an '&'.
 - Use "unsigned int" rather than "unsigned".
 - Removed duplicate word in comment.
 - Filled in the commit message on the last patch.

Link: https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=51c78a4d532efe9543a4df019ff405f05c6157f6 # part 1
Link: https://lore.kernel.org/r/20230616161301.622169-1-dhowells@redhat.com/ # v1

David Howells (17):
  net: Copy slab data for sendmsg(MSG_SPLICE_PAGES)
  net: Display info about MSG_SPLICE_PAGES memory handling in proc
  tcp_bpf, smc, tls, espintcp: Reduce MSG_SENDPAGE_NOTLAST usage
  siw: Use sendmsg(MSG_SPLICE_PAGES) rather than sendpage to transmit
  ceph: Use sendmsg(MSG_SPLICE_PAGES) rather than sendpage
  net: Use sendmsg(MSG_SPLICE_PAGES) not sendpage in skb_send_sock()
  ceph: Use sendmsg(MSG_SPLICE_PAGES) rather than sendpage()
  rds: Use sendmsg(MSG_SPLICE_PAGES) rather than sendpage
  dlm: Use sendmsg(MSG_SPLICE_PAGES) rather than sendpage
  nvme: Use sendmsg(MSG_SPLICE_PAGES) rather then sendpage
  smc: Drop smc_sendpage() in favour of smc_sendmsg() + MSG_SPLICE_PAGES
  ocfs2: Use sendmsg(MSG_SPLICE_PAGES) rather than sendpage()
  drbd: Use sendmsg(MSG_SPLICE_PAGES) rather than sendpage()
  drdb: Send an entire bio in a single sendmsg
  iscsi: Use sendmsg(MSG_SPLICE_PAGES) rather than sendpage
  sock: Remove ->sendpage*() in favour of sendmsg(MSG_SPLICE_PAGES)
  net: Kill MSG_SENDPAGE_NOTLAST

 Documentation/bpf/map_sockmap.rst             |  10 +-
 Documentation/filesystems/locking.rst         |   2 -
 Documentation/filesystems/vfs.rst             |   1 -
 Documentation/networking/scaling.rst          |   4 +-
 crypto/af_alg.c                               |  28 --
 crypto/algif_aead.c                           |  22 +-
 crypto/algif_rng.c                            |   2 -
 crypto/algif_skcipher.c                       |  14 -
 drivers/block/drbd/drbd_main.c                |  88 +++---
 drivers/infiniband/sw/siw/siw_qp_tx.c         | 231 +++-------------
 .../chelsio/inline_crypto/chtls/chtls.h       |   2 -
 .../chelsio/inline_crypto/chtls/chtls_io.c    |  14 -
 .../chelsio/inline_crypto/chtls/chtls_main.c  |   1 -
 drivers/nvme/host/tcp.c                       |  46 ++--
 drivers/nvme/target/tcp.c                     |  46 ++--
 drivers/scsi/iscsi_tcp.c                      |  26 +-
 drivers/scsi/iscsi_tcp.h                      |   2 +-
 drivers/target/iscsi/iscsi_target_util.c      |  15 +-
 fs/dlm/lowcomms.c                             |  10 +-
 fs/nfsd/vfs.c                                 |   2 +-
 fs/ocfs2/cluster/tcp.c                        | 109 ++++----
 include/crypto/if_alg.h                       |   2 -
 include/linux/net.h                           |   8 -
 include/linux/skbuff.h                        |   5 +
 include/linux/socket.h                        |   4 +-
 include/net/inet_common.h                     |   2 -
 include/net/sock.h                            |   6 -
 include/net/tcp.h                             |   4 -
 net/appletalk/ddp.c                           |   1 -
 net/atm/pvc.c                                 |   1 -
 net/atm/svc.c                                 |   1 -
 net/ax25/af_ax25.c                            |   1 -
 net/caif/caif_socket.c                        |   2 -
 net/can/bcm.c                                 |   1 -
 net/can/isotp.c                               |   1 -
 net/can/j1939/socket.c                        |   1 -
 net/can/raw.c                                 |   1 -
 net/ceph/messenger_v1.c                       |  58 ++--
 net/ceph/messenger_v2.c                       |  91 ++-----
 net/core/skbuff.c                             | 257 ++++++++++++++++--
 net/core/sock.c                               |  35 +--
 net/dccp/ipv4.c                               |   1 -
 net/dccp/ipv6.c                               |   1 -
 net/ieee802154/socket.c                       |   2 -
 net/ipv4/af_inet.c                            |  21 --
 net/ipv4/tcp.c                                |  43 +--
 net/ipv4/tcp_bpf.c                            |  30 +-
 net/ipv4/tcp_ipv4.c                           |   1 -
 net/ipv4/udp.c                                |  15 -
 net/ipv4/udp_impl.h                           |   2 -
 net/ipv4/udplite.c                            |   1 -
 net/ipv6/af_inet6.c                           |   3 -
 net/ipv6/raw.c                                |   1 -
 net/ipv6/tcp_ipv6.c                           |   1 -
 net/kcm/kcmsock.c                             |  20 --
 net/key/af_key.c                              |   1 -
 net/l2tp/l2tp_ip.c                            |   1 -
 net/l2tp/l2tp_ip6.c                           |   1 -
 net/llc/af_llc.c                              |   1 -
 net/mctp/af_mctp.c                            |   1 -
 net/mptcp/protocol.c                          |   2 -
 net/netlink/af_netlink.c                      |   1 -
 net/netrom/af_netrom.c                        |   1 -
 net/packet/af_packet.c                        |   2 -
 net/phonet/socket.c                           |   2 -
 net/qrtr/af_qrtr.c                            |   1 -
 net/rds/af_rds.c                              |   1 -
 net/rds/tcp_send.c                            |  74 ++---
 net/rose/af_rose.c                            |   1 -
 net/rxrpc/af_rxrpc.c                          |   1 -
 net/sctp/protocol.c                           |   1 -
 net/smc/af_smc.c                              |  29 --
 net/smc/smc_stats.c                           |   2 +-
 net/smc/smc_stats.h                           |   1 -
 net/smc/smc_tx.c                              |  20 +-
 net/smc/smc_tx.h                              |   2 -
 net/socket.c                                  |  48 ----
 net/tipc/socket.c                             |   3 -
 net/tls/tls.h                                 |   6 -
 net/tls/tls_device.c                          |  24 +-
 net/tls/tls_main.c                            |   9 +-
 net/tls/tls_sw.c                              |  37 +--
 net/unix/af_unix.c                            |  19 --
 net/vmw_vsock/af_vsock.c                      |   3 -
 net/x25/af_x25.c                              |   1 -
 net/xdp/xsk.c                                 |   1 -
 net/xfrm/espintcp.c                           |  10 +-
 .../perf/trace/beauty/include/linux/socket.h  |   1 -
 tools/perf/trace/beauty/msg_flags.c           |   3 -
 89 files changed, 547 insertions(+), 1063 deletions(-)


