Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35FF54BB1A3
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 06:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbiBRFvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 00:51:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiBRFvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 00:51:37 -0500
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF383D1F8;
        Thu, 17 Feb 2022 21:51:20 -0800 (PST)
Received: by codeconstruct.com.au (Postfix, from userid 10001)
        id 7533E202C6; Fri, 18 Feb 2022 13:51:18 +0800 (AWST)
From:   Matt Johnston <matt@codeconstruct.com.au>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org,
        Zev Weiss <zev@bewilderbeest.net>
Subject: [PATCH net-next v6 0/2] MCTP I2C driver
Date:   Fri, 18 Feb 2022 13:51:04 +0800
Message-Id: <20220218055106.1944485-1-matt@codeconstruct.com.au>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds a netdev driver providing MCTP transport over
I2C. 

I think I've addressed all the points raised in v5. It now has
mctp_i2c_unregister() to run things in the correct order, waiting for
the worker thread and I2C rx to complete.

Cheers,
Matt

--

v6:
 - Changed netdev register/unregister/free to avoid races. Ensure that
   netif functions are not used by irq handler/threads after unregister.
 - Fix incoming I2C hwaddr that was previously incorrect (left 
   shifted 1 bit)
 - Add a check that byte_count wire header matches the length received
 - Renamed I2C driver to mctp-i2c-interface
 - Removed __func__ from print messages, added missing newlines
 - Removed sysfs mctp_current_mux file which was used for debug
 - Renamed curr_lock to sel_lock
 - Tidied comment formatting
 - Fix newline in Kconfig
v5:
 - Fix incorrect format string
v4:
 - Switch to __i2c_transfer() rather than __i2c_smbus_xfer(), drop 255 byte
   smbus patches
 - Use wait_event_idle() for the sleeping TX thread
 - Use dev_addr_set()
v3:
 - Added Reviewed-bys for npcm7xx
 - Resend with net-next open
v2:
 - Simpler Kconfig condition for i2c-mux dependency, from Randy Dunlap


Matt Johnston (2):
  dt-bindings: net: New binding mctp-i2c-controller
  mctp i2c: MCTP I2C binding driver

 Documentation/devicetree/bindings/i2c/i2c.txt |    4 +
 .../bindings/net/mctp-i2c-controller.yaml     |   92 ++
 drivers/net/mctp/Kconfig                      |   12 +
 drivers/net/mctp/Makefile                     |    1 +
 drivers/net/mctp/mctp-i2c.c                   | 1081 +++++++++++++++++
 5 files changed, 1190 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/mctp-i2c-controller.yaml
 create mode 100644 drivers/net/mctp/mctp-i2c.c

-- 
2.32.0

