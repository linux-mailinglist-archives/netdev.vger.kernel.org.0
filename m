Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDF12A9365
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 10:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbgKFJvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 04:51:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbgKFJvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 04:51:32 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F9CEC0613D3
        for <netdev@vger.kernel.org>; Fri,  6 Nov 2020 01:51:32 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id o9so1074277ejg.1
        for <netdev@vger.kernel.org>; Fri, 06 Nov 2020 01:51:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=malat-biz.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9IBtvz1xb0AHqlIyVvrG0wyMkGPT2R1uF6Ltx4fuS1Q=;
        b=SAtXTf1XTB2iVd5TsH8z3gKUSMvhnZmXeL+fzOMchO4JYyHTivLWInorPoNF1DFORj
         j8lXfXmgtXu+LcfNo4JD7X/kZD5JqBa5Sf75iYnWT1zVOVCVhwDLvnHBJQIRBo0PEPpR
         2R/cJBBtyoU1IKHW2m2J9wLN0y1SldbIzR4n6eyWustw2bynhVWuiSODN6OzGbBkequZ
         UYTantj+YB5gOLlQtB/RipsFf4kztiwyb1ksnx/etvPWbpL2Sb/hBy1qM3ryYc2fsIhr
         sv1si2l3sOINQX3318hskJopCjJYeJ7xWUMTKwi1DyB3OvrKJMzCkm66nBD9cX2p+Lrx
         jObw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9IBtvz1xb0AHqlIyVvrG0wyMkGPT2R1uF6Ltx4fuS1Q=;
        b=Au/+TZaG8sn3vRnpofT88FGGvD89XhPWVzVq4ysaUDT/q1vyFS0NIwLucYvqK/Yx8s
         STABTe16iPUS+fIurkO5GNRD/gcvYEBEffsZq5AdmBKQ1m1YYMHs5VXBXSTOLFEKHIqe
         a3YhuvyacEwnVHwzl/vMqIPUrwMh4Ae3epJFRRdCNTHzCgAmkpCrLKejT1CDEIkI3tsH
         Q4HKgRpy55DQYf74dSEvq8P43OqHYbU+x9EdSt2/o+vKNn/+y45LIguXXj0Ve8AlCbFa
         Cycl4J0n/t6wCkdEJE7RH1qyEC/MDCLGKesXBeAmQY6uF/lXM7cHE39Rx0FltBPHLis3
         9+zA==
X-Gm-Message-State: AOAM53201nxmITAMtfftOyisEWwL0mK9v3+bwoxfiILI7D9/G07Pplgj
        N2Y26mZKkI6DtRUHqIIuCGqE8Q==
X-Google-Smtp-Source: ABdhPJw46RbOpExLWqlAV9SWFLIsfa1kfttjTMIHD/W89boZnOgzyIxJi3jf6mmoTPl+/LfXcidpuQ==
X-Received: by 2002:a17:907:264d:: with SMTP id ar13mr1167369ejc.207.1604656290864;
        Fri, 06 Nov 2020 01:51:30 -0800 (PST)
Received: from bordel.klfree.net (bordel.klfree.cz. [81.201.48.42])
        by smtp.gmail.com with ESMTPSA id k11sm603182edh.72.2020.11.06.01.51.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 01:51:30 -0800 (PST)
Date:   Fri, 6 Nov 2020 10:48:24 +0100
From:   Petr Malat <oss@malat.biz>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sctp: Fix sending when PMTU is less than
 SCTP_DEFAULT_MINSEGMENT
Message-ID: <20201106094824.GA7570@bordel.klfree.net>
References: <20201105103946.18771-1-oss@malat.biz>
 <20201106084634.GA3556@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201106084634.GA3556@localhost.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 06, 2020 at 05:46:34AM -0300, Marcelo Ricardo Leitner wrote:
> On Thu, Nov 05, 2020 at 11:39:47AM +0100, Petr Malat wrote:
> > Function sctp_dst_mtu() never returns lower MTU than
> > SCTP_TRUNC4(SCTP_DEFAULT_MINSEGMENT) even when the actual MTU is less,
> > in which case we rely on the IP fragmentation and must enable it.
> 
> This should be being handled at sctp_packet_will_fit():

sctp_packet_will_fit() does something a little bit different, it
allows fragmentation, if the packet must be longer than the pathmtu
set in SCTP structures, which is never less than 512 (see
sctp_dst_mtu()) even when the actual mtu is less than 512.

One can test it by setting mtu of an interface to e.g. 300,
and sending a longer packet (e.g. 400B):
>           psize = packet->size;
>           if (packet->transport->asoc)
>                   pmtu = packet->transport->asoc->pathmtu;
>           else
>                   pmtu = packet->transport->pathmtu;
here the returned pmtu will be 512

> 
>           /* Decide if we need to fragment or resubmit later. */
>           if (psize + chunk_len > pmtu) {
This branch will not be taken as the packet length is less then 512

>            }
> 
And the whole function will return SCTP_XMIT_OK without setting
ipfragok.

I think the idea of never going bellow 512 in sctp_dst_mtu() is to
reduce overhead of SCTP headers, which is fine, but when we do that,
we must be sure to allow the IP fragmentation, which is currently
missing.

The other option would be to keep track of the real MTU in pathmtu
and perform max(512, pathmtu) in sctp_packet_will_fit() function.

Not sure when exactly this got broken, but using MTU less than 512
used to work in 4.9.
  Petr
