Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA12D52F01E
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 18:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351401AbiETQJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 12:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351396AbiETQJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 12:09:17 -0400
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E8A217CE78;
        Fri, 20 May 2022 09:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1653062956; x=1684598956;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=k4TaXOe7Lwo+CV82+bLt4wFrTLilH5zJy3rK/5JlxKc=;
  b=Tvcegh9kDtmAk+/wt8QwA9p1TQ8Eb3lVTHdL7luMCPtHQlCbnQ5MVveG
   cBmRsk4zfUj91/zsaa5zoaq/gbBkREjG8cC36f2+9HGb0J8g/4t1Vm+AT
   UOCQRCffgn0p3i2FiQnM43fMryf+VYjhF5ztE3uxNhDwVBT9hXZ6sJMoT
   M=;
Received: from ironmsg-lv-alpha.qualcomm.com ([10.47.202.13])
  by alexa-out.qualcomm.com with ESMTP; 20 May 2022 09:09:16 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg-lv-alpha.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2022 09:09:15 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 20 May 2022 09:08:55 -0700
Received: from [10.110.24.32] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 20 May
 2022 09:08:53 -0700
Message-ID: <ec16c0b5-b8c7-3bd1-e733-f054ec3c2cd1@quicinc.com>
Date:   Fri, 20 May 2022 09:08:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH net v2] net: wireless: marvell: mwifiex: fix sleep in
 atomic context bugs
Content-Language: en-US
To:     <duoming@zju.edu.cn>
CC:     Kalle Valo <kvalo@kernel.org>, <linux-kernel@vger.kernel.org>,
        <amitkarwar@gmail.com>, <ganapathi017@gmail.com>,
        <sharvari.harisangam@nxp.com>, <huxinming820@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <20220519135345.109936-1-duoming@zju.edu.cn>
 <87zgjd1sd4.fsf@kernel.org>
 <699e56d5.22006.180dce26e02.Coremail.duoming@zju.edu.cn>
 <18852332-ee42-ef7e-67a3-bbd91a6694ba@quicinc.com>
 <4e778cb1.22654.180decbcb8e.Coremail.duoming@zju.edu.cn>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <4e778cb1.22654.180decbcb8e.Coremail.duoming@zju.edu.cn>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/19/2022 5:08 PM, duoming@zju.edu.cn wrote:
> Hello,
> 
> On Thu, 19 May 2022 08:48:44 -0700 Jeff Johnson wrote:
> 
>>>>> There are sleep in atomic context bugs when uploading device dump
>>>>> data on usb interface. The root cause is that the operations that
>>>>> may sleep are called in fw_dump_timer_fn which is a timer handler.
>>>>> The call tree shows the execution paths that could lead to bugs:
>>>>>
>>>>>      (Interrupt context)
>>>>> fw_dump_timer_fn
>>>>>     mwifiex_upload_device_dump
>>>>>       dev_coredumpv(..., GFP_KERNEL)
>>
>> just looking at this description, why isn't the simple fix just to
>> change this call to use GFP_ATOMIC?
> 
> Because change the parameter of dev_coredumpv() to GFP_ATOMIC could only solve
> partial problem. The following GFP_KERNEL parameters are in /lib/kobject.c
> which is not influenced by dev_coredumpv().
> 
>   kobject_set_name_vargs
>     kvasprintf_const(GFP_KERNEL, ...); //may sleep
>     kstrdup(s, GFP_KERNEL); //may sleep

Then it seems there is a problem with dev_coredumpm().

dev_coredumpm() takes a gfp param which means it expects to be called in 
any context, but it then calls dev_set_name() which, as you point out, 
cannot be called from an atomic context.

So if we cannot change the fact that dev_set_name() cannot be called 
from an atomic context, then it would seem to follow that 
dev_coredumpv()/dev_coredumpm() also cannot be called from an atomic 
context and hence their gfp param is pointless and should presumably be 
removed.

/jeff
