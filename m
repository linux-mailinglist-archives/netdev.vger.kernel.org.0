Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A828691725
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 04:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbjBJDaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 22:30:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbjBJDaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 22:30:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76853EB42
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 19:30:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE8AF61C9C
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 03:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98583C433EF;
        Fri, 10 Feb 2023 03:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675999816;
        bh=PQxKjQxxVhlB+Oyg6VHbfPCg/KJt+nBvWEmNPL+ZNV4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CT2f7lqP3MCXsA2Otn5BMevzU9aN+A8AS/CbjqYKCXAtruI9jJ5nn2OQh+emGUaVY
         qUj5NKVDoM7KX56LaX4B88Sp9TTucIZVbLV/sw5N5k1RMbvEz7+OUJzK2e+hPix0Lx
         rnyPE+440eZ5DOJf6NWl2ynalDEUgSYGkLKwOSJWnBFkFGrt/Q22IOACMAV3XWFFuS
         OvD63uqKdMONPNH4JPx/66UMWdLLe6qDek/vvSuvzoOIeWenWLcw3cU1/BQqkKpEkf
         5YWebkWnhKJtC2OBre86AGeCUuySL5OueUOQ1TnSJ90EDjDkYWonp3QcJcDCZCLZYv
         2G5nzBJA6pAaA==
Date:   Thu, 9 Feb 2023 19:30:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yinjun Zhang <yinjun.zhang@corigine.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, Saeed Mahameed <saeed@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
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
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>
Subject: Re: [PATCH/RFC net-next 1/2] devlink: expose port function commands
 to assign VFs to multiple netdevs
Message-ID: <20230209193014.3aae3f26@kernel.org>
In-Reply-To: <DM6PR13MB37058D011EC0D1CB7DD72B7BFCDE9@DM6PR13MB3705.namprd13.prod.outlook.com>
References: <20230206153603.2801791-2-simon.horman@corigine.com>
        <20230206184227.64d46170@kernel.org>
        <Y+OFspnA69XxCnpI@unreal>
        <Y+OJVW8f/vL9redb@corigine.com>
        <Y+ONTC6q0pqZl3/I@unreal>
        <Y+OP7rIQ+iB5NgUw@corigine.com>
        <Y+QWBFoz66KrsU7V@x130>
        <20230208153552.4be414f6@kernel.org>
        <Y+REcLbT6LYLJS7U@x130>
        <DM6PR13MB37055FC589B66F4F06EF264FFCD99@DM6PR13MB3705.namprd13.prod.outlook.com>
        <Y+UOLkAWD0yCJHCb@nanopsycho>
        <DM6PR13MB37058D011EC0D1CB7DD72B7BFCDE9@DM6PR13MB3705.namprd13.prod.outlook.com>
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

On Fri, 10 Feb 2023 02:14:27 +0000 Yinjun Zhang wrote:
> I understand in switchdev mode, the fine-grained manipulation by TC can do it.
> While legacy has fixed forwarding rule, and we hope it can be implemented without
> too much involved configuration from user if they only want legacy forwarding.
> 
> As multi-port mapping to one PF NIC is scarce, maybe we should implement is as
> vendor specific configuration, make sense?

Vendor extension or not we are disallowing adding configuration 
for legacy SR-IOV mode. We want people to move to switchdev mode,
otherwise we'll have to keep extending both for ever.
