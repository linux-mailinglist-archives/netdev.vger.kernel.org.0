Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DADC9663F15
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 12:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232969AbjAJLMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 06:12:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233194AbjAJLLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 06:11:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BBDD1583C;
        Tue, 10 Jan 2023 03:11:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12308615E1;
        Tue, 10 Jan 2023 11:11:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF4F8C433D2;
        Tue, 10 Jan 2023 11:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673349099;
        bh=8cN4Br15XlXNlsj7EXzb4jkI/RpDLhUFi9ylXgLyakQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QOcxtjh7Qojg4D3UoH7XNHMGW5mbX2Fec056qGx5aQE2yTxk+Z7eNYKLTwfW6jou5
         moX/OyiQTykiD5BPdS5DhmssBXTf9Xk706TiK0y+dfC9atb6tqWO9NMFV2BGBwZwfh
         m5ULBAQ37QZxcGNH7iZ89YBSRx7J0XW03iP2FB5BVxCvWYr1sZbEu1yMRdBhmnj59E
         vVS1CTLygownMOq/vaID9387jjYfDasoIgSPc+GkeKi0GSx7z5oguutjvQpRa7R5ET
         wdmpRqTSKUWB278WEDtjdd7ILZRUaVUXizCF1DrewAVhfKmWYve1NHcVgMo9sEanSs
         7VdhFJ7JeSqtg==
Date:   Tue, 10 Jan 2023 13:11:34 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Hariprasad Kelam <hkelam@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, sgoutham@marvell.com, gakula@marvell.com,
        sbhatta@marvell.com
Subject: Re: [net PATCH] octeontx2-pf: Fix resource leakage in VF driver
 unbind
Message-ID: <Y71H5ub5K+9GlGTm@unreal>
References: <20230109061325.21395-1-hkelam@marvell.com>
 <167334601536.23804.3249818012090319433.git-patchwork-notify@kernel.org>
 <Y7098K4iMjPyAWww@unreal>
 <79108835e679706d138afc33a19a96ed4a1f71ea.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79108835e679706d138afc33a19a96ed4a1f71ea.camel@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 10, 2023 at 11:43:28AM +0100, Paolo Abeni wrote:
> Hello,
> 
> On Tue, 2023-01-10 at 12:29 +0200, Leon Romanovsky wrote:
> > On Tue, Jan 10, 2023 at 10:20:15AM +0000, patchwork-bot+netdevbpf@kernel.org wrote:
> > > Hello:
> > > 
> > > This patch was applied to netdev/net.git (master)
> > > by Paolo Abeni <pabeni@redhat.com>:
> > > 
> > > On Mon, 9 Jan 2023 11:43:25 +0530 you wrote:
> > > > resources allocated like mcam entries to support the Ntuple feature
> > > > and hash tables for the tc feature are not getting freed in driver
> > > > unbind. This patch fixes the issue.
> > > > 
> > > > Fixes: 2da489432747 ("octeontx2-pf: devlink params support to set mcam entry count")
> > > > Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> > > > Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> > > > 
> > > > [...]
> > > 
> > > Here is the summary with links:
> > >   - [net] octeontx2-pf: Fix resource leakage in VF driver unbind
> > >     https://git.kernel.org/netdev/net/c/53da7aec3298
> > 
> > I don't think that this patch should be applied.
> > 
> > It looks like wrong Fixes to me and I don't see clearly how structures
> > were allocated on VF which were cleared in this patch.
> 
> My understanding is that the resource allocation happens via:
> 
> otx2_dl_mcam_count_set()
> 
> which is registered as the devlink parameter write operation on the vf
> by the fixes commit - the patch looks legit to me.
> 
> Did I miss something?

No, you are right. I'm not sure if I would be able to see that OTX2_FLAG_MCAM_ENTRIES_ALLOC
flag without your hint.

Thanks
