Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41C9B5BF830
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 09:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbiIUHuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 03:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiIUHuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 03:50:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E93895C36F
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 00:50:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81BBFB82E4F
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 07:50:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1B6C433D6;
        Wed, 21 Sep 2022 07:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663746600;
        bh=IdavPII6SMmrOQI+nCN//Gn0Zy3iBq1qqfUcNXyapVQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sEeCE8gbJWdqZZ7N+oo9JlsPtqbg3ze1C3/BXw307smJS6LchOkLpwZ776KTG0iuP
         whPYAwCmGffiTLdQD0mYgDSO6v6p46ihwWpHg2Fp2DwfwNiXvVcT5GasjDgUp0aJWg
         1bfz7we5cTR9UB+YJ8oVigVukHdxiiW3dJucq9kWAI1Xef44WuE8eJFxq5UN3i2cj3
         5+54ekgdWMztZ563BQedY1WD0mVb7E+oh6qUUC5REAN8+7RWXEO9J5mi4FIrGaUVXx
         0eI1nUtyaRVf9wjhyGEcW5N36DQUM6+9dqD3MlkGvJrujMq/uHDXSjXxCnFWQSRtv3
         YPNx2RSwmCoXA==
Date:   Wed, 21 Sep 2022 10:49:56 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Bharat Bhushan <bbhushan2@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [EXT] Re: Are xfrm state_add/delete() calls serialized?
Message-ID: <YyrCJLrciWrI5dED@unreal>
References: <DM5PR1801MB1883E2826A037070B2DD6608E3449@DM5PR1801MB1883.namprd18.prod.outlook.com>
 <Yyg2kYNeGxWSCvC4@unreal>
 <DM5PR1801MB18836F4BB4032F8654A35BD2E34F9@DM5PR1801MB1883.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM5PR1801MB18836F4BB4032F8654A35BD2E34F9@DM5PR1801MB1883.namprd18.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 21, 2022 at 05:42:22AM +0000, Bharat Bhushan wrote:
> Please see inline 
> 
> > -----Original Message-----
> > From: Leon Romanovsky <leon@kernel.org>
> > Sent: Monday, September 19, 2022 3:00 PM
> > To: Bharat Bhushan <bbhushan2@marvell.com>
> > Cc: netdev@vger.kernel.org
> > Subject: [EXT] Re: Are xfrm state_add/delete() calls serialized?
> > 
> > External Email
> > 
> > ----------------------------------------------------------------------
> > On Mon, Sep 12, 2022 at 03:10:12PM +0000, Bharat Bhushan wrote:
> > > Hi All,
> > >
> > > Have a very basic query related to .xdo_dev_state_add()/delete() ops
> > supported by netdev driver. Can .xdo_dev_state_add()/delete() execute from
> > other core while already in process of handling .xdo_dev_state_add()/delete()
> > on one core? Or these calls are always serialized by stack?
> > 
> > It is protected from userspace callers with xfrm_cfg_mutex in xfrm_netlink_rcv().
> 
> So all *_state_add() and _state_delete() are serialized from user.
> 
> > However, stack triggered deletion can be in parallel. There is a lock for that
> > specific SA that is going to be deleted, and it is not global.
> 
> Just want to confirm m understanding, xfrm_state->lock is used by stack (example xfrm_timer_handler()) for deletion, but this lock is per SA (not global).
> So _state_delete() of different SA can happen in parallel and also _state_delete() by stack can run in parallel to state addition from user.

Right

> 
> Thanks
> -Bharat
> 
> > 
> > > Wanted to know if we need proper locking while handling these ops in driver.
> > >
> > > Thanks
> > > -Bharat
