Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F010A23C108
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 22:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbgHDU5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 16:57:12 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:33454 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727045AbgHDU5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 16:57:12 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 074KuL9b111419;
        Tue, 4 Aug 2020 15:56:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1596574581;
        bh=GwPSW5fl3OD+EqwLcnAsaWavPhdkH819zGG0j850yMw=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=a6MoEKURk8JUeubkttK5Imr9Wa7yPWixo4vv7gixgnB0ikfpwwM+yQUhkoAtseQek
         KnxN7qA+Z6+/MkfprhJHOzQ1PHDfT6Y0VwuS8yojlPKxRESC48+rdynp6qla97YwzN
         BMJccdz9cZNC6PveuYknQ86Bnpjav3B8FpzvN9U8=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 074KuLDH014074
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 4 Aug 2020 15:56:21 -0500
Received: from DLEE109.ent.ti.com (157.170.170.41) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 4 Aug
 2020 15:56:20 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 4 Aug 2020 15:56:20 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 074KuGja023049;
        Tue, 4 Aug 2020 15:56:16 -0500
Subject: Re: [PATCH v3 1/9] ptp: Add generic ptp v2 header parsing function
To:     Kurt Kanzenbach <kurt@linutronix.de>,
        Petr Machata <petrm@mellanox.com>
CC:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>, <netdev@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>
References: <20200730080048.32553-1-kurt@linutronix.de>
 <20200730080048.32553-2-kurt@linutronix.de> <87lfj1gvgq.fsf@mellanox.com>
 <87pn8c0zid.fsf@kurt>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <09f58c4f-dec5-ebd1-3352-f2e240ddcbe5@ti.com>
Date:   Tue, 4 Aug 2020 23:56:12 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <87pn8c0zid.fsf@kurt>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 31/07/2020 13:06, Kurt Kanzenbach wrote:
> On Thu Jul 30 2020, Petr Machata wrote:
>> Kurt Kanzenbach <kurt@linutronix.de> writes:
>>
>>> @@ -107,6 +107,37 @@ unsigned int ptp_classify_raw(const struct sk_buff *skb)
>>>   }
>>>   EXPORT_SYMBOL_GPL(ptp_classify_raw);
>>>   
>>> +struct ptp_header *ptp_parse_header(struct sk_buff *skb, unsigned int type)
>>> +{
>>> +	u8 *data = skb_mac_header(skb);
>>> +	u8 *ptr = data;
>>
>> One of the "data" and "ptr" variables is superfluous.
> 
> Yeah. Can be shortened to u8 *ptr = skb_mac_header(skb);

Actually usage of skb_mac_header(skb) breaks CPTS RX time-stamping on
am571x platform PATCH 6.

The CPSW RX timestamp requested after full packet put in SKB, but
before calling eth_type_trans().

So, skb->data pints on Eth header, but skb_mac_header() return garbage.

Below diff fixes it for me.

--- a/net/core/ptp_classifier.c
+++ b/net/core/ptp_classifier.c
@@ -109,7 +109,7 @@ EXPORT_SYMBOL_GPL(ptp_classify_raw);
  
  struct ptp_header *ptp_parse_header(struct sk_buff *skb, unsigned int type)
  {
-       u8 *data = skb_mac_header(skb);
+       u8 *data = skb->data;
         u8 *ptr = data;
  
         if (type & PTP_CLASS_VLAN)

> 
> However, I'll wait a bit before sending the next version. So, that the
> other maintainers have time to test their drivers.

-- 
Best regards,
grygorii
