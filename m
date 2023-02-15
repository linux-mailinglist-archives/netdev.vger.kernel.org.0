Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66F9969846C
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 20:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjBOTXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 14:23:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjBOTXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 14:23:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9A43B666
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 11:23:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5353B81E4E
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 19:23:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B86C4339B;
        Wed, 15 Feb 2023 19:23:08 +0000 (UTC)
Subject: [PATCH v4 0/2] Another crack at a handshake upcall mechanism
From:   Chuck Lever <chuck.lever@oracle.com>
To:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com
Cc:     netdev@vger.kernel.org, chuck.lever@oracle.com, hare@suse.com,
        dhowells@redhat.com, bcodding@redhat.com, kolga@netapp.com,
        jmeneghi@redhat.com
Date:   Wed, 15 Feb 2023 14:23:07 -0500
Message-ID: <167648817566.5586.11847329328944648217.stgit@91.116.238.104.host.secureserver.net>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi-

Here is v4 of a series to add generic support for transport layer
security handshake on behalf of kernel socket consumers (user space
consumers use a security library directly, of course).

A summary of the purpose of these patches is archived here:

https://lore.kernel.org/netdev/1DE06BB1-6BA9-4DB4-B2AA-07DE532963D6@oracle.com/

This version of the series replaces Classic Netlink infrastructure
with Generic Netlink, as requested. It is again a signficant rewrite
of the previous version of the series. There are several more tasks
to complete, including the creation of a YAML protocol
specification and the ability to return multiple remote peer
identities upon handshake completion.

The full patch set to support SunRPC with TLSv1.3 is available in
the topic-rpc-with-tls-upcall branch here, based on v6.1.12:

   https://git.kernel.org/pub/scm/linux/kernel/git/cel/linux.git

A sample user space handshake agent with netlink support is
available in the "netlink" branch here:

   https://github.com/oracle/ktls-utils

---

Changes since v3:
- Converted all netlink code to use Generic Netlink
- Reworked handshake request lifetime logic throughout
- Global pending list is now per-net
- On completion, return the remote's identity to the consumer

Changes since v2:
- PF_HANDSHAKE replaced with NETLINK_HANDSHAKE
- Replaced listen(2) / poll(2) with a multicast notification service
- Replaced accept(2) with a netlink operation that can return an
  open fd and handshake parameters
- Replaced close(2) with a netlink operation that can take arguments

Changes since RFC:
- Generic upcall support split away from kTLS
- Added support for TLS ServerHello
- Documentation has been temporarily removed while API churns

Chuck Lever (2):
      net/handshake: Create a NETLINK service for handling handshake requests
      net/tls: Add kernel APIs for requesting a TLSv1.3 handshake


 Documentation/networking/index.rst         |   1 +
 Documentation/networking/tls-handshake.rst | 146 ++++++++
 include/net/handshake.h                    |  46 +++
 include/net/net_namespace.h                |   5 +
 include/net/sock.h                         |   1 +
 include/net/tls.h                          |  23 ++
 include/uapi/linux/handshake.h             | 100 ++++++
 net/Makefile                               |   1 +
 net/handshake/Makefile                     |  11 +
 net/handshake/handshake.h                  |  43 +++
 net/handshake/netlink.c                    | 373 ++++++++++++++++++++
 net/handshake/request.c                    | 160 +++++++++
 net/tls/Makefile                           |   2 +-
 net/tls/tls_handshake.c                    | 388 +++++++++++++++++++++
 14 files changed, 1299 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/networking/tls-handshake.rst
 create mode 100644 include/net/handshake.h
 create mode 100644 include/uapi/linux/handshake.h
 create mode 100644 net/handshake/Makefile
 create mode 100644 net/handshake/handshake.h
 create mode 100644 net/handshake/netlink.c
 create mode 100644 net/handshake/request.c
 create mode 100644 net/tls/tls_handshake.c

--
Chuck Lever

