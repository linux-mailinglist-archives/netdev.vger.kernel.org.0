Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6FC839E0
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 21:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbfHFTxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 15:53:03 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:40376 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbfHFTxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 15:53:03 -0400
Received: by mail-oi1-f195.google.com with SMTP id w196so47066804oie.7;
        Tue, 06 Aug 2019 12:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KmU4HJB87X8xhCUfLfjkNelVmkZzhKKTTRnmGP3cf9U=;
        b=BVtj3Pifd5xr8+HJJFf4aJmYb9qybfaNXVqzIbEG9IIKBACsE97O8oil++vm+WDz3f
         nwOXAtDNiBE7kkTXWbyXNkrR+vUtboSqYBexi4cmkHKKx7Y21RHWf/TsIXh3OBqiyIn8
         kgEQgTkoUh/m6QVIPewlvTNVT86h2iU2w+1lZdEgSBVTfAwvY//38uEdGIsb4WBXzu8E
         RtebHHU2dCD/UM/5K4RmeMlAuyvypIJ+aMUFGDELhsZ/gBs2lRUspxTgyblGARaakmS/
         jYdNYkRuTEeqR5OiWTKp1kL44ROEmsy+3efPL++mXO8wtBHa7t8tiqTJYwKg+5X01RXs
         HRXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KmU4HJB87X8xhCUfLfjkNelVmkZzhKKTTRnmGP3cf9U=;
        b=SyedbWa9rkKeaR379l6VCKXeVG2clB3EBZH1G8q87s02Z+YOnQ5bFlrQQ/oxK/aBfs
         wLOCLm/lF34psAb5Ai3x3AKYs8BjsyEKoDiwanJ01fu0WrBPnb62XI7WyB6KKIPBBBlz
         3Hapfn0WuRDwsEdoLwHd7M33Ezvf142Os4oSc6nq9CN2oElKgkX6BigZjSLQe5LxJVL8
         Ch0Rt7kWOUrjhG4mevCLyUA55Ib+wZOkJDbv2KtpNniSZo2JFjqXE5h2YjnTxWhhFIM6
         unXbMqFJouqbkrxrrpdy2szXXH7sK/bXQK7lVmTBxTcQ7HhGl2X5nsVDZqsMmL6raiYS
         tCRg==
X-Gm-Message-State: APjAAAXc+NPex6TofDWDUsmRGPecv9wV5HoJfvEj/JydACIhp+JvvERX
        /YIFTe3a+wclvSZ6hQwxkeUi8HvKc/Sc75UmDwQ3RPVj
X-Google-Smtp-Source: APXvYqx+q743nGPHX6aJH/9jIqgTQd8k5xwXFPshKqY+NszZolvWwtyutRRUfJ99Fcu5s3o7aw9Mdlg1WTzTh9OMidI=
X-Received: by 2002:a02:cd82:: with SMTP id l2mr5991247jap.96.1565121182404;
 Tue, 06 Aug 2019 12:53:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190806092919.13211-1-firo.yang@suse.com> <20190806.113640.171591509807004446.davem@davemloft.net>
In-Reply-To: <20190806.113640.171591509807004446.davem@davemloft.net>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 6 Aug 2019 12:52:51 -0700
Message-ID: <CAKgT0UctiHjKxGXHJEiJX4_aEJt1swBAxMOKPT9huXBOcf+2VQ@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH 1/1] ixgbe: sync the first fragment unconditionally
To:     David Miller <davem@davemloft.net>
Cc:     firo.yang@suse.com, Netdev <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 6, 2019 at 11:36 AM David Miller <davem@davemloft.net> wrote:
>
> From: Firo Yang <firo.yang@suse.com>
> Date: Tue, 6 Aug 2019 09:29:51 +0000
>
> > In Xen environment, if Xen-swiotlb is enabled, ixgbe driver
> > could possibly allocate a page, DMA memory buffer, for the first
> > fragment which is not suitable for Xen-swiotlb to do DMA operations.
> > Xen-swiotlb will internally allocate another page for doing DMA
> > operations. It requires syncing between those two pages. Otherwise,
> > we may get an incomplete skb. To fix this problem, sync the first
> > fragment no matter the first fargment is makred as "page_released"
> > or not.
> >
> > Signed-off-by: Firo Yang <firo.yang@suse.com>
>
> I don't understand, an unmap operation implies a sync operation.

Actually it doesn't because ixgbe is mapping and unmapping with
DMA_ATTR_SKIP_CPU_SYNC.

The patch description isn't very good. The issue is that the sync in
this case is being skipped in ixgbe_get_rx_buffer for a frame where
the buffer spans more then a single page. As such we need to do both
the sync and the unmap call on the last frame when we encounter the
End Of Packet.
