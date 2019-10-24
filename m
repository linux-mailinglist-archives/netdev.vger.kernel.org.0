Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C904E35D7
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 16:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406668AbfJXOom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 10:44:42 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:36696 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726838AbfJXOom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 10:44:42 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 7CE896C0096;
        Thu, 24 Oct 2019 14:44:39 +0000 (UTC)
Received: from cim-opti7060.uk.solarflarecom.com (10.17.20.154) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 24 Oct 2019 15:44:34 +0100
Subject: Re: [PATCH net-next 1/6] sfc: support encapsulation of xdp_frames in
 efx_tx_buffer.
To:     Jesper Dangaard Brouer <brouer@redhat.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-net-drivers@solarflare.com>
References: <05b72fdb-165c-1350-787b-ca8c5261c459@solarflare.com>
 <7eca8299-a6bf-5d47-1815-4d2cfa87c070@solarflare.com>
 <20191023001917.59f51f52@carbon>
From:   Charles McLachlan <cmclachlan@solarflare.com>
Message-ID: <fa035bcc-88ef-5bc2-96ae-46b05987b0dd@solarflare.com>
Date:   Thu, 24 Oct 2019 15:44:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191023001917.59f51f52@carbon>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.154]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24998.003
X-TM-AS-Result: No-2.810100-8.000000-10
X-TMASE-MatchedRID: VPleTT1nwdTmLzc6AOD8DfHkpkyUphL9eouvej40T4gd0WOKRkwsh3lo
        OvA4aBJJrdoLblq9S5ra/g/NGTW3MjmzjEr3tKb/Lyz9QvAyHjolfqmUl3Kc1dZd/DOmlnxICiJ
        8KlIiyymCRs05n+R8uwuhyQBNugjgHzoyklNKQhGVOwZbcOalS+uLFZZYlisfTX7PJ/OU3vK9ox
        GQAU8pjWMVPzx/r2cb+gtHj7OwNO33FLeZXNZS4IzHo47z5Aa+IWoQlF9HP/rJb/PtUdoxT2xyh
        geUeUmezdR8QmMisuVIQpzzf8r2AUCk5NW1zza9oxjxxrOP1bPiT8oz+yD/mBwocI/C6oai1DXs
        KeBNv04EqZlWBkJWd7MZNZFdSWvHG2wlTHLNY1JWXGvUUmKP2w==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.810100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24998.003
X-MDID: 1571928280-2x8QKCam4gDD
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/10/2019 23:19, Jesper Dangaard Brouer wrote:
>> diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
>> index 65e81ec1b314..9905e8952a45 100644
>> --- a/drivers/net/ethernet/sfc/tx.c
>> +++ b/drivers/net/ethernet/sfc/tx.c
>> @@ -95,6 +95,8 @@ static void efx_dequeue_buffer(struct efx_tx_queue *tx_queue,
>>  		netif_vdbg(tx_queue->efx, tx_done, tx_queue->efx->net_dev,
>>  			   "TX queue %d transmission id %x complete\n",
>>  			   tx_queue->queue, tx_queue->read_count);
>> +	} else if (buffer->flags & EFX_TX_BUF_XDP) {
>> +		xdp_return_frame(buffer->xdpf);
> 
> Is this efx_dequeue_buffer() function always called under NAPI protection?
> (So it could use the faster xdp_return_frame_rx_napi() ... ?)

Yes, it *is* always called from NAPI, so I've changed it to use xdp_return_frame_rx_napi. 
