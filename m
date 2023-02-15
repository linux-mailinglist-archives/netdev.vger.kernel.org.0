Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4691B69849C
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 20:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbjBOTli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 14:41:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjBOTli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 14:41:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 568B83B657
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 11:41:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1465B821C3
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 19:41:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D68C433D2;
        Wed, 15 Feb 2023 19:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676490094;
        bh=Rf0W4X9oogQzMrnlc1RECfwCL+hEsmqRsGmeIzCEmqo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KBLygs9LQ9yiJeu7aeLooLRYfBGgXn3rSAbjklGX8EipsO1Hoji81XZC9z71yjocl
         pyjsixSDKGAa5wuLKb5PtjQT9rH4NiN+C6bgK6v0FE408uUo0wiCnEvePtjTk08uvE
         FHz1g39IfxKD7isansyIAR+QGun5em6D9Nt8MP3+aQnhnF1hIxNJ92D+hdoTea14+C
         eg2SCed4jyddSLdwqMdL7Feqcg3zIHQSExLJBDvMXfuY5PFo0Y7K57WznzPoWLVACI
         N0SuZOc47kvHJLkxPj+49i033bANj7eo1OQRgjL5b2Cd4bbb1AALlnfqoOQMopLXXU
         hk4JtvFmW5QHQ==
Date:   Wed, 15 Feb 2023 11:41:33 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: Re: [net-next 01/15] net/mlx5: Lag, Let user configure multiport
 eswitch
Message-ID: <Y+01bfkEKwBgu3Gy@x130>
References: <20230210221821.271571-1-saeed@kernel.org>
 <20230210221821.271571-2-saeed@kernel.org>
 <23c46b99-1fbf-0155-b2d0-2ea3d1fe9d17@intel.com>
 <Y+zGFVZPj2UzY0K2@unreal>
 <b8dbd338-e2d0-5173-3186-4f92d7d52f40@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <b8dbd338-e2d0-5173-3186-4f92d7d52f40@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15 Feb 18:04, Alexander Lobakin wrote:
>From: Leon Romanovsky <leon@kernel.org>
>Date: Wed, 15 Feb 2023 13:46:29 +0200
>
>> On Tue, Feb 14, 2023 at 06:07:54PM +0100, Alexander Lobakin wrote:
>>> From: Saeed Mahameed <saeed@kernel.org>
>>> Date: Fri, 10 Feb 2023 14:18:07 -0800
>
>[...]
>
>>> How about
>>>
>>> 	if (ctx->val.vbool)
>>> 		return mlx5_lag_mpesw_enable(dev);
>>> 	else
>>> 		mlx5_lag_mpesw_disable(dev);
>>>
>>> 	return 0;
>>
>> If such construction is used, there won't need in "else".
>>
>>  	if (ctx->val.vbool)
>>  		return mlx5_lag_mpesw_enable(dev);
>>
>>  	mlx5_lag_mpesw_disable(dev);
>>  	return 0;
>

Thanks, this is exactly what I did when posting V2.

>Correct, I just thought that if-else would look more intuitive here
>since it's a simple "if enabled enable else disable".
>
>[...]
>
>Thanks,
>Olek
