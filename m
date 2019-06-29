Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6211F5AD62
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 22:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbfF2UmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 16:42:12 -0400
Received: from smtprelay0064.hostedemail.com ([216.40.44.64]:59902 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726909AbfF2UmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 16:42:11 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 7EE17182CF668;
        Sat, 29 Jun 2019 20:42:10 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:69:355:379:599:800:960:966:968:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1431:1437:1515:1516:1518:1535:1544:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3355:3622:3865:3866:3867:3868:3870:3871:4250:4321:4385:5007:6119:7974:10004:10848:11026:11232:11657:11658:11914:12043:12296:12297:12438:12555:12740:12760:12895:12986:13138:13161:13229:13231:13439:14181:14659:14721:21080:21451:21627:30034:30054:30055:30064:30070:30091,0,RBL:error,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:30,LUA_SUMMARY:none
X-HE-Tag: blow05_873a3713ed920
X-Filterd-Recvd-Size: 5034
Received: from XPS-9350 (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf02.hostedemail.com (Postfix) with ESMTPA;
        Sat, 29 Jun 2019 20:42:09 +0000 (UTC)
Message-ID: <9408eb59ecaa3e245fd71ec0211a34c3fb0e324b.camel@perches.com>
Subject: Re: [net-next 08/15] iavf: Fix up debug print macro
From:   Joe Perches <joe@perches.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Date:   Sat, 29 Jun 2019 13:42:06 -0700
In-Reply-To: <20190628224932.3389-9-jeffrey.t.kirsher@intel.com>
References: <20190628224932.3389-1-jeffrey.t.kirsher@intel.com>
         <20190628224932.3389-9-jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-06-28 at 15:49 -0700, Jeff Kirsher wrote:
> This aligns the iavf_debug() macro with the other Intel drivers.
> 
> Add the bus number, bus_id field to i40e_bus_info so output shows
> each physical port(i.e func) in following format:
>   [[[[<domain>]:]<bus>]:][<slot>][.[<func>]]
> domains are numbered from 0 to ffff), bus (0-ff), slot (0-1f) and
> function (0-7).
> 
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> ---
>  drivers/net/ethernet/intel/iavf/iavf_osdep.h | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_osdep.h b/drivers/net/ethernet/intel/iavf/iavf_osdep.h
> index d39684558597..a452ce90679a 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_osdep.h
> +++ b/drivers/net/ethernet/intel/iavf/iavf_osdep.h
> @@ -44,8 +44,12 @@ struct iavf_virt_mem {
>  #define iavf_allocate_virt_mem(h, m, s) iavf_allocate_virt_mem_d(h, m, s)
>  #define iavf_free_virt_mem(h, m) iavf_free_virt_mem_d(h, m)
>  
> -#define iavf_debug(h, m, s, ...)  iavf_debug_d(h, m, s, ##__VA_ARGS__)
> -extern void iavf_debug_d(void *hw, u32 mask, char *fmt_str, ...)
> -	__printf(3, 4);
> +#define iavf_debug(h, m, s, ...)				\
> +do {								\
> +	if (((m) & (h)->debug_mask))				\
> +		pr_info("iavf %02x:%02x.%x " s,			\
> +			(h)->bus.bus_id, (h)->bus.device,	\
> +			(h)->bus.func, ##__VA_ARGS__);		\
> +} while (0)

Why not change the function to do this?

And if this is really wanted this particular way
the now unused function should be removed too.

But I suggest emitting at KERN_DEBUG and using
the more typical %pV vsprintf extension.

---

 drivers/net/ethernet/intel/iavf/iavf_main.c  | 25 ++++++++++++++-----------
 drivers/net/ethernet/intel/iavf/iavf_osdep.h |  9 ++++++---
 2 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 881561b36083..8504fd71d398 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -143,25 +143,28 @@ enum iavf_status iavf_free_virt_mem_d(struct iavf_hw *hw,
 }
 
 /**
- * iavf_debug_d - OS dependent version of debug printing
+ * _iavf_debug - OS dependent version of debug printing
  * @hw:  pointer to the HW structure
  * @mask: debug level mask
- * @fmt_str: printf-type format description
+ * @fmt: printf-type format description
  **/
-void iavf_debug_d(void *hw, u32 mask, char *fmt_str, ...)
+void _iavf_debug(const struct iavf_hw *hw, u32 mask, const char *fmt, ...)
 {
-	char buf[512];
-	va_list argptr;
+	struct va_format vaf;
+	va_list args;
 
-	if (!(mask & ((struct iavf_hw *)hw)->debug_mask))
+	if (!(hw->debug_mask & mask))
 		return;
 
-	va_start(argptr, fmt_str);
-	vsnprintf(buf, sizeof(buf), fmt_str, argptr);
-	va_end(argptr);
+	va_start(args, fmt);
 
-	/* the debug string is already formatted with a newline */
-	pr_info("%s", buf);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	pr_debug("iavf %02x:%02x.%x %pV",
+		 hw->bus.bus_id, hw->bus.device, hw->bus.func, &vaf);
+
+	va_end(args);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/iavf/iavf_osdep.h b/drivers/net/ethernet/intel/iavf/iavf_osdep.h
index d39684558597..0e6ac7d262c8 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_osdep.h
+++ b/drivers/net/ethernet/intel/iavf/iavf_osdep.h
@@ -44,8 +44,11 @@ struct iavf_virt_mem {
 #define iavf_allocate_virt_mem(h, m, s) iavf_allocate_virt_mem_d(h, m, s)
 #define iavf_free_virt_mem(h, m) iavf_free_virt_mem_d(h, m)
 
-#define iavf_debug(h, m, s, ...)  iavf_debug_d(h, m, s, ##__VA_ARGS__)
-extern void iavf_debug_d(void *hw, u32 mask, char *fmt_str, ...)
-	__printf(3, 4);
+struct iavf_hw;
+
+__printf(3, 4)
+void _iavf_debug(const struct iavf_hw *hw, u32 mask, const char *fmt, ...);
+#define iavf_debug(hw, mask, fmt, ...)					\
+	_iavf_debug(hw, mask, fmt, ##__VA_ARGS__)
 
 #endif /* _IAVF_OSDEP_H_ */


