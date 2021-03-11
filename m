Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7C6336D32
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 08:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbhCKHid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 02:38:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231700AbhCKHhr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 02:37:47 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22042C061574;
        Wed, 10 Mar 2021 23:37:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=GbNcgOHLGMy86885Ok+FY4vdiVw9mClMYoLXE3N1vXM=; b=HjxHoey09FeabfFj1I3cyZMn2B
        7ROjoCZJZQQbbrRBKdptrni7pihXGdaqK5kxPEqWPukMh5VoYWf7HBrXJufrpkJfzNP82bkYh7bba
        l2jnUNnb4g2d/J1+CBzcKhb0A3+Q0e1tKPTSP0WRlV4ThoMrSHO/ovfI+ZlczFWQtwd+3FDiToUBK
        PS8J8fsYrG8knWTHZmnc0WJ4rW9MSpswRBYz1sJcjOkVDWS7wjmsy9L8BS3a9TYsV/aF2ykqPMUAJ
        OGIjOzZODj8rPYBCDA1A94GOU/TZ7X1f0AnkuBrmT/7Y0tPOFcBDCq2DgRbdqtMzTUB/GFdw1t/dI
        CkNX95QQ==;
Received: from [2001:4bb8:180:9884:c70:4a89:bc61:3] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lKFsz-006l7r-SA; Thu, 11 Mar 2021 07:37:35 +0000
Date:   Thu, 11 Mar 2021 08:37:32 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Felix Manlunas <felix.manlunas@cavium.com>,
        Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: module refcount issues in the liquidio driver
Message-ID: <YEnIvMOComLaaVa5@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

I just stumbled over the odd handling of module refcounts in the liquidio
driver.  The big red flag is the call to module_refcount in
liquidio_watchdog, which will do the wrong thing for any external module
refcount, like a userspace open.

But more importantly the whole concept of acquiring module refcounts from
inside the driver is pretty bogus.  What problem does this try to solve?


