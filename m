Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1935D23AE63
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 22:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbgHCUrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 16:47:08 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:56636 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728515AbgHCUrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 16:47:08 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.62])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 90DAE600D8;
        Mon,  3 Aug 2020 20:47:07 +0000 (UTC)
Received: from us4-mdac16-75.ut7.mdlocal (unknown [10.7.64.194])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 8E8118009B;
        Mon,  3 Aug 2020 20:47:07 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.30])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 0C32428004D;
        Mon,  3 Aug 2020 20:47:07 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id A553A10008A;
        Mon,  3 Aug 2020 20:47:06 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 3 Aug 2020
 21:47:00 +0100
Subject: Re: [PATCH] net: sfc: fix possible buffer overflow caused by bad DMA
 value in efx_siena_sriov_vfdi()
To:     Jia-Ju Bai <baijiaju@tsinghua.edu.cn>,
        <linux-net-drivers@solarflare.com>, <mhabets@solarflare.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200802153930.5271-1-baijiaju@tsinghua.edu.cn>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <48330670-63d0-dec6-f102-1936d5f05355@solarflare.com>
Date:   Mon, 3 Aug 2020 21:46:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200802153930.5271-1-baijiaju@tsinghua.edu.cn>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25582.002
X-TM-AS-Result: No-0.311200-8.000000-10
X-TMASE-MatchedRID: scwq2vQP8OHmLzc6AOD8DfHkpkyUphL9V447DNvw38Z/Z0SyQdcmEKo6
        hcXA9s6kZz5CP6uFgj54Rs5B8MIvKEIyGZ9D/l2WUPktDdOX0fsR5c83KIxTTpA9cwIW2cWUyJN
        a6DYLgM2XUzspP39qoBSiTGLfVnzeIeFIFB+CV+wD2WXLXdz+Adi5W7Rf+s6QSQdzZTc1JgLzPv
        RcNNSOxmOW+f6Bz68/aOpAHcS05Hdk3PL9VnFakZ4CIKY/Hg3AcmfM3DjaQLHZs3HUcS/scCq2r
        l3dzGQ1SERKX67t9yWwS4uk2JEc8Apmdc+SSQBabq13Wt7q2Z1y6282DgK7ie7hl+IktQoMqBPD
        FU26PM5eCkHqPzCAfpj9s/3jjT8d2hDLTFmwtpMGxECHxaZMBwbZYBYdvap6SswcLuSaZJZzlLq
        E1zO6+EMMprcbiest
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--0.311200-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25582.002
X-MDID: 1596487627-CBdiEFYLbdy0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/08/2020 16:39, Jia-Ju Bai wrote:
> To fix this problem, "req->op" is assigned to a local variable, and then
> the driver accesses this variable instead of "req->op".
>
> Signed-off-by: Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
Not sure how necessary this is (or even if anyone's still usingSiena
 SR-IOV, since it needed a specially-patched libvirt to work), but I
 don't see any reason to refuse.
> diff --git a/drivers/net/ethernet/sfc/siena_sriov.c b/drivers/net/ethernet/sfc/siena_sriov.c
> index 83dcfcae3d4b..21a8482cbb3b 100644
> --- a/drivers/net/ethernet/sfc/siena_sriov.c
> +++ b/drivers/net/ethernet/sfc/siena_sriov.c
> @@ -875,6 +875,7 @@ static void efx_siena_sriov_vfdi(struct work_struct *work)
>  	struct vfdi_req *req = vf->buf.addr;
>  	struct efx_memcpy_req copy[2];
>  	int rc;
> +	u32 op = req->op;
Could you maybe fix up the xmas here, rather than making it worse?

Also, you didn't specify in your Subject line which tree this is for.

-ed
