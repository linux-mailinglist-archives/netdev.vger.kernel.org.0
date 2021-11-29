Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA894625AB
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 23:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234414AbhK2Wmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 17:42:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233868AbhK2Wlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 17:41:47 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0903EC0C0860
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 09:37:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3025FCE13B1
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 17:37:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F22C53FC7;
        Mon, 29 Nov 2021 17:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638207446;
        bh=KUK+9Va24/nGi2WDRbIUnIKtk2Sli1sipJu3qPg3FBY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=I8S0ZV9j3RCip93brlGm7biDGsve/736e+QFEmr/5qTPCypo4ug6pIZ99ysBko8HN
         +Yc7lrBLoK4HvYr0LUpX2hKqOfIpSD98pcefN7A+XgTv7pZ6lLTSorEr62kp4at0MJ
         zlR8mmLmjLtWTiiU2eAMJScvd/HoLX65ZivMmPerdS3GLstuQ00PgaBlhmivr9BTj+
         PwZgcyJhWIHsdb6NI+OjhqGueuwAoq5H0XwMwfbSQ9aX+h/zOTlCTfhtRmrPsuoYY2
         Rx2D7paU1HUyITnlblMOhD/wv+iyaU7M4VVYF8+LH674nrsFThnagDXb8K2FyuTHgw
         QR44yJ+6y5ttQ==
Date:   Mon, 29 Nov 2021 09:37:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 0/4] ethtool: Add ability to flash and
 query transceiver modules' firmware
Message-ID: <20211129093724.3b76ebff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211127174530.3600237-1-idosch@idosch.org>
References: <20211127174530.3600237-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 27 Nov 2021 19:45:26 +0200 Ido Schimmel wrote:
> This patchset extends the ethtool netlink API to allow user space to
> both flash transceiver modules' firmware and query the firmware
> information (e.g., version, state).
> 
> The main use case is CMIS compliant modules such as QSFP-DD. The CMIS
> standard specifies the interfaces used for both operations. See section
> 7.3.1 in revision 5.0 of the standard [1].
> 
> Despite the immediate use case being CMIS compliant modules, the user
> interface is kept generic enough to accommodate future use cases, if
> these arise.
> 
> The purpose of this RFC is to solicit feedback on both the proposed user
> interface and the device driver API which are described in detail in
> patches #1 and #3. The netdevsim patches are for RFC purposes only. The
> plan is to implement the CMIS functionality in common code (under lib/)
> so that it can be shared by MAC drivers that will pass function pointers
> to it in order to read and write from their modules EEPROM.
> 
> ethtool(8) patches can be found here [2].

Immediate question I have is why not devlink. We purposefully moved 
FW flashing to devlink because I may take long, so doing it under
rtnl_lock is really bad. Other advantages exist (like flashing
non-Ethernet ports). Ethtool netlink already existed at the time.

I think device flashing may also benefit from the infra you're adding.
