Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA4D92255D8
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 04:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgGTCUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 22:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbgGTCUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 22:20:43 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A001C0619D2
        for <netdev@vger.kernel.org>; Sun, 19 Jul 2020 19:20:43 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0221312864431;
        Sun, 19 Jul 2020 19:20:41 -0700 (PDT)
Date:   Sun, 19 Jul 2020 19:20:38 -0700 (PDT)
Message-Id: <20200719.192038.2300519017333591083.davem@davemloft.net>
To:     willemdebruijn.kernel@gmail.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        tom@herbertland.com, willemb@google.com
Subject: Re: [PATCH net-next v2] icmp: support rfc 4884
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200710132902.1957784-1-willemdebruijn.kernel@gmail.com>
References: <20200710132902.1957784-1-willemdebruijn.kernel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 19 Jul 2020 19:20:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Fri, 10 Jul 2020 09:29:02 -0400

> From: Willem de Bruijn <willemb@google.com>
> 
> Add setsockopt SOL_IP/IP_RECVERR_4884 to return the offset to an
> extension struct if present.
> 
> ICMP messages may include an extension structure after the original
> datagram. RFC 4884 standardized this behavior. It stores the offset
> in words to the extension header in u8 icmphdr.un.reserved[1].
> 
> The field is valid only for ICMP types destination unreachable, time
> exceeded and parameter problem, if length is at least 128 bytes and
> entire packet does not exceed 576 bytes.
> 
> Return the offset to the start of the extension struct when reading an
> ICMP error from the error queue, if it matches the above constraints.
> 
> Do not return the raw u8 field. Return the offset from the start of
> the user buffer, in bytes. The kernel does not return the network and
> transport headers, so subtract those.
> 
> Also validate the headers. Return the offset regardless of validation,
> as an invalid extension must still not be misinterpreted as part of
> the original datagram. Note that !invalid does not imply valid. If
> the extension version does not match, no validation can take place,
> for instance.
> 
> For backward compatibility, make this optional, set by setsockopt
> SOL_IP/IP_RECVERR_RFC4884. For API example and feature test, see
> github.com/wdebruij/kerneltools/blob/master/tests/recv_icmp_v2.c
> 
> For forward compatibility, reserve only setsockopt value 1, leaving
> other bits for additional icmp extensions.
> 
> Changes
>   v1->v2:
>   - convert word offset to byte offset from start of user buffer
>     - return in ee_data as u8 may be insufficient
>   - define extension struct and object header structs
>   - return len only if constraints met
>   - if returning len, also validate
> 
> Signed-off-by: Willem de Bruijn <willemb@google.com>

Applied, thanks Willem.
