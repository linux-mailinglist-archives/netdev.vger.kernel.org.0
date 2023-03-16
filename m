Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE8506BC3F4
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 03:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjCPCqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 22:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjCPCqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 22:46:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F9F37F3E;
        Wed, 15 Mar 2023 19:46:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2723F61E4A;
        Thu, 16 Mar 2023 02:46:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750A8C433D2;
        Thu, 16 Mar 2023 02:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678934771;
        bh=kMBj/ONcpCxcvW1/TB95gMmTecyHHCqJAUGwt5LGYx4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JawDYmChR9PXaxBMnVR+ANKv5AAnWjW/3Q5/+0VTC2I3A5hR5qUdtj1p4ceZD1OD2
         drbNEpmXtXXzU0ar6OZ9hdd6HTrHl0qpj2/cD7kuHjUi6zALmgizHhqqDyBLHH+ISZ
         jC1tv4z8V8AZXf57K2rAr1N/eR4mfRdaqHd2aw/1s/7RaEUEKoWmjO3+XzFwBCeMbF
         JqXojEhNcfOt/pmORwyJ28XCvy+W0km0DBn3ZTV5xcOr9zi3RE1uQf8x6whVnANqW2
         un/6QHpL9OgY8gx6s9wQkQ/Nfliv6QNXZFaULU2owoFWOrpvBW97DzvjnjFdkWSiY3
         jnrB/sn5XrtnQ==
Date:   Wed, 15 Mar 2023 19:46:10 -0700
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, saeedm@nvidia.com,
        leon@kernel.org, shayagr@amazon.com, akiyano@amazon.com,
        darinzon@amazon.com, sgoutham@marvell.com,
        lorenzo.bianconi@redhat.com, toke@redhat.com, teknoraver@meta.com,
        ttoukan.linux@gmail.com
Subject: Re: [PATCH net v2 7/8] net/mlx5e: take into account device
 reconfiguration for xdp_features flag
Message-ID: <ZBKC8lxQurwQpj4k@x130>
References: <cover.1678364612.git.lorenzo@kernel.org>
 <16c37367670903e86f863cc8c481100dd4b3a323.1678364613.git.lorenzo@kernel.org>
 <20230315163900.381dd25e@kernel.org>
 <20230315172932.71de01fa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230315172932.71de01fa@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15 Mar 17:29, Jakub Kicinski wrote:
>On Wed, 15 Mar 2023 16:39:00 -0700 Jakub Kicinski wrote:
>> diff --git a/net/core/xdp.c b/net/core/xdp.c
>> index 87e654b7d06c..5722a1fc6e9e 100644
>> --- a/net/core/xdp.c
>> +++ b/net/core/xdp.c
>> @@ -781,6 +781,9 @@ void xdp_set_features_flag(struct net_device *dev, xdp_features_t val)
>>                 return;
>>
>>         dev->xdp_features = val;
>> +
>> +       if (dev->reg_state < NETREG_REGISTERED)
>> +               return;
>>         call_netdevice_notifiers(NETDEV_XDP_FEAT_CHANGE, dev);
>>  }
>>  EXPORT_SYMBOL_GPL(xdp_set_features_flag);
>>
>> ? The notifiers are not needed until the device is actually live.
>
>I think so.. let me send a full patch.

We have an  internal version of a fix, Tariq is finalizing some review
comments and we will be posting it ASAP.

