Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7B36C4C8F
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 14:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbjCVN5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 09:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbjCVN5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 09:57:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0302038013
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 06:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679493381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5woec2SKsMOQkbW9YnJmuUdhKTAPEWv+lO7kND+/pB8=;
        b=Kqw58Fs9Y9dv4scH4cNyVaNbPWbNc0kyOKG6pgsf6UtEGFBiRomEC+0KIA7c8d3a0PvO0I
        5jWGpqy0pPPOhC/NOggOx92raHVbBJ55dnywv7RUzouvoLQ/qFzn907SXbkxZDtY95gxjz
        z3ZISvpG4PQWZK3eHH6nV95sRj+Q0Co=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-96-pqt0UpdMM--DDgtV9lXpLA-1; Wed, 22 Mar 2023 09:56:18 -0400
X-MC-Unique: pqt0UpdMM--DDgtV9lXpLA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 960C61C02D3C;
        Wed, 22 Mar 2023 13:56:17 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3B7D542C827;
        Wed, 22 Mar 2023 13:56:16 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Jeff Layton <jlayton@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/3] net: Drop size arg from ->sendmsg() and pass msghdr into __ip{,6}_append_data()
Date:   Wed, 22 Mar 2023 13:56:09 +0000
Message-Id: <20230322135612.3265850-1-dhowells@redhat.com>
In-Reply-To: <6419bda5a2b4d_59e87208ca@willemb.c.googlers.com.notmuch>
References: <6419bda5a2b4d_59e87208ca@willemb.c.googlers.com.notmuch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Willem,

Here's another option to passing MSG_SPLICE_PAGES into sendmsg()[1] without
polluting the flags in msg->msg_flags.  The idea here is to put the flag
into a new field in msghdr, msg_kflags, that holds internal kernel flags
that aren't available to userspace.

What I've done here is:

 (1) Pass msg down to __ip_append_data() and __ip6_append_data() so that
     they can access the extra flags.

 (2) In order to avoid adding extra arguments to these functions and the
     functions in their call chains (such as ip_make_skb()), remove the
     size and flags arguments as these values are redundant if msg is
     passed in.

 (3) msg is then passed into getfrag().  I would like to get rid of the
     "from" argument also in favour of using something in msghdr, but I'm
     not sure how best to do that.

 (4) The size parameter to ->sendmsg() seems to be redundant; indeed
     sock_sendmsg() doesn't actually take it, but rather gets the count
     from msg_iter - so remove this parameter.

     kernel_sendmsg() will still take a size, but it sets it on the
     iterator and then calls sock_sendmsg().

 (5) Protocol sendmsg implementations then extract the length and the flags
     from the iterator.

 (6) Illustrate the addition of msg_kflags and MSG_SPLICE_PAGES.  I think
     that, at some point in the future, some of the other flags could be
     moved from msg_flags to msg_kflags.

David

Link: https://lore.kernel.org/r/20230316152618.711970-1-dhowells@redhat.com/ [1]

