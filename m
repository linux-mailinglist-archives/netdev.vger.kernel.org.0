Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0869D23C193
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 23:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbgHDVfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 17:35:16 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:38952 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726472AbgHDVfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 17:35:16 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 074LYuEF120897;
        Tue, 4 Aug 2020 16:34:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1596576896;
        bh=0DWV7Pu5fIL8Y6q1M+t9jizUL+aYopFzmuQHuxvWOgc=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=xWisHsZeNtar4rIbmn9KF27AgK/RDqWbKIVOzH5i6qltUzkwy3rorxDhaZgMifDLC
         Uk5v795wDAKYoIzaX8Kg8HSq2eYi4H3HeDMY48LXgSoXtkluvrFFh0ScQETgSv3FSI
         c7IFH0fQyeqSNZYwAiKFqUuN9q2NWnhfbdRWSHDQ=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 074LYuMi063403
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 4 Aug 2020 16:34:56 -0500
Received: from DFLE102.ent.ti.com (10.64.6.23) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 4 Aug
 2020 16:34:55 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 4 Aug 2020 16:34:55 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 074LYoMU075708;
        Tue, 4 Aug 2020 16:34:51 -0500
Subject: Re: [PATCH v3 1/9] ptp: Add generic ptp v2 header parsing function
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Kurt Kanzenbach <kurt@linutronix.de>,
        Petr Machata <petrm@mellanox.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>, <netdev@vger.kernel.org>
References: <20200730080048.32553-1-kurt@linutronix.de>
 <20200730080048.32553-2-kurt@linutronix.de> <87lfj1gvgq.fsf@mellanox.com>
 <87pn8c0zid.fsf@kurt> <09f58c4f-dec5-ebd1-3352-f2e240ddcbe5@ti.com>
 <20200804210759.GU1551@shell.armlinux.org.uk>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <45130ed9-7429-f1cd-653b-64417d5a93aa@ti.com>
Date:   Wed, 5 Aug 2020 00:34:47 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200804210759.GU1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 05/08/2020 00:07, Russell King - ARM Linux admin wrote:
> On Tue, Aug 04, 2020 at 11:56:12PM +0300, Grygorii Strashko wrote:
>>
>>
>> On 31/07/2020 13:06, Kurt Kanzenbach wrote:
>>> On Thu Jul 30 2020, Petr Machata wrote:
>>>> Kurt Kanzenbach <kurt@linutronix.de> writes:
>>>>
>>>>> @@ -107,6 +107,37 @@ unsigned int ptp_classify_raw(const struct sk_buff *skb)
>>>>>    }
>>>>>    EXPORT_SYMBOL_GPL(ptp_classify_raw);
>>>>> +struct ptp_header *ptp_parse_header(struct sk_buff *skb, unsigned int type)
>>>>> +{
>>>>> +	u8 *data = skb_mac_header(skb);
>>>>> +	u8 *ptr = data;
>>>>
>>>> One of the "data" and "ptr" variables is superfluous.
>>>
>>> Yeah. Can be shortened to u8 *ptr = skb_mac_header(skb);
>>
>> Actually usage of skb_mac_header(skb) breaks CPTS RX time-stamping on
>> am571x platform PATCH 6.
>>
>> The CPSW RX timestamp requested after full packet put in SKB, but
>> before calling eth_type_trans().
>>
>> So, skb->data pints on Eth header, but skb_mac_header() return garbage.
>>
>> Below diff fixes it for me.
> 
> However, that's likely to break everyone else.
> 
> For example, anyone calling this from the mii_timestamper rxtstamp()
> method, the skb will have been classified with the MAC header pushed
> and restored, so skb->data points at the network header.
> 
> Your change means that ptp_parse_header() expects the MAC header to
> also be pushed.
> 
> Is it possible to adjust CPTS?
> 
> Looking at:
> drivers/net/ethernet/ti/cpsw.c... yes.
> drivers/net/ethernet/ti/cpsw_new.c... yes.
> drivers/net/ethernet/ti/netcp_core.c... unclear.
> 
> If not, maybe cpts should remain unconverted - I don't see any reason
> to provide a generic function for one user.
> 

Could it be an option to pass "u8 *ptr" instead of "const struct sk_buff *skb" as
input parameter to ptp_parse_header()?

-- 
Best regards,
grygorii
