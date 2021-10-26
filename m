Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD9843AD2C
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 09:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbhJZH3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 03:29:30 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:40391 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229540AbhJZH33 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 03:29:29 -0400
Received: from [192.168.0.2] (ip5f5aef5c.dynamic.kabel-deutschland.de [95.90.239.92])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 01C9F61E6478B;
        Tue, 26 Oct 2021 09:27:04 +0200 (CEST)
Message-ID: <5e3271cb-ea53-496a-1fd7-341e9c57c3a8@molgen.mpg.de>
Date:   Tue, 26 Oct 2021 09:27:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [Intel-wired-lan] [PATCH v2] e1000e: Add a delay to let ME
 unconfigure s0ix when DPG_EXIT_DONE is already flagged
Content-Language: en-US
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org,
        acelan.kao@canonical.com, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Dima Ruinskiy <dima.ruinskiy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com
References: <20211026065112.1366205-1-kai.heng.feng@canonical.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20211026065112.1366205-1-kai.heng.feng@canonical.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Kai-Heng,


On 26.10.21 08:51, Kai-Heng Feng wrote:

In the commit message summary, maybe write:

> e1000e: Add 1 s delay …


> On some ADL platforms, DPG_EXIT_DONE is always flagged so e1000e resume
> polling logic doesn't wait until ME really unconfigures s0ix.

Please list one broken system. The log message says, it’s a firmware 
bug. Please elaborate.

> So check DPG_EXIT_DONE before issuing EXIT_DPG, and if it's already
> flagged, wait for 1 second to let ME unconfigure s0ix.

Where did you get the one second from?

> Fixes: 3e55d231716e ("e1000e: Add handshake with the CSME to support S0ix")
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=214821
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
> v2:
>   Add missing "Fixes:" tag
> 
>   drivers/net/ethernet/intel/e1000e/netdev.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> index 44e2dc8328a22..cd81ba00a6bc9 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -6493,14 +6493,21 @@ static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
>   	u32 mac_data;
>   	u16 phy_data;
>   	u32 i = 0;
> +	bool dpg_exit_done;
>   
>   	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID) {
> +		dpg_exit_done = er32(EXFWSM) & E1000_EXFWSM_DPG_EXIT_DONE;
>   		/* Request ME unconfigure the device from S0ix */
>   		mac_data = er32(H2ME);
>   		mac_data &= ~E1000_H2ME_START_DPG;
>   		mac_data |= E1000_H2ME_EXIT_DPG;
>   		ew32(H2ME, mac_data);
>   
> +		if (dpg_exit_done) {
> +			e_warn("DPG_EXIT_DONE is already flagged. This is a firmware bug\n");

What firmware exactly? Management Engine?

> +			msleep(1000);

One second is quite long. Can some bit be polled instead?

> +		}
> +
>   		/* Poll up to 2.5 seconds for ME to unconfigure DPG.
>   		 * If this takes more than 1 second, show a warning indicating a
>   		 * firmware bug
> 


Kind regards,

Paul
