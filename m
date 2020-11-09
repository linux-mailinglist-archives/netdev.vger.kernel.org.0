Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D19CA2AB77F
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 12:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729706AbgKILsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 06:48:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49915 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgKILsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 06:48:39 -0500
Received: from 1.general.cascardo.us.vpn ([10.172.70.58] helo=mussarela)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <cascardo@canonical.com>)
        id 1kc5f1-0007u3-1s; Mon, 09 Nov 2020 11:48:35 +0000
Date:   Mon, 9 Nov 2020 08:48:28 -0300
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Kleber Sacilotto de Souza <kleber.souza@canonical.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        "David S. Miller" <davem@davemloft.net>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "Alexander A. Klimov" <grandmaster@al2klimov.de>,
        Kees Cook <keescook@chromium.org>,
        Alexey Kodanev <alexey.kodanev@oracle.com>,
        dccp@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dccp: ccid: move timers to struct dccp_sock
Message-ID: <20201109114828.GP595944@mussarela>
References: <20201013171849.236025-1-kleber.souza@canonical.com>
 <20201013171849.236025-2-kleber.souza@canonical.com>
 <20201016153016.04bffc1e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016153016.04bffc1e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 16, 2020 at 03:30:16PM -0700, Jakub Kicinski wrote:
> On Tue, 13 Oct 2020 19:18:48 +0200 Kleber Sacilotto de Souza wrote:
> > From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> > 
> > When dccps_hc_tx_ccid is freed, ccid timers may still trigger. The reason
> > del_timer_sync can't be used is because this relies on keeping a reference
> > to struct sock. But as we keep a pointer to dccps_hc_tx_ccid and free that
> > during disconnect, the timer should really belong to struct dccp_sock.
> > 
> > This addresses CVE-2020-16119.
> > 
> > Fixes: 839a6094140a (net: dccp: Convert timers to use timer_setup())
> > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> > Signed-off-by: Kleber Sacilotto de Souza <kleber.souza@canonical.com>
> 
> I've been mulling over this fix.
> 
> The layering violation really doesn't sit well.
> 
> We're reusing the timer object. What if we are really unlucky, the
> fires and gets blocked by a cosmic ray just as it's about to try to
> lock the socket, then user manages to reconnect, and timer starts
> again. Potentially with a different CCID algo altogether?
> 
> Is disconnect ever called under the BH lock?  Maybe plumb a bool
> argument through to ccid*_hc_tx_exit() and do a sk_stop_timer_sync()
> when called from disconnect()?
> 
> Or do refcounting on ccid_priv so that the timer holds both the socket
> and the priv?

Sorry about too late a response. I was on vacation, then came back and spent a
couple of days testing this further, and had to switch to other tasks.

So, while testing this, I had to resort to tricks like having a very small
expire and enqueuing on a different CPU. Then, after some minutes, I hit a UAF.
That's with or without the first of the second patch.

I also tried to refcount ccid instead of the socket, keeping the timer on the
ccid, but that still hit the UAF, and that's when I had to switch tasks. Oh,
and in the meantime, I found one or two other fixes that we should apply, will
send them shortly.

But I would argue that we should apply the revert as it addresses the CVE,
without really regressing the other UAF, as I argued. Does that make sense?

Thank you.
Cascardo.
