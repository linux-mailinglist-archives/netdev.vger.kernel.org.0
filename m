Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B73E33A7244
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 00:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbhFNW7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 18:59:09 -0400
Received: from mail.asbjorn.biz ([185.38.24.25]:53268 "EHLO mail.asbjorn.biz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231707AbhFNW7E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 18:59:04 -0400
X-Greylist: delayed 535 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Jun 2021 18:59:04 EDT
Received: from x201s (193-106-167-236.ip4.fiberby.net [193.106.167.236])
        by mail.asbjorn.biz (Postfix) with ESMTPSA id B52AF1C29733;
        Mon, 14 Jun 2021 22:48:01 +0000 (UTC)
Received: from x201s.roaming.asbjorn.biz (localhost [127.0.0.1])
        by x201s (Postfix) with ESMTP id 1E409200C8A;
        Mon, 14 Jun 2021 22:47:09 +0000 (UTC)
Subject: Re: [PATCH iproute2] tc: pedit: add decrement operation
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>
References: <20210614203324.236756-1-asbjorn@asbjorn.st>
 <20210614142540.37eded6f@hermes.local>
From:   =?UTF-8?Q?Asbj=c3=b8rn_Sloth_T=c3=b8nnesen?= <asbjorn@asbjorn.st>
Message-ID: <58173122-f31b-be9e-fffd-2d219ff53f7b@asbjorn.st>
Date:   Mon, 14 Jun 2021 22:47:08 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210614142540.37eded6f@hermes.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,

On 6/14/21 9:25 PM, Stephen Hemminger wrote:
> On Mon, 14 Jun 2021 20:33:24 +0000
> Asbjørn Sloth Tønnesen         <asbjorn@asbjorn.st> wrote:
> 
>> @@ -422,16 +434,21 @@ int parse_cmd(int *argc_p, char ***argv_p, __u32 len, int type, __u32 retain,
>>   		goto done;
>>   	}
>>   
>>   	return -1;
>> +
> 
> 
> Please no unnecessary whitespace changes.

No problem, I tried to give context by using format-patch -U4,
so it didn't became it's own chunk. I included it to be
consistent within the function, having a blank line above
both label.


> Also you are missing to print_pedit() to print the resulting change.

I didn't plan to since it is stored as TCA_PEDIT_KEY_EX_CMD_ADD,
hence it is printed as:

   key #0  at ipv4+8: add ff000000 mask 00ffffff
   or
   key #0  at ipv6+4: add 000000ff mask ffffff00

If really needed I could detect this, and print something else,
but that would break FP and/or JSON compatibility, which I
don't think is worth it.

print_pedit() is generally not a direct representation of it's
input parameters.

   tc filter add [...] action pedit ex \
     munge eth dst set aa:00:42:00:00:33 \
     munge eth src set aa:00:42:00:00:22 \
     munge ip6 hoplimit dec action [..]

becomes:

   key #0  at eth+0: val aa004200 mask 00000000
   key #1  at eth+4: val 00330000 mask 0000ffff
   key #2  at eth+4: val 0000aa00 mask ffff0000
   key #3  at eth+8: val 42000022 mask 00000000
   key #4  at ipv6+4: add 000000ff mask ffffff00

Note: key #1 and #2 could be consolidated.


Shortly after posting, I noticed that I forgot to amend explain(),
that will be in v2.

-- 
Best regards
Asbjørn Sloth Tønnesen
