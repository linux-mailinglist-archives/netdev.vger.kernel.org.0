Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F96812755E
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 06:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbfLTFkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 00:40:49 -0500
Received: from mga07.intel.com ([134.134.136.100]:63509 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbfLTFkt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Dec 2019 00:40:49 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Dec 2019 21:40:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,334,1571727600"; 
   d="scan'208";a="416433124"
Received: from ipwrosz-mobl.ger.corp.intel.com ([10.252.4.56])
  by fmsmga005.fm.intel.com with ESMTP; 19 Dec 2019 21:40:45 -0800
Message-ID: <21328530d3f15c75abca8107823a4578e5065ca6.camel@intel.com>
Subject: Re: iwlwifi: refactor the SAR tables from mvm to acpi
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     Colin Ian King <colin.king@canonical.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ihab Zhaika <ihab.zhaika@intel.com>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Fri, 20 Dec 2019 07:40:44 +0200
In-Reply-To: <18ea9fa8-93fe-f371-68ee-3d12eac252c8@canonical.com>
References: <18ea9fa8-93fe-f371-68ee-3d12eac252c8@canonical.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1-2+b1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-12-20 at 00:02 +0000, Colin Ian King wrote:
> Hi,
> 
> Static analysis with Coverity has detected a potential issue with the
> following commit:
> 
> commit 39c1a9728f938c7255ce507c8d56b73e8a4ebddf
> Author: Ihab Zhaika <ihab.zhaika@intel.com>
> Date:   Fri Nov 15 09:28:11 2019 +0200
> 
>     iwlwifi: refactor the SAR tables from mvm to acpi
> 
> 
> in function iwl_sar_get_ewrd_table() we have an array index pos being
> initialized to 3 and then incremented each time a loop iterates:
> 
>         for (i = 0; i < n_profiles; i++) {
>                 /* the tables start at element 3 */
>                 int pos = 3;
> 
>                 /* The EWRD profiles officially go from 2 to 4, but we
>                  * save them in sar_profiles[1-3] (because we don't
>                  * have profile 0).  So in the array we start from 1.
>                  */
>                 ret = iwl_sar_set_profile(&wifi_pkg->package.elements[pos],
>                                           &fwrt->sar_profiles[i + 1],
>                                           enabled);
>                 if (ret < 0)
>                         break;
> 
>                 /* go to the next table */
>                 pos += ACPI_SAR_TABLE_SIZE;
>         }
> 
> So, each iteration is always accessing package.elements[3]. I'm not sure
> if that is intentional. If it is, then the increment of pos is not
> required.  Either way, it's not clear what the original intention is.

Good catch, thanks! We'll fix it.

--
Cheers,
Luca.

