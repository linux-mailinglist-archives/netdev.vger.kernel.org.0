Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5D864CE42
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 17:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238676AbiLNQoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 11:44:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiLNQoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 11:44:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B21E17A91
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 08:44:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4364B819A0
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 16:44:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49221C433EF;
        Wed, 14 Dec 2022 16:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671036239;
        bh=ZNjmKq9IyCYV0fKpfk7E3ofoJDHFiJl30HiMC3UduSM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=riNDDX6T5N7CChBiStbw/nY9jhUq+T7Rjx5557hGw2oV/KlFI1t1v2C27qo095Zgl
         xX4PYa7BSWTR5fGI0ga16TDBGVSYF1doHuRZtNZA/zb5Md/jGdk0fYw3tD51Chggax
         KQFTj5i4lXtzf3y3C9hKch7U//GuMTlIX+5GzAYE5PPsgFxyUsT0ydlTvlg0/mTpp5
         aZNxuLDn+oyHlRmpyo/X2RkdyYvvcmaFrkw64U6cjhMkmlPtqS2o6MfIvUg42zk4JL
         7Et8IoEei/+ipGhRpYN5iOGBZKk/+/X2Ru92RZM3G4U2YtZ9HFjt4apGOdQ5NV07Xb
         PM9XVphqL0OXw==
Date:   Wed, 14 Dec 2022 08:43:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Nir Levy <bhr166@gmail.com>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [PATCH net v2] net: atm: Fix use-after-free bug in
 atm_dev_register()
Message-ID: <20221214084358.161f9d6f@kernel.org>
In-Reply-To: <Y5mAbfpeHEuQp0BE@unreal>
References: <20221211124943.3004-1-bhr166@gmail.com>
        <Y5bUXjhM3mvUkwNL@unreal>
        <20221213191233.5d0a7c8f@kernel.org>
        <Y5mAbfpeHEuQp0BE@unreal>
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

On Wed, 14 Dec 2022 09:51:09 +0200 Leon Romanovsky wrote:
> > Also atm_dev_register() still frees the dev on atm_register_sysfs()
> > failure, is that okay?  
> 
> Yes, the kernel panic points that class_dev (not dev) had use-after-free.

How is that possible? "class_dev" is embedded in dev (struct atm_dev).
