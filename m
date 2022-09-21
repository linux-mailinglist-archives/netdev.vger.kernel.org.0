Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5BA55E547D
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 22:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbiIUU3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 16:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiIUU3d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 16:29:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7842DD86
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 13:29:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12F4A6292B
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 20:29:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E3BC433C1;
        Wed, 21 Sep 2022 20:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663792170;
        bh=drXLtze76SLhP3VZlGlEaOcbcKLjB0BFmy/WuYAdqn4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BH0Mjw/XXwntfwl0bZpnG5pCAYgUqDshgyL3mNxyeFsGRyujIYIWihiBZ4KL8hws5
         hGCL7eyDRexVxGFPARaqoNJ7f1SIiDR302OBG3dCuRW1ZUOXHG3o0BvjnAkunTsNxb
         O6OX35s6CfCjEKUgpHVZUWAdpNq4Il6npo8vMS0S3PJZogvIABJj47XRPdAQHbhyeh
         xywZDdLLDVI0ciWV9zYBbaPjlWjdUKy+2dlLlbxVuY9r95Xql/2nyAQma8Grk/KUpJ
         ybMQ8KFZiCVcRQE9GauzoK5hD+dvwZjm8GKIpxWzLRWjEaLBXAPgxArMV9S7WSXBQw
         MtfF9MM3LK3VA==
Date:   Wed, 21 Sep 2022 13:29:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Amritha Nambiar <amritha.nambiar@intel.com>
Cc:     netdev@vger.kernel.org, alexander.duyck@gmail.com,
        jhs@mojatatu.com, jiri@resnulli.us, xiyou.wangcong@gmail.com,
        vinicius.gomes@intel.com, sridhar.samudrala@intel.com
Subject: Re: [net-next PATCH v2 0/4] Extend action skbedit to RX queue
 mapping
Message-ID: <20220921132929.3f4ca04d@kernel.org>
In-Reply-To: <166260012413.81018.8010396115034847972.stgit@anambiarhost.jf.intel.com>
References: <166260012413.81018.8010396115034847972.stgit@anambiarhost.jf.intel.com>
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

On Wed, 07 Sep 2022 18:23:57 -0700 Amritha Nambiar wrote:
> Based on the discussion on
> https://lore.kernel.org/netdev/20220429171717.5b0b2a81@kernel.org/,
> the following series extends skbedit tc action to RX queue mapping.
> Currently, skbedit action in tc allows overriding of transmit queue.
> Extending this ability of skedit action supports the selection of receive
> queue for incoming packets. Offloading this action is added for receive
> side. Enabled ice driver to offload this type of filter into the
> hardware for accepting packets to the device's receive queue.
> 
> v2: Added documentation in Documentation/networking

Alex and I had a quick chat about this, I think we can work around 
the difficulties with duplicating the behavior in SW by enforcing 
that the action can only be used with skip_sw. Either skbedit or
Alex's suggested approach with act_mirred. Or new hw-only action.

Alex pointed out that it'd be worth documenting the priorities of 
aRFS vs this thing, which one will be used if HW matches both.
