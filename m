Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5911E525842
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 01:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359469AbiELX2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 19:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359468AbiELX2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 19:28:22 -0400
Received: from mxd2.seznam.cz (mxd2.seznam.cz [IPv6:2a02:598:2::210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BEB25D5C3;
        Thu, 12 May 2022 16:28:19 -0700 (PDT)
Received: from email.seznam.cz
        by email-smtpc12b.ng.seznam.cz (email-smtpc12b.ng.seznam.cz [10.23.14.105])
        id 37d74adad37b99e4360aebb4;
        Fri, 13 May 2022 01:28:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seznam.cz; s=beta;
        t=1652398089; bh=AN1Ebqidtw04jZtRI8UuItFChCdPVEmjmNzRgnKjwFQ=;
        h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:X-szn-frgn:X-szn-frgc;
        b=Tk7oTHNnEEeklfYav34ODYOyQmjGVFYqWh064DybJqTGVlRcu9n62DoHObRvu2NFT
         GgAPNGSgkW+b90MnNEHRigeg5n1Qk55ayv9c4ZRspsmCsh2282Xz0zhkncMWJU7MiO
         wlkoumAW576tBRkrYAzKV53jHCLJdzcKiWuSE3ec=
Received: from localhost.localdomain (ip-89-176-234-80.net.upcbroadband.cz [89.176.234.80])
        by email-relay29.ng.seznam.cz (Seznam SMTPD 1.3.136) with ESMTP;
        Fri, 13 May 2022 01:28:03 +0200 (CEST)  
From:   Matej Vasilevski <matej.vasilevski@seznam.cz>
To:     linux-can@vger.kernel.org, mkl@pengutronix.de,
        pisa@cmp.felk.cvut.cz
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        ondrej.ille@gmail.com, martin.jerabek01@gmail.com,
        matej.vasilevski@seznam.cz
Subject: [RFC] can: ctucanfd: RX timestamping implementation
Date:   Fri, 13 May 2022 01:27:04 +0200
Message-Id: <20220512232706.24575-1-matej.vasilevski@seznam.cz>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-szn-frgn: <b50df9af-4ecf-4bac-a186-9da2c845e65c>
X-szn-frgc: <0>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I would like to upstream my timestamping patch for CTU CAN FD IP core,
but I guess it won't be that easy, so this is only an RFC.

I'm using the timecounter/cyclecounter structures as has been recommended
(basically copied from the mcp251xfd). But the hard part here is passing
information to the driver, because the timestaping counter width and
frequency isn't defined in the IP core specs.

So currently I take both the counter width and frequency from Device Tree.
The frequency can be specified in the form of second clock in "clocks"
property (which seems good to me, because then the timestamping clock
would be initialized and managed automatically, in case the clock isn't
the same as the main clock). Or directly in "ts-frequency" property.
Counter bit width is specified in the "ts-bit-width" property.
This means that PCI devices currently can't report timestamps (because
Device Tree isn't used for PCI devices).
Alternatively, I could use module parameters, but those are frowned
upon. Module_param also uses static variables, which means one parameter
would be shared across multiple ctucanfd devices, which isn't great
either.

This patch also introduces another Kconfig option:
CAN_CTUCANFD_PLATFORM_ENABLE_HW_TIMESTAMPS to control whether timestamps
are enabled by default. I've done this for cases when somebody would
like to disable timestamping (be it for performance reasons or
whatever). Seems to me better than having to run some script after
startup which would disable timestamping. I don't know which tool does
can do this (ethtool/ip-link?), but I guess it would require the
.ndo_eth_ioctl callback in the driver.

Looking forward to some comments/feedback.

Thank you, yours sincerely,
Matej Vasilevski



