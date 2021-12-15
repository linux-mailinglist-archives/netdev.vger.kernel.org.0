Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B08DB47668B
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 00:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbhLOXdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 18:33:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231880AbhLOXdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 18:33:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62BBEC061574
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 15:33:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56E0D61B5C
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 23:33:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A42F5C36AE1;
        Wed, 15 Dec 2021 23:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639611191;
        bh=mL75OCkpyUdsVQ9BzAz/RObql3HiOQUzVZDUX+aP2fs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ho44ijtJoGTOykqBv74rwGAcq1drdc61BxQO7Kx49gWf5/UzJL/B6+MnJYjw+FbCt
         wticCgaByrOb1PCvkl1+Rxy0Sv1ZIHaZaJSiCcUHOIbWBRQQvtPKueR6WhiCfJ97eS
         wickQEFdFz/TxP00owk+h8dk1PJ6sM+Kli/YrzmVwgsbm8cQ6sOTtKjzQfnkwybXlS
         gK7moEj9yEK3JxxVcDUONWQgevmO4gJGlVi4To1uG9L5P7zGa+Gsnr36gwuHIYSYFA
         LJyfk56X/Bd504GJSoQ3MnlFE7ee8wV/kO8XW8lFK8J0zfa8pvnxqUrUK/rg9auDKy
         4d//pvMTeRa3Q==
Date:   Wed, 15 Dec 2021 15:33:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     Network Development <netdev@vger.kernel.org>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>
Subject: Re: Port mirroring (RFC)
Message-ID: <20211215153310.27367243@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <384e168b-8266-cb9b-196b-347a513c0d36@linaro.org>
References: <384e168b-8266-cb9b-196b-347a513c0d36@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Dec 2021 08:47:12 -0600 Alex Elder wrote:
> I am implementing what amounts to port mirroring functionality
> for the IPA driver.
> 
> The IPA hardware isn't exactly a network switch (it's sort of
> more than that), but it has the ability to supply replicas of
> packets transferred within it to a special (read only) interface.
> 
> My plan is to implement this using a new "ipa_mirror" network
> device, so it could be used with a raw socket to capture the
> arriving packets.  There currently exists one other netdev,
> which represents access through a modem to a WWAN network.
> 
> I would like some advice on how to proceed with this.  I want
> the result to match "best practice" upstream, and would like
> this to be as well integrated possible with existing network
> tools.
> 
> A few details about the stream of packets that arrive on
> this hardware interface:
> - Packet data is truncated if it's larger than a certain size
> - Each packet is preceded by a fixed-size header describing it
> - Packets (and their headers) are aggregated into a buffer; i.e.
>    a single receive might carry a dozen (truncated) packets
> 
> Here are a few specific questions, but I would love to get
> *any* feedback about what I'm doing.
> - Is representing this as a separate netdev a reasonable
>    thing to do?
> - Is there anything wrong with making a netdev read-only?
>    (Any packets supplied for transmit would be dropped)
> - Are there things I should do so it's clear this interface
>    does not carry IP traffic (or even UDP, etc.)?
> - Should the driver de-aggregate the received packets, i.e.
>    separating each into a separate SKB for reading?
> 
> I might have *many* more questions, but I'd just like to make
> sure I'm on the right track, and would like both specific and
> general suggestions about how to do this the right way.

Maybe the first question to ask is - why do you need this?
Or perhaps - how is it used? There's a significant difference 
between an interface for users and a debug interface.

Do you aim to give users control over the forwarding which happens
on the application processor at some point? If so Andrew and Florian
give great suggestions but starting from debugging of the forwarding
feels a little backward.
