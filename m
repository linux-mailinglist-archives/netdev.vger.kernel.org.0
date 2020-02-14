Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA6C15D294
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 08:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728740AbgBNHL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 02:11:29 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34179 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726048AbgBNHL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 02:11:29 -0500
Received: by mail-pg1-f195.google.com with SMTP id j4so4493364pgi.1
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 23:11:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jU2sZa1WkSUp9LtlRxlbU7ND84BNIYyPM31kgPc2EkM=;
        b=d6yJ0jaL0KXHq60FOjaubJkaaJNOdxym9aLZ4KJNPllXU53vJMMWWIefwZTBSzt62b
         TgTOPDhRgfaeigPxd9WSGpRQY6ITkqMC/+4HDr628tlA4gdOU6n7lvEkPyZ94qnYf/A4
         QPeJYwVb6HrXmbEt85Y6evyRL5WaoghhJGIF87qqHLDgPbxYtnnLeG6FshP6m4YN8m/j
         /dDYTI63Pz9TEtOiZvJRls6246hPAwVY5iAbuzrnM8wetYVt256k9q91HzaHl0nVHzI2
         Uv+4ocv5dl3v7i/I2mANNaYh/fFJ36zSKYTtz5eNUpiPCmYU2u4oNt9Ya4nyOa04COVb
         GQKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jU2sZa1WkSUp9LtlRxlbU7ND84BNIYyPM31kgPc2EkM=;
        b=YbE1XLGAzH+Vz3ObOtCYJ6stowfaJX9ReM+2aPK0pPEMUKCIsTbvlHFCTYDaH8Hq87
         /Qe7P1xZ0Qn6ErUF0fJKALybK9cl1rEv076Rn5NPCFUPw3Ns4I3UL4K62RTS0bS+E5mo
         YHT/3+EmfXUUwFI8Kt1UwaDf88mGCN9jcTWe4w5oq/SsN5wH7pi5rGB5rIQ3LV6FE8Oh
         KD2j01Yc+lMU+ydegpcPmUjmATRJM/hZYvwe+ljJ4IItE8vOYTlo29opWULrhHkfmWXX
         SZEpSwgvJTd0bWzRWe9CsYbla3CUAxidUtUNV3C2HIZiKIKZpuY3uY6OTSjD0ahM9gnx
         eA+w==
X-Gm-Message-State: APjAAAVuDQWscUDttNAok80VLEqm656V0dEgB61vJ9bCp7WdOeTNAL/r
        bcPGXlbGXn0Qop3qiXN0p2c=
X-Google-Smtp-Source: APXvYqznszRQBZJ7pgVb/iUmEN3UyCmhhYJKvRaRqUIgMZ2WDdpWdDzFMkjwQiPJiUdfqc6Dj9Fusg==
X-Received: by 2002:a63:d041:: with SMTP id s1mr1920787pgi.363.1581664288879;
        Thu, 13 Feb 2020 23:11:28 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id s206sm5807056pfs.100.2020.02.13.23.11.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2020 23:11:27 -0800 (PST)
Subject: Re: [PATCH net] net: rtnetlink: fix bugs in rtnl_alt_ifname()
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     Jiri Pirko <jiri@resnulli.us>, Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@mellanox.com>,
        syzbot <syzkaller@googlegroups.com>
References: <20200213045826.181478-1-edumazet@google.com>
 <20200213064532.GD22610@nanopsycho>
 <2e122d94-89a1-f2aa-2613-2fc75ff6b4d1@gmail.com>
Message-ID: <741c1c4e-9f83-d5bd-0100-d33cb5db7cc6@gmail.com>
Date:   Thu, 13 Feb 2020 23:11:26 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <2e122d94-89a1-f2aa-2613-2fc75ff6b4d1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/12/20 10:58 PM, Eric Dumazet wrote:
> 
> 
> On 2/12/20 10:45 PM, Jiri Pirko wrote:
>> Thu, Feb 13, 2020 at 05:58:26AM CET, edumazet@google.com wrote:
>>> Since IFLA_ALT_IFNAME is an NLA_STRING, we have no
>>> guarantee it is nul terminated.
>>>
>>> We should use nla_strdup() instead of kstrdup(), since this
>>> helper will make sure not accessing out-of-bounds data.
>>>
>>>
>>> Fixes: 36fbf1e52bd3 ("net: rtnetlink: add linkprop commands to add and delete alternative ifnames")
>>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>>> Cc: Jiri Pirko <jiri@mellanox.com>
>>> Reported-by: syzbot <syzkaller@googlegroups.com>
>>> ---
>>> net/core/rtnetlink.c | 26 ++++++++++++--------------
>>> 1 file changed, 12 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
>>> index 09c44bf2e1d28842d77b4ed442ef2c051a25ad21..e1152f4ffe33efb0a69f17a1f5940baa04942e5b 100644
>>> --- a/net/core/rtnetlink.c
>>> +++ b/net/core/rtnetlink.c
>>> @@ -3504,27 +3504,25 @@ static int rtnl_alt_ifname(int cmd, struct net_device *dev, struct nlattr *attr,
>>> 	if (err)
>>> 		return err;
>>>
>>> -	alt_ifname = nla_data(attr);
>>> +	alt_ifname = nla_strdup(attr, GFP_KERNEL);
>>> +	if (!alt_ifname)
>>> +		return -ENOMEM;
>>> +
>>> 	if (cmd == RTM_NEWLINKPROP) {
>>> -		alt_ifname = kstrdup(alt_ifname, GFP_KERNEL);
>>> -		if (!alt_ifname)
>>> -			return -ENOMEM;
>>> 		err = netdev_name_node_alt_create(dev, alt_ifname);
>>> -		if (err) {
>>> -			kfree(alt_ifname);
>>> -			return err;
>>> -		}
>>> +		if (!err)
>>> +			alt_ifname = NULL;
>>> 	} else if (cmd == RTM_DELLINKPROP) {
>>> 		err = netdev_name_node_alt_destroy(dev, alt_ifname);
>>> -		if (err)
>>> -			return err;
>>> 	} else {
>>
>>
>>> -		WARN_ON(1);
>>> -		return 0;
>>> +		WARN_ON_ONCE(1);
>>> +		err = -EINVAL;
>>
>> These 4 lines do not seem to be related to the rest of the patch. Should
>> it be a separate patch?
> 
> Well, we have to kfree(alt_ifname).
> 
> Generally speaking I tried to avoid return in the middle of this function.
> 
> The WARN_ON(1) is dead code today, making it a WARN_ON_ONCE(1) is simply
> a matter of avoiding syslog floods if this path is ever triggered in the future.

Also, related to this new fancy code ;)

Is there anything preventing netdev_name_node_alt_destroy() from destroying the primary
ifname ?

netdev_name_node_lookup() should be able to find dev->name_node itself ?

Then we would leave a dangling pointer in dev->name_node, and crash later.

I am thinking we need this fix :

diff --git a/net/core/dev.c b/net/core/dev.c
index a6316b336128cdb31eea6e80f1a47620abbd0d31..3fa2bc2c30ee1350b5b4b400f0552b9bf2a62697 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -331,6 +331,11 @@ int netdev_name_node_alt_destroy(struct net_device *dev, const char *name)
        name_node = netdev_name_node_lookup(net, name);
        if (!name_node)
                return -ENOENT;
+
+       /* Do not trust users, ever ! */
+       if (name_node == dev->name_node || name_node->dev != dev)
+               return -EINVAL;
+
        __netdev_name_node_alt_destroy(name_node);
 
        return 0;
