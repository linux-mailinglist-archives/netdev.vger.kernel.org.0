Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6556A303E3A
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 14:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403942AbhAZNLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 08:11:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58455 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391931AbhAZNLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 08:11:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611666604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g3Lc9vIktAmbO8Je+80+3rGZZl7kbxWiciTE4TpbxwQ=;
        b=DNK3VG0oNHqDRiEP+QZfA5XwmzL7AryEjSURaEI0BiY6LpzQnPHAzQTMMvGia+HDvBRS+Q
        9g5J28sahn2HOYiUVjHQ+nFo3+tUY3D74jlJlPJU5CwNX3rPI9x8Z+4AtxVEtPj61bqtE5
        rNFM2AXYITF3DzwKYQftuMRW/YTB+Wc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-oPnKmvUjPbGIwHQxyIce8w-1; Tue, 26 Jan 2021 08:10:02 -0500
X-MC-Unique: oPnKmvUjPbGIwHQxyIce8w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C7FC9B8105;
        Tue, 26 Jan 2021 13:10:00 +0000 (UTC)
Received: from carbon (unknown [10.36.110.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF9EF5D751;
        Tue, 26 Jan 2021 13:09:55 +0000 (UTC)
Date:   Tue, 26 Jan 2021 14:09:54 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Igor Russkikh <irusskikh@marvell.com>,
        "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     brouer@redhat.com, <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 2/2] samples: pktgen: new append mode
Message-ID: <20210126140954.34989297@carbon>
In-Reply-To: <20210122150517.7650-3-irusskikh@marvell.com>
References: <20210122150517.7650-1-irusskikh@marvell.com>
        <20210122150517.7650-3-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Jan 2021 16:05:17 +0100
Igor Russkikh <irusskikh@marvell.com> wrote:

> To configure various complex flows we for sure can create custom
> pktgen init scripts, but sometimes thats not that easy.
> 
> New "-a" (append) option in all the existing sample scripts allows
> to append more "devices" into pktgen threads.
> 
> The most straightforward usecases for that are:
> - using multiple devices. We have to generate full linerate on
> all physical functions (ports) of our multiport device.
> - pushing multiple flows (with different packet options)

The use-case makes sense.

More comment inlined below.

> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
> ---
>  samples/pktgen/README.rst                      | 18 ++++++++++++++++++
>  samples/pktgen/functions.sh                    |  2 +-
>  samples/pktgen/parameters.sh                   |  7 ++++++-
>  samples/pktgen/pktgen_sample01_simple.sh       | 10 ++++++++--
>  samples/pktgen/pktgen_sample02_multiqueue.sh   | 10 ++++++++--
>  .../pktgen_sample03_burst_single_flow.sh       | 10 ++++++++--
>  samples/pktgen/pktgen_sample04_many_flows.sh   | 10 ++++++++--
>  .../pktgen/pktgen_sample05_flow_per_thread.sh  | 10 ++++++++--
>  ..._sample06_numa_awared_queue_irq_affinity.sh | 10 ++++++++--
>  9 files changed, 73 insertions(+), 14 deletions(-)
> 
> diff --git a/samples/pktgen/README.rst b/samples/pktgen/README.rst
> index f9c53ca5cf93..f7d8dd76b0c4 100644
> --- a/samples/pktgen/README.rst
> +++ b/samples/pktgen/README.rst
> @@ -28,10 +28,28 @@ across the sample scripts.  Usage example is printed on errors::
>    -b : ($BURST)     HW level bursting of SKBs
>    -v : ($VERBOSE)   verbose
>    -x : ($DEBUG)     debug
> +  -6 : ($IP6)       IPv6
> +  -w : ($DELAY)     Tx Delay value (us)
> +  -a : ($APPENDCFG) Script will not reset generator's state, but will append its config

You called it $APPENDCFG, but code use $APPEND.

>  The global variable being set is also listed.  E.g. the required
>  interface/device parameter "-i" sets variable $DEV.
>  
> +"-a" parameter may be used to create different flows simultaneously.
> +In this mode script will keep the existing config, will append its settings.
> +In this mode you'll have to manually run traffic with "pg_ctrl start".
> +
> +For example you may use:
> +
> +    source ./samples/pktgen/functions.sh
> +    pg_ctrl reset
> +    # add first device
> +    ./pktgen_sample06_numa_awared_queue_irq_affinity.sh -a -i ens1f0 -m 34:80:0d:a3:fc:c9 -t 8
> +    # add second device
> +    ./pktgen_sample06_numa_awared_queue_irq_affinity.sh -a -i ens1f1 -m 34:80:0d:a3:fc:c9 -t 8
> +    # run joint traffic on two devs
> +    pg_ctrl start
> +
>  Common functions
>  ----------------
>  The functions.sh file provides; Three different shell functions for
> diff --git a/samples/pktgen/functions.sh b/samples/pktgen/functions.sh
> index dae06d5b38fa..8db945ee4f55 100644
> --- a/samples/pktgen/functions.sh
> +++ b/samples/pktgen/functions.sh
> @@ -108,7 +108,7 @@ function pgset() {
>      fi
>  }
>  
> -[[ $EUID -eq 0 ]] && trap 'pg_ctrl "reset"' EXIT
> +[ -z "$APPEND" ] && [ "$EUID" -eq 0 ] && trap '[ -z "$APPEND" ] && pg_ctrl "reset"' EXIT

This looks confusing and wrong (I think).
(e.g. is the second '[ -z "$APPEND" ] && ...' needed).

In functions.sh we don't need to "compress" the lines that much. I
prefer readability in this file.  (Cc Daniel T. Lee as he added this
line).  Maybe we can make it more human readable:

if [[ -z "$APPEND" ]]; then
	if [[ $EUID -eq 0 ]]; then
		# Cleanup pktgen setup on exit
		trap 'pg_ctrl "reset"' EXIT
	fi
fi

I'm a little confused how the "trap" got added into 'functions.sh', as
my original intend was that function.sh should only provide helper
functions and not have a side-effect. (But I can see I acked the
change).

  
>  ## -- General shell tricks --
>  
> diff --git a/samples/pktgen/parameters.sh b/samples/pktgen/parameters.sh
> index 70cc2878d479..3fd4d5e8107a 100644
> --- a/samples/pktgen/parameters.sh
> +++ b/samples/pktgen/parameters.sh
> @@ -20,12 +20,13 @@ function usage() {
>      echo "  -x : (\$DEBUG)     debug"
>      echo "  -6 : (\$IP6)       IPv6"
>      echo "  -w : (\$DELAY)     Tx Delay value (us)"
> +    echo "  -a : (\$APPENDCFG) Script will not reset generator's state, but will append its config"

You called it $APPENDCFG, but code use $APPEND.

>      echo ""
>  }
>  
>  ##  --- Parse command line arguments / parameters ---
>  ## echo "Commandline options:"
> -while getopts "s:i:d:m:p:f:t:c:n:b:w:vxh6" option; do
> +while getopts "s:i:d:m:p:f:t:c:n:b:w:vxh6a" option; do
>      case $option in
>          i) # interface
>            export DEV=$OPTARG
> @@ -83,6 +84,10 @@ while getopts "s:i:d:m:p:f:t:c:n:b:w:vxh6" option; do
>  	  export IP6=6
>  	  info "IP6: IP6=$IP6"
>  	  ;;
> +        a)
> +          export APPEND=yes

