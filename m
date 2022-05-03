Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 263C55186FE
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 16:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237236AbiECOpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 10:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237177AbiECOpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 10:45:53 -0400
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1595238BF3;
        Tue,  3 May 2022 07:42:21 -0700 (PDT)
Received: from quatroqueijos (unknown [179.93.188.62])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 7208C41086;
        Tue,  3 May 2022 14:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1651588938;
        bh=WaQ0JNIY3E6qz6M1rSXBnKTMF2DlqR4eUvy4J4r2am4=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=ijOMXJnWU++SNSWLAzAavdyw1j2nLnhDcFm0OVDKbBYisjnXO1QFhN6AnsLJrFG46
         GA1wqX8JqExaoEwsIxUkpAPnSwPLcSqPCKYALhGzoAwrmFB41M8ET2UuZtVc80NEq3
         0HhfI3em8wNhEoAdVaAzwXTPlV0ajkyxv0iUks33D3a1vdM6rKww6YMiO36oiEgtG1
         773iTicG0CenmUGGO/AQd60Xv+TEt+u5nzwXjC1WlG5kRGJhQi1OyoOAGOxlJ0Ubwg
         0BBS9f+42ynVyDIXHyQ+e3x43bXSkgxHDZPK4TpJoEpELuhHCKzzYhuSgweDBoXJur
         HKXsi8sbSXqTA==
Date:   Tue, 3 May 2022 11:42:11 -0300
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        davem@davemloft.net, jiri@resnulli.us, xiyou.wangcong@gmail.com,
        jhs@mojatatu.com, vladbu@mellanox.com
Subject: Re: [PATCH 4.9.y] net: sched: prevent UAF on tc_ctl_tfilter when
 temporarily dropping rtnl_lock
Message-ID: <YnE/Q3SwZuG9HQNv@quatroqueijos>
References: <20220502204924.3456590-1-cascardo@canonical.com>
 <YnEy2726cz98I6YC@kroah.com>
 <YnE7AbD1eYTBBVeE@quatroqueijos>
 <YnE7yBTTsJ/9JSjm@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnE7yBTTsJ/9JSjm@kroah.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 03, 2022 at 04:27:20PM +0200, Greg KH wrote:
> On Tue, May 03, 2022 at 11:24:01AM -0300, Thadeu Lima de Souza Cascardo wrote:
> > On Tue, May 03, 2022 at 03:49:15PM +0200, Greg KH wrote:
> > > On Mon, May 02, 2022 at 05:49:24PM -0300, Thadeu Lima de Souza Cascardo wrote:
> > > > When dropping the rtnl_lock for looking up for a module, the device may be
> > > > removed, releasing the qdisc and class memory. Right after trying to load
> > > > the module, cl_ops->put is called, leading to a potential use-after-free.
> > > > 
> > > > Though commit e368fdb61d8e ("net: sched: use Qdisc rcu API instead of
> > > > relying on rtnl lock") fixes this, it involves a lot of refactoring of the
> > > > net/sched/ code, complicating its backport.
> > > 
> > > What about 4.14.y?  We can not take a commit for 4.9.y with it also
> > > being broken in 4.14.y, and yet fixed in 4.19.y, right?  Anyone who
> > > updates from 4.9 to 4.14 will have a regression.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > 4.14.y does not call cl_ops->put (the get/put and class refcount has been done
> > with on 4.14.y). However, on the error path after the lock has been dropped,
> > tcf_chain_put is called. But it does not touch the qdisc, but only the chain
> > and block objects, which cannot be released on a race condition, as far as I
> > was able to investigate.
> 
> So what changed between 4.9 and 4.14 that requires this out-of-tree
> change to 4.9 for the issue?  Shouldn't we backport that change instead
> of this custom one?
> 
> thanks,
> 
> greg k-h

143976ce992f ("net_sched: remove tc class reference counting") removed the call
to cops->put as that reference counting was removed and the get call was
replaced by find.

Backporting it is an alternative fix, but there are more chances of breaking
something else, as it is not a trivial cherry-pick.

Cascardo.
