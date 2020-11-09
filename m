Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A93EF2ABE4B
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 15:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730313AbgKIONV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 09:13:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53903 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727826AbgKIONS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 09:13:18 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kc7v1-0002TX-Oi; Mon, 09 Nov 2020 14:13:15 +0000
Subject: Re: net: dsa: hellcreek: Add support for hardware timestamping
To:     Kurt Kanzenbach <kurt@linutronix.de>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        ivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
References: <7c4b526c-b229-acdf-d22a-2bf4a206be5b@canonical.com>
 <87v9eer5qm.fsf@kurt>
From:   Colin Ian King <colin.king@canonical.com>
Message-ID: <b71b9ba5-c0f1-091f-be4a-8bfb365af87b@canonical.com>
Date:   Mon, 9 Nov 2020 14:13:15 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <87v9eer5qm.fsf@kurt>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/11/2020 13:59, Kurt Kanzenbach wrote:
> Hi Colin,
> 
> On Mon Nov 09 2020, Colin Ian King wrote:
>> Hi
>>
>> Static analysis on linux-next with Coverity has detected a potential
>> null pointer dereference issue on the following commit:
>>
>> commit f0d4ba9eff75a79fccb7793f4d9f12303d458603
>> Author: Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>
>> Date:   Tue Nov 3 08:10:58 2020 +0100
>>
>>     net: dsa: hellcreek: Add support for hardware timestamping
>>
>> The analysis is as follows:
>>
>> 323                /* Get nanoseconds from ptp packet */
>> 324                type = SKB_PTP_TYPE(skb);
>>
>>    4. returned_null: ptp_parse_header returns NULL (checked 10 out of 12
>> times).
>>    5. var_assigned: Assigning: hdr = NULL return value from
>> ptp_parse_header.
>>
>> 325                hdr  = ptp_parse_header(skb, type);
>>
>>    Dereference null return value (NULL_RETURNS)
>>    6. dereference: Dereferencing a pointer that might be NULL hdr when
>> calling hellcreek_get_reserved_field.
>>
>> 326                ns   = hellcreek_get_reserved_field(hdr);
>> 327                hellcreek_clear_reserved_field(hdr);
>>
>> This issue can only occur if the type & PTP_CLASS_PMASK is not one of
>> PTP_CLASS_IPV4, PTP_CLASS_IPV6 or PTP_CLASS_L2.  I'm not sure if this is
>> a possibility or not, but I'm assuming that it would be useful to
>> perform the null check just in case, but I'm not sure how this affects
>> the hw timestamping code in this function.
> 
> I don't see how the null pointer dereference could happen. That's the
> Rx path you showed above.
> 
> The counter part code is:
> 
> hellcreek_port_rxtstamp:
> 
> 	/* Make sure the message is a PTP message that needs to be timestamped
> 	 * and the interaction with the HW timestamping is enabled. If not, stop
> 	 * here
> 	 */
> 	hdr = hellcreek_should_tstamp(hellcreek, port, skb, type);
> 	if (!hdr)
> 		return false;
> 
> 	SKB_PTP_TYPE(skb) = type;
> 
> Here the type is stored and hellcreek_should_tstamp() also calls
> ptp_parse_header() internally. Only when ptp_parse_header() didn't
> return NULL the first time the timestamping continues. It should be
> safe.
> 
> Also the error handling would be interesting at that point. What should
> happen if the header is null then? Returning an invalid timestamp?
> Ignore it?
> 
> Hm. I think we have to make sure that it is a valid ptp packet before
> reaching this code and that's what we've implemented. So, I guess it's
> OK.

OK - thanks, I'll mark this as a false positive.

> 
> Thanks,
> Kurt
> 

