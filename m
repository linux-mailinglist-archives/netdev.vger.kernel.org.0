Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C400A11FAEB
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 20:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbfLOT7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 14:59:46 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:42581 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbfLOT7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 14:59:46 -0500
Received: by mail-pj1-f65.google.com with SMTP id o11so2024502pjp.9
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 11:59:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CyzEYO0tBZAuG9V1nNydZ2BB6jr/y6qEzG3L9J1ddi8=;
        b=DYRm0n2dZQjzZD2TexyuyXB23be06bctKnmRRPB1r5kMbOq2+i99kbqh/SpiDoG3x1
         gIgit/Z3BobWG5xmah5F7yDbYKQkcvEfof5Zm39RBGfEO7YB0hH2LKsZPDqUF2LyD4Pu
         kOe5iwrZBKV20O6L/nneEz5tN72BnWsPPa4N4UUxKnyvvNSCQpdPOvDkGe89uHn9P/45
         WrGTBD8Elnjt+MsylCtWuJHbNmiPx2oUHObr+pjzoN19nzxgAADFW3/Iw0pwEhxSDSzL
         LLDS7JS8AAsuLp2ItOsOqqisH1zG0/tP6B1mpliZNdtHWHfC41Pm2TI89u/t2IzBdfHx
         HeZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CyzEYO0tBZAuG9V1nNydZ2BB6jr/y6qEzG3L9J1ddi8=;
        b=PPyh323bAXg8oymKdcGTXaARQnPsU4zq2+Zvzfv/l2ChihF01J2lQ0RThc6v628jAn
         83PwAhlo4d2qySNLM/oLGZXMaLGawUB8HTDRAN6bru89q2lniWfh0VPxFtdjcAwW+z8W
         gnMhU61TAv/bgFKQEGjtcUEoHlJZ7MGLU/rZaL7jpRMMEJf8N716kLAdmZYfhrytWHZe
         AyImea4cziQAG/aV9BKWsF9TCo6l5a2Yvf5ayYl3Pv68YhJaRiRS0o/GdKlJlmhgpgRb
         5I/LOgKRggOUToOng9yqtaVAdOFVU+viHiCR1dbTx6GcNVPl7FfWARWihu5fp5ZeQ8Pj
         WKpA==
X-Gm-Message-State: APjAAAXmfUi3CzWvj60rSNN3g8eLssTNxic8AZCJ3w7Th2c+ZYdRPuF3
        eJ5I1XA5c/yBuDreZvb6XQY=
X-Google-Smtp-Source: APXvYqwElKNL2fwMJ1X3iQjEFXTurwtwovDXzea69dm4/hHdgyMNKZmC7QKZbXhIMgjIzzaBLUq/sA==
X-Received: by 2002:a17:902:321:: with SMTP id 30mr12039769pld.153.1576439985369;
        Sun, 15 Dec 2019 11:59:45 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id x4sm19097301pfx.68.2019.12.15.11.59.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Dec 2019 11:59:44 -0800 (PST)
Subject: Re: [PATCH net-next] tcp: Set rcv zerocopy hint correctly if skb last
 frag is < PAGE_SIZE.
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Arjun Roy <arjunroy.kdev@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, arjunroy@google.com,
        soheil@google.com, edumazet@google.com
References: <20191212225930.233745-1-arjunroy.kdev@gmail.com>
 <20191215112214.3dd72168@cakuba.netronome.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <80810ad7-a044-a88f-6032-0508661aadc2@gmail.com>
Date:   Sun, 15 Dec 2019 11:59:40 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191215112214.3dd72168@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/15/19 11:22 AM, Jakub Kicinski wrote:
> On Thu, 12 Dec 2019 14:59:30 -0800, Arjun Roy wrote:
>> At present, if the last frag of paged data in a skb has < PAGE_SIZE
>> data, we compute the recv_skip_hint as being equal to the size of that
>> frag and the entire next skb.
>>
>> Instead, just return the runt frag size as the hint.
> 
> nit: this commit message doesn't really tell us why or what the effects
>      are going to be.

Right, I added a bit of explanation.

Basically we would hint the application to copy more bytes than needed.

Since zerocopy is best effort, this can target net-next

> 
>> Signed-off-by: Arjun Roy <arjunroy@google.com>
>> Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
>> Signed-off-by: Eric Dumazet <edumazet@google.com>
> 
> WARNING: Missing Signed-off-by: line by nominal patch author 'Arjun Roy <arjunroy.kdev@gmail.com>'
> 
> You gotta send it from the same address you signed it off from.

I sent a v2 on behalf of Arjun.

Thanks.

