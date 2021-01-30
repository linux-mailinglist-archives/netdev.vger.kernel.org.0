Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1CD73093A2
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 10:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232006AbhA3JpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 04:45:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:44330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231904AbhA3Jn4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Jan 2021 04:43:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA55664E09;
        Sat, 30 Jan 2021 06:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611987777;
        bh=fD0zqLA4rxCeHjN+YspWd9sPj+WUaZ3o7DTmA2KRtMo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rP/6uKNPvOO1xQgHSIiJENxCItDl2a+v/+PxZRFwzBxqZBTny4pMzQlh5cxoZdOu+
         lXfQYG3V8ohRgy34AJebsVPiIrWWyH7b5h6qWODvTu7gi3Aan1S1qXIw6jlUZ4M/Kb
         WsNycumtMbQBHaRz2Lf1J0RgUepWbCd+p03F6OSeANT0uTNjRl6UK3WdpA/Nh2S1wg
         5uQ4iC8tLbYyExiFUaIECOhywy+tRsCzNgapf3aAZjTy+zpaFRLvG7fRCBfJcTntnp
         TiiGqVN9mpk2x52Jwy2UCMxm5gIeA2aYM3ZfQtBe4FlG6ZupWT9oy4q3FebGepUudS
         Dk02B9FcldY9A==
Date:   Fri, 29 Jan 2021 22:22:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, Kai-Heng Feng <kai.heng.feng@canonical.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        Sasha Neftin <sasha.neftin@intel.com>
Subject: Re: [PATCH net 1/4] igc: Report speed and duplex as unknown when
 device is runtime suspended
Message-ID: <20210129222255.5e7115bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210128213851.2499012-2-anthony.l.nguyen@intel.com>
References: <20210128213851.2499012-1-anthony.l.nguyen@intel.com>
        <20210128213851.2499012-2-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jan 2021 13:38:48 -0800 Tony Nguyen wrote:
> From: Kai-Heng Feng <kai.heng.feng@canonical.com>
> 
> Similar to commit 165ae7a8feb5 ("igb: Report speed and duplex as unknown
> when device is runtime suspended"), if we try to read speed and duplex
> sysfs while the device is runtime suspended, igc will complain and
> stops working:

> The more generic approach will be wrap get_link_ksettings() with begin()
> and complete() callbacks, and calls runtime resume and runtime suspend
> routine respectively. However, igc is like igb, runtime resume routine
> uses rtnl_lock() which upper ethtool layer also uses.
> 
> So to prevent a deadlock on rtnl, take a different approach, use
> pm_runtime_suspended() to avoid reading register while device is runtime
> suspended.

Is someone working on the full fix to how PM operates?

There is another rd32(IGC_STATUS) in this file which I don't think 
is protected either. 
