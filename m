Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1501A4717DA
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 03:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232592AbhLLCmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 21:42:24 -0500
Received: from relay036.a.hostedemail.com ([64.99.140.36]:9897 "EHLO
        relay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S232495AbhLLCmY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 21:42:24 -0500
Received: from omf18.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay09.hostedemail.com (Postfix) with ESMTP id 7A0002234B;
        Sun, 12 Dec 2021 02:42:22 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf18.hostedemail.com (Postfix) with ESMTPA id 02B2F37;
        Sun, 12 Dec 2021 02:42:20 +0000 (UTC)
Message-ID: <e7eeecfb1c967336944f0941900a9052bcce279e.camel@perches.com>
Subject: Re: [PATCH] net: bcmgenet: Fix NULL vs IS_ERR() checking
From:   Joe Perches <joe@perches.com>
To:     Miaoqian Lin <linmq006@gmail.com>,
        Dan Carpenter <error27@gmail.com>
Cc:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sat, 11 Dec 2021 18:42:19 -0800
In-Reply-To: <20211211140154.23613-1-linmq006@gmail.com>
References: <20211211140154.23613-1-linmq006@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 02B2F37
X-Spam-Status: No, score=-3.04
X-Stat-Signature: rtx4mxyg7rrt6c6e4terzb84xmjnc1fm
X-Rspamd-Server: rspamout08
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19V+2w4H3z8/tKHt6v8o/V7BtPfcoyla5g=
X-HE-Tag: 1639276940-116653
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2021-12-11 at 14:01 +0000, Miaoqian Lin wrote:
> The phy_attach() function does not return NULL. It returns error pointers.

Perhaps all the functions that return error pointers rather than
NULL on error should be marked with a special attribute:

Something like:

#define __returns_nonnull	__attribute__((__returns_nonnull__))

---

 include/linux/compiler_attributes.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler_attributes.h
index 37e2600202216..e2351a36dda97 100644
--- a/include/linux/compiler_attributes.h
+++ b/include/linux/compiler_attributes.h
@@ -250,6 +250,18 @@
 # define __no_profile
 #endif
 
+/*
+ * Optional: only supported since GCC >= 5.x
+ *
+ *      gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-returns_005fnonnull-function-attribute
+ *    clang: https://clang.llvm.org/docs/AttributeReference.html#returns-nonnull
+ */
+#if __has_attribute(__returns_nonnull__)
+# define __returns_nonnull		__attribute__((__returns_nonnull__))
+#else
+# define __returns_nonnull
+#endif
+
 /*
  *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-noreturn-function-attribute
  * clang: https://clang.llvm.org/docs/AttributeReference.html#noreturn


