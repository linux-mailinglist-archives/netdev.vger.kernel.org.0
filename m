Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 938A11F5465
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 14:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728918AbgFJMTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 08:19:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:57083 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728540AbgFJMTB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jun 2020 08:19:01 -0400
IronPort-SDR: s/bi49aKySkiwbs8663bQJ+alHT+8HYSYrFHTWHHR7jBY08gcg2eOEmKybHG3rxx8cTZEs1jnX
 GgwojsqzKWBw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2020 05:18:55 -0700
IronPort-SDR: xyBzLieBBLsKIOmAea68QV63E8nLmS/k0Ib31fTDfHW9z0qJeN1wDvYkmntxkSU0fGdiImspmd
 f+zeTjf78rEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,495,1583222400"; 
   d="scan'208";a="473405781"
Received: from tstralma-mobl.ger.corp.intel.com ([10.249.254.134])
  by fmsmga005.fm.intel.com with ESMTP; 10 Jun 2020 05:18:52 -0700
Message-ID: <1cbbb0dab91cad4ecf76cb6ca92f3c3bfe6ee5f7.camel@intel.com>
Subject: Re: [PATCH 02/15] iwlwifi: mvm: fix gcc-10 zero-length-bounds
 warning
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sara Sharon <sara.sharon@intel.com>
Cc:     Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date:   Wed, 10 Jun 2020 15:18:52 +0300
In-Reply-To: <20200430213101.135134-3-arnd@arndb.de>
References: <20200430213101.135134-1-arnd@arndb.de>
         <20200430213101.135134-3-arnd@arndb.de>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-04-30 at 23:30 +0200, Arnd Bergmann wrote:
> gcc-10 complains when a zero-length array is accessed:
> 
> drivers/net/wireless/intel/iwlwifi/mvm/tx.c: In function 'iwl_mvm_rx_ba_notif':
> drivers/net/wireless/intel/iwlwifi/mvm/tx.c:1929:17: warning: array subscript 9 is outside the bounds of an interior zero-length array 'struct iwl_mvm_compressed_ba_tfd[0]' [-Wzero-length-bounds]
>  1929 |     &ba_res->tfd[i];
>       |      ~~~~~~~~~~~^~~
> In file included from drivers/net/wireless/intel/iwlwifi/mvm/../fw/api/tdls.h:68,
>                  from drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h:68,
>                  from drivers/net/wireless/intel/iwlwifi/mvm/sta.h:73,
>                  from drivers/net/wireless/intel/iwlwifi/mvm/mvm.h:83,
>                  from drivers/net/wireless/intel/iwlwifi/mvm/tx.c:72:
> drivers/net/wireless/intel/iwlwifi/mvm/../fw/api/tx.h:769:35: note: while referencing 'tfd'
>   769 |  struct iwl_mvm_compressed_ba_tfd tfd[0];
>       |                                   ^~~
> 
> Change this structure to use a flexible-array member for 'tfd' instead,
> along with the various structures using an zero-length ieee80211_hdr
> array that do not show warnings today but might be affected by similar
> issues in the future.
> 
> Fixes: 6f68cc367ab6 ("iwlwifi: api: annotate compressed BA notif array sizes")
> Fixes: c46e7724bfe9 ("iwlwifi: mvm: support new BA notification response")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Patch applied to iwlwifi-next.git, thanks.

9cec1d547cb7 iwlwifi: mvm: fix gcc-10 zero-length-bounds warning

