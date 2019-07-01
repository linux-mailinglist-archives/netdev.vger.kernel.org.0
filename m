Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DADC15BEB2
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 16:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729866AbfGAOvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 10:51:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10649 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727337AbfGAOvW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 10:51:22 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8D49A780F4;
        Mon,  1 Jul 2019 14:51:17 +0000 (UTC)
Received: from carbon (ovpn-200-45.brq.redhat.com [10.40.200.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 78AB62CFAD;
        Mon,  1 Jul 2019 14:51:13 +0000 (UTC)
Date:   Mon, 1 Jul 2019 16:51:11 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        brouer@redhat.com, Robert Olsson <robert@herjulf.net>
Subject: Re: [PATCH 1/2] samples: pktgen: add some helper functions for port
 parsing
Message-ID: <20190701165111.3e68cd6c@carbon>
In-Reply-To: <20190629133358.8251-1-danieltimlee@gmail.com>
References: <20190629133358.8251-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Mon, 01 Jul 2019 14:51:22 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 29 Jun 2019 22:33:57 +0900
"Daniel T. Lee" <danieltimlee@gmail.com> wrote:

> This commit adds port parsing and port validate helper function to parse
> single or range of port(s) from a given string. (e.g. 1234, 443-444)
> 
> Helpers will be used in prior to set target port(s) in samples/pktgen.
> 
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---
>  samples/pktgen/functions.sh | 34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)


Nice bash shellcode with use of array variables.

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

> diff --git a/samples/pktgen/functions.sh b/samples/pktgen/functions.sh
> index f8bb3cd0f4ce..4af4046d71be 100644
> --- a/samples/pktgen/functions.sh
> +++ b/samples/pktgen/functions.sh
> @@ -162,3 +162,37 @@ function get_node_cpus()
>  
>  	echo $node_cpu_list
>  }
> +
> +# Given a single or range of port(s), return minimum and maximum port number.
> +function parse_ports()
> +{
> +    local port_str=$1
> +    local port_list
> +    local min_port
> +    local max_port
> +
> +    IFS="-" read -ra port_list <<< $port_str
> +
> +    min_port=${port_list[0]}
> +    max_port=${port_list[1]:-$min_port}
> +
> +    echo $min_port $max_port
> +}
> +
> +# Given a minimum and maximum port, verify port number.
> +function validate_ports()
> +{
> +    local min_port=$1
> +    local max_port=$2
> +
> +    # 0 < port < 65536
> +    if [[ $min_port -gt 0 && $min_port -lt 65536 ]]; then
> +	if [[ $max_port -gt 0 && $max_port -lt 65536 ]]; then
> +	    if [[ $min_port -le $max_port ]]; then
> +		return 0
> +	    fi
> +	fi
> +    fi
> +
> +    err 5 "Invalid port(s): $min_port-$max_port"
> +}



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
