Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2868822420B
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 19:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgGQRkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 13:40:02 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:53002 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgGQRkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 13:40:01 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 06HHdvJr050812;
        Fri, 17 Jul 2020 12:39:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1595007597;
        bh=q+uV5H8PhIiItB099rfL6+xnCZi5MWUbsygzwPOLpns=;
        h=Subject:To:References:From:Date:In-Reply-To;
        b=ELSpKX3JiFn29aHn8ntqRY7V8tydy4hG0vuz78jLKUnnNA8VVoNIkwv4cmXlbBWWT
         LEWSymz3xNVsiNgYmsBR0d2N8O31YI/IZUKZpRmaQEOvBnICui7RagiZgZ0hoWj8re
         88NyRckoKzbpY79bDkB8zeTRDryev4H1gJbbNb8g=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 06HHdvQQ061694
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 17 Jul 2020 12:39:57 -0500
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 17
 Jul 2020 12:39:57 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 17 Jul 2020 12:39:57 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06HHdsIY017474;
        Fri, 17 Jul 2020 12:39:55 -0500
Subject: Re: [PATCH 1/2 v2] net: hsr: fix incorrect lsdu size in the tag of
 HSR frames for small frames
To:     Murali Karicheri <m-karicheri2@ti.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <nsekhar@ti.com>,
        <vinicius.gomes@intel.com>
References: <20200717145510.30433-1-m-karicheri2@ti.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <0e064d93-546d-e999-e36a-499d37137ba4@ti.com>
Date:   Fri, 17 Jul 2020 20:39:53 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200717145510.30433-1-m-karicheri2@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 17/07/2020 17:55, Murali Karicheri wrote:
> For small Ethernet frames with size less than minimum size 66 for HSR
> vs 60 for regular Ethernet frames, hsr driver currently doesn't pad the
> frame to make it minimum size. This results in incorrect LSDU size being
> populated in the HSR tag for these frames. Fix this by padding the frame
> to the minimum size applicable for HSR.
> 
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> ---
>   no change from original version
>   Sending this bug fix ahead of PRP patch series as per comment
>   net/hsr/hsr_forward.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
>   Sending this bug fix ahead of PRP patch series as per comment
> diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
> index ed13760463de..e42fd356f073 100644
> --- a/net/hsr/hsr_forward.c
> +++ b/net/hsr/hsr_forward.c
> @@ -127,6 +127,9 @@ static void hsr_fill_tag(struct sk_buff *skb, struct hsr_frame_info *frame,
>   	int lane_id;
>   	int lsdu_size;
>   
> +	/* pad to minimum packet size which is 60 + 6 (HSR tag) */
> +	skb_put_padto(skb, ETH_ZLEN + HSR_HLEN);

It may fail.
And i worry that it might be not the right place to do that
(if packet is small it will be called for every copy of the packet).
May be it has to be done once when packet enters LRE device?

> +
>   	if (port->type == HSR_PT_SLAVE_A)
>   		lane_id = 0;
>   	else
> 

-- 
Best regards,
grygorii
