Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10B916D24A9
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 18:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbjCaQKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 12:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbjCaQKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 12:10:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB5F20C26
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 09:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680278965;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=TrM3FV9yUJu11xxe+B6pkEMKfEy/1PmRJ+mwB6z84Mo=;
        b=YdZbS+olioXG1IzxHpf/HOmiUwS4ZfZcol3b1yAWsLHG5X2C2c2qWDGviR9SdTsneo84Vo
        uE1++OnId7gV3cWcC/ORgqoH68lRlKQIHe75H0huQ5tZ/Xr2+wClU3kQRvDsQfeiYtrRvU
        4aq68PLGzgSfSEDpyFAm+QnOHoqqv58=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-347-71hJcF8XPTKVTsiDQtuGSg-1; Fri, 31 Mar 2023 12:09:22 -0400
X-MC-Unique: 71hJcF8XPTKVTsiDQtuGSg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 38F753C1178B;
        Fri, 31 Mar 2023 16:09:21 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B376440DD;
        Fri, 31 Mar 2023 16:09:18 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v3 00/55] splice, net: Replace sendpage with sendmsg(MSG_SPLICE_PAGES)
Date:   Fri, 31 Mar 2023 17:08:19 +0100
Message-Id: <20230331160914.1608208-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Willy, Dave, et al.,

I've been looking at how to make pipes handle the splicing in of multipage
folios and also looking to see if I could implement a suggestion from Willy
that pipe_buffers could perhaps hold a list of pages (which could make
splicing simpler - an entire splice segment would go in a single
pipe_buffer).

There are a couple of issues here:

 (1) Gifting/stealing a multipage folio is really tricky.  I think that if
     a multipage folio if gifted, the gift flag should be quietly dropped.
     Userspace has no control over what splice() and vmsplice() will see in
     the pagecache.

 (2) The sendpage op expects to be given a single page and various network
     protocols just attach that to a socket buffer.

This patchset aims to deal with the second by removing the ->sendpage()
operation and replacing it with sendmsg() and a new internal flag
MSG_SPLICE_PAGES.  As sendmsg() takes an I/O iterator, this also affords
the opportunity to pass a slew of pages in one go, rather than one at a
time.

If MSG_SPLICE_PAGES is set, the protocol sendmsg() instance will attempt to
splice the pages out of the buffer, copying into individual fragments those
that it can't (e.g. because they belong to the slab).

The patchset consists of the following parts:

 (1) A couple of fixes.

 (2) Define the MSG_SPLICE_PAGES flag.

 (3) The page_frag_alloc_align() allocator is overhauled:

     (a) Split it out from mm/page_alloc.c into its own file,
     mm/page_frag_alloc.c.

     (b) Make it use multipage folios rather than compound pages.

     (c) Give it per-cpu buckets to allocate from so no locking is
     required.

     (d) The netdev_alloc_cache and the napi fragment cache are then cast
     in terms of this and some private allocators are removed.

     I'm not sure that the existing allocator is 100% multithread safe.

 (4) Implement MSG_SPLICE_PAGES support in TCP.

 (5) Make MSG_SPLICE_PAGES copy unspliceable pages (eg. slab pages).

 (6) Make do_tcp_sendpages() just wrap sendmsg() and then fold it in to its
     various callers.

 (7) Implement MSG_SPLICE_PAGES support in IP and make udp_sendpage() just
     a wrapper around sendmsg().

 (8) Make IP/UDP copy unspliceable pages.

 (9) Implement MSG_SPLICE_PAGES support in AF_UNIX.

(10) Make AF_UNIX copy unspliceable pages.

(11) Make AF_ALG use netfs_extract_iter_to_sg().

(12) Make AF_ALG implement MSG_SPLICE_PAGES and make af_alg_sendpage() just
     a wrapper around sendmsg().

(13) Make AF_ALG/hash implement MSG_SPLICE_PAGES.

(14) Make TLS implement MSG_SPLICE_PAGES and make its sendpage
     implementations just a wrapper.

     [!] Note that tls_sw_sendpage_locked() appears to have the wrong
     	 locking upstream.  I think the caller will only hold the socket
     	 lock, but it should hold tls_ctx->tx_lock too.

