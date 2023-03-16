Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B10EE6BD372
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 16:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbjCPP1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 11:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbjCPP1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 11:27:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE7C173C
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 08:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678980386;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=d661vx9npfWLSp9px0j06PlyK1m4PN240sa+uKnXwQU=;
        b=A/EK02JjGazF5e7Ro5+9sDW+1RZGDb5qf2jm4RyJPcy4MsrR4U89FA9C3J9vHH2cN1xCvt
        d2JTcuadIYTNtNNzl3k/7VMT8YKs+TgfdULWvDMVKS/r5knvZ+dPBoaSEYW5ELcYOUpBS3
        2pLjtK5nyVwZrzSjOo3HxewJHt9dWpg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-411-np5JX8eSNR-Ww7mS7-96oA-1; Thu, 16 Mar 2023 11:26:24 -0400
X-MC-Unique: np5JX8eSNR-Ww7mS7-96oA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8705838149BF;
        Thu, 16 Mar 2023 15:26:23 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 962C92166B26;
        Thu, 16 Mar 2023 15:26:21 +0000 (UTC)
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
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [RFC PATCH 00/28] splice, net: Replace sendpage with sendmsg(MSG_SPLICE_PAGES)
Date:   Thu, 16 Mar 2023 15:25:50 +0000
Message-Id: <20230316152618.711970-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Willy, Dave, et al.,

[NOTE! This patchset is a work in progress and some modules will not
 compile with it.]

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

If MSG_SPLICE_PAGES is set, the current implementation requires that the
iterator be ITER_BVEC-type and that the pages can be retained by calling
get_page() on them.  Note that I'm accessing the bvec[] directly, but
should really use iov_iter_extract_pages() which would allow an
ITER_XARRAY-type iterator to be used also.

The patchset consists of the following parts:

 (1) Define the MSG_SPLICE_PAGES flag.

 (2) Provide a simple allocator that takes pages and splits pieces off them
     on request and returns them with a ref on the page.  Unlike with slab
     memory, the lifetime of the allocated memory is controlled by the page
     refcount.  This allows protocol bits to be included in the same bvec[]
     as the data.

 (3) Implement MSG_SPLICE_PAGES support in TCP.

 (4) Make do_tcp_sendpages() just wrap sendmsg() and then fold it in to its
     various callers.

 (5) Implement MSG_SPLICE_PAGES support in IP and make udp_sendpage() just
     a wrapper around sendmsg().

 (6) Implement MSG_SPLICE_PAGES support in AF_UNIX.

 (7) Implement MSG_SPLICE_PAGES support in AF_ALG and make
     af_alg_sendpage() just a wrapper around sendmsg().

 (8) Rename pipe_to_sendpage() to pipe_to_sendmsg() and make it a wrapper
     around sendmsg().

 (9) Remove sendpage file operation.

(10) Convert siw, ceph, iscsi and tcp_bpf to use sendmsg() instead of
     tcp_sendpage().

(11) Make skb_send_sock() use sendmsg().

(12) Remove AF_ALG's hash_sendpage() as hash_sendmsg() seems to do paste
     the page pointers in anyway.

(13) Convert ceph, rds, dlm and sunrpc to use sendmsg().

(14) Remove the sendpage socket operation.

This leaves the implementation of MSG_SPLICE_PAGES in AF_TLS, AF_KCM,
AF_SMC and Chelsio-TLS which I'm going to need help with, and cleaning up
the use of kernel_sendpage in AF_KCM, AF_SMC and NVMe over TCP still to be
done.


I'm wondering about how best to proceed further:

 - Rather than providing a special allocator, should protocols implementing
   MSG_SPLICE_PAGES recognise pages that belong to the slab allocator and
   copy the content of those to the skbuff and only directly attach the
   source page if it's not a slab page?

 - Should MSG_SPLICE_PAGES work with ITER_XARRAY as well as ITER_BVEC?

 - Should MSG_SPLICE_PAGES just be a hint and get ignored if the conditions
   for using it are not met rather than giving an error?

 - Should pages attached to a pipe be pinned (ie. FOLL_PIN) rather than
   simply ref'd (ie. FOLL_GET) so that the DIO issue doesn't occur on
   spliced pages?

 - Similarly, should pages undergoing zerocopy be pinned when attached to
   an skbuff rather than being simply ref'd?  I have a patch to note in the
   bottom two bits of the frag page pointer if they are pinned, ref'd or
   neither.


I have tested AF_UNIX splicing - which, surprisingly, seems nearly twice as
fast - TCP splicing, the siw driver (softIWarp RDMA with nfs and cifs),
sunrpc (with nfsd) and UDP (using a patched rxrpc).

I've pushed the patches here also:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=iov-sendpage

David

