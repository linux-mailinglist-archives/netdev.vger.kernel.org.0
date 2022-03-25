Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A87B44E7CB6
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233708AbiCYWTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 18:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233603AbiCYWTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 18:19:47 -0400
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A6816AA6A;
        Fri, 25 Mar 2022 15:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1648246693; x=1679782693;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9jYjx+4jeXCmvNIm9diCTLqf2spnMxHz/9y78hPvvBQ=;
  b=Yk/zxMdglai/5OZ8UFe7yPyyVRs8dAHlgseQ+zq8o8bULUZ0rcTOimj7
   XDKEd3pSlyUv48fxqnarSzSlxHxmz9eO9fqdkel0WunEIgD8g4cg2YCD6
   N5fJxw2BsHLhi/+rnI/7ev5qxUa07zER6LYgKlByWXzSZI9qh8QzNNjaw
   Q=;
Received: from ironmsg07-lv.qualcomm.com ([10.47.202.151])
  by alexa-out.qualcomm.com with ESMTP; 25 Mar 2022 15:18:13 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg07-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2022 15:18:12 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 25 Mar 2022 15:18:11 -0700
Received: from [10.110.27.134] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 25 Mar
 2022 15:18:10 -0700
Message-ID: <487e4136-94dc-5a77-89c7-e416a05c3a35@quicinc.com>
Date:   Fri, 25 Mar 2022 15:18:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [BUG] deadlock in nl80211_vendor_cmd
Content-Language: en-US
To:     Johannes Berg <johannes@sipsolutions.net>,
        William McVicker <willmcvicker@google.com>
CC:     Jakub Kicinski <kuba@kernel.org>, <linux-wireless@vger.kernel.org>,
        "Marek Szyprowski" <m.szyprowski@samsung.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Amitkumar Karwar" <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>, <kernel-team@android.com>,
        Paolo Abeni <pabeni@redhat.com>
References: <0000000000009e9b7105da6d1779@google.com>
 <99eda6d1dad3ff49435b74e539488091642b10a8.camel@sipsolutions.net>
 <5d5cf050-7de0-7bad-2407-276970222635@quicinc.com>
 <YjpGlRvcg72zNo8s@google.com>
 <dc556455-51a2-06e8-8ec5-b807c2901b7e@quicinc.com>
 <Yjzpo3TfZxtKPMAG@google.com>
 <19e12e6b5f04ba9e5b192001fbe31a3fc47d380a.camel@sipsolutions.net>
 <20220325094952.10c46350@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <f4f8a27dc07c1adaab470fde302ed841113e6b7f.camel@sipsolutions.net>
 <Yj4FFIXi//ivQC3X@google.com> <Yj4ntUejxaPhrM5b@google.com>
 <976e8cf697c7e5bc3a752e758a484b69a058710a.camel@sipsolutions.net>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <976e8cf697c7e5bc3a752e758a484b69a058710a.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/25/2022 2:16 PM, Johannes Berg wrote:
> On Fri, 2022-03-25 at 20:36 +0000, William McVicker wrote:
>>
>> I found that my wlan driver is using the vendor commands to create/delete NAN
>> interfaces for this Android feature called Wi-Fi aware [1]. Basically, this
>> features allows users to discover other nearby devices and allows them to
>> connect directly with one another over a local network.
>>
> 
> Wait, why is it doing that? We actually support a NAN interface type
> upstream :) It's not really quite fully fleshed out, but it could be?
> Probably should be?

And this is the issue with Android drivers. Android team proposes 
changes to the Wifi HAL and driver vendors have to implement those 
quickly to meet product deadlines. Some infrastructure changes we're 
able to get into the core kernel without having an in-tree driver that 
uses them (such as introducing NL80211_IFTYPE_NAN), but there have been 
instances of core kernel changes being rejected because there was not an 
in-tree user.

Yes, in your ideal world all of the Android wifi drivers would be 
in-tree. And in that ideal world every release cycle the Android team 
would advocate for core kernel changes needed to support the new 
features of the HAL. But past history has shown attempts to upstream new 
features has been delayed, perhaps in part due to the absence of an 
in-tree driver that utilizes those features, and the only way to meet 
product deadlines is to take the vendor command route.

And yes my out-of-tree driver is facing the exact same issue with NAN 
interface creation and deletion via vendor commands.

Previously you had suggested:
> Your easiest option might be to just patch NL80211_FLAG_NEED_RTNL into
> your kernel for vendor commands and call it a day? 

Would you consider taking that upstream given that there are very few 
in-tree users of vendor commands, and I fear Will and I aren't the only 
ones who'll face this issue?

Will, suggest you at least advocate for getting this into the 5.15 ACK.

/jeff
