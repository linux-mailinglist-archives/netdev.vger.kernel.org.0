Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A559F56B30C
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 09:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbiGHHAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 03:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237400AbiGHHAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 03:00:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EF5DC74DC5
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 00:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657263614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2UDSJOrzjkP1xJhn9ewHzP+5HWa2b/wjbrG2J/UB9Nw=;
        b=iOhsXLZ9XsOe5gNE7r2XcRJNRiulkkhpYQm/Ggay8FDUxiioKjwWvs6WhUkV9n9HdYYgmU
        D1uFqkBo/0IdhOjiQ74s4Rirtw4Dl7IWBTkVNadwt/fWPaYALEOpD4RsnhUiIJgUIZcl0/
        kwbOLxyb+e/c4rq0mg0BwaDJIjT5ENU=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-574-vFPRl6JHPKOg4BmPYhsxZw-1; Fri, 08 Jul 2022 03:00:12 -0400
X-MC-Unique: vFPRl6JHPKOg4BmPYhsxZw-1
Received: by mail-lf1-f70.google.com with SMTP id f40-20020a0565123b2800b0048454c5aec2so3715656lfv.1
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 00:00:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=2UDSJOrzjkP1xJhn9ewHzP+5HWa2b/wjbrG2J/UB9Nw=;
        b=TueDNXBLfubMUK57He5HdG5bez1hjVjs9ZIvh9+Gh9W7fQcoTPgvkH558AyRZ8gElP
         xGRGCGclhrN9vlaZpxSrxhw2/ULVw/bF8YxbF948JfTJu/nVRIID9bMZ2Leb8uYoGwHC
         wCdpMmfOWHLUjdIKE2qBv5qqM32MIUag28jy3mGE+pi9AswaePPOAMPxKsC9BOSEKvwB
         fIfnhyF5R99HEFO0T6UDWO2TDYQyZNGbowcnbAM6lKZ0Md1jUM3x53ktkLymBOL6TlG5
         c1AvSdMw0gUYSihml0geEUH5faTGAMInpJCaK6SLIWJxLzXDk4cB4Apl5T5adELqyTTP
         JroQ==
X-Gm-Message-State: AJIora8yWE12Y2c31pasZnbHI6wBgGa/dDqFQRngGXztEIGuO4whVqdn
        kX3YfWQ0tTb4MkPqE95u6JD3qCwNO0bPjk9EhRnb/FYYX6ACJMXIlVTu5sWsW8CGI/ziqsfPODH
        wLGpaov5DLswq2YHU
X-Received: by 2002:a05:6512:12d3:b0:483:4a93:8b3 with SMTP id p19-20020a05651212d300b004834a9308b3mr1336536lfg.402.1657263611300;
        Fri, 08 Jul 2022 00:00:11 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uWQ/NGmYK2r3YIilwM4mOvqDVl0fdNjnwNjCNp0vG3uKF8p94q4lC37sTDvmaQysRQrNb71A==
X-Received: by 2002:a05:6512:12d3:b0:483:4a93:8b3 with SMTP id p19-20020a05651212d300b004834a9308b3mr1336523lfg.402.1657263610957;
        Fri, 08 Jul 2022 00:00:10 -0700 (PDT)
Received: from [192.168.0.50] (87-59-106-155-cable.dk.customer.tdc.net. [87.59.106.155])
        by smtp.gmail.com with ESMTPSA id t6-20020a056512208600b0047f79487758sm7243922lfr.133.2022.07.08.00.00.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jul 2022 00:00:10 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <58e538d6-d1cd-4689-694e-e14d91c47d41@redhat.com>
Date:   Fri, 8 Jul 2022 09:00:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Cc:     brouer@redhat.com, Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: netdev stats for AF_XDP traffic
Content-Language: en-US
To:     Srivats P <pstavirs@gmail.com>, Xdp <xdp-newbies@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
References: <CANzUK5_qwaRm=9c46yH8d_J54PAcNhZB-R5M=wYgXGGaJJaFAA@mail.gmail.com>
In-Reply-To: <CANzUK5_qwaRm=9c46yH8d_J54PAcNhZB-R5M=wYgXGGaJJaFAA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 08/07/2022 08.19, Srivats P wrote:
> Hi,
> 
> Is there any update on the "consistency for XDP statistics" [1]
> high-prio work item from the xdp-project.net project management page?

Lorenzo (cc) have done cleanups in several drivers, both mvneta and
veth, but not mlx5. Ahern (cc) also had an interest earlier.


> More specifically the fact that the mlx driver (are there others too?)
> don't update netdev/ifconfig stats for XDP/AF_XDP traffic? 

IMHO the drivers MUST update the netdev/ifconfig RX stats, even when an
XDP action is taken.  XDP-progs are user installed software, and not
updating netdev RX-stats (for some XDP actions) is very confusing for
all existing stats collector tools.
The mlx drivers are (sadly) the most inconsistent if I remember correctly.

> The email thread started for that item dates from 2018 and hasn't
> seen any updates after that.
I think nobody have really had the time to fix up this inconsistent
stats mess.

Are you interested in working on this?


> I see some recent patch/commit activity about XDP specific stats via
> netlink but I believe this is different from the standard
> netdev/ifconfig stats.

Yes, if taking this "task", I recommend focusing on standardizing
netdev/ifconfig stats behavior for XDP.  Solving the other XDP specific
stats is a much larger task with much upstream discussions required.

> Srivats
> 
> [1] https://xdp-project.net/#Consistency-for-statistics-with-XDP
> 

--Jesper

