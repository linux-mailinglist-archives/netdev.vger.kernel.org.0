Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4208639C90
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 20:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiK0TSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 14:18:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiK0TSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 14:18:48 -0500
Received: from fritzc.com (mail.fritzc.com [IPv6:2a00:17d8:100::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E53F3A4;
        Sun, 27 Nov 2022 11:18:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=fritzc.com;
        s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:Cc:
        To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=C+mZx1Eg6bo4mfX+DFliuwOi9n3vRN8QYXoOJN3XKzg=; b=jWzEMUkiw2c8kHimMLq5YPfDMl
        8zx4jM3k6D+Xz0eHpryqHe8swrxyjuF7KWjH7U2bmjfjsIsHm47K8DRbjiHmZrb9Kok/yNnrJlDxJ
        H6NhXquUI/+PJ+mOlS82Qp+x7QxxDMs9Aru7mrg+GyOSz1Qn/esHMtGdAF32cSRo5O9o=;
Received: from 127.0.0.1
        by fritzc.com with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim latest)
        (envelope-from <christoph.fritz@hexdev.de>)
        id 1ozMvf-000XD6-0c; Sun, 27 Nov 2022 20:03:03 +0100
From:   Christoph Fritz <christoph.fritz@hexdev.de>
To:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Richard Weinberger <richard@nod.at>,
        Andreas Lauser <andreas.lauser@mbition.io>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 0/2] LIN support for Linux
Date:   Sun, 27 Nov 2022 20:02:42 +0100
Message-Id: <20221127190244.888414-1-christoph.fritz@hexdev.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam_score: -1.0
X-Spam_bar: -
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The intention of this series is to kick off a discussion about how to
support LIN (ISO 17987) [0] in Linux.

This series consist of two patches which are two individual proposals
for adding LIN abstraction into the kernel.

One approach is to add LIN ontop of CANFD:
  [RFC] can: introduce LIN abstraction

The other approach is adding a new type of CAN-socket:
  [RFC] can: Add LIN proto skeleton

These patches are abstracting LIN so that actual device drivers can
make use of it.

For reference, the LIN-ontop-of-CANFD variant already has a device
driver using it (not part of this series). It is a specially built USB
LIN-BUS adapter hardware called hexLIN [1].  Its purpose is mainly to
test, adapt and discuss different LIN APIs for mainline Linux kernel.
But it can already be used productively as a Linux LIN node in
controller (master) and responder (slave) mode. By sysfs, hexLIN
supports different checksum calculations and setting up a
responder-table.

For more info about hexLIN, see link below [1].

We are looking for partners with Linux based LIN projects for funding. 

[0]: https://en.wikipedia.org/wiki/Local_Interconnect_Network
[1]: https://hexdev.de/hexlin/

Christoph Fritz (1):
  [RFC] can: Introduce LIN bus as CANFD abstraction

Richard Weinberger (1):
  [RFC] can: Add LIN proto skeleton

 drivers/net/can/Kconfig          |  10 ++
 drivers/net/can/Makefile         |   1 +
 drivers/net/can/lin.c            | 181 +++++++++++++++++++++++++++
 include/net/lin.h                |  30 +++++
 include/uapi/linux/can.h         |   8 +-
 include/uapi/linux/can/lin.h     |  15 +++
 include/uapi/linux/can/netlink.h |   1 +
 net/can/Kconfig                  |   5 +
 net/can/Makefile                 |   3 +
 net/can/lin.c                    | 207 +++++++++++++++++++++++++++++++
 10 files changed, 460 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/can/lin.c
 create mode 100644 include/net/lin.h
 create mode 100644 include/uapi/linux/can/lin.h
 create mode 100644 net/can/lin.c

-- 
2.30.2

