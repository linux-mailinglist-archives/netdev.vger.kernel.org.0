Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A53B716865F
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 19:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729556AbgBUSWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 13:22:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:34238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727966AbgBUSWD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 13:22:03 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3630C206E2;
        Fri, 21 Feb 2020 18:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582309323;
        bh=EB3RCy+KkbrCa0bZvqvuVZ+vD2rifSO3C97ioE4E808=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OMrbdBxiSCuSen5OTFY5Uj3YZzdkbztZ5qpMsMmI2MJ97LJHqF/jniBNa5bZZjM5m
         ShMgtMhqTda93WYql5cAiQakSKoB9IrmLH7G9jnTa0aAYWFDYhISpyZBsNMvlN8oSf
         mTYQYnaBlwLDXsogyl3Kbm0VFVGP6JpaOaZc5eho=
Date:   Fri, 21 Feb 2020 10:22:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org, mlxsw@mellanox.com,
        Edward Cree <ecree@solarflare.com>
Subject: Re: [patch net-next 00/10] net: allow user specify TC filter HW
 stats type
Message-ID: <20200221102200.1978e10e@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200221095643.6642-1-jiri@resnulli.us>
References: <20200221095643.6642-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Feb 2020 10:56:33 +0100 Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Currently, when user adds a TC filter and the filter gets offloaded,
> the user expects the HW stats to be counted and included in stats dump.
> However, since drivers may implement different types of counting, there
> is no way to specify which one the user is interested in.
> 
> For example for mlx5, only delayed counters are available as the driver
> periodically polls for updated stats.
> 
> In case of mlxsw, the counters are queried on dump time. However, the
> HW resources for this type of counters is quite limited (couple of
> thousands). This limits the amount of supported offloaded filters
> significantly. Without counter assigned, the HW is capable to carry
> millions of those.
> 
> On top of that, mlxsw HW is able to support delayed counters as well in
> greater numbers. That is going to be added in a follow-up patch.
> 
> This patchset allows user to specify one of the following types of HW
> stats for added fitler:
> any - current default, user does not care about the type, just expects
>       any type of stats.
> immediate - queried during dump time
> delayed - polled from HW periodically or sent by HW in async manner
> disabled - no stats needed

Hmm, but the statistics are on actions, it feels a little bit like we
are perpetuating the mistake of counting on filters here.

Would it not work to share actions between filters which don't need
fine grained stats if HW can do more filters than stats?

Let's CC Ed on this.