(15) Make Chelsio's chtls implement MSG_SPLICE_PAGES.

(16) Make AF_KCM implement MSG_SPLICE_PAGES.

(17) Rename pipe_to_sendpage() to pipe_to_sendmsg() and make it a wrapper
     around sendmsg().

(18) Replace splice_to_socket() with an implementation that doesn't use
     splice_from_pipe() to push one page at a time, but rather something
     that splices up to 16 pages at once.  This absorbs pipe_to_sendmsg().

(19) Remove sendpage file operation.

(20) Convert siw, ceph, iscsi and tcp_bpf to use sendmsg() instead of
     tcp_sendpage().

(21) Make skb_send_sock() use sendmsg().

(22) Convert ceph, rds, dlm, sunrpc, nvme, kcm, smc, ocfs2 and drbd to use
     sendmsg().

(23) Make drbd delegate copying of slab pages to TCP and pass an entire
     bio's bvec to sendmsg at a time.  Delegate copying of unspliceable
     pages to TCP.

(24) Remove the sendpage socket operation.

I've killed off all uses of kernel_sendpage() and all uses of sendpage_ok()
outside of the protocols.

I have tested AF_UNIX splicing - which, surprisingly, seems nearly twice as
fast - TCP splicing, the siw driver (softIWarp RDMA with nfs and cifs),
sunrpc (with nfsd), UDP (using a patched rxrpc) and TLS/sw.

I've pushed the patches here also:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=iov-sendpage

David

Changes
=======
ver #3)
 - Dropped the iterator-of-iterators patch.
 - Only expunge MSG_SPLICE_PAGES in sys_send[m]msg, not sys_recv[m]msg.
 - Split MSG_SPLICE_PAGES code in __ip_append_data() out into helper
   functions.
 - Implement MSG_SPLICE_PAGES support in __ip6_append_data() using the
   above helper functions.
 - Rename 'xlength' to 'initial_length'.
 - Minimise the changes to sunrpc for the moment.
 - Don't give -EOPNOTSUPP if NETIF_F_SG not available, just copy instead.
 - Implemented MSG_SPLICE_PAGES support in the TLS, Chelsio-TLS and AF_KCM
   code.
 
ver #2)
 - Overhauled the page_frag_alloc() allocator: large folios and per-cpu.
   - Got rid of my own zerocopy allocator.
 - Use iov_iter_extract_pages() rather poking in iter->bvec.
 - Made page splicing fall back to page copying on a page-by-page basis.
 - Made splice_to_socket() pass 16 pipe buffers at a time.
 - Made AF_ALG/hash use finup/digest where possible in sendmsg.
 - Added an iterator-of-iterators, ITER_ITERLIST.
 - Made sunrpc use the iterator-of-iterators.
 - Converted more drivers.

Link: https://lore.kernel.org/r/20230316152618.711970-1-dhowells@redhat.com/ # v1
Link: https://lore.kernel.org/r/20230329141354.516864-1-dhowells@redhat.com/ # v2

