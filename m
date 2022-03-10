Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31EC54D52DD
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 21:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235854AbiCJUJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 15:09:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232476AbiCJUJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 15:09:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59AA66179
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 12:08:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EAB5D6165C
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 20:08:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A2DDC340E9;
        Thu, 10 Mar 2022 20:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646942908;
        bh=3k2i786lC8lJUADFXPn0HCJZ8eismXy8jNR3+HYO5ms=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ujQdhmKfk9SyzM0/HnJqdT3y5+PxuJjs+0kjLb8Ndznz5l+BID6FgDfIba+Xv+K64
         C6QZg7PvJyBPUb658hjifidy0cOjudIk3sT/CSlFmwHJ2PUf5soumZgH3Y2nljqiaL
         AnyO8lEzG6CFLvKP106jWFPbBgVz3DZfTqzyjk8xu2wpTVN6lEqW4Y/C4LZjIilP4f
         YAY3uah1cyl9YfbPL/4tp5hApPlMsksXDx9KAEEI/jg8SUXjRK8RErb8/cGTPXz/g8
         OM6SM0XZuT29WZNFmNHStAJ7pMz3f/MDZYRCK0YXp/wRzXJESOlkRJDh+RJLk3BdPP
         9DTD9W0JU1F0g==
Date:   Thu, 10 Mar 2022 12:08:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
        netdev@vger.kernel.org, leonro@nvidia.com
Subject: Re: [RFT net-next 4/6] eth: mlxsw: switch to explicit locking for
 port registration
Message-ID: <20220310120827.3dfee02f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YinCNuQO3p0Bkv05@nanopsycho>
References: <20220310001632.470337-1-kuba@kernel.org>
        <20220310001632.470337-5-kuba@kernel.org>
        <YinCNuQO3p0Bkv05@nanopsycho>
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

On Thu, 10 Mar 2022 10:17:42 +0100 Jiri Pirko wrote:
> Thu, Mar 10, 2022 at 01:16:30AM CET, kuba@kernel.org wrote:
> >Explicitly lock the devlink instance and use devl_ API.
> >
> >This will be used by the subsequent patch to invoke
> >.port_split / .port_unsplit callbacks with devlink
> >instance lock held.
> >
> >Signed-off-by: Jakub Kicinski <kuba@kernel.org>  
> 
> Looks fine. I was about to propose a helpers for the lock/unlock that
> would take mlxsw_core, but I see you are removing most of them in the
> next patch :)

Yup :) the end result should be one lock / unlock in probe and remove
paths.
