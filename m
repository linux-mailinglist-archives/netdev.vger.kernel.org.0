Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E99228F067
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 12:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729596AbgJOKyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 06:54:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32992 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727123AbgJOKyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 06:54:10 -0400
Received: from 187-26-179-30.3g.claro.net.br ([187.26.179.30] helo=mussarela)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <cascardo@canonical.com>)
        id 1kT0ta-00072z-2p; Thu, 15 Oct 2020 10:54:06 +0000
Date:   Thu, 15 Oct 2020 07:53:58 -0300
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Kleber Sacilotto de Souza <kleber.souza@canonical.com>,
        netdev@vger.kernel.org, Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        "David S. Miller" <davem@davemloft.net>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "Alexander A. Klimov" <grandmaster@al2klimov.de>,
        Kees Cook <keescook@chromium.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexey Kodanev <alexey.kodanev@oracle.com>,
        dccp@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dccp: ccid: move timers to struct dccp_sock
Message-ID: <20201015105358.GA367246@mussarela>
References: <20201013171849.236025-1-kleber.souza@canonical.com>
 <20201013171849.236025-2-kleber.souza@canonical.com>
 <20201014204322.7a51c375@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201014204322.7a51c375@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 14, 2020 at 08:43:22PM -0700, Jakub Kicinski wrote:
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
> 
> Presumably you chose this commit because the fix won't apply beyond it?
> But it really fixes 2677d2067731 (dccp: don't free.. right?

Well, it should also fix cases where dccps_hc_tx_ccid{,_private} has been freed
right after the timer is stopped.

So, we could add:
Fixes: 2a91aa396739 ([DCCP] CCID2: Initial CCID2 (TCP-Like) implementation)
Fixes: 7c657876b63c ([DCCP]: Initial implementation)

But I wouldn't say that this fixes 2677d2067731, unless there is argument to
say that it fixes it because it claimed to fix what is being fixed here. But
even the code that it removed was supposed to be stopping the timer, so how
could it ever fix what it was claiming to fix?

Thanks.
Cascardo.

> 
> > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> > Signed-off-by: Kleber Sacilotto de Souza <kleber.souza@canonical.com>
