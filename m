Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 872452BB2DB
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729964AbgKTS0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:26:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:47630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728002AbgKTS0i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:26:38 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D9EE2224C;
        Fri, 20 Nov 2020 18:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605896798;
        bh=sFNKrLDLK54f4Sp1AqlHs6UQ2fZdDbDcWqwJqTgIDkU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PVTnZbfxrziUP4qmHVBjxbAjkp4q6kinrT0UIg+rSLvyzApO7OGYjc1IsMsHvIGgu
         Qw5ztqDYie9903I/QoJ7CNKh+fUVcAF+BBoGSAO/+HZCASAPXdA8T3PvFMk3sSgBlX
         0m3xbP2Md/8GoW0+lX/bVuFGb8z2MvtFXJT/Y2B4=
Date:   Fri, 20 Nov 2020 10:26:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>, netdev@vger.kernel.org
Subject: Re: [net v3] net/tls: missing received data after fast remote close
Message-ID: <20201120102637.7d36a9f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1605801588-12236-1-git-send-email-vfedorenko@novek.ru>
References: <1605801588-12236-1-git-send-email-vfedorenko@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Nov 2020 18:59:48 +0300 Vadim Fedorenko wrote:
> In case when tcp socket received FIN after some data and the
> parser haven't started before reading data caller will receive
> an empty buffer. This behavior differs from plain TCP socket and
> leads to special treating in user-space.
> The flow that triggers the race is simple. Server sends small
> amount of data right after the connection is configured to use TLS
> and closes the connection. In this case receiver sees TLS Handshake
> data, configures TLS socket right after Change Cipher Spec record.
> While the configuration is in process, TCP socket receives small
> Application Data record, Encrypted Alert record and FIN packet. So
> the TCP socket changes sk_shutdown to RCV_SHUTDOWN and sk_flag with
> SK_DONE bit set. The received data is not parsed upon arrival and is
> never sent to user-space.
> 
> Patch unpauses parser directly if we have unparsed data in tcp
> receive queue.
> 
> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>

Applied, thanks!
