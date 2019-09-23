Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8E0BBB89C
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 17:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732811AbfIWPxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 11:53:01 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33654 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728464AbfIWPxA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 11:53:00 -0400
Received: by mail-pf1-f194.google.com with SMTP id q10so9399797pfl.0
        for <netdev@vger.kernel.org>; Mon, 23 Sep 2019 08:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LvVgVoijm4LqeTHNewjLvUao2avklYCb3x3l0rgxnGM=;
        b=sCLm/MJTXTL1D6tNJmJEnfxoBmlKkb1llSFTUWWsnyUbY0WWdiXcNH9RvkVpa3QAtG
         SkWgHIJthxL6Df6l1i68eT+0XBEZvDRWf5ANCjMfwWOqpgL91uSO69zi/4ukJGgzbbNg
         ZrLmDwErsfY4ZjJjkfqK+jJT3ggkKWhtj9T9SPFKIpaf/1tQd3/53jij1GyXqtUNcsfM
         0dTiwrJDJEaQaevsDntInK7xkGI3Y4V/02U8YLlxV3JKG6MhUXrmLlOXSyv/j9WT4Je9
         eSUU+TQ9tqnMCMiVUQmkoVdjqNgQhxOnj01oc9zb0XW1aw/VHWl1TXP2jH51tP8TCxtk
         /x6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LvVgVoijm4LqeTHNewjLvUao2avklYCb3x3l0rgxnGM=;
        b=RysynCDTYxPXnhFY4ze9Qubt7LETndvRLWu7vAL8zeMU8fTrbExEjM8PQmKsEQySdi
         8ge2sM8cM2L0Tr8rBq1UQGr/767zSMhHQctzLt2FRzGDnZM8i3+OVCKgYWP7YvytWiYE
         ktpDNNDd19XOiF5vZhvBia5RlSgbftqgAIwwRSWuVVj2tmr7+ZZmE5tVedkcQDAr3mnz
         fER6bp7vh7QrpN5uSYfZbqUb7yxKePowpJ3n5zdaL3rl/pxmhR3HitHz+9uIFM0H8x1N
         SHzY355oIXMjbdjdSawqZ4PkAi3NQHZ2udyQuY5xVl0O2ItV+lb8zL2mphmLN1XL55+Z
         fvkA==
X-Gm-Message-State: APjAAAUJ8R7Arrsz6d3eIuOLA9bcvs76sOhueXRGC7rvB5ykKuNizeDn
        ajBx8EJ688caG0iGVjJCnKQMSayY
X-Google-Smtp-Source: APXvYqzf2EWIWILO8RnYLOPgJc+yCXsN6CwrgHumxccBcit9mrklxGWc7/axT0/VpFHKms4EKnhiUQ==
X-Received: by 2002:a62:ac13:: with SMTP id v19mr282377pfe.202.1569253980032;
        Mon, 23 Sep 2019 08:53:00 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id o35sm9719180pgm.29.2019.09.23.08.52.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Sep 2019 08:52:59 -0700 (PDT)
Subject: Re: [PATCH net] sch_netem: fix a divide by zero in tabledist()
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
References: <20190918150539.135042-1-edumazet@google.com>
 <20190920191516.073d88b6@cakuba.netronome.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <722331f3-55f8-868f-0f52-60e17e28e862@gmail.com>
Date:   Mon, 23 Sep 2019 08:52:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190920191516.073d88b6@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/20/19 7:15 PM, Jakub Kicinski wrote:
> On Wed, 18 Sep 2019 08:05:39 -0700, Eric Dumazet wrote:
>> syzbot managed to crash the kernel in tabledist() loading
>> an empty distribution table.
>>
>> 	t = dist->table[rnd % dist->size];
>>
>> Simply return an error when such load is attempted.
>>
>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>> Reported-by: syzbot <syzkaller@googlegroups.com>
> 
> Applied, queued, thank you!
> 

Note that another divide by zero seems possible in the same function,
if sigma = 0x8000000


2*sigma becomes zero, and we have yet another issue in :

if (dist == NULL)
   return ((rnd % (2 * sigma)) + mu) - sigma;


