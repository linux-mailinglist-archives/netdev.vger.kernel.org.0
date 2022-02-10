Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B94E4B02C0
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 03:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234573AbiBJB7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 20:59:22 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:34084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233109AbiBJB7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 20:59:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93CA528A
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 17:56:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D3F7B823F1
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 01:56:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8A7EC340E7;
        Thu, 10 Feb 2022 01:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644458160;
        bh=P6o53v+rtsbLlBvwkvt4Q7DDX0NIe2YFtAMBxLpgkl8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X3Q8MPRp/JcoyPmgyYNdaX0cb3QgYB/7xaPJHL+pRnTDx9po++JLqXgZk3TGK2oYC
         5OAw4I4RttQ/PJgwzGDSgTTkiqr4sDA4CE7LLmfIbKTtPlUKoLuc8m8zk7SRL2CTHO
         IYjuyKH7LkNyI9amz1NSWNTbb33TVjoPGP8ZVmeqvfNQsEO/PBQtyzfQ+EcX4S1Nql
         zCoPAxLWMYFiPvzIa6G4FEEhD0Ea5VVAniCZiWwkGJdwym+wWY5ZslpQYLQRzEAcVo
         FMtcQsLkg3gBC0TgWbzW220L5o2pFL1Jwvv9Ub6tnLhRWnu/efZPdJRgtCh4NzBDmf
         1d1EVf4byqEng==
Date:   Wed, 9 Feb 2022 17:55:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        Eric Dumazet <edumazet@google.com>,
        Ziyang Xuan <william.xuanziyang@huawei.com>
Subject: Re: [PATCH net 2/2] vlan: move dev_put into vlan_dev_uninit
Message-ID: <20220209175558.3117342d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <76c52badfdccaa7f094d959eaf24f422ae09dec6.1644394642.git.lucien.xin@gmail.com>
References: <cover.1644394642.git.lucien.xin@gmail.com>
        <76c52badfdccaa7f094d959eaf24f422ae09dec6.1644394642.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Feb 2022 03:19:56 -0500 Xin Long wrote:
> Shuang Li reported an QinQ issue by simply doing:
> 
>   # ip link add dummy0 type dummy
>   # ip link add link dummy0 name dummy0.1 type vlan id 1
>   # ip link add link dummy0.1 name dummy0.1.2 type vlan id 2
>   # rmmod 8021q
> 
>  unregister_netdevice: waiting for dummy0.1 to become free. Usage count = 1

How about we put this in a selftest under tools/testing/selftests/net/
or tools/testing/selftests/drivers/net/ ?

> When rmmods 8021q, all vlan devs are deleted from their real_dev's vlan grp
> and added into list_kill by unregister_vlan_dev(). dummy0.1 is unregistered
> before dummy0.1.2, as it's using for_each_netdev() in __rtnl_kill_links().
> 
> When unregisters dummy0.1, dummy0.1.2 is not unregistered in the event of
> NETDEV_UNREGISTER, as it's been deleted from dummy0.1's vlan grp. However,
> due to dummy0.1.2 still holding dummy0.1, dummy0.1 will keep waiting in
> netdev_wait_allrefs(), while dummy0.1.2 will never get unregistered and
> release dummy0.1, as it delays dev_put until calling dev->priv_destructor,
> vlan_dev_free().
> 
> This issue was introduced by Commit 563bcbae3ba2 ("net: vlan: fix a UAF in
> vlan_dev_real_dev()"), and this patch is to fix it by moving dev_put() into
> vlan_dev_uninit(), which is called after NETDEV_UNREGISTER event but before
> netdev_wait_allrefs().
> 
> Fixes: 563bcbae3ba2 ("net: vlan: fix a UAF in vlan_dev_real_dev()")

As far as I understand this is pretty much a revert of the previous fix.
Note that netdevice_event_work_handler() as seen in the backtrace in the
commit message of the fix in question is called from a workqueue, so the
ordering of netdev notifications saves us from nothing here. We can't
start freeing state until all refs are gone.

I think better fix would be to rewrite netdev_run_todo() to free the
netdevs in any order they become ready. That's gonna solve any
dependency problems and may even speed things up.

