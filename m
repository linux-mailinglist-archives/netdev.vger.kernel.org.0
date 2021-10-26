Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E237B43A96F
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 02:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235790AbhJZAwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 20:52:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:54578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233234AbhJZAwO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 20:52:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6282B60C4B;
        Tue, 26 Oct 2021 00:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635209391;
        bh=L6/2soJkbNzpkTcZ7/gxJpFJX00HzVfIOo2Grjkb+XE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fMudTksHnfmxzOvxePrGwgpeHW4iC8wzK2Cr2/+tc66jkUEB1TVnTwqatgCWczfyw
         U80Z3PYQm2ZfMM321iTywUvOUk3dhaNxGRKWp7TgUDG4uLPnGAvGnz9zFYiJWfR5UM
         wfGsSm5hxlWSqlvBADlJ7ka0IAMxSUeBDxHe0VoH/Pe2iagg/TKWRfRsGK3sNwT56b
         r2K9BZSEYBhYI55X1OCAEwhSr0g/GqfFRrKdCQlnPkOWFRS3Anh72maJGAdZyGeh8O
         YkX2wHBH/RQuZfYEOEI08L6MurYOF8xc/F5sx8ZxcfRdGl1IGhAFOUq3gFcLi3gkYc
         rmdiGxDX8L9uQ==
Date:   Mon, 25 Oct 2021 17:49:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sven Eckelmann <sven@narfation.org>, mareklindner@neomailbox.ch
Cc:     sw@simonwunderlich.de, a@unstable.cc, davem@davemloft.net,
        Pavel Skripkin <paskripkin@gmail.com>,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+28b0702ada0bf7381f58@syzkaller.appspotmail.com
Subject: Re: [PATCH] net: batman-adv: fix error handling
Message-ID: <20211025174950.1bec22fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <2526100.mKikVBQdmv@sven-l14>
References: <2056331.oJahCzYEoq@sven-desktop>
        <20211024131356.10699-1-paskripkin@gmail.com>
        <2526100.mKikVBQdmv@sven-l14>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 24 Oct 2021 16:58:30 +0200 Sven Eckelmann wrote:
> On Sunday, 24 October 2021 15:13:56 CEST Pavel Skripkin wrote:
> > Syzbot reported ODEBUG warning in batadv_nc_mesh_free(). The problem was
> > in wrong error handling in batadv_mesh_init().
> > 
> > Before this patch batadv_mesh_init() was calling batadv_mesh_free() in case
> > of any batadv_*_init() calls failure. This approach may work well, when
> > there is some kind of indicator, which can tell which parts of batadv are
> > initialized; but there isn't any.
> > 
> > All written above lead to cleaning up uninitialized fields. Even if we hide
> > ODEBUG warning by initializing bat_priv->nc.work, syzbot was able to hit
> > GPF in batadv_nc_purge_paths(), because hash pointer in still NULL. [1]
> > 
> > To fix these bugs we can unwind batadv_*_init() calls one by one.
> > It is good approach for 2 reasons: 1) It fixes bugs on error handling
> > path 2) It improves the performance, since we won't call unneeded
> > batadv_*_free() functions.
> > 
> > So, this patch makes all batadv_*_init() clean up all allocated memory
> > before returning with an error to no call correspoing batadv_*_free()
> > and open-codes batadv_mesh_free() with proper order to avoid touching
> > uninitialized fields.
> > 
> > Link: https://lore.kernel.org/netdev/000000000000c87fbd05cef6bcb0@google.com/ [1]
> > Reported-and-tested-by: syzbot+28b0702ada0bf7381f58@syzkaller.appspotmail.com
> > Fixes: c6c8fea29769 ("net: Add batman-adv meshing protocol")
> > Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>  
> 
> Acked-by: Sven Eckelmann <sven@narfation.org>

FWIW I'm marking this as "Awaiting upstream" in netdev patchwork,
please LMK if you prefer for it to be applied directly.
