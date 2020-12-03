Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 106872CDB9C
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 17:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbgLCQyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 11:54:14 -0500
Received: from spam.lhost.no ([5.158.192.85]:38565 "EHLO mx04.lhost.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726257AbgLCQyO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 11:54:14 -0500
X-ASG-Debug-ID: 1607014400-0ffc0612ed3f8aa0001-BZBGGp
Received: from s103.paneda.no ([5.158.193.76]) by mx04.lhost.no with ESMTP id DGa9vBDgEE621j3G (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NO); Thu, 03 Dec 2020 17:53:22 +0100 (CET)
X-Barracuda-Envelope-From: thomas.karlsson@paneda.se
X-Barracuda-Effective-Source-IP: UNKNOWN[5.158.193.76]
X-Barracuda-Apparent-Source-IP: 5.158.193.76
X-ASG-Whitelist: Client
Received: from [192.168.10.188] (83.140.179.234) by s103.paneda.no
 (10.16.55.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.1979.3; Thu, 3 Dec
 2020 17:53:19 +0100
Subject: Re: [PATCH net-next v4] macvlan: Support for high multicast packet
 rate
To:     Jakub Kicinski <kuba@kernel.org>
X-ASG-Orig-Subj: Re: [PATCH net-next v4] macvlan: Support for high multicast packet
 rate
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>, <jiri@resnulli.us>,
        <kaber@trash.net>, <edumazet@google.com>, <vyasevic@redhat.com>,
        <alexander.duyck@gmail.com>
References: <485531aec7e243659ee4e3bb7fa2186d@paneda.se>
 <147b704ac1d5426fbaa8617289dad648@paneda.se>
 <20201123143052.1176407d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <dd4673b2-7eab-edda-6815-85c67ce87f63@paneda.se>
 <20201203082038.3dab8511@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   Thomas Karlsson <thomas.karlsson@paneda.se>
Message-ID: <f8172596-ba59-9e30-c4f1-8cf8fb7d6493@paneda.se>
Date:   Thu, 3 Dec 2020 17:53:19 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201203082038.3dab8511@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [83.140.179.234]
X-ClientProxiedBy: s103.paneda.no (10.16.55.12) To s103.paneda.no
 (10.16.55.12)
X-Barracuda-Connect: UNKNOWN[5.158.193.76]
X-Barracuda-Start-Time: 1607014402
X-Barracuda-Encrypted: ECDHE-RSA-AES256-SHA384
X-Barracuda-URL: https://mx04.lhost.no:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at lhost.no
X-Barracuda-Scan-Msg-Size: 2127
X-Barracuda-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Wed, 2 Dec 2020 19:49:58 +0100 Thomas Karlsson wrote:
>> Background:
>> Broadcast and multicast packages are enqueued for later processing.
>> This queue was previously hardcoded to 1000.
>>
>> This proved insufficient for handling very high packet rates.
>> This resulted in packet drops for multicast.
>> While at the same time unicast worked fine.
>>
>> The change:
>> This patch make the queue length adjustable to accommodate
>> for environments with very high multicast packet rate.
>> But still keeps the default value of 1000 unless specified.
>>
>> The queue length is specified as a request per macvlan
>> using the IFLA_MACVLAN_BC_QUEUE_LEN parameter.
>>
>> The actual used queue length will then be the maximum of
>> any macvlan connected to the same port. The actual used
>> queue length for the port can be retrieved (read only)
>> by the IFLA_MACVLAN_BC_QUEUE_LEN_USED parameter for verification.
>>
>> This will be followed up by a patch to iproute2
>> in order to adjust the parameter from userspace.
>>
>> Signed-off-by: Thomas Karlsson <thomas.karlsson@paneda.se>
> 
>> @@ -1658,6 +1680,8 @@ static const struct nla_policy macvlan_policy[IFLA_MACVLAN_MAX + 1] = {
>>  	[IFLA_MACVLAN_MACADDR] = { .type = NLA_BINARY, .len = MAX_ADDR_LEN },
>>  	[IFLA_MACVLAN_MACADDR_DATA] = { .type = NLA_NESTED },
>>  	[IFLA_MACVLAN_MACADDR_COUNT] = { .type = NLA_U32 },
>> +	[IFLA_MACVLAN_BC_QUEUE_LEN] = { .type = NLA_U32 },
> 
> I wonder whether we should require that the queue_len is > 0? Is there 
> a valid use case for the queue to be completely disabled? If you agree
> please follow up with a simple patch which adds a NLA_POLICY_MIN() here.

Well, I did consider if I should put in a limit like that but then came
to the conclusion that is probably wise not to make any assumption on everyone else's
use cases. I can't really think of a reason why you want to disable the queue completely.
However, I think it still makes sense to allow that in case someone somewhere in the future
does find that useful.

> Applied to net-next, thank you!
> 

Awesome, thanks!
