Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCF2E2297C
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 02:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729620AbfETALD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 May 2019 20:11:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:41330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727391AbfETALD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 May 2019 20:11:03 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4324020675;
        Mon, 20 May 2019 00:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558311062;
        bh=ViChPQlVCmuJP4DeAj0GffvTOE0giQmWa+adK7cNeC8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eYKhzaYHJAFt8HVFi1j65Bt//wfJFu6PyyY38G1ZMQAY1oWrDJ4Bw6ptsFHP4XAqV
         o5uO3L6oPs3Rvl/5+wiIXztNFHaUzyc6f2nOKhLL4OWLeZQMVFpF7m+PtRjj1A1eTs
         OerN6JTvCtpn+0NxKY0vivAm+QQXpIFPoi3bZz6E=
Date:   Sun, 19 May 2019 20:11:01 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Thomas Haller <thaller@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 4.9 41/51] fib_rules: return 0 directly if an exactly
 same rule exists when NLM_F_EXCL not supplied
Message-ID: <20190520001101.GE11972@sasha-vm>
References: <20190515090616.669619870@linuxfoundation.org>
 <20190515090628.066392616@linuxfoundation.org>
 <20190519154348.GA113991@archlinux-epyc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190519154348.GA113991@archlinux-epyc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 19, 2019 at 08:43:48AM -0700, Nathan Chancellor wrote:
>On Wed, May 15, 2019 at 12:56:16PM +0200, Greg Kroah-Hartman wrote:
>> From: Hangbin Liu <liuhangbin@gmail.com>
>>
>> [ Upstream commit e9919a24d3022f72bcadc407e73a6ef17093a849 ]
>>
>> With commit 153380ec4b9 ("fib_rules: Added NLM_F_EXCL support to
>> fib_nl_newrule") we now able to check if a rule already exists. But this
>> only works with iproute2. For other tools like libnl, NetworkManager,
>> it still could add duplicate rules with only NLM_F_CREATE flag, like
>>
>> [localhost ~ ]# ip rule
>> 0:      from all lookup local
>> 32766:  from all lookup main
>> 32767:  from all lookup default
>> 100000: from 192.168.7.5 lookup 5
>> 100000: from 192.168.7.5 lookup 5
>>
>> As it doesn't make sense to create two duplicate rules, let's just return
>> 0 if the rule exists.
>>
>> Fixes: 153380ec4b9 ("fib_rules: Added NLM_F_EXCL support to fib_nl_newrule")
>> Reported-by: Thomas Haller <thaller@redhat.com>
>> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
>> Signed-off-by: David S. Miller <davem@davemloft.net>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> ---
>>  net/core/fib_rules.c |    6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> --- a/net/core/fib_rules.c
>> +++ b/net/core/fib_rules.c
>> @@ -429,9 +429,9 @@ int fib_nl_newrule(struct sk_buff *skb,
>>  	if (rule->l3mdev && rule->table)
>>  		goto errout_free;
>>
>> -	if ((nlh->nlmsg_flags & NLM_F_EXCL) &&
>> -	    rule_exists(ops, frh, tb, rule)) {
>> -		err = -EEXIST;
>> +	if (rule_exists(ops, frh, tb, rule)) {
>> +		if (nlh->nlmsg_flags & NLM_F_EXCL)
>> +			err = -EEXIST;
>>  		goto errout_free;
>>  	}
>>
>>
>>
>
>Hi all,
>
>This commit is causing issues on Android devices when Wi-Fi and mobile
>data are both enabled. The device will do a soft reboot consistently.
>So far, I've had reports on the Pixel 3 XL, OnePlus 6, Pocophone, and
>Note 9 and I can reproduce on my OnePlus 6.

Is this something that happens with Linus's tree as well? or is this a
backport issue?

>Sorry for taking so long to report this, I just figured out how to
>reproduce it today and I didn't want to report it without that.

FWIW, if you see anything suspicious with -stable patches just let us
know separately from a "better" bug report for upstream, then we can at
least temporary pull it out of the stable queue while the issue is being
addressed.

--
Thanks,
Sasha
