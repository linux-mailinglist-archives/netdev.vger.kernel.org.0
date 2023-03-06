Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18E0E6ACE24
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 20:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbjCFTcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 14:32:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbjCFTca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 14:32:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2663572026;
        Mon,  6 Mar 2023 11:32:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE678B810CB;
        Mon,  6 Mar 2023 19:32:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4C0C433EF;
        Mon,  6 Mar 2023 19:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678131146;
        bh=L7gLqiiFYaP2XNBd2h5/Rsh8PZ4eC03xH916HWtC9BA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=k6g9cWan3rjrfLv6jU+Rca7cSMBm8BcX6LzWdAf/rK3elDL/LF/4xEkfX8h3oHdOx
         xQZC/QXY2wr6JDudhJFqNzRkOrbtCpzyUQrtk+OdhIKpQoEM99LELRJQzvwqa2X/VB
         FJiDVeUQBeU41dDTIxb+MhZvRBbJDpBKr72a75gAjSPII1DIhG1K46MH52oggwyc/i
         KgKAwj8bIyAmZvAF8SC6jpqaDS/TrewU+idhczWcldwoEDGAUu2NVq+oWmsQNV27Ah
         AAOIuSwl3TxAbEY00uD/ayrYoH/TDtwYC/5+7LdPuqfNfNMfkRcwjUQIGYOkVWhOMc
         g4ac7mtxS0erQ==
Date:   Mon, 6 Mar 2023 11:32:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, hawk@kernel.org,
        toke@redhat.com, memxor@gmail.com, alardam@gmail.com,
        lorenzo.bianconi@redhat.com
Subject: Re: [RFC net-next] ethtool: provide XDP information with
 XDP_FEATURES_GET
Message-ID: <20230306113225.6a087a4c@kernel.org>
In-Reply-To: <ZAYxolxpBtGZbO6m@lore-desk>
References: <ced8d727138d487332e32739b392ec7554e7a241.1678098067.git.lorenzo@kernel.org>
        <20230306102150.5fee8042@kernel.org>
        <ZAYxolxpBtGZbO6m@lore-desk>
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

On Mon, 6 Mar 2023 19:32:02 +0100 Lorenzo Bianconi wrote:
> So far the only way to dump the XDP features supported by the NIC is through
> libbpf running bpf_xdp_query(). I would say it is handy for a sysadmin to
> examine the XDP NIC capabilities in a similar way he/she is currently doing
> for the hw offload capabilities. Something like (I have an ethtool user-space
> patch not posted yet):

The sysadmin running linux-next or 6.3-rc1, that is? :)

The plan in my head is to package a tool like tools/net/ynl/cli.py for
sysadmins to use. Either package it with the specs or expose the specs
in sysfs like we expose BTF and kheaders.

I was hoping we can "give it a release or two" to get more experience
with the specs with just developers using them, 'cause once sysadmins
are using them we'll have to worry about backward compat.

But I don't want to hold you back so if the plan above sounds sensible
to you we can start executing on it, perhaps?

Alternative would be to teach ethtool or some other tool (new tool?)
to speak netdev genl, because duplicating the uAPI at the kernel level
really seems odd :(
