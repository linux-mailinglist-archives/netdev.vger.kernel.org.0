Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA2568CECF
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 06:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbjBGFUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 00:20:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjBGFUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 00:20:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B0771EBF5
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 21:20:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9CF161062
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 05:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A089C433A0;
        Tue,  7 Feb 2023 05:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675747215;
        bh=6pJ4CEBcOFbG5uddoA1TnI0quhTUq4Pev5hNh/7VKXw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lkCkfs8yU/MTy5b0ThDhjkF11JAkYTZNWSWMHRodamuwwpLsqxsjpzGVXkC/jc6xu
         B6DvOZCklEfWU2YDqIgLchBMM3o95Wj0ZWmaRpYAN6zwzc52h3wYO52s7aDsHLgoRi
         uCCNA/uOADjc29mLzW2dKtO75knv2b8o364FGImDKI7wUWGln7BtzcqmhBEuluFagT
         n0ffb7xvTVm9dcBtdEzadSNTmITbDTe3cYGAicrh9FFSxDklYjdmEByjMqt+OkmHVF
         H0Q/OSpIwsMH6ykYa9F/T+RICKeTIO3dQ382KeMBQ2u7sbx4C2kuG/V16ydkE3dcml
         NN+4y4hlcI7Kw==
Date:   Mon, 6 Feb 2023 21:20:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marcelo Leitner <mleitner@redhat.com>
Cc:     Ilya Maximets <i.maximets@ovn.org>, Paul Blakey <paulb@nvidia.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: Re: [PATCH net-next v8 0/7] net/sched: cls_api: Support hardware
 miss to tc action
Message-ID: <20230206212013.7ada7f77@kernel.org>
In-Reply-To: <CALnP8ZaEFnd=N_oFar+8hBF=XukRis92cnW4KBtywxnO4u9=zQ@mail.gmail.com>
References: <20230205154934.22040-1-paulb@nvidia.com>
        <e1e94c51-403a-ebed-28bb-06c5f2d518bc@ovn.org>
        <9d58f6dc-3508-6c10-d5ba-71b768ad2432@nvidia.com>
        <35e2378f-1a9b-9b32-796d-cb1c8c777118@ovn.org>
        <CALnP8ZaEFnd=N_oFar+8hBF=XukRis92cnW4KBtywxnO4u9=zQ@mail.gmail.com>
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

On Mon, 6 Feb 2023 21:03:15 -0800 Marcelo Leitner wrote:
> On Tue, Feb 07, 2023 at 01:20:55AM +0100, Ilya Maximets wrote:
> > On 2/6/23 18:14, Paul Blakey wrote:  
> > > I think its a good idea, and I'm fine with proposing something like this in a
> > > different series, as this isn't a new problem from this series and existed before
> > > it, at least with CT rules.  
> >
> > Hmm, I didn't realize the issue already exists.  
> 
> Maintainers: please give me up to Friday to review this patchset.

No problem, there's a v9 FWIW:

https://lore.kernel.org/all/20230206174403.32733-1-paulb@nvidia.com/
