Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEE83132178
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 09:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727584AbgAGIfx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 7 Jan 2020 03:35:53 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:45973 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbgAGIfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 03:35:53 -0500
Received: by mail-ed1-f68.google.com with SMTP id v28so49626586edw.12;
        Tue, 07 Jan 2020 00:35:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=4NPbL5gfhr82BUT1F8pxPLF2ghzVDIFlv2yg5NjGG5M=;
        b=fUk9SKmlX8LagpLK9eeISQ+sk1eNOCusNZYfclzE9pURPuJ7Fsr2S/C33tPJHJ6wxU
         GH3CXgiGzTTm8Ai9UNAWufvYobb0mq4xo2KoOYGogNLZdGRgr6tWD2ZZDeAfmaG14JBn
         1XE6hsuz2adCtfFKcmY0CrGOedW8oE+3o99R6LeHEe8DF2SsZhjmhawNImTPlMI4icts
         +BzGAZFToCQtiBF00P/U1uYLcXUaOvv1lk1PuBpBc4Vsa5pflOGpOv8gr2NQr0H+gboL
         tRoZY+S0rmOsrEJjKu19sxpQP46ShF//iJkDF2ngEKG4c8HPTLRxFPGShzm6TDY5yMlO
         j/QQ==
X-Gm-Message-State: APjAAAXX/gOkJYNf4qiF77LnzfSSVUiCwl14cfbwpzCa5lM2U9xy93G6
        LV1UfBbQgyt53T8ejsyKgnxN1Jqv
X-Google-Smtp-Source: APXvYqyEpGGSHizJFu4q7AZbNrpA3xN2XeePmWxFFUvPAbTS4xzuSkWc58Bib3qx5TWcDqiNWXR3qQ==
X-Received: by 2002:a17:906:9248:: with SMTP id c8mr113760646ejx.37.1578386151548;
        Tue, 07 Jan 2020 00:35:51 -0800 (PST)
Received: from pi3 ([194.230.155.149])
        by smtp.googlemail.com with ESMTPSA id u23sm7441830edq.74.2020.01.07.00.35.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 00:35:50 -0800 (PST)
Date:   Tue, 7 Jan 2020 09:35:48 +0100
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     David Miller <davem@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] net: ethernet: 3c515: Fix cast from pointer to
 integer of different size
Message-ID: <20200107083548.GA31906@pi3>
References: <20200104143306.21210-1-krzk@kernel.org>
 <20200106.133155.1221137250116950495.davem@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200106.133155.1221137250116950495.davem@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 06, 2020 at 01:31:55PM -0800, David Miller wrote:
> From: Krzysztof Kozlowski <krzk@kernel.org>
> Date: Sat,  4 Jan 2020 15:33:05 +0100
> 
> > Pointer passed as integer should be cast to unsigned long to
> > avoid warning (compile testing on alpha architecture):
> > 
> >     drivers/net/ethernet/3com/3c515.c: In function ‘corkscrew_start_xmit’:
> >     drivers/net/ethernet/3com/3c515.c:1066:8: warning:
> >         cast from pointer to integer of different size [-Wpointer-to-int-cast]
> > 
> > Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> > 
> > ---
> > 
> > Only compile tested
> 
> Sorry, I'm not applying these two.
> 
> It is clear that these drivers only work properly on 32-bit architectures
> where virtual address equals the DMA address.
> 
> Making this warning goes away creates a false sense that they are in
> fact 64-bit clean and capable, they are not.

The existing casts are clearly wrong - the convention is that pointer
should be cast to unsigned long, not int. In the second case it is even
weirder - the buffer array is actually unsigned long so the cast is
confusing.

However I understand your argument that these casts serve as a
documentation purpose of only 32-bit support, so let it be.

Thanks!

Best regards,
Krzysztof

