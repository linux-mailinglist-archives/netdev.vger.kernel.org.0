Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D782F2B4446
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 14:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728624AbgKPNCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 08:02:08 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:37704 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728583AbgKPNCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 08:02:08 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0AGD1lKr072874;
        Mon, 16 Nov 2020 07:01:47 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1605531707;
        bh=qOn9VBecldSCPtkfrayvV0l2cc/JVvoAqmkbFZ+As/A=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=bGPU51Cb9p4KckeEvI9sPoNtqV3fX1E6/YX8YXmum5L3fx2mriEjOkxLD8AByQRtd
         pR0WP2G7fpl9l4l27YlaaWYsCOZku8DaUJ9ioxtdOzY7cAdavId4Hq0pylGAwidDtx
         16Cqv7pilOk1iQ6kEVWbC0J7fEpxAZ0Gef3z/WK0=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0AGD1ldX046622
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 16 Nov 2020 07:01:47 -0600
Received: from DFLE115.ent.ti.com (10.64.6.36) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 16
 Nov 2020 07:01:46 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 16 Nov 2020 07:01:46 -0600
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0AGD1hsN035807;
        Mon, 16 Nov 2020 07:01:44 -0600
Subject: Re: [PATCH net-next 2/3] net: ethernet: ti: cpsw_new: enable
 broadcast/multicast rate limit support
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Tony Lindgren <tony@atomide.com>
References: <20201114035654.32658-1-grygorii.strashko@ti.com>
 <20201114035654.32658-3-grygorii.strashko@ti.com>
 <20201114190909.cc3rlnvom6wf2zkg@skbuf>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <7c288b6d-f32f-c5a9-8e8c-ab377423d4a8@ti.com>
Date:   Mon, 16 Nov 2020 15:01:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201114190909.cc3rlnvom6wf2zkg@skbuf>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 14/11/2020 21:09, Vladimir Oltean wrote:
> On Sat, Nov 14, 2020 at 05:56:53AM +0200, Grygorii Strashko wrote:
>> This patch enables support for ingress broadcast(BC)/multicast(MC) rate limiting
>> in TI CPSW switchdev driver (the corresponding ALE support was added in previous
>> patch) by implementing HW offload for simple tc-flower policer with matches
>> on dst_mac:
>>   - ff:ff:ff:ff:ff:ff has to be used for BC rate limiting
>>   - 01:00:00:00:00:00 fixed value has to be used for MC rate limiting
>>
>> Hence tc policer defines rate limit in terms of bits per second, but the
>> ALE supports limiting in terms of packets per second - the rate limit
>> bits/sec is converted to number of packets per second assuming minimum
>> Ethernet packet size ETH_ZLEN=60 bytes.
>>
>> Examples:
>> - BC rate limit to 1000pps:
>>    tc qdisc add dev eth0 clsact
>>    tc filter add dev eth0 ingress flower skip_sw dst_mac ff:ff:ff:ff:ff:ff \
>>    action police rate 480kbit burst 64k
>>
>>    rate 480kbit - 1000pps * 60 bytes * 8, burst - not used.
>>
>> - MC rate limit to 20000pps:
>>    tc qdisc add dev eth0 clsact
>>    tc filter add dev eth0 ingress flower skip_sw dst_mac 01:00:00:00:00:00 \
>>    action police rate 9600kbit burst 64k
>>
>>    rate 9600kbit - 20000pps * 60 bytes * 8, burst - not used.
>>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>> ---
> 
> Your example for multicast would actually be correct if you specified
> the mask as well. Like this:
> 
> tc filter add dev eth0 ingress flower skip_sw \
> 	dst_mac 01:00:00:00:00:00/01:00:00:00:00:00 \
> 	action police rate 9600kbit burst 64k
> 
> But as things stand, the flow rule would have a certain meaning in
> software (rate-limit only that particular multicast MAC address) and a
> different meaning in hardware. Please modify the driver code to also
> match on the mask.
> 

ok.

-- 
Best regards,
grygorii
