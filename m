Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9F014CB627
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 06:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiCCFWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 00:22:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiCCFWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 00:22:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 415791637FE;
        Wed,  2 Mar 2022 21:21:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB406B823AA;
        Thu,  3 Mar 2022 05:21:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15A9C004E1;
        Thu,  3 Mar 2022 05:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646284884;
        bh=QpJA8xs1s3NtV8aEbClD8BQ6uzwMgBrnvimTomtkHjw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=swDDeyTOV3PIAXnPCPH7l7dgtozIokCEu4ffnu5sDkl2NMrCObISCXS6AKqa4x9EN
         qMunvySTWU6dcfeEyP/2Ixretdyylw26joA6j2ALYQeSKD68psdLVd0leqX967s8i/
         pCm+cgr/cxHzSDVUNzZC9mY5hbbCFhAzt65cuoinw8UVcoHjtkgt/RfUNbLLjeamt+
         asvToTju/wKIByt84QMBnSZG77HtIFzhvYMRm1No1DLmzOmuI7S64Bqp4Tl7psdgVW
         W7IA6QnWrXl6/+riMM4BOm0ITB4nbwtsQ6B0xjJ97h+rv40qfZcBrqyWKHK9ktTcLG
         PlDXu9HebD03g==
Date:   Wed, 2 Mar 2022 21:21:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dongli Zhang <dongli.zhang@oracle.com>
Cc:     dsahern@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, edumazet@google.com
Subject: Re: [PATCH net-next v4 4/4] net: tun: track dropped skb via
 kfree_skb_reason()
Message-ID: <20220302212122.7863b690@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <e3bc5ac4-e1db-584c-7219-54a09192a001@oracle.com>
References: <20220226084929.6417-1-dongli.zhang@oracle.com>
        <20220226084929.6417-5-dongli.zhang@oracle.com>
        <20220301185021.7cba195d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <ca81687c-4943-6d58-34f9-fb0a858f6887@oracle.com>
        <20220302111731.00746020@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <e3bc5ac4-e1db-584c-7219-54a09192a001@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Mar 2022 14:21:31 -0800 Dongli Zhang wrote:
> > because of OOM" is what should be reported. What we were trying to
> > allocate is not very relevant (and can be gotten from the stack trace 
> > if needed).  
> 
> I think OOM is not enough. Although it may not be the case in this patchset,
> sometimes the allocation is failed because we are allocating a large chunk of
> physically continuous pages (kmalloc vs. vmalloc) while there is still plenty of
> memory pages available.
> 
> As a kernel developer, it is very significant for me to identify the specific
> line/function and specific data structure that cause the error. E.g, the bug
> filer may be chasing which line is making trouble.
> 
> It is less likely to SKB_TRIM more than once in a driver function, compared to
> ENOMEM.

Nack, trim is meaningless.
