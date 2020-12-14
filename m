Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D98582D9E39
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 18:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbgLNRvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 12:51:52 -0500
Received: from mx04.lhost.no ([5.158.192.85]:48184 "EHLO mx04.lhost.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440514AbgLNRvQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 12:51:16 -0500
X-ASG-Debug-ID: 1607968228-0ffc0612ed60a550001-BZBGGp
Received: from s103.paneda.no ([5.158.193.76]) by mx04.lhost.no with ESMTP id 1XOmUIwG5l6ltLNJ (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NO); Mon, 14 Dec 2020 18:50:29 +0100 (CET)
X-Barracuda-Envelope-From: thomas.karlsson@paneda.se
X-Barracuda-Effective-Source-IP: UNKNOWN[5.158.193.76]
X-Barracuda-Apparent-Source-IP: 5.158.193.76
X-ASG-Whitelist: Client
Received: from [192.168.10.188] (83.140.179.234) by s103.paneda.no
 (10.16.55.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.1979.3; Mon, 14
 Dec 2020 18:50:25 +0100
Subject: Re: [PATCH iproute2-next v2] iplink:macvlan: Added bcqueuelen
 parameter
To:     David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
X-ASG-Orig-Subj: Re: [PATCH iproute2-next v2] iplink:macvlan: Added bcqueuelen
 parameter
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <stephen@networkplumber.org>,
        <kuznet@ms2.inr.ac.ru>
References: <485531aec7e243659ee4e3bb7fa2186d@paneda.se>
 <147b704ac1d5426fbaa8617289dad648@paneda.se>
 <20201123143052.1176407d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <892be191-c948-4538-e46d-437c3f3a118c@paneda.se>
 <25e06e96-3c8d-06c0-4148-3409d7cecc6a@gmail.com>
From:   Thomas Karlsson <thomas.karlsson@paneda.se>
Message-ID: <ffe5b799-b9d9-369d-54fb-b8e87d8a462c@paneda.se>
Date:   Mon, 14 Dec 2020 18:50:27 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <25e06e96-3c8d-06c0-4148-3409d7cecc6a@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: sv
Content-Transfer-Encoding: 7bit
X-Originating-IP: [83.140.179.234]
X-ClientProxiedBy: s103.paneda.no (10.16.55.12) To s103.paneda.no
 (10.16.55.12)
X-Barracuda-Connect: UNKNOWN[5.158.193.76]
X-Barracuda-Start-Time: 1607968229
X-Barracuda-Encrypted: ECDHE-RSA-AES256-SHA384
X-Barracuda-URL: https://mx04.lhost.no:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at lhost.no
X-Barracuda-Scan-Msg-Size: 3319
X-Barracuda-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-14 18:03, David Ahern wrote:
> On 12/14/20 3:42 AM, Thomas Karlsson wrote:
>> This patch allows the user to set and retrieve the
>> IFLA_MACVLAN_BC_QUEUE_LEN parameter via the bcqueuelen
>> command line argument
>>
>> This parameter controls the requested size of the queue for
>> broadcast and multicast packages in the macvlan driver.
>>
>> If not specified, the driver default (1000) will be used.
>>
>> Note: The request is per macvlan but the actually used queue
>> length per port is the maximum of any request to any macvlan
>> connected to the same port.
>>
>> For this reason, the used queue length IFLA_MACVLAN_BC_QUEUE_LEN_USED
>> is also retrieved and displayed in order to aid in the understanding
>> of the setting. However, it can of course not be directly set.
>>
>> Signed-off-by: Thomas Karlsson <thomas.karlsson@paneda.se>
>> ---
>>
>> Note: This patch controls the parameter added in net-next
>> with commit d4bff72c8401e6f56194ecf455db70ebc22929e2
>>
>> v2 Rebased on origin/main
>> v1 Initial version
>>
>>  ip/iplink_macvlan.c   | 33 +++++++++++++++++++++++++++++++--
>>  man/man8/ip-link.8.in | 33 +++++++++++++++++++++++++++++++++
>>  2 files changed, 64 insertions(+), 2 deletions(-)
>>
>> diff --git a/ip/iplink_macvlan.c b/ip/iplink_macvlan.c
>> index b966a615..302a3748 100644
>> --- a/ip/iplink_macvlan.c
>> +++ b/ip/iplink_macvlan.c
>> @@ -30,12 +30,13 @@
>>  static void print_explain(struct link_util *lu, FILE *f)
>>  {
>>  	fprintf(f,
>> -		"Usage: ... %s mode MODE [flag MODE_FLAG] MODE_OPTS\n"
>> +		"Usage: ... %s mode MODE [flag MODE_FLAG] MODE_OPTS [bcqueuelen BC_QUEUE_LEN]\n"
>>  		"\n"
>>  		"MODE: private | vepa | bridge | passthru | source\n"
>>  		"MODE_FLAG: null | nopromisc\n"
>>  		"MODE_OPTS: for mode \"source\":\n"
>> -		"\tmacaddr { { add | del } <macaddr> | set [ <macaddr> [ <macaddr>  ... ] ] | flush }\n",
>> +		"\tmacaddr { { add | del } <macaddr> | set [ <macaddr> [ <macaddr>  ... ] ] | flush }\n"
>> +		"BC_QUEUE_LEN: Length of the rx queue for broadcast/multicast: [0-4294967295]\n",
> 
> Are we really allowing a BC queue up to 4G? seems a bit much. is a u16
> and 64k not more than sufficient?
> 
> 

No, 64k is not sufficient when you have very high packet rate and very small packages.
I can easily see myself retrieving more than 300 kpps and 65k is then only just around
200 ms of buffer head-room, which I don't consider much saftey margin at all, especially if
the incoming data is not perfectly spaced out but rather comes in bursts.
If you start adding 10Gbps cards in the mix you could get 10 times that and the buffer
would be down to only 20ms. And we would get back to the situation where unicast works
fine but multicast does not.

So for sure a larger max than 64k is needed.

The reason I didn't add an upper limit beside the u32 was that I didn't want to pick an
arbitrary limit that works for me now but maybe not support someone elses use case later.

I'm now looking at net.core.netdev_max_backlog for inspiration. Which, at least on my system,
seems to have a limit of 2147483647 (signed 32 bit int). So perhaps this setting could be
aligned with that number since the settings are sort of related instead of using the full range
if you prefer that?
