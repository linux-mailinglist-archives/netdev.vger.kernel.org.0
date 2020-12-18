Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E02072DEBDE
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 00:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725879AbgLRXJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 18:09:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgLRXJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 18:09:17 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47FD0C0617A7
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 15:08:37 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kqOrT-0007sk-4g; Sat, 19 Dec 2020 00:08:35 +0100
Date:   Sat, 19 Dec 2020 00:08:35 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        dsahern@gmail.com
Subject: Re: [PATCH iproute2 2/2] lib/fs: Fix single return points for
 get_cgroup2_*
Message-ID: <20201218230835.GY28824@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Andrea Claudi <aclaudi@redhat.com>, netdev@vger.kernel.org,
        stephen@networkplumber.org, dsahern@gmail.com
References: <cover.1608315719.git.aclaudi@redhat.com>
 <9b07b59c4c422b29d6c8297f7f7ec0f2dcc7fb3f.1608315719.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b07b59c4c422b29d6c8297f7f7ec0f2dcc7fb3f.1608315719.git.aclaudi@redhat.com>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 18, 2020 at 08:09:23PM +0100, Andrea Claudi wrote:
> Functions get_cgroup2_id() and get_cgroup2_path() uncorrectly performs
> cleanup on the single return point. Both of them may get to use close()
> with a negative argument, if open() fails.
> 
> Fix this adding proper labels and gotos to make sure we clean up only
> resources we are effectively used before.

Since free(NULL) is OK according to POSIX, the fds are initialized to -1
and open() returns -1 on error, you may simplify these
changes down to making the close() calls conditional:

| if (fd >= 0)
| 	close(fd);

Cheers, Phil
