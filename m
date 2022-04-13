Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E42D74FFF95
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 21:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237009AbiDMTsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 15:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231436AbiDMTsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 15:48:40 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D0DB7522B;
        Wed, 13 Apr 2022 12:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=TsmPNaK5EhVUCi0QRwL1L+rVvRifceYwNNpMjUTmFq0=; b=lXYjOzxjnKh6D+uV4pVfYNwZfw
        AV/wm5OKcdr/HiD62jqs75O2BX+tPwbixswxvQiEYCTx4dFd+vb7vyAN90uttIl1D7pktWr3EF1gA
        ItUKKvOE1WU0VEvkYyT6xgEGkTLqp0LPY4kD9pZpPcIqOA0Q2wxLiqyBM+Y+DfdCC/h2tQmkyWBEI
        ZH/lj9ssBprW1gAyOL0tg0C0v+GKOTxdRpcD+Lu8Jxd0AXCroDpqEuJ98TaqeXfexY/NWfo+/PVmX
        7NRy787YCNn0MxXHIYwYPEQPRu1oCBV6IaZsVV2YQ5f7Q/IbrUk6KQlqfOWIaWWtbeTW/nj2rSBPl
        5/h+oWIA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1neiwE-002Yz4-F5; Wed, 13 Apr 2022 19:46:02 +0000
Date:   Wed, 13 Apr 2022 12:46:02 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Yan Zhu <zhuyan34@huawei.com>, andrii@kernel.org, ast@kernel.org,
        bpf@vger.kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        keescook@chromium.org, kpsingh@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        liucheng32@huawei.com, netdev@vger.kernel.org,
        nixiaoming@huawei.com, songliubraving@fb.com,
        xiechengliang1@huawei.com, yhs@fb.com, yzaikin@google.com,
        zengweilin@huawei.com, leeyou.li@huawei.com,
        laiyuanyuan.lai@huawei.com
Subject: Re: [PATCH v4 sysctl-next] bpf: move bpf sysctls from
 kernel/sysctl.c to bpf module
Message-ID: <YlcoevXO2t1pn3Pu@bombadil.infradead.org>
References: <Yk4XE/hKGOQs5oq0@bombadil.infradead.org>
 <20220407070759.29506-1-zhuyan34@huawei.com>
 <3a82460b-6f58-6e7e-a3d9-141f42069eda@iogearbox.net>
 <Ylcd0zvHhi96zVi+@bombadil.infradead.org>
 <b615bd44-6bd1-a958-7e3f-dd2ff58931a1@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b615bd44-6bd1-a958-7e3f-dd2ff58931a1@iogearbox.net>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 13, 2022 at 09:40:58PM +0200, Daniel Borkmann wrote:
> On 4/13/22 9:00 PM, Luis Chamberlain wrote:
> > On Wed, Apr 13, 2022 at 04:45:00PM +0200, Daniel Borkmann wrote:
> > > On 4/7/22 9:07 AM, Yan Zhu wrote:
> > > > We're moving sysctls out of kernel/sysctl.c as its a mess. We
> > > > already moved all filesystem sysctls out. And with time the goal is
> > > > to move all sysctls out to their own subsystem/actual user.
> > > > 
> > > > kernel/sysctl.c has grown to an insane mess and its easy to run
> > > > into conflicts with it. The effort to move them out is part of this.
> > > > 
> > > > Signed-off-by: Yan Zhu <zhuyan34@huawei.com>
> > > 
> > > Acked-by: Daniel Borkmann <daniel@iogearbox.net>
> > > 
> > > Given the desire is to route this via sysctl-next and we're not shortly
> > > before but after the merge win, could we get a feature branch for bpf-next
> > > to pull from to avoid conflicts with ongoing development cycle?
> > 
> > Sure thing. So I've never done this sort of thing, so forgive me for
> > being new at it. Would it make sense to merge this change to sysctl-next
> > as-is today and put a frozen branch sysclt-next-bpf to reflect this,
> > which bpf-next can merge. And then sysctl-next just continues to chug on
> > its own? As-is my goal is to keep sysctl-next as immutable as well.
> > 
> > Or is there a better approach you can recommend?
> 
> Are you able to merge the pr/bpf-sysctl branch into your sysctl-next tree?
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/log/?h=pr/bpf-sysctl
> 
> This is based off common base for both trees (3123109284176b1532874591f7c81f3837bbdc17)
> so should only pull in the single commit then.

Yup. That worked just fine. I pushed it.

  Luis
