Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 894535105FB
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 19:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbiDZR57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 13:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346458AbiDZR56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 13:57:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E0C36329
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 10:54:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E457AB80ECC
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 17:54:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77FD1C385A0;
        Tue, 26 Apr 2022 17:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650995685;
        bh=QYn+MxyoADYmkClypNdQagHn9u+DcUarYZZT5Be1aFc=;
        h=From:To:Cc:Subject:Date:From;
        b=HeUU2savhGB9oTraJ4HOUEmdCbt/Irpvo/v/QPD0GW7KuC8R6tWOAjTucjD87YIMu
         HqeSboub50o/xbRcpy+bxCUzWs8qnCHsQMPG73UfXoYbBOe14NjgOJzhdBwPPxjSqf
         M6euwhUh+ODXZ3uKxzq/ILO+tQ9Q9ATxEzoJ51JQJTRwE6hxfUAllJfCAED9rliB5o
         GiELyp644ycw1AbZcwgtD/3nDomYZvZ1dvJTCSJvOpFIcM6v5ICJq35Af1ECNriDlx
         j7rrvcJCBnsxPAWNW3Y0BuSgOi4a4SWj4em7a8ObECyVCqfNWuvGyjrXNIQIoEj5dI
         oiFMFpuZIsKhQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/6] net: remove non-Ethernet drivers using virt_to_bus()
Date:   Tue, 26 Apr 2022 10:54:30 -0700
Message-Id: <20220426175436.417283-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Networking is currently the main offender in using virt_to_bus().
Frankly all the drivers which use it are super old and unlikely
to be used today. They are just an ongoing maintenance burden.

In other words this series is using virt_to_bus() as an excuse
to shed some old stuff. Having done the tree-wide dev_addr_set()
conversion recently I have limited sympathy for carrying dead
code.

Obviously please scream if any of these drivers _is_ in fact
still being used. Otherwise let's take the chance, we can always
apologize and revert if users show up later.

Also I should say thanks to everyone who contributed to this code!
The work continues to be appreciated although realistically in more
of a "history book" fashion...

Jakub Kicinski (6):
  net: atm: remove support for Fujitsu FireStream ATM devices
  net: atm: remove support for Madge Horizon ATM devices
  net: atm: remove support for ZeitNet ZN122x ATM devices
  net: wan: remove support for COSA and SRP synchronous serial boards
  net: wan: remove support for Z85230-based devices
  net: hamradio: remove support for DMA SCC devices

 Documentation/admin-guide/devices.txt         |    2 +-
 .../networking/device_drivers/index.rst       |    1 -
 .../networking/device_drivers/wan/index.rst   |   18 -
 .../device_drivers/wan/z8530book.rst          |  256 --
 MAINTAINERS                                   |    7 -
 arch/mips/configs/gpr_defconfig               |    3 -
 arch/mips/configs/mtx1_defconfig              |    3 -
 drivers/atm/Kconfig                           |   54 -
 drivers/atm/Makefile                          |    3 -
 drivers/atm/firestream.c                      | 2057 ------------
 drivers/atm/firestream.h                      |  502 ---
 drivers/atm/horizon.c                         | 2853 -----------------
 drivers/atm/horizon.h                         |  492 ---
 drivers/atm/uPD98401.h                        |  293 --
 drivers/atm/uPD98402.c                        |  266 --
 drivers/atm/uPD98402.h                        |  107 -
 drivers/atm/zatm.c                            | 1652 ----------
 drivers/atm/zatm.h                            |  104 -
 drivers/net/hamradio/Kconfig                  |   34 -
 drivers/net/hamradio/Makefile                 |    1 -
 drivers/net/hamradio/dmascc.c                 | 1450 ---------
 drivers/net/wan/Kconfig                       |   44 -
 drivers/net/wan/Makefile                      |    3 -
 drivers/net/wan/cosa.c                        | 2052 ------------
 drivers/net/wan/cosa.h                        |  104 -
 drivers/net/wan/hostess_sv11.c                |  336 --
 drivers/net/wan/sealevel.c                    |  352 --
 drivers/net/wan/z85230.c                      | 1641 ----------
 drivers/net/wan/z85230.h                      |  407 ---
 include/uapi/linux/atm_zatm.h                 |   47 -
 30 files changed, 1 insertion(+), 15143 deletions(-)
 delete mode 100644 Documentation/networking/device_drivers/wan/index.rst
 delete mode 100644 Documentation/networking/device_drivers/wan/z8530book.rst
 delete mode 100644 drivers/atm/firestream.c
 delete mode 100644 drivers/atm/firestream.h
 delete mode 100644 drivers/atm/horizon.c
 delete mode 100644 drivers/atm/horizon.h
 delete mode 100644 drivers/atm/uPD98401.h
 delete mode 100644 drivers/atm/uPD98402.c
 delete mode 100644 drivers/atm/uPD98402.h
 delete mode 100644 drivers/atm/zatm.c
 delete mode 100644 drivers/atm/zatm.h
 delete mode 100644 drivers/net/hamradio/dmascc.c
 delete mode 100644 drivers/net/wan/cosa.c
 delete mode 100644 drivers/net/wan/cosa.h
 delete mode 100644 drivers/net/wan/hostess_sv11.c
 delete mode 100644 drivers/net/wan/sealevel.c
 delete mode 100644 drivers/net/wan/z85230.c
 delete mode 100644 drivers/net/wan/z85230.h
 delete mode 100644 include/uapi/linux/atm_zatm.h

-- 
2.34.1

