Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26E1C62186A
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 16:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234143AbiKHPfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 10:35:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234607AbiKHPfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 10:35:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ED0459FD1
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 07:35:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16BBAB81B24
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 15:35:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 670E8C433C1;
        Tue,  8 Nov 2022 15:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667921702;
        bh=eebeys5bTekrBKL2ZsOyal9OnTqSqNn201aq5XC28jo=;
        h=From:To:Cc:Subject:Date:From;
        b=lQgRQ2RrBXVAhQbnumY2llRBQLcbsvOUr2biESZcffw4HNdo0hnyt6rYRSYVWzbwj
         NHRBEGQn9F/TSA4W2BuC4Sm7yvWJI0K3uVhjoZWu+ypXiYIP4ayymeZg9sP4OBeTsd
         wzkMw65XQGIV1ofV4xrEabNixtkdVeCfQ62Al+imBe2+NhDF62c53JKcih7eyEP3GG
         RSclg43OEygMcAKBrC2zfFuY3lstUT6OLrQotvvsX+EDhh6hVyh0vv5vfhHKKiawaE
         dKlUu5A+k/3azvSvPXoCK5NQqukfEvnIT+3O05bG0EuhCIBRx1X2v1OTEzE9bLpMvh
         6E02RzNh0WLJQ==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Antoine Tenart <atenart@kernel.org>, sd@queasysnail.net,
        irusskikh@marvell.com, netdev@vger.kernel.org
Subject: [PATCH net 0/2] macsec: clear encryption keys in h/w drivers
Date:   Tue,  8 Nov 2022 16:34:57 +0100
Message-Id: <20221108153459.811293-1-atenart@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Commit aaab73f8fba4 ("macsec: clear encryption keys from the stack after
setting up offload") made sure to clean encryption keys from the stack
after setting up offloading but some h/w drivers did a copy of the key
which need to be zeroed as well.

The MSCC PHY driver can actually be converted not to copy the encryption
key at all, but such patch would be quite difficult to backport. I'll
send a following up patch doing this in net-next once this series lands.

Tested on the MSCC PHY but not on the atlantic NIC.

Thanks,
Antoine

Antoine Tenart (2):
  net: phy: mscc: macsec: clear encryption keys when freeing a flow
  net: atlantic: macsec: clear encryption keys from the stack

 .../net/ethernet/aquantia/atlantic/aq_macsec.c |  2 ++
 .../aquantia/atlantic/macsec/macsec_api.c      | 18 +++++++++++-------
 drivers/net/phy/mscc/mscc_macsec.c             |  1 +
 3 files changed, 14 insertions(+), 7 deletions(-)

-- 
2.38.1

