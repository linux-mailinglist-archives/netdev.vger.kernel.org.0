Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5AB6309F6E
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 00:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbhAaXVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 18:21:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbhAaXVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 18:21:38 -0500
X-Greylist: delayed 176 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 31 Jan 2021 15:20:57 PST
Received: from mail.as397444.net (mail.as397444.net [IPv6:2620:6e:a000:dead:beef:15:bad:f00d])
        by lindbergh.monkeyblade.net (Postfix) with UTF8SMTPS id 521E6C061573
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 15:20:57 -0800 (PST)
Received: by mail.as397444.net (Postfix) with UTF8SMTPSA id 18EB6479E60;
        Sun, 31 Jan 2021 23:17:12 +0000 (UTC)
X-DKIM-Note: Keys used to sign are likely public at https://as397444.net/dkim/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bluematt.me;
        s=1612132862; t=1612135032;
        bh=Z7r1nofAiJwgxKw5SKF1EGrZeU5YYebX8UBzH8odMd8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Ls7jW3UVjYa3fPW7fja1BcyTLzrwnWo1Ldd0l11Ao/2APKMv98saUw7U/ZFsbOZNC
         oW9I/0UoRKPMUIdPLzlY9lZ2xiw/diN18F8dPY0J+8MOUJoyt9ytDDgCKQNDl3SRBa
         RxhLN/8ZlzSnafRu6VYn7aGIf3IaZVOMrRyYRe7tru5DxGOOXXiwWDCGRKt7ZqIb5u
         1MypMcy0IMo0dsv0BNYB0zk3sPZW7vJnReWJH1nhIfn24pU1emioxCXMW8XHNmPj58
         FTL+jTaJKnfn9cgaj60t28gFxd0QREa8X8IVXlkyB2N+FGhklGVqu+VlGLBHtjRNOt
         DcoRFTJmPX5zw==
Subject: Re: [PATCH net] igb: Enable RSS for Intel I211 Ethernet Controller
To:     Nick Lowe <nick.lowe@gmail.com>, netdev@vger.kernel.org
Cc:     anthony.l.nguyen@intel.com, kuba@kernel.org,
        jesse.brandeburg@intel.com, intel-wired-lan@lists.osuosl.org,
        davem@davemloft.net
References: <20201221222502.1706-1-nick.lowe@gmail.com>
From:   Matt Corallo <linux-wired-list@bluematt.me>
Message-ID: <379d4ef3-02e5-f08a-1b04-21848e11a365@bluematt.me>
Date:   Sun, 31 Jan 2021 18:17:11 -0500
MIME-Version: 1.0
In-Reply-To: <20201221222502.1706-1-nick.lowe@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Given this fixes a major (albeit ancient) performance regression, is it not a candidate for backport? It landed on 
Tony's dev-queue branch with a Fixes tag but no stable CC.

Thanks,
Matt

On 12/21/20 5:25 PM, Nick Lowe wrote:
> The Intel I211 Ethernet Controller supports 2 Receive Side Scaling (RSS) queues.
> It should not be excluded from having this feature enabled.
> 
> Via commit c883de9fd787b6f49bf825f3de3601aeb78a7114
> E1000_MRQC_ENABLE_RSS_4Q was renamed to E1000_MRQC_ENABLE_RSS_MQ to
> indicate that this is a generic bit flag to enable queues and not
> a flag that is specific to devices that support 4 queues
> 
> The bit flag enables 2, 4 or 8 queues appropriately depending on the part.
> 
> Tested with a multicore CPU and frames were then distributed as expected.
> 
> This issue appears to have been introduced because of confusion caused
> by the prior name.
> 
> Signed-off-by: Nick Lowe <nick.lowe@gmail.com>
> ---
>   drivers/net/ethernet/intel/igb/igb_main.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> index 03f78fdb0dcd..87ac1d3e25cb 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -4482,8 +4482,7 @@ static void igb_setup_mrqc(struct igb_adapter *adapter)
>   		else
>   			mrqc |= E1000_MRQC_ENABLE_VMDQ;
>   	} else {
> -		if (hw->mac.type != e1000_i211)
> -			mrqc |= E1000_MRQC_ENABLE_RSS_MQ;
> +		mrqc |= E1000_MRQC_ENABLE_RSS_MQ;
>   	}
>   	igb_vmm_control(adapter);
>   
> 
