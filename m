Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F237962ED57
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 06:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240999AbiKRFux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 00:50:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240996AbiKRFuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 00:50:52 -0500
Received: from mx23lb.world4you.com (mx23lb.world4you.com [81.19.149.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C81F97AA1
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 21:50:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=hxuTsymMVx1nGfafs9G+DVwJO7Ts8+PYUc21+EnL+f4=; b=fcRJo2SkgbQyqRBzCak7saGASq
        lH/E47rFsoQu5FD/bgyazorZuHbAp1hA9A2LEQCZIJOf0dJx41gi40rtgP5m+oXsl4dX7RL9l4PRf
        uhKMXyY89Rym1dYiVuXSJwRiu9GO4bGyiUV3fXePV0VQpjJmHbEqB50508TLCJwBn/3w=;
Received: from [88.117.56.227] (helo=[10.0.0.160])
        by mx23lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1ovuH2-0000bg-0K; Fri, 18 Nov 2022 06:50:48 +0100
Message-ID: <784e1ad7-0110-43f9-342c-abe513123f1a@engleder-embedded.com>
Date:   Fri, 18 Nov 2022 06:50:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next 1/4] tsnep: Throttle interrupts
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com
References: <20221117201440.21183-1-gerhard@engleder-embedded.com>
 <20221117201440.21183-2-gerhard@engleder-embedded.com>
 <Y3aatP+384keCkpN@lunn.ch>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <Y3aatP+384keCkpN@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.11.22 21:33, Andrew Lunn wrote:
> On Thu, Nov 17, 2022 at 09:14:37PM +0100, Gerhard Engleder wrote:
>> Without interrupt throttling, iperf server mode generates a CPU load of
>> 100% (A53 1.2GHz). Also the throughput suffers with less than 900Mbit/s
>> on a 1Gbit/s link. The reason is a high interrupt load with interrupts
>> every ~20us.
> 
> Not my area of expertise, but is NAPI working correctly? It should be
> that you disable interrupts while NAPI is polling, and only re-enable
> interrupts when polling has stopped. If you are receiving at near line
> rate at 100% load, i would of thought that NAPI would be polling most
> of the time and interrupts would be mostly disabled?

I disable and re-enable interrupts in the driver, but I don't know
exactly under which conditions interrupts will be disabled mostly. At
least during my XDP tests with minimum size packets the interrupt rate
dropped significantly. Here the CPU had also 100% load but packet rate
was much higher with ~880000 pkt/s.

I compared the performance and the interrupt rate with the macb driver
on the same CPU and the results were similar.

> Interrupt coalescence makes a lot of sense thought, so the patch
> itself is useful.

Thanks!

Gerhard
