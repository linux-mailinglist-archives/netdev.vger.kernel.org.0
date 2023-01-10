Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4CB66367A
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 01:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237643AbjAJAzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 19:55:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237532AbjAJAzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 19:55:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAA2434D67
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 16:55:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82E7DB80883
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 00:55:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2232C433EF;
        Tue, 10 Jan 2023 00:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673312102;
        bh=fycSserpBVX3akb/I+W7078+oqqtiOxV9x7jWoQDBEA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qp8q0rZtFptTgr2FlLH0PixiAWuVXoBWGAHm7Dg44gVkdUEmr12jEhaAIYYHCLwbB
         //cT9eHEzz/EzZyHygR7MvThLyA5j7UFZeTxbtoaDLDHM58Bt9YZ1crOc8vfXm8Sej
         WCSTQTsCszclFq9vXxLhYh6EntL5tK76YC+Ob+710isNAD/o0Ud5Exnl9F2EgO2eEh
         JtZiey+rPHhEmDWwaAi28ymYKPkvJLfplRDzO6mnWvcjG6a3xbjOLLRLaJtuk6jSda
         gUaHNU3gC919ivDuUTKdlXRjo+OeXf02YW+y0EjNebXd6d4AN2tTJieGNL/Fgxy2JM
         zuxSG4/08E7ZA==
Date:   Mon, 9 Jan 2023 16:55:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: Re: [patch net-next v3 01/11] devlink: remove devlink features
Message-ID: <20230109165500.3bebda0a@kernel.org>
In-Reply-To: <20230109183120.649825-2-jiri@resnulli.us>
References: <20230109183120.649825-1-jiri@resnulli.us>
        <20230109183120.649825-2-jiri@resnulli.us>
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

On Mon,  9 Jan 2023 19:31:10 +0100 Jiri Pirko wrote:
> Note that mlx5 used this to enable devlink reload conditionally only
> when device didn't act as multi port slave. Move the multi port check
> into mlx5_devlink_reload_down() callback alongside with the other
> checks preventing the device from reload in certain states.

Right, but this is not 100% equivalent because we generate the
notifications _before_ we try to reload_down:

	devlink_ns_change_notify(devlink, dest_net, curr_net, false);
	err = devlink->ops->reload_down(devlink, !!dest_net, action, limit, extack);
	if (err)
		return err;

IDK why, I haven't investigated.
