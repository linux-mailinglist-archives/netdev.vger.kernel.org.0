Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E55544CAE1E
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 20:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244841AbiCBTD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 14:03:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244850AbiCBTDz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 14:03:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CAEE4AE09;
        Wed,  2 Mar 2022 11:03:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3E44614C9;
        Wed,  2 Mar 2022 19:03:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9472BC004E1;
        Wed,  2 Mar 2022 19:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646247782;
        bh=o//HJ6BOALyflat2+5/GXiJeuCPk+VlksyaDQu6xvUo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vFrX8MUdmDI0aw/CwGNlWdVxijOAupdHvPGORfc9vfwp7o9C3E1UfWW6zSvKXoVHs
         PZwc4C/SYJZKagYuC8rtAcyj6JvNYd7B0tAs4yMk5FyTjhnVCzloNeiMpnYw1EAwde
         kzFHoX0Lm7lo3yrq6Sd9pQgyinqc6EeWhRw/B2wwP36yEvva87s0wjEPmflAkRRrV3
         LvIfkTTXdyZUJsgAXz0K33lu+ttMODStUdQMmAaNG/ipZn0hh3vABvjaGyMPMTUQsQ
         Qvh3dlPm4WYvjNrexqoPy7FXkQoHZnWZn5UqzaZcyWld0LHiz3vbdyJEKe7MnX3JPI
         xdz7ju2+U5kqA==
Date:   Wed, 2 Mar 2022 11:03:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dongli Zhang <dongli.zhang@oracle.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, dsahern@gmail.com,
        edumazet@google.com
Subject: Re: [PATCH net-next v4 2/4] net: tap: track dropped skb via
 kfree_skb_reason()
Message-ID: <20220302110300.1ac78804@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <0556b706-cb4d-b0b6-ef29-443123afd71d@oracle.com>
References: <20220226084929.6417-1-dongli.zhang@oracle.com>
        <20220226084929.6417-3-dongli.zhang@oracle.com>
        <20220301184209.1f11b350@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <0556b706-cb4d-b0b6-ef29-443123afd71d@oracle.com>
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

On Wed, 2 Mar 2022 09:43:29 -0800 Dongli Zhang wrote:
> On 3/1/22 6:42 PM, Jakub Kicinski wrote:
> > On Sat, 26 Feb 2022 00:49:27 -0800 Dongli Zhang wrote:  
> >> +	SKB_DROP_REASON_SKB_CSUM,	/* sk_buff checksum error */  
> > 
> > Can we spell it out a little more? It sounds like the checksum was
> > incorrect. Will it be clear that computing the checksum failed, rather
> > than checksum validation failed?  
> 
> I am just trying to make the reasons as generic as possible so that:
> 
> 1. We may minimize the number of reasons.
> 
> 2. People may re-use the same reason for all CSUM related issue.

The generic nature is fine, my concern is to clearly differentiate
errors in _validating_ the checksum from errors in _generating_ them.
"sk_buff checksum error" does not explain which one had taken place.

> >> +	SKB_DROP_REASON_SKB_COPY_DATA,	/* failed to copy data from or to
> >> +					 * sk_buff
> >> +					 */  
> > 
> > Here should we specify that it's copying from user space?  
> 
> Same as above. I am minimizing the number of reasons so that any memory copy for
> sk_buff may re-use this reason.

IIUC this failure is equivalent to user passing an invalid buffer. 
I mean something like:

	send(fd, (void *)random(), 1000, 0);

I'd be tempted to call the reason something link SKB_UCOPY_FAULT.
To indicate it's a problem copying from user space. EFAULT is the
typical errno for that. WDYT?

