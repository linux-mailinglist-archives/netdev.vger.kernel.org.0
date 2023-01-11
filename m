Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 058796664F9
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 21:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233742AbjAKUqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 15:46:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231469AbjAKUqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 15:46:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C092D87
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 12:46:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDB1161E2A
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 20:46:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F7DC433D2;
        Wed, 11 Jan 2023 20:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673469970;
        bh=kW0dPeQTEZNIJwu1/KrnA0HaIMR5mvB6lrf7poIL7qk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c/jsbNWoovLuf8g1f4n5OdomwrpC7kZKLmYD4W8TWZtF/g+Lcd/jGYCLki4TuFxB5
         0qosON5yAYnrkE/YQxaZECBhZp++VYDy8ru2VS7lko5tEI+iJdxWVW+ynFu+OaFP0O
         iMcASvyP1eJeX1WpVZTPpO1VZM4V7/2kymskDuE2R0PAb14BEYGoZI+bKDavsaId4T
         IhCXHH98lbPAwLMqiHT8otveO8lvXa1HbqMeNiUbxURsANbnDrQb4Qs4EVomtzWj9x
         zjnMm1Y1ro3dP9mGan44Zn9VF5yIv6Pu25WH+bzYbsPL/L3ggQbwZqH1djU/vketbG
         l8CBvwOuKs9CA==
Date:   Wed, 11 Jan 2023 12:46:08 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: Re: [net-next 08/15] net/mlx5e: Add hairpin debugfs files
Message-ID: <Y78gEBXP9BuMq09O@x130>
References: <20230111053045.413133-1-saeed@kernel.org>
 <20230111053045.413133-9-saeed@kernel.org>
 <20230111103422.102265b3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230111103422.102265b3@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11 Jan 10:34, Jakub Kicinski wrote:
>On Tue, 10 Jan 2023 21:30:38 -0800 Saeed Mahameed wrote:
>> +	debugfs_create_file("hairpin_num_queues", 0644, tc->dfs_root,
>> +			    &tc->hairpin_params, &fops_hairpin_queues);
>> +	debugfs_create_file("hairpin_queue_size", 0644, tc->dfs_root,
>> +			    &tc->hairpin_params, &fops_hairpin_queue_size);
>
>debugfs should be read-only, please LMK if I'm missing something,
>otherwise this series is getting reverted

I remember asking you about this and you said it's ok to use write for
debug features, this is needed for debugging performance bottlenecks.
hairpin + steering performance behaves differently between different
hardware versions and under different NIC/E-Switch configs, so it's really
important to have some control on some of these attributes when debugging.

Our dilemma was either to use devlink vendor params or a debug interface, 
since we are pretty sure that our NIC hairpin implementation
is unique as it uses software constructs (RQs/SQs) managed internally
by Firmware for abstraction of a TC redirect action, thus the only place
for this is either devlink vendor params or debugfs, we chose debugfs since
we want to keep this for debug purposes on production systems.

we also considered extending TC but again since this is unique to CX
architecture of the current chips, we didn't want to pollute TC.

Also devlink resource wasn't a good match since these resources don't
exist until a TC redirect action is offloaded.

Please let me know what you think and whether this is acceptable by you.

