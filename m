Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD1F2F9040
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 03:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbhAQCzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 21:55:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:44558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727090AbhAQCzH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Jan 2021 21:55:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49B98206E9;
        Sun, 17 Jan 2021 02:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610852066;
        bh=vfsUFuW7gGiPst/6ZKfKHJ4oa7u6XK7YppotYAaltrE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Wk6iAni8bvJihMSRrPd3SRObl98a27K7kzllVrp/CnSUJWj00krCSth9GvwbD/4WO
         tzOKjTlyjPBhgwC6Te+TQ48w+cwCqmThw6Uqk5T8yeySXtQOFVdE3xyyO6rupUTZIO
         OlrG2tElcb8T0wGa8WR+I8AQBtBZL+0VnZaW3aANw4Y78e8wsIDZyE6zZVDDVbYxcR
         JU7pD5Zzh9RDF+QBqyCmQyDyRcAYeAAY1gpRl3tQCr7W4MvabrLkZoLsSCymu778po
         /ZHBoThhCQTXZtU/TdFlG7LvOu2hJmYXywrUjMT5P3QE4raPOhfAAM0FIw5a3SeJYc
         2Q4O8vcuBa40g==
Date:   Sat, 16 Jan 2021 18:54:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Boris Pismenny <borisp@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jarod Wilson <jarod@redhat.com>,
        Ivan Vecera <ivecera@redhat.com>
Subject: Re: [PATCH net-next V2 5/8] net/bonding: Implement TLS TX device
 offload
Message-ID: <20210116185425.17636415@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210114180135.11556-6-tariqt@nvidia.com>
References: <20210114180135.11556-1-tariqt@nvidia.com>
        <20210114180135.11556-6-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jan 2021 20:01:32 +0200 Tariq Toukan wrote:
> As the bond interface is being bypassed by the TLS module, interacting
> directly against the slaves, there is no way for the bond interface to
> disable its device offload capabilities, as long as the mode/policy
> config allows it.
> Hence, the feature flag is not directly controllable, but just reflects
> the current offload status based on the logic under bond_sk_check().

In that case why set it in ->hw_features ?
IIRC features set only in ->features but not ->hw_features show up to
userspace as "fixed" which I gather is what we want here, no?

> +#if IS_ENABLED(CONFIG_TLS_DEVICE)
> +	bond_dev->hw_features |= BOND_TLS_FEATURES;
> +	if (bond_sk_check(bond))
> +		bond_dev->features |= BOND_TLS_FEATURES;
> +#endif
