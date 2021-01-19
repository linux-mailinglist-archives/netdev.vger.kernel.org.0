Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE1302FC350
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 23:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729484AbhASWXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 17:23:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:50916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729409AbhASWXh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 17:23:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 520D322E01;
        Tue, 19 Jan 2021 22:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611094976;
        bh=niDRueobfQSw7qRh3wm0hADAEsU9O4M6jpKIPzKJr38=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZLeTn6Afeg0srzQzcNn0I9Nm5ZObyawYnbUwJCLPc7ZUBCTIl1q6w4Q2m3J1nEUYG
         QBG/hXYp7KRGZSKRIdc8oBCfps/FMPZPYuOzrZXmOOIUEj2RcHHPhVUT8duL+c+gNk
         oW4sAyfUxS3ILNT8RfJ6BpKIwblMdwMY+ubqlIybQYKP7eRMiPGM0tbA0Mq9RZiut7
         GdNsVJFGyxEBGtdYvjLKsEUJHELwbJm0fRpqh5r1xNANMP33PYQkLnbCZw1YcPWMfk
         11En8+Vgwg8w0YIZSucad67vZpQf/spdyBm0GnpZeb6RDUuQ2u6cGyfXVdk9An7r31
         lr86SD3TkZXTQ==
Date:   Tue, 19 Jan 2021 14:22:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, petrm@nvidia.com,
        jiri@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 0/5] mlxsw: Add support for RED qevent "mark"
Message-ID: <20210119142255.1caca7fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210117080223.2107288-1-idosch@idosch.org>
References: <20210117080223.2107288-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 17 Jan 2021 10:02:18 +0200 Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> The RED qdisc currently supports two qevents: "early_drop" and "mark". The
> filters added to the block bound to the "early_drop" qevent are executed on
> packets for which the RED algorithm decides that they should be
> early-dropped. The "mark" filters are similarly executed on ECT packets
> that are marked as ECN-CE (Congestion Encountered).
> 
> A previous patchset has offloaded "early_drop" filters on Spectrum-2 and
> later, provided that the classifier used is "matchall", that the action
> used is either "trap" or "mirred", and a handful or further limitations.

For early_drop trap or mirred makes obvious sense, no explanation
needed.

But for marked as a user I'd like to see a _copy_ of the packet, 
while the original continues on its marry way to the destination.
I'd venture to say that e.g. for a DCTCP deployment mark+trap is
unusable, at least for tracing, because it distorts the operation 
by effectively dropping instead of marking.

Am I reading this right?

If that is the case and you really want to keep the mark+trap
functionality - I feel like at least better documentation is needed.
The current two liner should also be rewritten, quoting from patch 1:

> * - ``ecn_mark``
>   - ``drop``
>   - Traps ECN-capable packets that were marked with CE (Congestion
>     Encountered) code point by RED algorithm instead of being dropped

That needs to say that the trap is for datagrams trapped by a qevent.
Otherwise "Traps ... instead of being dropped" is too much of a
thought-shortcut, marked packets are not dropped.

(I'd also think that trap is better documented next to early_drop,
let's look at it from the reader's perspective)
