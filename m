Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2EA134F30
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 22:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbgAHV7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 16:59:19 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:47029 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbgAHV7T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 16:59:19 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 29dd440d;
        Wed, 8 Jan 2020 20:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:mime-version:content-transfer-encoding;
         s=mail; bh=BYJF5aJT7larlO1XySbP18XykXM=; b=ifKqMyTnIpy0VP+yghNG
        JaxPorCSaHbbcIgUMhrCE0iDpdscrhEh7n6M304qQIn8wSh8WVup82QGemkslSYg
        1SFq4EKJlpn9dnCBoaZjDjCigBbMynl4GeGs0EFfThVndq0b8F8Fpw9y3tnX1BdN
        3Z5lKDc22fBSwnnwUMU112q+nxjl1r5gImhKSsUH9sCA9BxwsMG6Be1UVIh3nSxX
        yti+rBE0tPquWYEBAgJja5GPACm8rB1gHu/BoullTmmE6jyegOAZ9EXEpK6AvO5s
        HDPxFB5Guk7L+Cand21fZtNl5WE07SY4MsCMH4aGzuYed6K9p3/ZL/2l+dSqdp+4
        Fw==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 1058fa27 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Wed, 8 Jan 2020 20:59:59 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net,
        siva.kallam@broadcom.com, christopher.lee@cspi.com,
        ecree@solarflare.com, johannes.berg@intel.com
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 0/8] reduce open coded skb->next access for gso segment walking
Date:   Wed,  8 Jan 2020 16:59:01 -0500
Message-Id: <20200108215909.421487-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset introduces the skb_list_walk_safe helper macro, in order
to add some sanity to the myrid ways drivers have of walking through gso
segments. The goal is to reduce future bugs commonly caused by open
coding these sorts of things, and to in the future make it easier to
swap out the underlying list representation.

This first patch series addresses the easy uses of drivers iterating
over the returned list of skb_gso_segments, for drivers that live in
drivers/net/*. There are still other use cases to tackle later for
net/*, and after these low-hanging fruits are taken care of, I imagine
there are more subtle cases of gso segment walking that isn't just a
direct return value from skb_gso_segments, and eventually this will have
to be tackled. This series is the first in that direction.

Jason A. Donenfeld (8):
  net: introduce skb_list_walk_safe for skb segment walking
  net: tap: use skb_list_walk_safe helper for gso segments
  net: r8152: use skb_list_walk_safe helper for gso segments
  net: tg3: use skb_list_walk_safe helper for gso segments
  net: sunvnet: use skb_list_walk_safe helper for gso segments
  net: sfc: use skb_list_walk_safe helper for gso segments
  net: myri10ge: use skb_list_walk_safe helper for gso segments
  net: iwlwifi: use skb_list_walk_safe helper for gso segments

 drivers/net/ethernet/broadcom/tg3.c              | 12 +++++-------
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c |  8 +++-----
 drivers/net/ethernet/sfc/tx.c                    |  7 ++-----
 drivers/net/ethernet/sun/sunvnet_common.c        |  9 +++------
 drivers/net/tap.c                                | 14 ++++++--------
 drivers/net/usb/r8152.c                          | 12 +++++-------
 drivers/net/wireguard/device.h                   |  8 --------
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c      |  9 ++-------
 include/linux/skbuff.h                           |  5 +++++
 9 files changed, 31 insertions(+), 53 deletions(-)

-- 
2.24.1

