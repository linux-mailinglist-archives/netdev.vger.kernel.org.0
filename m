Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A72D49C66A
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 10:39:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239237AbiAZJjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 04:39:31 -0500
Received: from mga05.intel.com ([192.55.52.43]:9277 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239217AbiAZJja (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 04:39:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643189970; x=1674725970;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=07WBSgMRDpJKqoyYch5hDAXQZYzth7c5ZCJjIGOcNFw=;
  b=azB3zvlRcNIUQ/XfmIITIq7BIvMDBmiwpaeZGw4eJ3YUZQolqsNyc3F2
   y/+rvu9VHlZ3C16k4SK9TlWhzkfRnT6Wqp0MtdKUs9VEhx43CJnMMZww5
   0+gN5HqeLJep2BbnT3Tf+bBDuatSwTGj0BmMISf/UAXvsekBF+q761xDG
   nGa7CpK9r/yDK8odq+hn7fwMJAkWN5BfTB6EH3Gcw29noL0QiTaZMraug
   1oQKGZ6yIIZ+WnjsTxLYEuRWiWtdTV6Al4MsL/b6u3m/QI2Ul54qqznK6
   isOiRa3XhHTVa3b3V5dlN2o27k6JHFaGHj1+0GSWudxutCG6DVWSeTNiQ
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10238"; a="332869372"
X-IronPort-AV: E=Sophos;i="5.88,317,1635231600"; 
   d="scan'208";a="332869372"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 01:39:29 -0800
X-IronPort-AV: E=Sophos;i="5.88,317,1635231600"; 
   d="scan'208";a="477433079"
Received: from lucas-s2600cw.jf.intel.com ([10.165.21.202])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 01:39:29 -0800
From:   Lucas De Marchi <lucas.demarchi@intel.com>
To:     linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-security-module@vger.kernel.org,
        nouveau@lists.freedesktop.org, netdev@vger.kernel.org
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alex Deucher <alexander.deucher@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        "David S. Miller" <davem@davemloft.net>,
        Emma Anholt <emma@anholt.net>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Harry Wentland <harry.wentland@amd.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Leo Li <sunpeng.li@amd.com>, Petr Mladek <pmladek@suse.com>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: [PATCH v2 01/11] lib/string_helpers: Consolidate string helpers implementation
Date:   Wed, 26 Jan 2022 01:39:41 -0800
Message-Id: <20220126093951.1470898-2-lucas.demarchi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126093951.1470898-1-lucas.demarchi@intel.com>
References: <20220126093951.1470898-1-lucas.demarchi@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few implementations of string helpers in the tree like yesno()
that just returns "yes" or "no" depending on a boolean argument. Those
are helpful to output strings to the user or log.

In order to consolidate them, prefix all of them str_ prefix to make it
clear what they are about and avoid symbol clashes.
Taking the commoon `val ? "yes" : "no"` implementation,  quite a few
users of open coded yesno() could later be converted to the new
function:

$ git grep '?\s*"yes"\s*' | wc -l
286
$ git grep '?\s*"no"\s*' | wc -l
20

The inlined function should keep the const strings local to each
compilation unit, the same way it's now, thus not changing the current
behavior.

Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Acked-by: Jani Nikula <jani.nikula@intel.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 include/linux/string_helpers.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/string_helpers.h b/include/linux/string_helpers.h
index 7a22921c9db7..4d72258d42fd 100644
--- a/include/linux/string_helpers.h
+++ b/include/linux/string_helpers.h
@@ -106,4 +106,24 @@ void kfree_strarray(char **array, size_t n);
 
 char **devm_kasprintf_strarray(struct device *dev, const char *prefix, size_t n);
 
+static inline const char *str_yes_no(bool v)
+{
+	return v ? "yes" : "no";
+}
+
+static inline const char *str_on_off(bool v)
+{
+	return v ? "on" : "off";
+}
+
+static inline const char *str_enable_disable(bool v)
+{
+	return v ? "enable" : "disable";
+}
+
+static inline const char *str_enabled_disabled(bool v)
+{
+	return v ? "enabled" : "disabled";
+}
+
 #endif
-- 
2.34.1

