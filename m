Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC1263427A
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 18:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234194AbiKVRba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 12:31:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233609AbiKVRb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 12:31:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6DA976158;
        Tue, 22 Nov 2022 09:31:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61308617FB;
        Tue, 22 Nov 2022 17:31:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0AEC433C1;
        Tue, 22 Nov 2022 17:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669138286;
        bh=8UBCk1aFjds98RFSFgY4MTnbmw5QfgG8To9lYS+ZhDM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=RRH0pvoQjD3xu/oyiV17c0bwqmbvH5UCloVcM5GILhLduVSU/rHrgiaDMrT/ZmUZ8
         CN6VSOizLrwY2jtJ2pAG2+4eOFS1c/TUv143en4fkVHfxycFuth7sI6oA/iEgx1cY+
         L7wKGbzv5ff9+VrqfP+fKfxh0SrbnLsLEYH9ZqqmoFj8Sb+SYTwhQTjJXBr6Fp822O
         QJQ+n858iqMVtoL4zXwplylq7hFYZ3XQgp87txFCmxa//4vac+DOUK9HGUR6Zf1fEZ
         ML7IqkLADksC23kJ5x64LAg5QCj2aCqejcA9/Cq0gHAhuSPVmU/mKCSbUzB3nnLr5+
         wMLvX0Q1uqpLQ==
Message-ID: <22ecf134-233c-8c17-2c8f-0bc3ad761c76@kernel.org>
Date:   Tue, 22 Nov 2022 19:31:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2 1/4] net: ethernet: ti: am65-cpsw: Fix set channel
 operation
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, vigneshr@ti.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221121142300.9320-1-rogerq@kernel.org>
 <20221121142300.9320-2-rogerq@kernel.org> <Y3wezv4J9NTSU4R3@lunn.ch>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <Y3wezv4J9NTSU4R3@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 22/11/2022 02:58, Andrew Lunn wrote:
> On Mon, Nov 21, 2022 at 04:22:57PM +0200, Roger Quadros wrote:
>> The set channel operation "ethtool -L tx <n>" broke with
>> the recent suspend/resume changes.
>>
>> Revert back to original driver behaviour of not freeing
>> the TX/RX IRQs at am65_cpsw_nuss_common_stop(). We will
>> now free them only on .suspend() as we need to release
>> the DMA channels (as DMA looses context) and re-acquiring
>> them on .resume() may not necessarily give us the same
>> IRQs.
>>
>> Introduce am65_cpsw_nuss_remove_rx_chns() which is similar
>> to am65_cpsw_nuss_remove_tx_chns() and invoke them both in
>> .suspend().
>>
>> At .resume() call am65_cpsw_nuss_init_rx/tx_chns() to
>> acquire the DMA channels.
>>
>> To as IRQs need to be requested after knowing the IRQ
>> numbers, move am65_cpsw_nuss_ndev_add_tx_napi() call to
>> am65_cpsw_nuss_init_tx_chns().
> 
> It is probably easier to review if you first do a revert and then add
> the new code to make suspend/resume work.

Thanks! This will make it much easier to review.

> 
>     Andrew

cheers,
-roger
