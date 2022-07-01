Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F338562980
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 05:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233976AbiGADRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 23:17:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233948AbiGADRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 23:17:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B10FB64D4E
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 20:17:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D41C62198
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 03:17:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717DEC34115;
        Fri,  1 Jul 2022 03:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656645430;
        bh=biGYCsqe7IJjoIUN6ICxo1ZU1IFtuOLCZ+AsEAgycJM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uFKsUkSFwiW6NAAH1w56etD1j+7+HZmZIouS0vDmmqgHKhUhZJwqdfUC6p9ehG6sC
         2PCJps8KYJ/TnnUUvbpG2wFcu4a64/YLaPnvcnmXSMslfEby+aIgYHE9SLU98ekT3t
         M2pokFg3ot64IiymcqbaoQcGJJHOZk4Gm2rWb/oUZd+6FQ22K5glNwq3069PqH+RkX
         7F/ItNTVWGj/e05ycwbdvmNK9/MVcanW+Qy5xXU/D2Aq+AN5bZzYi/wyyJrVJZxspw
         2U24wkdqf93C5MSn4JK6X/gHWWxDuMEIhP7y+700Be8oBdBe0FIfAriV0w/q/5l3DI
         MVLfrDYGxKKPQ==
Date:   Thu, 30 Jun 2022 20:17:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com
Subject: Re: [PATCH net-next 01/13] mlxsw: Configure egress VID for unicast
 FDB entries
Message-ID: <20220630201709.6e66a1bb@kernel.org>
In-Reply-To: <20220630082257.903759-2-idosch@nvidia.com>
References: <20220630082257.903759-1-idosch@nvidia.com>
        <20220630082257.903759-2-idosch@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jun 2022 11:22:45 +0300 Ido Schimmel wrote:
> From: Amit Cohen <amcohen@nvidia.com>
> 
> Using unified bridge model, firmware no longer configures the egress VID
> "under the hood" and moves this responsibility to software.
> 
> For layer 2, this means that software needs to determine the egress VID
> for both unicast (i.e., FDB) and multicast (i.e., MDB and flooding) flows.
> 
> Unicast FDB records and unicast LAG FDB records have new fields - "set_vid"
> and "vid", set them. For records which point to router port, do not set
> these fields.

clang seems to have a legitimate complaint:

drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c:2928:6: warning: variable 'mlxsw_sp_port_vlan' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
        if (mlxsw_sp_fid_is_dummy(mlxsw_sp, fid))
            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c:2948:11: note: uninitialized use occurs here
                                      mlxsw_sp_port_vlan->vid, adding, true);
                                      ^~~~~~~~~~~~~~~~~~
drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c:2928:2: note: remove the 'if' if its condition is always false
        if (mlxsw_sp_fid_is_dummy(mlxsw_sp, fid))
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c:2923:6: warning: variable 'mlxsw_sp_port_vlan' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
        if (!mlxsw_sp_port) {
            ^~~~~~~~~~~~~~
drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c:2948:11: note: uninitialized use occurs here
                                      mlxsw_sp_port_vlan->vid, adding, true);
                                      ^~~~~~~~~~~~~~~~~~
drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c:2923:2: note: remove the 'if' if its condition is always false
        if (!mlxsw_sp_port) {
        ^~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c:2907:47: note: initialize the variable 'mlxsw_sp_port_vlan' to silence this warning
        struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan;
                                                     ^
                                                      = NULL
