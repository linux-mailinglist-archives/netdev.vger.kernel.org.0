Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7794A51A285
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 16:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351490AbiEDOu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 10:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348352AbiEDOu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 10:50:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 835A520F5F
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 07:47:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C5D361ABC
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 14:47:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34828C385A4;
        Wed,  4 May 2022 14:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651675639;
        bh=PLZXDj27tTjL0KPBU5yjckijQTuSmMtJCHBpBr5Pj1U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GM2UL9fG2R1TBQNIAuwbyydG9PLKizmOgCfBO+5ZShGxuxpr4mpBWG64QJz86poQE
         mcTKXMB9kcN9y7BgNHzyfuoQEr0CBkU5NQYL75YXewPVN2qvLOYO2A5TN7RdkqPff4
         dqkICd2ULPcZi5x21tltXxG4CfObGcQuntUpEFt7G/zHr4Zh4kPEG061H1ZgSgbfmi
         s66swfKqaPtTuCk9YNP/r1D/tUwi6YpEKzjGzLhLwaSZqrRkGbycaDbLBoIynSXwT4
         q2B/jX2YVm4bM8KwnkaqUfWUHLuYTx3pJu8gBKcuQYtLJSruDsJlL8c0pNJpWMDkNG
         TwVFJ5VDVLExw==
Date:   Wed, 4 May 2022 07:47:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net] net/sched: act_pedit: really ensure the skb is
 writable
Message-ID: <20220504074718.146a5724@kernel.org>
In-Reply-To: <cac58f4ead1cac145d5a2005bcd3556851807f86.camel@redhat.com>
References: <6c1230ee0f348230a833f92063ff2f5fbae58b94.1651584976.git.pabeni@redhat.com>
        <7e4682da-6ed6-17cf-8e5a-dff7925aef1d@mojatatu.com>
        <cac58f4ead1cac145d5a2005bcd3556851807f86.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 04 May 2022 10:52:59 +0200 Paolo Abeni wrote:
> On Tue, 2022-05-03 at 16:10 -0400, Jamal Hadi Salim wrote:
> > What was the tc pedit command that triggered this?  
> 
> From the mptcp self-tests, mptcp_join.sh:
> 
> tc -n $ns2 filter add dev ns2eth$i egress \
> 		protocol ip prio 1000 \
> 		handle 42 fw \
> 		action pedit munge offset 148 u8 invert \
> 		pipe csum tcp \
> 		index 100 || exit 1
> 
> It's used to corrupt a packet so that TCP csum is still correct while
> the MPTCP one is not.
> 
> The relevant part is that the touched offset is outside the skb head.
> 
> > Can we add it to tdc tests?  
> 
> What happens in the mptcp self-tests it that an almost simultaneous
> mptcp-level reinjection on another device using the same cloned data
> get unintentionally corrupted and we catch it - when it sporadically
> happens - via the MPTCP mibs.
> 
> While we could add the above pedit command, but I fear that a
> meaningful test for the issue addressed here not fit the tdc
> infrastructure easily.

For testing stuff like this would it be possible to inject packets
with no headers pulled and frags in pages we marked read-only?
We can teach netdevsim to do it.

Obviously not as a pre-requisite for this patch.
