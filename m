Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2F0A463C68
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 18:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244532AbhK3RFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 12:05:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244500AbhK3RFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 12:05:19 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9F5C061746
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 09:02:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6909FCE1752
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 17:01:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB07DC53FCD;
        Tue, 30 Nov 2021 17:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638291716;
        bh=rqtdftXIpIvI7ZkRWe1on+X8o5DVuoG9+bXlci6RdIk=;
        h=From:To:Cc:Subject:Date:From;
        b=b/3cw8VpPAYoxzJNphjEKfCJXf8WAFZVZavThQJqvJ8dTP51z9K42uX2zy/l2Vk2E
         X1DoQ3/X3Zzdj7McRRfbDtozYsyjdb0cSBDCXK1CXFo1vZTaCSnurqmJgYp0M3bzFa
         K+FZoCYdEDstPkUsj/L8+g0dLkBWVdZDZ8nF/89xTwwwjvGg4Q52BVdP3+4Zo24KzU
         wDdnrxB4YhrEtK0kL1Vbn/icr2MaG6VDC3oVRQ7zyNy62klOGmBkiNhVP6wmMLHx4o
         1rHKA/LH8Skeb/Cuch3YNxuZOY6AO82lr+oFdid/psdEnwE/gBj3AVUseDCSgX1/Cn
         i049Bdlf/Bchw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net v2 0/6] mv88e6xxx fixes (mainly 88E6393X family)
Date:   Tue, 30 Nov 2021 18:01:45 +0100
Message-Id: <20211130170151.7741-1-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

sending v2 of these fixes.

Original cover letter:

So I managed to discovered how to fix inband AN for 2500base-x mode on
88E6393x (Amethyst) family.

This series fixes application of erratum 4.8, adds fix for erratum 5.2,
adds support for completely disablign SerDes receiver / transmitter,
fixes inband AN for 2500base-x mode by using 1000base-x mode and simply
changing frequeny to 3.125 GHz, all this for 88E6393X.

The last commit fixes linking when link partner has AN disabled and the
device invokes the AN bypass feature. Currently we fail to link in this
case.

Changes since v1:
- fixed wrong operator in patch 3 (thanks Russell)
- added more comments about why BMCR_ANENABLE is used in patch 6 (thanks
  Russell)
- updated some return statements from
     if (something)
       return func();
     return 0;
  to
     if (something)
       err = func();
     return err;
  (err is set to 0 before the condition)

Marek

Marek Behún (6):
  net: dsa: mv88e6xxx: Fix application of erratum 4.8 for 88E6393X
  net: dsa: mv88e6xxx: Drop unnecessary check in
    mv88e6393x_serdes_erratum_4_6()
  net: dsa: mv88e6xxx: Save power by disabling SerDes trasmitter and
    receiver
  net: dsa: mv88e6xxx: Add fix for erratum 5.2 of 88E6393X family
  net: dsa: mv88e6xxx: Fix inband AN for 2500base-x on 88E6393X family
  net: dsa: mv88e6xxx: Link in pcs_get_state() if AN is bypassed

 drivers/net/dsa/mv88e6xxx/serdes.c | 252 +++++++++++++++++++++++++----
 drivers/net/dsa/mv88e6xxx/serdes.h |   4 +
 2 files changed, 224 insertions(+), 32 deletions(-)

-- 
2.32.0

