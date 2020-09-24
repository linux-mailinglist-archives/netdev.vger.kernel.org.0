Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB3EF27755B
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 17:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbgIXPcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 11:32:15 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:40541 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728285AbgIXPcO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 11:32:14 -0400
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 2E70C20646203;
        Thu, 24 Sep 2020 17:32:12 +0200 (CEST)
Subject: Re: [Intel-wired-lan] [PATCH v2] e1000e: Increase iteration on
 polling MDIC ready bit
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
References: <20200923074751.10527-1-kai.heng.feng@canonical.com>
 <20200924150958.18016-1-kai.heng.feng@canonical.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <748efbf9-573f-ab2a-0c82-a7b2a11cda60@molgen.mpg.de>
Date:   Thu, 24 Sep 2020 17:32:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200924150958.18016-1-kai.heng.feng@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Kai-Heng,


Thank you for sending version 2.

Am 24.09.20 um 17:09 schrieb Kai-Heng Feng:
> We are seeing the following error after S3 resume:

I’d be great if you added the system and used hardware, you are seeing 
this with.

> [  704.746874] e1000e 0000:00:1f.6 eno1: Setting page 0x6020
> [  704.844232] e1000e 0000:00:1f.6 eno1: MDI Write did not complete

A follow-up patch, should extend the message to include the timeout value.

 > MDI Write did not complete did not complete in … seconds.

According to the Linux timestamps it’s 98 ms, which makes sense, as (640 
* 3 * 50 μs = 96 ms).

What crappy hardware is this, that it takes longer than 100 ms?

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

Please explicitly state, what the current timeout value is, and what it 
is increased to.

     640 * 3 * 50 μs = 96 ms
     640 * 10 * 50 μs = 320 ms

The macro definition also misses the unit.

     /* SerDes Control */
     #define E1000_GEN_POLL_TIMEOUT          640

How did you determine, that tenfold that value is good. And not 
eightfold, for example? Please give the exact value (Linux log message 
timestamps should be enough), what the hardware needs now.

As a commit message summary, I suggest:

 > e1000e: Increase MDIC ready bit polling timeout from 96 ms to 320 ms

> While at it, also move the delay to the end of loop, to potentially save
> 50 us.
> 
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
> v2:
>   - Increase polling iteration instead of powering down the phy.
> 
>   drivers/net/ethernet/intel/e1000e/phy.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/e1000e/phy.c b/drivers/net/ethernet/intel/e1000e/phy.c
> index e11c877595fb..72968a01164b 100644
> --- a/drivers/net/ethernet/intel/e1000e/phy.c
> +++ b/drivers/net/ethernet/intel/e1000e/phy.c
> @@ -203,11 +203,12 @@ s32 e1000e_write_phy_reg_mdic(struct e1000_hw *hw, u32 offset, u16 data)
>   	 * Increasing the time out as testing showed failures with
>   	 * the lower time out
>   	 */
> -	for (i = 0; i < (E1000_GEN_POLL_TIMEOUT * 3); i++) {
> -		udelay(50);
> +	for (i = 0; i < (E1000_GEN_POLL_TIMEOUT * 10); i++) {
>   		mdic = er32(MDIC);
>   		if (mdic & E1000_MDIC_READY)
>   			break;
> +
> +		udelay(50);
>   	}
>   	if (!(mdic & E1000_MDIC_READY)) {
>   		e_dbg("MDI Write did not complete\n");
> 
