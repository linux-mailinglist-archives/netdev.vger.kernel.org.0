Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F3F26AF17
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 23:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbgIOVCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 17:02:30 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37090 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728068AbgIOUoG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 16:44:06 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kIHnz-00Eomd-BX; Tue, 15 Sep 2020 22:43:59 +0200
Date:   Tue, 15 Sep 2020 22:43:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net-next v2 00/10] make drivers/net/ethernet W=1 clean
Message-ID: <20200915204359.GF3526428@lunn.ch>
References: <20200915014455.1232507-1-jesse.brandeburg@intel.com>
 <a28498acdf87f11e81d3282d63f18dbe1a3d5329.camel@kernel.org>
 <20200915140326.GG3485708@lunn.ch>
 <734f0c4595a18ab136263b6e5c97e7f48a93abe1.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <734f0c4595a18ab136263b6e5c97e7f48a93abe1.camel@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Yes we can have our own gcc options in the Makfile regardless of what
> you put in W command line argument.
> 
> Example:
> 
> KBUILD_CFLAGS += -Wextra -Wunused -Wno-unused-parameter
> KBUILD_CFLAGS += -Wmissing-declarations
> KBUILD_CFLAGS += -Wmissing-format-attribute
> KBUILD_CFLAGS += -Wmissing-prototypes
> KBUILD_CFLAGS += -Wold-style-definition
> KBUILD_CFLAGS += -Wmissing-include-dirs

How about something like this, so we get whatever W=1 means.

    Andrew

diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index 72e18d505d1a..d4e125831d1c 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -3,6 +3,9 @@
 # Makefile for the Linux network device drivers.
 #
 
+# Enable W=1 by default
+subdir-ccflags-y := $(KBUILD_CFLAGS_WARN1)
+
 #
 # Networking Core Drivers
 #
diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
index 95e4cdb94fe9..bf0de3502849 100644
--- a/scripts/Makefile.extrawarn
+++ b/scripts/Makefile.extrawarn
@@ -20,23 +20,26 @@ export KBUILD_EXTRA_WARN
 #
 # W=1 - warnings which may be relevant and do not occur too often
 #
-ifneq ($(findstring 1, $(KBUILD_EXTRA_WARN)),)
-
-KBUILD_CFLAGS += -Wextra -Wunused -Wno-unused-parameter
-KBUILD_CFLAGS += -Wmissing-declarations
-KBUILD_CFLAGS += -Wmissing-format-attribute
-KBUILD_CFLAGS += -Wmissing-prototypes
-KBUILD_CFLAGS += -Wold-style-definition
-KBUILD_CFLAGS += -Wmissing-include-dirs
-KBUILD_CFLAGS += $(call cc-option, -Wunused-but-set-variable)
-KBUILD_CFLAGS += $(call cc-option, -Wunused-const-variable)
-KBUILD_CFLAGS += $(call cc-option, -Wpacked-not-aligned)
-KBUILD_CFLAGS += $(call cc-option, -Wstringop-truncation)
+KBUILD_CFLAGS_WARN1 += -Wextra -Wunused -Wno-unused-parameter
+KBUILD_CFLAGS_WARN1 += -Wmissing-declarations
+KBUILD_CFLAGS_WARN1 += -Wmissing-format-attribute
+KBUILD_CFLAGS_WARN1 += -Wmissing-prototypes
+KBUILD_CFLAGS_WARN1 += -Wold-style-definition
+KBUILD_CFLAGS_WARN1 += -Wmissing-include-dirs
+KBUILD_CFLAGS_WARN1 += $(call cc-option, -Wunused-but-set-variable)
+KBUILD_CFLAGS_WARN1 += $(call cc-option, -Wunused-const-variable)
+KBUILD_CFLAGS_WARN1 += $(call cc-option, -Wpacked-not-aligned)
+KBUILD_CFLAGS_WARN1 += $(call cc-option, -Wstringop-truncation)
 # The following turn off the warnings enabled by -Wextra
-KBUILD_CFLAGS += -Wno-missing-field-initializers
-KBUILD_CFLAGS += -Wno-sign-compare
-KBUILD_CFLAGS += -Wno-type-limits
+KBUILD_CFLAGS_WARN1 += -Wno-missing-field-initializers
+KBUILD_CFLAGS_WARN1 += -Wno-sign-compare
+KBUILD_CFLAGS_WARN1 += -Wno-type-limits
+
+export KBUILD_CFLAGS_WARN1
+
+ifneq ($(findstring 1, $(KBUILD_EXTRA_WARN)),)
 
+KBUILD_CFLAGS += $(KBUILD_CFLAGS_WARN1)
 KBUILD_CPPFLAGS += -DKBUILD_EXTRA_WARN1
 
 else