David Howells (55):
  netfs: Fix netfs_extract_iter_to_sg() for ITER_UBUF/IOVEC
  iov_iter: Remove last_offset member
  net: Declare MSG_SPLICE_PAGES internal sendmsg() flag
  mm: Move the page fragment allocator from page_alloc.c into its own
    file
  mm: Make the page_frag_cache allocator use multipage folios
  mm: Make the page_frag_cache allocator use per-cpu
  tcp: Support MSG_SPLICE_PAGES
  tcp: Make sendmsg(MSG_SPLICE_PAGES) copy unspliceable data
  tcp: Convert do_tcp_sendpages() to use MSG_SPLICE_PAGES
  tcp_bpf: Inline do_tcp_sendpages as it's now a wrapper around
    tcp_sendmsg
  espintcp: Inline do_tcp_sendpages()
  tls: Inline do_tcp_sendpages()
  siw: Inline do_tcp_sendpages()
  tcp: Fold do_tcp_sendpages() into tcp_sendpage_locked()
  ip, udp: Support MSG_SPLICE_PAGES
  ip, udp: Make sendmsg(MSG_SPLICE_PAGES) copy unspliceable data
  ip6, udp6: Support MSG_SPLICE_PAGES
  udp: Convert udp_sendpage() to use MSG_SPLICE_PAGES
  af_unix: Support MSG_SPLICE_PAGES
  af_unix: Make sendmsg(MSG_SPLICE_PAGES) copy unspliceable data
  crypto: af_alg: Pin pages rather than ref'ing if appropriate
  crypto: af_alg: Use netfs_extract_iter_to_sg() to create scatterlists
  crypto: af_alg: Indent the loop in af_alg_sendmsg()
  crypto: af_alg: Support MSG_SPLICE_PAGES
  crypto: af_alg: Convert af_alg_sendpage() to use MSG_SPLICE_PAGES
  crypto: af_alg/hash: Support MSG_SPLICE_PAGES
  tls/device: Support MSG_SPLICE_PAGES
  tls/device: Convert tls_device_sendpage() to use MSG_SPLICE_PAGES
  tls/sw: Support MSG_SPLICE_PAGES
  tls/sw: Convert tls_sw_sendpage() to use MSG_SPLICE_PAGES
  chelsio: Support MSG_SPLICE_PAGES
  chelsio: Convert chtls_sendpage() to use MSG_SPLICE_PAGES
  kcm: Support MSG_SPLICE_PAGES
  kcm: Convert kcm_sendpage() to use MSG_SPLICE_PAGES
  splice, net: Use sendmsg(MSG_SPLICE_PAGES) rather than ->sendpage()
  splice, net: Reimplement splice_to_socket() to pass multiple bufs to
    sendmsg()
  Remove file->f_op->sendpage
  siw: Use sendmsg(MSG_SPLICE_PAGES) rather than sendpage to transmit
  ceph: Use sendmsg(MSG_SPLICE_PAGES) rather than sendpage
  iscsi: Use sendmsg(MSG_SPLICE_PAGES) rather than sendpage
  iscsi: Assume "sendpage" is okay in iscsi_tcp_segment_map()
  tcp_bpf: Make tcp_bpf_sendpage() go through
    tcp_bpf_sendmsg(MSG_SPLICE_PAGES)
  net: Use sendmsg(MSG_SPLICE_PAGES) not sendpage in skb_send_sock()
  algif: Remove hash_sendpage*()
  ceph: Use sendmsg(MSG_SPLICE_PAGES) rather than sendpage()
  rds: Use sendmsg(MSG_SPLICE_PAGES) rather than sendpage
  dlm: Use sendmsg(MSG_SPLICE_PAGES) rather than sendpage
  sunrpc: Use sendmsg(MSG_SPLICE_PAGES) rather then sendpage
  nvme: Use sendmsg(MSG_SPLICE_PAGES) rather then sendpage
  kcm: Use sendmsg(MSG_SPLICE_PAGES) rather then sendpage
  smc: Drop smc_sendpage() in favour of smc_sendmsg() + MSG_SPLICE_PAGES
  ocfs2: Use sendmsg(MSG_SPLICE_PAGES) rather than sendpage()
  drbd: Use sendmsg(MSG_SPLICE_PAGES) rather than sendmsg()
  drdb: Send an entire bio in a single sendmsg
  sock: Remove ->sendpage*() in favour of sendmsg(MSG_SPLICE_PAGES)

 Documentation/networking/scaling.rst          |   4 +-
 crypto/Kconfig                                |   1 +
 crypto/af_alg.c                               | 194 +++++--------
 crypto/algif_aead.c                           |  52 ++--
 crypto/algif_hash.c                           | 171 +++++------
 crypto/algif_rng.c                            |   2 -
 crypto/algif_skcipher.c                       |  24 +-
 drivers/block/drbd/drbd_main.c                |  86 ++----
 drivers/infiniband/sw/siw/siw_qp_tx.c         | 227 +++------------
 .../chelsio/inline_crypto/chtls/chtls.h       |   2 -
 .../chelsio/inline_crypto/chtls/chtls_io.c    | 169 ++++-------
 .../chelsio/inline_crypto/chtls/chtls_main.c  |   1 -
 drivers/net/ethernet/mediatek/mtk_wed_wo.c    |  19 +-
 drivers/net/ethernet/mediatek/mtk_wed_wo.h    |   2 -
 drivers/nvme/host/tcp.c                       |  63 ++--
 drivers/nvme/target/tcp.c                     |  69 +++--
 drivers/scsi/iscsi_tcp.c                      |  31 +-
 drivers/scsi/iscsi_tcp.h                      |   2 +-
 drivers/scsi/libiscsi_tcp.c                   |  13 +-
 drivers/target/iscsi/iscsi_target_util.c      |  14 +-
 fs/dlm/lowcomms.c                             |  10 +-
 fs/netfs/iterator.c                           |   2 +-
 fs/ocfs2/cluster/tcp.c                        | 107 +++----
 fs/splice.c                                   | 158 ++++++++--
 include/crypto/if_alg.h                       |   7 +-
 include/linux/fs.h                            |   3 -
 include/linux/gfp.h                           |  17 +-
 include/linux/mm_types.h                      |  13 +-
 include/linux/net.h                           |   8 -
 include/linux/socket.h                        |   3 +
 include/linux/splice.h                        |   2 +
 include/linux/sunrpc/svc.h                    |  11 +-
 include/linux/uio.h                           |   5 +-
 include/net/inet_common.h                     |   2 -
 include/net/ip.h                              |   4 +
 include/net/sock.h                            |   6 -
 include/net/tcp.h                             |   2 -
 include/net/tls.h                             |   2 +-
 mm/Makefile                                   |   2 +-
 mm/page_alloc.c                               | 126 --------
 mm/page_frag_alloc.c                          | 201 +++++++++++++
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
 net/ceph/messenger_v2.c                       |  89 ++----
 net/core/skbuff.c                             |  81 +++---
 net/core/sock.c                               |  35 +--
 net/dccp/ipv4.c                               |   1 -
 net/dccp/ipv6.c                               |   1 -
 net/ieee802154/socket.c                       |   2 -
 net/ipv4/af_inet.c                            |  21 --
 net/ipv4/ip_output.c                          | 122 +++++++-
 net/ipv4/tcp.c                                | 274 ++++++------------
 net/ipv4/tcp_bpf.c                            |  72 +----
 net/ipv4/tcp_ipv4.c                           |   1 -
 net/ipv4/udp.c                                |  54 ----
 net/ipv4/udp_impl.h                           |   2 -
 net/ipv4/udplite.c                            |   1 -
 net/ipv6/af_inet6.c                           |   3 -
 net/ipv6/ip6_output.c                         |  28 +-
 net/ipv6/raw.c                                |   1 -
 net/ipv6/tcp_ipv6.c                           |   1 -
 net/kcm/kcmsock.c                             | 249 ++++++----------
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
 net/rds/tcp_send.c                            |  86 +++---
 net/rose/af_rose.c                            |   1 -
 net/rxrpc/af_rxrpc.c                          |   1 -
 net/sctp/protocol.c                           |   1 -
 net/smc/af_smc.c                              |  29 --
 net/smc/smc_stats.c                           |   2 +-
 net/smc/smc_stats.h                           |   1 -
 net/smc/smc_tx.c                              |  16 -
 net/smc/smc_tx.h                              |   2 -
 net/socket.c                                  |  76 +----
 net/sunrpc/svcsock.c                          |  38 +--
 net/tipc/socket.c                             |   3 -
 net/tls/tls_device.c                          |  91 +++---
 net/tls/tls_main.c                            |  31 +-
 net/tls/tls_sw.c                              | 215 ++++++--------
 net/unix/af_unix.c                            | 254 +++++++---------
 net/vmw_vsock/af_vsock.c                      |   3 -
 net/x25/af_x25.c                              |   1 -
 net/xdp/xsk.c                                 |   1 -
 net/xfrm/espintcp.c                           |  10 +-
 102 files changed, 1519 insertions(+), 2301 deletions(-)
 create mode 100644 mm/page_frag_alloc.c

