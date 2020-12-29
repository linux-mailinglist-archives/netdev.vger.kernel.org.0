Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE042E6D80
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 04:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727705AbgL2DMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 22:12:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727648AbgL2DMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 22:12:24 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30972C061793;
        Mon, 28 Dec 2020 19:11:44 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id c22so8422714pgg.13;
        Mon, 28 Dec 2020 19:11:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cUly1AgH09bKcQKGZSMiPnEKvApULnMTjHcxsPTjH9A=;
        b=hga1AZWs48sXAgyIwbs06iVeLS1Sodoziu2DsSspADo8yQcDYunpdLDqAaI6n9J1pW
         CambmoZo3q/DgM58v4ibezx4NwpkfngrugG6fS7quZgz94WZQozBlHB76RGV6PURkSag
         5Kg7i2AVUspQx4s9eScQa9pcRn6hI9EtePTHNn+NOH6zxA0nTNaFCeXjyATroquXgeVB
         8+L8GD94Azeb3Q3CtCuRukR0IVNH75ru1uHR8rkUCmshdjSMVXipNcyKzubPuvsChu49
         CWGk/l3bFQ78vW3+OkHAEaJp4HWxtpGGjDaEDQLIfHExx4YOAGkUHf66t3ynXhDsTwgW
         Gecg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cUly1AgH09bKcQKGZSMiPnEKvApULnMTjHcxsPTjH9A=;
        b=lRMFR89MDQ5iSN+3LAe2J8ZEYjtQu80wMowvXoW9plbUh1Phj8nFo6i4OYci/A3gD5
         nK0WeVxvbi+4wj1R69hur6ZIIHngv5D6hJYqu/Q0+94GHNzQzUzRQeWIPERMB2eQFnZk
         g5uvuS1Nommh5wgreZy6vbc0bcBiuv9GeNh9sv3ckWpRy5f6BXid5y8t6j5xD9kMD1CT
         lYimAvuqMOmzq5/r8/em2KcD6q90pHcNW5D4mSFUA7VdX3FOZ4khJV+qv+nUWLkZHJKt
         hU8MA1m7oguYGrm4EKjC0aEALHEHuXRL7R5X9jqVIx7qtvAwDIxzVbyfZPoPseWFKuBe
         Hhxg==
X-Gm-Message-State: AOAM531934e6Afm5ZSURIe80UEKPnjtBXkHkqMccFLFjZ8XiY1tUKlj0
        HWZraytNzruEszILJall4bGrORcsJBw=
X-Google-Smtp-Source: ABdhPJwGcSKWPl8PN+X4tEgXJ9grrBvzaxERTQa0KbIyrBm2zXNwO5eoq7qCjVIKc7iDpLCkE7CXnQ==
X-Received: by 2002:a63:cf56:: with SMTP id b22mr46612409pgj.16.1609211503434;
        Mon, 28 Dec 2020 19:11:43 -0800 (PST)
Received: from [10.230.29.27] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id gj1sm854367pjb.11.2020.12.28.19.11.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Dec 2020 19:11:42 -0800 (PST)
Subject: Re: [PATCH net-next v2 1/6] bcm63xx_enet: batch process rx path
To:     Sieng Piaw Liew <liew.s.piaw@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20201224142421.32350-1-liew.s.piaw@gmail.com>
 <20201224142421.32350-2-liew.s.piaw@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <edad0329-af52-e9d7-71c6-0fa480c62176@gmail.com>
Date:   Mon, 28 Dec 2020 19:11:40 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201224142421.32350-2-liew.s.piaw@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/24/2020 6:24 AM, Sieng Piaw Liew wrote:
> Use netif_receive_skb_list to batch process rx skb.
> Tested on BCM6328 320 MHz using iperf3 -M 512, increasing performance
> by 12.5%.
> 
> Before:
> [ ID] Interval           Transfer     Bandwidth       Retr
> [  4]   0.00-30.00  sec   120 MBytes  33.7 Mbits/sec  277         sender
> [  4]   0.00-30.00  sec   120 MBytes  33.5 Mbits/sec            receiver
> 
> After:
> [ ID] Interval           Transfer     Bandwidth       Retr
> [  4]   0.00-30.00  sec   136 MBytes  37.9 Mbits/sec  203         sender
> [  4]   0.00-30.00  sec   135 MBytes  37.7 Mbits/sec            receiver
> 
> Signed-off-by: Sieng Piaw Liew <liew.s.piaw@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
