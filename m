Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54FDFCF378
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 09:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730191AbfJHHRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 03:17:51 -0400
Received: from mga06.intel.com ([134.134.136.31]:45785 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730057AbfJHHRu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 03:17:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Oct 2019 00:17:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,270,1566889200"; 
   d="scan'208";a="199737798"
Received: from raystayl-mobl1.ger.corp.intel.com ([10.252.7.179])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Oct 2019 00:17:45 -0700
Message-ID: <b1c63efd883452ccb5e57e107c6a0aa74bf25d49.camel@intel.com>
Subject: Re: [PATCH] iwlwifi: fw: don't send GEO_TX_POWER_LIMIT command to
 FW version 29
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     You-Sheng Yang <vicamo.yang@canonical.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Sara Sharon <sara.sharon@intel.com>,
        Gil Adam <gil.adam@intel.com>,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Haim Dreyfuss <haim.dreyfuss@intel.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 08 Oct 2019 10:17:44 +0300
In-Reply-To: <20191008060511.18474-1-vicamo.yang@canonical.com>
References: <20191008060511.18474-1-vicamo.yang@canonical.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-10-08 at 14:05 +0800, You-Sheng Yang wrote:
> Follow-up for commit fddbfeece9c7 ("iwlwifi: fw: don't send
> GEO_TX_POWER_LIMIT command to FW version 36"). There is no
> GEO_TX_POWER_LIMIT command support for all revisions of FW version
> 29, either.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204151
> Signed-off-by: You-Sheng Yang <vicamo.yang@canonical.com>
> ---
>  drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
> index 32a5e4e5461f..dbba616c19de 100644
> --- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
> @@ -889,14 +889,14 @@ static bool iwl_mvm_sar_geo_support(struct iwl_mvm *mvm)
>  	 * firmware versions.  Unfortunately, we don't have a TLV API
>  	 * flag to rely on, so rely on the major version which is in
>  	 * the first byte of ucode_ver.  This was implemented
> -	 * initially on version 38 and then backported to29 and 17.
> +	 * initially on version 38 and then backported to 29 and 17.
>  	 * The intention was to have it in 36 as well, but not all
>  	 * 8000 family got this feature enabled.  The 8000 family is
>  	 * the only one using version 36, so skip this version
> -	 * entirely.
> +	 * entirely. All revisions of -29 fw still don't have
> +	 * GEO_TX_POWER_LIMIT supported yet.
>  	 */
>  	return IWL_UCODE_SERIAL(mvm->fw->ucode_ver) >= 38 ||
> -	       IWL_UCODE_SERIAL(mvm->fw->ucode_ver) == 29 ||
>  	       IWL_UCODE_SERIAL(mvm->fw->ucode_ver) == 17;
>  }

Thanks for the patch!

But I have investigated this (even) further and now I see that 3168
doesn't have this command, but 7265D does.  The latter also uses -29,
so we can't blindly disable all -29 versions.

Can you try this instead?

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 0d2229319261..38d89ee9bd28 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -906,8 +906,10 @@ static bool iwl_mvm_sar_geo_support(struct iwl_mvm
*mvm)
         * entirely.
         */
        return IWL_UCODE_SERIAL(mvm->fw->ucode_ver) >= 38 ||
-              IWL_UCODE_SERIAL(mvm->fw->ucode_ver) == 29 ||
-              IWL_UCODE_SERIAL(mvm->fw->ucode_ver) == 17;
+              IWL_UCODE_SERIAL(mvm->fw->ucode_ver) == 17 ||
+              (IWL_UCODE_SERIAL(mvm->fw->ucode_ver) == 29 &&
+               (mvm->trans->hw_rev &
+                CSR_HW_REV_TYPE_MSK) == CSR_HW_REV_TYPE_7265D);
 }
 
 int iwl_mvm_get_sar_geo_profile(struct iwl_mvm *mvm)


--
Cheers,
Luca.

