Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 322A15FD383
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 05:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiJMDRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 23:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiJMDQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 23:16:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 890C5110B11;
        Wed, 12 Oct 2022 20:16:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15CEB61683;
        Thu, 13 Oct 2022 03:16:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D08C433D6;
        Thu, 13 Oct 2022 03:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665631011;
        bh=pPVBjkE+WYLlwdAojvR6/fxG25rQT+sKY5Dn1ohZXRE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JocxvH1+TArBftSrmjX8X/t9EgB4e+ayDR3t9HrEFJdCLH+ouDr0NxbsXvKmz59XS
         CRSomupkkE/6iOEtIPZbQLa6tcU3hEiqWb8OEaW9V1Is4Rf8UfOIqxdZeq1OLepk1N
         TFRiM4i03yFDYgYUNUZiNkX/33xRDkU1qqZ18YJAtf3cVMZWo4mD4+QlpJ3WYAKlnd
         H1GWbnLEFEjoWnvQZxijUODUrGlD5XhPcXjmYNdW7YAGvdL+2TVcPIV5dml568G+Ak
         x73LJ6ActKw4GV/TfHAvHyJoANHfosb4nbynHdXzH4/mqIMP/1HLunwmohznygUjHC
         wbBamUHL0zpRQ==
Date:   Wed, 12 Oct 2022 20:16:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Wei Wang <weiwan@google.com>, Eric Dumazet <edumazet@google.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH net-next] net-memcg: pass in gfp_t mask to
 mem_cgroup_charge_skmem()
Message-ID: <20221012201650.3e55331d@kernel.org>
In-Reply-To: <20221012184050.5a7f3bde@kernel.org>
References: <20210817194003.2102381-1-weiwan@google.com>
        <20221012163300.795e7b86@kernel.org>
        <CALvZod5pKzcxWsLnjUwE9fUb=1S9MDLOHF950miF8x8CWtK5Bw@mail.gmail.com>
        <20221012173825.45d6fbf2@kernel.org>
        <20221013005431.wzjurocrdoozykl7@google.com>
        <20221012184050.5a7f3bde@kernel.org>
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

On Wed, 12 Oct 2022 18:40:50 -0700 Jakub Kicinski wrote:
> Did the fact that we used to force charge not potentially cause
> reclaim, tho?  Letting TCP accept the next packet even if it had
> to drop the current one?

I pushed this little nugget to one affected machine via KLP:

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 03ffbb255e60..c1ca369a1b77 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -7121,6 +7121,10 @@ bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
                return true;
        }
 
+       if (gfp_mask == GFP_NOWAIT) {
+               try_charge(memcg, gfp_mask|__GFP_NOFAIL, nr_pages);
+               refill_stock(memcg, nr_pages);
+       }
        return false;
 }

The problem normally reproes reliably within 10min -- 30min and counting
and the application-level latency has not spiked.
