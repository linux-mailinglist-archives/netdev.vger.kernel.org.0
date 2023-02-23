Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA9366A094D
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 14:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234245AbjBWNDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 08:03:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232906AbjBWNDm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 08:03:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C04C51FA3;
        Thu, 23 Feb 2023 05:03:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D71CB81A13;
        Thu, 23 Feb 2023 13:03:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 392C1C433D2;
        Thu, 23 Feb 2023 13:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157399;
        bh=3T3zjuJ4D9MS4kWsEp9XXb1UBO6gK0qhHxG1BbhHOE0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Su6iP3jQwjNWfZyDA2MQZG7ScRildoyIKyfy+lhDUhL9i9pr5/6hxbsFGoUH2Ws3V
         rAfMHgyPSKxbvooRaoKbm8AxaXmhIqsNMTRl4UUAzjJ9TH1qWjr5Cnl/iOwEcnl56A
         jJqw+FUaQgXFIuGkyrxQO47kfbDXNxvpF+S5RYoQ=
Date:   Thu, 23 Feb 2023 14:03:17 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Kurt Kanzenbach <kurt@linutronix.de>,
        Sasha Levin <sashal@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH v2 net 2/2] net/sched: taprio: make qdisc_leaf() see the
 per-netdev-queue pfifo child qdiscs
Message-ID: <Y/dkFcqSdLK+jEMK@kroah.com>
References: <20220915100802.2308279-1-vladimir.oltean@nxp.com>
 <20220915100802.2308279-3-vladimir.oltean@nxp.com>
 <874jrdvluv.fsf@kurt>
 <20230222142507.hapqjfhswhlq42ay@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230222142507.hapqjfhswhlq42ay@skbuf>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 22, 2023 at 04:25:07PM +0200, Vladimir Oltean wrote:
> +Greg, Sasha.

Hint, in the future, please cc: stable@vger.kernel.org with stable
kernel requests, I know I don't see stuff that isn't cc:ed there
normally when working on that tree.

> 
> Hi Kurt,
> 
> On Wed, Feb 22, 2023 at 03:03:04PM +0100, Kurt Kanzenbach wrote:
> > This commit was backported to v5.15-LTS which results in NULL pointer
> > dereferences e.g., when attaching an ETF child qdisc to taprio.
> > 
> > From what I can see is, that the issue was reported back then and this
> > commit was reverted [1]. However, the revert didn't make it into
> > v5.15-LTS? Is there a reason for it? I'm testing 5.15.94-rt59 here.
> > 
> > Thanks,
> > Kurt
> > 
> > [1] - https://lore.kernel.org/all/20221004220100.1650558-1-vladimir.oltean@nxp.com/
> 
> You are right; the patchwork-bot clearly says that the revert was
> applied to net.git as commit af7b29b1deaa ("Revert "net/sched: taprio:
> make qdisc_leaf() see the per-netdev-queue pfifo child qdiscs""), but
> the revert never made it to stable.
> 
> OTOH, the original patch did make it to, and still is in, linux-stable.
> I have backport notification emails of the original to 5.4, 5.10, 5.15, 5.19.
> 
> Greg, Sasha, can you please pick up and backport commit af7b29b1deaa
> ("Revert "net/sched: taprio: make qdisc_leaf() see the per-netdev-queue
> pfifo child qdiscs"") to the currently maintained stable kernels?

Now queued up, thanks.

greg k-h
