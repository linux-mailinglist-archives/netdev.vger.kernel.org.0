Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 223596050E8
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 21:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiJST5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 15:57:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbiJST5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 15:57:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EBE91D7981
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 12:57:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDE14619AC
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 19:57:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06934C433D6;
        Wed, 19 Oct 2022 19:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666209466;
        bh=A5HUVcpRVhdI8sNUfwtNM7yXPDKBNNT8zfimMfutKIA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WeB5LGyYlj39qVOlPU/QlTMYll5zHoymAZUah5G8kwWHnXMS8EWmP4ZclGf/8E6vN
         Y2dzHDDj4nYnEgjp4MaGQKXtKnzlR8E8g4kiFHjmbYIrLhB/rENWRbGtdRGaRgdOzc
         LfUNKUf/iCYvCE5ev79qweV6HK14nKNeE5H7RB1wEyp7+M/7JOFG329XmllbLdwkgu
         yPZN0eo7twZgncnRKQfKvScN7/av4jtguMYhh63u58MXJ3/SQVO3TPf9U0veAoGhq1
         oDsGH4Wuyx/N2EcIfVfZ8rsmumICOkFIUcIHGPpHUpumEZgaQ6XgrNgrAb3DR8GcSm
         t1cMm83ABJLLQ==
Date:   Wed, 19 Oct 2022 12:57:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jiri@resnulli.us, razor@blackwall.org,
        nicolas.dichtel@6wind.com, gnault@redhat.com,
        jacob.e.keller@intel.com, fw@strlen.de
Subject: Re: [PATCH net-next 12/13] genetlink: allow families to use split
 ops directly
Message-ID: <20221019125745.3f2e7659@kernel.org>
In-Reply-To: <dfac0b6e09e9739c7f613cb8ed77c81f9db0bb44.camel@sipsolutions.net>
References: <20221018230728.1039524-1-kuba@kernel.org>
        <20221018230728.1039524-13-kuba@kernel.org>
        <a23c47631957c3ba3aaa87bc325553da04f99a0c.camel@sipsolutions.net>
        <20221019122504.0cb9d326@kernel.org>
        <dfac0b6e09e9739c7f613cb8ed77c81f9db0bb44.camel@sipsolutions.net>
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

On Wed, 19 Oct 2022 21:37:41 +0200 Johannes Berg wrote:
> > > You mean "Full ops would have [...] while split ops allow individual
> > > [...]" or so?  
> > 
> > Split ops end up being larger as we need a separate entry for each 
> > do and dump. So I think it's right?
> 
> Indeed.
> 
> Oh, I see now, you were basically saying "it's only 9% bigger for all
> that extra flexibility" ... didn't read that right before.

Yup, BTW one annoying bit is that we treat maxattr == 0 as 
"no validation" rather than "reject everything".

Right now I add a reject-all policy in the family itself (with two
entries, argh), and hook it up to parameter-less dumps. But we could 
do something else - like modify the behavior in case the op was declared
as split at the family level.

I opted for having family add the reject-all policy because I code gen
the policies based on YAML spec, anyway, so not much extra effort, and
the uniformity between different type of ops seems worth maintaining.

WDYT?