David Howells (3):
  net: Drop the size argument from ->sendmsg()
  ip: Make __ip{,6}_append_data() and co. take a msghdr*
  net: Declare MSG_SPLICE_PAGES internal sendmsg() flag

 crypto/af_alg.c                               | 12 +--
 crypto/algif_aead.c                           |  9 +--
 crypto/algif_hash.c                           |  8 +-
 crypto/algif_rng.c                            |  3 +-
 crypto/algif_skcipher.c                       | 10 +--
 drivers/isdn/mISDN/socket.c                   |  3 +-
 .../chelsio/inline_crypto/chtls/chtls.h       |  2 +-
 .../chelsio/inline_crypto/chtls/chtls_io.c    | 15 ++--
 drivers/net/ppp/pppoe.c                       |  4 +-
 drivers/net/tap.c                             |  3 +-
 drivers/net/tun.c                             |  3 +-
 drivers/vhost/net.c                           |  6 +-
 drivers/xen/pvcalls-back.c                    |  2 +-
 drivers/xen/pvcalls-front.c                   |  4 +-
 drivers/xen/pvcalls-front.h                   |  3 +-
 fs/afs/rxrpc.c                                |  8 +-
 include/crypto/if_alg.h                       |  3 +-
 include/linux/lsm_hook_defs.h                 |  3 +-
 include/linux/lsm_hooks.h                     |  1 -
 include/linux/net.h                           |  6 +-
 include/linux/security.h                      |  4 +-
 include/linux/socket.h                        |  3 +
 include/net/af_rxrpc.h                        |  3 +-
 include/net/inet_common.h                     |  2 +-
 include/net/ip.h                              | 24 +++---
 include/net/ipv6.h                            | 22 +++---
 include/net/ping.h                            |  7 +-
 include/net/sock.h                            |  7 +-
 include/net/tcp.h                             |  8 +-
 include/net/udp.h                             |  2 +-
 include/net/udplite.h                         |  4 +-
 net/appletalk/ddp.c                           |  3 +-
 net/atm/common.c                              |  3 +-
 net/atm/common.h                              |  2 +-
 net/ax25/af_ax25.c                            |  4 +-
 net/bluetooth/hci_sock.c                      |  4 +-
 net/bluetooth/iso.c                           |  4 +-
 net/bluetooth/l2cap_sock.c                    |  5 +-
 net/bluetooth/rfcomm/sock.c                   |  7 +-
 net/bluetooth/sco.c                           |  4 +-
 net/caif/caif_socket.c                        | 13 ++--
 net/can/bcm.c                                 |  3 +-
 net/can/isotp.c                               |  3 +-
 net/can/j1939/socket.c                        |  4 +-
 net/can/raw.c                                 |  3 +-
 net/core/sock.c                               |  4 +-
 net/dccp/dccp.h                               |  2 +-
 net/dccp/proto.c                              |  3 +-
 net/ieee802154/socket.c                       | 11 +--
 net/ipv4/af_inet.c                            |  4 +-
 net/ipv4/icmp.c                               | 14 ++--
 net/ipv4/ip_output.c                          | 73 ++++++++++---------
 net/ipv4/ping.c                               | 18 ++---
 net/ipv4/raw.c                                | 23 +++---
 net/ipv4/tcp.c                                | 17 +++--
 net/ipv4/tcp_bpf.c                            |  5 +-
 net/ipv4/tcp_input.c                          |  3 +-
 net/ipv4/udp.c                                | 24 +++---
 net/ipv6/af_inet6.c                           |  7 +-
 net/ipv6/icmp.c                               | 21 ++++--
 net/ipv6/ip6_output.c                         | 57 +++++++--------
 net/ipv6/ping.c                               | 12 +--
 net/ipv6/raw.c                                | 25 +++----
 net/ipv6/udp.c                                | 26 ++++---
 net/ipv6/udp_impl.h                           |  2 +-
 net/iucv/af_iucv.c                            |  4 +-
 net/kcm/kcmsock.c                             |  2 +-
 net/key/af_key.c                              |  3 +-
 net/l2tp/l2tp_ip.c                            |  3 +-
 net/l2tp/l2tp_ip6.c                           |  3 +-
 net/l2tp/l2tp_ppp.c                           |  4 +-
 net/llc/af_llc.c                              |  5 +-
 net/mctp/af_mctp.c                            |  3 +-
 net/mptcp/protocol.c                          |  8 +-
 net/netlink/af_netlink.c                      | 11 +--
 net/netrom/af_netrom.c                        |  3 +-
 net/nfc/llcp_sock.c                           |  7 +-
 net/nfc/rawsock.c                             |  3 +-
 net/packet/af_packet.c                        | 11 +--
 net/phonet/datagram.c                         |  3 +-
 net/phonet/pep.c                              |  3 +-
 net/phonet/socket.c                           |  5 +-
 net/qrtr/af_qrtr.c                            |  4 +-
 net/rds/rds.h                                 |  2 +-
 net/rds/send.c                                |  3 +-
 net/rose/af_rose.c                            |  3 +-
 net/rxrpc/af_rxrpc.c                          |  6 +-
 net/rxrpc/ar-internal.h                       |  2 +-
 net/rxrpc/output.c                            | 22 +++---
 net/rxrpc/rxperf.c                            |  4 +-
 net/rxrpc/sendmsg.c                           | 15 ++--
 net/sctp/socket.c                             |  3 +-
 net/smc/af_smc.c                              |  5 +-
 net/socket.c                                  | 16 ++--
 net/tipc/socket.c                             | 34 ++++-----
 net/tls/tls.h                                 |  4 +-
 net/tls/tls_device.c                          |  5 +-
 net/tls/tls_sw.c                              |  2 +-
 net/unix/af_unix.c                            | 19 +++--
 net/vmw_vsock/af_vsock.c                      | 16 ++--
 net/x25/af_x25.c                              |  3 +-
 net/xdp/xsk.c                                 |  6 +-
 net/xfrm/espintcp.c                           |  8 +-
 security/apparmor/lsm.c                       |  6 +-
 security/security.c                           |  4 +-
 security/selinux/hooks.c                      |  3 +-
 security/smack/smack_lsm.c                    |  4 +-
 security/tomoyo/common.h                      |  3 +-
 security/tomoyo/network.c                     |  4 +-
 security/tomoyo/tomoyo.c                      |  6 +-
 110 files changed, 444 insertions(+), 456 deletions(-)

