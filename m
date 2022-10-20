Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EEC46067F3
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 20:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbiJTSKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 14:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbiJTSKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 14:10:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA78E161FE1
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 11:10:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6C1961CD7
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 18:09:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2EEAC433C1;
        Thu, 20 Oct 2022 18:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666289392;
        bh=wlHkS6DyCa12Il2rxSLAcEGqSzgs8168sAeC6T6V1Ek=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qq58qILKYcUclTnQnkKpETfcwiM47Ti08gLBGx/K3lLVC26wIHI3h1zqiRNg7jpy4
         IXoSpXQoT3fiaW9NJcYKb2Kykhmh0bEfWKkiUzyiuIEgv9AcCsxYE2dGiQvJfDaYl4
         6zitFs3utB/FSd2Cmt7Afxfh3U1AD/EGZLK1WU2dMJQ0Q08pLUx2XZ241tT7beRYxs
         H8OLcTyu4S3kphdXXUcTq2d1Jr+WKls0kd2iWvGwL84eSXlE5Mu9rhPj0NtIOViplh
         UxajIynkp3+vk9WY/YoNT6/BjAz4wnIhr0wduvrD3bszC+6Lot3DP38ZRmql0Wy8GA
         /r2DUz2Dckrkw==
Date:   Thu, 20 Oct 2022 11:09:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jiri@resnulli.us, razor@blackwall.org,
        nicolas.dichtel@6wind.com, gnault@redhat.com,
        jacob.e.keller@intel.com, fw@strlen.de
Subject: Re: [PATCH net-next 12/13] genetlink: allow families to use split
 ops directly
Message-ID: <20221020110950.6e91f9bb@kernel.org>
In-Reply-To: <683f4c655dd09a2af718956e8c8d56e6451e11ac.camel@sipsolutions.net>
References: <20221018230728.1039524-1-kuba@kernel.org>
        <20221018230728.1039524-13-kuba@kernel.org>
        <a23c47631957c3ba3aaa87bc325553da04f99a0c.camel@sipsolutions.net>
        <20221019122504.0cb9d326@kernel.org>
        <dfac0b6e09e9739c7f613cb8ed77c81f9db0bb44.camel@sipsolutions.net>
        <20221019125745.3f2e7659@kernel.org>
        <683f4c655dd09a2af718956e8c8d56e6451e11ac.camel@sipsolutions.net>
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

On Thu, 20 Oct 2022 09:32:17 +0200 Johannes Berg wrote:
> Hmm. The codegen/YAML part likely won't really happen for all of the
> families so perhaps some simplification would be good?
> 
> I feel like I probably should've changed this when adding
> GENL_DONT_VALIDATE_DUMP_STRICT / GENL_DONT_VALIDATE_STRICT, but I guess
> that's too late now :(
> 
> I guess we could add another set of flags, but that'd be annoying.

Perhaps we could hang it of the .resv_start_op as well?
Any op past that would treat policy == NULL as reject all?

We'd need to add GENL_DONT_VALIDATE_DO for families which 
want to parse inside the callbacks. I wonder if people would
get annoyed.

> OTOH, it's nicer if future things are better, and we don't need to add a
> "reject all" policy to all of them?
