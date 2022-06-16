Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D836654D9BE
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 07:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358676AbiFPFgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 01:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358674AbiFPFgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 01:36:15 -0400
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA5F65AEF0
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 22:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1655357775; x=1686893775;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Kca8HefnmBfJ8RFrbcROOESYt9gYVBOggIJ7RYzPMRI=;
  b=NvF5Ab3J2p26qAtKyFSfXw4QpQ/kLITfLPkGLhTFDjpMOlbsfm2XB3bw
   fP7n8gqk0mwM3ppRF0VAHdUqKNVKJVRVANZSA5gxGNcIDd2jnWYOaa/9l
   TVKddPAxN2qj7uXbdWzouO/rf0hEvl/L7fX7HAijZYba1HAPo0lyuYujo
   0=;
Received: from ironmsg09-lv.qualcomm.com ([10.47.202.153])
  by alexa-out.qualcomm.com with ESMTP; 15 Jun 2022 22:36:14 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg09-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 22:36:13 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Wed, 15 Jun 2022 22:36:12 -0700
Received: from [10.110.98.37] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 15 Jun
 2022 22:36:11 -0700
Message-ID: <132e514e-bad8-9f73-8f08-1bd5ac8aecd4@quicinc.com>
Date:   Wed, 15 Jun 2022 23:36:10 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH net v2 1/2] ipv6: Honor route mtu if it is within limit of
 dev mtu
Content-Language: en-US
To:     =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Linux NetDev <netdev@vger.kernel.org>,
        Stefano Brivio <sbrivio@redhat.com>,
        "Kaustubh Pandey" <quic_kapandey@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>
References: <1655182915-12897-1-git-send-email-quic_subashab@quicinc.com>
 <1655182915-12897-2-git-send-email-quic_subashab@quicinc.com>
 <20220615173516.29c80c96@kernel.org>
 <CANP3RGfGcr25cjnrUOdaH1rG9S9uY8uS80USXeycDBhbsX9CZw@mail.gmail.com>
From:   "Subash Abhinov Kasiviswanathan (KS)" <quic_subashab@quicinc.com>
In-Reply-To: <CANP3RGfGcr25cjnrUOdaH1rG9S9uY8uS80USXeycDBhbsX9CZw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> CC maze, please add him if there is v3
>>
>> I feel like the problem is with the fact that link mtu resets protocol
>> MTUs. Nothing we can do about that, so why not set link MTU to 9k (or
>> whatever other quantification of infinity there is) so you don't have
>> to touch it as you discover the MTU for v4 and v6?

That's a good point.

>>
>> My worry is that the tweaking of the route MTU update heuristic will
>> have no end.
>>
>> Stefano, does that makes sense or you think the change is good?

The only concern is that current behavior causes the initial packets 
after interface MTU increase to get dropped as part of PMTUD if the IPv6 
PMTU itself didn't increase. I am not sure if that was the intended 
behavior as part of the original change. Stefano, could you please confirm?

> I vaguely recall that if you don't want device mtu changes to affect
> ipv6 route mtu, then you should set 'mtu lock' on the routes.
> (this meaning of 'lock' for v6 is different than for ipv4, where
> 'lock' means transmit IPv4/TCP with Don't Frag bit unset)

I assume 'mtu lock' here refers to setting the PMTU on the IPv6 routes 
statically. The issue with that approach is that router advertisements 
can no longer update PMTU once a static route is configured.
