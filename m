Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0FB5BF1F0
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 02:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbiIUA0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 20:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbiIUA0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 20:26:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D78D5AC4A;
        Tue, 20 Sep 2022 17:26:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37DBC6260A;
        Wed, 21 Sep 2022 00:26:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09145C433C1;
        Wed, 21 Sep 2022 00:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663719969;
        bh=kOc9LBTqYjvRnyqiu2NdEtQAsHH6QxXzcA0/fNkr1jA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EkQJNjycvM9XX2NLnWE9bHxfpRrLRzubgoehVa/v1+XWC5VA2tzociUkz/SmqTm6s
         al7FyMeI4EFcYjTPoB04QLDtsZKPfpuMDR2DTHPRwwLAqRIC4Q+8g3OlKyASRLy3h0
         MWbK0PJoFGJXhXAigjdYEGmGVEz/6Dn+TdrXMN4yVkLSTO0h3KXjwqAT2BSJva9eBX
         35fCSVA3XiKJMwLn+j9YqYaHDxrmhpL2mNfeFxfPaTYN5RWP6ak25v0t2TmEP6XGWJ
         Yl0vjMlMSb4H5aFCdvRmh32kx49v0TYjuBL4/sNuPPMTeAx8I0o9ZKJpgyReJ2LEjL
         EcfovXk0an+dw==
Date:   Tue, 20 Sep 2022 17:26:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 7/7] net/sched: taprio: replace safety
 precautions with comments
Message-ID: <20220920172608.5cf6bac1@kernel.org>
In-Reply-To: <20220921001625.jwpr5r5tneyoxect@skbuf>
References: <20220915105046.2404072-1-vladimir.oltean@nxp.com>
        <20220915105046.2404072-8-vladimir.oltean@nxp.com>
        <20220920140119.481f74a3@kernel.org>
        <20220921001625.jwpr5r5tneyoxect@skbuf>
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

On Wed, 21 Sep 2022 00:16:26 +0000 Vladimir Oltean wrote:
> On Tue, Sep 20, 2022 at 02:01:19PM -0700, Jakub Kicinski wrote:
> > Another option is DEBUG_NET_WARN_ON_ONCE() FWIW, you probably know..  
> 
> Just for replacing WARN_ON_ONCE(), yes, maybe, but when you factor in
> that the code also had calls to qdisc_drop(), I suppose you meant
> replacing it with something like this?
> 
> 	if (DEBUG_NET_WARN_ON_ONCE(unlikely(FULL_OFFLOAD_IS_ENABLED(q->flags))))
> 		return qdisc_drop(skb, sch, to_free);
> 
> This won't work because DEBUG_NET_WARN_ON_ONCE() force-casts WARN_ON_ONCE()
> to void, discarding its evaluated value.
> 
> We'd be left with something custom like below:
> 
> 	if (IS_ENABLED(CONFIG_DEBUG_NET) && unlikely(FULL_OFFLOAD_IS_ENABLED(q->flags))) {
> 		WARN_ONCE(1, "Trying to enqueue skb into the root of a taprio qdisc configured with full offload\n");
> 		return qdisc_drop(skb, sch, to_free);
> 	}
> 
> which may work, but it's so odd looking that it's just not worth the
> trouble, I feel?

I meant as a way of retaining the sanity check, a bare:

	DEBUG_NET_WARN_ON_ONCE(FULL_OFFLOAD_IS_ENABLED(q->flags));

no other handling. Not sure how much sense it makes here,
it's best suited as syzbot fodder, perhaps the combination
with offload is pointless.
