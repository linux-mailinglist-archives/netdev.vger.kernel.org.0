Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E39021C1E0
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 07:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfENFd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 01:33:58 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:54216 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725935AbfENFd6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 01:33:58 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hQQ4T-0007fL-Pu; Tue, 14 May 2019 08:33:49 +0300
Message-ID: <befa7d4791e2031ca86cd2e0d4721d166b0f38db.camel@coelho.fi>
Subject: Re: [PATCH] net: wireless: iwlwifi: Fix double-free problems in
 iwl_req_fw_callback()
From:   Luca Coelho <luca@coelho.fi>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>, johannes.berg@intel.com,
        emmanuel.grumbach@intel.com, linuxwifi@intel.com,
        kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 14 May 2019 08:33:47 +0300
In-Reply-To: <20190504093305.19360-1-baijiaju1990@gmail.com>
References: <20190504093305.19360-1-baijiaju1990@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2019-05-04 at 17:33 +0800, Jia-Ju Bai wrote:
> In the error handling code of iwl_req_fw_callback(),
> iwl_dealloc_ucode()
> is called to free data. In iwl_drv_stop(), iwl_dealloc_ucode() is
> called
> again, which can cause double-free problems.
> 
> To fix this bug, the call to iwl_dealloc_ucode() in
> iwl_req_fw_callback() is deleted.
> 
> This bug is found by a runtime fuzzing tool named FIZZER written by
> us.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
>  drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
> b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
> index 689a65b11cc3..4fd1737d768b 100644
> --- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
> +++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
> @@ -1579,7 +1579,6 @@ static void iwl_req_fw_callback(const struct
> firmware *ucode_raw, void *context)
>  	goto free;
>  
>   out_free_fw:
> -	iwl_dealloc_ucode(drv);
>  	release_firmware(ucode_raw);
>   out_unbind:
>  	complete(&drv->request_firmware_complete);

Thanks! Applied to our internal tree and will reach the mainline
following our normal upstreaming process.

--
Cheers,
Luca.

