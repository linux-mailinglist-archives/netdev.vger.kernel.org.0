Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBAED6338E9
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 10:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233376AbiKVJrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 04:47:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233083AbiKVJrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 04:47:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B258414007;
        Tue, 22 Nov 2022 01:47:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F049615F8;
        Tue, 22 Nov 2022 09:47:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E5DEC433C1;
        Tue, 22 Nov 2022 09:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669110432;
        bh=UL5MzjRuYkiwDfixp0yElsuBzd8ef1l5k+fEAa+oJwM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EjRz0hp02xXIJwqJ0Kt2F7rWj+ZUVG4GmRJ8wdWkExkqrjSwOl84CUYYRumgzuXMO
         WVYtwQaLxsSfJNClEbWgoGlkRzWFpvJ6vfWWQ6wBRXvuAyrITOJ4xWnFHLZc45jGgq
         XKlE0lHiV+0KCCgb+JFR42CYU1DJpDpTy2AIMUTViIAzZ9Vah/yNewiqzLdiVovigZ
         w2IKdAaKwvKm2TUfxNCyh8cAEur7ZweaDeVYIOqzgOQDP7qhxb7BkGG9g0eDv6jiy+
         L3oB8M3t8XxHTb83A0+ZHzfEU5ZflgXOvNk89DT6rYOmf+rLGzlu3ax0VTS7ofstiM
         4X1co1K+vXtAQ==
Date:   Tue, 22 Nov 2022 11:47:09 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] sfc: fix potential memleak in
 __ef100_hard_start_xmit()
Message-ID: <Y3yanROxeZDR+aNG@unreal>
References: <1668671409-10909-1-git-send-email-zhangchangzhong@huawei.com>
 <Y3YctdnKDDvikQcl@unreal>
 <efedaa0e-33ce-24c6-bb9d-8f9b5c4a1c38@huawei.com>
 <Y3YxlxPIiw43QiKE@unreal>
 <Y3dNP6iEj2YyEwqJ@gmail.com>
 <Y3e8wEZme3OpMZKV@unreal>
 <0a568e890497f4066128b1ce957904e0c5540c16.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a568e890497f4066128b1ce957904e0c5540c16.camel@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 09:28:42AM +0100, Paolo Abeni wrote:
> Hello,
> 
> On Fri, 2022-11-18 at 19:11 +0200, Leon Romanovsky wrote:
> > On Fri, Nov 18, 2022 at 09:15:43AM +0000, Martin Habets wrote:
> > > On Thu, Nov 17, 2022 at 03:05:27PM +0200, Leon Romanovsky wrote:
> > > > Please take a look __ef100_enqueue_skb() and see if it frees SKB on
> > > > error or not. If not, please fix it.
> > > 
> > > That function looks ok to me, but I appreciate the extra eyes on it.
> > 
> > __ef100_enqueue_skb() has the following check in error path:
> > 
> >   498 err:
> >   499         efx_enqueue_unwind(tx_queue, old_insert_count);
> >   500         if (!IS_ERR_OR_NULL(skb))
> >   501                 dev_kfree_skb_any(skb);
> >   502
> > 
> > The issue is that skb is never error or null here and this "if" is
> > actually always true and can be deleted.
> 
> I think that such additional change could be suite for a different net-
> next patch, while this -net patch could land as is, @Leon: do you
> agree?
> 

Sure, thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
