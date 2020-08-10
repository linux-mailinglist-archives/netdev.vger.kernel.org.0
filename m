Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2A9240B6B
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 18:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728016AbgHJQxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 12:53:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:50400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728000AbgHJQxM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Aug 2020 12:53:12 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68EBA20829;
        Mon, 10 Aug 2020 16:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597078391;
        bh=qll4ROc/iiSxpZbfUYAk6IGaJD6djwIBywiA409PpSo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f4Z0AEuObhXDWOorZOmIAP8AsvVIrAjKw76TZ3TRPz74NoXUpoMbQ/NlIn7nfARjz
         I/b0vt4TovXh3PIHae4xyqr7s6zwd0mVK9IzgYM5wA655XzZG3tWjUTyQaMNIPTkQd
         fYF3Pm8vYfu8DkQTAsSDC2pWeY5z8L5lSAohIpO4=
Date:   Mon, 10 Aug 2020 09:53:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        Jacob Keller <jacob.e.keller@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: Re: [PATCH net-next RFC 01/13] devlink: Add reload level option to
 devlink reload command
Message-ID: <20200810095305.0b9661ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <8b06ade2-dfbe-8894-0d6a-afe9c2f41b4e@mellanox.com>
References: <20200728130653.7ce2f013@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <04f00024-758c-bc19-c187-49847c24a5a4@mellanox.com>
        <20200729140708.5f914c15@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3352bd96-d10e-6961-079d-5c913a967513@mellanox.com>
        <20200730161101.48f42c5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <0f2467fd-ee2e-1a51-f9c1-02f8a579d542@mellanox.com>
        <20200803141442.GB2290@nanopsycho>
        <20200803135703.16967635@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200804100418.GA2210@nanopsycho>
        <20200804133946.7246514e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200805110258.GA2169@nanopsycho>
        <20200806112530.0588b3ac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <8b06ade2-dfbe-8894-0d6a-afe9c2f41b4e@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 9 Aug 2020 16:21:29 +0300 Moshe Shemesh wrote:
> Okay, so devlink reload default for mlx5 will include also fw-activate 
> to align with mlxsw default.
> 
> Meaning drivers that supports fw-activate will add it to the default.

No per-driver default.

Maybe the difference between mlxsw and mlx5 can be simply explained by
the fact that mlxsw loads firmware from /lib/firmware on every probe
(more or less).

It's only natural for a driver which loads FW from disk to load it on
driver reload.

> The flow of devlink reload default on mlx5 will be:
> 
> If there is FW image pending and live patch is suitable to apply, do 
> live patch and driver re-initialization.
> 
> If there is FW image pending but live patch doesn't fit do fw-reset and 
> driver-initialization.
> 
> If no FW image pending just do driver-initialization.

This sounds too complicated. Don't try to guess what the user wants.

> I still think I should on top of that add the level option to be 
> selected by the user if he prefers a specific action, so the uAPI would be:
> 
> devlink dev reload [ netns { PID | NAME | ID } ] [ level { fw-live-patch 
> | driver-reinit |fw-activate } ]

I'm all for the level/action.

> But I am still missing something: fw-activate implies that it will 
> activate a new FW image stored on flash, pending activation. What if the 
> user wants to reset and reload the FW if no new FW pending ? Should we 
> add --force option to fw-activate level ?

Since reload does not check today if anything changed - i.e. if reload
is actually needed, neither should fw-activate, IMO. I'd expect the
"--force behavior" to be the default.
