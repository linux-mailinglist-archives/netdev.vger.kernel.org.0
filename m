Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA41A462EF5
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 09:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239863AbhK3I5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 03:57:49 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:53148 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239864AbhK3I5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 03:57:49 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 4C4CC1FD2F;
        Tue, 30 Nov 2021 08:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1638262469; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=djDnA+ME6UfUZnWzUVmeJ7d2dpPBA27usHWKRJj5kUg=;
        b=r/g9U57eILI24zaHOrQcOu14G5CeFpUMKP4B5opruF0sKFYL1NIyThjlTIsl97nvjVze/J
        rb2ErAsX9zzryv7R7wWM669wDQ2mAv7GWn0ouVKSeIQBR49y605yi7CHr3gaX3mwLtXlck
        1M2yxz9aV2nK8IM1SfvqSNL/h3ybrwc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1638262469;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=djDnA+ME6UfUZnWzUVmeJ7d2dpPBA27usHWKRJj5kUg=;
        b=wfu1ETjEjJrOeOLqUMPUvtcnOloUJOkzhMNN4hKguEvrxXmSd7a5WUNx68kvkoMsTCZtOV
        rb4TLLqHmtfqBgAQ==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 34295A3B8E;
        Tue, 30 Nov 2021 08:54:29 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 8FEF5607EF; Tue, 30 Nov 2021 09:54:26 +0100 (CET)
Date:   Tue, 30 Nov 2021 09:54:26 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, andrew@lunn.ch, pali@kernel.org,
        jacob.e.keller@intel.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 0/4] ethtool: Add ability to flash and query
 transceiver modules' firmware
Message-ID: <20211130085426.txa5xrrd3nipxgtz@lion.mk-sys.cz>
References: <20211127174530.3600237-1-idosch@idosch.org>
 <20211129093724.3b76ebff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YaXicrPwrHJoTi9w@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YaXicrPwrHJoTi9w@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 30, 2021 at 10:36:02AM +0200, Ido Schimmel wrote:
> On Mon, Nov 29, 2021 at 09:37:24AM -0800, Jakub Kicinski wrote:
> > 
> > Immediate question I have is why not devlink. We purposefully moved 
> > FW flashing to devlink because I may take long, so doing it under
> > rtnl_lock is really bad. Other advantages exist (like flashing
> > non-Ethernet ports). Ethtool netlink already existed at the time.
> 
> Device firmware flashing doesn't belong in devlink because of locking
> semantics. It belongs in devlink because you are updating the firmware
> of the device, which can instantiate multiple netdevs. For multi-port
> devices, it always seemed weird to tell users "choose some random port
> and use it for 'ethtool -f'". I remember being asked if the command
> needs to be run for all swp* netdevs (no).
> 
> On the other hand, each netdev corresponds to a single transceiver
> module and each transceiver module corresponds to a single netdev
> (modulo split which is a user configuration).

Devlink also has abstraction for ports so it can be used so it is not
necessarily a problem.

> In addition, users are already dumping the EEPROM contents of
> transceiver modules via ethtool and also toggling their settings.
> 
> Given the above, it's beyond me why we should tell users to use anything
> other than ethtool to update transceiver modules' firmware.

As I already mentioned, we should distinguish between ethtool API and
ethtool utility. It is possible to implement the flashing in devlink API
and let both devlink and ethtool utilities use that API.

I'm not saying ethtool API is a wrong choice, IMHO either option has its
pros and cons. I'm just trying to point out that implementation in
devlink API does not necessarily mean one cannot use the ethtool to use
the feature.

Michal
