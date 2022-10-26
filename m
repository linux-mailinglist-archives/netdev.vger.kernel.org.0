Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56A5460E55B
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 18:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234601AbiJZQRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 12:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234415AbiJZQRn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 12:17:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CACB610A7EC
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 09:17:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36D1E61FA2
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 16:17:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F18DAC433C1;
        Wed, 26 Oct 2022 16:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666801060;
        bh=8QEk12W7sy52oMpghJI6kxQ1gsKPdRcXD+d5Y4G/iZY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U8i7s5dJd1uZhrK1LHDZnG27naiqp8kULqdwddcK6C/kN9aGEIzODfDMcw/XuYlmZ
         +mnu4Poi5+oKTjfbHJPPeRgPb3QXHGiuT6f8d8hC7DT+ViYp0tshsmISgxuSkHoqUO
         0nc/T+74bPB3Zgs6fX5VXTY8Kz9Mb3wFn9GTa6PkkrRsRulUumMvnaTBSeaAydpvK2
         r2l6hqTfpooP2xZBQ3LKSkGFuPSHsfr6gVjmJsjdTl6AnkQgLExmd0GLlNR2ukkuzn
         +XWGTZlvv48OZvV4mmmExr5U2E0iifp/rHv3YU6zHe4ULxjH2q8ScDrYBF1AM03IWe
         e8POhIsMUA4Kg==
Date:   Wed, 26 Oct 2022 09:17:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Roi Dayan <roid@nvidia.com>
Cc:     Amritha Nambiar <amritha.nambiar@intel.com>,
        netdev@vger.kernel.org, alexander.duyck@gmail.com,
        jhs@mojatatu.com, jiri@resnulli.us, xiyou.wangcong@gmail.com,
        vinicius.gomes@intel.com, sridhar.samudrala@intel.com,
        Maor Dickman <maord@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [net-next PATCH v3 1/3] act_skbedit: skbedit queue mapping for
 receive queue
Message-ID: <20221026091738.57a72c85@kernel.org>
In-Reply-To: <c04ab396-bea0-fcb2-7b5a-deafa3daffa5@nvidia.com>
References: <166633888716.52141.3425659377117969638.stgit@anambiarhost.jf.intel.com>
        <166633911976.52141.3907831602027668289.stgit@anambiarhost.jf.intel.com>
        <c04ab396-bea0-fcb2-7b5a-deafa3daffa5@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Oct 2022 14:40:39 +0300 Roi Dayan wrote:
> This patch broke mlx5_core TC offloads.
> We have a generic code part going over the enum values and have a list
> of action pointers to handle parsing each action without knowing the action.
> The list of actions depends on being aligned with the values order of
> the enum which I think usually new values should go to the end of the list.
> I'm not sure if other code parts are broken from this change but at
> least one part is.
> New values were always inserted at the end.
> 
> Can you make a fixup patch to move FLOW_ACTION_RX_QUEUE_MAPPING to
> the end of the enum list?
> i.e. right before NUM_FLOW_ACTIONS.

Odd, can you point us to the exact code that got broken?
There are no guarantees on ordering of kernel-internal enum
and I think it's a bad idea to make such precedent.
