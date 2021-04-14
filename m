Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A03D635F51E
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 15:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351517AbhDNNlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 09:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351506AbhDNNlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 09:41:12 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 053BFC061574;
        Wed, 14 Apr 2021 06:40:50 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id h4so10896387wrt.12;
        Wed, 14 Apr 2021 06:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3/hUJE1/0e4Sy7DgTurC8EOEw9A7fU9QoNPLG2ViTic=;
        b=bfKMPXjqMqqNzL1u+MOUZU3TcWBd4LJsTqAjttUfEoq9HB9LcAb+waz+NWjr0FoCCt
         sXt4dSejwSGaS0ZHG+GDe/M9gPtS0LQo8HOJOHcVasdVg3QTSc2wdmP7PSdXKBHDUGiT
         iDIoC5CQ+sbfYxt16faHnGSoCGhQ8sKKj3kIEj9b9ymr1xJDRhqbERnB77gsL/tKaj1T
         IP14V0Gnj+LHINDv5TMDBdCZvnvKSp109IBZg8nUUZkY4+ITfESwdueIYPb2HDTnf1BF
         aBzW5UrJtk5IWFfdXnfSYgl8GCJrGs2X6VdtN/DhzQQTLfWc/VH1LSdWbFZnUmAhpSxc
         TYZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3/hUJE1/0e4Sy7DgTurC8EOEw9A7fU9QoNPLG2ViTic=;
        b=JBZOzUea5oqEiuzT17ZwJpK9EpgjUyLJh4QBqDlhgH9fmfMf7VUaQbtDh+qC0x+gs+
         xX/kQuSWtNBU8uN78y3LQ9iaB4/hZ0sq9UsXM6ck7lSe6dtsET7yNfxnUsljM6p6q0qH
         EbbyGSxXdl4NIxvR0EADQnNeHGFDHTc7at1oXqwdjKdkuWi2FKjOgMohjN1LsH2IiOqk
         +6JdgcCOqnAi5UDT2qowGPthjPIIDV7rOkRQGTfv9sY9Alv0pO145IBp1DVEAKzAOv3g
         1uFhEag89JQavuF/ZkpoFCvcaatr1pBOONanJt1Ts7tUjVQhK/AHILskjjXeRKIAOa2R
         mJhA==
X-Gm-Message-State: AOAM532yde6Rjc2SWrRhFKQMhpRV6bEmHxGiwFCst/2guoEBjZyLbMq4
        o456A2Q8zyGXm6gTT9l2dvURrg/Jn8PLGZfV80o=
X-Google-Smtp-Source: ABdhPJxuJ1T6ntwerbNSYGHb4Mg2TPLwpec/axK/UN4TcQLoCH16yl3RFFeDO9Yag1sOHrqUqcbWQFlEWRgMdmshxbQ=
X-Received: by 2002:adf:e34f:: with SMTP id n15mr42736058wrj.224.1618407648696;
 Wed, 14 Apr 2021 06:40:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210409003904.8957-1-TheSven73@gmail.com> <0bf00feb-a588-12e1-d606-4a5d7d45e0b3@linux.ibm.com>
 <CAGngYiXyQEui8+OiVQXe1UeypQvny_hr=qtuOri7r2guxVDm9g@mail.gmail.com> <089f6b41-29ee-7a4a-dde0-c2d5de2534bf@linux.ibm.com>
In-Reply-To: <089f6b41-29ee-7a4a-dde0-c2d5de2534bf@linux.ibm.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Wed, 14 Apr 2021 09:40:37 -0400
Message-ID: <CAGngYiUSkBA7ZG5hx-zaKVghME3kWKk_x5ZPWokuxkdzg+KDAA@mail.gmail.com>
Subject: Re: [PATCH net v1] lan743x: fix ethernet frame cutoff issue
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        George McCollister <george.mccollister@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Julian,

On Wed, Apr 14, 2021 at 9:33 AM Julian Wiedmann <jwi@linux.ibm.com> wrote:
>
> __netdev_alloc_skb_ip_align() already reserves the NET_IP_ALIGN part.
> So when the NIC stores into the dma-mapped skb->data parts, each
> fragment will automatically have the required alignment - even when
> you only care about the first fragment's alignment.
>

That's really interesting! I'm going to try that out.
