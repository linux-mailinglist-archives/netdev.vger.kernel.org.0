Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 664F8B880D
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 01:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389611AbfISXZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 19:25:17 -0400
Received: from www62.your-server.de ([213.133.104.62]:54568 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388331AbfISXZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 19:25:16 -0400
Received: from [178.197.248.15] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iB5nW-00084S-9N; Fri, 20 Sep 2019 01:25:14 +0200
Date:   Fri, 20 Sep 2019 01:25:13 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Joe Stringer <joe@wand.net.nz>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH iproute2 master] bpf: Fix race condition with map pinning
Message-ID: <20190919232513.GA7765@pc-63.home>
References: <20190919220733.31206-1-joe@wand.net.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190919220733.31206-1-joe@wand.net.nz>
"User-Agent: Mutt/1.12.1 with l2md"
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25577/Thu Sep 19 10:20:13 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 19, 2019 at 03:07:33PM -0700, Joe Stringer wrote:
> If two processes attempt to invoke bpf_map_attach() at the same time,
> then they will both create maps, then the first will successfully pin
> the map to the filesystem and the second will not pin the map, but will
> continue operating with a reference to its own copy of the map. As a
> result, the sharing of the same map will be broken from the two programs
> that were concurrently loaded via loaders using this library.
> 
> Fix this by adding a retry in the case where the pinning fails because
> the map already exists on the filesystem. In that case, re-attempt
> opening a fd to the map on the filesystem as it shows that another
> program already created and pinned a map at that location.
> 
> Signed-off-by: Joe Stringer <joe@wand.net.nz>

Acked-by: Daniel Borkmann <daniel@iogearbox.net>
