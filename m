Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE63E151103
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 21:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgBCU24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 15:28:56 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38406 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbgBCU24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 15:28:56 -0500
Received: by mail-pf1-f196.google.com with SMTP id x185so8147551pfc.5;
        Mon, 03 Feb 2020 12:28:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=siQycGYY8uLdiyJo1UqDxauAjdTPEMqBtw7U2dZ5LhI=;
        b=lrRwlB1okgYyiQFnN8726aVdL4ZvGDPMB2bCyV7nkABshDDfBQFEiqUIatekSfjzPq
         ymoMpIxnDZ6RB1jHFZB1k1hMNp+PmneFQ52vu+SOwQunzS4e9EHPRW8BoEXbC7gTu9iZ
         BjAo4K0Prv89IZrg0I+yQxep/AnIclR9ElrAOHJEeaV3TV6eg5r33iD2DtQ1w++V7gT1
         XIZe6rFezKbT79+LmemzMNLWoloFllvWVM9NmYwyyvyXkVD9XbqRunhq85J13lXpZCGl
         0be6Qz+ECXdGzUYGA93mgMlDNajAugsnUOs7/ijAvMvO07wJsmXRMQAKTmtYKcMSLJNO
         lBOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=siQycGYY8uLdiyJo1UqDxauAjdTPEMqBtw7U2dZ5LhI=;
        b=VKOB1Yhq9qFo2H4Y+Msn0L5HwjbzFNGUG5sHN01PBWdZO3HI2k3u662MYjyilH3MZo
         5lGaVwDslKHnmLOHA+P0oS5Cy412At/eJvVPYafJVT+roQ6tg+V62S/k2vLjlgz88usu
         RedvE2NBj/F2tecWjSmnAAae997usUx3JuSAjRf5K4tPjVHTPbRfN2uKhq95MQHSorWg
         utgJmoR1Jz/vL9pV4yy8X0P+D1A9yN76BY3wI4ajYb/MfuXGalh57W/FI1wUq1FzP38I
         9ADjOQLVFzdgwrO8QIGYetX72VEt8VszwKwYdZCvhsDEZDMBTIwTw83BldwIakpdGDhb
         Q/pg==
X-Gm-Message-State: APjAAAVFyzMsq+sQ+G3jdXF3Yprnazolygr24hl09VY9l9pXkEGKRGgr
        AbhWRa13yV58eSJ7lRRSM1R/imTz
X-Google-Smtp-Source: APXvYqyjYMNZianTD5o1eDp3jFCaeN2M2FqTkqBNkMXs5LXFx1IqBVCu7+VxzdmhsPvEB5HDSTNsLQ==
X-Received: by 2002:a62:8601:: with SMTP id x1mr26557329pfd.0.1580761734660;
        Mon, 03 Feb 2020 12:28:54 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id iq22sm345701pjb.9.2020.02.03.12.28.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Feb 2020 12:28:53 -0800 (PST)
Subject: Re: [PATCH] skbuff: fix a data race in skb_queue_len()
To:     Qian Cai <cai@lca.pw>, Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, elver@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <648d6673-bbd8-6634-0174-f9b77194ecfd@gmail.com>
 <D743FB35-3736-45E9-9DE1-8E81929D67C1@lca.pw>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <126aa227-2383-efdd-742c-6ccf85ae7ba4@gmail.com>
Date:   Mon, 3 Feb 2020 12:28:52 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <D743FB35-3736-45E9-9DE1-8E81929D67C1@lca.pw>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/3/20 12:19 PM, Qian Cai wrote:
> 
> 
>> On Feb 3, 2020, at 2:42 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>
>> We do not want to add READ_ONCE() for all uses of skb_queue_len()
>>
>> This could hide some real bugs, and could generate slightly less
>> efficient code in the cases we have the lock held.
> 
> Good point. I should have thought about that. How about introducing 2 new helpers.
> 
> skb_queue_len_once()
> unix_recvq_full_once()
> 
> which will have a READ_ONCE() there, and then unix_dgram_sendmsg() could use that instead?
> 

We added recently skb_queue_empty_lockless() helper, to use in these contexts.

The fact that we use READ_ONCE() is more of an implementation detail I think.

Also, addressing load-stearing issues without making sure the write side
is using WRITE_ONCE() might be not enough (even if KCSAN warnings disappear)

