Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4F7A6055BC
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 05:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbiJTDEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 23:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiJTDEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 23:04:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E599FDDA;
        Wed, 19 Oct 2022 20:04:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BF3EB8264A;
        Thu, 20 Oct 2022 03:04:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DDDBC433D6;
        Thu, 20 Oct 2022 03:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666235060;
        bh=OBbPh3uuOP84WsLDpOq6PnPUi4rGs/kimwF5mglmUNE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mKGgw3O4VQFvQM2V9wntuEFr60/7HP602gYW3NSZ5+K60G0ukvwNUpXEf96bixLp6
         xnqTPM48Klh35EiPRaYV9DREN0upjpleSCTsEYDJn2PcyyPqV63UQ+F7JZMl8jMqFf
         k2zeyrrRKmz9YylbSe6ALa/IDXxKRoNpYG4lOG8q7J6NxheGwAVy082D/Aca1MqaTX
         8QhPgtcoZowNHhNc9pOo6gaTCH/I2XfPMOZDj2T1ifKmGybi870zvD+1LMJmwV5/xi
         dRqeBPwCum+noCjvU5eZJW5HvtjUC1Tw8RprfTstEDx9sfeEiCscQqywDfYnbmoWXF
         qNkzqHPrDp56Q==
Date:   Wed, 19 Oct 2022 20:04:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     syzbot <syzbot+81c4b4bbba6eea2cfcae@syzkaller.appspotmail.com>,
        andrew@lunn.ch, bagasdotme@gmail.com, davem@davemloft.net,
        edumazet@google.com, linux-kernel@vger.kernel.org,
        linux@rempel-privat.de, lkp@intel.com, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] general protection fault in pse_prepare_data
Message-ID: <20221019200419.45f2c063@kernel.org>
In-Reply-To: <CADvbK_cXfDVFJ-eo-+uqXXPT1Xt7qf4bg0Cu6U5Zg7TCLeqoUw@mail.gmail.com>
References: <00000000000044139d05eb617b1c@google.com>
        <20221019153018.2ca0580d@kernel.org>
        <CADvbK_cXfDVFJ-eo-+uqXXPT1Xt7qf4bg0Cu6U5Zg7TCLeqoUw@mail.gmail.com>
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

On Wed, 19 Oct 2022 22:25:47 -0400 Xin Long wrote:
> > Yeah, looking at ethtool internals - info can be NULL :(  
> It seems that eeprom_prepare_data() doesn't check info before
> accessing info->extack either.

Good catch, looks like that one dumps as well!

Perhaps we should require netdevsim support for all new commands 
going forward :S Otherwise this code is hard for syzbot to exercise.
