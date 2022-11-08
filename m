Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B73B86207D9
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 04:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232381AbiKHDzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 22:55:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232270AbiKHDza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 22:55:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8893813FB1
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 19:55:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2256D6140B
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 03:55:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00169C433D6;
        Tue,  8 Nov 2022 03:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667879728;
        bh=jfSoGwo546XyLcE1uccBGS6De2TD0dAjfZXKPspZBdw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aGhgILqCEVDt6EWAqsWWrysxlK7H3uEVANEME1KqxgLcyUWVKiSULyjZEfKMDrru6
         nUqYggNQAFBr9K4aqvyBpj2ZwL9hUtJsIxx2c1xsLgORGt/XJSYbI7Tyc2cnxR3woq
         N9IDKbzXcrFUnNnxyC3YD00hIXyPi9Y01dcJekwb6Fj170uYm1dmxnP0jCf7c7yqbC
         9G6cZMjSu/2e0jpdqsw3AuUhSJOUsjvhbFWzJEm9DPyLQUpJ/0r2kaGYIZAP1kHvjV
         5MhhTVlY4lQnetAICBBGWGrKVYTaaxBlBTHhWaXCAFqYvsNVA6PD3wz+H1Q7hUhTVY
         lRPbM88bxF7ag==
Date:   Mon, 7 Nov 2022 19:55:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "Ruhl, Michael J" <michael.j.ruhl@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        Kees Cook <keescook@chromium.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "G, GurucharanX" <gurucharanx.g@intel.com>
Subject: Re: [PATCH net-next 5/6] igb: Do not free q_vector unless new one
 was allocated
Message-ID: <20221107195526.5ef1262e@kernel.org>
In-Reply-To: <c051fa25-6047-0efb-7049-be08f566d1fb@intel.com>
References: <20221104205414.2354973-1-anthony.l.nguyen@intel.com>
        <20221104205414.2354973-6-anthony.l.nguyen@intel.com>
        <Y2itqqGQm6uZ/2Wf@unreal>
        <DM5PR11MB1324FDF4D4399A6A99727B5EC13C9@DM5PR11MB1324.namprd11.prod.outlook.com>
        <Y2lEK4CMdCyEMBLf@unreal>
        <c051fa25-6047-0efb-7049-be08f566d1fb@intel.com>
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

On Mon, 7 Nov 2022 10:35:14 -0800 Jacob Keller wrote:
> > I understand the issue what you are trying to solve, I just don't
> > understand your RCU code. I would expect calls to rcu_dereference()
> > in order to get q_vector and rcu_assign_pointer() to clear
> > adapter->q_vector[v_idx], but igb has none.
> 
> the uses of kfree_rcu were introduced by 5536d2102a2d ("igb: Combine 
> q_vector and ring allocation into a single function")
> 
> The commit doesn't mention switching from kfree to kfree_rcu and I 
> suspect that the igb driver is not actually really using RCU semantics 
> properly.
> 
> The closest explanation is that the get_stats64 function might be 
> accessing the ring and thus needs the RCU grace period.. but I think 
> you're right in that we're missing the necessary RCU access macros.

Alright, expecting a follow up for this.
