Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14FA217259C
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 18:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729797AbgB0RtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 12:49:12 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:51098 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729382AbgB0RtM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 12:49:12 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 321FB1C007E;
        Thu, 27 Feb 2020 17:49:10 +0000 (UTC)
Received: from [10.17.20.62] (10.17.20.62) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Thu, 27 Feb
 2020 17:49:06 +0000
Subject: Re: [PATCH net] sfc: fix timestamp reconstruction at 16-bit rollover
 points
To:     "Alex Maftei (amaftei)" <amaftei@solarflare.com>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>
References: <ec166593-f68f-7834-e260-cd8ec6533054@solarflare.com>
From:   Martin Habets <mhabets@solarflare.com>
Message-ID: <d298a514-5b0b-eaab-6806-de10e3fe88f5@solarflare.com>
Date:   Thu, 27 Feb 2020 17:49:05 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <ec166593-f68f-7834-e260-cd8ec6533054@solarflare.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.62]
X-ClientProxiedBy: ukex01.SolarFlarecom.com (10.17.10.4) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25256.003
X-TM-AS-Result: No-13.960600-8.000000-10
X-TMASE-MatchedRID: vEvJ7Rh1lGjmLzc6AOD8DfHkpkyUphL9hlL5/PVMMhKfAKXk1rxjB6Dz
        5hsiacLfCBYfILTe9juM1sb/XspgZY9a6fUGbDyCelGHXZKLL2t6i696PjRPiB3RY4pGTCyHeWg
        68DhoEkmt2gtuWr1Lmm4+NMjYY4WNr84vp9dYZRYJ8QiVTQrM2ERJRb9jm/QSNNoPpAdRKUM4jV
        nV08GG4HBtBsSeq1LeglnBCQK4TVily8pda1+H2/RUId35VCIevMRNh9hLjFmbkEl1SMP4VUa8Q
        lWZfI6X+W2Elaj143OygDex2o1vRGoR/pevuvZYh2VzUlo4HVMX2zxRNhh61aJprKmdp8pPnpBW
        eVcwjKD8IXeaxVF71n0GFT5KU5MDTIunQAI8qaKeAiCmPx4NwLTrdaH1ZWqCeVl+oyOKCVfUZxE
        AlFPo846HM5rqDwqtWgFQFJNzOvZ8iJVeLZbnlznHRFnbYrdqDfqS4dlooiCE/nn0hGo12Q==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--13.960600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25256.003
X-MDID: 1582825751-63TopbljnO4F
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/02/2020 17:33, Alex Maftei (amaftei) wrote:
> We can't just use the top bits of the last sync event as they could be
> off-by-one every 65,536 seconds, giving an error in reconstruction of
> 65,536 seconds.
> 
> This patch uses the difference in the bottom 16 bits (mod 2^16) to
> calculate an offset that needs to be applied to the last sync event to
> get to the current time.
> 
> Signed-off-by: Alexandru-Mihai Maftei <amaftei@solarflare.com>

Acked-by: Martin Habets <mhabets@solarflare.com>

> ---
>  drivers/net/ethernet/sfc/ptp.c | 38 +++++++++++++++++++++++++++++++---
>  1 file changed, 35 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
> index af15a737c675..59b4f16896a8 100644
> --- a/drivers/net/ethernet/sfc/ptp.c
> +++ b/drivers/net/ethernet/sfc/ptp.c
> @@ -560,13 +560,45 @@ efx_ptp_mac_nic_to_ktime_correction(struct efx_nic *efx,
>  				    u32 nic_major, u32 nic_minor,
>  				    s32 correction)
>  {
> +	u32 sync_timestamp;
>  	ktime_t kt = { 0 };
> +	s16 delta;
>  
>  	if (!(nic_major & 0x80000000)) {
>  		WARN_ON_ONCE(nic_major >> 16);
> -		/* Use the top bits from the latest sync event. */
> -		nic_major &= 0xffff;
> -		nic_major |= (last_sync_timestamp_major(efx) & 0xffff0000);
> +
> +		/* Medford provides 48 bits of timestamp, so we must get the top
> +		 * 16 bits from the timesync event state.
> +		 *
> +		 * We only have the lower 16 bits of the time now, but we do
> +		 * have a full resolution timestamp at some point in past. As
> +		 * long as the difference between the (real) now and the sync
> +		 * is less than 2^15, then we can reconstruct the difference
> +		 * between those two numbers using only the lower 16 bits of
> +		 * each.
> +		 *
> +		 * Put another way
> +		 *
> +		 * a - b = ((a mod k) - b) mod k
> +		 *
> +		 * when -k/2 < (a-b) < k/2. In our case k is 2^16. We know
> +		 * (a mod k) and b, so can calculate the delta, a - b.
> +		 *
> +		 */
> +		sync_timestamp = last_sync_timestamp_major(efx);
> +
> +		/* Because delta is s16 this does an implicit mask down to
> +		 * 16 bits which is what we need, assuming
> +		 * MEDFORD_TX_SECS_EVENT_BITS is 16. delta is signed so that
> +		 * we can deal with the (unlikely) case of sync timestamps
> +		 * arriving from the future.
> +		 */
> +		delta = nic_major - sync_timestamp;
> +
> +		/* Recover the fully specified time now, by applying the offset
> +		 * to the (fully specified) sync time.
> +		 */
> +		nic_major = sync_timestamp + delta;
>  
>  		kt = ptp->nic_to_kernel_time(nic_major, nic_minor,
>  					     correction);
> 
