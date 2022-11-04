Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C511361A3FD
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 23:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiKDWTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 18:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiKDWTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 18:19:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ADE3113
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 15:19:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0980F6223E
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 22:19:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB7D7C433C1;
        Fri,  4 Nov 2022 22:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667600362;
        bh=R+X7CnFtxUSkXf3EzWHdz2oucrhrMeFMcet73xkgR/E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=neMwAx3Db6v7tnTE//PLxTdT4rVYvzlm9Iy7Gxz1qRLs02SbzrszIGY/ofN26ex6w
         J+rh4BCeZFRjRdZDyiQOn3+r1rv3RNfuftvOxhsPwgvqwSGd8o0JuGuWalV2ypOV96
         +5n0M9qVh913r3KG18RnynTA3zi0xBRRnZ/5BWPNcNG3D0KDQMi/VbRVAFz1sEX9aX
         Aj9O9WV986q8Y97A7QtdPghZTCIkVBKijh6ZU+iroMSbSM/52smZe5yfHJjC7xEuqr
         5fCiZWZ4VSjJ0WgwNJzrM6xKeO2A8zjOWbbpbErSDUy6wYWtE9Ts0KhPI9zx6ptFRo
         DlvFTwzn49BQg==
Date:   Fri, 4 Nov 2022 15:19:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jiri@resnulli.us, razor@blackwall.org,
        gnault@redhat.com, jacob.e.keller@intel.com, fw@strlen.de
Subject: Re: [PATCH net-next v2 12/13] genetlink: allow families to use
 split ops directly
Message-ID: <20221104151920.141553de@kernel.org>
In-Reply-To: <cea8a3b5-135b-efc6-ae8d-2a27c1db3b5f@6wind.com>
References: <20221102213338.194672-1-kuba@kernel.org>
        <20221102213338.194672-13-kuba@kernel.org>
        <cea8a3b5-135b-efc6-ae8d-2a27c1db3b5f@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Nov 2022 23:10:57 +0100 Nicolas Dichtel wrote:
> > +		/* Check sort order */
> > +		if (a->cmd < b->cmd)
> > +			continue;  
> If I understand correctly, the goal of the below checks, between a and b, is to
> enforce flags consitency between the do and the dump.
> Does this work if the cmds in the struct genl_split_ops are declared randomly (
> ie the do and the dump are separated by another cmd)?

I'm trying to go further and enforce sort order as weel (see comment
above the check), so that we can use binary search if we ever get to 
a large enough family for it to matter.
