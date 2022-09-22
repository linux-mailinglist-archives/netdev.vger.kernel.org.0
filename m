Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C16625E6D05
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 22:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiIVU3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 16:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiIVU3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 16:29:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA32B21821
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 13:29:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61A7262A2B
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 20:29:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42458C433D6;
        Thu, 22 Sep 2022 20:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663878586;
        bh=03Be1RpJ0786D4CdXPypsQxN7I/vBRO0g/0H9iri/T0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tFzhCI7jUcHOnPBKVWigBUis82prI4+TZU95bBS4Bh46WaJZo4+gtHZg5bCNMQu9G
         6xf55+3FrcEBYmaY0K9Y7tsBlNDShwc6pvOxMiwy0z6rArS9qgJsycn8+W8N/pEN+E
         DV6kUTegBPuuqSKVgrzFI+jRhsampXlnOuV6byiphtMucm52s51OGUz7lGcIsBMDXl
         qK7bSbMf7IcXhY0ADYxmBemtb9RsGMHQKqjzdI1CQCan0ovOAdh0nqEjB7JSh9TGj+
         hs6xyT/7/FFsXpYrjapcRdeAXiVpzHk9kbhTtCQoyaIEhdbQSBqKU0QigpDaq2zLLP
         kThBv29XZBXKQ==
Date:   Thu, 22 Sep 2022 13:29:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Wilczynski, Michal" <michal.wilczynski@intel.com>
Cc:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <alexandr.lobakin@intel.com>, <dchumak@nvidia.com>,
        <maximmi@nvidia.com>, <jiri@resnulli.us>,
        <simon.horman@corigine.com>, <jacob.e.keller@intel.com>,
        <jesse.brandeburg@intel.com>, <przemyslaw.kitszel@intel.com>
Subject: Re: [RFC PATCH net-next v4 2/6] devlink: Extend devlink-rate api
 with queues and new parameters
Message-ID: <20220922132945.7b449d9b@kernel.org>
In-Reply-To: <9656fcda-0d63-06dc-0803-bc5f90ee44fd@intel.com>
References: <20220915134239.1935604-1-michal.wilczynski@intel.com>
        <20220915134239.1935604-3-michal.wilczynski@intel.com>
        <f17166c7-312d-ac13-989e-b064cddcb49e@gmail.com>
        <401d70a9-5f6d-ed46-117b-de0b82a5f52c@intel.com>
        <20220921163354.47ca3c64@kernel.org>
        <477ea14d-118a-759f-e847-3ba93ae96ea8@intel.com>
        <20220922055040.7c869e9c@kernel.org>
        <9656fcda-0d63-06dc-0803-bc5f90ee44fd@intel.com>
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

On Thu, 22 Sep 2022 15:45:55 +0200 Wilczynski, Michal wrote:
> On 9/22/2022 2:50 PM, Jakub Kicinski wrote:
> > Anyway. My gut feeling is that this is cutting a corner. Seems
> > most natural for the VF/PF level to be controlled by the admin
> > and the queue level by whoever owns the queue. The hypervisor
> > driver/FW should reconcile the two and compile the full hierarchy.  
> 
> We tried already tc-htb, and it doesn't work for a couple of reasons, 
> even in this potential hybrid with devlink-rate. One of the problems
> with tc-htb offload is that it forces you to allocate a new
> queue, it doesn't allow for reassigning an existing queue to another 
> scheduling node. This is our main use case.
> 
> Here's a discussion about tc-htb: 
> https://lore.kernel.org/netdev/20220704114513.2958937-1-michal.wilczynski@intel.com/

This is a problem only for "SR-IOV case" or also for just the PF?

> So either I would have to invent a new offload type (?) for tc, or 
> completely rewrite and
> probably break tc-htb that mellanox implemented.
> Also in our use case it's possible to create completely new branches 
> from the root and
> reassigning queues there. This wouldn't be possible with the method 
> you're proposing.
> 
> So existing interface doesn't allow us to do what is required.

For some definition of "what is required" which was not really
disclosed clearly. Or I'm to slow to grasp.
