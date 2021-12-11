Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 306344711A3
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 06:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbhLKFRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 00:17:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbhLKFRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 00:17:52 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094D2C061714
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 21:14:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4C916CE2D34
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 05:14:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B02DC004DD;
        Sat, 11 Dec 2021 05:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639199652;
        bh=fWOAuyxfZ7q+sSlxM5Ms64reDS08U22RmE2aQd/R1LQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c+UTiSYC+dNc99Kgzx2QcYgwyWxg6q5/8DxYd1UTAPmx9H91N6DHVff2UvEly2S1i
         H12s8lp1pbgh3N8185LXA7V07wamtGWPUfF6taL7j5fbbCTQEGuhD+Vt5WPPRmvIMd
         09445fb5SjVNgv8Xbpjw4J693z4mIMCuQ8cK9ZNJoKDLDwfQJbde3/ZMzEg1W29/MI
         WiyNLPn1rrenKurPtwW9vQ1zdNiZckUkMX5GZ6KMwmOigJAIMsUSSzI+gIttKWexNz
         kRlR59o8wkLnOLLAxYm7di6FtvxFRD2EMoSIY2RUl+kJ2asi1fOqKFUj527l504kol
         A164lfs8riFsQ==
Date:   Fri, 10 Dec 2021 21:14:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Kurt Kanzenbach <kurt@kmk-computers.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH net-next v1] net: dsa: mv88e6xxx: Trap PTP traffic
Message-ID: <20211210211410.62cf1f01@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87y24t1fvk.fsf@waldekranz.com>
References: <20211209173337.24521-1-kurt@kmk-computers.de>
        <87y24t1fvk.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Dec 2021 01:07:59 +0100 Tobias Waldekranz wrote:
> > At the moment the mv88e6xxx driver for mv88e6341 doesn't trap these messages
> > which leads to confusion when multiple end devices are connected to the
> > switch. Therefore, setup PTP traps. Leverage the already implemented policy
> > mechanism based on destination addresses. Configure the traps only if
> > timestamping is enabled so that non time aware use case is still functioning.  
> 
> Do we know how PTP is supposed to work in relation to things like STP?
> I.e should you be able to run PTP over a link that is currently in
> blocking?

Not sure if I'm missing the real question but IIRC the standard
calls out that PTP clock distribution tree can be different that
the STP tree, ergo PTP ignores STP forwarding state.
