Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFBFA610F9F
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 13:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbiJ1LZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 07:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbiJ1LZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 07:25:04 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.166])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75BDB5FF74;
        Fri, 28 Oct 2022 04:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1666956281;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=7v1Lc0mrTAZ3fxIwBDnwQONRBkHRnlphfULEbABarX8=;
    b=LB6ekYdKq7/Ofq1rabkpWmfX8lhuf6Dva/xPFq3U24g+LNZwqATrd0z+6bU75kfogu
    BkQQ9mfheepwZmC8zPz/1oqVh5ZNSnobmQmBYa/SIEjj7/gvzRhmL/3f0AYI7mVE8WlV
    bd+0Xp4RUw6jpFQ8FOKhhS72F6zvwAOUgv+f08SG2YsQ1iWSxPDzMMgQxHVAp7DVWWDL
    6A4Yr9Wc3Uw/YiXkTUjReUyvR/wYXYz+mkkV1+JQ4Ovu2GTuzaU3o+JeFfXK07svyd/s
    dSlTxlByAcg4jshnhPsBZZJOkPVvKfDQsCy4T1bS+8Vohec52LXeq0pbBBu50Xpp/y9S
    KFaQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdIrpKytJSr6hfz3Vg=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfd:d100::923]
    by smtp.strato.de (RZmta 48.2.1 AUTH)
    with ESMTPSA id Dde783y9SBOfA4X
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 28 Oct 2022 13:24:41 +0200 (CEST)
Message-ID: <773e6b03-c816-5ecb-bd4f-5f214fa347fb@hartkopp.net>
Date:   Fri, 28 Oct 2022 13:24:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH net] can: af_can: fix NULL pointer dereference in
 can_rx_register()
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Zhengchao Shao <shaozhengchao@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@rempel-privat.de, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
References: <20221028033342.173528-1-shaozhengchao@huawei.com>
 <d1e728d2-b62f-3646-dd27-8cc36ba7c819@hartkopp.net>
 <20221028074637.3havdrt37qsmbvll@pengutronix.de>
Content-Language: en-US
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20221028074637.3havdrt37qsmbvll@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 28.10.22 09:46, Marc Kleine-Budde wrote:
> On 28.10.2022 09:13:09, Oliver Hartkopp wrote:
>> Hello,
>>
>> On 28.10.22 05:33, Zhengchao Shao wrote:
>>> It causes NULL pointer dereference when testing as following:
>>> (a) use syscall(__NR_socket, 0x10ul, 3ul, 0) to create netlink socket.
>>> (b) use syscall(__NR_sendmsg, ...) to create bond link device and vxcan
>>>       link device, and bind vxcan device to bond device (can also use
>>>       ifenslave command to bind vxcan device to bond device).
>>> (c) use syscall(__NR_socket, 0x1dul, 3ul, 1) to create CAN socket.
>>> (d) use syscall(__NR_bind, ...) to bind the bond device to CAN socket.
>>>
>>> The bond device invokes the can-raw protocol registration interface to
>>> receive CAN packets. However, ml_priv is not allocated to the dev,
>>> dev_rcv_lists is assigned to NULL in can_rx_register(). In this case,
>>> it will occur the NULL pointer dereference issue.
>>
>> I can see the problem and see that the patch makes sense for
>> can_rx_register().
>>
>> But for me the problem seems to be located in the bonding device.
>>
>> A CAN interface with dev->type == ARPHRD_CAN *always* has the dev->ml_priv
>> and dev->ml_priv_type set correctly.
>>
>> I'm not sure if a bonding device does the right thing by just 'claiming' to
>> be a CAN device (by setting dev->type to ARPHRD_CAN) but not taking care of
>> being a CAN device and taking care of ml_priv specifics.
>>
>> This might also be the case in other ml_priv use cases.
>>
>> Would it probably make sense to blacklist CAN devices in bonding devices?
> 
> NACK - We had this discussion 2.5 years ago:
> 
> | https://lore.kernel.org/all/00000000000030dddb059c562a3f@google.com
> | https://lore.kernel.org/all/20200130133046.2047-1-socketcan@hartkopp.net
> 
> ...and davem pointed out:
> 
> | https://lore.kernel.org/all/20200226.202326.295871777946911500.davem@davemloft.net
> 
> On 26.02.2020 20:23:26, David Miller wrote:
> [...]
>> What I don't get is why the PF_CAN is blindly dereferencing a device
>> assuming what is behind bond_dev->ml_priv.
>>
>> If it assumes a device it access is CAN then it should check the
>> device by comparing the netdev_ops or via some other means.
>>
>> This restriction seems arbitrary.
> 
> With the addition of struct net_device::ml_priv_type in 4e096a18867a
> ("net: introduce CAN specific pointer in the struct net_device"), what
> davem requested is now possible.
> 
> Marc

Oh, thanks for the heads up!

Didn't have remembered that specific discussion.

Wouldn't we need this check in can_rx_unregister() and maybe 
can[|fd|xl]_rcv() then too?

As all these functions check for ARPHRD_CAN and later access ml_priv.

Best regards,
Oliver

