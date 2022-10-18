Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF7EA60215A
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 04:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbiJRCoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 22:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231192AbiJRCoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 22:44:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D2139623E
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 19:44:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EFB161363
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 02:44:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90EF7C433C1;
        Tue, 18 Oct 2022 02:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666061046;
        bh=PGvJK2Uq9YbNqzDPQnZHMe7Mi6c/mB4wy/TwI/BGjlk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ebu/2TZLVLsKksNV8jadm/7nk1+CitaxblKaWBqlNEZBTjuJVmEmoq88am8Mm4TyT
         236rHlV1qpYDFv5nuRD0dkZpDBQqaOZLo5YtFGFKfIuPAe6kXwhrhYFdUEv7/YnYj0
         HKnXNLUtdefKuy4C/6NjyZGQ+osTupER9HO1dMbtspAfPV8nkFWtDox1h9YEYKQZBL
         r7UbQjmbUaXusCYUwKWVmuKMu82HLY2iUdvarOSAhr9JT/rlEysPhzVvZ5afnlkT+J
         Le4AsLy6Zvr2LBq1fWx7tYEgec8W8HAGiakCIrOmahKVoJHhpQ1A8x5OFZ6v5L28FK
         iffJBhBll28ZA==
Date:   Mon, 17 Oct 2022 19:44:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?B?w43DsWlnbw==?= Huguet <ihuguet@redhat.com>
Cc:     irusskikh@marvell.com, dbogdanov@marvell.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        Li Liang <liali@redhat.com>
Subject: Re: [PATCH net] atlantic: fix deadlock at aq_nic_stop
Message-ID: <20221017194404.0f841a52@kernel.org>
In-Reply-To: <Y03y/D8WszbjmSwZ@lunn.ch>
References: <20221014103443.138574-1-ihuguet@redhat.com>
        <Y0lSYQ99lBSqk+eH@lunn.ch>
        <CACT4ouct9H+TQ33S=bykygU_Rpb61LMQDYQ1hjEaM=-LxAw9GQ@mail.gmail.com>
        <Y0llmkQqmWLDLm52@lunn.ch>
        <CACT4oudn-sS16O7_+eihVYUqSTqgshbbqMFRBhgxkgytphsN-Q@mail.gmail.com>
        <Y0rNLpmCjHVoO+D1@lunn.ch>
        <CACT4oucrz5gDazdAF3BpEJX8XTRestZjiLAOxSHGAxSqf_o+LQ@mail.gmail.com>
        <Y03y/D8WszbjmSwZ@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Oct 2022 02:27:40 +0200 Andrew Lunn wrote:
> > > Please try to identify what is being protected. If it is driver
> > > internal state, could it be replaced with a driver mutex, rather than
> > > RTNL? Or is it network stack as a whole state, which really does
> > > require RTNL? If so, how do other drivers deal with this problem? Is
> > > it specific to MACSEC? Does MACSEC have a design problem?  
> > 
> > I already considered this possibility but discarded it because, as I
> > say above, everything else is already legitimately protected by
> > rtnl_lock.  
> 
> Did you look at other drivers using MACSEC offload? Is this driver
> unique in having stuff run in a work queue which you need to cancel?
> In fact, it is not limited to MACSEC, it could be any work queue which
> holds RTNL and needs to be cancelled.

FWIW the work APIs return a boolean to tell you if the work was
actually scheduled / canceled, and you can pair that with a reference
count of the netdev to avoid the typical _sync issues.

trigger()
	ASSERT_RTNL();
	if (schedule_work(netdev_priv->bla))
		netdev_hold();

work()
	rtnl_lock();
	if (netif_running())
		do_ya_thing();
	netdev_put();
	rtnl_unlock();

stop()
	ASSERT_RTNL();
	if (cancel_work(bla))
		netdev_put();

I think.
