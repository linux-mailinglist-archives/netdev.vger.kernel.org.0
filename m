Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1F4605059
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 21:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbiJSTZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 15:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbiJSTZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 15:25:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93DA2E987A
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 12:25:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35767B825C3
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 19:25:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9527FC433D6;
        Wed, 19 Oct 2022 19:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666207505;
        bh=MuynOBSOVHNHYDwt4NyxZDLiJU1ztlUiUpEsQ49YC2E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EON4GZY38uHkq5G3pKCeLkK25imrqKPLQG+x7ZRxb/DoGV9e9r8wSiAirpJnQkbO/
         VjS8n0g2c15zYuYSNcask2u38Y9aeGB3P07BGSoOXMqBeJ+gg/g1QIdo1ph6HQPbMi
         iH4/4Cr+bG6aFZFKkpQOKW0uIUrm/x8b5V5RiFnOB1wBx/RiN/llD0HXgIk/et79xs
         rIQJCEAqXdEemkhoATNx0YDfDxJRcQbeP5SOeeQZp1P15I7aG1jfpK9BJjLcfhWctn
         9ftgK93jyJkQOXp9gbDJt2JZv1tZ6dY2qt8gwvLM+FuBSvY/W2DWTGoRLI+/keelbg
         RoxWbYMvo9YKQ==
Date:   Wed, 19 Oct 2022 12:25:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jiri@resnulli.us, razor@blackwall.org,
        nicolas.dichtel@6wind.com, gnault@redhat.com,
        jacob.e.keller@intel.com, fw@strlen.de
Subject: Re: [PATCH net-next 12/13] genetlink: allow families to use split
 ops directly
Message-ID: <20221019122504.0cb9d326@kernel.org>
In-Reply-To: <a23c47631957c3ba3aaa87bc325553da04f99a0c.camel@sipsolutions.net>
References: <20221018230728.1039524-1-kuba@kernel.org>
        <20221018230728.1039524-13-kuba@kernel.org>
        <a23c47631957c3ba3aaa87bc325553da04f99a0c.camel@sipsolutions.net>
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

On Wed, 19 Oct 2022 10:15:05 +0200 Johannes Berg wrote:
> > full ops. Each split op is 40B while full op is 48B.
> > Devlink for example has 54 dos and 19 dumps, 2 of the dumps
> > do not have a do -> 56 full commands = 2688B.
> > Split ops would have taken 2920B, so 9% more space while
> > allowing individual per/post doit and per-type policies.  
> 
> You mean "Full ops would have [...] while split ops allow individual
> [...]" or so?

Split ops end up being larger as we need a separate entry for each 
do and dump. So I think it's right?
