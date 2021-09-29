Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D40C41D024
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 01:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347708AbhI2XuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 19:50:20 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:60024 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347701AbhI2XuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 19:50:19 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.203])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 800072006C;
        Wed, 29 Sep 2021 23:48:36 +0000 (UTC)
Received: from mail3.candelatech.com (mail2.candelatech.com [208.74.158.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 53DEBAC0081;
        Wed, 29 Sep 2021 23:48:36 +0000 (UTC)
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id BEC2513C2B0;
        Wed, 29 Sep 2021 16:48:35 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com BEC2513C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1632959315;
        bh=vHWqpT/MLbnLwFw4Q6glPgTHpa6f8eTf4ukDFS7NK/M=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=b9EnBhFuPOapMB2UBqB9KDCm0CgRLUBDyeEFLp6D0KmMOEX/3q22CE4WRopjMsZN2
         3Xkc253QEsYc4I9vYyb7DlbpcxOXDEMPANg73iNIW/03qSIqpRg8PADuc3/bwa4efS
         qba6A5Q8Z1cwc1GINpihjxJqVvIoE/JlI/840nLI=
Subject: Re: 5.15-rc3+ crash in fq-codel?
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>
References: <dfa032f3-18f2-22a3-80bf-f0f570892478@candelatech.com>
 <b6e8155e-7fae-16b0-59f0-2a2e6f5142de@gmail.com>
 <00e495ba-391e-6ad8-94a2-930fbc826a37@candelatech.com>
 <296232ac-e7ed-6e3c-36b9-ed430a21f632@candelatech.com>
 <7e87883e-42f5-2341-ab67-9f1614fb8b86@candelatech.com>
 <7f1d67f1-3a2c-2e74-bb86-c02a56370526@gmail.com>
 <88bc8a03-da44-fc15-f032-fe5cb592958b@candelatech.com>
 <b537053d-498d-928b-8ca0-e9daf5909128@gmail.com>
 <f3f1378d-6839-cd23-9e2c-4668947c2345@gmail.com>
 <41b4221b-be68-da96-8cbf-4297bb7ba821@gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <8768df9e-f1f6-db25-15d8-cabed2346f32@candelatech.com>
Date:   Wed, 29 Sep 2021 16:48:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <41b4221b-be68-da96-8cbf-4297bb7ba821@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-MDID: 1632959317-i29wC2umFs-X
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/29/21 4:42 PM, Eric Dumazet wrote:
> 
> 
> On 9/29/21 4:28 PM, Eric Dumazet wrote:
>>
> 
>>
>> Actually the bug seems to be in pktgen, vs NET_XMIT_CN
>>
>> You probably would hit the same issues with other qdisc also using NET_XMIT_CN
>>
> 
> I would try the following patch :
> 
> diff --git a/net/core/pktgen.c b/net/core/pktgen.c
> index a3d74e2704c42e3bec1aa502b911c1b952a56cf1..0a2d9534f8d08d1da5dfc68c631f3a07f95c6f77 100644
> --- a/net/core/pktgen.c
> +++ b/net/core/pktgen.c
> @@ -3567,6 +3567,7 @@ static void pktgen_xmit(struct pktgen_dev *pkt_dev)
>          case NET_XMIT_DROP:
>          case NET_XMIT_CN:
>                  /* skb has been consumed */
> +               pkt_dev->last_ok = 1;
>                  pkt_dev->errors++;
>                  break;
>          default: /* Drivers are not supposed to return other values! */
> 

Thanks, that makes sense to me.  I'll test that out tomorrow...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

