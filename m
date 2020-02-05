Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9299A1533C4
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 16:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbgBEPWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 10:22:05 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43013 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbgBEPWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 10:22:04 -0500
Received: by mail-pl1-f193.google.com with SMTP id p11so997658plq.10
        for <netdev@vger.kernel.org>; Wed, 05 Feb 2020 07:22:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7C0GdY6a/eqbW0oF5FAvA2mzARuafK6h/Lxue4MqMHM=;
        b=pkHgf875pzIEmQmBc1SOrRJcj+uDZV357xyPHN86FV26WNjCk2EGJY/zxtanlvSUs/
         0E9VE2/l0ngbTd9fKkc53rxg5CY8OdHpxJ7CpQw+6uszE5rnsAPPQ3NSoRKx9DgM1UxT
         8UBPqW2cW3IlabP7ZguqhrpZ8l2GbjebKGD2i8wsYmHyyNi5muMngQs8hGyKZxPPYWOZ
         JkYUzl6hlsyJiPeSoHQSTURGq9bfzoG4wtvB77TBVi8Io5vaQoNT5gPVtQ8DpVKHgRDg
         l2zTMw9SFkysbJ1TwxaSYQCYWvG3ZLa3l797MEm/493yS7bF5i1/XSU6efTQhqpPJCqx
         O8kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7C0GdY6a/eqbW0oF5FAvA2mzARuafK6h/Lxue4MqMHM=;
        b=bmnFqDbID3462sDm7xU0nVfATBC6iLeVzqtEabPst4tCwsy8YhmN4WAeKid/knjEot
         REwHdcXtJxK1NUmYjujVPiCCUVTVS9YF9Z9442p9tWj2A8tVuQmo1l1HBjbGczjXH79y
         l7wNmeswM4L5uT7DwwYA5eHGvspymGUN6th2gGAC0Iu9CadbFcSaoEvL2Dl0j4yClE2j
         klLLhma0kvHQbIZSTVlwYUzJwj7xrHIftVCPqPox0cPge7YSbROqRT8AJmVCH2jyzFHY
         /FNIHO4Tw7C1x87eHLUGTonWUYO36EtUQUEfpOQNnkV4or/AMv5FAVd3pdLX49xZHq8T
         dm4w==
X-Gm-Message-State: APjAAAX9G00ig/ki6vPVuRKaQ6ZdDZtomizaLXJQZK3Wjbhha/34pNgz
        7hplTsEF9Zv0aR3VQjbrbHmXuHhF
X-Google-Smtp-Source: APXvYqzRa0svTaWey3AFhm7/9CynqFvcbmmRUcALH+ckX8jJktOpz8gfhD4qFwZHHlV4DIBQJtKa/A==
X-Received: by 2002:a17:902:654d:: with SMTP id d13mr33986256pln.187.1580915791756;
        Wed, 05 Feb 2020 07:16:31 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id u7sm28208733pfh.128.2020.02.05.07.16.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2020 07:16:31 -0800 (PST)
Subject: Re: [PATCH net] bonding/alb: properly access headers in
 bond_alb_xmit()
To:     David Miller <davem@davemloft.net>, edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net
References: <20200205032605.242866-1-edumazet@google.com>
 <20200205.143058.1599098684086589259.davem@davemloft.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <113f8915-57bf-0a7a-1213-66ad04f80a59@gmail.com>
Date:   Wed, 5 Feb 2020 07:16:27 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200205.143058.1599098684086589259.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/5/20 5:30 AM, David Miller wrote:
> From: Eric Dumazet <edumazet@google.com>
> Date: Tue,  4 Feb 2020 19:26:05 -0800
> 
>> syzbot managed to send an IPX packet through bond_alb_xmit()
>> and af_packet and triggered a use-after-free.
>>
>> First, bond_alb_xmit() was using ipx_hdr() helper to reach
>> the IPX header, but ipx_hdr() was using the transport offset
>> instead of the network offset. In the particular syzbot
>> report transport offset was 0xFFFF
>>
>> This patch removes ipx_hdr() since it was only (mis)used from bonding.
>>
>> Then we need to make sure IPv4/IPv6/IPX headers are pulled
>> in skb->head before dereferencing anything.
>>
>> BUG: KASAN: use-after-free in bond_alb_xmit+0x153a/0x1590 drivers/net/bonding/bond_alb.c:1452
>> Read of size 2 at addr ffff8801ce56dfff by task syz-executor.2/18108
>>  (if (ipx_hdr(skb)->ipx_checksum != IPX_NO_CHECKSUM) ...)
>  ...
>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>> Reported-by: syzbot <syzkaller@googlegroups.com>
> 
> I had to read this one over a few times, but looks good.
> 
> Applied and queued up for -stable, thanks.
> 

Thanks for the scrutiny David !
