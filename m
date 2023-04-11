Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D27B6DE51C
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 21:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjDKTts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 15:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjDKTts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 15:49:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607AC19AD
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 12:49:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F05FD62465
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 19:49:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B359C433EF;
        Tue, 11 Apr 2023 19:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681242586;
        bh=KHwqZhruzUQmMJcAyzNbufatb1HafS1nawYwY2TE5N4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HFhNSFpt8p4cG6jntP6BK9FTa6Xghm6hMXWvH4wnZinzdEsWO39B7ztreJFtiKvy2
         TJIjxq33eE3Eqn93fUiNaCAvutIQG9/ysS+0xgJPHX2WAoLchkzw+S+6/PHFHBy4bP
         sfWwdjkQwoQnGYuZq6TYZL/BDl9AOFdJo2F+V4i5T4xJs9J46A3OouG9EaJ3Qw1IVj
         9mvIyLUqCM7c9VtfLywYK0QRkvUUyadRDmIdSZ6HuFCB+VaCrQP+q+V08P5CNbb/3L
         BqvbW64Lx/g8Sh0rVkg8zixO/mNqgLJWj0ErHf6LYOhdlvi8hI0CDBD4e2tolZa8Ou
         B0HIrjykEHUpQ==
Date:   Tue, 11 Apr 2023 12:49:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Brett Creeley <bcreeley@amd.com>,
        Brett Creeley <brett.creeley@amd.com>, davem@davemloft.net,
        netdev@vger.kernel.org, drivers@pensando.io,
        shannon.nelson@amd.com, neel.patel@amd.com
Subject: Re: [PATCH net] ionic: Fix allocation of q/cq info structures from
 device local node
Message-ID: <20230411124945.527b0ee4@kernel.org>
In-Reply-To: <20230411124704.GX182481@unreal>
References: <20230407233645.35561-1-brett.creeley@amd.com>
        <20230409105242.GR14869@unreal>
        <bd48d23b-093c-c6d4-86f1-677c2a0ab03c@amd.com>
        <20230411124704.GX182481@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Apr 2023 15:47:04 +0300 Leon Romanovsky wrote:
> > We want to allocate memory from the node local to our PCI device, which is
> > not necessarily the same as the node that the thread is running on where
> > vzalloc() first tries to alloc.  
> 
> I'm not sure about it as you are running kernel thread which is
> triggered directly by device and most likely will run on same node as
> PCI device.

Isn't that true only for bus-side probing?
If you bind/unbind via sysfs does it still try to move to the right
node? Same for resources allocated during ifup?

> > Since it wasn't clear to us that vzalloc_node() does any fallback,   
> 
> vzalloc_node() doesn't do fallback, but vzalloc will find the right node
> for you.

Sounds like we may want a vzalloc_node_with_fallback or some GFP flag?
All the _node() helpers which don't fall back lead to unpleasant code
in the users.

> > we followed the example in the ena driver to follow up with a more
> > generic vzalloc() request.  
> 
> I don't know about ENA implementation, maybe they have right reasons to
> do it, but maybe they don't.
> 
> > 
> > Also, the custom message helps us quickly figure out exactly which
> > allocation failed.  
> 
> If OOM is missing some info to help debug allocation failures, let's add
> it there, but please do not add any custom prints after alloc failures.

+1
