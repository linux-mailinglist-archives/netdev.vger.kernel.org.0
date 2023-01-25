Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF0A67AA09
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 06:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233829AbjAYFmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 00:42:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjAYFmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 00:42:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365DD40F8;
        Tue, 24 Jan 2023 21:42:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 856C56143F;
        Wed, 25 Jan 2023 05:42:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 636B8C433D2;
        Wed, 25 Jan 2023 05:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674625331;
        bh=06NHYe81ukCOxE/YCvjn/ynkOIZcaf92JSd+ZjnUlPE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GUl9bhlOOpeLskMmhKcpDHyauJ6z2c25XU38XouqHGeRbtvhCpZDEFPWDhpqtHARj
         h4rFN2nBWdmiARr4puPbSI6Rj2p5PPrUPCljkS53uvTFrx95uIR8O/B4PiwtGHXqCU
         GY0TPvAYweVR5RDy1zE3/JBa5kVlhWb6uq8cOVW/rzKJOuj/iZx08tv8nEimcncW2z
         SXrtuyFmwYt82vqKZs18I5uebb5v5glUbrQFScRtclc+A2IU8Yspg32nN+Q0Kd4tMO
         iuDoXhutWvS/43X6ZxIjcVAj45WHC8JTUMstM39mcuEXO+zi55ZDUkb41akR3unyuq
         Q1zzQIG+3tiWg==
Date:   Tue, 24 Jan 2023 21:42:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     <davem@davemloft.net>, <pabeni@redhat.com>, <pablo@netfilter.org>,
        <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>
Subject: Re: [PATCH net-next v4 6/7] net/sched: act_ct: offload UDP NEW
 connections
Message-ID: <20230124214210.32ac7329@kernel.org>
In-Reply-To: <20230124140207.3975283-7-vladbu@nvidia.com>
References: <20230124140207.3975283-1-vladbu@nvidia.com>
        <20230124140207.3975283-7-vladbu@nvidia.com>
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

On Tue, 24 Jan 2023 15:02:06 +0100 Vlad Buslov wrote:
> Modify the offload algorithm of UDP connections to the following:
> 
> - Offload NEW connection as unidirectional.
> 
> - When connection state changes to ESTABLISHED also update the hardware
> flow. However, in order to prevent act_ct from spamming offload add wq for
> every packet coming in reply direction in this state verify whether
> connection has already been updated to ESTABLISHED in the drivers. If that
> it the case, then skip flow_table and let conntrack handle such packets
> which will also allow conntrack to potentially promote the connection to
> ASSURED.
> 
> - When connection state changes to ASSURED set the flow_table flow
> NF_FLOW_HW_BIDIRECTIONAL flag which will cause refresh mechanism to offload
> the reply direction.
> 
> All other protocols have their offload algorithm preserved and are always
> offloaded as bidirectional.
> 
> Note that this change tries to minimize the load on flow_table add
> workqueue. First, it tracks the last ctinfo that was offloaded by using new
> flow 'ext_data' field and doesn't schedule the refresh for reply direction
> packets when the offloads have already been updated with current ctinfo.
> Second, when 'add' task executes on workqueue it always update the offload
> with current flow state (by checking 'bidirectional' flow flag and
> obtaining actual ctinfo/cookie through meta action instead of caching any
> of these from the moment of scheduling the 'add' work) preventing the need
> from scheduling more updates if state changed concurrently while the 'add'
> work was pending on workqueue.

Clang is not happy:

net/sched/act_ct.c:677:12: warning: cast to smaller integer type 'enum ip_conntrack_info' from 'typeof (_Generic((flow->ext_data), char: (char)0, unsigned char: (unsigned char)0, signed char: (signed char)0, unsigned short: (unsigned short)0, short: (short)0, unsigned int: (unsigned int)0, int: (int)0, unsigned long: (unsigned long)0, long: (long)0, unsigned long long: (unsigned long long)0, long long: (long long)0, default: (flow->ext_data)))' (aka 'void *') [-Wvoid-pointer-to-enum-cast]
                else if ((enum ip_conntrack_info)READ_ONCE(flow->ext_data) ==
                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
