Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D936C623EF3
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 10:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiKJJq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 04:46:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiKJJqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 04:46:54 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7940469DFA
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 01:46:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 896C9CE21DA
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 09:46:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88908C433C1;
        Thu, 10 Nov 2022 09:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668073607;
        bh=Rpc3q+QPPfNRnU+8WASadIWA8GHEexHrspY/e/lAWps=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XmkWo/yRyRWwhVbhfdPe+3boA5QHrz9iGX3V1v/PT7nbNRdVQgSpVWQdJkoaQCGmV
         gLCRG03koq7Mn/cjWpgWIJzLE1FlHK3fVg8eLCprHLC9TGEzL9l7ABMue//fJ2zNmG
         VPmbZ4rfPW7Yo868sQy2T28MLlVUbqyspPZH6PPVibWBXVt8NL6Lr2zmd0rmtkLZm5
         /qlsVdjcspzZUau5En1SWB8FMvnON9o3cvZNSYaw9YvPy8K86OKhn7fyjbDVILufU5
         e4cgkj83OjtAFGuvWvwdekF3QWhchQ1Ej7K/EjzfC3PG9ojKhdUXApQiO+cuxasycD
         Me0Jm7XCAt6sQ==
Date:   Thu, 10 Nov 2022 11:46:40 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Yuan Can <yuancan@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mqaio@linux.alibaba.com,
        shaozhengchao@huawei.com, christophe.jaillet@wanadoo.fr,
        gustavoars@kernel.org, luobin9@huawei.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: hinic: Fix error handling in hinic_module_init()
Message-ID: <Y2zIgJblD4I7DOn+@unreal>
References: <20221110021642.80378-1-yuancan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110021642.80378-1-yuancan@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 10, 2022 at 02:16:42AM +0000, Yuan Can wrote:
> A problem about hinic create debugfs failed is triggered with the
> following log given:
> 
>  [  931.419023] debugfs: Directory 'hinic' with parent '/' already present!
> 
> The reason is that hinic_module_init() returns pci_register_driver()
> directly without checking its return value, if pci_register_driver()
> failed, it returns without destroy the newly created debugfs, resulting
> the debugfs of hinic can never be created later.
> 
>  hinic_module_init()
>    hinic_dbg_register_debugfs() # create debugfs directory
>    pci_register_driver()
>      driver_register()
>        bus_add_driver()
>          priv = kzalloc(...) # OOM happened
>    # return without destroy debugfs directory
> 
> Fix by removing debugfs when pci_register_driver() returns error.
> 
> Fixes: 253ac3a97921 ("hinic: add support to query sq info")
> Signed-off-by: Yuan Can <yuancan@huawei.com>
> ---
> Changes in v2:
> - Change to simpler error handling style
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
