Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A593B61A039
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 19:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbiKDSrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 14:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiKDSrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 14:47:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C74659867;
        Fri,  4 Nov 2022 11:47:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C00CB82EF9;
        Fri,  4 Nov 2022 18:47:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7088FC433C1;
        Fri,  4 Nov 2022 18:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667587651;
        bh=FCVLnWzagH7Ltd74TWHda9yHbM/ThxqIP+R6QjDXusQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K8hlD+njx6G0TqbVm5Fth4CASD4xRSsQn3RzlPzp94KN29oCnPq1QW9c+GhArw0lr
         IQV8gpSUILgpCglcGFRxTTIEVu1IfaPnMuRSqcLulzeSRZBwyFfxm5DPY3KkKH/1XE
         iSDtWmLg+4zjj/QSfMgcNWeO3kXacE7WifGznlQF/rfapUXZUCNb5sTi8cpbbuhm8u
         HDBnUcSH2d2i2GM6C12emCculNjc1Ze801WOqR9G0RSVwKLF9LR4+kmtJKjfLRjvNe
         JlJHOrX1NojuKHc1moNVg0FzATcdR3XD0Y6vUNrtrNaoZcn0EO03RExhAOesjgH+tw
         83q/IgxOqpz1w==
Date:   Fri, 4 Nov 2022 11:47:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     Jiri Slaby <jirislaby@kernel.org>,
        "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>,
        Jan Sokolowski <jan.sokolowski@intel.com>,
        <jesse.brandeburg@intel.com>, <linux-kernel@vger.kernel.org>,
        Martin Liska <mliska@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH] i40e (gcc13): synchronize allocate/free functions
 return type & values
Message-ID: <20221104114730.42294e1c@kernel.org>
In-Reply-To: <003bc385-dc14-12ba-d3d6-53de3712a5dc@intel.com>
References: <20221031114456.10482-1-jirislaby@kernel.org>
        <20221102204110.26a6f021@kernel.org>
        <bf584d22-8aca-3867-5e3a-489d62a61929@kernel.org>
        <003bc385-dc14-12ba-d3d6-53de3712a5dc@intel.com>
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

On Fri, 4 Nov 2022 11:33:07 -0700 Tony Nguyen wrote:
> As Jiri mentioned, this is propagated up throughout the driver. We could 
> change this function to return int but all the callers would then need 
> to convert these errors to i40e_status to propagate. This doesn't really 
> gain much other than having this function return int. To adjust the 
> entire call chain is going to take more work. As this is resolving a 
> valid warning and returning what is currently expected, what are your 
> thoughts on taking this now to resolve the issue and our i40e team will 
> take the work on to convert the functions to use the standard errnos?

My thoughts on your OS abstraction layers should be pretty evident.
If anything I'd like to be more vigilant about less flagrant cases.

I don't think this is particularly difficult, let's patch it up
best we can without letting the "status" usage grow.
