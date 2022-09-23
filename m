Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A60F5E7B40
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 15:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbiIWNCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 09:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230431AbiIWNCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 09:02:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3B9137922
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 06:02:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAA2D61093
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:02:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4DB5C433D7;
        Fri, 23 Sep 2022 13:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663938124;
        bh=8ccEfO3Z9vk85htOkvZX7zuEqVhIw1/ucT+ADV67fWQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rKQEDsNwXgf/glQfcmM9L5tnrl+n+AOLtOUYA6GQaPKpb7jONxYl7PamvbR7F7wNb
         rR+0iKHo/ejURh/36pAAER3HZ2dc/cVi2erS/FnLfpe4pVqCtpd1gSUTMGdHJ3QUCF
         4LGior/3iZsbp3tbJyGkK29QKm/asthzEl07VJZifvMg29tLG5IC2NPMHOeN9xD1I5
         1Ud9er4CYCK5kFgxIGeYoKkLV4L7QGxOjsGl47W6p6RkHN+UvBCK1A7IAygM7pVWul
         J2qoZHBDy3cyAT4SkikKV3BylsjGr3q1szotOxKsMPna6qe3AloMouD/93fpDAVkKy
         31NrACsPWIdRg==
Date:   Fri, 23 Sep 2022 06:02:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Nambiar, Amritha" <amritha.nambiar@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: Re: [net-next PATCH v2 0/4] Extend action skbedit to RX queue
 mapping
Message-ID: <20220923060200.5effc63e@kernel.org>
In-Reply-To: <MWHPR11MB1293FB462DB6021E6B2916A5F1519@MWHPR11MB1293.namprd11.prod.outlook.com>
References: <166260012413.81018.8010396115034847972.stgit@anambiarhost.jf.intel.com>
        <20220921132929.3f4ca04d@kernel.org>
        <MWHPR11MB1293C87E3EC9BD7D64829F2FF14E9@MWHPR11MB1293.namprd11.prod.outlook.com>
        <20220922052908.4b5197d9@kernel.org>
        <MWHPR11MB1293FB462DB6021E6B2916A5F1519@MWHPR11MB1293.namprd11.prod.outlook.com>
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

On Fri, 23 Sep 2022 01:09:38 +0000 Nambiar, Amritha wrote:
> > Is it configurable? :S If we think about RSS context selection we'd
> > expect the context to be selected based on for example the IPv6 daddr
> > of the container but we still want aRFS to select the exact queue...  
> 
> This behavior is similar on E810 currently, i.e., TC filter selects the set
> of queues (like the RSS context), and then the flow director filter can
> be used to select the exact queue within the queue-set. We want to have
> the ability to select the exact queue within the queue-set via TC (and not
> flow director filter).
> 
> On E810, TC filters are added to hardware block called the "switch". This
> block supports two types of actions in hardware termed as "forward to
> queue" and  "forward to queue-set". aRFS filters are added to a different
> HW block called the "flow director" (FD). The FD block comes after the switch
> block in the HW pipeline. The FD block has certain restrictions (can only
> have filters with the same packet type). The switch table does not have
> this restriction.
> 
> When both the TC filter and FD filter competes for queue selection (i.e. both
> filters are matched and action is to set a queue), the pipeline resolves
> conflicts based on metadata priority. The priorities are not user configurable.
> The ICE driver programs these priorities based on metadata at each stage,
> action etc. Switch (TC) filters with forward-to-queue action have higher 
> priority over FD filter assigning a queue. The hash filter has lowest priority.
> 
> > Is there a counterargument for giving the flow director higher prio?  
> 
> Isn't the HW behavior on RX (WRT to setting the queue) consistent
> with what we have in SW for TX ? In SW, TX queue set via TC filter
> (skbedit action) has the highest precedence over XPS and jhash (lowest). 

Alright, I guess that could work as well, thanks for the explanation.
Initially I thought that it'd be strange if the queue-set selection
was before aRFS and queue-id selection after, if they are both to be
controlled by TC. But I can see how that makes most practical sense :S
