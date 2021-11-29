Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34A58461D56
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 19:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235980AbhK2SKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 13:10:44 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:47176 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242755AbhK2SIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 13:08:44 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 2BE44212FE;
        Mon, 29 Nov 2021 18:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1638209125; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=M/UTxtY9Xc5/nnJZygS6hEcN1Eww61XtnRUeT3JFbb0=;
        b=C68oDD53LGWWfMyzrAVNUVMtNd5nwvs+qEhX++t9s+tcvT5Io1X9tSj5jML/aPg4mKREj9
        7zRK8bekUW0Mv5KPZR2YOqaSSMQk7ghO84m2UJjYRkUFpu8+KlgfvK1dlOtn5kGuorA6iO
        5BGlFsLEeiJhormhxWz4hHV2DPYKkOY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1638209125;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=M/UTxtY9Xc5/nnJZygS6hEcN1Eww61XtnRUeT3JFbb0=;
        b=QMqNs9f2/671NBw2MiepvfnG2TKMTxe399X3IsTShrokPJ11DJr35dYcSRnit+Rrg+vhXV
        5aIs6TeSfQidiICA==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 492E8A3B87;
        Mon, 29 Nov 2021 18:05:24 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 1790C602D5; Mon, 29 Nov 2021 19:05:21 +0100 (CET)
Date:   Mon, 29 Nov 2021 19:05:21 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, andrew@lunn.ch, pali@kernel.org,
        jacob.e.keller@intel.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 0/4] ethtool: Add ability to flash and query
 transceiver modules' firmware
Message-ID: <20211129180521.vk5au236ipjyhbua@lion.mk-sys.cz>
References: <20211127174530.3600237-1-idosch@idosch.org>
 <20211129093724.3b76ebff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129093724.3b76ebff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 29, 2021 at 09:37:24AM -0800, Jakub Kicinski wrote:
> On Sat, 27 Nov 2021 19:45:26 +0200 Ido Schimmel wrote:
> > This patchset extends the ethtool netlink API to allow user space to
> > both flash transceiver modules' firmware and query the firmware
> > information (e.g., version, state).
> > 
> > The main use case is CMIS compliant modules such as QSFP-DD. The CMIS
> > standard specifies the interfaces used for both operations. See section
> > 7.3.1 in revision 5.0 of the standard [1].
> > 
> > Despite the immediate use case being CMIS compliant modules, the user
> > interface is kept generic enough to accommodate future use cases, if
> > these arise.
> > 
> > The purpose of this RFC is to solicit feedback on both the proposed user
> > interface and the device driver API which are described in detail in
> > patches #1 and #3. The netdevsim patches are for RFC purposes only. The
> > plan is to implement the CMIS functionality in common code (under lib/)
> > so that it can be shared by MAC drivers that will pass function pointers
> > to it in order to read and write from their modules EEPROM.
> > 
> > ethtool(8) patches can be found here [2].
> 
> Immediate question I have is why not devlink. We purposefully moved 
> FW flashing to devlink because I may take long, so doing it under
> rtnl_lock is really bad. Other advantages exist (like flashing
> non-Ethernet ports). Ethtool netlink already existed at the time.

Note that ethtool (as userspace utility) can still provide the
functionality even if it's implemented in devlink API; this is likely
going to be the case for device EEPROM flash (ethtool -f). At the
moment, there is a problem that not nearly every device capable of
flashing implements devlink but that could be addressed by the "generic
devlink" idea (a wrapper implementing selected parts of devlink API for
devices without an actual devlink implementation).

Michal
