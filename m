Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDEEB603A86
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 09:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbiJSHUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 03:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiJSHUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 03:20:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54FA64DB3A
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 00:20:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99BA6B82268
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 07:20:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A0BC433C1;
        Wed, 19 Oct 2022 07:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666164041;
        bh=iMkX5GMzmfEzeexZEYxwEVcLkJr48qcUNG/OYxEboB8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L/nAlAfOPcPEKOzIVkvfsJ9WlfiR2ZG6TTYoJD3FCp+56eTeGjc2fLXP3HB4JwuUI
         A1qXV/xV98nnyaYojGizxY4DODYyWq1kHbY5i7GQcqKaGfWvMv1GXmTBhOYGf9buI5
         y5xq5etFZchib/L+tG7wsdtPOa168STG6m27OTZbmW+/pE3gc2HEccsyCVCQhZrfaL
         GOHerMd8EDudYBuMj1goRqKkyiyBzfy04SXxc00Q8k8w2tle+59PT2i31voKzlX613
         qw2hBOPan5fDYYcqbKbysaodemXbY4ZH7ZGFp9jF3cGPZQdA+cixBGVoE6XyslK62Z
         Ut0/0GQNSTkeg==
Date:   Wed, 19 Oct 2022 10:20:36 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, keescook@chromium.org,
        gustavoars@kernel.org, gregkh@linuxfoundation.org, ast@kernel.org,
        peter.chen@kernel.org, bin.chen@corigine.com, luobin9@huawei.com,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
Subject: Re: [PATCH net 3/4] net: hinic: fix the issue of CMDQ memory leaks
Message-ID: <Y0+lRITJ1kPNCY0c@unreal>
References: <20221019024220.376178-1-shaozhengchao@huawei.com>
 <20221019024220.376178-4-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019024220.376178-4-shaozhengchao@huawei.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 19, 2022 at 10:42:19AM +0800, Zhengchao Shao wrote:
> When hinic_set_cmdq_depth() fails in hinic_init_cmdqs(), the cmdq memory is
> not released correctly. Fix it.
> 
> Fixes: 72ef908bb3ff ("hinic: add three net_device_ops of vf")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c | 5 +++++
>  1 file changed, 5 insertions(+)

<...>

> +	cmdq_type = HINIC_CMDQ_SYNC;
> +	for (; cmdq_type < HINIC_MAX_CMDQ_TYPES; cmdq_type++)

Why do you have this "for loops" in all places? There is only one cmdq_type.

Thanks
