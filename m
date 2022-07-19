Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47678579019
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 03:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236279AbiGSBvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 21:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234108AbiGSBvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 21:51:45 -0400
X-Greylist: delayed 314 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 18 Jul 2022 18:51:43 PDT
Received: from smtp96.ord1c.emailsrvr.com (smtp96.ord1c.emailsrvr.com [108.166.43.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9574ABBF
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 18:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=openvpn.net;
        s=20170822-45nk5nwl; t=1658195188;
        bh=v86zbFkNmLa4Q1zDZyb65YsBcagrBcLQ0LSg0jY1sUE=;
        h=From:To:Subject:Date:From;
        b=PoDI3JKsno8CMF5seVWru+OMHmaISRO4GEwvjCSNzq9R6q3auv44EuromiOVAgZ6Q
         B7tUZnSUYUVCOPXissEhRT24sJjQ7xI9DUOffOKcvGljadk4JM6PdU3fQ3TjxxZIMb
         IpeTAM4XSumo/dTF8FdxhkoYom9wPi8zgshf/qAo=
X-Auth-ID: antonio@openvpn.net
Received: by smtp13.relay.ord1c.emailsrvr.com (Authenticated sender: antonio-AT-openvpn.net) with ESMTPSA id CA826A0116;
        Mon, 18 Jul 2022 21:46:27 -0400 (EDT)
From:   Antonio Quartulli <antonio@openvpn.net>
To:     netdev@vger.kernel.org
Cc:     Antonio Quartulli <antonio@openvpn.net>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [RFC 0/1] Introducing OpenVPN Data Channel Offload
Date:   Tue, 19 Jul 2022 03:47:03 +0200
Message-Id: <20220719014704.21346-1-antonio@openvpn.net>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Classification-ID: d34e7317-6ebb-43b3-b845-a9b2dd2374c9-1-1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all!

With this RFC I want to introduce OpenVPN Data Channel Offload (DCO), also
known as ovpn-dco.

The OpenVPN community has since long been interested in moving the fast path
to kernel space. Ovpn-dco finally helps achieving this goal.

Ovpn-dco is essentialy a device driver that allows creating a virtual
network interface to handle the OpenVPN data channel. Any traffic
entering the interface is encrypted, encapsulated and sent to the
appropriate destination.

Despite technically possible, ovpn-dco requires OpenVPN in userspace
to run along its side in order to be properly configured and maintained
during its life cycle.

The ovpn-dco interface can be created/destroyed via RTNL and then
configured via Netlink API.

Specifically OpenVPN in userspace will:
* create the ovpn-dco interface
* establish the connection with one or more peers
* perform TLS handshake and negotiate any protocol parameter
* configure the ovpn-dco interface with peer data (ip/port, keys, etc.)
* handle any subsequent control channel communication

I'd like to point out the control channel is fully handles in userspace.
The idea is to keep the ovpn-dco kernel module as simple as possible and
let userspace handle all the non-data (non-fast-path) features.

Please note that the userspace code requires to driver an ovpn-dco
interface is currently under review and is still being merged to the
OpenVPN master branch. This code will be released with OpenVPN 2.6
(later this year).

If you want to test ovpn-dco, for the time being you need to switch to
the "dco" branch of the official repo hosted at
https://github.com/OpenVPN/openvpn (or at our GitLab mirror).

Note that OpenVPN3-Linux (https://github.com/OpenVPN/openvpn3-linux)
already supports ovpn-dco since a while, but this software is client
only.

The ovpn-dco code that can be built as out-of-tree module is available
here https://github.com/OpenVPN/ovpn-dco (we try to keep some
compatibility with older kernels too).

In the past months I also created an OpenWRT feed in order to allow
developers to test ovpn-dco, available at
https://github.com/OpenVPN/openvpn-dev-openwrt

For more technical details please refer to the actual patch commit message.

Please note that the patch touches also a few files outside of the
ovpn-dco folder.
Specifically it adds a new macro named NLA_POLICY_MAX_LEN to net/netlink.h
and also adds a new constant named UDP_ENCAP_OVPNINUDP to linux/udp.h.

With this RFC I would love to get some feedback from the netdev and
kernel community in the attempt of reaching a status where ovpn-dco
could be merged upstream.

Any comment, concern, statement will be appreciated.

Thanks a lot!

Best Regards,

Antonio Quartulli
OpenVPN Inc.

---

Antonio Quartulli (1):
  net: introduce OpenVPN Data Channel Offload (ovpn-dco)

 MAINTAINERS                        |    8 +
 drivers/net/Kconfig                |   19 +
 drivers/net/Makefile               |    1 +
 drivers/net/ovpn-dco/Makefile      |   21 +
 drivers/net/ovpn-dco/addr.h        |   41 +
 drivers/net/ovpn-dco/bind.c        |   62 ++
 drivers/net/ovpn-dco/bind.h        |   67 ++
 drivers/net/ovpn-dco/crypto.c      |  154 ++++
 drivers/net/ovpn-dco/crypto.h      |  144 ++++
 drivers/net/ovpn-dco/crypto_aead.c |  369 +++++++++
 drivers/net/ovpn-dco/crypto_aead.h |   27 +
 drivers/net/ovpn-dco/main.c        |  281 +++++++
 drivers/net/ovpn-dco/main.h        |   39 +
 drivers/net/ovpn-dco/netlink.c     | 1132 ++++++++++++++++++++++++++++
 drivers/net/ovpn-dco/netlink.h     |   22 +
 drivers/net/ovpn-dco/ovpn.c        |  597 +++++++++++++++
 drivers/net/ovpn-dco/ovpn.h        |   43 ++
 drivers/net/ovpn-dco/ovpnstruct.h  |   59 ++
 drivers/net/ovpn-dco/peer.c        |  878 +++++++++++++++++++++
 drivers/net/ovpn-dco/peer.h        |  168 +++++
 drivers/net/ovpn-dco/pktid.c       |  127 ++++
 drivers/net/ovpn-dco/pktid.h       |  116 +++
 drivers/net/ovpn-dco/proto.h       |  101 +++
 drivers/net/ovpn-dco/rcu.h         |   21 +
 drivers/net/ovpn-dco/skb.h         |   54 ++
 drivers/net/ovpn-dco/sock.c        |  134 ++++
 drivers/net/ovpn-dco/sock.h        |   54 ++
 drivers/net/ovpn-dco/stats.c       |   20 +
 drivers/net/ovpn-dco/stats.h       |   67 ++
 drivers/net/ovpn-dco/tcp.c         |  324 ++++++++
 drivers/net/ovpn-dco/tcp.h         |   38 +
 drivers/net/ovpn-dco/udp.c         |  338 +++++++++
 drivers/net/ovpn-dco/udp.h         |   25 +
 include/net/netlink.h              |    1 +
 include/uapi/linux/ovpn_dco.h      |  265 +++++++
 include/uapi/linux/udp.h           |    1 +
 36 files changed, 5818 insertions(+)
 create mode 100644 drivers/net/ovpn-dco/Makefile
 create mode 100644 drivers/net/ovpn-dco/addr.h
 create mode 100644 drivers/net/ovpn-dco/bind.c
 create mode 100644 drivers/net/ovpn-dco/bind.h
 create mode 100644 drivers/net/ovpn-dco/crypto.c
 create mode 100644 drivers/net/ovpn-dco/crypto.h
 create mode 100644 drivers/net/ovpn-dco/crypto_aead.c
 create mode 100644 drivers/net/ovpn-dco/crypto_aead.h
 create mode 100644 drivers/net/ovpn-dco/main.c
 create mode 100644 drivers/net/ovpn-dco/main.h
 create mode 100644 drivers/net/ovpn-dco/netlink.c
 create mode 100644 drivers/net/ovpn-dco/netlink.h
 create mode 100644 drivers/net/ovpn-dco/ovpn.c
 create mode 100644 drivers/net/ovpn-dco/ovpn.h
 create mode 100644 drivers/net/ovpn-dco/ovpnstruct.h
 create mode 100644 drivers/net/ovpn-dco/peer.c
 create mode 100644 drivers/net/ovpn-dco/peer.h
 create mode 100644 drivers/net/ovpn-dco/pktid.c
 create mode 100644 drivers/net/ovpn-dco/pktid.h
 create mode 100644 drivers/net/ovpn-dco/proto.h
 create mode 100644 drivers/net/ovpn-dco/rcu.h
 create mode 100644 drivers/net/ovpn-dco/skb.h
 create mode 100644 drivers/net/ovpn-dco/sock.c
 create mode 100644 drivers/net/ovpn-dco/sock.h
 create mode 100644 drivers/net/ovpn-dco/stats.c
 create mode 100644 drivers/net/ovpn-dco/stats.h
 create mode 100644 drivers/net/ovpn-dco/tcp.c
 create mode 100644 drivers/net/ovpn-dco/tcp.h
 create mode 100644 drivers/net/ovpn-dco/udp.c
 create mode 100644 drivers/net/ovpn-dco/udp.h
 create mode 100644 include/uapi/linux/ovpn_dco.h

-- 
2.35.1

