Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2374FDF06
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 14:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348000AbiDLMF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 08:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354602AbiDLMEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 08:04:40 -0400
Received: from smtp-190a.mail.infomaniak.ch (smtp-190a.mail.infomaniak.ch [IPv6:2001:1600:4:17::190a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 688DC5623A
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 04:07:25 -0700 (PDT)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4Kd2xQ5bZGzMpvCG;
        Tue, 12 Apr 2022 13:07:22 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4Kd2xQ1jKlzljsTj;
        Tue, 12 Apr 2022 13:07:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1649761642;
        bh=hdT0n/yGB+udShZ9jh7ougx0uizMRtCIzzMECKwb6I0=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=Ov765teFETg9CKi7Sr2LidqlCCNWHCI3wIFdpxdr/yBg71su8fgyE2Aq42iMtlUle
         poGNb4mgJNbdWVo5QPE5mi/0M4+nW2nYWB1TldCSY5vu3eIM2EoaP7HF+1N29RnJql
         oEH7oGTMu7DbyGIdqbQRIRxXH21PCBUmhFMKZz44=
Message-ID: <0e5afeaf-0569-d0b5-b701-0f611d103732@digikod.net>
Date:   Tue, 12 Apr 2022 13:07:39 +0200
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>,
        willemdebruijn.kernel@gmail.com
Cc:     linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com, anton.sirazetdinov@huawei.com
References: <20220309134459.6448-1-konstantin.meskhidze@huawei.com>
 <20220309134459.6448-4-konstantin.meskhidze@huawei.com>
 <bc44f11f-0eaa-a5f6-c5dc-1d36570f1be1@digikod.net>
 <6535183b-5fad-e3a9-1350-d22122205be6@huawei.com>
 <92d498f0-c598-7413-6b7c-d19c5aec6cab@digikod.net>
 <cb30248d-a8ae-c366-2c9f-2ab0fe44cc9a@huawei.com>
 <90a20548-39f6-6e84-efb1-8ef3ad992255@digikod.net>
 <212ac1b3-b78b-4030-1f3d-f5cd1001bb7d@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [RFC PATCH v4 03/15] landlock: landlock_find/insert_rule
 refactoring (TCP port 0)
In-Reply-To: <212ac1b3-b78b-4030-1f3d-f5cd1001bb7d@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 23/03/2022 09:41, Konstantin Meskhidze wrote:
> 
> 
> 3/22/2022 4:24 PM, Mickaël Salaün пишет:
>>

[...]
>> The remaining question is: should we need to accept 0 as a valid TCP 
>> port? Can it be used? How does the kernel handle it?
> 
>   I agree that must be a check for port 0 in add_rule_net_service(), 
> cause unlike most port numbers, port 0 is a reserved port in TCP/IP 
> networking, meaning that it should not be used in TCP or UDP messages.
> Also network traffic sent across the internet to hosts listening on port 
> 0 might be generated from network attackers or accidentally by 
> applications programmed incorrectly.
> Source: https://www.lifewire.com/port-0-in-tcp-and-udp-818145

OK, so denying this port by default without a way to allow it should not 
be an issue. I guess an -EINVAL error would make sense when trying to 
allow this port. This should be documented in a comment (with a link to 
the RFC/section) and a dedicated test should check that behavior.

What is the behavior of firewalls (e.g. Netfiler) when trying to filter 
port 0?

This doesn't seem to be settle though: 
https://www.austingroupbugs.net/view.php?id=1068

Interesting article: 
https://z3r0trust.medium.com/socket-programming-the-bizarre-tcp-ip-port-0-saga-fcfbc0e0a276
