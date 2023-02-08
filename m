Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9585568FB3E
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 00:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbjBHXf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 18:35:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjBHXfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 18:35:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E2A1717E
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 15:35:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BF476173A
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 23:35:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE21C433D2;
        Wed,  8 Feb 2023 23:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675899353;
        bh=Mv/NyrR+FEB3AUA/k1BxXnPoI/oAEoAFwIIhHPUq5jo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cmMhhLjKzp6CE9Tcpf7W1yvywczV2K2ZM/7/8hUhRbyQWxdmE8md5JhlMYvjmS8U5
         acb5dGgnRaqLGsR/oMwbPIyJH6nn+sR3edPStNegnUm2KPeyedZw/pHzM5yeAOqfMt
         fvdxVRZfD870OcOc6GzD/qRE8Q6KvlSkl2tM5XE/nWxm1iVKFIUK2LsmIKqPAh+235
         ZgrjmwzPxNawsqPd5FTy9nLlOAtkF3x84iJvSJ7cRQkRc8KTfWvIMDLS9YcdAi9hQP
         y8xBi9XjC2h/8ZxnlkialFh3GzngFgAMsIbsYH7tfsdOcoow5ZQPRWRmT30NsfylpD
         cvfELYmI1JIVg==
Date:   Wed, 8 Feb 2023 15:35:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
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
Message-ID: <20230208153552.4be414f6@kernel.org>
In-Reply-To: <Y+QWBFoz66KrsU7V@x130>
References: <20230206153603.2801791-1-simon.horman@corigine.com>
        <20230206153603.2801791-2-simon.horman@corigine.com>
        <20230206184227.64d46170@kernel.org>
        <Y+OFspnA69XxCnpI@unreal>
        <Y+OJVW8f/vL9redb@corigine.com>
        <Y+ONTC6q0pqZl3/I@unreal>
        <Y+OP7rIQ+iB5NgUw@corigine.com>
        <Y+QWBFoz66KrsU7V@x130>
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

On Wed, 8 Feb 2023 13:37:08 -0800 Saeed Mahameed wrote:
> I don't understand the difference between the two modes, 
> 1) "where VFs are associated with physical ports"
> 2) "another mode where all VFs are associated with one physical port"
> 
> anyway here how it works for ConnectX devices, and i think the model should
> be generalized to others as it simplifies the user life in my opinion.

I'm guessing the version of the NFP Simon posted this for behaves 
much like CX3 / mlx4. One PF, multiple Ethernet ports.
