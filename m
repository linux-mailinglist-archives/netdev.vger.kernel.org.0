Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D78AD210BC0
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 15:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729503AbgGANHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 09:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729326AbgGANHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 09:07:08 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42684C03E979
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 06:07:08 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id h28so19655465edz.0
        for <netdev@vger.kernel.org>; Wed, 01 Jul 2020 06:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rRAeBW81k+yJUiZ1aCgmBuge1Mw8P6poJBDFtaEUHHA=;
        b=w7TOiFzpIcTkvMeli+ufI37FATl+mPtODM/gMd5N2yEy64/hSWUgNi0M7GRsC2SoKp
         vluvJi1eCh9EGPreLhJwLkFat2EUur24weiihqKyMOskr2qFZ3MMHNS8zlUl0WEyBjym
         +RYEhGBojNym82JmjPLT/JCVEa7GYmHq+F7emoWp4Rqiy6ISdFVBROYKxCJqyNYTIIa4
         IT8c4fRo/oOjm6r73PjuadoPOKTGRz/W11c9A2ypqSJTVTZzKw2uEjEmCd2hQYY4nWvD
         SftpcCqTh8KmoI5aN1HQd/fCc8FNcY2+wbL1611QQmIXsK0a16ORm+KrHrIFk9qvK7Us
         i6OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rRAeBW81k+yJUiZ1aCgmBuge1Mw8P6poJBDFtaEUHHA=;
        b=ep2mXmuHnwv+YbA1y2GmpnoRZQh8uOmn3hwSW26qeJ90e2OwwwfBD0qHOldEcDMN6/
         M+GKhRnrzJtPp9EeTxnAQ4yQxCIMzJ2fKuodr/SuHwRJRlPPKq//29ILCX50tzjHouup
         fIN577fCMZlxwfOY6p4pUL064Z4/1kzj6lBB+i9nO88Z29W4N7uNAr2y05+qBhBslbO/
         kY6ab6Uv9+rmbf1fUyP7jq59E03pMs/p67DdfXNblaS6RHrOsuZK5k+7OLoSjWAr6NVg
         hZ9DT7b42qNomqmuYi2XITa0ExGoj8Wp52jbAJa/e7RroP8uWq7GZNt4R4J7QWSGwI1+
         MKlA==
X-Gm-Message-State: AOAM533dv7qIhRuUdBlEbNBOCSwCBwU2A7VYmNNzJnFiatoZ08BMBZ/p
        g4iqOafLiAlGRTPMfEF/zIfy0B3gO2s=
X-Google-Smtp-Source: ABdhPJzYQ2QPPE2Zc48OOSRTdC9G+PpdeNI1XSSyPVh8fbUz2bJXb6bS32Y+OsPMsoGbGEbfn2qIZw==
X-Received: by 2002:a50:ba8b:: with SMTP id x11mr29785786ede.201.1593608826951;
        Wed, 01 Jul 2020 06:07:06 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([81.246.10.41])
        by smtp.gmail.com with ESMTPSA id l1sm6343978edi.33.2020.07.01.06.07.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jul 2020 06:07:06 -0700 (PDT)
Subject: Re: [PATCH net-next 2/2] mptcp: add receive buffer auto-tuning
To:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Cc:     mptcp@lists.01.org
References: <20200630192445.18333-1-fw@strlen.de>
 <20200630192445.18333-3-fw@strlen.de>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <26e2e166-ffcc-d53c-21f1-c35bf456655a@tessares.net>
Date:   Wed, 1 Jul 2020 15:07:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200630192445.18333-3-fw@strlen.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On 30/06/2020 21:24, Florian Westphal wrote:
> When mptcp is used, userspace doesn't read from the tcp (subflow)
> socket but from the parent (mptcp) socket receive queue.
> 
> skbs are moved from the subflow socket to the mptcp rx queue either from
> 'data_ready' callback (if mptcp socket can be locked), a work queue, or
> the socket receive function.
> 
> This means tcp_rcv_space_adjust() is never called and thus no receive
> buffer size auto-tuning is done.
> 
> An earlier (not merged) patch added tcp_rcv_space_adjust() calls to the
> function that moves skbs from subflow to mptcp socket.
> While this enabled autotuning, it also meant tuning was done even if
> userspace was reading the mptcp socket very slowly.
> 
> This adds mptcp_rcv_space_adjust() and calls it after userspace has
> read data from the mptcp socket rx queue.
> 
> Its very similar to tcp_rcv_space_adjust, with two differences:
> 
> 1. The rtt estimate is the largest one observed on a subflow
> 2. The rcvbuf size and window clamp of all subflows is adjusted
>     to the mptcp-level rcvbuf.
> 
> Otherwise, we get spurious drops at tcp (subflow) socket level if
> the skbs are not moved to the mptcp socket fast enough.
> 
> Before:
> time mptcp_connect.sh -t -f $((4*1024*1024)) -d 300 -l 0.01% -r 0 -e "" -m mmap
> [..]
> ns4 MPTCP -> ns3 (10.0.3.2:10108      ) MPTCP   (duration 40823ms) [ OK ]
> ns4 MPTCP -> ns3 (10.0.3.2:10109      ) TCP     (duration 23119ms) [ OK ]
> ns4 TCP   -> ns3 (10.0.3.2:10110      ) MPTCP   (duration  5421ms) [ OK ]
> ns4 MPTCP -> ns3 (dead:beef:3::2:10111) MPTCP   (duration 41446ms) [ OK ]
> ns4 MPTCP -> ns3 (dead:beef:3::2:10112) TCP     (duration 23427ms) [ OK ]
> ns4 TCP   -> ns3 (dead:beef:3::2:10113) MPTCP   (duration  5426ms) [ OK ]
> Time: 1396 seconds
> 
> After:
> ns4 MPTCP -> ns3 (10.0.3.2:10108      ) MPTCP   (duration  5417ms) [ OK ]
> ns4 MPTCP -> ns3 (10.0.3.2:10109      ) TCP     (duration  5427ms) [ OK ]
> ns4 TCP   -> ns3 (10.0.3.2:10110      ) MPTCP   (duration  5422ms) [ OK ]
> ns4 MPTCP -> ns3 (dead:beef:3::2:10111) MPTCP   (duration  5415ms) [ OK ]
> ns4 MPTCP -> ns3 (dead:beef:3::2:10112) TCP     (duration  5422ms) [ OK ]
> ns4 TCP   -> ns3 (dead:beef:3::2:10113) MPTCP   (duration  5423ms) [ OK ]
> Time: 296 seconds
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Thank you for adding this very useful feature!

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
