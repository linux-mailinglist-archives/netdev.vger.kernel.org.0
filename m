Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21F6D2AD499
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 12:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729909AbgKJLTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 06:19:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60589 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729484AbgKJLTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 06:19:43 -0500
Received: from 1.general.cascardo.us.vpn ([10.172.70.58] helo=mussarela)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <cascardo@canonical.com>)
        id 1kcRgY-0003QB-Ox; Tue, 10 Nov 2020 11:19:39 +0000
Date:   Tue, 10 Nov 2020 08:19:32 -0300
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
Message-ID: <20201110111932.GS595944@mussarela>
References: <20201013171849.236025-1-kleber.souza@canonical.com>
 <20201013171849.236025-2-kleber.souza@canonical.com>
 <20201016153016.04bffc1e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201109114828.GP595944@mussarela>
 <20201109094938.45b230c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201109210909.GQ595944@mussarela>
 <20201109131554.5f65b2fa@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20201109213134.GR595944@mussarela>
 <20201109141553.30e9d502@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201109141553.30e9d502@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 09, 2020 at 02:15:53PM -0800, Jakub Kicinski wrote:
> On Mon, 9 Nov 2020 18:31:34 -0300 Thadeu Lima de Souza Cascardo wrote:
> > > Which paths are those (my memory of this code is waning)? I thought
> > > disconnect is only called from the user space side (shutdown syscall).
> > > The only other way to terminate the connection is to close the socket,
> > > which Eric already fixed by postponing the destruction of ccid in that
> > > case.  
> > 
> > dccp_v4_do_rcv -> dccp_rcv_established -> dccp_parse_options ->
> > 	dccp_feat_parse_options -> dccp_feat_handle_nn_established ->
> > 	dccp_feat_activate -> __dccp_feat_activate -> dccp_hdlr_ccid ->
> > 	ccid_hc_tx_delete
> 
> Well, that's not a disconnect path.
> 
> There should be no CCID on a disconnected socket, tho, right? Otherwise
> if we can switch from one active CCID to another then reusing a single
> timer in struct dccp_sock for both is definitely not safe as I
> explained in my initial email.

Yeah, I agree with your initial email. The patch I submitted for that fix needs
rework, which is what I tried and failed so far. I need to get back to some
testing of my latest fix and find out what needs fixing there.

But I am also saying that simply doing a del_timer_sync on disconnect paths
won't do, because there are non-disconnect paths where there is a CCID that we
will remove and replace and that will still trigger a timer UAF.

So I have been working on a fix that involves a refcnt on ccid itself. But I
want to test that it really fixes the problem and I have spent most of the time
finding out a way to trigger the timer in a race with the disconnect path.

And that same test has showed me that this timer UAF will happen regardless of
commit 2677d20677314101293e6da0094ede7b5526d2b1, which led me into stating that
reverting it should be done in any case.

I think I can find some time this week to work a little further on the fix for
the time UAF.

Thanks.
Cascardo.
