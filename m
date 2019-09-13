Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4537FB1DD3
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 14:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729830AbfIMMnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 08:43:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40762 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726771AbfIMMnM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Sep 2019 08:43:12 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3DA6C6128F;
        Fri, 13 Sep 2019 12:43:12 +0000 (UTC)
Received: from carbon (ovpn-200-36.brq.redhat.com [10.40.200.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2D4C5608AB;
        Fri, 13 Sep 2019 12:43:06 +0000 (UTC)
Date:   Fri, 13 Sep 2019 14:43:05 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        brouer@redhat.com
Subject: Re: [v2 2/3] samples: pktgen: add helper functions for IP(v4/v6)
 CIDR parsing
Message-ID: <20190913144305.4bf38c04@carbon>
In-Reply-To: <20190911184807.21770-2-danieltimlee@gmail.com>
References: <20190911184807.21770-1-danieltimlee@gmail.com>
        <20190911184807.21770-2-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Fri, 13 Sep 2019 12:43:12 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Sep 2019 03:48:06 +0900
"Daniel T. Lee" <danieltimlee@gmail.com> wrote:

> This commit adds CIDR parsing and IP validate helper function to parse
> single IP or range of IP with CIDR. (e.g. 198.18.0.0/15)
> 
> Helpers will be used in prior to set target address in samples/pktgen.
> 
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---
>  samples/pktgen/functions.sh | 122 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 122 insertions(+)
> 
> diff --git a/samples/pktgen/functions.sh b/samples/pktgen/functions.sh
> index 4af4046d71be..8be5a6b6c097 100644
[...]

> +# Given a single IP(v4/v6) or CIDR, return minimum and maximum IP addr.
> +function parse_addr()
> +{
> +    # check function is called with (funcname)6
> +    [[ ${FUNCNAME[1]: -1} == 6 ]] && local IP6=6
> +    local bitlen=$[ IP6 ? 128 : 32 ]
> +    local octet=$[ IP6 ? 16 : 8 ]
> +
> +    local addr=$1
> +    local net prefix
> +    local min_ip max_ip
> +
> +    IFS='/' read net prefix <<< $addr
> +    [[ $IP6 ]] && net=$(extend_addr6 $net)
> +    validate_addr$IP6 $net
> +
> +    if [[ $prefix -gt $bitlen ]]; then
> +        err 5 "Invalid prefix: $prefix"
> +    elif [[ -z $prefix ]]; then
> +        min_ip=$net
> +        max_ip=$net
> +    else
> +        # defining array for converting Decimal 2 Binary
> +        # 00000000 00000001 00000010 00000011 00000100 ...
> +        local d2b='{0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1}'
> +        [[ $IP6 ]] && d2b+=$d2b
> +        eval local D2B=($d2b)

I must say this is a rather cool shell/bash trick to use an array for
converting decimal numbers into binary.

> +
> +        local shift=$[ bitlen-prefix ]

Using a variable named 'shift' is slightly problematic for shell/bash
code.  It works, but it is just confusing.

> +        local min_mask max_mask
> +        local min max
> +        local ip_bit
> +        local ip sep
> +
> +        # set separator for each IP(v4/v6)
> +        [[ $IP6 ]] && sep=: || sep=.
> +        IFS=$sep read -ra ip <<< $net
> +
> +        min_mask="$(printf '1%.s' $(seq $prefix))$(printf '0%.s' $(seq $shift))"
> +        max_mask="$(printf '0%.s' $(seq $prefix))$(printf '1%.s' $(seq $shift))"

Also a surprising shell trick to get binary numbers out of a prefix number.

> +
> +        # calculate min/max ip with &,| operator
> +        for i in "${!ip[@]}"; do
> +            digit=$[ IP6 ? 16#${ip[$i]} : ${ip[$i]} ]
> +            ip_bit=${D2B[$digit]}
> +
> +            idx=$[ octet*i ]
> +            min[$i]=$[ 2#$ip_bit & 2#${min_mask:$idx:$octet} ]
> +            max[$i]=$[ 2#$ip_bit | 2#${max_mask:$idx:$octet} ]
> +            [[ $IP6 ]] && { min[$i]=$(printf '%X' ${min[$i]});
> +                            max[$i]=$(printf '%X' ${max[$i]}); }
> +        done
> +
> +        min_ip=$(IFS=$sep; echo "${min[*]}")
> +        max_ip=$(IFS=$sep; echo "${max[*]}")
> +    fi
> +
> +    echo $min_ip $max_ip
> +}

If you just fix the variable name 'shift' to something else, then I'm
happy with this patch.

Again, I'm very impressed with your shell/bash skills, I were certainly
challenged when reviewing this :-)

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
