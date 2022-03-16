Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBC14DACB6
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 09:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349714AbiCPIno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 04:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241762AbiCPInm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 04:43:42 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC4064BC2;
        Wed, 16 Mar 2022 01:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1647420145;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=hTsp7OapLNx3g9rQvgRH6HCjHjq3R7cpjLkkERGVtx4=;
    b=ZH7gPT/EjHBiIknsGRpD94hvbeteTN6vfK0SSfYKc6FauLmMW7gIHa+AlBJFr6qd9N
    XkKwXIHoAx1WmxnFqQMLC1gAHwfAbttYq2VlamEOkm4YL5F8wfyTVOAquziFjLt9Db02
    By9CeItl0K3dceNDTUirbq84m7wgWl7edpcFkz344Yn0cYxON7wpML99u1RppKc25bSW
    kmY9We1u2ajbQuqiiB81rrEe/7SsFUrDnebHiGmQ+BKqknNEs+upEj8ki0ZsyBaySl0n
    eJza8ScdIapwtztJpcEwAbw4+wyfxs78BIc7al8Sfbe1t2l33mCeZWp+qZY86o+hZwng
    nr2Q==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdd0DIgVuBOfXW6v7w=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfa:f900::b82]
    by smtp.strato.de (RZmta 47.41.0 AUTH)
    with ESMTPSA id a046a1y2G8gP208
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 16 Mar 2022 09:42:25 +0100 (CET)
Message-ID: <ec2adb66-2199-2f9d-15ce-6641562c54f2@hartkopp.net>
Date:   Wed, 16 Mar 2022 09:42:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [net-next] can: isotp: sanitize CAN ID checks in isotp_bind()
Content-Language: en-US
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        syzbot+2339c27f5c66c652843e@syzkaller.appspotmail.com,
        linux-can <linux-can@vger.kernel.org>
References: <20220315203748.1892-1-socketcan@hartkopp.net>
 <20220315185134.687fe506@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3922032f-c829-b609-e408-6dec83a0041a@hartkopp.net>
 <20220316074802.b3xazftb7axziue3@pengutronix.de>
 <7445f2f1-4d89-116e-0cf7-fc7338c2901f@hartkopp.net>
 <20220316080111.s2hlj6krlzcroxh6@pengutronix.de>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20220316080111.s2hlj6krlzcroxh6@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 16.03.22 09:01, Marc Kleine-Budde wrote:
> On 16.03.2022 08:53:54, Oliver Hartkopp wrote:
>>> Should this go into net/master with stable on Cc or to net-next?
>>
>> This patch is for net-next as it won't apply to net/master nor the
>> stable trees due to the recent changes in net-next.
>>
>> As it contains a Fixes: tag I would send the patch for the stable
>> trees when the patch hits Linus' tree and likely Greg would show up
>> asking for it.
>>
>> I hope that's the most elegant process here?!?
> 
> Another option is to port the patch to net/master with the hope that
> back porting is easier.

I have a patch here for net/master that also properly applies down to 
linux-5.10.y
If requested I could post it instantly.

> Then talk to Jakub and David about the merge
> conflict when net/master is merged to net-next/master.

Yes. There will be a merge conflict. Therefore I thought bringing that 
patch for the released 5.17 and the stable trees later would be less 
effort for Jakub and David.

Best regards.
Oliver
