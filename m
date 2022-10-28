Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34837610B10
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 09:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiJ1HNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 03:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbiJ1HNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 03:13:33 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D37881B65FD;
        Fri, 28 Oct 2022 00:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1666941194;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=WBsnojuHoKnnLcdYz+N/pxwSegwPIzgkz5hK5ttC8V4=;
    b=MEF7xmtFz8yvuvLhFvR4xojg2SME2bCImc8Xnhak0Hj6Ai53bpkToBNuEvLcguZdK+
    6aCt2+v4HYs3I77+I3xV664CR70ESSceMr3RW56T3dDRPCb5joO/5gA7N9KZ2WomBczt
    Afue+aktdouW4hXlh7rmjXzZM2pXNDpLe2HPb4tcStQe47jbwFumXhoFnch6OEauHHv5
    8L7O5Qm40TzEJonQULtkuNtFS8oNZaUs901LgvKHbO2fiqMLktX0/IcIjbvi5Zktf6zf
    sv1z3iY3YGPTk+BwOzw1BFZdWKr+UcN5dGT1NXcD7yQ2Ldo3riV2AGT9A/Z1d5A5Yn6Y
    1PHA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdIrpKytJSr6hfz3Vg=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfd:d100::923]
    by smtp.strato.de (RZmta 48.2.1 AUTH)
    with ESMTPSA id Dde783y9S7DE8wG
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 28 Oct 2022 09:13:14 +0200 (CEST)
Message-ID: <d1e728d2-b62f-3646-dd27-8cc36ba7c819@hartkopp.net>
Date:   Fri, 28 Oct 2022 09:13:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH net] can: af_can: fix NULL pointer dereference in
 can_rx_register()
To:     Zhengchao Shao <shaozhengchao@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        mkl@pengutronix.de, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     linux@rempel-privat.de, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
References: <20221028033342.173528-1-shaozhengchao@huawei.com>
Content-Language: en-US
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20221028033342.173528-1-shaozhengchao@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On 28.10.22 05:33, Zhengchao Shao wrote:
> It causes NULL pointer dereference when testing as following:
> (a) use syscall(__NR_socket, 0x10ul, 3ul, 0) to create netlink socket.
> (b) use syscall(__NR_sendmsg, ...) to create bond link device and vxcan
>      link device, and bind vxcan device to bond device (can also use
>      ifenslave command to bind vxcan device to bond device).
> (c) use syscall(__NR_socket, 0x1dul, 3ul, 1) to create CAN socket.
> (d) use syscall(__NR_bind, ...) to bind the bond device to CAN socket.
> 
> The bond device invokes the can-raw protocol registration interface to
> receive CAN packets. However, ml_priv is not allocated to the dev,
> dev_rcv_lists is assigned to NULL in can_rx_register(). In this case,
> it will occur the NULL pointer dereference issue.

I can see the problem and see that the patch makes sense for 
can_rx_register().

But for me the problem seems to be located in the bonding device.

A CAN interface with dev->type == ARPHRD_CAN *always* has the 
dev->ml_priv and dev->ml_priv_type set correctly.

I'm not sure if a bonding device does the right thing by just 'claiming' 
to be a CAN device (by setting dev->type to ARPHRD_CAN) but not taking 
care of being a CAN device and taking care of ml_priv specifics.

This might also be the case in other ml_priv use cases.

Would it probably make sense to blacklist CAN devices in bonding devices?

Thanks & best regards,
Oliver

> 
> The following is the stack information:
> BUG: kernel NULL pointer dereference, address: 0000000000000008
> PGD 122a4067 P4D 122a4067 PUD 1223c067 PMD 0
> Oops: 0000 [#1] PREEMPT SMP
> RIP: 0010:can_rx_register+0x12d/0x1e0
> Call Trace:
> <TASK>
> raw_enable_filters+0x8d/0x120
> raw_enable_allfilters+0x3b/0x130
> raw_bind+0x118/0x4f0
> __sys_bind+0x163/0x1a0
> __x64_sys_bind+0x1e/0x30
> do_syscall_64+0x35/0x80
> entry_SYSCALL_64_after_hwframe+0x63/0xcd
> </TASK>
> 
> Fixes: 4e096a18867a ("net: introduce CAN specific pointer in the struct net_device")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>   net/can/af_can.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/can/af_can.c b/net/can/af_can.c
> index 9503ab10f9b8..ef2697f3ebcb 100644
> --- a/net/can/af_can.c
> +++ b/net/can/af_can.c
> @@ -450,7 +450,7 @@ int can_rx_register(struct net *net, struct net_device *dev, canid_t can_id,
>   
>   	/* insert new receiver  (dev,canid,mask) -> (func,data) */
>   
> -	if (dev && dev->type != ARPHRD_CAN)
> +	if (dev && (dev->type != ARPHRD_CAN || dev->ml_priv_type != ML_PRIV_CAN))
>   		return -ENODEV;
>   
>   	if (dev && !net_eq(net, dev_net(dev)))
