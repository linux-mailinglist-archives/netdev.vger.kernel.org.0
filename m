Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0F7B34E9
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 08:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729407AbfIPGxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 02:53:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39770 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725798AbfIPGxZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Sep 2019 02:53:25 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 03E2F3082132;
        Mon, 16 Sep 2019 06:53:25 +0000 (UTC)
Received: from carbon (ovpn-200-36.brq.redhat.com [10.40.200.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D767B60BF3;
        Mon, 16 Sep 2019 06:53:18 +0000 (UTC)
Date:   Mon, 16 Sep 2019 08:53:17 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        brouer@redhat.com,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Subject: Re: [v3 2/3] samples: pktgen: add helper functions for IP(v4/v6)
 CIDR parsing
Message-ID: <20190916085317.02e4d985@carbon>
In-Reply-To: <20190914151353.18054-2-danieltimlee@gmail.com>
References: <20190914151353.18054-1-danieltimlee@gmail.com>
        <20190914151353.18054-2-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Mon, 16 Sep 2019 06:53:25 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 15 Sep 2019 00:13:52 +0900
"Daniel T. Lee" <danieltimlee@gmail.com> wrote:

> This commit adds CIDR parsing and IP validate helper function to parse
> single IP or range of IP with CIDR. (e.g. 198.18.0.0/15)
> 
> Helpers will be used in prior to set target address in samples/pktgen.
> 
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---
> Changes since v3:
>  * Set errexit option to stop script execution on error
> 
>  samples/pktgen/functions.sh | 124 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 124 insertions(+)
> 
> diff --git a/samples/pktgen/functions.sh b/samples/pktgen/functions.sh
> index 4af4046d71be..87ae61701904 100644
> --- a/samples/pktgen/functions.sh
> +++ b/samples/pktgen/functions.sh
> @@ -5,6 +5,8 @@
>  # Author: Jesper Dangaaard Brouer
>  # License: GPL
>  
> +set -o errexit

Unfortunately, this breaks the scripts.

The function proc_cmd are designed to grep after "Result: OK:" which
might fail, and your patch/change makes the script stop immediately.
We actually want to continue, and output what command that failed (and
also grep again after "Result:" to provide the kernel reason).

Even if you somehow "fix" function proc_cmd, then we in general want to
catch different error situations by looking at status $?, and output
meaning full errors via calling err() function.  IHMO as minimum with
errexit you need a 'trap' function that can help/inform the user of
what went wrong.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
