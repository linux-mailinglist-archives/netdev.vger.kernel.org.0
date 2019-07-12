Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2369867393
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 18:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbfGLQse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 12:48:34 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36112 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727053AbfGLQse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 12:48:34 -0400
Received: by mail-wm1-f67.google.com with SMTP id g67so5443336wme.1
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 09:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=L5R8ySVBE7QUys7rJasb12px1bBwr4aCUTw+k4YiYko=;
        b=eXl55svtvjeuIteWN3mbz7O1CcrYXOTtNPcOndhtCOEHSwkPwbkPqJOK3rN6xgBe7e
         rHpLq69DqW9KWY3oxb4ZyNXa8SXeF1GIkoVgWz5q5egwx+UkHHBPMiCBexjdUILkzCHE
         YWqyoer665xDuJgoxp6JMlagTspvkHIUAPTEf4dXhvXyBZkJVE3aYaBISQuImi7WkmfO
         O9eqDeQZD2Bi4g9BQw3puMO2h3yM9F4hJs62Ne7ZFGsoiovUlLw8DRTrrS1ziZQORhRt
         xbPh273VJYjHv73Jd0T34kAcr14ncihX6HV9cRWG8H06r3sbzikit6BgQAmeWeuTLsPL
         vrdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L5R8ySVBE7QUys7rJasb12px1bBwr4aCUTw+k4YiYko=;
        b=U05McdiyHzI/ElvIfsjKkUnzRH9JeNtyGCikoDgpvvmdfhsnEot4qPFrtiUkrREZgN
         tMy4maSmg2S60tx1jD69iVR8h/CzjwP6Eq7SKpjWRP1D30j2flNxkQ0K2GtkjQmVb7pu
         VslZg4kbD1n0zV8HfOvzaLMNCtlS2ydkBljaa25GIUISdJJQVgT+O/mURk51vAaT26u6
         OU/2wrF4ybG/fkxoDnJekpwvIuFjQNka6+Qak+r5UZA64JOxPaE/2hwwt6QjAY3uw30c
         klg8S3Ev/1Lqau82S6zTrpA1P+dcpBlx3YZJBuAg1FUlG/B9xDlEi5QpJ9Ffosoq3ods
         q/wg==
X-Gm-Message-State: APjAAAVifODviWxlkVSYxvR7C6+VgI8alamGyDtJWUrfxo1HgY2iCb/H
        uwzdKI6xfqXeKwFP9oUO2PVgLB1f
X-Google-Smtp-Source: APXvYqyienDeTtIk2D7xfQawnw/znhQFnBAUfBxj2sIdmxZ+y7xZG6D7e8MzUZLhFtCzLldgwDRRuw==
X-Received: by 2002:a7b:c8c3:: with SMTP id f3mr11019615wml.124.1562950111753;
        Fri, 12 Jul 2019 09:48:31 -0700 (PDT)
Received: from [192.168.8.147] (106.174.185.81.rev.sfr.net. [81.185.174.106])
        by smtp.gmail.com with ESMTPSA id i18sm10127049wrp.91.2019.07.12.09.48.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Jul 2019 09:48:30 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 0/3] net: batched receive in GRO path
To:     Edward Cree <ecree@solarflare.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>
References: <7920e85c-439e-0622-46f8-0602cf37e306@solarflare.com>
 <c80a9e7846bf903728327a1ca2c3bdcc078057a2.camel@redhat.com>
 <677040f4-05d1-e664-d24a-5ee2d2edcdbd@solarflare.com>
 <1735314f-3c6a-45fc-0270-b90cc4d5d6ba@gmail.com>
 <4516a34a-5a88-88ef-e761-7512dff4f3ce@solarflare.com>
 <38ff0ce0-7e26-1683-90f0-adc9c0ac9abe@gmail.com>
 <927da9ee-c2fc-8556-fbeb-e26ea1c98d1e@solarflare.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <d7ca6e7a-b80e-12e8-9050-c25b8b92bf26@gmail.com>
Date:   Fri, 12 Jul 2019 18:48:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <927da9ee-c2fc-8556-fbeb-e26ea1c98d1e@solarflare.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/12/19 5:59 PM, Edward Cree wrote:
> On 10/07/2019 18:39, Eric Dumazet wrote:
>> Holding a small packet in the list up to the point we call busy_poll_stop()
>> will basically make busypoll non working anymore.
>>
>> napi_complete_done() has special behavior when busy polling is active.
> Yep, I get it now, sorry for being dumb :)
> Essentially we're saying that things coalesced by GRO are 'bulk' traffic and
>  can wait around, 


GRO can still be beneficial even when busypolling, since TCP stack
will send a single ACK back, and a read()/recv() will copy the whole train
instead of a single MSS.

I should have mentioned that we have a patch that I forgot to upstream adding
the PSH flag to all TSO packets, meaning the receiver can automatically learn
the boundary of a GRO packet and not have to wait for the napi->poll() end
(busypolling or not)

> but the rest is the stuff we're polling for for low latency.
> I'm putting a gro_normal_list() call after the trace_napi_poll() in
>  napi_busy_loop() and testing that, let's see how it goes...
> 
