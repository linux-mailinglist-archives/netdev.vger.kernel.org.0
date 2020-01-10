Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A744137511
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 18:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbgAJRmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 12:42:47 -0500
Received: from mail-wr1-f51.google.com ([209.85.221.51]:39635 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727559AbgAJRmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 12:42:47 -0500
Received: by mail-wr1-f51.google.com with SMTP id y11so2615980wrt.6
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 09:42:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=subject:from:to:cc:references:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aPawCyUcXhRe/Zj9MMvZSVZIlwNaKnOtuQA7O9ya5dE=;
        b=jtImzoyFu7WJnGPn4yNDiDXAG7DFbLS+KMkjxMf/vtha/qH5u479f6abcEywxDja/d
         Dt/UR8shNuSdfW2FkobsWJplv4fKJsrcDeDVgaLlW63H4Lr6Z6gipWmqpNUnGTYp3a+/
         l38H5nif2j1wx14+lD78WEuZfnqPRAdU3L8oQOmjfLE3EEwZ8d/qtG0NIwfsTduvffpx
         Qz+dNB3Zvtbb/nJd31BSlSwV+EfK7KQYbm2hVo/o27K7GUKsUPjmmTm9HhfjgT4KuVxn
         1aT9ncMY0rPlekW5M2cevbeGaC5RRmTFi2A4zBXhBeYwNj2IUdAUdOWtq98vSriUYv/J
         OpKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=aPawCyUcXhRe/Zj9MMvZSVZIlwNaKnOtuQA7O9ya5dE=;
        b=P/S59RAWLqm4e18PSFl3cW76nbg4ntTsbTvBdAtQBuHnQQ81FuaVbxDcOKwI8OuUQX
         RovD/iXxEeP13UVtkKGBFZJ7xQBQtfOW/vFDHwTEWBnlt30pemqXpJpjaQyvmtjeL0lJ
         tdZhIXCWT9cgNVZCCVBuSN/B+6ygOrGUfIapTHBuLCH6lY5/w731ILYaUdDkIqB5GGIw
         Rvr7b8BXpSea99qt//aEmGHYuKlUGPjYHxULt+PAkbM1TH6ylc93fXDtkZuOT1MFM02w
         IfDUlkzF0LUe7pT9FsvmGRqYmQ1sgLcj3+UjgPdvBHnu3pSh83Bx2Rbz6IXJFwuDDwhj
         4p+A==
X-Gm-Message-State: APjAAAWEDgzjEDe8rptV+YmQQzbYIp34KNltNMx+qaQTox+mYHjBCU5G
        WswR+Iii80qzvEb2GC02BJX2c/WiN0U=
X-Google-Smtp-Source: APXvYqw1UMClTzxxcQh4NfJbnWNV9J+ih5HUeWZqnJIA/rStIwB4mAFz7WQY8v913i7EMci4ADkJTg==
X-Received: by 2002:adf:f3d0:: with SMTP id g16mr4935125wrp.2.1578678164459;
        Fri, 10 Jan 2020 09:42:44 -0800 (PST)
Received: from ?IPv6:2a01:e0a:410:bb00:f8f3:9d2d:82b5:ab17? ([2a01:e0a:410:bb00:f8f3:9d2d:82b5:ab17])
        by smtp.gmail.com with ESMTPSA id z123sm3156023wme.18.2020.01.10.09.42.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jan 2020 09:42:43 -0800 (PST)
Subject: Re: [PATCH ipsec v2 0/2] ipsec interfaces: fix sending with
 bpf_redirect() / AF_PACKET sockets
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     steffen.klassert@secunet.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <20200109084009.GA8621@gauss3.secunet.de>
 <20200109133543.8559-1-nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <6407b52a-b01d-5580-32e2-fbe352c2f47e@6wind.com>
Date:   Fri, 10 Jan 2020 18:42:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200109133543.8559-1-nicolas.dichtel@6wind.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 09/01/2020 à 14:35, Nicolas Dichtel a écrit :
> Before those patches, packets sent to a vti[6]/xfrm interface via
> bpf_redirect() or via an AF_PACKET socket were dropped, mostly because
> no dst was attached.
Please, drop this version, I will send an update.


Regards,
Nicolas
