Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18BC67AFAE
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 19:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730356AbfG3RVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 13:21:11 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:38791 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbfG3RVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 13:21:10 -0400
Received: by mail-wr1-f52.google.com with SMTP id g17so66643239wrr.5
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 10:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vx1WPFQR/0ekdOh6+wil39Vg2uqg8SMm9gVCms4QGi8=;
        b=AD0pl6LeGMES8GvenbHna78EY5+8C1caKBtiTYGFJn1Wc0eFBT1R2CbopiNSmh9yp/
         hhVEDXlV5Hw9oQ0FhBruqUUPgcC6aX18ALSYWeD2steFRwiHsyC5RV57CnwaGVknfOj1
         YSJUbW6H/5ix2A039F6WcZh49aSvNYO/GO8mw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vx1WPFQR/0ekdOh6+wil39Vg2uqg8SMm9gVCms4QGi8=;
        b=f0iYA2tuFATKp9nWiCKu6xxQhdalzyuB6fRE1nnN1VFVOjRjPnh4nRVGsz7zWVXk0E
         YjLy/7JNimCJKocsiqpOc39hkNtbwCe7DRUERAw6NYzApLJSJ0moJjrI4Xb3elWPQGrN
         JeIqWHs311UtKihCxe68ogC8/NtREdWxk337KIho+ueLLU8EpAX0rWLWUXv5Lfw+TPbb
         EBR3t5a0BJRClcBaSgnB2dNWtZupcHqj2xeWwscc2vAj/VdDaOAS1daJkyluZ4vDh72M
         INdAcP1rl6slm8ED+DqV4xBbh9oE/0aYrDgTNsZU+ZJpZuG087N/wAVenYjwV+t/EAb8
         RkyQ==
X-Gm-Message-State: APjAAAXW1jnANfXSTWUDdcGIg+7BZpsEPMx2yihxl+24RB6V2kjNYT9H
        ycWf0092t4MR4lfs3WhOZrB9KQ==
X-Google-Smtp-Source: APXvYqx2n7YXIdnAF5OQXRVva27j+HkgnAT2SaRXidg8ZAG5K+CZcO8LVsjNxyZFw4IWYbvq8deKJg==
X-Received: by 2002:adf:e444:: with SMTP id t4mr27931393wrm.262.1564507268674;
        Tue, 30 Jul 2019 10:21:08 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id w23sm69355023wmi.45.2019.07.30.10.21.07
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 10:21:08 -0700 (PDT)
Subject: Re: [PATCH net] net: bridge: mcast: don't delete permanent entries
 when fast leave is enabled
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org
References: <20190730112100.18156-1-nikolay@cumulusnetworks.com>
 <20190730.101811.1836331521043535108.davem@davemloft.net>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <a3de94a3-5976-9035-69bf-2aee6454b45e@cumulusnetworks.com>
Date:   Tue, 30 Jul 2019 20:21:06 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190730.101811.1836331521043535108.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/07/2019 20:18, David Miller wrote:
> From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> Date: Tue, 30 Jul 2019 14:21:00 +0300
> 
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
> 
> Like David, I also don't understand why this can be a break.  Is it because
> permanent entries are always the last on the list?  Why will there be no
> other entries that might need to be processed on the list?
> 

The reason is that only one port can match. See the first clause of br_port_group_equal,
that port can participate only once. We could easily add a break statement in the end
when a match is found and it will be correct. Even in the presence of MULTICAST_TO_UNICAST
flag, the port must match and can be added only once.

