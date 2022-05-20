Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89C8F52F1EC
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 19:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352361AbiETR4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 13:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352350AbiETR4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 13:56:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 620AD12AF1;
        Fri, 20 May 2022 10:56:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B789B82A71;
        Fri, 20 May 2022 17:56:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99793C385A9;
        Fri, 20 May 2022 17:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653069367;
        bh=BauBZA+9MLuNRUrLD4ooneX0V86w2XtTFlmo3sZ4u5M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bsIQT34R879rJkztp88jzZPm1yV3+sDH8CtK5k37hwj0bW8es4PjPVbgCN63FtsVC
         XYeGuWZeTZYkGyl8fkMA1lTtuW/JfjDkRnoryQbBkwH+QN/B12n1C4BIz34d6DXHZT
         5F/JzkzxTVbNbc/h2bUgm5Fve1HT/6JApyIPeiWjJf8lX2gct3g8Uixny8T6flip31
         8lbW2Of7WVYwEQUP0eoBQu9ZANdRTVLX2YdvxzIvt42vIB5wQsjRFR5dqvOLBmw4Ww
         /ecn/L65tTKlrYGuImpK1zVVU8Pt3facYeWUU29ixzZqErWwioMizf/Z+UOrZiv+fG
         s7CCUvnk0qSVQ==
Date:   Fri, 20 May 2022 10:56:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, pabeni@redhat.com,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH net-next 06/11] netfilter: nf_flow_table: count and
 limit hw offloaded entries
Message-ID: <20220520105606.15fd5133@kernel.org>
In-Reply-To: <YodG+REOiDa2PMUl@salvia>
References: <20220519220206.722153-1-pablo@netfilter.org>
        <20220519220206.722153-7-pablo@netfilter.org>
        <20220519161136.32fdba19@kernel.org>
        <YodG+REOiDa2PMUl@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 May 2022 09:44:57 +0200 Pablo Neira Ayuso wrote:
> > Why a sysctl and not a netlink attr per table or per device?  
> 
> Per-device is not an option, because the flowtable represents a
> compound of devices.
> 
> Moreover, in tc ct act the flowtable is not bound to a device, while
> in netfilter/nf_tables it is.
> 
> tc ct act does not expose flowtables to userspace in any way, they
> internally allocate one flowtable per zone. I assume there os no good
> netlink interface for them.
> 
> For netfilter/nftables, it should be possible to add per-flowtable
> netlink attributes, my plan is to extend the flowtable netlink
> attribute to add a flowtable maximum size.
> 
> This sysctl count and limit hw will just work as a global limit (which
> is optional), my plan is that the upcoming per-flowtable limit will
> just override this global limit.
> 
> I think it is a reasonable tradeoff for the different requirements of
> the flowtable infrastructure users given there are two clients
> currently for this code.

net namespace is a software administrative unit, setting HW offload
limits on it does not compute for me. It's worse than a module param.

Can we go back to the problem statement? It sounds like the device
has limited but unknown capacity and the sysctl is supposed to be set
by the user magically to the right size, preventing HW flow table from
filling up? Did I get it right? If so some form of request flow control
seems like a better idea...
