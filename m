Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6C1651563
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 23:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232908AbiLSWLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 17:11:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232903AbiLSWK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 17:10:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E77B7EF
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 14:10:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BC2B6117A
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 22:10:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E22DC433D2;
        Mon, 19 Dec 2022 22:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671487801;
        bh=W2GBY944y5S4G37h0IBe2pE+J+Ty1ZBoCBMtHbJj7RQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bIHOim3kMJFlK1tVbIY28mY4rTguKl05xlvMhT/kG94buQ+47RdjOJ1Jx+LukCOFk
         IGh1dKJxIeKg3V29U7sBA/3+yMUC4DXcDficw5imGfvAu6H4zcR3JvgouCYHiFU7n3
         +nhH7HNEF/NwJIypkOhn+lMHY5u3k0lkEV4bNV9LuQt6zzefHe+WzePMAqkMotoGua
         dd4EP2AAbj4ounY2Pp8d8OBRv5XXo3ocHnOPN8NjWjIgXfSQ3uoAm/NzGkkajxeLjW
         cRtF7a77Bg52OPTdqU42Acewg4ZHHJj3B+cjH/J/wLEVuM6k9/joXI49RX6eMWAi5U
         NoBOYCNicib3A==
Date:   Mon, 19 Dec 2022 14:10:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     <jiri@resnulli.us>, <leon@kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [RFC net-next 00/10] devlink: remove the wait-for-references on
 unregister
Message-ID: <20221219141000.32c94617@kernel.org>
In-Reply-To: <3d169051-e095-6a2a-d5d8-409a5ad8af4b@intel.com>
References: <20221217011953.152487-1-kuba@kernel.org>
        <3d169051-e095-6a2a-d5d8-409a5ad8af4b@intel.com>
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

On Mon, 19 Dec 2022 09:38:09 -0800 Jacob Keller wrote:
> On 12/16/2022 5:19 PM, Jakub Kicinski wrote:
> > This set is on top of the previous RFC.
> > 
> > Move the registration and unregistration of the devlink instances
> > under their instance locks. Don't perform the netdev-style wait
> > for all references when unregistering the instance.
> 
> Could you explain the reasoning/benefits here? I'm sure some of this is
> explained in each commit message as well but it would help to understand
> the overall series.

Fair point, I'll add this:

  Yang Yingliang reported [1] a use-after-free in devlink because netdev
  paths are able to acquire a reference on the devlink instances before
  they are registered.

[1]
https://lore.kernel.org/all/20221122121048.776643-1-yangyingliang@huawei.com/
