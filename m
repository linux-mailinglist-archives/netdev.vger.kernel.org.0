Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B43E75FD2C6
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 03:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbiJMBlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 21:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbiJMBk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 21:40:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B07A3AE77;
        Wed, 12 Oct 2022 18:40:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B33BB81CCD;
        Thu, 13 Oct 2022 01:40:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8E9C433C1;
        Thu, 13 Oct 2022 01:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665625251;
        bh=3ZCGToPaazLxSo8auNDegz7ZNYJoaGHGQK/xLD/k5Yc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cAqYNXvo5FQ12eE1mxDNT5gXxmkTLytoDOpPo9g0aqYCJsdWxA/DaZBASaBYKlRnp
         82Ml9I7x46PwbneRMgA+JDoQlT5D9elUmpV2dHCfvFDfSHZ+W4MNnuORvj3hTL8QnV
         fx1lYjFEPbYOV1F8An+ZsHF9SLuR+qBZnvdo1B7mepPnKUdx8hsQ96jHn0r2KLbQYF
         Uy1QgQ3Jbmpib/p0R13uw5SmVGv9/l0PynGEiomvK30DmPCD1YxTHirgDW4VWLS85a
         GlNqljtHAtSliG/bxK156q5pu/oaSG8itOlMPdyywpGzP6YcSC6jyatydVie+I7js3
         4gXeBnGxmwRJg==
Date:   Wed, 12 Oct 2022 18:40:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Wei Wang <weiwan@google.com>, Eric Dumazet <edumazet@google.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH net-next] net-memcg: pass in gfp_t mask to
 mem_cgroup_charge_skmem()
Message-ID: <20221012184050.5a7f3bde@kernel.org>
In-Reply-To: <20221013005431.wzjurocrdoozykl7@google.com>
References: <20210817194003.2102381-1-weiwan@google.com>
        <20221012163300.795e7b86@kernel.org>
        <CALvZod5pKzcxWsLnjUwE9fUb=1S9MDLOHF950miF8x8CWtK5Bw@mail.gmail.com>
        <20221012173825.45d6fbf2@kernel.org>
        <20221013005431.wzjurocrdoozykl7@google.com>
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

On Thu, 13 Oct 2022 00:54:31 +0000 Shakeel Butt wrote:
> So, before the patch, the memcg code may force charges but it will
> return false and make the networking code to uncharge memcg for
> SK_MEM_RECV.

Ah, right, I see it now :(

I guess I'll have to try to test (some approximation of) a revert 
after all.

Did the fact that we used to force charge not potentially cause
reclaim, tho?  Letting TCP accept the next packet even if it had
to drop the current one?
