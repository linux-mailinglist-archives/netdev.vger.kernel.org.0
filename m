Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCFA6BBE28
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 21:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbjCOUvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 16:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjCOUvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 16:51:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF7F1DBA9
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 13:51:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2934BB81F50
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 20:51:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB6DC433EF;
        Wed, 15 Mar 2023 20:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678913507;
        bh=6wk7EL/VLDiKoOgCuSp2NM5Dqx7OExqI/4UBY4KY16U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XNwaPxHc99I+69Mb7kNZZUZgW/fMdzy1wUAMM2ObyX0LtxKqSBPcurPhj5TTQOTrG
         2Xpe8AdBnvhLDbEeef0APILjbic1+naJ7ko7lKoqn4VGU6eaN8FiDHbjDGudz8ZbC3
         pInT5AlcoNPEbY3EZhwbfAEKEGFx1xPUvOF6dmTuxA9oQQKCidUCnBg/KVztO58lUX
         E+XWC79CIb2kMFY/EvV7i1xWjL8i3ZmBn+MVlAW0uLVUmthj6IB4bv0dG8BoeaRs6D
         foVQdbhHUHHcgPWAhNZrMM6cy+fn51uXSqCVbO6cCIp5SjhOOcnyglk5VBw7gpHfNQ
         jyu+UtyUxJqCQ==
Date:   Wed, 15 Mar 2023 13:51:46 -0700
From:   Saeed Mahameed <saeed@kernel.org>
To:     Piotr Raczynski <piotr.raczynski@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Daniel Jurgens <danielj@nvidia.com>
Subject: Re: [net 03/14] net/mlx5: Fix setting ec_function bit in MANAGE_PAGES
Message-ID: <ZBIv4oGgtWbTGkaS@x130>
References: <20230314174940.62221-1-saeed@kernel.org>
 <20230314174940.62221-4-saeed@kernel.org>
 <ZBHD2J8I1WGf9gnB@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ZBHD2J8I1WGf9gnB@nimitz>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15 Mar 14:10, Piotr Raczynski wrote:
>On Tue, Mar 14, 2023 at 10:49:29AM -0700, Saeed Mahameed wrote:
>> From: Parav Pandit <parav@nvidia.com>
>>
>> When ECPF is a page supplier, reclaim pages missed to honor the
>> ec_function bit provided by the firmware. It always used the ec_function
>> to true during driver unload flow for ECPF. This is incorrect.
>>
>> Honor the ec_function bit provided by device during page allocation
>> request event.
>>
>> Fixes: d6945242f45d ("net/mlx5: Hold pages RB tree per VF")
>> Signed-off-by: Parav Pandit <parav@nvidia.com>
>> Signed-off-by: Daniel Jurgens <danielj@nvidia.com>
>> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
>> ---
>>  .../ethernet/mellanox/mlx5/core/pagealloc.c    | 18 ++++++++++++++----
>>  1 file changed, 14 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
>> index 64d4e7125e9b..bd2712b2317d 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
>> @@ -82,6 +82,16 @@ static u16 func_id_to_type(struct mlx5_core_dev *dev, u16 func_id, bool ec_funct
>>  	return func_id <= mlx5_core_max_vfs(dev) ?  MLX5_VF : MLX5_SF;
>>  }
>>
>> +static u32 get_ec_function(u32 function)
>> +{
>> +	return function >> 16;
>> +}
>> +
>> +static u32 get_func_id(u32 function)
>> +{
>> +	return function & 0xffff;
>> +}
>> +
>Some code in this file is mlx5 'namespaced', some is not. It may be a
>little easier to follow the code knowing explicitly whether it is driver
>vs core code, just something to consider.
>

For static local file functions we prefer to avoid mlx5 perfix.

>Other than that, looks fine, thanks.
>Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
>

Thanks!


>>  static struct rb_root *page_root_per_function(struct mlx5_core_dev *dev, u32 >
