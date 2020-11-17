Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 922D42B6BD9
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 18:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729424AbgKQRfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 12:35:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:41960 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729212AbgKQRfW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 12:35:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C217AABF4;
        Tue, 17 Nov 2020 17:35:20 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 586FE6073E; Tue, 17 Nov 2020 18:35:20 +0100 (CET)
Date:   Tue, 17 Nov 2020 18:35:20 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Antonio Cardace <acardace@redhat.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v4 5/6] selftests: refactor get_netdev_name
 function
Message-ID: <20201117173520.bix4wdfy6u3mapjl@lion.mk-sys.cz>
References: <20201117152015.142089-1-acardace@redhat.com>
 <20201117152015.142089-6-acardace@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117152015.142089-6-acardace@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 04:20:14PM +0100, Antonio Cardace wrote:
> As pointed out by Michal Kubecek, getting the name
> with the previous approach was racy, it's better
> and easier to get the name of the device with this
> patch's approach.
> 
> Essentialy the function doesn't need to exist
> anymore as it's a simple 'ls' command.
> 
> Signed-off-by: Antonio Cardace <acardace@redhat.com>
> ---
>  .../drivers/net/netdevsim/ethtool-common.sh   | 20 ++-----------------
>  1 file changed, 2 insertions(+), 18 deletions(-)
> 
> diff --git a/tools/testing/selftests/drivers/net/netdevsim/ethtool-common.sh b/tools/testing/selftests/drivers/net/netdevsim/ethtool-common.sh
> index fa44cf6e732c..3c287ac78117 100644
> --- a/tools/testing/selftests/drivers/net/netdevsim/ethtool-common.sh
> +++ b/tools/testing/selftests/drivers/net/netdevsim/ethtool-common.sh
> @@ -20,23 +20,6 @@ function cleanup {
>  
>  trap cleanup EXIT
>  
> -function get_netdev_name {
> -    local -n old=$1
> -
> -    new=$(ls /sys/class/net)
> -
> -    for netdev in $new; do
> -	for check in $old; do
> -            [ $netdev == $check ] && break
> -	done
> -
> -	if [ $netdev != $check ]; then
> -	    echo $netdev
> -	    break
> -	fi
> -    done
> -}
> -
>  function check {
>      local code=$1
>      local str=$2
> @@ -65,5 +48,6 @@ function make_netdev {
>      fi
>  
>      echo $NSIM_ID > /sys/bus/netdevsim/new_device
> -    echo `get_netdev_name old_netdevs`
> +    # get new device name
> +    echo $(ls /sys/bus/netdevsim/devices/netdevsim${NSIM_ID}/net/)

Is there a reason for combining command substitution with echo? Couldn't
we use one of

  ls /sys/bus/netdevsim/devices/netdevsim${NSIM_ID}/net/
  echo /sys/bus/netdevsim/devices/netdevsim${NSIM_ID}/net/*

instead?

Michal

>  }
> -- 
> 2.28.0
> 
