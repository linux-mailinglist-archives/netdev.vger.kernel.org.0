Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 012C44F849F
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 18:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232236AbiDGQNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 12:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232154AbiDGQNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 12:13:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFAFF73060
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 09:11:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15E5361F5A
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 16:11:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117FDC385AA;
        Thu,  7 Apr 2022 16:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649347881;
        bh=ThDJyN+QR/Nifz7JLO24fG+OkcppU2kEbxnnVZ+Xvxo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SYzkSLcM01L1GZRDSVC9OX4qP4Lq8XuskHsm3rAFt075YCNq5YFW97UCa0QY6oqUD
         RWVxpdn+kvfmZv0LfQAqOoOPHUC+bJtj69/I1mTwRBaIqhxgehz834ur1fWLoQbArG
         h/TfN08/No4IX4UwIRirOL8uAlx+jveeD3teFMLAMaW9oLEWmZzU+nCTqNwI97EI4I
         HOQQnTLPRSyRf2E+P1F2iVtgDO611b5NToDpqvIoGf6zfsdOSppXb7KTMIXbcZr6F4
         wF1TcPYywS6Vfmtni6E57a3MS9SuThI1w1ZL1nEeYNOL877Ptq5k90v0KgbL6tcHRC
         ApZJTl0SP9Eqw==
Date:   Thu, 7 Apr 2022 09:11:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florent Fourcot <florent.fourcot@wifirst.fr>
Cc:     netdev@vger.kernel.org, cong.wang@bytedance.com,
        edumazet@google.com, Jiri Pirko <jiri@mellanox.com>,
        Brian Baboch <brian.baboch@wifirst.fr>
Subject: Re: [PATCH v3 net-next 1/4] rtnetlink: enable alt_ifname for
 setlink/newlink
Message-ID: <20220407091119.6ff5b879@kernel.org>
In-Reply-To: <748f0357-2527-edda-d08a-ac0b0a7bffef@wifirst.fr>
References: <20220405134237.16533-1-florent.fourcot@wifirst.fr>
        <20220405174149.39a50448@kernel.org>
        <748f0357-2527-edda-d08a-ac0b0a7bffef@wifirst.fr>
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

On Thu, 7 Apr 2022 14:34:33 +0200 Florent Fourcot wrote:
> > This patch needs to be after patch 3, AFAICT. Otherwise someone running
> > a bisection and landing in between the two will have a buggy build.
> 
> I double checked and this patch compiles perfectly fine when applied 
> first, at least with my .config.
> Could you be more specific on what I'm missing?

rtnl_group_changelink() was passing NULL as ifname, but with just 
this patch applied we'll start using tb[IFLA_IFNAME] directly. 

It's better to have your patch which rejects group settings with
tb[IFLA_IFNAME] first, to avoid changing the group + IFLA_IFNAME
behavior subtly multiple times.
