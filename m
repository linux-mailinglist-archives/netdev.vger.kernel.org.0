Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 270622A57E3
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 22:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731996AbgKCVqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 16:46:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:47460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731203AbgKCUvt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 15:51:49 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A736A2236F;
        Tue,  3 Nov 2020 20:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436709;
        bh=RbG8BEayeDOLy1d5GJe6IeOENyppy7McuHZnW2CuuxE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IcwtH2bp02+HupW+Ga0jxmSObUzLi7ocHLXziYnPOPXrGxq5LK3tZOIho5P801Ykc
         ZbPL2zC6s/6H4FhqCeMqhhRVvbFB+UOzvrCrlryC2puW9GVrQDOJyJsAFVnFsB6cGA
         sn71xKXqltdGQt9aB0Em/HxDdk1zRradtved9SlE=
Date:   Tue, 3 Nov 2020 12:51:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rohit Maheshwari <rohitm@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com
Subject: Re: [net v4 07/10] ch_ktls: packet handling prior to start marker
Message-ID: <20201103125147.565dbf0c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201030180225.11089-8-rohitm@chelsio.com>
References: <20201030180225.11089-1-rohitm@chelsio.com>
        <20201030180225.11089-8-rohitm@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Oct 2020 23:32:22 +0530 Rohit Maheshwari wrote:
> There could be a case where ACK for tls exchanges prior to start
> marker is missed out, and by the time tls is offloaded. This pkt
> should not be discarded and handled carefully. It could be
> plaintext alone or plaintext + finish as well.

By plaintext + finish you mean the start of offload falls in the middle
of a TCP skb? That should never happen. We force EOR when we turn on
TLS, so you should never see a TCP skb that needs to be half-encrypted.
