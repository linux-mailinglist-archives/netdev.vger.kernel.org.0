Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 934EA63B5F6
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 00:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234653AbiK1XdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 18:33:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234702AbiK1XdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 18:33:21 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFF0012AD7
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 15:33:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3A0B3CE0F6D
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 23:33:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2692BC433C1;
        Mon, 28 Nov 2022 23:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669678396;
        bh=yHawFEjNfNAE4vkXIO0vIgq9VERM4G9XyZp+jjXngbY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hHmKcc2q6SYNEN82zJGzUav97r1SYZMXOO9K95bk3d1VD74em/QkSAotTIPZPbEeQ
         Q+Qgr7pPrH1RVzZ5giT/Gwd6tJ7UedX9uziENwddRXx7edifLQD8OrGuFFx2yNBuUS
         NFh4Bo4CxNW1mfaINznWxdvLzBLy+QjmnImSfOwBG+SgU6RNWHdGrAm/JJgKaWtuiB
         T25zWX81pOn/y5ZZjtnUD1cDYVOueVS7VAT98ArKqe+aspjQsGx4rWRqcwKS1maVLI
         8VA7Bzvmn2fg4WWo1vF3yUXDdunPbrEU+lcbsOE8RWZGTsBkrzDDExIhfWDwL8F6CT
         7IPnuxMB+DYPg==
Date:   Mon, 28 Nov 2022 15:33:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <shnelson@amd.com>
Cc:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net, mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, drivers@pensando.io,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: Re: [RFC PATCH net-next 06/19] pds_core: add FW update feature to
 devlink
Message-ID: <20221128153315.11535ddd@kernel.org>
In-Reply-To: <11905a1a-4559-1e44-59ea-3a02f924419b@amd.com>
References: <20221118225656.48309-1-snelson@pensando.io>
        <20221118225656.48309-7-snelson@pensando.io>
        <20221128102709.444e3724@kernel.org>
        <11905a1a-4559-1e44-59ea-3a02f924419b@amd.com>
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

On Mon, 28 Nov 2022 14:25:46 -0800 Shannon Nelson wrote:
> I don't think Intel selects which FW image to boot, but it looks like 
> mlxsw and nfp use the PARAM_GENERIC_FW_LOAD_POLICY to select between 
> DRIVER, FLASH, or DISK.  Shall I add a couple of generic SLOT_x items to 
> the enum devlink_param_fw_load_policy_value and use this API?  For example:
> 
> 	DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_SLOT_0,
> 	DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_SLOT_1,
> 	DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_SLOT_2,
> 	DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_SLOT_3,

Not the worst idea, although I presume normal FW flashing should switch
between slots to activate the new image by default? Which means the
action of fw flashing would alter the policy set by the user. A little
awkward from an API purist standpoint.

I'd just expose the active "bank" via netlink directly.

> I could then modify the devlink dev info printed to refer to fw_slot_0, 
> fw.slot_1, and fw.slot_2 instead of our vendor specific names.

Jake, didn't you have a similar capability in ice?

Knowing my memory I may have acquiesced to something in another driver
already. That said - I think it's cleaner if we just list the stored
versions per bank, no?
