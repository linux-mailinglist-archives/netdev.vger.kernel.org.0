Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48B025BC55D
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 11:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiISJaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 05:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiISJaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 05:30:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73BACB7FA
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 02:30:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C365B80B22
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 09:29:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B45C433C1;
        Mon, 19 Sep 2022 09:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663579797;
        bh=cpQSPa+u3DXGZzowMFKHUAwGFlwJBgPxXcdYkDID5dk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pjMjW/B8e0+35XrKjxz7jAR9kdl8XERR0pMjVh8+g2dE9q4Z57gqPPKEBKczC5S4j
         qaXRX6iUME2KLSysu9lGc3DXr7cS5/IJS+OpWaUHjalOoXK1o7ZLK/QwhIYVcN1r+r
         5jTDoHPzVMQs4efxaovOb5BFSChPpnZnyMjucRokhmWMT0WkBkRbsXASGPVIt5eUnP
         aNFqDEO3g5hJCQkRitVuyMJhGtfbbN7D82o0/jG+PmJ4TAIQcd7AtG1171jWiUc1uV
         mT6hAMnCGGc703GJJA/83h2XAUSmnM2q3Sbt2VKzVxtcXKrs38rl9jelU4H6dgD803
         KMUyjCMM8PLZg==
Date:   Mon, 19 Sep 2022 12:29:53 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Bharat Bhushan <bbhushan2@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Are xfrm state_add/delete() calls serialized?
Message-ID: <Yyg2kYNeGxWSCvC4@unreal>
References: <DM5PR1801MB1883E2826A037070B2DD6608E3449@DM5PR1801MB1883.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM5PR1801MB1883E2826A037070B2DD6608E3449@DM5PR1801MB1883.namprd18.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 12, 2022 at 03:10:12PM +0000, Bharat Bhushan wrote:
> Hi All,
> 
> Have a very basic query related to .xdo_dev_state_add()/delete() ops supported by netdev driver. Can .xdo_dev_state_add()/delete() execute from other core while already in process of handling .xdo_dev_state_add()/delete() on one core? Or these calls are always serialized by stack?

It is protected from userspace callers with xfrm_cfg_mutex in xfrm_netlink_rcv().
However, stack triggered deletion can be in parallel. There is a lock
for that specific SA that is going to be deleted, and it is not global.

> Wanted to know if we need proper locking while handling these ops in driver.
> 
> Thanks
> -Bharat 
