Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBDF251B1C6
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 00:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239704AbiEDW2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 18:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233350AbiEDW2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 18:28:15 -0400
Received: from mail.itouring.de (mail.itouring.de [IPv6:2a01:4f8:a0:4463::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D288D1EAEE;
        Wed,  4 May 2022 15:24:34 -0700 (PDT)
Received: from tux.applied-asynchrony.com (p5ddd7616.dip0.t-ipconnect.de [93.221.118.22])
        by mail.itouring.de (Postfix) with ESMTPSA id 435A2124EC0;
        Thu,  5 May 2022 00:24:33 +0200 (CEST)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id E9601F01600;
        Thu,  5 May 2022 00:24:32 +0200 (CEST)
Subject: Re: [PATCH] net: atlantic: always deep reset on pm op, fixing null
 deref regression
To:     Manuel Ullmann <labre@posteo.de>,
        Igor Russkikh <irusskikh@marvell.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        regressions@lists.linux.dev, davem@davemloft.net,
        ndanilov@marvell.com, kuba@kernel.org, pabeni@redhat.com,
        Jordan Leppert <jordanleppert@protonmail.com>,
        koo5 <kolman.jindrich@gmail.com>
References: <87czgt2bsb.fsf@posteo.de>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <05b077d6-95a7-60d6-94ad-b44dbe7cd5e4@applied-asynchrony.com>
Date:   Thu, 5 May 2022 00:24:32 +0200
MIME-Version: 1.0
In-Reply-To: <87czgt2bsb.fsf@posteo.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-05-05 00:06, Manuel Ullmann wrote:
>  From a3eccd32c618fe4b4f5c537cd83ba5611149623e Mon Sep 17 00:00:00 2001
> Date: Wed, 4 May 2022 21:30:44 +0200
> 
> The impact of this regression is the same for resume that I saw on
> thaw: the kernel hangs and nothing except SysRq rebooting can be done.
> 
> The null deref occurs at the same position as on thaw.
> BUG: kernel NULL pointer dereference
> RIP: aq_ring_rx_fill+0xcf/0x210 [atlantic]
> 
> Fixes regression in cbe6c3a8f8f4 ("net: atlantic: invert deep par in
> pm functions, preventing null derefs"), where I disabled deep pm
> resets in suspend and resume, trying to make sense of the
> atl_resume_common deep parameter in the first place.
> 
> It turns out, that atlantic always has to deep reset on pm operations
> and the parameter is useless. Even though I expected that and tested
> resume, I screwed up by kexec-rebooting into an unpatched kernel, thus
> missing the breakage.
> 
> This fixup obsoletes the deep parameter of atl_resume_common, but I
> leave the cleanup for the maintainers to post to mainline.
> 
> PS: I'm very sorry for this regression.
> 
> Fixes: cbe6c3a8f8f4315b96e46e1a1c70393c06d95a4c
> Link: https://lore.kernel.org/regressions/9-Ehc_xXSwdXcvZqKD5aSqsqeNj5Izco4MYEwnx5cySXVEc9-x_WC4C3kAoCqNTi-H38frroUK17iobNVnkLtW36V6VWGSQEOHXhmVMm5iQ=@protonmail.com/
> Reported-by: Jordan Leppert <jordanleppert@protonmail.com>
> Reported-by: Holger Hoffstätte <holger@applied-asynchrony.com>
> CC: <stable@vger.kernel.org> # 5.17.5
> CC: <stable@vger.kernel.org> # 5.15.36
> CC: <stable@vger.kernel.org> # 5.10.113
> Signed-off-by: Manuel ULlmann <labre@posteo.de>
> ---
>   drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
> index 3a529ee8c834..831833911a52 100644
> --- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
> +++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
> @@ -449,7 +449,7 @@ static int aq_pm_freeze(struct device *dev)
>   
>   static int aq_pm_suspend_poweroff(struct device *dev)
>   {
> -	return aq_suspend_common(dev, false);
> +	return aq_suspend_common(dev, true);
>   }
>   
>   static int aq_pm_thaw(struct device *dev)
> @@ -459,7 +459,7 @@ static int aq_pm_thaw(struct device *dev)
>   
>   static int aq_pm_resume_restore(struct device *dev)
>   {
> -	return atl_resume_common(dev, false);
> +	return atl_resume_common(dev, true);
>   }
>   
>   static const struct dev_pm_ops aq_pm_ops = {
> 
> base-commit: 672c0c5173427e6b3e2a9bbb7be51ceeec78093a
> 

As mentioned in the discusson thread this reliably restores resume
for me, so:

Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>

Thanks!
Holger
