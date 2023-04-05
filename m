Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 281176D8425
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 18:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbjDEQyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 12:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjDEQyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 12:54:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 759A7E41
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 09:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680713630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=KmiKjQgWG4Y9cITznjjg+SgzOOlwkZVxSxLSfyrxTP0=;
        b=h4gre8quMvb2EUgVxS2ANbDpDPhKE9t5+Ml4YoZw7C/mzQyW0AcWJIffl8C1ld2IYka0W3
        /CSxwRZ/80Ell46E6jkfvZL2hZUIDX7HzN/whPLy+Ade3xoiXtxj7vibV7Qng/vfrtQlOc
        TF0fYY3IdWpyvIeLNN80RN2AlVn3J+c=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-125-tnozf7CANJ-ARwwUpEUG2g-1; Wed, 05 Apr 2023 12:53:45 -0400
X-MC-Unique: tnozf7CANJ-ARwwUpEUG2g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8CA8D2807D62;
        Wed,  5 Apr 2023 16:53:44 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 664DE140EBF4;
        Wed,  5 Apr 2023 16:53:42 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH net-next v4 00/20] splice, net: Replace sendpage with sendmsg(MSG_SPLICE_PAGES), part 1
Date:   Wed,  5 Apr 2023 17:53:19 +0100
Message-Id: <20230405165339.3468808-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here's the first tranche of patches towards providing a MSG_SPLICE_PAGES
internal sendmsg flag that is intended to replace the ->sendpage() op with
calls to sendmsg().  MSG_SPLICE is a hint that tells the protocol that it
should splice the pages supplied if it can and copy them if not.

This will allow splice to pass multiple pages in a single call and allow
certain parts of higher protocols (e.g. sunrpc, iwarp) to pass an entire
message in one go rather than having to send them piecemeal.  This should
also make it easier to handle the splicing of multipage folios.

This set consists of the following parts:

 (1) Provide a set of sample functions in samples/net/ that can be used to
     drive splice() and sendfile() with TCP/TCP6, UDP/UDP6, TLS over
     TCP/TCP6, UNIX and ALG hash/skcipher sockets for testing.

 (2) Define the MSG_SPLICE_PAGES flag and prevent sys_sendmsg() from being
     able to set it.

 (3) Overhaul the page_frag_alloc_align() allocator:

     (a) Split it out from mm/page_alloc.c into its own file,
     mm/page_frag_alloc.c.

     (b) Make it use multipage folios rather than compound pages.

     (c) Give it per-cpu buckets to allocate from so no locking is
     required.

     (d) The netdev_alloc_cache and the napi fragment cache are then cast
     in terms of this and some private allocators are removed.

     I'm not sure that the existing allocator is 100% thread safe.

 (4) Implement MSG_SPLICE_PAGES support in TCP.

 (5) Make do_tcp_sendpages() just wrap sendmsg() and then fold it in to its
     various callers.

 (6) Implement MSG_SPLICE_PAGES support in IP and make udp_sendpage() just
     a wrapper around sendmsg().

 (7) Implement MSG_SPLICE_PAGES support in IP6/UDP6.

 (8) Implement MSG_SPLICE_PAGES support in AF_UNIX.

 (9) Make AF_UNIX copy unspliceable pages.

I've pushed the patches here also:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=sendpage-1

The follow-on patches are on branch iov-sendpage on the same tree.

David

Changes
=======
ver #4)
 - Added some sample socket-I/O programs into samples/net/.
 - Fix a missing page-get in AF_KCM.
 - Init the sgtable and mark the end in AF_ALG when calling
   netfs_extract_iter_to_sg().
 - Add a destructor func for page frag caches prior to generalising it and
   making it per-cpu.

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
Link: https://lore.kernel.org/r/20230331160914.1608208-1-dhowells@redhat.com/ # v3

David Howells (20):
  net: Add samples for network I/O and splicing
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
  udp: Convert udp_sendpage() to use MSG_SPLICE_PAGES
  ip: Remove ip_append_page()
  ip, udp: Support MSG_SPLICE_PAGES
  ip, udp: Make sendmsg(MSG_SPLICE_PAGES) copy unspliceable data
  ip6, udp6: Support MSG_SPLICE_PAGES
  af_unix: Support MSG_SPLICE_PAGES
  af_unix: Make sendmsg(MSG_SPLICE_PAGES) copy unspliceable data

 drivers/infiniband/sw/siw/siw_qp_tx.c      |  17 +-
 drivers/net/ethernet/mediatek/mtk_wed_wo.c |  19 +-
 drivers/net/ethernet/mediatek/mtk_wed_wo.h |   2 -
 drivers/nvme/host/tcp.c                    |  19 +-
 drivers/nvme/target/tcp.c                  |  22 +-
 include/linux/gfp.h                        |  17 +-
 include/linux/mm_types.h                   |  13 +-
 include/linux/socket.h                     |   3 +
 include/net/ip.h                           |   3 +-
 include/net/tcp.h                          |   2 -
 include/net/tls.h                          |   2 +-
 mm/Makefile                                |   2 +-
 mm/page_alloc.c                            | 126 ----------
 mm/page_frag_alloc.c                       | 201 ++++++++++++++++
 net/core/skbuff.c                          |  32 +--
 net/ipv4/ip_output.c                       | 202 ++++++----------
 net/ipv4/tcp.c                             | 260 ++++++++-------------
 net/ipv4/tcp_bpf.c                         |  20 +-
 net/ipv4/udp.c                             |  50 +---
 net/ipv6/ip6_output.c                      |  12 +
 net/socket.c                               |   2 +
 net/tls/tls_main.c                         |  24 +-
 net/unix/af_unix.c                         | 115 +++++++--
 net/xfrm/espintcp.c                        |  10 +-
 samples/Kconfig                            |   6 +
 samples/Makefile                           |   1 +
 samples/net/Makefile                       |  13 ++
 samples/net/alg-encrypt.c                  | 201 ++++++++++++++++
 samples/net/alg-hash.c                     | 143 ++++++++++++
 samples/net/splice-out.c                   | 142 +++++++++++
 samples/net/tcp-send.c                     | 154 ++++++++++++
 samples/net/tcp-sink.c                     |  76 ++++++
 samples/net/tls-send.c                     | 176 ++++++++++++++
 samples/net/tls-sink.c                     |  98 ++++++++
 samples/net/udp-send.c                     | 151 ++++++++++++
 samples/net/udp-sink.c                     |  82 +++++++
 samples/net/unix-send.c                    | 147 ++++++++++++
 samples/net/unix-sink.c                    |  51 ++++
 38 files changed, 2017 insertions(+), 599 deletions(-)
 create mode 100644 mm/page_frag_alloc.c
 create mode 100644 samples/net/Makefile
 create mode 100644 samples/net/alg-encrypt.c
 create mode 100644 samples/net/alg-hash.c
 create mode 100644 samples/net/splice-out.c
 create mode 100644 samples/net/tcp-send.c
 create mode 100644 samples/net/tcp-sink.c
 create mode 100644 samples/net/tls-send.c
 create mode 100644 samples/net/tls-sink.c
 create mode 100644 samples/net/udp-send.c
 create mode 100644 samples/net/udp-sink.c
 create mode 100644 samples/net/unix-send.c
 create mode 100644 samples/net/unix-sink.c

