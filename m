Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4898D2A571A
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 22:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732169AbgKCVeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 16:34:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:58590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731929AbgKCU4j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 15:56:39 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6874A2053B;
        Tue,  3 Nov 2020 20:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436998;
        bh=TcyQb0TCBUDS0ej6dkKIdHcPAnKe8NGWWMa05VJTxAg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DXFtVmOQQcqMn3kZGy9gK1S0goG14ywMuvWqTzC+BMbyNuFCHhk2uM86bsIzc6oVz
         2vL/U//QZElZ1/A9/TWQYm7+2GTl4zOIScnoFng1oeQ2QvDS+tXU1d6T/MvFg44Osc
         pSE/4pou0RaOMjXD3ptaQ+iNbQ0c0qOKuJ2rvgv0=
Date:   Tue, 3 Nov 2020 12:56:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Martin Varghese <martin.varghese@nokia.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        David Ahern <dsa@cumulusnetworks.com>
Subject: Re: [PATCH net-next] mpls: drop skb's dst in mpls_forward()
Message-ID: <20201103125637.37838cf7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <f8c2784c13faa54469a2aac339470b1049ca6b63.1604102750.git.gnault@redhat.com>
References: <f8c2784c13faa54469a2aac339470b1049ca6b63.1604102750.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 31 Oct 2020 01:07:25 +0100 Guillaume Nault wrote:
> Commit 394de110a733 ("net: Added pointer check for
> dst->ops->neigh_lookup in dst_neigh_lookup_skb") added a test in
> dst_neigh_lookup_skb() to avoid a NULL pointer dereference. The root
> cause was the MPLS forwarding code, which doesn't call skb_dst_drop()
> on incoming packets. That is, if the packet is received from a
> collect_md device, it has a metadata_dst attached to it that doesn't
> implement any dst_ops function.
> 
> To align the MPLS behaviour with IPv4 and IPv6, let's drop the dst in
> mpls_forward(). This way, dst_neigh_lookup_skb() doesn't need to test
> ->neigh_lookup any more. Let's keep a WARN condition though, to  
> document the precondition and to ease detection of such problems in the
> future.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>

Applied, thanks!
