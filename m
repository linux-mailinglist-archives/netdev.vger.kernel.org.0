Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF740303D2C
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 13:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391381AbhAZMkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 07:40:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44433 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391466AbhAZMjo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 07:39:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611664694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e6bopiz441gWxyzUQpWnHQK4hDRqDeGHEv7Xf5cbC5s=;
        b=DvnnDip17TAwDL1rFTB3nd7Roa2zhx6pwVF7GVwNDGxwEh+gpOqN/2Ytz4/tQhM0SGvOgV
        8zrDSS87G85/DzYfI+GNMdPMIMrwJTJf2Da9YufRM2Gc8IC/Izqgb4SrhqSbPJDZWb6y98
        5hP6bAhGDr02Lc4L8ejr1tbu8jFqne0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-541-hMWNvN-IMxaKzXWYtgyX1A-1; Tue, 26 Jan 2021 07:38:10 -0500
X-MC-Unique: hMWNvN-IMxaKzXWYtgyX1A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 035EC1902ED9;
        Tue, 26 Jan 2021 12:38:09 +0000 (UTC)
Received: from carbon (unknown [10.36.110.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 67A3963743;
        Tue, 26 Jan 2021 12:38:04 +0000 (UTC)
Date:   Tue, 26 Jan 2021 13:38:02 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     brouer@redhat.com, <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 1/2] samples: pktgen: allow to specify delay
 parameter via new opt
Message-ID: <20210126133744.6419c183@carbon>
In-Reply-To: <20210122150517.7650-2-irusskikh@marvell.com>
References: <20210122150517.7650-1-irusskikh@marvell.com>
        <20210122150517.7650-2-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Jan 2021 16:05:16 +0100
Igor Russkikh <irusskikh@marvell.com> wrote:

> DELAY may now be explicitly specified via common parameter -w

What are you actually using this for?

Notice there is also an option called "ratep" which can be used for
setting the packet rate per sec.  In the pktgen.c code, it will use the
"delay" variable.


> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
> ---
>  samples/pktgen/parameters.sh                           | 10 +++++++++-
>  samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh |  3 ---
>  samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh    |  3 ---
>  samples/pktgen/pktgen_sample01_simple.sh               |  3 ---
>  samples/pktgen/pktgen_sample02_multiqueue.sh           |  1 -
>  samples/pktgen/pktgen_sample03_burst_single_flow.sh    |  3 ---
>  samples/pktgen/pktgen_sample04_many_flows.sh           |  3 ---
>  samples/pktgen/pktgen_sample05_flow_per_thread.sh      |  3 ---
>  .../pktgen_sample06_numa_awared_queue_irq_affinity.sh  |  1 -
>  9 files changed, 9 insertions(+), 21 deletions(-)
> 
> diff --git a/samples/pktgen/parameters.sh b/samples/pktgen/parameters.sh
> index ff0ed474fee9..70cc2878d479 100644
> --- a/samples/pktgen/parameters.sh
> +++ b/samples/pktgen/parameters.sh
> @@ -19,12 +19,13 @@ function usage() {
>      echo "  -v : (\$VERBOSE)   verbose"
>      echo "  -x : (\$DEBUG)     debug"
>      echo "  -6 : (\$IP6)       IPv6"
> +    echo "  -w : (\$DELAY)     Tx Delay value (us)"

I think the resolution is in nanosec.

>      echo ""
>  }
>  
>  ##  --- Parse command line arguments / parameters ---
>  ## echo "Commandline options:"
> -while getopts "s:i:d:m:p:f:t:c:n:b:vxh6" option; do
> +while getopts "s:i:d:m:p:f:t:c:n:b:w:vxh6" option; do
>      case $option in
>          i) # interface
>            export DEV=$OPTARG
> @@ -66,6 +67,10 @@ while getopts "s:i:d:m:p:f:t:c:n:b:vxh6" option; do
>  	  export BURST=$OPTARG
>  	  info "SKB bursting: BURST=$BURST"
>            ;;
> +        w)
> +	  export DELAY=$OPTARG
> +	  info "DELAY=$DELAY"
> +          ;;
>          v)
>            export VERBOSE=yes
>            info "Verbose mode: VERBOSE=$VERBOSE"
> @@ -100,6 +105,9 @@ if [ -z "$THREADS" ]; then
>      export THREADS=1
>  fi
>  
> +# default DELAY
> +[ -z "$DELAY" ] && export DELAY=0 # Zero means max speed
> +

