Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0028328D80B
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 03:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731010AbgJNBi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 21:38:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:44026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730193AbgJNBi5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 21:38:57 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE05021D7B;
        Wed, 14 Oct 2020 01:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602639537;
        bh=dsUVIlKk884TUcuPsT0joqWY7RCV3CzDvt7qne8kSi0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xc9TskiH47FAB6jcPHkmNnpxOxX4sxS/6XthgN4E8BtP4dJpbOdApDoyVyTRtvfBr
         OWEDT3attuecVkjIOoe8iR2qr5PnzwjTZET28e4adjrcap6s1DgVhA7P3r3jDhsH7F
         1NituLd8AXNNFXZxfASG62BTmIVa0VgEIb3KDEPg=
Date:   Tue, 13 Oct 2020 18:38:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org,
        syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com,
        Xie He <xie.he.0141@gmail.com>,
        William Tu <u9012063@gmail.com>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [Patch net v3] ip_gre: set dev->hard_header_len and
 dev->needed_headroom properly
Message-ID: <20201013183855.59717bd0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201012231721.20374-1-xiyou.wangcong@gmail.com>
References: <20201012231721.20374-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Oct 2020 16:17:21 -0700 Cong Wang wrote:
> GRE tunnel has its own header_ops, ipgre_header_ops, and sets it
> conditionally. When it is set, it assumes the outer IP header is
> already created before ipgre_xmit().
> 
> This is not true when we send packets through a raw packet socket,
> where L2 headers are supposed to be constructed by user. Packet
> socket calls dev_validate_header() to validate the header. But
> GRE tunnel does not set dev->hard_header_len, so that check can
> be simply bypassed, therefore uninit memory could be passed down
> to ipgre_xmit(). Similar for dev->needed_headroom.
> 
> dev->hard_header_len is supposed to be the length of the header
> created by dev->header_ops->create(), so it should be used whenever
> header_ops is set, and dev->needed_headroom should be used when it
> is not set.
> 
> Reported-and-tested-by: syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com
> Cc: Xie He <xie.he.0141@gmail.com>
> Cc: William Tu <u9012063@gmail.com>
> Acked-by: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied, thank you!
