Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5408F64411C
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 11:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234135AbiLFKPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 05:15:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234265AbiLFKPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 05:15:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC694E20;
        Tue,  6 Dec 2022 02:15:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 660CB615E7;
        Tue,  6 Dec 2022 10:15:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FB45C433B5;
        Tue,  6 Dec 2022 10:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670321722;
        bh=yO8H2wPz2yiz0jpwZL0JAyUSggS/ugiA1nSilGo2FLo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ottP8oFfj6PnIRGcrO0xqOlKqb/4MQuSUHuBzuMg6Rv2uLY/S6iIV9VQ+jFF3BHsQ
         JVwyhMmkSdLJwhLSG4R8mxcpUFHFc2XhvfXU9kZZ5uHZZueg88GTdsEtNGLcINZ6Qh
         OZ8oxIj6htW0onT76towkUj2K1n6F++qgAa2mvTFFwHv21HOW16jfsEmTC7vLAxlu8
         y2ltdBEDd446gJrlpdqriv6AUs5QEmM8ippKLKVS5Ys0dVohDEYzsn1OLOA2XLa/k6
         GFXd9kP8i2TCriNUTjA4MPXA8N16od3BCgo5u9wlIG2G84DH0KKO8eHyg/05iiEhGk
         WJ6kpiVfIizyg==
Message-ID: <fed09b42-7891-0a5e-3fd9-1ab65d090271@kernel.org>
Date:   Tue, 6 Dec 2022 12:15:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v5 net-next 0/6] net: ethernet: ti: am65-cpsw: Fix set
 channel operation
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, maciej.fijalkowski@intel.com, kuba@kernel.org,
        andrew@lunn.ch, edumazet@google.com, pabeni@redhat.com,
        vigneshr@ti.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221206094419.19478-1-rogerq@kernel.org>
 <Y48T4OduISrVD4HR@unreal>
Content-Language: en-US
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <Y48T4OduISrVD4HR@unreal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/12/2022 12:05, Leon Romanovsky wrote:
> On Tue, Dec 06, 2022 at 11:44:13AM +0200, Roger Quadros wrote:
>> Hi,
>>
>> This contains a critical bug fix for the recently merged suspend/resume
>> support [1] that broke set channel operation. (ethtool -L eth0 tx <n>)
>>
>> As there were 2 dependent patches on top of the offending commit [1]
>> first revert them and then apply them back after the correct fix.
> 
> Why did you chose revert and reapply almost same patch instead of simply
> fixing what is missing?

v1 & 2 of this series were doing that but it was difficult to review.
This is because we are taking a different approach so we have to undo
most of the things done earlier.

It was suggested during review that reverting and fresh patch was better.

cheers,
-roger

> 
> Thanks
> 
>>
>> [1] fd23df72f2be ("net: ethernet: ti: am65-cpsw: Add suspend/resume support")
>>
>> cheers,
>> -roger
>>
>> Changelog:
>>
>> v5:
>> - Change reset failure error code from -EBUSY to -ETIMEDOUT
>>
>> v4:
>> - move am65_cpsw_nuss_ndev_add_tx_napi() earlier to avoid declaration.
>> - print error and error out if soft RESET failed in
>>   am65_cpsw_nuss_ndo_slave_open()
>> - move struct 'am65_cpsw_host *host' where 'common' is defined.
>>
>> v3:
>> - revert offending commit before applying the updated patch.
>> - drop optimization patch to be sent separately.
>>
>> v2:
>> - Fix build warning
>>  drivers/net/ethernet/ti/am65-cpsw-nuss.c:562:13: warning: variable 'tmo' set but not used [-Wunused-but-set-variable]
>>
>> Roger Quadros (6):
>>   Revert "net: ethernet: ti: am65-cpsw: Fix hardware switch mode on
>>     suspend/resume"
>>   Revert "net: ethernet: ti: am65-cpsw: retain PORT_VLAN_REG after
>>     suspend/resume"
>>   Revert "net: ethernet: ti: am65-cpsw: Add suspend/resume support"
>>   net: ethernet: ti: am65-cpsw: Add suspend/resume support
>>   net: ethernet: ti: am65-cpsw: retain PORT_VLAN_REG after
>>     suspend/resume
>>   net: ethernet: ti: am65-cpsw: Fix hardware switch mode on
>>     suspend/resume
>>
>>  drivers/net/ethernet/ti/am65-cpsw-nuss.c | 197 ++++++++++++-----------
>>  1 file changed, 105 insertions(+), 92 deletions(-)
>>
>> -- 
>> 2.17.1
>>
