Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C61FA5FCEF4
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 01:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiJLXdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 19:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiJLXdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 19:33:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A2B8E8AA3;
        Wed, 12 Oct 2022 16:33:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 144F6615FE;
        Wed, 12 Oct 2022 23:33:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EFA8C43140;
        Wed, 12 Oct 2022 23:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665617582;
        bh=2Q43OD6ELjO061ruqIM9rlIj6RE37EF7791n2YoQok4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BJHMm2+JGCrZkkkXFcE+oWTKipjRdIU5JJxgbankq6nNuQk7d8hYuaNRINumrQmos
         ArgGoad04753zZFQZkEzJpG0rFKM3b6062n+MG0f/VFUKoxCk6+sB0r3DQwBkuxHdp
         Fv9J37lA7Mhc6oZLUZ6CYzHLP3anao1k1bLM4AP+RjeX8RmCgFDOziruJBItlkG3U+
         FnHEks/27iS777oDY4eYuGX/eSckqCbE+8OMhS3A6ViE1oL7mnJn06oPc6VmgH773Y
         uQeF8Y4jW4IsBMF8OojmQG2KTb6+sWPOUMneGGy94L3FbLlS1JyegVEy9xfaZmwgUa
         c09+by+jC6I2g==
Date:   Wed, 12 Oct 2022 16:33:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wei Wang <weiwan@google.com>, Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH net-next] net-memcg: pass in gfp_t mask to
 mem_cgroup_charge_skmem()
Message-ID: <20221012163300.795e7b86@kernel.org>
In-Reply-To: <20210817194003.2102381-1-weiwan@google.com>
References: <20210817194003.2102381-1-weiwan@google.com>
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

On Tue, 17 Aug 2021 12:40:03 -0700 Wei Wang wrote:
> Add gfp_t mask as an input parameter to mem_cgroup_charge_skmem(),
> to give more control to the networking stack and enable it to change
> memcg charging behavior. In the future, the networking stack may decide
> to avoid oom-kills when fallbacks are more appropriate.
> 
> One behavior change in mem_cgroup_charge_skmem() by this patch is to
> avoid force charging by default and let the caller decide when and if
> force charging is needed through the presence or absence of
> __GFP_NOFAIL.

This patch is causing a little bit of pain to us, to workloads running
with just memory.max set. After this change the TCP rx path no longer
forces the charging.

Any recommendation for the fix? Setting memory.high a few MB under
memory.max seems to remove the failures.
