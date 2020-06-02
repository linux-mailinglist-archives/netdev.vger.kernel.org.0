Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F641EC1C2
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 20:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgFBS1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 14:27:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:44478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726000AbgFBS1G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 14:27:06 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35412206E2;
        Tue,  2 Jun 2020 18:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591122425;
        bh=0ikuGlMb3+veLCaBgLdDqsIEYa6XdaBx4RugmcZHXLQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lnDRYafiR+a6Qgoi9YYhIPZJltsBsqZQiahCGPJQbUZEE3Tq56rrQ89fTJD/RavGH
         GtPPa40CfqaJS4S2XhuzYKMgJDDsX1bVbR79miw5tP5Gu7XfVdEl9fGpplgBNXbAxN
         Gr5tzIuhT2BNiirnRQHpPNmHmIcfuAgCQ5ja/FEg=
Date:   Tue, 2 Jun 2020 11:27:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Boris Pismenny <borisp@mellanox.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [net-next 10/11] net/mlx5e: kTLS, Add kTLS RX resync support
Message-ID: <20200602112703.13166ffa@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <c58e2276-81a1-5d4a-b6e1-b89fe076e8ba@mellanox.com>
References: <20200529194641.243989-1-saeedm@mellanox.com>
        <20200529194641.243989-11-saeedm@mellanox.com>
        <20200529131631.285351a5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <e0b8a4d9395207d553e46cb28e38f37b8f39b99d.camel@mellanox.com>
        <20200529145043.5d218693@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <27149ee9-0483-ecff-a4ec-477c8c03d4dd@mellanox.com>
        <20200601151206.454168ad@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <c58e2276-81a1-5d4a-b6e1-b89fe076e8ba@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Jun 2020 07:23:53 +0300 Boris Pismenny wrote:
> On 02/06/2020 1:12, Jakub Kicinski wrote:
> > On Sun, 31 May 2020 15:06:28 +0300 Boris Pismenny wrote:  
> >> On 30/05/2020 0:50, Jakub Kicinski wrote:
> >>  
> >>> IIUC every ooo packet causes a resync request in your
> >>> implementation - is that true?
> >>>     
> >> No, only header loss. We never required a resync per OOO packet. I'm
> >> not sure why would you think that.  
> > I mean until device is back in sync every frame kicks off
> > resync_update_sn() and tries to queue the work, right?
> >  
> Nope, only the first frame triggers resync_update_sn, so as to keep
> the process efficient and avoid spamming the system with resync
> requests. Per-flow, the device will try again to trigger
> resync_update_sn only if it gets out of sync due to out-of-sequence
> record headers.

It'd be good to clarify what the ooo counter counts in the
documentation, it sounds like it counts first TLS header HW found 
after seq discontinuity is detected?

In fact calling this a ooo counter may be slightly misleading, I like
the nfp counters much more: tx_tls_resync_req_ok and
tx_tls_resync_req_ign.
