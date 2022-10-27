Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 794E960F1EA
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 10:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234850AbiJ0IK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 04:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234899AbiJ0IKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 04:10:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD0AB43AC0
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 01:10:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64265B824E9
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 08:10:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7526DC433D6;
        Thu, 27 Oct 2022 08:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666858249;
        bh=EGss+lbcpZv9omK37tj4CeIMBujbXvfYax7DQtfaTMk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FEG1ElrDj3iP0wpEXgNb+4ux+DIQOCD9Goqhi5LG2LtWM/eY4gUO10RPGvq+k9TkZ
         3w62FCsTkad5IxryCiLr3JjFzTsoZeNS68KSEzM2S440+S2ckOw9Tk5hFqkcgEqx5H
         q+kNGZeU8+aHR2p6LPC6Kgqf41W4nGHb6BMja2GyH3KAf1vA+e8nUfhJmJXCzTojt5
         BuxlFGWJw94bF6CuWbLeyicCOv0XR9xpUI41euVI1w8qQWlezjJr2Lvj/4RwKC1jN2
         C+7Dhq4cbK3lhwrVzeyJCNoEYnzx+awUu7WGtjkapyhYlMEL7fc79EIceoJs/fOLro
         DG9fVQfw9m2TQ==
Date:   Thu, 27 Oct 2022 09:10:43 +0100
From:   Saeed Mahameed <saeed@kernel.org>
To:     Roi Dayan <roid@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
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
Message-ID: <20221027081043.agootcu3xjjetm3g@sx1>
References: <166633888716.52141.3425659377117969638.stgit@anambiarhost.jf.intel.com>
 <166633911976.52141.3907831602027668289.stgit@anambiarhost.jf.intel.com>
 <c04ab396-bea0-fcb2-7b5a-deafa3daffa5@nvidia.com>
 <20221026091738.57a72c85@kernel.org>
 <56977d26-5aca-1340-baba-5ba0cdbb9701@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <56977d26-5aca-1340-baba-5ba0cdbb9701@nvidia.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27 Oct 10:12, Roi Dayan wrote:
>
>
>On 26/10/2022 19:17, Jakub Kicinski wrote:
>> On Wed, 26 Oct 2022 14:40:39 +0300 Roi Dayan wrote:
>>> This patch broke mlx5_core TC offloads.
>>> We have a generic code part going over the enum values and have a list
>>> of action pointers to handle parsing each action without knowing the action.
>>> The list of actions depends on being aligned with the values order of
>>> the enum which I think usually new values should go to the end of the list.
>>> I'm not sure if other code parts are broken from this change but at
>>> least one part is.
>>> New values were always inserted at the end.
>>>
>>> Can you make a fixup patch to move FLOW_ACTION_RX_QUEUE_MAPPING to
>>> the end of the enum list?
>>> i.e. right before NUM_FLOW_ACTIONS.
>>
>> Odd, can you point us to the exact code that got broken?
>> There are no guarantees on ordering of kernel-internal enum
>> and I think it's a bad idea to make such precedent.
>
>
>ok. I were in the thought order is kept.
>
>You can see our usage in drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>in function parse_tc_actions().
>we loop over the actions and get a struct with function pointers
>that represent the flow action and we use those function pointers
>to parse whats needed without parse_tc_actions() knowing the action.
>
>the function pointers are in drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
>see static struct mlx5e_tc_act *tc_acts_fdb[NUM_FLOW_ACTIONS].
>each function handling code is in a different file under that sub folder.
>
>if order is not important i guess i'll do a function to return the ops i need
>per enum value.
>please let me know if to continue this road.
>thanks

Order is not guaranteed, let's have a robust solution.
You can define an explicit static mapping in the driver, not in a for loop.

