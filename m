Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B951FCDCFB
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 10:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbfJGIQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 04:16:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45924 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727302AbfJGIQr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 04:16:47 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 062932BE94;
        Mon,  7 Oct 2019 08:16:47 +0000 (UTC)
Received: from carbon (ovpn-200-24.brq.redhat.com [10.40.200.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EBC365C219;
        Mon,  7 Oct 2019 08:16:40 +0000 (UTC)
Date:   Mon, 7 Oct 2019 10:16:39 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        brouer@redhat.com
Subject: Re: [PATCH net-next v5 3/4] samples: pktgen: add helper functions
 for IP(v4/v6) CIDR parsing
Message-ID: <20191007101639.57203a0b@carbon>
In-Reply-To: <20191005082509.16137-4-danieltimlee@gmail.com>
References: <20191005082509.16137-1-danieltimlee@gmail.com>
        <20191005082509.16137-4-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Mon, 07 Oct 2019 08:16:47 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  5 Oct 2019 17:25:08 +0900
"Daniel T. Lee" <danieltimlee@gmail.com> wrote:

> This commit adds CIDR parsing and IP validate helper function to parse
> single IP or range of IP with CIDR. (e.g. 198.18.0.0/15)
> 
> Validating the address should be preceded prior to the parsing.
> Helpers will be used in prior to set target address in samples/pktgen.
> 
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

> ---
> Changes since v3:
>  * Set errexit option to stop script execution on error
> 
> Changes since v4:
>  * Set errexit option moved to previous commit
>  * previously, the reason 'parse_addr' won't exit on error was using
>    here-string which runs on subshell.
>  * to avoid this, 'validate_addr' is removed from the 'parse_addr' flow.
>  * to remove duplicated comparison, added 'in_between' helper func
> 
>  samples/pktgen/functions.sh | 137 +++++++++++++++++++++++++++++++++++-
>  1 file changed, 134 insertions(+), 3 deletions(-)
> 
> diff --git a/samples/pktgen/functions.sh b/samples/pktgen/functions.sh
> index 40873a5d1461..858e74ae2279 100644
> --- a/samples/pktgen/functions.sh
> +++ b/samples/pktgen/functions.sh
> @@ -168,6 +168,137 @@ function get_node_cpus()
>  	echo $node_cpu_list
>  }
>  
> +# Check $1 is in between $2, $3 ($2 <= $1 <= $3)
> +function in_between() { [[ ($1 -ge $2) && ($1 -le $3) ]] ; }
> +
> +# Extend shrunken IPv6 address.
> +# fe80::42:bcff:fe84:e10a => fe80:0:0:0:42:bcff:fe84:e10a
> +function extend_addr6()
> +{
> +    local addr=$1
> +    local sep=: sep2=::
> +    local sep_cnt=$(tr -cd $sep <<< $1 | wc -c)
> +    local shrink
> +
> +    # separator count should be (2 <= $sep_cnt <= 7)
> +    if ! (in_between $sep_cnt 2 7); then
> +        err 5 "Invalid IP6 address: $1"
> +    fi
> +
> +    # if shrink '::' occurs multiple, it's malformed.
> +    shrink=( $(egrep -o "$sep{2,}" <<< $addr) )
> +    if [[ ${#shrink[@]} -ne 0 ]]; then
> +        if [[ ${#shrink[@]} -gt 1 || ( ${shrink[0]} != $sep2 ) ]]; then
> +            err 5 "Invalid IP6 address: $1"
> +        fi
> +    fi
> +
> +    # add 0 at begin & end, and extend addr by adding :0
> +    [[ ${addr:0:1} == $sep ]] && addr=0${addr}
> +    [[ ${addr: -1} == $sep ]] && addr=${addr}0
> +    echo "${addr/$sep2/$(printf ':0%.s' $(seq $[8-sep_cnt])):}"
> +}
> +
> +# Given a single IP(v4/v6) address, whether it is valid.
> +function validate_addr()
> +{
> +    # check function is called with (funcname)6
> +    [[ ${FUNCNAME[1]: -1} == 6 ]] && local IP6=6
> +    local bitlen=$[ IP6 ? 128 : 32 ]
> +    local len=$[ IP6 ? 8 : 4 ]
> +    local max=$[ 2**(len*2)-1 ]
> +    local net prefix
> +    local addr sep
> +
> +    IFS='/' read net prefix <<< $1
> +    [[ $IP6 ]] && net=$(extend_addr6 $net)
> +
> +    # if prefix exists, check (0 <= $prefix <= $bitlen)
> +    if [[ -n $prefix ]]; then
> +        if ! (in_between $prefix 0 $bitlen); then
> +            err 5 "Invalid prefix: /$prefix"
> +        fi
> +    fi
> +
> +    # set separator for each IP(v4/v6)
> +    [[ $IP6 ]] && sep=: || sep=.
> +    IFS=$sep read -a addr <<< $net
> +
> +    # array length
> +    if [[ ${#addr[@]} != $len ]]; then
> +        err 5 "Invalid IP$IP6 address: $1"
> +    fi
> +
> +    # check each digit (0 <= $digit <= $max)
> +    for digit in "${addr[@]}"; do
> +        [[ $IP6 ]] && digit=$[ 16#$digit ]
> +        if ! (in_between $digit 0 $max); then
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
> +{
> +    # check function is called with (funcname)6
> +    [[ ${FUNCNAME[1]: -1} == 6 ]] && local IP6=6
> +    local net prefix
> +    local min_ip max_ip
> +
> +    IFS='/' read net prefix <<< $1
> +    [[ $IP6 ]] && net=$(extend_addr6 $net)
> +
> +    if [[ -z $prefix ]]; then
> +        min_ip=$net
> +        max_ip=$net
> +    else
> +        # defining array for converting Decimal 2 Binary
> +        # 00000000 00000001 00000010 00000011 00000100 ...
> +        local d2b='{0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1}'
> +        [[ $IP6 ]] && d2b+=$d2b
> +        eval local D2B=($d2b)
> +
> +        local bitlen=$[ IP6 ? 128 : 32 ]
> +        local remain=$[ bitlen-prefix ]
> +        local octet=$[ IP6 ? 16 : 8 ]
> +        local min_mask max_mask
> +        local min max
> +        local ip_bit
> +        local ip sep
> +
> +        # set separator for each IP(v4/v6)
> +        [[ $IP6 ]] && sep=: || sep=.
> +        IFS=$sep read -ra ip <<< $net
> +
> +        min_mask="$(printf '1%.s' $(seq $prefix))$(printf '0%.s' $(seq $remain))"
> +        max_mask="$(printf '0%.s' $(seq $prefix))$(printf '1%.s' $(seq $remain))"
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
> +
> +function parse_addr6() { parse_addr $@ ; }
> +
>  # Given a single or range of port(s), return minimum and maximum port number.
>  function parse_ports()
>  {
> @@ -190,9 +321,9 @@ function validate_ports()
>      local min_port=$1
>      local max_port=$2
>  
> -    # 0 < port < 65536
> -    if [[ $min_port -gt 0 && $min_port -lt 65536 ]]; then
> -	if [[ $max_port -gt 0 && $max_port -lt 65536 ]]; then
> +    # 1 <= port <= 65535
> +    if (in_between $min_port 1 65535); then
> +	if (in_between $max_port 1 65535); then
>  	    if [[ $min_port -le $max_port ]]; then
>  		return 0
>  	    fi



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
