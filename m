Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD2843D392
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 23:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244200AbhJ0VLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 17:11:43 -0400
Received: from ink.ssi.bg ([178.16.128.7]:36507 "EHLO ink.ssi.bg"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244195AbhJ0VLn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 17:11:43 -0400
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id E1AE43C0332;
        Thu, 28 Oct 2021 00:09:12 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.16.1/8.16.1) with ESMTP id 19RL999a042887;
        Thu, 28 Oct 2021 00:09:10 +0300
Date:   Thu, 28 Oct 2021 00:09:09 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     yangxingwu <xingwu.yang@gmail.com>
cc:     Simon Horman <horms@verge.net.au>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] ipvs: Fix reuse connection if RS weight is 0
In-Reply-To: <CA+7U5Jta_g2vCXiwScVVwLZppWp51TDOB7LxUxeundkPxNZYnA@mail.gmail.com>
Message-ID: <35e6215-4fb3-5149-a888-67aa6fae958f@ssi.bg>
References: <20211025115910.2595-1-xingwu.yang@gmail.com> <707b5fb3-6b61-c53-e983-bc1373aa2bf@ssi.bg> <CA+7U5JsSuwqP7eHj1tMHfsb+EemwrhZEJ2b944LFWTroxAnQRQ@mail.gmail.com> <1190ef60-3ad9-119e-5336-1c62522aec81@ssi.bg> <CA+7U5JvvsNejgOifAwDdjddkLHUL30JPXSaDBTwysSL7dhphuA@mail.gmail.com>
 <CA+7U5Jta_g2vCXiwScVVwLZppWp51TDOB7LxUxeundkPxNZYnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Wed, 27 Oct 2021, yangxingwu wrote:

> what we want is if RS weight is 0, then no new connections should be
> served even if conn_reuse_mode is 0, just as commit dc7b3eb900aa
> ("ipvs: Fix reuse connection if real server is
> dead") trying to do
> 
> Pls let me know if there are any other issues of concern

	My concern is with the behaviour people expect
from each sysctl var: conn_reuse_mode decides if port reuse
is considered for rescheduling and expire_nodest_conn
should have priority only for unavailable servers (nodest means
No Destination), not in this case.

	We don't know how people use the conn_reuse_mode=0
mode, one may bind to a local port and try to send multiple
connections in a row with the hope they will go to same real
server, i.e. as part from same "session", even while weight=0.
If they do not want such behaviour (99% of the cases), they
will use the default conn_reuse_mode=1. OTOH, you have different
expectations for mode 0, not sure why but you do not want to use
the default mode=1 which is safer to use. May be the setups
forget to stay with conn_reuse_mode=1 on kernels 5.9+ and
set the var to 0 ?

	The problem with mentioned commit dc7b3eb900aa is that
it breaks FTP and persistent connections while the goal of
weight=0 is graceful inhibition of the server. We made
the mistake to add priority for expire_nodest_conn when weight=0.
This can be fixed with a !cp->control check. We do not want
expire_nodest_conn to kill every connection during the
graceful period.

Regards

--
Julian Anastasov <ja@ssi.bg>