David Howells (28):
  net: Declare MSG_SPLICE_PAGES internal sendmsg() flag
  Add a special allocator for staging netfs protocol to MSG_SPLICE_PAGES
  tcp: Support MSG_SPLICE_PAGES
  tcp: Convert do_tcp_sendpages() to use MSG_SPLICE_PAGES
  tcp_bpf: Inline do_tcp_sendpages as it's now a wrapper around
    tcp_sendmsg
  espintcp: Inline do_tcp_sendpages()
  tls: Inline do_tcp_sendpages()
  siw: Inline do_tcp_sendpages()
  tcp: Fold do_tcp_sendpages() into tcp_sendpage_locked()
  ip, udp: Support MSG_SPLICE_PAGES
  udp: Convert udp_sendpage() to use MSG_SPLICE_PAGES
  af_unix: Support MSG_SPLICE_PAGES
  crypto: af_alg: Indent the loop in af_alg_sendmsg()
  crypto: af_alg: Support MSG_SPLICE_PAGES
  crypto: af_alg: Convert af_alg_sendpage() to use MSG_SPLICE_PAGES
  splice, net: Use sendmsg(MSG_SPLICE_PAGES) rather than ->sendpage()
  Remove file->f_op->sendpage
  siw: Use sendmsg(MSG_SPLICE_PAGES) rather than sendpage to transmit
  ceph: Use sendmsg(MSG_SPLICE_PAGES) rather than sendpage
  iscsi: Use sendmsg(MSG_SPLICE_PAGES) rather than sendpage
  tcp_bpf: Make tcp_bpf_sendpage() go through
    tcp_bpf_sendmsg(MSG_SPLICE_PAGES)
  net: Use sendmsg(MSG_SPLICE_PAGES) not sendpage in skb_send_sock()
  algif: Remove hash_sendpage*()
  ceph: Use sendmsg(MSG_SPLICE_PAGES) rather than sendpage()
  rds: Use sendmsg(MSG_SPLICE_PAGES) rather than sendpage
  dlm: Use sendmsg(MSG_SPLICE_PAGES) rather than sendpage
  sunrpc: Use sendmsg(MSG_SPLICE_PAGES) rather then sendpage
  sock: Remove ->sendpage*() in favour of sendmsg(MSG_SPLICE_PAGES)

 Documentation/networking/scaling.rst     |   4 +-
 crypto/Kconfig                           |   1 +
 crypto/af_alg.c                          | 137 +++++--------
 crypto/algif_aead.c                      |  40 ++--
 crypto/algif_hash.c                      |  66 ------
 crypto/algif_rng.c                       |   2 -
 crypto/algif_skcipher.c                  |  22 +-
 drivers/infiniband/sw/siw/siw_qp_tx.c    | 224 +++++----------------
 drivers/target/iscsi/iscsi_target_util.c |  14 +-
 fs/dlm/lowcomms.c                        |  10 +-
 fs/splice.c                              |  42 ++--
 include/linux/fs.h                       |   3 -
 include/linux/net.h                      |   8 -
 include/linux/socket.h                   |   1 +
 include/linux/splice.h                   |   2 +
 include/linux/zcopy_alloc.h              |  16 ++
 include/net/inet_common.h                |   2 -
 include/net/sock.h                       |   6 -
 include/net/tcp.h                        |   2 -
 include/net/tls.h                        |   2 +-
 mm/Makefile                              |   2 +-
 mm/zcopy_alloc.c                         | 129 ++++++++++++
 net/appletalk/ddp.c                      |   1 -
 net/atm/pvc.c                            |   1 -
 net/atm/svc.c                            |   1 -
 net/ax25/af_ax25.c                       |   1 -
 net/caif/caif_socket.c                   |   2 -
 net/can/bcm.c                            |   1 -
 net/can/isotp.c                          |   1 -
 net/can/j1939/socket.c                   |   1 -
 net/can/raw.c                            |   1 -
 net/ceph/messenger_v1.c                  |  58 ++----
 net/ceph/messenger_v2.c                  |  89 ++-------
 net/core/skbuff.c                        |  49 +++--
 net/core/sock.c                          |  35 +---
 net/dccp/ipv4.c                          |   1 -
 net/dccp/ipv6.c                          |   1 -
 net/ieee802154/socket.c                  |   2 -
 net/ipv4/af_inet.c                       |  21 --
 net/ipv4/ip_output.c                     |  89 ++++++++-
 net/ipv4/tcp.c                           | 244 +++++------------------
 net/ipv4/tcp_bpf.c                       |  72 ++-----
 net/ipv4/tcp_ipv4.c                      |   1 -
 net/ipv4/udp.c                           |  54 -----
 net/ipv4/udp_impl.h                      |   2 -
 net/ipv4/udplite.c                       |   1 -
 net/ipv6/af_inet6.c                      |   3 -
 net/ipv6/raw.c                           |   1 -
 net/ipv6/tcp_ipv6.c                      |   1 -
 net/key/af_key.c                         |   1 -
 net/l2tp/l2tp_ip.c                       |   1 -
 net/l2tp/l2tp_ip6.c                      |   1 -
 net/llc/af_llc.c                         |   1 -
 net/mctp/af_mctp.c                       |   1 -
 net/mptcp/protocol.c                     |   2 -
 net/netlink/af_netlink.c                 |   1 -
 net/netrom/af_netrom.c                   |   1 -
 net/packet/af_packet.c                   |   2 -
 net/phonet/socket.c                      |   2 -
 net/qrtr/af_qrtr.c                       |   1 -
 net/rds/af_rds.c                         |   1 -
 net/rds/tcp_send.c                       |  80 ++++----
 net/rose/af_rose.c                       |   1 -
 net/rxrpc/af_rxrpc.c                     |   1 -
 net/sctp/protocol.c                      |   1 -
 net/socket.c                             |  74 +------
 net/sunrpc/svcsock.c                     |  70 ++-----
 net/sunrpc/xdr.c                         |  24 ++-
 net/tipc/socket.c                        |   3 -
 net/tls/tls_main.c                       |  24 ++-
 net/unix/af_unix.c                       | 223 +++++++--------------
 net/vmw_vsock/af_vsock.c                 |   3 -
 net/x25/af_x25.c                         |   1 -
 net/xdp/xsk.c                            |   1 -
 net/xfrm/espintcp.c                      |  10 +-
 75 files changed, 687 insertions(+), 1313 deletions(-)
 create mode 100644 include/linux/zcopy_alloc.h
 create mode 100644 mm/zcopy_alloc.c

