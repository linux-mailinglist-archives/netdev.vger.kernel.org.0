Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A12290DBA
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 00:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404536AbgJPWaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 18:30:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:44976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391662AbgJPWaT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 18:30:19 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 224DC22201;
        Fri, 16 Oct 2020 22:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602887418;
        bh=QIhm6rh4cFWdK4I5sF0Dg/mxr6d+MjeS/vGS3QZH7YE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zXBcjuvED6yQMnI0tG7rBKOnl0CHVmSdg48KolA4qhKETrRMpT3AVec63jl6jafpT
         51Wq8VaVTZB7i4Mi+80RcniUj7dgC9FcPGaS+sRFoJ8hRGQZw/jKLdIVlahu7VZeFh
         N85Z8VOI81XAURJTkYJIkLRarQ7pIKQqtaAPBD+Q=
Date:   Fri, 16 Oct 2020 15:30:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kleber Sacilotto de Souza <kleber.souza@canonical.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "Alexander A. Klimov" <grandmaster@al2klimov.de>,
        Kees Cook <keescook@chromium.org>,
        Alexey Kodanev <alexey.kodanev@oracle.com>,
        dccp@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dccp: ccid: move timers to struct dccp_sock
Message-ID: <20201016153016.04bffc1e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201013171849.236025-2-kleber.souza@canonical.com>
References: <20201013171849.236025-1-kleber.souza@canonical.com>
        <20201013171849.236025-2-kleber.souza@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Oct 2020 19:18:48 +0200 Kleber Sacilotto de Souza wrote:
> From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> 
> When dccps_hc_tx_ccid is freed, ccid timers may still trigger. The reason
> del_timer_sync can't be used is because this relies on keeping a reference
> to struct sock. But as we keep a pointer to dccps_hc_tx_ccid and free that
> during disconnect, the timer should really belong to struct dccp_sock.
> 
> This addresses CVE-2020-16119.
> 
> Fixes: 839a6094140a (net: dccp: Convert timers to use timer_setup())
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> Signed-off-by: Kleber Sacilotto de Souza <kleber.souza@canonical.com>

I've been mulling over this fix.

The layering violation really doesn't sit well.

We're reusing the timer object. What if we are really unlucky, the
fires and gets blocked by a cosmic ray just as it's about to try to
lock the socket, then user manages to reconnect, and timer starts
again. Potentially with a different CCID algo altogether?

Is disconnect ever called under the BH lock?  Maybe plumb a bool
argument through to ccid*_hc_tx_exit() and do a sk_stop_timer_sync()
when called from disconnect()?

Or do refcounting on ccid_priv so that the timer holds both the socket
and the priv?
