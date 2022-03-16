Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB0E34DABE1
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 08:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352638AbiCPHhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 03:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345500AbiCPHhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 03:37:21 -0400
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C28D53E32
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 00:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1647416164;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=F8YpoKkv6lez90Q1mC78jHCngf9a96dTnmbpkpkZX3k=;
    b=HMJvGorx+4py2XZJ2eT6PFKRzpmWoXnnS9XN33eaaTZ/sGZiX+QSLujGekIlzrb/Ro
    suAiOYtEIx58MqFC3dx1gpLppXCnNQbwhOlQ8TEBGGj3rsAIwelHIokydPHrxInqHSO4
    SLXVc1nD9OOpe+UOEgRsGXdy5l68rKSvM9qjqtTrtecco1vE0/KX6M1/SfL3f1iLXhvd
    LFizhE9mXEiklQ87vUoIEZF/CID/rdkSAO6+dfID7l7ZNOCjq0eAjuJL8VSSEfOXDrpt
    JhuQdmyZ7XNKvmDHaJU9Pp3+5h2jGvhHUL4bzcyeaUmy1a5KJghzK3cCA/m4d24o6aYH
    LCVQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdd0DIgVuBOfXW6v7w=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfa:f900::b82]
    by smtp.strato.de (RZmta 47.41.0 AUTH)
    with ESMTPSA id a046a1y2G7a41fG
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 16 Mar 2022 08:36:04 +0100 (CET)
Message-ID: <3922032f-c829-b609-e408-6dec83a0041a@hartkopp.net>
Date:   Wed, 16 Mar 2022 08:35:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [net-next] can: isotp: sanitize CAN ID checks in isotp_bind()
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org,
        syzbot+2339c27f5c66c652843e@syzkaller.appspotmail.com
References: <20220315203748.1892-1-socketcan@hartkopp.net>
 <20220315185134.687fe506@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20220315185134.687fe506@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 16.03.22 02:51, Jakub Kicinski wrote:
> On Tue, 15 Mar 2022 21:37:48 +0100 Oliver Hartkopp wrote:
>> Syzbot created an environment that lead to a state machine status that
>> can not be reached with a compliant CAN ID address configuration.
>> The provided address information consisted of CAN ID 0x6000001 and 0xC28001
>> which both boil down to 11 bit CAN IDs 0x001 in sending and receiving.
>>
>> Sanitize the SFF/EFF CAN ID values before performing the address checks.
>>
>> Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
>> Reported-by: syzbot+2339c27f5c66c652843e@syzkaller.appspotmail.com
>> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
> 
> CC Marc, please make sure you CC maintainers.

Oh, that would have been better! I'm maintaining the CAN network layer 
stuff together with Marc and there was no relevant stuff in can-next to 
be pulled in the next days. So I sent it directly to hit the merge 
window and had all of us in the reply to the syzbot report.

Will CC Marc next time when posting to netdev only!

Maybe I treated this patch more urgent than it needed to be handled 
¯\_(ツ)_/¯

Thanks & best regards,
Oliver


