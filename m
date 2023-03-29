Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD8A16CDCB8
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 16:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjC2Oft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 10:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbjC2OfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 10:35:24 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818E46A48;
        Wed, 29 Mar 2023 07:31:27 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C8D9E1FDD7;
        Wed, 29 Mar 2023 14:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1680099832; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JgAqhks0C3IN4+lfZvuY0gbFhTkXdOVc3wNxYkO+XwE=;
        b=VHJy/t4VnSzbZ4tzrhebOifyuC6pGjl5TQIz/eVAhtxXjcdr04nTTT8d+loIHlGU27b+2j
        CSu6s44u+410mCUI1AS93mzHeTuhgDd5WeETx5FLlNVkwySfxchYWlJ1RLdkFjFZotLzG/
        coolDxdnh26L8KxKvBfdG8ioSVVkkIQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1680099832;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JgAqhks0C3IN4+lfZvuY0gbFhTkXdOVc3wNxYkO+XwE=;
        b=47xCWD44CmYf+Mf1uCacEcx5m0liEJt4VEk696Atou5kYSzLvIRfiSd0oiNW0K9PV3jU3L
        lxDHHZyHaPhoaJCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 63D1E138FF;
        Wed, 29 Mar 2023 14:23:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id vQXSFvhJJGTPMwAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 29 Mar 2023 14:23:52 +0000
Message-ID: <e128356a-f56f-4c02-7437-dfea38e4194b@suse.de>
Date:   Wed, 29 Mar 2023 16:23:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [RFC PATCH v2 48/48] sock: Remove ->sendpage*() in favour of
 sendmsg(MSG_SPLICE_PAGES)
To:     David Howells <dhowells@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-doc@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
        linux-sctp@vger.kernel.org, linux-afs@lists.infradead.org,
        rds-devel@oss.oracle.com, linux-x25@vger.kernel.org,
        dccp@vger.kernel.org, linux-rdma@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        linux-wpan@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-hams@vger.kernel.org,
        mptcp@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Christian Brauner <brauner@kernel.org>, netdev@vger.kernel.org,
        Jeff Layton <jlayton@kernel.org>, linux-kernel@vger.kernel.org,
        Chuck Lever III <chuck.lever@oracle.com>,
        tipc-discussion@lists.sourceforge.net,
        linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        bpf@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
References: <20230329141354.516864-1-dhowells@redhat.com>
 <20230329141354.516864-49-dhowells@redhat.com>
Content-Language: en-US
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230329141354.516864-49-dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/29/23 16:13, David Howells wrote:
> [!] Note: This is a work in progress.  At the moment, some things won't
>      build if this patch is applied.  nvme, kcm, smc, tls.
> 
> Remove ->sendpage() and ->sendpage_locked().  sendmsg() with
> MSG_SPLICE_PAGES should be used instead.  This allows multiple pages and
> multipage folios to be passed through.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> Acked-by: Marc Kleine-Budde <mkl@pengutronix.de> # for net/can
> cc: "David S. Miller" <davem@davemloft.net>
> cc: Eric Dumazet <edumazet@google.com>
> cc: Jakub Kicinski <kuba@kernel.org>
> cc: Paolo Abeni <pabeni@redhat.com>
> cc: Jens Axboe <axboe@kernel.dk>
> cc: Matthew Wilcox <willy@infradead.org>
> cc: bpf@vger.kernel.org
> cc: dccp@vger.kernel.org
> cc: linux-afs@lists.infradead.org
> cc: linux-arm-msm@vger.kernel.org
> cc: linux-can@vger.kernel.org
> cc: linux-crypto@vger.kernel.org
> cc: linux-doc@vger.kernel.org
> cc: linux-hams@vger.kernel.org
> cc: linux-kernel@vger.kernel.org
> cc: linux-rdma@vger.kernel.org
> cc: linux-sctp@vger.kernel.org
> cc: linux-wpan@vger.kernel.org
> cc: linux-x25@vger.kernel.org
> cc: mptcp@lists.linux.dev
> cc: netdev@vger.kernel.org
> cc: rds-devel@oss.oracle.com
> cc: tipc-discussion@lists.sourceforge.net
> cc: virtualization@lists.linux-foundation.org
> ---
>   Documentation/networking/scaling.rst |   4 +-
>   crypto/af_alg.c                      |  29 ------
>   crypto/algif_aead.c                  |  22 +----
>   crypto/algif_rng.c                   |   2 -
>   crypto/algif_skcipher.c              |  14 ---
>   include/linux/net.h                  |   8 --
>   include/net/inet_common.h            |   2 -
>   include/net/sock.h                   |   6 --
>   net/appletalk/ddp.c                  |   1 -
>   net/atm/pvc.c                        |   1 -
>   net/atm/svc.c                        |   1 -
>   net/ax25/af_ax25.c                   |   1 -
>   net/caif/caif_socket.c               |   2 -
>   net/can/bcm.c                        |   1 -
>   net/can/isotp.c                      |   1 -
>   net/can/j1939/socket.c               |   1 -
>   net/can/raw.c                        |   1 -
>   net/core/sock.c                      |  35 +------
>   net/dccp/ipv4.c                      |   1 -
>   net/dccp/ipv6.c                      |   1 -
>   net/ieee802154/socket.c              |   2 -
>   net/ipv4/af_inet.c                   |  21 ----
>   net/ipv4/tcp.c                       |  34 -------
>   net/ipv4/tcp_bpf.c                   |  21 +---
>   net/ipv4/tcp_ipv4.c                  |   1 -
>   net/ipv4/udp.c                       |  22 -----
>   net/ipv4/udp_impl.h                  |   2 -
>   net/ipv4/udplite.c                   |   1 -
>   net/ipv6/af_inet6.c                  |   3 -
>   net/ipv6/raw.c                       |   1 -
>   net/ipv6/tcp_ipv6.c                  |   1 -
>   net/key/af_key.c                     |   1 -
>   net/l2tp/l2tp_ip.c                   |   1 -
>   net/l2tp/l2tp_ip6.c                  |   1 -
>   net/llc/af_llc.c                     |   1 -
>   net/mctp/af_mctp.c                   |   1 -
>   net/mptcp/protocol.c                 |   2 -
>   net/netlink/af_netlink.c             |   1 -
>   net/netrom/af_netrom.c               |   1 -
>   net/packet/af_packet.c               |   2 -
>   net/phonet/socket.c                  |   2 -
>   net/qrtr/af_qrtr.c                   |   1 -
>   net/rds/af_rds.c                     |   1 -
>   net/rose/af_rose.c                   |   1 -
>   net/rxrpc/af_rxrpc.c                 |   1 -
>   net/sctp/protocol.c                  |   1 -
>   net/socket.c                         |  48 ---------
>   net/tipc/socket.c                    |   3 -
>   net/unix/af_unix.c                   | 139 ---------------------------
>   net/vmw_vsock/af_vsock.c             |   3 -
>   net/x25/af_x25.c                     |   1 -
>   net/xdp/xsk.c                        |   1 -
>   52 files changed, 9 insertions(+), 447 deletions(-)
> 
Weelll ... what happens to consumers of kernel_sendpage()?
(Let's call them nvme ...)
Should they be moved over, too?

Or what is the general consensus here?

(And what do we do with TLS? It does have a ->sendpage() version, too ...)

Cheers,

Hannes

