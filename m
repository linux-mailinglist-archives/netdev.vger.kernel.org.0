Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4041A1F9118
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 10:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728833AbgFOIMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 04:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728162AbgFOIMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 04:12:47 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41991C061A0E;
        Mon, 15 Jun 2020 01:12:47 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id c17so18014299lji.11;
        Mon, 15 Jun 2020 01:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=esQ9ZP4QrNKVj1s3Afnuk/QQLM5w95MQXK30wGnnz/c=;
        b=lDeFc3s+oQ6i7fjeD0CQe0IF2bAdNoqbP92/C78FZwZ+G9XDVaDGPQ6AnvURqHMvmh
         nrxh3UhES9pmuFA4j8BPwICZVcpB8ZKzz3RZGaaB7FQK32hfHLHR2DSXiNV9a//6GSUK
         PcS7N/nOBhlwJ4P5K8lV+L8Ub7/hW896qB+inuyvFzm1yc7mpAYLeRBqj1TXKHDTl1p6
         7Mc9k/LrMoQg/o5PiBipYidjL4fgF9Gu6Uuho0VFIk3QXjs9T1/HxGL+GUR3Nb3ydAm8
         dI0WKCjpLXI/aQixi8fYjdVATSA6gl7Yy9HRkbspiRvBcuI8LgmsXakV7OAw9r5M13Vg
         NFLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=esQ9ZP4QrNKVj1s3Afnuk/QQLM5w95MQXK30wGnnz/c=;
        b=tCc/nZPbJFqEUHMTvDMuD5jAHxTjNS2dNtawoxj9PjGwJnusS0XwGJVZXF8EE/fzaO
         9W/O7wkXKwL9883QOKjNwpahjqsDSB/xFbQUa3OhgomnDR4nSQyWcK4nf/9XzXeXQq2F
         tH1qCGUXHSeB/7640G64/tlr8xqx9y7ybC5SOLKjHtvpSYmVaruWaqAymiQeEdCAnf6/
         I+5+hi7Ggt+jauQMFPz9nK63Es+BIrcm5efIuNq3iSme5rcE+D6Y0QzV8oNOFJc5jo2H
         zSKFnWt3QM8OajD3r203ppCpHlT1kk3YldaVn9Z5nhYwpmmPVehFg4W30/UWjxC79IYw
         oqTw==
X-Gm-Message-State: AOAM532r3+LHTyjkb6i6r3Gcah6SXFhdb0yVdmRjeLN4Tt4eFD05KbjK
        j8nQoiznY/zSU/OryUCc4JEo8M64i/g=
X-Google-Smtp-Source: ABdhPJw5Dq2Wml/AFE1eTw70HtFRq7j+SfEAvP9mGae9F6oab09XbrpikGFUd3OBVAV2GQM8LF167w==
X-Received: by 2002:a2e:9246:: with SMTP id v6mr12648336ljg.47.1592208765137;
        Mon, 15 Jun 2020 01:12:45 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:898:cee0:935:d774:3b72:5f7e? ([2a00:1fa0:898:cee0:935:d774:3b72:5f7e])
        by smtp.gmail.com with ESMTPSA id v126sm4358553lfa.50.2020.06.15.01.12.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2020 01:12:44 -0700 (PDT)
Subject: Re: [PATCH/RFC] net: ethernet: ravb: Try to wake subqueue instead of
 stop on timeout
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "sergei.shtylyov@cogentembedded.com" 
        <sergei.shtylyov@cogentembedded.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Cc:     "REE dirk.behme@de.bosch.com" <dirk.behme@de.bosch.com>,
        "Shashikant.Suguni@in.bosch.com" <Shashikant.Suguni@in.bosch.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
References: <1590486419-9289-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <TY2PR01MB369266A27D1ADF5297A3CFFCD89C0@TY2PR01MB3692.jpnprd01.prod.outlook.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Organization: Brain-dead Software
Message-ID: <9f71873b-ee5e-7ae3-8a5a-caf7bf38a68e@gmail.com>
Date:   Mon, 15 Jun 2020 11:12:37 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <TY2PR01MB369266A27D1ADF5297A3CFFCD89C0@TY2PR01MB3692.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 15.06.2020 8:58, Yoshihiro Shimoda wrote:

>> From: Yoshihiro Shimoda, Sent: Tuesday, May 26, 2020 6:47 PM
>>
>> According to the report of [1], this driver is possible to cause
>> the following error in ravb_tx_timeout_work().
>>
>> ravb e6800000.ethernet ethernet: failed to switch device to config mode
>>
>> This error means that the hardware could not change the state
>> from "Operation" to "Configuration" while some tx queue is operating.
>> After that, ravb_config() in ravb_dmac_init() will fail, and then
>> any descriptors will be not allocaled anymore so that NULL porinter
>> dereference happens after that on ravb_start_xmit().
>>
>> Such a case is possible to be caused because this driver supports
>> two queues (NC and BE) and the ravb_stop_dma() is possible to return
>> without any stopping process if TCCR or CSR register indicates
>> the hardware is operating for TX.
>>
>> To fix the issue, just try to wake the subqueue on
>> ravb_tx_timeout_work() if the descriptors are not full instead
>> of stop all transfers (all queues of TX and RX).
>>
>> [1]
>> https://lore.kernel.org/linux-renesas-soc/20200518045452.2390-1-dirk.behme@de.bosch.com/
>>
>> Reported-by: Dirk Behme <dirk.behme@de.bosch.com>
>> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
>> ---
>>   I'm guessing that this issue is possible to happen if:
>>   - ravb_start_xmit() calls netif_stop_subqueue(), and
>>   - ravb_poll() will not be called with some reason, and
>>   - netif_wake_subqueue() will be not called, and then
>>   - dev_watchdog() in net/sched/sch_generic.c calls ndo_tx_timeout().
>>
>>   However, unfortunately, I didn't reproduce the issue yet.
>>   To be honest, I'm also guessing other queues (SR) of this hardware
>>   which out-of tree driver manages are possible to reproduce this issue,
>>   but I didn't try such environment for now...
>>
>>   So, I marked RFC on this patch now.
> 
> I'm afraid, but do you have any comments about this patch?

    I agree that we should now reset only the stuck queue, not both but I 
doubt your solution is good enough. Let me have another look...

[...]

MBR, Sergei
