Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAEA057E97E
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 00:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236686AbiGVWIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 18:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiGVWIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 18:08:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEC3A2316B
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 15:08:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7BDC8B82B1E
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 22:08:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4E7BC341C6;
        Fri, 22 Jul 2022 22:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658527698;
        bh=4Y1LIFbgxz6EhovTkvJt4bF/mE5sWts0Dlfq9mP7atI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GxgB4+tO4CRuQmbkBUgyMNywcuePekWHb88GmOtY9yJIZMpWpN6zkJdVZnbNk6sCM
         dFSkgP1hZKfCCIYsvGckqzgiER20HFQmIDNX2qvViI3UfMs28Qyb6qvH7hxHhSuwMM
         lRiiE4h3lOApU7R+SK7t0NK2fKp6ZfdoZfF5IjjGE3t+Ypr3/J7triKklBg6h/r1ae
         EmsPmGnQyVEtCR5lWyDgtP8q2yfnAg6SRr/2JS6yJ7wG+FZlnLDPhl31YLxRr7jpRC
         3DAErAK5XKPmgm7uoua3QjUcCVPMlckyWFgiBtiVRdrPQqoVB4hTPGSm45N4ZiOJ/0
         W3qkXvsOmT0qQ==
Date:   Fri, 22 Jul 2022 15:08:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net/sched: act_mirred: avoid printout in the
 traffic path
Message-ID: <20220722150816.08349bed@kernel.org>
In-Reply-To: <c2ef23da1d9a4eb62f4e7b7c4540f9bafb553c15.1658420239.git.dcaratti@redhat.com>
References: <c2ef23da1d9a4eb62f4e7b7c4540f9bafb553c15.1658420239.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Jul 2022 18:19:22 +0200 Davide Caratti wrote:
>  			if (tcf_mirred_dev_dereference(m) == dev) {
> +				pr_notice("tc mirred: target device %s is %s\n",
> +					  dev->name,
> +					  event == NETDEV_UNREGISTER ? "gone" : "down");

Should we only do this print only once per event as well?
There can be a large number of actions redirecting to a single device,
no point printing the warning multiple times for one down event.
