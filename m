Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07D8F69E4AB
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 17:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234072AbjBUQaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 11:30:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233860AbjBUQaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 11:30:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA970271F;
        Tue, 21 Feb 2023 08:30:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48CCA61126;
        Tue, 21 Feb 2023 16:30:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473EFC433D2;
        Tue, 21 Feb 2023 16:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676997007;
        bh=EG8UTLrMQLzm3iFPPWAYTYcIEk58a7c9l0GCfKkd92c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bHc5O2DuJT4Kxj6Mgrzub0CK/6NJp7PkaVkjeDm3YQVDzSx4zynjbU+tfuJWlhfC9
         ybHZtDlRnea2QnBlet4a+0D4DIwK2e3FRD/qbx4BgGYcAWyvCQEKx9dPvTm81iziUc
         ygomDdmXFZOdJ6or+aW62GUFsTP+8YwziANC2AFx8QuOZsRAekxzXcKHFs6FREXZY2
         LlYh8YvSYz/b9MknHE5Td5SKZoWUinv+5sjfUtQwYkpTXXGp9A3XUpAhAVWwOfwNm1
         X1s0mejDijZCtizrrfUPuPJR11qyjgwN+r+Aom2o53Cfo1ykgINPWAz9krKd1uyuxQ
         YaW7NBrdOFSPg==
Date:   Tue, 21 Feb 2023 08:30:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Patrisious Haddad <phaddad@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, linux-rdma@vger.kernel.org,
        Mark Zhang <markzhang@nvidia.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net-next] net/mlx5: Fix memory leak in IPsec RoCE
 creation
Message-ID: <20230221083006.012507c3@kernel.org>
In-Reply-To: <Y/RnLCPZPaR4WSUC@unreal>
References: <1b414ea3a92aa0d07b6261cf641445f27bc619d8.1676811549.git.leon@kernel.org>
        <20230220165000.1eda0afb@kernel.org>
        <Y/RnLCPZPaR4WSUC@unreal>
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

On Tue, 21 Feb 2023 08:39:40 +0200 Leon Romanovsky wrote:
> On Mon, Feb 20, 2023 at 04:50:00PM -0800, Jakub Kicinski wrote:
> > On Sun, 19 Feb 2023 14:59:57 +0200 Leon Romanovsky wrote:  
> > > -rule_fail:
> > > +fail_rule:
> > >  	mlx5_destroy_flow_group(roce->g);
> > > -fail:
> > > +fail_group:
> > >  	mlx5_destroy_flow_table(ft);
> > > +fail_table:
> > > +	kvfree(in);
> > >  	return err;  
> > 
> > If you're touching all of them please name them after what they do.
> > Much easier to review.  
> 
> I can change it, but all mlx* drivers and randomly chosen place in ice
> use label to show what fail and not what will be done. Such notation
> gives an ability to refactor code without changing label names if
> failed part of code is not removed.

Please refactor, and it'd be great if the convention was changed for
all new code in these drivers.
