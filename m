Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BABD5291D18
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 21:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733076AbgJRTnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 15:43:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:33556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731770AbgJRTm4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 15:42:56 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57931206ED;
        Sun, 18 Oct 2020 19:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603050175;
        bh=UfI1PyUfh5fJxCGvVlL/LU5sm3vSHjRrPW5xWthEkAc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HougGKIXhULYZr+5UZUMZ6gx8lHtGXs50oU4aeKtlrU/SZxS2xcSmqX6wI/HbaRqt
         A3MJIF/AlKhbfw0peFi6bRA2KnwWMt5YqY5xFY50GKXSC+sHzfdmD8FXLgLWJ9slUL
         In/Ir/ZnejJN4oXv3tLnBGvVNPX7y9FcZJNCc+Cg=
Date:   Sun, 18 Oct 2020 12:42:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dev@openvswitch.org,
        pabeni@redhat.com, pshelar@ovn.org, jlelli@redhat.com,
        bigeasy@linutronix.de, i.maximets@ovn.org
Subject: Re: [PATCH net v4] net: openvswitch: fix to make sure flow_lookup()
 is not preempted
Message-ID: <20201018124254.2ec023b0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <160295903253.7789.826736662555102345.stgit@ebuild>
References: <160295903253.7789.826736662555102345.stgit@ebuild>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 17 Oct 2020 20:24:51 +0200 Eelco Chaudron wrote:
> The flow_lookup() function uses per CPU variables, which must be called
> with BH disabled. However, this is fine in the general NAPI use case
> where the local BH is disabled. But, it's also called from the netlink
> context. The below patch makes sure that even in the netlink path, the
> BH is disabled.
> 
> In addition, u64_stats_update_begin() requires a lock to ensure one writer
> which is not ensured here. Making it per-CPU and disabling NAPI (softirq)
> ensures that there is always only one writer.
> 
> Fixes: eac87c413bf9 ("net: openvswitch: reorder masks array based on usage")
> Reported-by: Juri Lelli <jlelli@redhat.com>
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>

Applied and queued for 5.9.2. Thanks Eelco!
