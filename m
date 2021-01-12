Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9392F32C9
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 15:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727463AbhALORe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 09:17:34 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:1251 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726235AbhALORe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 09:17:34 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ffdaf550002>; Tue, 12 Jan 2021 06:16:53 -0800
Received: from [172.27.11.205] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 12 Jan
 2021 14:16:48 +0000
Subject: Re: [PATCH net-next v3 2/2] net: flow_dissector: Parse PTP L2 packet
 header
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Guillaume Nault <gnault@redhat.com>,
        Andrew Lunn <andrew@lunn.ch>
References: <1610389068-2133-1-git-send-email-eranbe@nvidia.com>
 <1610389068-2133-3-git-send-email-eranbe@nvidia.com>
 <20210112134941.GA24407@hoboy.vegasvil.org>
From:   Eran Ben Elisha <eranbe@nvidia.com>
Message-ID: <4e1c8783-6e98-0b73-cb28-eaabf7c51cfb@nvidia.com>
Date:   Tue, 12 Jan 2021 16:16:46 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210112134941.GA24407@hoboy.vegasvil.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610461013; bh=upHyiDZBZ2FVWwxMvuDKc0GLJjXSKv9fxPemECgOhUM=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=LQO2sfGQ8YxwvjgmoK5H+Rg4SPfXmRD5WHhNCE8sDZ3W6Mj7PpvkHaed75fQkk0Aq
         QRbMQNVqtcdnfXQFcDmuWbIei94DPFvpjowBTweV4AzxSPXELNanXwOoRXOBgu0dwm
         MiYNFiiCaPDu5wKjvIUXq82QeyyFhVVgW/jqf79bAB+Ws9CqMuzlGC/vq+8AtsoN6k
         eEXcwYTohEZEOiCYmmRCnuhRv3DzOs8tBNQNCS1MAO8h1yRVQxCzRELfZB43AEN8q6
         ffEoR0XiluUNHvoBn+iXzanqQLUc8GN8JMhF+oXu1g7dhBY1BWxw8OUGktytZQO8XT
         soSxa8Vo2SOfg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/12/2021 3:49 PM, Richard Cochran wrote:
> On Mon, Jan 11, 2021 at 08:17:48PM +0200, Eran Ben Elisha wrote:
>> Add support for parsing PTP L2 packet header. Such packet consists
>> of an L2 header (with ethertype of ETH_P_1588), PTP header, body
>> and an optional suffix.
>>
>> Signed-off-by: Eran Ben Elisha <eranbe@nvidia.com>
>> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
>> ---
>>   net/core/flow_dissector.c | 16 ++++++++++++++++
>>   1 file changed, 16 insertions(+)
>>
>> diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
>> index 6f1adba6695f..fcaa223c7cdc 100644
>> --- a/net/core/flow_dissector.c
>> +++ b/net/core/flow_dissector.c
>> @@ -23,6 +23,7 @@
>>   #include <linux/if_ether.h>
>>   #include <linux/mpls.h>
>>   #include <linux/tcp.h>
>> +#include <linux/ptp_classify.h>
>>   #include <net/flow_dissector.h>
>>   #include <scsi/fc/fc_fcoe.h>
>>   #include <uapi/linux/batadv_packet.h>
>> @@ -1251,6 +1252,21 @@ bool __skb_flow_dissect(const struct net *net,
>>   						  &proto, &nhoff, hlen, flags);
>>   		break;
>>   
>> +	case htons(ETH_P_1588): {
>> +		struct ptp_header *hdr, _hdr;
>> +
>> +		hdr = __skb_header_pointer(skb, nhoff, sizeof(_hdr), data,
>> +					   hlen, &_hdr);
>> +		if (!hdr || (hlen - nhoff) < sizeof(_hdr)) {
> 
> I'm not really familiar with the flow dissector, but why check (hlen - nhoff) here?
> None of the other cases do that.  Doesn't skb_copy_bits() in
> __skb_header_pointer() already handle that?

You are right. I saw similar len validation at ETH_P_FCOE case. But now 
I see it does not go through __skb_header_pointer() flow.

Thanks.

> 
> Thanks,
> Richard
> 
> 
>> +			fdret = FLOW_DISSECT_RET_OUT_BAD;
>> +			break;
>> +		}
>> +
>> +		nhoff += ntohs(hdr->message_length);
>> +		fdret = FLOW_DISSECT_RET_OUT_GOOD;
>> +		break;
>> +	}
>> +
>>   	default:
>>   		fdret = FLOW_DISSECT_RET_OUT_BAD;
>>   		break;
>> -- 
>> 2.17.1
>>
