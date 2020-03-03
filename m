Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B317917745F
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 11:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728874AbgCCKgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 05:36:31 -0500
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:46851 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728506AbgCCKgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 05:36:31 -0500
X-Originating-IP: 90.89.41.158
Received: from localhost (lfbn-tou-1-1473-158.w90-89.abo.wanadoo.fr [90.89.41.158])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id C1BC940011;
        Tue,  3 Mar 2020 10:36:29 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     dsahern@gmail.com, sd@queasysnail.net
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>, netdev@vger.kernel.org
Subject: [PATCH iproute2-next v2 0/4] macsec: add offloading support
Date:   Tue,  3 Mar 2020 11:36:15 +0100
Message-Id: <20200303103619.818985-1-antoine.tenart@bootlin.com>
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

Giving the offloading mode when a macsec interface is created was
discussed; it is not implemented in this series. It could come later
on, when needed, as we'll still want to support updating the offloading
mode at runtime (what's implemented in this series).

Thanks!
Antoine

Since v1:
  - Added an accessor when accessing the offload_str array. Likewise
    added an accessor for the existing validate_str array.
  - Added a description of the new `macsec offload` command in the man
    page.

Antoine Tenart (4):
  macsec: report the offloading mode currently selected
  macsec: add support for changing the offloading mode
  man: document the ip macsec offload command
  macsec: add an accessor for validate_str

 ip/ipmacsec.c        | 83 ++++++++++++++++++++++++++++++++++++++++++--
 man/man8/ip-macsec.8 |  7 ++++
 2 files changed, 88 insertions(+), 2 deletions(-)

-- 
2.24.1

