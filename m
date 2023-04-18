Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D96796E6759
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 16:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbjDROns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 10:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232139AbjDROnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 10:43:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560031025E
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 07:43:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A366615A8
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 14:43:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796BBC4339B;
        Tue, 18 Apr 2023 14:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681829014;
        bh=x1y4gVpN/y5vPUqNb4upHnoH57j1Fxq6+HhwQb4XH2c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XS0k4iE9wb+HQh3vhdk5GCieqzW68SYEqSSth29vmX+oKDoHGWq7Ua5lhpQk0Fn0o
         VRt9yObzcndErI+FHILDYFW6SjF6AmrLEKIKT+nLnihCqRZVIfoM7vkHHaMObz2FsQ
         0rx8jbJ+cyx+6vUhEVv4KZVNHWKHVJbtziUDLOgpvp8yb0pa5Kqvu+rTIAN6acYfEi
         43+ZOd5yrR1aOT7tUDkHkWDXIKudsx1fE/mCFagdeWQSMREG8tOi2vBjODPvFM146Z
         mLC88D3O3PsLo6VQtR7UvAhN1jgU2zk7KhXY5dyzJaVWY/G7JBtek0HrDezoVCgbPM
         zzhcTdd+N7gsw==
Date:   Tue, 18 Apr 2023 07:43:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>,
        Davide Caratti <dcaratti@redhat.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Christoph Paasch <cpaasch@apple.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net] net/sched: sch_fq: fix integer overflow of "credit"
Message-ID: <20230418074333.7d084348@kernel.org>
In-Reply-To: <CANn89iJ0zy6rr4=O3328heYgiBHNcc9hmAHweTFvAW7iZi8QFw@mail.gmail.com>
References: <a5288a1f4b69eb2da3e704d0e1ff082489432d25.1681728988.git.dcaratti@redhat.com>
        <20230417193031.3ab4ee2a@kernel.org>
        <CANn89iJ0zy6rr4=O3328heYgiBHNcc9hmAHweTFvAW7iZi8QFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Apr 2023 12:26:13 +0200 Eric Dumazet wrote:
> > Please set the right policy in fq_policy[] instead.  
> 
> Not sure these policies are available for old kernels (sch_fq was
> added in linux-3.12) ?
> 
> Or have we backported all this infra already on stable kernels ?
> 
> commit d06a09b94c618c96ced584dd4611a888c8856b8d
> Author: Johannes Berg <johannes.berg@intel.com>
> Date:   Thu Apr 30 22:13:08 2020 +0200
> 
>     netlink: extend policy range validation

Good point, Davide, once the policy based fix hits the trees please
send this version of the fix to stable@ for 5.4 and older stable trees.
