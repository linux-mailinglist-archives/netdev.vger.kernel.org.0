Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 797948F994
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 06:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbfHPEBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 00:01:43 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45984 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbfHPEBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 00:01:43 -0400
Received: by mail-pg1-f195.google.com with SMTP id o13so2254951pgp.12
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 21:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WG0GV55jqeNKi5DbV14Kl0vKpyyXU9k9hlF2Tf1Nk6I=;
        b=RKE7SgZ9hB/qfBnnJ+bp/mCxsytDmLO7HnbGlyu/d48PouVz89DQpsl5gTOVSMlSRu
         a72gzj51OIp2bsyOrERUhjbs4GVsfZ8en4XWGwqosYt24ZeJW0dQc9d5Pv9VIIpmh0jX
         bad9b7tl4tl4eWxE3IJVFuEcgM9FuPNvygLdiCxvv33qicGSMQgs6YbM90eHeOwqNKvk
         26g+JsuRF8DhDl0eSU5NRXORw1waLoNroBOrnlaIT1SPIO9HZjHGkNIeCB5u2m75nm2p
         UJXKhy3c2EKfXzv9mintGmISgnP3qqXYi3t3+NU771i2LdpY2vtQPLhY5WdVSLKLNJ7F
         oW0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WG0GV55jqeNKi5DbV14Kl0vKpyyXU9k9hlF2Tf1Nk6I=;
        b=XAblaKKEE1PucoRNxkjQcV5f+AsQfD5D5+xWByFFYPEKTYyMhor4f80BMPBdfOGk4I
         MQhWjWT7bo/bFbepKr6adD65gIa4QuUYL6VjPsj7xMKvXJm2ZZ6NDEjqEnIzV/afUWiC
         GlmK05Pbh/7ExJcJWOIDEaMnqGHkZnpg9rgrsUZOu82+H6PLxPcND/CXO9NHJHuUjdKE
         nLZWK2rMvCRGteeom9Tbr215QJ99x04dydCtHFScbPqkkJv5i2XeEe/XS6hRJ4GSgMZ7
         9a27HHiTBikA+pvOZocHruUTOkttUhC3imd8EPwVARpXqAlpeaGrHaAM+ZD0+NyNTZrT
         iGwA==
X-Gm-Message-State: APjAAAURrJhasJ58Wzql+A8Fqmmpfcb2sIG3+Z9QQo/p5AADwisJ2qW3
        PQiL36xfxizbcAO1bD+v2Ho=
X-Google-Smtp-Source: APXvYqwBWMadltFsvrp75MS6MtIrV6QAp6TGkIVmB7kYUehqYWtdh3QBctqFwsJuRkPdTHmo2aIuow==
X-Received: by 2002:a63:121b:: with SMTP id h27mr6069459pgl.335.1565928102687;
        Thu, 15 Aug 2019 21:01:42 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x25sm4802707pfa.90.2019.08.15.21.01.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 21:01:42 -0700 (PDT)
Date:   Fri, 16 Aug 2019 12:01:31 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, Stefano Brivio <sbrivio@redhat.com>,
        wenxu <wenxu@ucloud.cn>, Alexei Starovoitov <ast@fb.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] tunnel: fix dev null pointer dereference when send
 pkg larger than mtu in collect_md mode
Message-ID: <20190816040131.GY18865@dhcp-12-139.nay.redhat.com>
References: <20190815060904.19426-1-liuhangbin@gmail.com>
 <cb5b5d82-1239-34a9-23f5-1894a2ec92a2@gmail.com>
 <20190816032418.GX18865@dhcp-12-139.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190816032418.GX18865@dhcp-12-139.nay.redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 16, 2019 at 11:24:18AM +0800, Hangbin Liu wrote:
> If yes, how about just set the skb dst to rt->dst, as the
> iptunnel_xmit would do later.
> 
> skb_dst_drop(skb);
> skb_dst_set(skb, &rt->dst);
> 

Tested and this donesn't work good....
