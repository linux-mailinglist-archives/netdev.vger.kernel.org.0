Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF55B2D3476
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 21:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729648AbgLHUo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 15:44:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:46828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728604AbgLHUo1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 15:44:27 -0500
Date:   Tue, 8 Dec 2020 11:27:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607455658;
        bh=pTp+T8fZ8pK7wJnQ8kEkNnOOcQdvT2U2tw2Hnanw8rg=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=lXGX2pgTvm39+vsLHG/YR8INs23R/Eb0IYWq757yo7bVQeKuZBpgKT8hY5+em5p+7
         UOqtuyIGKvJc+RDPFuuH90BrPMeDp2J5o1Nl7RN1xnNRiakrLpLuvg20rgUO9XVfER
         WTjMKx84R+Fu5dNINJCXK0isgLYC2BrmqKdQ5iA0n3w7xHtc+YT87mYGpcaNgQQaIE
         0aVON0FFDLXTjUeVHMyBPjMMM8JU2kjZxPe3yK3kjQuGrmbMYeyChxi7IAcEUlWVXl
         aRdNBn4Vp6hac8wD2HAvG1UYQEJJIxUWVhAM+13egZz0nSApMEAoopomZwmpHXFmAf
         piRZ1KDA4DEOg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jarod Wilson <jarod@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Ivan Vecera <ivecera@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: Re: [PATCH net v4] bonding: fix feature flag setting at init time
Message-ID: <20201208112730.05d13f3d@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201205172229.576587-1-jarod@redhat.com>
References: <20201203004357.3125-1-jarod@redhat.com>
        <20201205172229.576587-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  5 Dec 2020 12:22:29 -0500 Jarod Wilson wrote:
> Don't try to adjust XFRM support flags if the bond device isn't yet
> registered. Bad things can currently happen when netdev_change_features()
> is called without having wanted_features fully filled in yet. This code
> runs both on post-module-load mode changes, as well as at module init
> time, and when run at module init time, it is before register_netdevice()
> has been called and filled in wanted_features. The empty wanted_features
> led to features also getting emptied out, which was definitely not the
> intended behavior, so prevent that from happening.
> 
> Originally, I'd hoped to stop adjusting wanted_features at all in the
> bonding driver, as it's documented as being something only the network
> core should touch, but we actually do need to do this to properly update
> both the features and wanted_features fields when changing the bond type,
> or we get to a situation where ethtool sees:
> 
>     esp-hw-offload: off [requested on]
> 
> I do think we should be using netdev_update_features instead of
> netdev_change_features here though, so we only send notifiers when the
> features actually changed.
> 
> Fixes: a3b658cfb664 ("bonding: allow xfrm offload setup post-module-load")
> Reported-by: Ivan Vecera <ivecera@redhat.com>
> Suggested-by: Ivan Vecera <ivecera@redhat.com>

Applied, thanks!
