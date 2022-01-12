Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7364948BFA1
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 09:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351499AbiALIOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 03:14:02 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40782 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237613AbiALIOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 03:14:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 269E161731;
        Wed, 12 Jan 2022 08:14:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29354C36AEC;
        Wed, 12 Jan 2022 08:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641975240;
        bh=sVNfXg6usJJoEU9t5/A5dvhFxSpMOUHjwCWedxCuoVE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=dCMCCg6Wotk2I1eqDR1vIv9p6OqOLo4eDqR87Hgz+Qd9zUGdf6Y9+TuFBQOLT4+gh
         HhP/aLd3SI5j2Ma/BiJWRCz2qcV7kWqFKPDd6B0EdFoxJrGqaeTvpRir0j8INXKlCp
         2IJdJnp1Sy3Dj/0cwZXYOcG8X5R2qZuT0aPBmCVnRpeJSeYP0H91J/f0OGmPLM7ZHn
         Kv2ToO00Gn54GXj7XuePdBs7ozKIr9bPxqU1WRftiXI5duKtSqZ3sffsch08qOA1yl
         aI20WJGnvmgUMhMbbMcRz/noWpUPwkj1mGHNkb4X03zu6+7UG6c7kXUQLfb37z5gek
         u8mOpyu+eHS0w==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath5k: fix OOB in ath5k_eeprom_read_pcal_info_5111
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <YckvDdj3mtCkDRIt@a-10-27-26-18.dynapool.vpn.nyu.edu>
References: <YckvDdj3mtCkDRIt@a-10-27-26-18.dynapool.vpn.nyu.edu>
To:     Zekun Shen <bruceshenzk@gmail.com>
Cc:     bruceshenzk@gmail.com, Jiri Slaby <jirislaby@kernel.org>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, brendandg@nyu.edu
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164197523645.14338.13517394288080922684.kvalo@kernel.org>
Date:   Wed, 12 Jan 2022 08:13:57 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zekun Shen <bruceshenzk@gmail.com> wrote:

> The bug was found during fuzzing. Stacktrace locates it in
> ath5k_eeprom_convert_pcal_info_5111.
> When none of the curve is selected in the loop, idx can go
> up to AR5K_EEPROM_N_PD_CURVES. The line makes pd out of bound.
> pd = &chinfo[pier].pd_curves[idx];
> 
> There are many OOB writes using pd later in the code. So I
> added a sanity check for idx. Checks for other loops involving
> AR5K_EEPROM_N_PD_CURVES are not needed as the loop index is not
> used outside the loops.
> 
> The patch is NOT tested with real device.
> 
> The following is the fuzzing report
> 
> BUG: KASAN: slab-out-of-bounds in ath5k_eeprom_read_pcal_info_5111+0x126a/0x1390 [ath5k]
> Write of size 1 at addr ffff8880174a4d60 by task modprobe/214
> 
> CPU: 0 PID: 214 Comm: modprobe Not tainted 5.6.0 #1
> Call Trace:
>  dump_stack+0x76/0xa0
>  print_address_description.constprop.0+0x16/0x200
>  ? ath5k_eeprom_read_pcal_info_5111+0x126a/0x1390 [ath5k]
>  ? ath5k_eeprom_read_pcal_info_5111+0x126a/0x1390 [ath5k]
>  __kasan_report.cold+0x37/0x7c
>  ? ath5k_eeprom_read_pcal_info_5111+0x126a/0x1390 [ath5k]
>  kasan_report+0xe/0x20
>  ath5k_eeprom_read_pcal_info_5111+0x126a/0x1390 [ath5k]
>  ? apic_timer_interrupt+0xa/0x20
>  ? ath5k_eeprom_init_11a_pcal_freq+0xbc0/0xbc0 [ath5k]
>  ? ath5k_pci_eeprom_read+0x228/0x3c0 [ath5k]
>  ath5k_eeprom_init+0x2513/0x6290 [ath5k]
>  ? ath5k_eeprom_init_11a_pcal_freq+0xbc0/0xbc0 [ath5k]
>  ? usleep_range+0xb8/0x100
>  ? apic_timer_interrupt+0xa/0x20
>  ? ath5k_eeprom_read_pcal_info_2413+0x2f20/0x2f20 [ath5k]
>  ath5k_hw_init+0xb60/0x1970 [ath5k]
>  ath5k_init_ah+0x6fe/0x2530 [ath5k]
>  ? kasprintf+0xa6/0xe0
>  ? ath5k_stop+0x140/0x140 [ath5k]
>  ? _dev_notice+0xf6/0xf6
>  ? apic_timer_interrupt+0xa/0x20
>  ath5k_pci_probe.cold+0x29a/0x3d6 [ath5k]
>  ? ath5k_pci_eeprom_read+0x3c0/0x3c0 [ath5k]
>  ? mutex_lock+0x89/0xd0
>  ? ath5k_pci_eeprom_read+0x3c0/0x3c0 [ath5k]
>  local_pci_probe+0xd3/0x160
>  pci_device_probe+0x23f/0x3e0
>  ? pci_device_remove+0x280/0x280
>  ? pci_device_remove+0x280/0x280
>  really_probe+0x209/0x5d0
> 
> Reported-by: Brendan Dolan-Gavitt <brendandg@nyu.edu>
> Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

564d4eceb97e ath5k: fix OOB in ath5k_eeprom_read_pcal_info_5111

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/YckvDdj3mtCkDRIt@a-10-27-26-18.dynapool.vpn.nyu.edu/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

