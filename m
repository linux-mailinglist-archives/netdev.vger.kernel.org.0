Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F30F311950
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 04:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbhBFDB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 22:01:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:39752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231221AbhBFCvz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 21:51:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04C2264F51;
        Fri,  5 Feb 2021 22:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612564551;
        bh=/d7hyScWKy7rmoffTYVW8U8Hr6uQSMMsfR6pwjRMA6Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eI5GH/v34mz5bxoyj0tyMgr4duFyxIKSgiuDVYXwI0Mw6RZO9YyoC/wwf+APLDn/D
         IUIpI6af6qVqQQlAjixLznBHAhUVPlrFMgKED2ySuO/WFx18j1mpfLtq/bSUahZSEp
         UqllQfm9SeE3k2A209qzOLjDabtsY7t9zsRpyV7w=
Date:   Fri, 5 Feb 2021 14:35:50 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     NeilBrown <neilb@suse.de>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>,
        Xin Long <lucien.xin@gmail.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/3] Fix some seq_file users that were recently broken
Message-Id: <20210205143550.58d3530918459eafa918ad0c@linux-foundation.org>
In-Reply-To: <161248518659.21478.2484341937387294998.stgit@noble1>
References: <161248518659.21478.2484341937387294998.stgit@noble1>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 05 Feb 2021 11:36:30 +1100 NeilBrown <neilb@suse.de> wrote:

> A recent change to seq_file broke some users which were using seq_file
> in a non-"standard" way ...  though the "standard" isn't documented, so
> they can be excused.  The result is a possible leak - of memory in one
> case, of references to a 'transport' in the other.
> 
> These three patches:
>  1/ document and explain the problem
>  2/ fix the problem user in x86
>  3/ fix the problem user in net/sctp
> 

1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code and
interface") was August 2018, so I don't think "recent" applies here?

I didn't look closely, but it appears that the sctp procfs file is
world-readable.  So we gave unprivileged userspace the ability to leak
kernel memory?

So I'm thinking that we aim for 5.12-rc1 on all three patches with a cc:stable?
