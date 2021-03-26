Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A17FD34B01C
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 21:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhCZUXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 16:23:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:41212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230134AbhCZUW2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 16:22:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32C0161A02;
        Fri, 26 Mar 2021 20:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616790148;
        bh=ddnL4s7v9wNRvgNJHmRcz23Wtlt0n1J4XmQZLmnpSQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hvYDKBNU001fcZ6NlR2FFTlvQzQ/Tp9qlULbX5BhidZYvLG9JoxryZlYKN8EoTLcA
         Xx4EAjN8ihiEzTv5Gz6e+dAVK4icgGdU5Mv9UiJ/Fbz+N1D9Sx2J5Ib7DUx2t0Id+H
         ZC6w0+1LK4FhET5/1VXMcqdUlSWipWtiFoh86CzJpl/H43y4KHK1cfl5ouWyo00FrQ
         RiTIxDrLydB4bXPWEp/raTg0CAvUywU5NfBQMlKuLPOdVl6ViAAGmuqxZFHfbf0HA5
         P+x5ifTR8V/XVyrL0zBADCUFsbPmr9lt7eDXNLB5QyqY6GgDLU7wWkPEvLoeo15ctK
         xmTlM66fOljmg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, mkubecek@suse.cz,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/3] ethtool: fec: add note about reuse of reserved
Date:   Fri, 26 Mar 2021 13:22:21 -0700
Message-Id: <20210326202223.302085-2-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210326202223.302085-1-kuba@kernel.org>
References: <20210326202223.302085-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct ethtool_fecparam::reserved can't be used in SET, because
ethtool user space doesn't zero-initialize the structure.
Make this clear.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/uapi/linux/ethtool.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index f6ef7d42c7a1..9a47c3efd8ca 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1382,6 +1382,10 @@ struct ethtool_per_queue_op {
  * @fec: Bitmask of configured FEC modes.
  * @reserved: Reserved for future extensions, ignore on GET, write 0 for SET.
  *
+ * Note that @reserved was never validated on input and ethtool user space
+ * left it uninitialized when calling SET. Hence going forward it can only be
+ * used to return a value to userspace with GET.
+ *
  * FEC modes supported by the device can be read via %ETHTOOL_GLINKSETTINGS.
  * FEC settings are configured by link autonegotiation whenever it's enabled.
  * With autoneg on %ETHTOOL_GFECPARAM can be used to read the current mode.
-- 
2.30.2

