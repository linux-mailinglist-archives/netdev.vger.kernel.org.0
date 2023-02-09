Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6D068FC07
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 01:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbjBIAgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 19:36:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjBIAgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 19:36:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA15520060
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 16:36:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 831ECB81FCE
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 00:36:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D46AFC433D2;
        Thu,  9 Feb 2023 00:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675902996;
        bh=PdNH4Z8DGzRcqHpehHbxUEQNd/MZFhhwDOLL1cC/27U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oEgE5jc1Vmbix3N0SfKsqNTPqepHr/wFhiTmemjXrP1r3YLMgr1XPW7V1l5bv218f
         K2FqZh05DQXk73cMVA+RX2V70AmlBYi1nOI6ifqjtntLMrS5x8v7Pakkc7dMScH3BU
         6bnQ3sHOrTtxw2NLCHgaU+Fj/z1m/gLhcMq0Uk6MQG2eb7IFgZUF0CRqCVfLurkQIn
         ZlqzPBVrMLPQzQvmETR3DPTxXP6rZ76JoLhIKrw0fJbTrx98tcKRpm7JfhLnQgZVlz
         XVnJaCUjKQ+zLV9QxbEPbwRUckGEZJkqM7t5BkqeuZjip82s/S1gLBqVXD1Uhj2Xnk
         +qWw5rnoroiwA==
Date:   Wed, 8 Feb 2023 16:36:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander H Duyck <alexander.duyck@gmail.com>
Cc:     "Nambiar, Amritha" <amritha.nambiar@intel.com>,
        netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, Saeed Mahameed <saeed@kernel.org>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: Re: Kernel interface to configure queue-group parameters
Message-ID: <20230208163634.51ee1fa8@kernel.org>
In-Reply-To: <c8476530638a5f4381d64db0e024ed49c2db3b02.camel@gmail.com>
References: <e4deec35-d028-c185-bf39-6ba674f3a42e@intel.com>
        <c8476530638a5f4381d64db0e024ed49c2db3b02.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 07 Feb 2023 08:28:56 -0800 Alexander H Duyck wrote:
> I think much of this depends on exactly what functionality we are
> talking about. 

Right, maybe we need to take a page out of the container's book and
concede that best we can do is provide targeted APIs for slices of 
the problem. Which someone in user space would have to combine.

> > 4. Devlink:
> >     Pros:
> >     - New parameters can be added without any changes to the kernel or 
> > userspace.
> > 
> >     Cons:
> >     - Queue/Queue_group is a function-wide entity, Devlink is for 
> > device-wide stuff. Devlink being device centric is not suitable for 
> > queue parameters such as rates, NAPI etc.  
> 
> Yeah, I wouldn't expect something like this to be a good fit.

Devlink has the hierarchical rate API for example.
Maybe we should (re)consider adding top level nodes for RSS contexts
there?
