Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93F027AA6D
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 16:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729321AbfG3OAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 10:00:31 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40611 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727323AbfG3OAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 10:00:30 -0400
Received: by mail-wr1-f68.google.com with SMTP id r1so65898493wrl.7
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 07:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OVJbTjwxJ2V7gEJ1EnH0FtfbT8cNqFpXv0RRwvyIbGo=;
        b=D6/voHBS9dUFEITrTHGgDCMTH2ke7EsEqVZdZ93v1yLAuANCfSibdGPFfAsIbGPp+m
         sO5PeIFsg7mBpdo65ea6RQDnw4TQ81wITBTUcjvYDA3TYMFMCji79v3FlEXWy5VqcOyc
         JPGqK/l6Nrv4WsZzkV3FeOWuK8l9u/jLlvwRc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OVJbTjwxJ2V7gEJ1EnH0FtfbT8cNqFpXv0RRwvyIbGo=;
        b=tNL4+3eA7PAk9b+TLCE9QYMlSagIzybT5Uja/1cr0JFFiEvKrmgmqbdpD5pm0bjfYO
         KoxkLbN2s3U3/PGV0tMyyXPjE+sZl+ogpcHf7BKdZf0t6pkFaOzDkXVDnwx2OfE60lKx
         8YJB+1UhwPYyKp/Jh+nj4QR5cdNO0KCIhs2NbsGgDNfN0Artl+cLRJPsSe3ClqPmeTZ6
         AQU2vQyp6Yzp6osWNzcQJAiLzXxGpTkBJLvYK5fSbc8Z2ZISS+OyGZWigFrcToUw81Qj
         GTthZvQGbbnGZ+cWWDTWDEAq1zrceSRaHHAIpb6gYSlHwOl7z2AAkTiea7fIArAg0KCq
         aYrg==
X-Gm-Message-State: APjAAAVgWSmwf0kae6sZZUtM24eZd2DakFWfQq5ZVBabdTkygP36UnyJ
        z7DapszEKTT5YqDupY1wwsYPUw==
X-Google-Smtp-Source: APXvYqytpnI0ZY2uTT8feWzMH92iQ3CBWa0akOaYeEEvNfhhio0d1dj0S/CHj+0Fe0lYpC/qIYVafQ==
X-Received: by 2002:adf:ec8e:: with SMTP id z14mr4445595wrn.269.1564495229044;
        Tue, 30 Jul 2019 07:00:29 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id t140sm58302813wmt.0.2019.07.30.07.00.28
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 07:00:28 -0700 (PDT)
Subject: Re: [PATCH net] net: bridge: mcast: don't delete permanent entries
 when fast leave is enabled
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org
References: <20190730112100.18156-1-nikolay@cumulusnetworks.com>
 <4511701d-88c4-a937-2fbc-b557033a24ed@gmail.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <1b6cd3cf-0e01-2730-b8ad-d26e2355ce84@cumulusnetworks.com>
Date:   Tue, 30 Jul 2019 17:00:27 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <4511701d-88c4-a937-2fbc-b557033a24ed@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/07/2019 16:58, David Ahern wrote:
> On 7/30/19 5:21 AM, Nikolay Aleksandrov wrote:
>> diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
>> index 3d8deac2353d..f8cac3702712 100644
>> --- a/net/bridge/br_multicast.c
>> +++ b/net/bridge/br_multicast.c
>> @@ -1388,6 +1388,9 @@ br_multicast_leave_group(struct net_bridge *br,
>>  			if (!br_port_group_equal(p, port, src))
>>  				continue;
>>  
>> +			if (p->flags & MDB_PG_FLAGS_PERMANENT)
>> +				break;
>> +
>>  			rcu_assign_pointer(*pp, p->next);
>>  			hlist_del_init(&p->mglist);
>>  			del_timer(&p->timer);
> 
> Why 'break' and not 'continue' like you have with
> 	if (!br_port_group_equal(p, port, src))
> 

Because we'll hit the goto out after this hunk always, no point in continuing
if we matched a group and it's permanent, the break might as well be a goto out.

