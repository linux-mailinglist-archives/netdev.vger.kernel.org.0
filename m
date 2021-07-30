Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CEBE3DBD49
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 18:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbhG3Qqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 12:46:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:35340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229587AbhG3Qqi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 12:46:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9689760720;
        Fri, 30 Jul 2021 16:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627663593;
        bh=Kb1VEqN1zcTOLXdPhcQz2NDXAaRgdt/3T+aWiMrgVpI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vINdUSpGtYQqydBau7y/z4bS6qzcBdFF+++BVIcuctLIn+R/wiaM2u7H+sQvMlFPD
         6ljh7TV/hvTayVElAk2KYX+tb/mclU58dYkuz6aQIN03/zAAYgf25TqT1K3S268KVy
         hrc1pxpQNiYGoWAY8UeEQcb7urMXpCL3iN1C93tXXtSrwZkCAwb5RehHjBrWzoveW7
         NgL+gRwmWZMyusb+gPTe99A0Ibp7CvpIcg6ACKYvowdKvpBJ8695cX7ht9ThwqTawc
         jmXPbcEyZypgcPml35eC67YumDvYZKvcie+O/YFXzguDsJiuDjiwzJkyavf0fWmOXC
         KDMJ86oWO57gA==
Date:   Fri, 30 Jul 2021 09:46:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>, linux-kernel@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-arch@vger.kernel.org, Andrei Vagin <avagin@gmail.com>
Subject: Re: [PATCH v2] sock: allow reading and changing sk_userlocks with
 setsockopt
Message-ID: <20210730094631.106b8bec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210730160708.6544-1-ptikhomirov@virtuozzo.com>
References: <20210730160708.6544-1-ptikhomirov@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Jul 2021 19:07:08 +0300 Pavel Tikhomirov wrote:
> SOCK_SNDBUF_LOCK and SOCK_RCVBUF_LOCK flags disable automatic socket
> buffers adjustment done by kernel (see tcp_fixup_rcvbuf() and
> tcp_sndbuf_expand()). If we've just created a new socket this adjustment
> is enabled on it, but if one changes the socket buffer size by
> setsockopt(SO_{SND,RCV}BUF*) it becomes disabled.
> 
> CRIU needs to call setsockopt(SO_{SND,RCV}BUF*) on each socket on
> restore as it first needs to increase buffer sizes for packet queues
> restore and second it needs to restore back original buffer sizes. So
> after CRIU restore all sockets become non-auto-adjustable, which can
> decrease network performance of restored applications significantly.
> 
> CRIU need to be able to restore sockets with enabled/disabled adjustment
> to the same state it was before dump, so let's add special setsockopt
> for it.
> 
> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

The patchwork bot is struggling to ingest this, please double check it
applies cleanly to net-next.
