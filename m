Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCFE305175
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239054AbhA0Eac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:30:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:55592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231230AbhA0Csp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 21:48:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CC51206C0;
        Wed, 27 Jan 2021 02:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611714686;
        bh=OZTC+guNPTnvsF855UeK89tRUMG50c9qlSVuTZnEfC0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jOInqI5hUWxx5rEYs1MhD1e9DiNaW1QIHOr0rEPihulgMtoly/brVKl50kqLX19Qx
         hV9k/K+N9EhRaeHa2ievTP8oEfLWl+GL+5HS6DUWNpiD2fp5lCyQdxnMi4MD6bMni9
         gBCdpZmrjZvzxL1ipOaEEe6iWRXJE1AAVto844R83Css5AtVZp/MTdyv7kkbxrGLWv
         YfpGxkbBtFyVkM+MEBHLONIYjmyu1qTgrV7gVfKCc+Hn2+Vi8MIy5l1W6jKxvdkSmZ
         5wUPPozm/CPVCQm8/na3wpRScuBdgnkdpOcdxs50OqTh1Z2pBuzIKcPtPbFbnH4Vv7
         75ceF3UioYJgg==
Date:   Tue, 26 Jan 2021 18:31:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexey Denisov <rtgbnm@gmail.com>
Cc:     bryan.whitehead@microchip.com, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] lan743x: fix endianness when accessing descriptors
Message-ID: <20210126183117.22514d0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210125090320.27954-1-rtgbnm@gmail.com>
References: <20210125090320.27954-1-rtgbnm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jan 2021 14:03:20 +0500 Alexey Denisov wrote:
> TX/RX descriptor ring fields are always little-endian, but conversion
> wasn't performed for big-endian CPUs, so the driver failed to work.
> 
> This patch makes the driver work on big-endian CPUs. It was tested and
> confirmed to work on NXP P1010 processor (PowerPC).
> 
> Signed-off-by: Alexey Denisov <rtgbnm@gmail.com>

Thanks for the patch, you need to adjust the types of the members and
variables as well, otherwise sparse - the Linux type checking tool -
will start returning warnings that you interpret as le32 something
declared as CPU byteorder.
