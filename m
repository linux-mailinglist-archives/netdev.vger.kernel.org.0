Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A29563DACE
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 17:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbiK3Qgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 11:36:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbiK3QgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 11:36:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76CEC813A5
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 08:36:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1FA0FB81BBA
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 16:36:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B137C433C1;
        Wed, 30 Nov 2022 16:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669826180;
        bh=YRNv+MXGByMvdoWB5Mglfd3gljCb+jCu8JuCyCavihc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tOUrP2V6WM3C21auiik1eXTAZsi1QvGHG+1gsPZzenxDUE/VLEpL2hDpLTMbbaXSO
         OzhOW/tecQJVsL0FG3EbW0Q3CaqkMmeKiTvgSSfFuHYsce+aNlZIXfhS36ANdIsW+w
         zPrgNDIlxnZSqIJAJDTansSY6DqzSh+RpIOJdAykIzFNG9biGK32IFCcKwglnkWtHY
         fQPAHRRBrL9Z8jp6zfXqnQRUfsyeH5+COd9ZXquu9vCUBYotTwqf/ioetYdZ51TvUy
         S/NTZMSadsICyp6jwthiV9kzAzfZMlRnG4bNi5j/Nf/uuLLtzs3ByRTa1lodqQO1z9
         FAxuxxFtbXGew==
Date:   Wed, 30 Nov 2022 08:36:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jiri Pirko <jiri@resnulli.us>, Ido Schimmel <idosch@idosch.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        netdev@vger.kernel.org, jiri@nvidia.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net] net: devlink: fix UAF in
 devlink_compat_running_version()
Message-ID: <20221130083618.52596d05@kernel.org>
In-Reply-To: <Y4caLsLEQFMgz7HV@unreal>
References: <405f703b-b97e-afdd-8d5f-48b8f99d045d@huawei.com>
        <Y33OpMvLcAcnJ1oj@unreal>
        <fa1ab2fb-37ce-a810-8a3f-b71d902e8ff0@huawei.com>
        <Y35x9oawn/i+nuV3@shredder>
        <20221123181800.1e41e8c8@kernel.org>
        <Y4R9dT4QXgybUzdO@shredder>
        <Y4SGYr6VBkIMTEpj@nanopsycho>
        <20221128102043.35c1b9c1@kernel.org>
        <Y4XDbEWmLRE3D1Bx@nanopsycho>
        <20221129181826.79cef64c@kernel.org>
        <Y4caLsLEQFMgz7HV@unreal>
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

On Wed, 30 Nov 2022 10:54:06 +0200 Leon Romanovsky wrote:
> In parallel thread, Jiri wanted to avoid this situation of netlink
> notifications for not-visible yet object. He gave as an example
> devlink_port which is advertised without devlink being ready.

To be clear the exact ordering matters much less in my scheme,
because the user space caller will wait for the instance lock
before checking if the instance is registered. So an early user 
request will just sleep on the instance lock until init is done.
