Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1694D33B5
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 17:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbiCIQOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 11:14:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234796AbiCIQOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 11:14:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9337184B53
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 08:11:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9869B82226
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 16:11:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53AC2C340F3;
        Wed,  9 Mar 2022 16:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646842277;
        bh=9QTPPkd1MEbihT/AbU5iRhXYGyP/qAcsDvE9kxTePs8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PBBfAH5lIRqQKDgGn2yPi+1XEtWLAcIvgXWprMgxHQCeBHZkf2y6MI5SJk1bAHkB3
         jTYXRRTG0yIpDyhIKnRBxQneqMI3PeaswrNw8yJrXwn4YXY0TZY+VsC+WVVmNH/m/c
         hEv1VtsyXrmCZnRu4mzYYiD8cr1v70a6LD8g+0v8hU7wZWTEqQwt8b/neY10YGTQEo
         e7gNczhrM8amWXZGCO2p5bH65DP9Vh1miUcq+/oRRDez6XM0umjSfMRGwN0k7cs1BR
         DTJ/TqWGvjP3ME0yVbo7ZZHDWmbKzmXvccJ75b6ISkgyJf/GONBqvj1wN5FikUtnP4
         8fvZqEImzmj9A==
Date:   Wed, 9 Mar 2022 08:11:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: Re: Revive zerocopy TLS sendfile
Message-ID: <20220309081116.5455a4ae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <DM4PR12MB5150C0ACA2781ABD70DB99E8DC0A9@DM4PR12MB5150.namprd12.prod.outlook.com>
References: <DM4PR12MB5150C0ACA2781ABD70DB99E8DC0A9@DM4PR12MB5150.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Mar 2022 08:48:16 +0000 Maxim Mikityanskiy wrote:
> We would like to revive the discussion on zerocopy sendfile support for
> TLS offload:
> 
> https://lore.kernel.org/all/1594551195-3579-1-git-send-email-borisp@mellanox.com/
> 
> I believe we can resolve the concern about correctness vs performance
> expressed in the previous discussion.
> 
> Historically, sendfile implementations for TCP and TLS allow changing
> the underlying file while sending it. The connection is not disrupted,
> but besides that there aren't many guarantees: the contents of the
> received file may be a mix of the old and new versions (a lost middle
> packet may be retransmitted with the new data, after the packets
> following it were received with the old data). The goal is to preserve
> this behavior for all existing users.
> 
> Zerocopy TLS sendfile provides even fewer guarantees: if a part of a TLS
> record is being retransmitted on TCP level, while the file is being
> changed, the receiver may get a TLS record with bad signature and close
> the connection. That means we can't simply replace the current behavior
> with zerocopy.

It is the ZC TLS sendfile w/ offload you mean here? We use the term ZC
for too many things :S

> On the other hand, even with such a limitation, zerocopy TLS sendfile is
> extremely useful in a very common use case of serving static files over
> HTTPS. Web files normally have formats that become damaged and useless
> after arbitrary partial updates. From that perspective, receiving a
> damaged file or closing the connection is equally bad for the client.
> Admins should normally avoid updating static files without stopping the
> server, but even if they don't follow this recommendation, zerocopy
> itself doesn't impair user experience compared to regular sendfile. At
> the same time, it boosts the TX speed by up to 25% and reduces CPU load
> by up to 12.5%.
> 
> Given that we would like to keep the current sendfile behavior for all
> existing users, while still being able to use acceleration of zerocopy
> in applicable scenarios, I suggest considering including zerocopy TLS
> sendfile as an opt-in feature. The default will always be non-zerocopy,
> and there will be no global sysctl knob to change it, so that it won't
> be possible to break existing applications. The users willing to use
> zerocopy deliberately will set a flag, for example, by setsockopt (or
> any other mechanism).
> 
> Most importantly, there is no concern of violating kernel integrity. The
> userspace won't be able to crash the kernel or bypass protection using
> the new feature. It also won't be able to trick the kernel into
> transmitting some data that the userspace can't send using a regular TCP
> socket.
> 
> What do you think about these points? Does zerocopy TLS sendfile have a
> future in the kernel as an opt-in feature?

Opt-in sounds reasonable to me.
