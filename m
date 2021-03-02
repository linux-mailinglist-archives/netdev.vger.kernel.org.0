Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9B232B379
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449660AbhCCEBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:01:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350783AbhCBMtr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 07:49:47 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E65BC0611C2
        for <netdev@vger.kernel.org>; Tue,  2 Mar 2021 04:48:53 -0800 (PST)
Received: from [IPv6:2003:e9:d72a:21a0:8b4a:5ec4:afc4:817c] (p200300e9d72a21a08b4a5ec4afc4817c.dip0.t-ipconnect.de [IPv6:2003:e9:d72a:21a0:8b4a:5ec4:afc4:817c])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 788FEC0C3A;
        Tue,  2 Mar 2021 13:43:17 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1614688997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k4cDsSMEoBl+WI1nsm3Xy99TFgQIfTj9lZa4tbXwYQg=;
        b=i0phIXFrMPbKYZp4uh/XWMcNPas1PBmISHKnsqZ3J8NcNkrIBAWM7uKgWwf4z75C2g4fZX
        1e/50XH5XR7Lu+M1HCsGwbcNXpna27+tuhhNLbrR1C8hz2m8DNQQlDfJGxcg/mau3n83Oe
        C2Ivz+oRmDjnZduJRhK7EzJD6EgwVwwrKZ5j/pzO1ShN09AIJTy6irbHOs0m/SNX7Jka5p
        ygMYc39TeIHbnOVOResj7YiPRP7bhq+EqUpNK7nZD5nGhRlCyKSo2RLnvgzEDoP6Y6b/Na
        SIIfpnKq2sOeBAt3aiShPO8cdrIt3hPTxB5mOOb/6VMJm9kUOSyZ5x1ZosJhyg==
Subject: Re: [PATCH wpan 02/17] net: ieee802154: fix memory leak when deliver
 monitor skbs
To:     Alexander Aring <alex.aring@gmail.com>,
        Alexander Aring <aahringo@redhat.com>
Cc:     linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
References: <20210228151817.95700-1-aahringo@redhat.com>
 <20210228151817.95700-3-aahringo@redhat.com>
 <CAB_54W4Lo7TKnqWm_xH=SncTYXTrvT3JCGxTNamagPQ4e0Vs0g@mail.gmail.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <1855c82f-df0b-4c72-9cfe-5eb312b6b41a@datenfreihafen.org>
Date:   Tue, 2 Mar 2021 13:43:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CAB_54W4Lo7TKnqWm_xH=SncTYXTrvT3JCGxTNamagPQ4e0Vs0g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Alex.

On 01.03.21 04:16, Alexander Aring wrote:
> Hi Stefan,
> 
> On Sun, 28 Feb 2021 at 10:21, Alexander Aring <aahringo@redhat.com> wrote:
>>
>> This patch adds a missing consume_skb() when deliver a skb to upper
>> monitor interfaces of a wpan phy.
>>
>> Reported-by: syzbot+44b651863a17760a893b@syzkaller.appspotmail.com
>> Signed-off-by: Alexander Aring <aahringo@redhat.com>
>> ---
>>   net/mac802154/rx.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
>> index b8ce84618a55..18abc1f49323 100644
>> --- a/net/mac802154/rx.c
>> +++ b/net/mac802154/rx.c
>> @@ -244,6 +244,8 @@ ieee802154_monitors_rx(struct ieee802154_local *local, struct sk_buff *skb)
>>                          sdata->dev->stats.rx_bytes += skb->len;
>>                  }
>>          }
>> +
>> +       consume_skb(skb);
> 
> Please drop this patch. It's not correct. I will look next weekend at
> this one again.
> The other patches should be fine, I hope.

Thanks for the heads up. I dropped this patch and will take a look at 
the rest of the  series today or tomorrow.

regards
Stefan Schmidt
