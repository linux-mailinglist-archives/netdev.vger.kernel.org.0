Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAF8D67D211
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 17:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbjAZQq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 11:46:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjAZQq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 11:46:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 118EF4EE1
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 08:46:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A67FB81EB7
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 16:46:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D9DC4339B;
        Thu, 26 Jan 2023 16:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674751582;
        bh=t0FvtyzYoHprJd4E/BEfIItrovJAUK2ZKHWtaiAl5vE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hijWm2i52+GEKVqVZtU79msD0Ha+F2A10zIWfm0QbsD/JfXkm6NTMrJuNlcXpZXV8
         5mWIrj2CaJp9dGihbyRAdXVzzhggtZn/EKfAihenx/yFbisyhNHkB5xTMhosq3Z1MA
         K4gjcOfeJducuY3bIa/GyKh3SmD/hc3Naffl3BWENDz3wq1xBfdNyewCHeMyQKzdw1
         m0Wakta6BQob9m/u7zLNFCf2L6VZO+o4J0vxG5BrpixSuJn09/Jx8M2XeBa3U8Z5BE
         h6bV4k0hbzqFSMnwhtaZIgdDcdSsuSVj6D3eNVw4FZI2AM5huFTcW2tcUqa6MKu/VL
         ABi3iWXZY3+pg==
Date:   Thu, 26 Jan 2023 08:46:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Roger Quadros <rogerq@kernel.org>
Subject: Re: [PATCH v2 net-next 00/15] ENETC mqprio/taprio cleanup
Message-ID: <20230126084620.154021f4@kernel.org>
In-Reply-To: <20230126125308.1199404-1-vladimir.oltean@nxp.com>
References: <20230126125308.1199404-1-vladimir.oltean@nxp.com>
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

On Thu, 26 Jan 2023 14:52:53 +0200 Vladimir Oltean wrote:
> The main goal of this patch set is to make taprio pass the mqprio queue
> configuration structure down to ndo_setup_tc() - patch 12/15. But mqprio
> itself is not in the best shape currently, so there are some
> consolidation patches on that as well.

Does not apply?
