Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87892182CC5
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 10:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgCLJxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 05:53:12 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:39018 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726023AbgCLJxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 05:53:12 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 79B91A40064;
        Thu, 12 Mar 2020 09:53:10 +0000 (UTC)
Received: from [10.17.20.62] (10.17.20.62) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Thu, 12 Mar
 2020 09:53:06 +0000
Subject: Re: [PATCH 6/7] sfc: Use scnprintf() for avoiding potential buffer
 overflow
To:     Takashi Iwai <tiwai@suse.de>, <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Edward Cree <ecree@solarflare.com>
References: <20200311083745.17328-1-tiwai@suse.de>
 <20200311083745.17328-7-tiwai@suse.de>
From:   Martin Habets <mhabets@solarflare.com>
Message-ID: <92ac1339-892c-20de-1547-02a8eee85f12@solarflare.com>
Date:   Thu, 12 Mar 2020 09:53:05 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200311083745.17328-7-tiwai@suse.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.62]
X-ClientProxiedBy: ukex01.SolarFlarecom.com (10.17.10.4) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25284.003
X-TM-AS-Result: No-7.758900-8.000000-10
X-TMASE-MatchedRID: QfHZjzml1E/oSitJVour/QGdJZ3Knh6hOhJ9m53n4aBIXJo+eGm+FCGU
        b2JNxi1quGFmdKFVj3qDfOmzG3QTUPjqQjcYI9V+9u1rQ4BgXPLpVMb1xnESMmMunwKby/AXeWg
        68DhoEkmt2gtuWr1Lmtr+D80ZNbcy4yB02OeSDEniNGQgiadfQ4LFgHaE9Li9JLfQYoCQHFZ9aW
        vTi9VKSmiY9ityJJpYNM/hLAtRgkJzt4swJJfEYYicBKfMHlV8Oq7WO79QiaebKItl61J/ycnjL
        TA/UDoAoTCA5Efyn8C5G5ZK4Ai7+N0H8LFZNFG76sBnwpOylLMiWbqqcyvAuwhfsHYFXMu+6ZIX
        1dOhGK68Q23kGC1wPWAuOCjmrLCvqaNbOLSpK5F0lFg7620FNePFtGiUnux5NL8bN/KbK7uigEH
        y7J4S6ylkreA5r24aYnCi5itk3iprD5+Qup1qU37cGd19dSFd
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--7.758900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25284.003
X-MDID: 1584006791-wQ01YOy_1Rh0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Takashi,

Fix looks ok, but could you please fix the alignment of the subsequent lines as well?

Thanks,
Martin

On 11/03/2020 08:37, Takashi Iwai wrote:
> Since snprintf() returns the would-be-output size instead of the
> actual output size, the succeeding calls may go beyond the given
> buffer limit.  Fix it by replacing with scnprintf().
> 
> Cc: Solarflare linux maintainers <linux-net-drivers@solarflare.com>
> Cc: Edward Cree <ecree@solarflare.com>
> Cc: Martin Habets <mhabets@solarflare.com>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  drivers/net/ethernet/sfc/mcdi.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/mcdi.c
> index 2713300343c7..ac978e24644f 100644
> --- a/drivers/net/ethernet/sfc/mcdi.c
> +++ b/drivers/net/ethernet/sfc/mcdi.c
> @@ -212,11 +212,11 @@ static void efx_mcdi_send_request(struct efx_nic *efx, unsigned cmd,
>  		 * progress on a NIC at any one time.  So no need for locking.
>  		 */
>  		for (i = 0; i < hdr_len / 4 && bytes < PAGE_SIZE; i++)
> -			bytes += snprintf(buf + bytes, PAGE_SIZE - bytes,
> +			bytes += scnprintf(buf + bytes, PAGE_SIZE - bytes,
>  					  " %08x", le32_to_cpu(hdr[i].u32[0]));
>  
>  		for (i = 0; i < inlen / 4 && bytes < PAGE_SIZE; i++)
> -			bytes += snprintf(buf + bytes, PAGE_SIZE - bytes,
> +			bytes += scnprintf(buf + bytes, PAGE_SIZE - bytes,
>  					  " %08x", le32_to_cpu(inbuf[i].u32[0]));
>  
>  		netif_info(efx, hw, efx->net_dev, "MCDI RPC REQ:%s\n", buf);
> @@ -302,14 +302,14 @@ static void efx_mcdi_read_response_header(struct efx_nic *efx)
>  		 */
>  		for (i = 0; i < hdr_len && bytes < PAGE_SIZE; i++) {
>  			efx->type->mcdi_read_response(efx, &hdr, (i * 4), 4);
> -			bytes += snprintf(buf + bytes, PAGE_SIZE - bytes,
> +			bytes += scnprintf(buf + bytes, PAGE_SIZE - bytes,
>  					  " %08x", le32_to_cpu(hdr.u32[0]));
>  		}
>  
>  		for (i = 0; i < data_len && bytes < PAGE_SIZE; i++) {
>  			efx->type->mcdi_read_response(efx, &hdr,
>  					mcdi->resp_hdr_len + (i * 4), 4);
> -			bytes += snprintf(buf + bytes, PAGE_SIZE - bytes,
> +			bytes += scnprintf(buf + bytes, PAGE_SIZE - bytes,
>  					  " %08x", le32_to_cpu(hdr.u32[0]));
>  		}
>  
> @@ -1417,7 +1417,7 @@ void efx_mcdi_print_fwver(struct efx_nic *efx, char *buf, size_t len)
>  	}
>  
>  	ver_words = (__le16 *)MCDI_PTR(outbuf, GET_VERSION_OUT_VERSION);
> -	offset = snprintf(buf, len, "%u.%u.%u.%u",
> +	offset = scnprintf(buf, len, "%u.%u.%u.%u",
>  			  le16_to_cpu(ver_words[0]), le16_to_cpu(ver_words[1]),
>  			  le16_to_cpu(ver_words[2]), le16_to_cpu(ver_words[3]));
>  
> @@ -1427,7 +1427,7 @@ void efx_mcdi_print_fwver(struct efx_nic *efx, char *buf, size_t len)
>  	if (efx_nic_rev(efx) >= EFX_REV_HUNT_A0) {
>  		struct efx_ef10_nic_data *nic_data = efx->nic_data;
>  
> -		offset += snprintf(buf + offset, len - offset, " rx%x tx%x",
> +		offset += scnprintf(buf + offset, len - offset, " rx%x tx%x",
>  				   nic_data->rx_dpcpu_fw_id,
>  				   nic_data->tx_dpcpu_fw_id);
>  
> 
