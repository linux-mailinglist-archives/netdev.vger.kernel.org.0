Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD5266E4DB1
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 17:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbjDQPxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 11:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231460AbjDQPxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 11:53:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB1E2AD03
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 08:53:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9540627D3
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 15:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01A93C433EF;
        Mon, 17 Apr 2023 15:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681746772;
        bh=Q7ELvwTXtXHpUIqmGuiUwArDLgCOl1meklolhfYr4YY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=M4ojEqKmoSw9fbp7EK8Fjuy0UskadvsjOzIjHAfkHCZM8l5wqHpS5P2yCvTva+DGJ
         fKO41rLnIeHkrN8USw0vKo3SxJ7JnDr3yMeBf0qFPBaAXlXqiwLVbRZCgJwRWUIs2f
         sqyw6ii4909IlslE2zdN7nOfBCdeTs+N9WaZsKHMWw30W8AU6NBcTCkOVNOD3PF2Mj
         AK8WT8hLrL0oAQ/4UBnyrxyem1Zfop2wI0o3TgOuI3FPL8dW5gZ4KH5dJiqsxXXyPn
         9H4DW23A2xUI1+BHORQ5VfGI2517FTHs/dPD16RWvYP/2vQ6Ga5vU9njxWEJ4DiiAs
         92XZ2yWlKCrFw==
Date:   Mon, 17 Apr 2023 08:52:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Pedro Tammela <pctammela@mojatatu.com>, netdev@vger.kernel.org,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net-next 1/2] net/sched: sch_htb: use extack on errors
 messages
Message-ID: <20230417085251.6b031b1e@kernel.org>
In-Reply-To: <CAM0EoMkYCZovRqu4KRvgoO0YfEf0UXm0tU_uTmfJ5Ln2kbD1mQ@mail.gmail.com>
References: <20230414185309.220286-1-pctammela@mojatatu.com>
        <20230414185309.220286-2-pctammela@mojatatu.com>
        <20230414181345.34114441@kernel.org>
        <CAM0EoMkYCZovRqu4KRvgoO0YfEf0UXm0tU_uTmfJ5Ln2kbD1mQ@mail.gmail.com>
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

On Sat, 15 Apr 2023 10:06:36 -0400 Jamal Hadi Salim wrote:
> There is no "rule" other than the LinuxWay(tm) i.e. people cutnpaste.

:-)

> It's not just on qdiscs that this inconsistency exists but also on
> filters and actions.
> Do we need a rule to prefer one over the other? _MOD() seems to
> provide more information - which is always useful.

People started adding _MOD() on every extack so I was pushing back 
a little lately. It will bloat the strings and makes the output between
parsing and hand coded checks different. Plus if we really want the
mod name, we should just make it the default and remove the non-mod
version.

The rule of thumb I had was that if the message comes from "core" of 
a family then _MOD() is unnecessary. In this case HTB is a one-of-many
implementations so _MOD() seems fine. Then again errors about parsing
TCA_HTB_* attrs are unlikely to come from something else than HTB..
