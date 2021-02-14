Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA6131B0DD
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 15:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbhBNOyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 09:54:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbhBNOyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 09:54:39 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B00C061574
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 06:53:59 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id fa16so2261820pjb.1
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 06:53:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vw50znwU6REW59YMcJN+DgtH0CGqzi0DrUWq2GvV4dQ=;
        b=RAk+2B7b1fWhtDAoA8EF3LU0AeAUtXtsvOOdRORjDuVX7cGSeZ5jQhrsebmzFGmW4h
         eJ7eHugctRhuqR8us/bTBQdsIvMK0pl48PTmgWDgIek83hEJdl2NMysKz3601DiEf9Bm
         N4EMbVBHxzq/SzyTKys1aJB2pRoJ1LhTtuzVj22cJcAHCU2w7QV/EiY4lruFAf3rUD6d
         kzpABX+KQLvokHQpwwYrEsP0ctO9WN1ugUKabPtyKKD0Gl4zvdsYocc+PRXD3a6vIdZf
         FY664Atpkzt3EElzPZDeIGen2Qyy+hp7+PJSIuBKphEPJjQXiE+C5NvrmAavqz4rSi75
         Iegw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vw50znwU6REW59YMcJN+DgtH0CGqzi0DrUWq2GvV4dQ=;
        b=kzz1evK7MMDQU5EtswXOxulepFrWmh8MmE7yfh3ImJOH26R+jgYxQePLV06qHCRKfB
         6yH5vVbaYMRmO7NKN/44LvFEWup28IT9gYTkoAIHuudoxVC6KQ7d/65hOGKDUpOBfX7O
         FqxAtAaxGMLusNIJQ2VDK/Y5rhYgyPSHNrYKRg+5A6b7zfliUvgwjOVJF+bWRniRAKN9
         B9UM0maewLWvEQf3gMmW8Zq/T1r1NjjqZNcO/T/QSen94EJqCRgFCQ8yt3AZWNg1YeoE
         mryEzxmuOSYcLjj5cS6n6EkKbrNTw8WeRuS5k0QWA77ofelh+jAUCKyeIcPbY6C05L5p
         eEtA==
X-Gm-Message-State: AOAM5300mqpePZMUxNBU53wIiJvV9sU+/yPTlW3u0BPIfIrVgsXtg57L
        fXGAqy6flGVF9/MfHQM6olQ=
X-Google-Smtp-Source: ABdhPJwj6UxQQyGlu7pFqdkl1K5bKT9FfRVur7O4f6en7BAPG2PdBRfz6z8RsJp+jvVfhtUIgqIE5w==
X-Received: by 2002:a17:902:c602:b029:e2:8422:ffbc with SMTP id r2-20020a170902c602b02900e28422ffbcmr11369732plr.78.1613314439091;
        Sun, 14 Feb 2021 06:53:59 -0800 (PST)
Received: from [192.168.0.4] ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id r5sm15069499pfh.13.2021.02.14.06.53.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Feb 2021 06:53:58 -0800 (PST)
Subject: Re: [PATCH net-next v2 3/7] mld: add a new delayed_work,
 mc_delrec_work
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        jwi@linux.ibm.com, kgraul@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com,
        Marek Lindner <mareklindner@neomailbox.ch>,
        sw@simonwunderlich.de, a@unstable.cc, sven@narfation.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        dsahern@kernel.org, ap420073@gmail.com
References: <20210213175148.28375-1-ap420073@gmail.com>
 <CAM_iQpVrD5623egpEy2BhR66smuEaTLRHgsu9YA_vrMGjacPkg@mail.gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Message-ID: <5bb93b2b-e59c-a7d6-b638-f12463b0bc04@gmail.com>
Date:   Sun, 14 Feb 2021 23:53:53 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpVrD5623egpEy2BhR66smuEaTLRHgsu9YA_vrMGjacPkg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 >
 > By the way, if you do not use a delay, you can just use regular work.
 >

The regular workqueue API couldn't be used in an atomic context, So I 
used delayed_work.
If 0 delay is passed to delayed_work, it internally calls regular workqueue.
So, I think there is no actual difference.

Thanks!
