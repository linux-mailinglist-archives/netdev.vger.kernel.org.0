Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56C584B020A
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 02:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbiBJBZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 20:25:34 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:50924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbiBJBZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 20:25:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50FB75598;
        Wed,  9 Feb 2022 17:25:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD21EB823BB;
        Thu, 10 Feb 2022 01:25:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 276E9C340E7;
        Thu, 10 Feb 2022 01:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644456327;
        bh=q1j/8X8KRoaMux0MR33EKmu69UKx9HSvfrHlB087F2Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dSOgMdAvTyqsqgyfjJafaoZDP9KQqRA12znksjSjfUS65ZvWAeU5jZLE44U3J+1Te
         MblFTGGEnsucHWyXVUgdr+CpwrmS2RkEGHQn1zqk+rYzT1kzBDhkWXfKH4bcty4NF+
         AnSaHC9mSJ1XsDOYHyxifkbduWYMtOqU+/1ACoSa3/9Hz/5mjA2r4OqEdQLWtvNDn7
         u5a29BYyu2kAD8e7D9Kvd3BJJ556KnEQX8IYeAk/BKLebT2sZBhScfw1qznLrCjVNV
         PcCOJ//q4w8XmVdIJS+WtIYh0t78DmP/C2S6oouNqEmN0eFrKNifHdcOlZq+LiltdU
         6u6/GoJJ1W4tQ==
Date:   Wed, 9 Feb 2022 17:25:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>, Moshe Shemesh <moshe@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] net/mlx5: Introduce devlink param to
 disable SF aux dev probe
Message-ID: <20220209172525.19977e8c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YgOQAZKnbm5IzbTy@nanopsycho>
References: <1644340446-125084-1-git-send-email-moshe@nvidia.com>
        <20220208212341.513e04bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YgOQAZKnbm5IzbTy@nanopsycho>
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

On Wed, 9 Feb 2022 09:39:54 +0200 Moshe Shemesh wrote:
> Well we don't have the SFs at that stage, how can we tell which SF will 
> use vnet and which SF will use eth ?

On Wed, 9 Feb 2022 10:57:21 +0100 Jiri Pirko wrote: 
> It's a different user. One works with the eswitch and creates the port
> function. The other one takes the created instance and works with it.
> Note that it may be on a different host.

It is a little confusing, so I may well be misunderstanding but the
cover letter says:

$ devlink dev param set pci/0000:08:00.0 name enable_sfs_aux_devs \
              value false cmode runtime

$ devlink port add pci/0000:08:00.0 flavour pcisf pfnum 0 sfnum 11

So both of these run on the same side, no?

What I meant is make the former part of the latter:

$ devlink port add pci/0000:08:00.0 flavour pcisf pfnum 0 sfnum 11 noprobe


Maybe worth clarifying - pci/0000:08:00.0 is the eswitch side and
auxiliary/mlx5_core.sf.1 is the... "customer" side, correct? 
