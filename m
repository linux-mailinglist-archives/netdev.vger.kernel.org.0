Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE1BC68FC3C
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 01:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbjBIAzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 19:55:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjBIAzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 19:55:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A53A211643
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 16:55:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55B05B81FE2
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 00:55:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4FBFC4339B;
        Thu,  9 Feb 2023 00:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675904114;
        bh=L2ZGYvOI3oWZjaGz3VY8bv2qrl3HhMO+HR2is/pEiv8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DvyHPTatlg/5Xcc4ey2N40ctwGJJcyWo8P+kHYOy5lW+53v4BZU7IafdaNSDD3Cqr
         cGHY3CMZaiLjPsSvL8CyMFg2puyqDAtwfrk9CBFV2zuifh3MFnPfX/sf8kQn3D2XED
         Mn+rBqdRJP7W1YAryGrPpn8hfDuuG6efkLJ9GvY9a1WIhxS0ejObq1Cg30MLpqF94K
         L1CWJb5YArrNVQ2kDBpevtvCuovZHJjqdCLVeKV7QNFSmedpBG9LoQuZ4cnbH9fhrZ
         745Nd5E6Isbno/JhHGn2hZ9jaGmccklLxYMjACAbDRoMavoQoNX5wHqBJVDcAohIvM
         zmGu6KgP5gJ7g==
Date:   Wed, 8 Feb 2023 16:55:12 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Simon Horman <simon.horman@corigine.com>,
        Leon Romanovsky <leon@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Gal Pressman <gal@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, Fei Qin <fei.qin@corigine.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: Re: [PATCH/RFC net-next 1/2] devlink: expose port function commands
 to assign VFs to multiple netdevs
Message-ID: <Y+REcLbT6LYLJS7U@x130>
References: <20230206153603.2801791-1-simon.horman@corigine.com>
 <20230206153603.2801791-2-simon.horman@corigine.com>
 <20230206184227.64d46170@kernel.org>
 <Y+OFspnA69XxCnpI@unreal>
 <Y+OJVW8f/vL9redb@corigine.com>
 <Y+ONTC6q0pqZl3/I@unreal>
 <Y+OP7rIQ+iB5NgUw@corigine.com>
 <Y+QWBFoz66KrsU7V@x130>
 <20230208153552.4be414f6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230208153552.4be414f6@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08 Feb 15:35, Jakub Kicinski wrote:
>On Wed, 8 Feb 2023 13:37:08 -0800 Saeed Mahameed wrote:
>> I don't understand the difference between the two modes,
>> 1) "where VFs are associated with physical ports"
>> 2) "another mode where all VFs are associated with one physical port"
>>
>> anyway here how it works for ConnectX devices, and i think the model should
>> be generalized to others as it simplifies the user life in my opinion.
>
>I'm guessing the version of the NFP Simon posted this for behaves
>much like CX3 / mlx4. One PF, multiple Ethernet ports.

Then the question is, can they do PF per port and avoid such complex APIs ?


