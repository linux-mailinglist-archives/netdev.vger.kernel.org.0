Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE93C14FEFD
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 20:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgBBTtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 14:49:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:53090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726930AbgBBTs7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Feb 2020 14:48:59 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0782420658;
        Sun,  2 Feb 2020 19:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580672939;
        bh=Rlg0jY5Utlv0SsLl/gxSXQ7eRUpYyqUuR1hwFdO62w4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=u2NPP5SE6zfsKoYaErDN+HgdLFXE4GSI0mP1ZiyqLh9ccBWBWdifHryqwa1ynWl5P
         kGPZt52NpMYozlN0poAzZAqDlsTLigKZU0Ygpg3nEwxYs97SjNf+5X4g1JEPloYVF+
         vt2Acgr5U7piQXy7a8FXXa/00TRh1+29URkWW1JI=
Date:   Sun, 2 Feb 2020 11:48:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Raed Salem <raeds@mellanox.com>
Cc:     john.fastabend@gmail.com, daniel@iogearbox.net,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net] tls: handle NETDEV_UNREGISTER for tls device
Message-ID: <20200202114858.38cf7946@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <1580642572-21096-1-git-send-email-raeds@mellanox.com>
References: <1580642572-21096-1-git-send-email-raeds@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  2 Feb 2020 13:22:52 +0200, Raed Salem wrote:
> This patch to handle the asynchronous unregister

By asynchronous you mean callback, right?

> device event so the device tls offload resources
> could be cleanly released.

Please tell us how you trigger the error, code is rather self
explanatory.. 

Note that TLS offload can only be installed when device is UP:

	down_read(&device_offload_lock);
	if (!(netdev->flags & IFF_UP)) {
		rc = -EINVAL;
		goto release_lock;
	}

Is there an unregister that doesn't close first?

> Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
> Signed-off-by: Raed Salem <raeds@mellanox.com>
> Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
> Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>

