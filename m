Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBC2622619B
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 16:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbgGTOII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 10:08:08 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:47972 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgGTOII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 10:08:08 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 06KE82WL122938;
        Mon, 20 Jul 2020 09:08:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1595254083;
        bh=WQqhwdxJ663Ia7EcUnMz0X2DPv/osz4DluxYJnOHhdg=;
        h=Subject:To:References:From:Date:In-Reply-To;
        b=AzIDzgxQEvUnLaiRrTOVf9Xx4gpcpnYbO3KYw17wmCWEnkzBanFZunBWmZBPWgMsm
         t+o5YECfndW5Vkshw6mjzixH/oKbmR/R5TTqfOzPeOLlQE356qHyH+Khuf9a7ghCds
         sa8Aw0/kmYNK6NRDfkyLj49J2Jzalb/0nhcvqKNs=
Received: from DLEE111.ent.ti.com (dlee111.ent.ti.com [157.170.170.22])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 06KE829e121852
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 20 Jul 2020 09:08:02 -0500
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 20
 Jul 2020 09:08:01 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 20 Jul 2020 09:08:01 -0500
Received: from [10.250.74.234] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06KE81U5047112;
        Mon, 20 Jul 2020 09:08:01 -0500
Subject: Re: [PATCH 1/2 v2] net: hsr: fix incorrect lsdu size in the tag of
 HSR frames for small frames
To:     Grygorii Strashko <grygorii.strashko@ti.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <nsekhar@ti.com>,
        <vinicius.gomes@intel.com>
References: <20200717145510.30433-1-m-karicheri2@ti.com>
 <0e064d93-546d-e999-e36a-499d37137ba4@ti.com>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <ad869a7c-fe39-8b75-c235-d65005cd9c32@ti.com>
Date:   Mon, 20 Jul 2020 10:08:00 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0e064d93-546d-e999-e36a-499d37137ba4@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Grygorii,

On 7/17/20 1:39 PM, Grygorii Strashko wrote:
> 
> 
> On 17/07/2020 17:55, Murali Karicheri wrote:
>> For small Ethernet frames with size less than minimum size 66 for HSR
>> vs 60 for regular Ethernet frames, hsr driver currently doesn't pad the
>> frame to make it minimum size. This results in incorrect LSDU size being
>> populated in the HSR tag for these frames. Fix this by padding the frame
>> to the minimum size applicable for HSR.
>>
>> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>> ---
>>   no change from original version
>>   Sending this bug fix ahead of PRP patch series as per comment
>>   net/hsr/hsr_forward.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>>   Sending this bug fix ahead of PRP patch series as per comment
>> diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
>> index ed13760463de..e42fd356f073 100644
>> --- a/net/hsr/hsr_forward.c
>> +++ b/net/hsr/hsr_forward.c
>> @@ -127,6 +127,9 @@ static void hsr_fill_tag(struct sk_buff *skb, 
>> struct hsr_frame_info *frame,
>>       int lane_id;
>>       int lsdu_size;
>> +    /* pad to minimum packet size which is 60 + 6 (HSR tag) */
>> +    skb_put_padto(skb, ETH_ZLEN + HSR_HLEN);
> 
> It may fail.
> And i worry that it might be not the right place to do that
> (if packet is small it will be called for every copy of the packet).
> May be it has to be done once when packet enters LRE device?
> 
A better place may be to add it at the beginning of
hsr_fill_frame_info() at which point there is one copy and after that
code enters hsr_forward_do() to replicate. I don't think we can place it
anywhere before that code.

hsr_dev_xmit()
    - hsr_forward_skb()
       - hsr_fill_frame_info()

Inside hsr_fill_frame_info() we could do

	if (ethhdr->h_proto == htons(ETH_P_8021Q)) {
		frame->is_vlan = true;
		/* FIXME: */
		netdev_warn_once(skb->dev, "VLAN not yet supported");
	}
+	min_size = ETH_ZLEN + HSR_HLEN;
+       if (frame->is_vlan)
+		min_size += 4;
+	ret = skb_put_padto(skb, min_size))
+	if (ret)
+	     return ret;

At this point, it will be ready to tag the frame. Frame will be either a
supervision frame which is already tagged or standard frame from upper
layer. Either case, padto() is required. So looks like the right place
to avoid doing it twice.

And packet would get dropped at the caller if skb_put_padto() fails. So
we could return the return value to the caller.

This also eliminates similar padto() call in 
send_hsr_supervision_frame() as well.

What do you think?

Murali
>> +
>>       if (port->type == HSR_PT_SLAVE_A)
>>           lane_id = 0;
>>       else
>>
> 

-- 
Murali Karicheri
Texas Instruments
