Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6787E6B860B
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 00:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbjCMX0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 19:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjCMX0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 19:26:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F5E8637C6;
        Mon, 13 Mar 2023 16:26:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF52761540;
        Mon, 13 Mar 2023 23:26:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CAC9C433EF;
        Mon, 13 Mar 2023 23:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678749991;
        bh=BRsMzWmdaYzlv9qoKKwuQCY+NvMjyv1RPyvv4a7im+c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=M41gYODghzR11LPeFLPynXBhNdgsx1GV5VbR74GS2ydZuoBjhGpvFAhoCRwEM1HBW
         ikufFbE9uUVF/eQXQZ/sM6T1IRG1lPO7V10zk3hzSmglG3eNlKJC3jdEBBSJ2d47Z+
         ZTSKKYw6ubVaSNM1yVeVbk82Pyhj13nr3qkLb+CPu9XgTWEgvAVaJc2HYnqdSgicyk
         mU2vvvoHA/mZ98YxsaIZsIoHOXA1W/q6iqbBFNhC4Oz7H9Ze6RJVwftVczyC8tjJqy
         QsHW8mWSLzWuqjquS98ZmhEXRv8+W2024dOm3MXEEzjQvbZk1ZwfEwnhGT00GmEnjt
         j0LCYnwlYUo+w==
Date:   Mon, 13 Mar 2023 16:26:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zheng Wang <zyytlz.wz@163.com>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hackerzheng666@gmail.com, 1395428693sheep@gmail.com,
        alex000young@gmail.com
Subject: Re: [PATCH net]  net: ethernet: fix use after free bug in
 ns83820_remove_one due to race condition
Message-ID: <20230313162630.225f6a86@kernel.org>
In-Reply-To: <20230309094231.3808770-1-zyytlz.wz@163.com>
References: <20230309094231.3808770-1-zyytlz.wz@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  9 Mar 2023 17:42:31 +0800 Zheng Wang wrote:
> +	cancel_work_sync(&dev->tq_refill);
>  	ns83820_disable_interrupts(dev); /* paranoia */
>  
>  	unregister_netdev(ndev);

Canceling the work before unregister can't work.
Please take a closer look, the work to refill a ring should be
canceled when the ring itself is dismantled. 