Nice this allow us to remove some lines in the other scripts.

As all script have line:

   pg_set $dev "delay $DELAY"

I am the original author of the scripts, so I'm allowed to say that
doing this was actually kind of pointless, because the default delay
value is already zero. Although, you now took advantage of this
sillyness ;-)

If we want to use "ratep" instead, then we actually need to change all
those lines, because pg_set "ratep" and "delay" share the same setting
in the kernel.


>  export L_THREAD=$(( THREADS + F_THREAD - 1 ))
>  
>  if [ -z "$DEV" ]; then
> diff --git a/samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh b/samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh
> index 1b6204125d2d..30a610b541ad 100755
> --- a/samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh
> +++ b/samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh
> @@ -50,9 +50,6 @@ if [ -n "$DST_PORT" ]; then
>      validate_ports $UDP_DST_MIN $UDP_DST_MAX
>  fi
>  
> -# Base Config
> -DELAY="0"        # Zero means max speed
> -
>  # General cleanup everything since last run
>  pg_ctrl "reset"
>  
> diff --git a/samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh b/samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh
> index e607cb369b20..a6195bd77532 100755
> --- a/samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh
> +++ b/samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh
> @@ -33,9 +33,6 @@ if [ -n "$DST_PORT" ]; then
>      validate_ports $UDP_DST_MIN $UDP_DST_MAX
>  fi
>  
> -# Base Config
> -DELAY="0"        # Zero means max speed
> -
>  # General cleanup everything since last run
>  pg_ctrl "reset"
>  
> diff --git a/samples/pktgen/pktgen_sample01_simple.sh b/samples/pktgen/pktgen_sample01_simple.sh
> index a4e250b45dce..c2ad1fa32d3f 100755
> --- a/samples/pktgen/pktgen_sample01_simple.sh
> +++ b/samples/pktgen/pktgen_sample01_simple.sh
> @@ -31,9 +31,6 @@ if [ -n "$DST_PORT" ]; then
>      validate_ports $UDP_DST_MIN $UDP_DST_MAX
>  fi
>  
> -# Base Config
> -DELAY="0"        # Zero means max speed
> -
>  # Flow variation random source port between min and max
>  UDP_SRC_MIN=9
>  UDP_SRC_MAX=109
> diff --git a/samples/pktgen/pktgen_sample02_multiqueue.sh b/samples/pktgen/pktgen_sample02_multiqueue.sh
> index cb2495fcdc60..49e1e81a2945 100755
> --- a/samples/pktgen/pktgen_sample02_multiqueue.sh
> +++ b/samples/pktgen/pktgen_sample02_multiqueue.sh
> @@ -17,7 +17,6 @@ source ${basedir}/parameters.sh
>  [ -z "$COUNT" ] && COUNT="100000" # Zero means indefinitely
>  
>  # Base Config
> -DELAY="0"        # Zero means max speed
>  [ -z "$CLONE_SKB" ] && CLONE_SKB="0"
>  
>  # Flow variation random source port between min and max
> diff --git a/samples/pktgen/pktgen_sample03_burst_single_flow.sh b/samples/pktgen/pktgen_sample03_burst_single_flow.sh
> index fff50765a5aa..f9b67affb567 100755
> --- a/samples/pktgen/pktgen_sample03_burst_single_flow.sh
> +++ b/samples/pktgen/pktgen_sample03_burst_single_flow.sh
> @@ -42,9 +42,6 @@ if [ -n "$DST_PORT" ]; then
>      validate_ports $UDP_DST_MIN $UDP_DST_MAX
>  fi
>  
> -# Base Config
> -DELAY="0"  # Zero means max speed
> -
>  # General cleanup everything since last run
>  pg_ctrl "reset"
>  
[...]


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

