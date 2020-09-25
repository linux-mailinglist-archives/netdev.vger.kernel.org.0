Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7B9277FD7
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 07:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgIYFQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 01:16:43 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:57575 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726925AbgIYFQn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 01:16:43 -0400
Received: from [192.168.0.3] (ip5f5af1e7.dynamic.kabel-deutschland.de [95.90.241.231])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id D68B22064620A;
        Fri, 25 Sep 2020 07:16:38 +0200 (CEST)
Subject: Re: [Intel-wired-lan] [PATCH v3] e1000e: Increase iteration on
 polling MDIC ready bit
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
References: <20200924150958.18016-1-kai.heng.feng@canonical.com>
 <20200924164542.19906-1-kai.heng.feng@canonical.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <1497f846-40d2-ddc8-60be-ffd117ffc0b7@molgen.mpg.de>
Date:   Fri, 25 Sep 2020 07:16:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200924164542.19906-1-kai.heng.feng@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Kai-Heng,


Thank you for patch version 3.

Am 24.09.20 um 18:45 schrieb Kai-Heng Feng:
> We are seeing the following error after S3 resume:
> [  704.746874] e1000e 0000:00:1f.6 eno1: Setting page 0x6020
> [  704.844232] e1000e 0000:00:1f.6 eno1: MDI Write did not complete
> [  704.902817] e1000e 0000:00:1f.6 eno1: Setting page 0x6020
> [  704.903075] e1000e 0000:00:1f.6 eno1: reading PHY page 769 (or 0x6020 shifted) reg 0x17
> [  704.903281] e1000e 0000:00:1f.6 eno1: Setting page 0x6020
> [  704.903486] e1000e 0000:00:1f.6 eno1: writing PHY page 769 (or 0x6020 shifted) reg 0x17
> [  704.943155] e1000e 0000:00:1f.6 eno1: MDI Error
> ...
> [  705.108161] e1000e 0000:00:1f.6 eno1: Hardware Error
> 
> As Andrew Lunn pointed out, MDIO has nothing to do with phy, and indeed
> increase polling iteration can resolve the issue.
> 
> The root cause is quite likely Intel ME, since it's a blackbox to the
> kernel so the only approach we can take is to be patient and wait
> longer.
> 
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
> v3:
>   - Moving delay to end of loop doesn't save anytime, move it back.
>   - Point out this is quitely likely caused by Intel ME.

quietly

You seem to have missed my comments regarding patch version 3. It’d be 
great if you improved the commit message with my suggestions.

Without knowing what hardware this happened on, nobody, even later 
getting the hardware, can reproduce the your results. If you say the ME 
is involved, please also document the ME firmware version, which is used 
here.

> v2:
>   - Increase polling iteration instead of powering down the phy.
> 
>   drivers/net/ethernet/intel/e1000e/phy.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/e1000e/phy.c b/drivers/net/ethernet/intel/e1000e/phy.c
> index e11c877595fb..e6d4acd90937 100644
> --- a/drivers/net/ethernet/intel/e1000e/phy.c
> +++ b/drivers/net/ethernet/intel/e1000e/phy.c
> @@ -203,7 +203,7 @@ s32 e1000e_write_phy_reg_mdic(struct e1000_hw *hw, u32 offset, u16 data)
>   	 * Increasing the time out as testing showed failures with
>   	 * the lower time out
>   	 */
> -	for (i = 0; i < (E1000_GEN_POLL_TIMEOUT * 3); i++) {
> +	for (i = 0; i < (E1000_GEN_POLL_TIMEOUT * 10); i++) {
>   		udelay(50);
>   		mdic = er32(MDIC);
>   		if (mdic & E1000_MDIC_READY)

In the PCI subsystem, a warning is shown, when something takes more then 
100 ms. As you increase it to over 320 ms, a warning should be printed 
to talk to the firmware folks, when it passes 100 ms.


Kind regards,

Paul
