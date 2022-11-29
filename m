Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F005D63CA95
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 22:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236555AbiK2VqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 16:46:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235700AbiK2VqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 16:46:16 -0500
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 863616B3A6;
        Tue, 29 Nov 2022 13:46:14 -0800 (PST)
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 046FE5005E1;
        Wed, 30 Nov 2022 00:33:39 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 046FE5005E1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1669757624; bh=263HAE4gThgLqxBgosD91fhw+CqsFKmvqW1+zdyZEB8=;
        h=From:To:Cc:Subject:Date:From;
        b=gmJLHISmuSGTpXgxJnzbXJWYIzMv32fM7PZU2jgwAtdM9OdAfAvVuCdHBTDs8TufS
         mgUQxuKc3FTGegWRYrk4sRqw7TUrFuqLUTL4CMwKOmvMPG5KH3mojDl/pXCVJCuTOE
         I1EJh5MqIoHgH5/lpuLlNBuobo9yTlymsNwc2uD0=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Vadim Fedorenko <vfedorenko@novek.ru>,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
Subject: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
Date:   Wed, 30 Nov 2022 00:37:20 +0300
Message-Id: <20221129213724.10119-1-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement common API for clock/DPLL configuration and status reporting.
The API utilises netlink interface as transport for commands and event
notifications. This API aim to extend current pin configuration and
make it flexible and easy to cover special configurations.

v3 -> v4:
 * redesign framework to make pins dynamically allocated (Arkadiusz)
 * implement shared pins (Arkadiusz)
v2 -> v3:
 * implement source select mode (Arkadiusz)
 * add documentation
 * implementation improvements (Jakub)
v1 -> v2:
 * implement returning supported input/output types
 * ptp_ocp: follow suggestions from Jonathan
 * add linux-clk mailing list
v0 -> v1:
 * fix code style and errors
 * add linux-arm mailing list


Arkadiusz Kubalewski (1):
  dpll: add dpll_attr/dpll_pin_attr helper classes

Vadim Fedorenko (3):
  dpll: Add DPLL framework base functions
  dpll: documentation on DPLL subsystem interface
  ptp_ocp: implement DPLL ops

 Documentation/networking/dpll.rst  | 271 ++++++++
 Documentation/networking/index.rst |   1 +
 MAINTAINERS                        |   8 +
 drivers/Kconfig                    |   2 +
 drivers/Makefile                   |   1 +
 drivers/dpll/Kconfig               |   7 +
 drivers/dpll/Makefile              |  11 +
 drivers/dpll/dpll_attr.c           | 278 +++++++++
 drivers/dpll/dpll_core.c           | 760 +++++++++++++++++++++++
 drivers/dpll/dpll_core.h           | 176 ++++++
 drivers/dpll/dpll_netlink.c        | 963 +++++++++++++++++++++++++++++
 drivers/dpll/dpll_netlink.h        |  24 +
 drivers/dpll/dpll_pin_attr.c       | 456 ++++++++++++++
 drivers/ptp/Kconfig                |   1 +
 drivers/ptp/ptp_ocp.c              | 123 ++--
 include/linux/dpll.h               | 261 ++++++++
 include/linux/dpll_attr.h          | 433 +++++++++++++
 include/uapi/linux/dpll.h          | 263 ++++++++
 18 files changed, 4002 insertions(+), 37 deletions(-)
 create mode 100644 Documentation/networking/dpll.rst
 create mode 100644 drivers/dpll/Kconfig
 create mode 100644 drivers/dpll/Makefile
 create mode 100644 drivers/dpll/dpll_attr.c
 create mode 100644 drivers/dpll/dpll_core.c
 create mode 100644 drivers/dpll/dpll_core.h
 create mode 100644 drivers/dpll/dpll_netlink.c
 create mode 100644 drivers/dpll/dpll_netlink.h
 create mode 100644 drivers/dpll/dpll_pin_attr.c
 create mode 100644 include/linux/dpll.h
 create mode 100644 include/linux/dpll_attr.h
 create mode 100644 include/uapi/linux/dpll.h

-- 
2.27.0

