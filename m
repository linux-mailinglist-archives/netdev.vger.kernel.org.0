Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC39D34EAC
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 19:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfFDRXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 13:23:31 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39965 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfFDRXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 13:23:30 -0400
Received: by mail-pg1-f196.google.com with SMTP id d30so10737058pgm.7
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 10:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rGcQVMW0fl0747wGN/wBm81XIYeH3j1OT8rxKvWO9OQ=;
        b=m+ctwRTctdutVQx24X3Gs7FuURvap6cu6wYrnEq+2aAobkQB3co58DZWT4P7iIHlvJ
         kdUdanyucypLJaOoHkhmS/+NA2V5OZ3KjuuWaaJsCNFHbGQ5gsCmoAbiVLtJUaGcU6O6
         jcJQ8sln+Ai5E6m+Qoh3KPGlq7dzGmhkfIdWocBjASeLlNaHIDilSAfIluN+0uQawgBu
         UFCdaTS/tUfjMNJNuM6FPSwYyy65sNptG4cGLZTWlSBt22751X+Utg2aCK/hdNxVFhVU
         +8qMNujt30rqQBME50g9tuCcqo27ln1RztTzj5JK61trwaL5Mk1TacD7VLxWoAF3Qqld
         wCSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rGcQVMW0fl0747wGN/wBm81XIYeH3j1OT8rxKvWO9OQ=;
        b=mDVnEkYPVvp5jvSamO/DI/Yx9KsiFugWPAsM7dHia7lLIV5iWCKCkdXwgRbslmSFMi
         EhUBPiCLfTex6DpTa8z+j2cnUdKunBeHn+bunn/Aeewx1h7Rp80KO1C+aa/iuEbN1z+b
         UkTaAnC2bjCd3RQDzhTGcV1/CZ+Ktaeft6MuhQiEwZ3/y1KGgSImeY5LgHw9pDPLv9Rp
         878Y7j0NFsmRiKjAkkUbAh89UKJO/W989m376hxX8zLG0fpugeVuYJhtjw9UR9CH0yi7
         w7Jb6/6dzPBccphIPqnvQIjDPjJJXl8QGtS3D0l+3JcBuUX6lNqTGoDvaLcZdP15Fzc0
         o90g==
X-Gm-Message-State: APjAAAXxUNFpd9zikTeaYSBUXmeOafJL35LgPcVmnBAMNpnkxsk7mu/Z
        L2VpzZ+F+SKbay1PtYwNUbY=
X-Google-Smtp-Source: APXvYqy0WDvMlaIoP14Xf+XQq4nf0kurR5jiI0WNLYB4J/5jry71UXVSoIY5AsRTPQ2VZ60f3WkMbw==
X-Received: by 2002:a17:90a:1541:: with SMTP id y1mr3266292pja.88.1559669010210;
        Tue, 04 Jun 2019 10:23:30 -0700 (PDT)
Received: from [172.27.227.158] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id y7sm36682983pja.26.2019.06.04.10.23.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 10:23:29 -0700 (PDT)
Subject: Re: [PATCH net] udp: only choose unbound UDP socket for multicast
 when not in a VRF
To:     Tim Beale <timbeale@catalyst.net.nz>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
References: <1559613383-6086-1-git-send-email-timbeale@catalyst.net.nz>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e9d20a8f-146d-e9f3-4ef5-22a2f882146f@gmail.com>
Date:   Tue, 4 Jun 2019 11:23:27 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1559613383-6086-1-git-send-email-timbeale@catalyst.net.nz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/3/19 7:56 PM, Tim Beale wrote:
> By default, packets received in another VRF should not be passed to an
> unbound socket in the default VRF. This patch updates the IPv4 UDP
> multicast logic to match the unicast VRF logic (in compute_score()),
> as well as the IPv6 mcast logic (in __udp_v6_is_mcast_sock()).
> 
> The particular case I noticed was DHCP discover packets going
> to the 255.255.255.255 address, which are handled by
> __udp4_lib_mcast_deliver(). The previous code meant that running
> multiple different DHCP server or relay agent instances across VRFs
> did not work correctly - any server/relay agent in the default VRF
> received DHCP discover packets for all other VRFs.
> 
> Signed-off-by: Tim Beale <timbeale@catalyst.net.nz>
> ---
>  net/ipv4/udp.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 8fb250e..efe9283 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -538,8 +538,7 @@ static inline bool __udp_is_mcast_sock(struct net *net, struct sock *sk,
>  	    (inet->inet_dport != rmt_port && inet->inet_dport) ||
>  	    (inet->inet_rcv_saddr && inet->inet_rcv_saddr != loc_addr) ||
>  	    ipv6_only_sock(sk) ||
> -	    (sk->sk_bound_dev_if && sk->sk_bound_dev_if != dif &&
> -	     sk->sk_bound_dev_if != sdif))
> +	    !udp_sk_bound_dev_eq(net, sk->sk_bound_dev_if, dif, sdif))
>  		return false;
>  	if (!ip_mc_sf_allow(sk, loc_addr, rmt_addr, dif, sdif))
>  		return false;
> 

Thanks for the fix.

Really should have been apart of this commit:

Fixes: 6da5b0f027a8 ("net: ensure unbound datagram socket to be chosen
when not in a VRF")
Reviewed-by: David Ahern <dsahern@gmail.com>

IPv6 mcast socket lookup was converted to udp_sk_bound_dev_eq, so v6
seems ok.
