Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3554F691870
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 07:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbjBJGTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 01:19:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbjBJGTK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 01:19:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A315BA71
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 22:19:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E49D61CB7
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 06:19:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0313FC433EF;
        Fri, 10 Feb 2023 06:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676009948;
        bh=buAMJpgVNdlJLSorXT2KIxFdsp45sqq3TSWk3lR/ofE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pvPCSl7h4uLg3QfSg8oKzIVPLesKfZ4xYQtQsBCVDd4Eifp/AYJONtvzkgjmgp7Bp
         kNASLLCcZTHaM781QccPQ0pLETTBHIagnwOYdJLtzOwtIrBX33j09LMTTb3rJ9wcnY
         IcJLuKvFUxXV/+sYLqZl/nxaz/Ln6At56OuaK9Ei7j8nI5bdKvQ57a29IbSobGJLMU
         vvwBhBi08w/zEws98JKy+S+2IW5PrOeQBSzpp0mtmvB3aqRp6KY+UKoDf5Zxgo74F0
         VB+pd/Xmgy+dgtFyEg+qTWIt8Sb6t7msxry5GGghktZem/p+51X1iKWCUIHbvddj7o
         0VH3JZow9qWqg==
Date:   Thu, 9 Feb 2023 22:19:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, "Jiri Pirko" <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        "Simon Horman" <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: Re: [PATCH  net-next v3 2/9] net/sched: act_pedit, setup offload
 action for action stats query
Message-ID: <20230209221906.6a69c79f@kernel.org>
In-Reply-To: <20230206135442.15671-3-ozsh@nvidia.com>
References: <20230206135442.15671-1-ozsh@nvidia.com>
        <20230206135442.15671-3-ozsh@nvidia.com>
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

On Mon, 6 Feb 2023 15:54:35 +0200 Oz Shlomo wrote:
> +		for (k = 1; k < tcf_pedit_nkeys(act); k++) {
> +			last_cmd = cmd;
> +			cmd = tcf_pedit_cmd(act, k);
> +
> +			if (cmd != last_cmd) {
> +				NL_SET_ERR_MSG_MOD(extack, "Unsupported pedit command offload");
> +				return -EOPNOTSUPP;
> +			}

Is there a reason you're comparing to previous and not just always 
to the first one - since they all must be the same? 
