Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01521663B2
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 04:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728956AbfGLCPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 22:15:48 -0400
Received: from smtprelay0216.hostedemail.com ([216.40.44.216]:41189 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726505AbfGLCPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 22:15:48 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 8CD04181D33FB;
        Fri, 12 Jul 2019 02:15:46 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::,RULES_HIT:41:355:379:599:800:960:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1431:1437:1515:1516:1518:1535:1544:1593:1594:1711:1730:1747:1777:1792:2393:2525:2559:2564:2682:2685:2692:2828:2859:2899:2902:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6119:6742:7514:7807:7875:7901:7903:8957:9025:9707:10004:10848:11026:11232:11473:11657:11658:11914:12043:12297:12438:12555:12698:12737:12740:12760:12895:13132:13231:13255:13439:14181:14659:14721:21080:21325:21433:21451:21627:21740:30012:30029:30054:30055:30069:30091,0,RBL:error,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:28,LUA_SUMMARY:none
X-HE-Tag: list61_6c0723a6be725
X-Filterd-Recvd-Size: 5469
Received: from XPS-9350 (unknown [172.58.27.57])
        (Authenticated sender: joe@perches.com)
        by omf13.hostedemail.com (Postfix) with ESMTPA;
        Fri, 12 Jul 2019 02:15:42 +0000 (UTC)
Message-ID: <b219cf41933b2f965572af515cf9d3119293bfba.camel@perches.com>
Subject: Re: [PATCH -next] iwlwifi: dbg: work around clang bug by marking
 debug strings static
From:   Joe Perches <joe@perches.com>
To:     Nick Desaulniers <ndesaulniers@google.com>, kvalo@codeaurora.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Sara Sharon <sara.sharon@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
In-Reply-To: <20190712001708.170259-1-ndesaulniers@google.com>
References: <20190712001708.170259-1-ndesaulniers@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
Date:   Thu, 11 Jul 2019 19:01:14 -0700
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-07-11 at 17:17 -0700, Nick Desaulniers wrote:
> Commit r353569 in prerelease Clang-9 is producing a linkage failure:
> 
> ld: drivers/net/wireless/intel/iwlwifi/fw/dbg.o:
> in function `_iwl_fw_dbg_apply_point':
> dbg.c:(.text+0x827a): undefined reference to `__compiletime_assert_2387'
> 
> when the following configs are enabled:
> - CONFIG_IWLWIFI
> - CONFIG_IWLMVM
> - CONFIG_KASAN
> 
> Work around the issue for now by marking the debug strings as `static`,
> which they probably should be any ways.
> 
> Link: https://bugs.llvm.org/show_bug.cgi?id=42580
> Link: https://github.com/ClangBuiltLinux/linux/issues/580
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> ---
>  drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
> index e411ac98290d..f8c90ea4e9b4 100644
> --- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
> +++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
> @@ -2438,7 +2438,7 @@ static void iwl_fw_dbg_info_apply(struct iwl_fw_runtime *fwrt,
>  {
>  	u32 img_name_len = le32_to_cpu(dbg_info->img_name_len);
>  	u32 dbg_cfg_name_len = le32_to_cpu(dbg_info->dbg_cfg_name_len);
> -	const char err_str[] =
> +	static const char err_str[] =
>  		"WRT: ext=%d. Invalid %s name length %d, expected %d\n";

Better still would be to use the format string directly
in both locations instead of trying to deduplicate it
via storing it into a separate pointer.

Let the compiler/linker consolidate the format.
It's smaller object code, allows format/argument verification,
and is simpler for humans to understand.

---
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index e411ac98290d..25e6712932b8 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -2438,17 +2438,17 @@ static void iwl_fw_dbg_info_apply(struct iwl_fw_runtime *fwrt,
 {
 	u32 img_name_len = le32_to_cpu(dbg_info->img_name_len);
 	u32 dbg_cfg_name_len = le32_to_cpu(dbg_info->dbg_cfg_name_len);
-	const char err_str[] =
-		"WRT: ext=%d. Invalid %s name length %d, expected %d\n";
 
 	if (img_name_len != IWL_FW_INI_MAX_IMG_NAME_LEN) {
-		IWL_WARN(fwrt, err_str, ext, "image", img_name_len,
+		IWL_WARN(fwrt, "WRT: ext=%d. Invalid %s name length %d, expected %d\n",
+			 ext, "image", img_name_len,
 			 IWL_FW_INI_MAX_IMG_NAME_LEN);
 		return;
 	}
 
 	if (dbg_cfg_name_len != IWL_FW_INI_MAX_DBG_CFG_NAME_LEN) {
-		IWL_WARN(fwrt, err_str, ext, "debug cfg", dbg_cfg_name_len,
+		IWL_WARN(fwrt, "WRT: ext=%d. Invalid %s name length %d, expected %d\n",
+			 ext, "debug cfg", dbg_cfg_name_len,
 			 IWL_FW_INI_MAX_DBG_CFG_NAME_LEN);
 		return;
 	}
@@ -2775,8 +2775,6 @@ static void _iwl_fw_dbg_apply_point(struct iwl_fw_runtime *fwrt,
 		struct iwl_ucode_tlv *tlv = iter;
 		void *ini_tlv = (void *)tlv->data;
 		u32 type = le32_to_cpu(tlv->type);
-		const char invalid_ap_str[] =
-			"WRT: ext=%d. Invalid apply point %d for %s\n";
 
 		switch (type) {
 		case IWL_UCODE_TLV_TYPE_DEBUG_INFO:
@@ -2786,8 +2784,8 @@ static void _iwl_fw_dbg_apply_point(struct iwl_fw_runtime *fwrt,
 			struct iwl_fw_ini_allocation_data *buf_alloc = ini_tlv;
 
 			if (pnt != IWL_FW_INI_APPLY_EARLY) {
-				IWL_ERR(fwrt, invalid_ap_str, ext, pnt,
-					"buffer allocation");
+				IWL_ERR(fwrt, "WRT: ext=%d. Invalid apply point %d for %s\n",
+					ext, pnt, "buffer allocation");
 				goto next;
 			}
 
@@ -2797,8 +2795,8 @@ static void _iwl_fw_dbg_apply_point(struct iwl_fw_runtime *fwrt,
 		}
 		case IWL_UCODE_TLV_TYPE_HCMD:
 			if (pnt < IWL_FW_INI_APPLY_AFTER_ALIVE) {
-				IWL_ERR(fwrt, invalid_ap_str, ext, pnt,
-					"host command");
+				IWL_ERR(fwrt, "WRT: ext=%d. Invalid apply point %d for %s\n",
+					ext, pnt, "host command");
 				goto next;
 			}
 			iwl_fw_dbg_send_hcmd(fwrt, tlv, ext);


