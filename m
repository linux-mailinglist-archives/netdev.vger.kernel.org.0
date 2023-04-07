Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD4236DAFA9
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 17:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233032AbjDGP2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 11:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbjDGP2V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 11:28:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFEED6A5A
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 08:28:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7852D61E14
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 15:28:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82722C433EF;
        Fri,  7 Apr 2023 15:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680881299;
        bh=LExkG1iuIte8JP7HpdLmhImPG21jrfxw1tnNPMbfg3U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lY6RsyXNxGSMF/lxvBHZii18rO6QyvzIlP15rHpXRz6fkBqZnEbWqPlKGQ6jLhya2
         +g3eJ6bm4c0CG97fTqCwbwbhLNLy5UZlmDOjkBa5mjVZpcxfAr22fpeCgL+DJvA6G4
         +SBB7/z71+uGAAOVctSBb4lu0+k/Ccv20j/Drk+RgHMSoZ+LaQC4Je3yvLUAEVeqW3
         VJzZXFrlH+MslR1EaTayXC3x+iZ3N2pgkfy4opieTmfWrET8zdOAhsQVgr7PIR0kii
         EfjKOYYdjm/FRN08Z9TmOcXuSgNhsrB0Ljatryk+G0byfJ++gcDcYVgCyLgzeMQdGw
         7UJletNGhHlHA==
Date:   Fri, 7 Apr 2023 08:28:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>
Subject: Re: [RFC net-next v2 1/3] net: skb: plumb napi state thru skb
 freeing paths
Message-ID: <20230407082818.1aefb90f@kernel.org>
In-Reply-To: <20230407071402.09fa792f@kernel.org>
References: <20230405232100.103392-1-kuba@kernel.org>
        <20230405232100.103392-2-kuba@kernel.org>
        <2628d71f-ef66-6ea9-61da-6d01c04fbda9@huawei.com>
        <20230407071402.09fa792f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 7 Apr 2023 07:14:02 -0700 Jakub Kicinski wrote:
> > > -static bool skb_pp_recycle(struct sk_buff *skb, void *data)
> > > +static bool skb_pp_recycle(struct sk_buff *skb, void *data, bool in_normal_napi)    
> > 
> > What does *normal* means in 'in_normal_napi'?
> > can we just use in_napi?  
> 
> Technically netpoll also calls NAPI, that's why I threw in the
> "normal". If folks prefer in_napi or some other name I'm more 
> than happy to change. Naming is hard.

Maybe I should rename it to in_softirq ? Or napi_safe ?
Because __kfree_skb_defer() gets called from the Tx side.
And even the Rx deferred free isn't really *in* NAPI.
