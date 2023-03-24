Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5446C836E
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 18:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbjCXRfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 13:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjCXRfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 13:35:09 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD83DC64C;
        Fri, 24 Mar 2023 10:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:Subject:From
        :References:Cc:To:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=miGmwI1bTGkIjWnSC43LX/N+9isfAegXHNpz6mp4Veg=; b=myXgInc3xx8PMiPFGMZq3OGoHm
        ZLnQv4NmgXzemL98aFuh6/2u4qpW7QGvhTTTAxoi+QH4U2t3U6biOks9dNPgc0koyO3B1cta6kLct
        TPulu/bIE//tDM3Lw+Vr+4AiLUeKVslDfbkfB2qtTy1lwSfdOb+llXeHtEIr7IsMWZ1I=;
Received: from p200300daa7147b00f53b1e71cf2162bd.dip0.t-ipconnect.de ([2003:da:a714:7b00:f53b:1e71:cf21:62bd] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1pflJc-006Rgm-PY; Fri, 24 Mar 2023 18:35:00 +0100
Message-ID: <2d251879-1cf4-237d-8e62-c42bb4feb047@nbd.name>
Date:   Fri, 24 Mar 2023 18:35:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230324171314.73537-1-nbd@nbd.name>
 <20230324102038.7d91355c@kernel.org>
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH net-next] net/core: add optional threading for backlog
 processing
In-Reply-To: <20230324102038.7d91355c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.03.23 18:20, Jakub Kicinski wrote:
> On Fri, 24 Mar 2023 18:13:14 +0100 Felix Fietkau wrote:
>> When dealing with few flows or an imbalance on CPU utilization, static RPS
>> CPU assignment can be too inflexible. Add support for enabling threaded NAPI
>> for backlog processing in order to allow the scheduler to better balance
>> processing. This helps better spread the load across idle CPUs.
> 
> Can you explain the use case a little bit more?

I'm primarily testing this on routers with 2 or 4 CPUs and limited 
processing power, handling routing/NAT. RPS is typically needed to 
properly distribute the load across all available CPUs. When there is 
only a small number of flows that are pushing a lot of traffic, a static 
RPS assignment often leaves some CPUs idle, whereas others become a 
bottleneck by being fully loaded. Threaded NAPI reduces this a bit, but 
CPUs can become bottlenecked and fully loaded by a NAPI thread alone.

Making backlog processing threaded helps split up the processing work 
even more and distribute it onto remaining idle CPUs.

It can basically be used to make RPS a bit more dynamic and 
configurable, because you can assign multiple backlog threads to a set 
of CPUs and selectively steer packets from specific devices / rx queues 
to them and allow the scheduler to take care of the rest.

- Felix
