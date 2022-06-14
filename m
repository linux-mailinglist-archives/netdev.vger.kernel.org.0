Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11C2254B8B1
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 20:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233430AbiFNSeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 14:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232378AbiFNSeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 14:34:12 -0400
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F8A11C2C
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 11:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1655231651; x=1686767651;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=QsY20Icp8Q40Y4C5VztqWfV5SPkEpuA/4NP/+wrGzlY=;
  b=COL6QCgj9h2AZ1arCP+LEb8hASgRIwg4CycwRW50N+E6n3fIH6Pp4NNT
   gkjPfil/HstZRDoeyMLzW7VjGJpFVcxKyp7QHBR3RbI39a4mxuHGb1GXV
   2w8WG17rEYLxPQ1oNpn8Mw2/mMARyKyARDibMWv+LCtohUYcL1IwDCJ0t
   A=;
Received: from ironmsg-lv-alpha.qualcomm.com ([10.47.202.13])
  by alexa-out.qualcomm.com with ESMTP; 14 Jun 2022 11:34:11 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg-lv-alpha.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2022 11:34:10 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 14 Jun 2022 11:34:10 -0700
Received: from [10.110.105.179] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 14 Jun
 2022 11:34:09 -0700
Message-ID: <762a0384-e233-2107-16ef-1510ad2e82c8@quicinc.com>
Date:   Tue, 14 Jun 2022 12:34:08 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH net v2 1/2] ipv6: Honor route mtu if it is within limit of
 dev mtu
Content-Language: en-US
To:     Stefano Brivio <sbrivio@redhat.com>,
        Kaustubh Pandey <quic_kapandey@quicinc.com>
CC:     <davem@davemloft.net>, <dsahern@kernel.org>,
        <yoshfuji@linux-ipv6.org>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>,
        Sean Tranchetti <quic_stranche@quicinc.com>
References: <1655182915-12897-1-git-send-email-quic_subashab@quicinc.com>
 <1655182915-12897-2-git-send-email-quic_subashab@quicinc.com>
 <20220614142737.73fffc9d@elisabeth>
From:   "Subash Abhinov Kasiviswanathan (KS)" <quic_subashab@quicinc.com>
In-Reply-To: <20220614142737.73fffc9d@elisabeth>
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

> I read this a few times but I still fail to understand what issue
> you're actually fixing -- what makes this new MTU "wrong"?
> 
> The idea behind the original implementation is that, when an interface
> MTU is administratively updated, we should allow PMTU updates, if the
> old PMTU was matching the interface MTU, because the old MTU setting
> might have been the one limiting the MTU on the whole path.

Hi Stefano

Here is some additional background on the observations - consider a case
where an interface is brought up with IPv6 connection first with PMTU 
1280 (set via the MTU option of a router advertisement) followed by an 
IPv4 connection with PMTU 1700. An userspace management entity sets the 
link MTU to the maximum of IPv4 and IPv6 PMTUs.

When the IPv4 connection is brought up, the link MTU changes to 1700 
(max of IPv4 & IPv6 PMTUs in this case) which unnecessarily causes the 
PMTUD to occur for the IPv6 case.


> That is, if you lower the MTU on an interface, and then increase it
> back, a permanently lower PMTU is somewhat unexpected. As far as I can
> see, this behaviour persists with this patch, but:

I agree that this would indeed occur after the patch. The assumption 
here is that there would be an update from a router via a new router
advertisement if the IPv6 PMTU has to be increased / updated.

> ...I'm not sure what you really mean by "incoming dev mtu". Is it the
> newly configured one?

Yes, this is the new MTU configured by userspace.
