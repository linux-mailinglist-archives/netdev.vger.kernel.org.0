Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23D9349BAA8
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 18:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354844AbiAYRxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 12:53:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243629AbiAYRxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 12:53:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A58EC06173B
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 09:53:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C341B819DB
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 17:53:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AF05C340E0;
        Tue, 25 Jan 2022 17:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643133212;
        bh=bk7i+u0+BCEycnH9ujJxBXYeq0wbj7P4jlA8LQAr3Bk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gQFyFVYkGbZvG7CgRvtjbXj5LoEoQdJOGM18lMEyBr3R11ac1xkSzXYbbxMNcE/Aw
         ZbM11O/xrecX/579OMz6hAo5LtmVvv6shHwhTOVtDZHTaiZaNOkfehlguu7yo2193s
         W5RZMVXiewjz9hfUZhBfqnY1vz29r4kU4K5yrqIVrHfXBuQaU2z/jQo43H0m4kO8vG
         u6mGoeROxI7qAJsq8KagHRJnejvyFejRv0e5hrs0rg8Pw7VC88m7364y5aMMZkwAZo
         fY3b5r9IanBe5xp2i8lbppWsRmGrD3Il1bqr6qLaWp/5ipxCBD3s3Ow5w0Xl8g6/0p
         bEpW6y0fGaVyw==
Date:   Tue, 25 Jan 2022 09:53:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     edumazet@google.com, dsahern@gmail.com, pabeni@redhat.com,
        herbert@gondor.apana.org.au, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] ipv6: gro: flush instead of assuming
 different flows on hop_limit mismatch
Message-ID: <20220125095331.768dcc49@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220125044444.108785-1-kuba@kernel.org>
References: <20220125044444.108785-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Jan 2022 20:44:44 -0800 Jakub Kicinski wrote:
> IPv6 GRO considers packets to belong to different flows when their
> hop_limit is different. This seems counter-intuitive, the flow is
> the same. hop_limit may vary because of various bugs or hacks but
> that doesn't mean it's okay for GRO to reorder packets.
> 
> Practical impact of this problem on overall TCP performance
> is unclear, but TCP itself detects this reordering and bumps
> TCPSACKReorder resulting in user complaints.
> 
> Eric warns that there may be performance regressions in setups
> which do packet spraying across links with similar RTT but different
> hop count. To be safe let's target -next and not treat this
> as a fix. If the packet spraying is using flow label there should
> be no difference in behavior as flow label is checked first.
> 
> Note that the code plays an easy to miss trick by upcasting next_hdr
> to a u16 pointer and compares next_hdr and hop_limit in one go.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> --
> v2: resend for -next with the sparse false-positive addressed

In net-next now: 6fc2f3832d36 ("ipv6: gro: flush instead of assuming
different flows on hop_limit mismatch")
