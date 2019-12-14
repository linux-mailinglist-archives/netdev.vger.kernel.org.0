Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB5BE11EF35
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 01:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbfLNA2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 19:28:47 -0500
Received: from mga17.intel.com ([192.55.52.151]:12087 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726590AbfLNA2r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Dec 2019 19:28:47 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2019 16:28:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,311,1571727600"; 
   d="scan'208";a="297080334"
Received: from amhui-mobl1.amr.corp.intel.com ([10.251.3.80])
  by orsmga001.jf.intel.com with ESMTP; 13 Dec 2019 16:28:46 -0800
Date:   Fri, 13 Dec 2019 16:28:46 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@amhui-mobl1.amr.corp.intel.com
To:     Eric Dumazet <eric.dumazet@gmail.com>
cc:     netdev@vger.kernel.org, mptcp@lists.01.org
Subject: Re: [PATCH net-next 09/11] tcp: Check for filled TCP option space
 before SACK
In-Reply-To: <47545b88-94db-e9cd-2f9f-2c6d665246e2@gmail.com>
Message-ID: <alpine.OSX.2.21.1912131607000.38100@amhui-mobl1.amr.corp.intel.com>
References: <20191213230022.28144-1-mathew.j.martineau@linux.intel.com> <20191213230022.28144-10-mathew.j.martineau@linux.intel.com> <47545b88-94db-e9cd-2f9f-2c6d665246e2@gmail.com>
User-Agent: Alpine 2.21 (OSX 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Dec 2019, Eric Dumazet wrote:

>
>
> On 12/13/19 3:00 PM, Mat Martineau wrote:
>> The SACK code would potentially add four bytes to the expected
>> TCP option size even if all option space was already used.
>>
>> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
>> ---
>>  net/ipv4/tcp_output.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
>> index 9e04d45bc0e4..710ab45badfa 100644
>> --- a/net/ipv4/tcp_output.c
>> +++ b/net/ipv4/tcp_output.c
>> @@ -748,6 +748,9 @@ static unsigned int tcp_established_options(struct sock *sk, struct sk_buff *skb
>>  		size += TCPOLEN_TSTAMP_ALIGNED;
>>  	}
>>
>> +	if (size + TCPOLEN_SACK_BASE_ALIGNED >= MAX_TCP_OPTION_SPACE)
>> +		return size;
>> +
>>  	eff_sacks = tp->rx_opt.num_sacks + tp->rx_opt.dsack;
>>  	if (unlikely(eff_sacks)) {
>>  		const unsigned int remaining = MAX_TCP_OPTION_SPACE - size;
>>
>
>
> Hmmm... I thought I already fixed this issue ?
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=9424e2e7ad93ffffa88f882c9bc5023570904b55
>
> Please do not mix fixes (targeting net tree) in a patch series targeting net-next

Ok, good that it is already fixed. We have tried to upstream generic fixes 
when they're identified but obviously misclassified this one.

--
Mat Martineau
Intel
