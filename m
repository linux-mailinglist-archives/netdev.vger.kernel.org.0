Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF95E63B987
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 06:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235160AbiK2FpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 00:45:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbiK2FpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 00:45:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC1CC27DD7
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 21:45:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 587D36157D
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 05:45:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84097C433C1;
        Tue, 29 Nov 2022 05:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669700699;
        bh=Myz6cDV+o1Ls8oQQ7aroIQ8IxIS+lYFGPFPLM+ONzBc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fGEJFDug/YLZk78NU4lcKnUUaQyB39Bm0+JE8vXWdrAclZGJtkYLrtaRLTErcOLDP
         tanphs+66+GsEDZxnFvnbGEJMnE30yHZoxsvZf7rNee1gxC9ejRLoGatAOTvzSbG78
         JPAqHnjPUUHxEmSMVpOZQXZDB32gdTCBz9m2M0UbjS4kaZr/+D+jqAVqDROyzDTmtF
         lgIjJ5ZLQl82DYjTF0IF0xLpwSflZdeVthMQ4xREDnzW86ZkXeJQyqX/FOvPuQVIiX
         0bHHHD7VC9ugykEUFcrOMw+mgLtTfY+9ZNrlQWDyR3xFLx6EGh1DxGnHF7ughRsxqV
         9dtpuu+E/Y9nA==
Date:   Mon, 28 Nov 2022 21:44:57 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>, Raed Salem <raeds@nvidia.com>
Subject: Re: [net 13/15] net/mlx5e: MACsec, remove replay window size
 limitation in offload path
Message-ID: <Y4WcWaVbNptkQiEL@fedora>
References: <20221124081040.171790-1-saeed@kernel.org>
 <20221124081040.171790-14-saeed@kernel.org>
 <4bc41493-f837-6536-5f10-7359cf082756@intel.com>
 <20221128193553.0e694508@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221128193553.0e694508@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28 Nov 19:35, Jakub Kicinski wrote:
>On Mon, 28 Nov 2022 15:42:19 -0800 Jacob Keller wrote:
>> > index c19581f1f733..72f8be65fa90 100644
>> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
>> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
>> > @@ -229,22 +229,6 @@ static int macsec_set_replay_protection(struct mlx5_macsec_obj_attrs *attrs, voi
>> >   	if (!attrs->replay_protect)
>> >   		return 0;
>> >
>> > -	switch (attrs->replay_window) {
>> > -	case 256:
>> > -		window_sz = MLX5_MACSEC_ASO_REPLAY_WIN_256BIT;
>> > -		break;
>> > -	case 128:
>> > -		window_sz = MLX5_MACSEC_ASO_REPLAY_WIN_128BIT;
>> > -		break;
>> > -	case 64:
>> > -		window_sz = MLX5_MACSEC_ASO_REPLAY_WIN_64BIT;
>> > -		break;
>> > -	case 32:
>> > -		window_sz = MLX5_MACSEC_ASO_REPLAY_WIN_32BIT;
>> > -		break;
>> > -	default:
>> > -		return -EINVAL;
>> > -	}
>>
>> What sets window_sz now? Looking at the current code wouldn't this leave
>> window_sz uninitialized and this undefined behavior of MLX5_SET? Either
>> you should just forward in attrs->replay_window and remove window_sz
>> local or drop the MLX5_SET call for setting window size?
>
>Damn it, this is a clang warning, I need to rescind the PR :/

Make sense, Jacob found two real issues and this one is critical,
but I don't know how that works for PRs, let me know when you do it so I
will add his reviewed-by tags and address the two issues when is send v2.

another option is that i am currently working on my next PR for net, I can
address those two issues there, but we won't have Jacobs reviewed-by for
the work he already done on this series :/ .. 

Thanks.


