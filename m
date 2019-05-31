Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A562309E9
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 10:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfEaIPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 04:15:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:64473 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726617AbfEaIPJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 04:15:09 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 May 2019 01:15:09 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 31 May 2019 01:15:09 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 01/13] iavf: Use printf instead of gnu_printf for iavf_debug_d
Date:   Fri, 31 May 2019 01:15:06 -0700
Message-Id: <20190531081518.16430-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190531081518.16430-1-jeffrey.t.kirsher@intel.com>
References: <20190531081518.16430-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

Clang warns:

In file included from drivers/net/ethernet/intel/iavf/iavf_main.c:4:
In file included from drivers/net/ethernet/intel/iavf/iavf.h:37:
In file included from drivers/net/ethernet/intel/iavf/iavf_type.h:8:
drivers/net/ethernet/intel/iavf/iavf_osdep.h:49:18: warning: 'format' attribute argument not supported: gnu_printf [-Wignored-attributes]
        __attribute__ ((format(gnu_printf, 3, 4)));
                        ^
1 warning generated.

We can convert from gnu_printf to printf without any side effects for
two reasons:

1. All iavf_debug instances use standard printf formats, as pointed out
   by Miguel Ojeda at the below link, meaning gnu_printf is not strictly
   required.

2. However, GCC has aliased printf to gnu_printf on Linux since at least
   2010 based on git history.

   From gcc/c-family/c-format.c:

   /* Attributes such as "printf" are equivalent to those such as
      "gnu_printf" unless this is overridden by a target.  */
   static const target_ovr_attr gnu_target_overrides_format_attributes[] =
   {
     { "gnu_printf",   "printf" },
     { "gnu_scanf",    "scanf" },
     { "gnu_strftime", "strftime" },
     { "gnu_strfmon",  "strfmon" },
     { NULL,           NULL }
   };

The mentioned override only happens on Windows (mingw32). Changing from
gnu_printf to printf is a no-op for GCC and stops Clang from warning.

Link: https://github.com/ClangBuiltLinux/linux/issues/111
Suggested-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_osdep.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_osdep.h b/drivers/net/ethernet/intel/iavf/iavf_osdep.h
index e6e0b0328706..c90cafb526d0 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_osdep.h
+++ b/drivers/net/ethernet/intel/iavf/iavf_osdep.h
@@ -46,7 +46,7 @@ struct iavf_virt_mem {
 
 #define iavf_debug(h, m, s, ...)  iavf_debug_d(h, m, s, ##__VA_ARGS__)
 extern void iavf_debug_d(void *hw, u32 mask, char *fmt_str, ...)
-	__attribute__ ((format(gnu_printf, 3, 4)));
+	__printf(3, 4);
 
 typedef enum iavf_status_code iavf_status;
 #endif /* _IAVF_OSDEP_H_ */
-- 
2.21.0

