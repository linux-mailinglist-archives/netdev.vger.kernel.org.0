Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1B08AAF3
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 01:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbfHLXI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 19:08:59 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34821 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbfHLXI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 19:08:59 -0400
Received: by mail-wm1-f66.google.com with SMTP id l2so1080074wmg.0
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 16:08:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=W4XM1Cnxs/uiRXAVYOZTw4Gb7ujq35WkW+ksJnY1pqM=;
        b=b9FQN8GpIFxf5DuCF+DyxbmN07aRPFuNL7xN5p1oGtfVsoYYezMWhcOMruaMvyfoRU
         I6meXeDP85uVt5YRLoQucLm2OdV+oDjQpfULgCjewaS/dR3Bgp9VCUD9ObrIyNjdx5bZ
         f5xUOt+c6j406yzoA+899eKL1uSextvzwptY5dPxNXHWm2qtgPJK1kway/VGU8Jka27e
         Qfw7WiNAvds6bATfM1j1eqGelpiaAmVJPofrIKlpyvTOU+TDANCEkWlYOAGdY/lYFS4X
         tz80ZlthKn6/bWrwm07Ke+292O5VGeCS8ZLwN9o0oAiw/FGGEaB3lgMTAzfiGfsitmI+
         j9hg==
X-Gm-Message-State: APjAAAWTmp1qv9D9sNdsfMTMys2hMvb1sYq03CRBwHVs3NIHAKYEzjpY
        lSo4S4JB3o1bracpRXyBUgi4uQ==
X-Google-Smtp-Source: APXvYqyQesMp73rJT2oDxBQMJ/27gUNRJyJIh/pouulRg4Bpgzi8jGDwspujf2Pgh+EGBR57zt24HQ==
X-Received: by 2002:a1c:cc0d:: with SMTP id h13mr1232439wmb.119.1565651337706;
        Mon, 12 Aug 2019 16:08:57 -0700 (PDT)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id w15sm870677wmi.19.2019.08.12.16.08.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 16:08:57 -0700 (PDT)
Date:   Tue, 13 Aug 2019 01:08:55 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     David Miller <davem@davemloft.net>, Hangbin Liu <haliu@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Linus =?iso-8859-1?Q?L=FCssing?= <linus.luessing@c0d3.blue>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] ipv6: Fix return value of ipv6_mc_may_pull() for
 malformed packets
Message-ID: <20190812230855.GA22939@linux.home>
References: <dc0d0b1bc3c67e2a1346b0dd1f68428eb956fbb7.1565649789.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc0d0b1bc3c67e2a1346b0dd1f68428eb956fbb7.1565649789.git.sbrivio@redhat.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 12:46:01AM +0200, Stefano Brivio wrote:
> Commit ba5ea614622d ("bridge: simplify ip_mc_check_igmp() and
> ipv6_mc_check_mld() calls") replaces direct calls to pskb_may_pull()
> in br_ipv6_multicast_mld2_report() with calls to ipv6_mc_may_pull(),
> that returns -EINVAL on buffers too short to be valid IPv6 packets,
> while maintaining the previous handling of the return code.
> 
> This leads to the direct opposite of the intended effect: if the
> packet is malformed, -EINVAL evaluates as true, and we'll happily
> proceed with the processing.
> 
> Return 0 if the packet is too short, in the same way as this was
> fixed for IPv4 by commit 083b78a9ed64 ("ip: fix ip_mc_may_pull()
> return value").
> 
> I don't have a reproducer for this, unlike the one referred to by
> the IPv4 commit, but this is clearly broken.
> 
> Fixes: ba5ea614622d ("bridge: simplify ip_mc_check_igmp() and ipv6_mc_check_mld() calls")
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> ---
>  include/net/addrconf.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/net/addrconf.h b/include/net/addrconf.h
> index becdad576859..3f62b347b04a 100644
> --- a/include/net/addrconf.h
> +++ b/include/net/addrconf.h
> @@ -206,7 +206,7 @@ static inline int ipv6_mc_may_pull(struct sk_buff *skb,
>  				   unsigned int len)
>  {
>  	if (skb_transport_offset(skb) + ipv6_transport_len(skb) < len)
> -		return -EINVAL;
> +		return 0;
>  
>  	return pskb_may_pull(skb, len);
>  }

Acked-by: Guillaume Nault <gnault@redhat.com>
