Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9E1EB1DBC
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 14:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729704AbfIMMbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 08:31:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44590 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726771AbfIMMbw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Sep 2019 08:31:52 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3E56810C0922;
        Fri, 13 Sep 2019 12:31:52 +0000 (UTC)
Received: from carbon (ovpn-200-36.brq.redhat.com [10.40.200.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8245B5C207;
        Fri, 13 Sep 2019 12:31:45 +0000 (UTC)
Date:   Fri, 13 Sep 2019 14:31:44 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        brouer@redhat.com
Subject: Re: [v2 3/3] samples: pktgen: allow to specify destination IP range
 (CIDR)
Message-ID: <20190913143144.2b8c18ed@carbon>
In-Reply-To: <20190911184807.21770-3-danieltimlee@gmail.com>
References: <20190911184807.21770-1-danieltimlee@gmail.com>
        <20190911184807.21770-3-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.66]); Fri, 13 Sep 2019 12:31:52 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Sep 2019 03:48:07 +0900
"Daniel T. Lee" <danieltimlee@gmail.com> wrote:

> diff --git a/samples/pktgen/pktgen_sample01_simple.sh b/samples/pktgen/pktgen_sample01_simple.sh
> index 063ec0998906..08995fa70025 100755
> --- a/samples/pktgen/pktgen_sample01_simple.sh
> +++ b/samples/pktgen/pktgen_sample01_simple.sh
> @@ -22,6 +22,7 @@ fi
>  # Example enforce param "-m" for dst_mac
>  [ -z "$DST_MAC" ] && usage && err 2 "Must specify -m dst_mac"
>  [ -z "$COUNT" ]   && COUNT="100000" # Zero means indefinitely
> +[ -n "$DEST_IP" ] && read -r DST_MIN DST_MAX <<< $(parse_addr${IP6} $DEST_IP)

The way the function "parse_addr" is called, in case of errors the
'err()' function is called inside, but it will not stop the program
flow.  Instead that function will "only" echo the "ERROR", but program
flow continues (even-thought 'err()' uses exit $exitcode).

Maybe it is not solveable to get the exit/$?/status out? (I've tried
different options, but didn't find a way).

Alternatively we can just add one extra line to validate result:

 [ -z "$DST_MIN" ] && err 5 "Stop: Invalid IP${IP6} address input"

As if it fails then $DST_MIN isn't set.


>  if [ -n "$DST_PORT" ]; then
>      read -r UDP_DST_MIN UDP_DST_MAX <<< $(parse_ports $DST_PORT)
>      validate_ports $UDP_DST_MIN $UDP_DST_MAX
> @@ -61,7 +62,8 @@ pg_set $DEV "flag NO_TIMESTAMP"
>  
>  # Destination
>  pg_set $DEV "dst_mac $DST_MAC"
> -pg_set $DEV "dst$IP6 $DEST_IP"
> +pg_set $DEV "dst${IP6}_min $DST_MIN"
> +pg_set $DEV "dst${IP6}_max $DST_MAX"
>  
>  if [ -n "$DST_PORT" ]; then
>      # Single destination port or random port range



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
