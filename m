Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9B442758E0
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 15:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgIWNg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 09:36:58 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:38393 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726498AbgIWNgz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 09:36:55 -0400
X-Greylist: delayed 531 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Sep 2020 09:36:54 EDT
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id CE1B220646235;
        Wed, 23 Sep 2020 15:28:01 +0200 (CEST)
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Re: [Intel-wired-lan] [PATCH] e1000e: Power cycle phy on PM resume
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
References: <20200923074751.10527-1-kai.heng.feng@canonical.com>
Message-ID: <17092088-86ff-2d31-b3de-2469419136a3@molgen.mpg.de>
Date:   Wed, 23 Sep 2020 15:28:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200923074751.10527-1-kai.heng.feng@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Kai-Heng,


Am 23.09.20 um 09:47 schrieb Kai-Heng Feng:
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
> Since we don't know what platform firmware may do to the phy, so let's
> power cycle the phy upon system resume to resolve the issue.

Is there a bug report or list thread for this issue?

> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
>   drivers/net/ethernet/intel/e1000e/netdev.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> index 664e8ccc88d2..c2a87a408102 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -6968,6 +6968,8 @@ static __maybe_unused int e1000e_pm_resume(struct device *dev)
>   	    !e1000e_check_me(hw->adapter->pdev->device))
>   		e1000e_s0ix_exit_flow(adapter);
>   
> +	e1000_power_down_phy(adapter);
> +
>   	rc = __e1000_resume(pdev);
>   	if (rc)
>   		return rc;

How much does this increase the resume time?


Kind regards,

Paul

