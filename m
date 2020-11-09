Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8442AC824
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 23:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729807AbgKIWQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 17:16:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:53414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729247AbgKIWQB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 17:16:01 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF8A4206A4;
        Mon,  9 Nov 2020 22:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604960160;
        bh=wyEF/89LIqKHZv6IedNWIxEpT4kusLHJIDPUrtjUI4Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Iy5GLdn84ESku7OZsVMmbtFtesJ3+Ms0aJ7ps8s04K4vm4h5XbKGiAhUIAhDBtPLg
         g65WzW8xgHGi4rVWwOowGzTcY3GJbXTUOmEIg6zUCJtLJydC7lu/+72TnOVEwwD/+D
         XrPNIiNuV/x5F+Ef2POjN7OjZGsHrUsfbLOYP6Mc=
Date:   Mon, 9 Nov 2020 14:15:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
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
Message-ID: <20201109141553.30e9d502@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201109213134.GR595944@mussarela>
References: <20201013171849.236025-1-kleber.souza@canonical.com>
        <20201013171849.236025-2-kleber.souza@canonical.com>
        <20201016153016.04bffc1e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201109114828.GP595944@mussarela>
        <20201109094938.45b230c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201109210909.GQ595944@mussarela>
        <20201109131554.5f65b2fa@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20201109213134.GR595944@mussarela>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Nov 2020 18:31:34 -0300 Thadeu Lima de Souza Cascardo wrote:
> > Which paths are those (my memory of this code is waning)? I thought
> > disconnect is only called from the user space side (shutdown syscall).
> > The only other way to terminate the connection is to close the socket,
> > which Eric already fixed by postponing the destruction of ccid in that
> > case.  
> 
> dccp_v4_do_rcv -> dccp_rcv_established -> dccp_parse_options ->
> 	dccp_feat_parse_options -> dccp_feat_handle_nn_established ->
> 	dccp_feat_activate -> __dccp_feat_activate -> dccp_hdlr_ccid ->
> 	ccid_hc_tx_delete

Well, that's not a disconnect path.

There should be no CCID on a disconnected socket, tho, right? Otherwise
if we can switch from one active CCID to another then reusing a single
timer in struct dccp_sock for both is definitely not safe as I
explained in my initial email.