See variable name $APPEND is used here, but help says $APPENDCFG

> +          info "Append mode: APPEND=$APPEND"
> +          ;;
>          h|?|*)
>            usage;
>            err 2 "[ERROR] Unknown parameters!!!"
> diff --git a/samples/pktgen/pktgen_sample01_simple.sh b/samples/pktgen/pktgen_sample01_simple.sh
> index c2ad1fa32d3f..8ca7913eaf8a 100755
> --- a/samples/pktgen/pktgen_sample01_simple.sh
> +++ b/samples/pktgen/pktgen_sample01_simple.sh
> @@ -37,11 +37,11 @@ UDP_SRC_MAX=109
>  
>  # General cleanup everything since last run
>  # (especially important if other threads were configured by other scripts)
> -pg_ctrl "reset"
> +[ -z "$APPEND" ] && pg_ctrl "reset"

Makes sense.

>  # Add remove all other devices and add_device $DEV to thread 0
>  thread=0
> -pg_thread $thread "rem_device_all"
> +[ -z "$APPEND" ] && pg_thread $thread "rem_device_all"
>  pg_thread $thread "add_device" $DEV
>  
>  # How many packets to send (zero means indefinitely)
> @@ -77,6 +77,8 @@ pg_set $DEV "flag UDPSRC_RND"
>  pg_set $DEV "udp_src_min $UDP_SRC_MIN"
>  pg_set $DEV "udp_src_max $UDP_SRC_MAX"
>  
> +if [ -z "$APPEND" ]; then
> +
>  # start_run
>  echo "Running... ctrl^C to stop" >&2
>  pg_ctrl "start"
> @@ -85,3 +87,7 @@ echo "Done" >&2
>  # Print results
>  echo "Result device: $DEV"
>  cat /proc/net/pktgen/$DEV
> +
> +else
> +echo "Append mode: config done. Do more or use 'pg_ctrl start' to run"
> +fi

Hmm, could we indent lines for readability?
(Same in other files)

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

