Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 444F16D70E3
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 01:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236637AbjDDXqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 19:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236398AbjDDXqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 19:46:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C38201BFC
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 16:46:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F09263AC3
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 23:46:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B942C433D2;
        Tue,  4 Apr 2023 23:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680651969;
        bh=uszaaznEOO3yCNu6evsAVLVGf5KJ1sPvSInnN/WP8ks=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Jf8V7wQD0ysiGSUBIvdOeNfYf0axw+o3AGtnPYe0LR8fylw5RKv/WChaPd7b4hl9E
         67B+b2XtZU2WCGEqozYIoPxW2ecMCDX6mLs1Y3k2WO8HeMrTAABa1WodWIKi4rf9cb
         K0sKf9W6Zh8VglzzDRoQlCwyHqDLUNKDz7IZCTb9tYWgpr3Lr3HXQGOhRqn+M1v/Ft
         aPUM1yhUNrX8tSqIM9cqSy1w5wOHa78JtL44mxQ+scOnqOA4bqL7UhaX4HZm02yIi0
         c85zuWzcSFGQPLQA9WGX3NxWjMgE4ZX/B+jITHYr1Ke5sOHZdQiZXwf0jtRT7PyMF2
         6lqkb67MMJcZA==
Date:   Tue, 4 Apr 2023 16:46:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     edward.cree@amd.com, linux-net-drivers@amd.com,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org, habetsm.xilinx@gmail.com,
        sudheer.mogilappagari@intel.com
Subject: Re: [RFC PATCH net-next 5/6] net: ethtool: add a mutex protecting
 RSS contexts
Message-ID: <20230404164608.5489fb1b@kernel.org>
In-Reply-To: <9536914b-0254-23e4-de6d-a936a50129b0@gmail.com>
References: <cover.1680538846.git.ecree.xilinx@gmail.com>
        <255a20efdbbaa1cd26f3ae1baf4a3379bf63aa5e.1680538846.git.ecree.xilinx@gmail.com>
        <20230403150312.79174a7e@kernel.org>
        <9536914b-0254-23e4-de6d-a936a50129b0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Apr 2023 13:32:04 +0100 Edward Cree wrote:
> > Argh, the mutex doubles the size of the state, and most drivers don't
> > implement this feature.  My thinking was to add a "ethtool state">
> > pointer to net_device which will be allocated by ethtool on demand
> > and can hold all ethtool related state.  
> 
> Would any other existing net_device fields go in this struct, or is
>  it just the RSS stuff so far?

Only wol_enabled possibly, nothing else looks relevant.
But wol_enabled is one bit so up to you if you want to move it.
