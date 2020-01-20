Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8341432CF
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 21:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgATUS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 15:18:29 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:49295 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbgATUS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 15:18:29 -0500
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 6AEE71C0007;
        Mon, 20 Jan 2020 20:18:27 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     dsahern@gmail.com, sd@queasysnail.net
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>, netdev@vger.kernel.org
Subject: [PATCH iproute2-next 0/2] macsec: add offloading support
Date:   Mon, 20 Jan 2020 21:18:21 +0100
Message-Id: <20200120201823.887937-1-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

This series adds support for selecting and reporting the offloading mode
of a MACsec interface. Available modes are for now 'off' and 'phy',
'off' being the default when an interface is created. Modes are not only
'off' and 'on' as the MACsec operations can be offloaded to multiple
kinds of specialized hardware devices, at least to PHYs and Ethernet
MACs. The later isn't currently supported in the kernel though.

The first patch adds support for reporting the offloading mode currently
selected for a given MACsec interface through the `ip macsec show`
command:

   # ip macsec show
   18: macsec0: protect on validate strict sc off sa off encrypt on send_sci on end_station off scb off replay off
       cipher suite: GCM-AES-128, using ICV length 16
       TXSC: 3e5035b67c860001 on SA 0
           0: PN 1, state on, key 00000000000000000000000000000000
       RXSC: b4969112700f0001, state on
           0: PN 1, state on, key 01000000000000000000000000000000
->     offload: phy
   19: macsec1: protect on validate strict sc off sa off encrypt on send_sci on end_station off scb off replay off
       cipher suite: GCM-AES-128, using ICV length 16
       TXSC: 3e5035b67c880001 on SA 0
           1: PN 1, state on, key 00000000000000000000000000000000
       RXSC: b4969112700f0001, state on
           1: PN 1, state on, key 01000000000000000000000000000000
->     offload: off

The second patch allows an user to change the offloading mode at runtime
through a new subcommand, `ip macsec offload`:

  # ip macsec offload macsec0 phy
  # ip macsec offload macsec0 off

If a mode isn't supported, `ip macsec offload` will report an issue
(-EOPNOTSUPP).

One thing not supported in this series would be the ability to list all
supported modes (for now 'off' and 'phy') depending on the h/w interface
capabilities. This can come up in a later patch, as this is not critical
to get the feature used, but I would like this to be compatible with the
current series. I can think of 2 possibilities: either through
`ip macsec show` or through `ip macsec offload` (for example when no
argument is given). What are your thoughts on this?

Thanks!
Antoine

Antoine Tenart (2):
  macsec: report the offloading mode currently selected
  macsec: add support for changing the offloading mode

 ip/ipmacsec.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

-- 
2.24.1

