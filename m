Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3125AEA351
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 19:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbfJ3S1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 14:27:41 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:57070 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726795AbfJ3S1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 14:27:41 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B485260D84; Wed, 30 Oct 2019 18:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572460060;
        bh=+55ggPkSh45EHlcZuO6lfk8SKXJx0wdXiTwsfvhp3Pk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TveoLuuFH1rvTQ1i/95WUwLF7hQAyoxYbw/6pU3W42YFmwIbgLWWQ8t6nZdGPZWNO
         M/Lts8d34sX+gJfKcm7fVlGSjOnAxKHsaKVrLPhDOK9e+/3YI/cQHVqSVB9hUygU3k
         oj2mc4aM7nCrpaWeWFPQ079J+OuXgZiLrgVEi8zg=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id DDEC860D84;
        Wed, 30 Oct 2019 18:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572460058;
        bh=+55ggPkSh45EHlcZuO6lfk8SKXJx0wdXiTwsfvhp3Pk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cnNglN0CkoUhekgf3AH0gzUrSlm1g5oRLeTFbOiuCSFoCb+hirFT4M6rQIxiskZ0u
         nNc6ufers1LfFl0BHO1KM/zh8kBKwCAdd4upT+eRgm14k4Dq/+DAsaxEeVom6yob6B
         cbik4EN32zpRVM3cAZeyz1W23zpm0Nk+pOYqcOy8=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 30 Oct 2019 12:27:37 -0600
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Netdev <netdev@vger.kernel.org>, Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: Crash when receiving FIN-ACK in TCP_FIN_WAIT1 state
In-Reply-To: <CADVnQymDSZb=K8R1Gv=RYDLawW9Ju1tuskkk8LZG4fm3yxyq3w@mail.gmail.com>
References: <68ad6fb82c0edfb788c7ce1a3bdc851b@codeaurora.org>
 <CADVnQynFeJCpv4irANd8O63ck0ewUq66EDSHHRKdv-zieGZ+UA@mail.gmail.com>
 <f7a0507ce733dd722b1320622dfd1caa@codeaurora.org>
 <CADVnQy=SDgiFH57MUv5kNHSjD2Vsk+a-UD0yXQKGNGY-XLw5cw@mail.gmail.com>
 <2279a8988c3f37771dda5593b350d014@codeaurora.org>
 <CADVnQykjfjPNv6F1EtWWvBT0dZFgf1QPDdhNaCX3j3bFCkViwA@mail.gmail.com>
 <f9ae970c12616f61c6152ebe34019e2b@codeaurora.org>
 <CADVnQymqKpMh3iRfrdiAYjb+2ejKswk8vaZCY6EW4-3ppDnv_w@mail.gmail.com>
 <81ace6052228e12629f73724236ade63@codeaurora.org>
 <CADVnQymDSZb=K8R1Gv=RYDLawW9Ju1tuskkk8LZG4fm3yxyq3w@mail.gmail.com>
Message-ID: <74827a046961422207515b1bb354101d@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Thanks. Do you mind sharing what your patch looked like, so we can
> understand precisely what was changed?
> 
> Also, are you able to share what the workload looked like that tickled
> this issue? (web client? file server?...)

Sure. This was seen only on our regression racks and the workload there
is a combination of FTP, browsing and other apps.

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 4374196..9af7497 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -232,7 +232,8 @@ struct tcp_sock {
                 fastopen_connect:1, /* FASTOPEN_CONNECT sockopt */
                 fastopen_no_cookie:1, /* Allow send/recv SYN+data 
without a cookie */
                 is_sack_reneg:1,    /* in recovery from loss with SACK 
reneg? */
-               unused:2;
+               unused:1,
+               wqp_called:1;
         u8      nonagle     : 4,/* Disable Nagle algorithm?             
*/
                 thin_lto    : 1,/* Use linear timeouts for thin streams 
*/
                 recvmsg_inq : 1,/* Indicate # of bytes in queue upon 
recvmsg */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 1a1fcb3..0c29bdd 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2534,6 +2534,9 @@ void tcp_write_queue_purge(struct sock *sk)
         INIT_LIST_HEAD(&tcp_sk(sk)->tsorted_sent_queue);
         sk_mem_reclaim(sk);
         tcp_clear_all_retrans_hints(tcp_sk(sk));
+       tcp_sk(sk)->highest_sack = NULL;
+       tcp_sk(sk)->sacked_out = 0;
+       tcp_sk(sk)->wqp_called = 1;
         tcp_sk(sk)->packets_out = 0;
         inet_csk(sk)->icsk_backoff = 0;
  }


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
