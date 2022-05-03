Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E13E65186A3
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 16:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237066AbiECOa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 10:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237037AbiECOay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 10:30:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A5B31910;
        Tue,  3 May 2022 07:27:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37F2F61642;
        Tue,  3 May 2022 14:27:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83BB8C385AF;
        Tue,  3 May 2022 14:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651588041;
        bh=U+dMHz9mvZ+8O5RCxWHI4ioZs1g/R3YqAm9YLjXH3ro=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mTXUNdmNQF+WbQNc3W/k1ZcRihhHAhTSm7iTwc50NKSMC26QDAGtnHgmPnlwXMMWj
         XEbBNsePgD8bnHbEsWxAubNb5jcmiTCWrFfEsmpsnZVki+YRAKjE794FoiBQj5XiwM
         wUyMH1tPCJqfSa7udZg/xk87sWL3sXQC+zQ2Ip+c=
Date:   Tue, 3 May 2022 16:27:20 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     stable@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        davem@davemloft.net, jiri@resnulli.us, xiyou.wangcong@gmail.com,
        jhs@mojatatu.com, vladbu@mellanox.com
Subject: Re: [PATCH 4.9.y] net: sched: prevent UAF on tc_ctl_tfilter when
 temporarily dropping rtnl_lock
Message-ID: <YnE7yBTTsJ/9JSjm@kroah.com>
References: <20220502204924.3456590-1-cascardo@canonical.com>
 <YnEy2726cz98I6YC@kroah.com>
 <YnE7AbD1eYTBBVeE@quatroqueijos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnE7AbD1eYTBBVeE@quatroqueijos>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 03, 2022 at 11:24:01AM -0300, Thadeu Lima de Souza Cascardo wrote:
> On Tue, May 03, 2022 at 03:49:15PM +0200, Greg KH wrote:
> > On Mon, May 02, 2022 at 05:49:24PM -0300, Thadeu Lima de Souza Cascardo wrote:
> > > When dropping the rtnl_lock for looking up for a module, the device may be
> > > removed, releasing the qdisc and class memory. Right after trying to load
> > > the module, cl_ops->put is called, leading to a potential use-after-free.
> > > 
> > > Though commit e368fdb61d8e ("net: sched: use Qdisc rcu API instead of
> > > relying on rtnl lock") fixes this, it involves a lot of refactoring of the
> > > net/sched/ code, complicating its backport.
> > 
> > What about 4.14.y?  We can not take a commit for 4.9.y with it also
> > being broken in 4.14.y, and yet fixed in 4.19.y, right?  Anyone who
> > updates from 4.9 to 4.14 will have a regression.
> > 
> > thanks,
> > 
> > greg k-h
> 
> 4.14.y does not call cl_ops->put (the get/put and class refcount has been done
> with on 4.14.y). However, on the error path after the lock has been dropped,
> tcf_chain_put is called. But it does not touch the qdisc, but only the chain
> and block objects, which cannot be released on a race condition, as far as I
> was able to investigate.

So what changed between 4.9 and 4.14 that requires this out-of-tree
change to 4.9 for the issue?  Shouldn't we backport that change instead
of this custom one?

thanks,

greg k-h
