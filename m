Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECCD5B406D
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 22:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbiIIUUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 16:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbiIIUUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 16:20:41 -0400
X-Greylist: delayed 5547 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 09 Sep 2022 13:20:39 PDT
Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F248F7694F;
        Fri,  9 Sep 2022 13:20:39 -0700 (PDT)
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 3651D3338D;
        Fri,  9 Sep 2022 18:48:14 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.64.31])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 4CEFC1C0087;
        Fri,  9 Sep 2022 18:48:11 +0000 (UTC)
Received: from mail3.candelatech.com (mail2.candelatech.com [208.74.158.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 3276D600077;
        Fri,  9 Sep 2022 18:48:10 +0000 (UTC)
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 4C9DD13C2B0;
        Fri,  9 Sep 2022 11:48:09 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 4C9DD13C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1662749289;
        bh=OxEUMDoySFKOhq0UBTVO7cZL3nEq0r+AmeukrDSmFU8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=jVKmEoZWvxt500qv4Qf+/OwLytJDXGCoAhJUbZ0HJ4idoSiFxgfA+Rq7cIuV7qHw9
         48QxFrrYhK/ec+idHm/32urIFVAtDapJ1LQPxXQnZ10/K3fgTw7TZ1/erU5iLXNsLU
         1wN1cjnMX2Db2IqR1u26qfSq2LYZy775f2wysx+g=
Subject: Re: [PATCH AUTOSEL 5.4 06/16] wifi: mac80211: do not wake queues on a
 vif that is being stopped
To:     Johannes Berg <johannes@sipsolutions.net>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@kernel.org>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220720011730.1025099-1-sashal@kernel.org>
 <20220720011730.1025099-6-sashal@kernel.org>
 <b43cfde3-7f33-9153-42ca-9e1ecf409d2a@candelatech.com>
 <ff30252059ae6a7a74c135f9fa9525d379f9e74a.camel@sipsolutions.net>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <aafaf5f1-c8a1-2a13-2201-b83f65c77942@candelatech.com>
Date:   Fri, 9 Sep 2022 11:48:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <ff30252059ae6a7a74c135f9fa9525d379f9e74a.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-MDID: 1662749291-c0RrVeYq27PU
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/19/22 10:50 PM, Johannes Berg wrote:
> On Tue, 2022-07-19 at 18:58 -0700, Ben Greear wrote:
>> I think this one had a regression and needs another init-lock-early patch to keep from causing
>> problems?
>>
> 
> Yes, for now we should drop it from all stable trees. We'll re-assess
> the situation later if it's needed there or not, I guess.
> 
> johannes
> 

I think there is a second problem with this patch:

If I create multiple station vdevs (on mtk7916 radio, not sure that matters much or not),
and admin up a few of them, but leave remainder down, then the queues on the originally-down-vdevs
are never started and so tx-path-hang on those stations.

I am not sure the best way to fix this.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

