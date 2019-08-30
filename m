Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0089A37BD
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 15:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbfH3N2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 09:28:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38180 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727754AbfH3N2E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 09:28:04 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 07648307D84D;
        Fri, 30 Aug 2019 13:28:04 +0000 (UTC)
Received: from carbon (ovpn-200-29.brq.redhat.com [10.40.200.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3028E608C1;
        Fri, 30 Aug 2019 13:27:59 +0000 (UTC)
Date:   Fri, 30 Aug 2019 15:27:58 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        brouer@redhat.com
Subject: Re: [PATCH 2/3] samples: pktgen: add helper functions for IP(v4/v6)
 CIDR parsing
Message-ID: <20190830152758.41b38c24@carbon>
In-Reply-To: <20190828204243.16666-2-danieltimlee@gmail.com>
References: <20190828204243.16666-1-danieltimlee@gmail.com>
        <20190828204243.16666-2-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Fri, 30 Aug 2019 13:28:04 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Aug 2019 05:42:42 +0900
"Daniel T. Lee" <danieltimlee@gmail.com> wrote:

> This commit adds CIDR parsing and IP validate helper function to parse
> single IP or range of IP with CIDR. (e.g. 198.18.0.0/15)
> 
> Helpers will be used in prior to set target address in samples/pktgen.
> 
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---
>  samples/pktgen/functions.sh | 134 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 134 insertions(+)
> 
> diff --git a/samples/pktgen/functions.sh b/samples/pktgen/functions.sh
> index 4af4046d71be..eb1c52e25018 100644
> --- a/samples/pktgen/functions.sh
> +++ b/samples/pktgen/functions.sh
> @@ -163,6 +163,140 @@ function get_node_cpus()
>  	echo $node_cpu_list
>  }
>  
> +# Extend shrunken IPv6 address.
> +# fe80::42:bcff:fe84:e10a => fe80:0:0:0:42:bcff:fe84:e10a
> +function extend_addr6()
> +{
> +    local addr=$1
> +    local sep=:
> +    local sep2=::
> +    local sep_cnt=$(tr -cd $sep <<< $1 | wc -c)
> +    local shrink
> +
> +    # separator count : should be between 2, 7.
> +    if [[ $sep_cnt -lt 2 || $sep_cnt -gt 7 ]]; then
> +        err 5 "Invalid IP6 address sep: $1"
> +    fi
> +
> +    # if shrink '::' occurs multiple, it's malformed.
> +    shrink=( $(egrep -o "$sep{2,}" <<< $addr) )
> +    if [[ ${#shrink[@]} -ne 0 ]]; then
> +        if [[ ${#shrink[@]} -gt 1 || ( ${shrink[0]} != $sep2 ) ]]; then
> +            err 5 "Invalid IP$IP6 address shr: $1"
> +        fi
> +    fi
> +
> +    # add 0 at begin & end, and extend addr by adding :0
> +    [[ ${addr:0:1} == $sep ]] && addr=0${addr}
> +    [[ ${addr: -1} == $sep ]] && addr=${addr}0
> +    echo "${addr/$sep2/$(printf ':0%.s' $(seq $[8-sep_cnt])):}"
> +}
> +
> +
> +# Given a single IP(v4/v6) address, whether it is valid.
> +function validate_addr()
> +{
> +    # check function is called with (funcname)6
> +    [[ ${FUNCNAME[1]: -1} == 6 ]] && local IP6=6
> +    local len=$[ IP6 ? 8 : 4 ]
> +    local max=$[ 2**(len*2)-1 ]
> +    local addr
> +    local sep
> +
> +    # set separator for each IP(v4/v6)
> +    [[ $IP6 ]] && sep=: || sep=.
> +    IFS=$sep read -a addr <<< $1
> +
> +    # array length
> +    if [[ ${#addr[@]} != $len ]]; then
> +        err 5 "Invalid IP$IP6 address: $1"
> +    fi
> +
> +    # check each digit between 0, $max
> +    for digit in "${addr[@]}"; do
> +        [[ $IP6 ]] && digit=$[ 16#$digit ]
> +        if [[ $digit -lt 0 || $digit -gt $max ]]; then
> +            err 5 "Invalid IP$IP6 address: $1"
> +        fi
> +    done
> +
> +    return 0
> +}
> +
> +function validate_addr6() { validate_addr $@ ; }
> +
> +# Given a single IP(v4/v6) or CIDR, return minimum and maximum IP addr.
> +function parse_addr()

I must say that I'm impressed by your bash-shell skills, BUT below
function does look too complicated for doing this... I were expecting
that you would use the regular & (AND) operation to do the prefix
masking.


> +{
> +    # check function is called with (funcname)6
> +    [[ ${FUNCNAME[1]: -1} == 6 ]] && local IP6=6
> +    local bitlen=$[ IP6 ? 128 : 32 ]
> +
> +    local addr=$1
> +    local net
> +    local prefix
> +    local min_ip
> +    local max_ip
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
> +
> +        local shift=$[ bitlen-prefix ]
> +        local ip_bit
> +        local ip
> +        local sep
> +
> +        # set separator for each IP(v4/v6)
> +        [[ $IP6 ]] && sep=: || sep=.
> +        IFS=$sep read -ra ip <<< $net
> +
> +        # build full size bit
> +        for digit in "${ip[@]}"; do
> +            [[ $IP6 ]] && digit=$[ 16#$digit ]
> +            ip_bit+=${D2B[$digit]}
> +        done
> +
> +        # fill 0 or 1 by $shift
> +        base_bit=${ip_bit::$prefix}
> +        min_bit="$base_bit$(printf '0%.s' $(seq $shift))"
> +        max_bit="$base_bit$(printf '1%.s' $(seq $shift))"
> +
> +        bit2addr() {
> +            local step=$[ IP6 ? 16 : 8 ]
> +            local max=$[ bitlen-step ]
> +            local result
> +            local fmt
> +            [[ $IP6 ]] && fmt='%X' || fmt='%d'
> +
> +            for i in $(seq 0 $step $max); do
> +                result+=$(printf $fmt $[ 2#${1:$i:$step} ])
> +                [[ $i != $max ]] && result+=$sep
> +            done
> +            echo $result
> +        }
> +
> +        min_ip=$(bit2addr $min_bit)
> +        max_ip=$(bit2addr $max_bit)
> +    fi
> +
> +    echo $min_ip $max_ip
> +}
> +
> +function parse_addr6() { parse_addr $@ ; }
> +
>  # Given a single or range of port(s), return minimum and maximum port number.
>  function parse_ports()
>  {



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
