Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 390573554C5
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 15:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242395AbhDFNQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 09:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbhDFNQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 09:16:41 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 435E9C06174A;
        Tue,  6 Apr 2021 06:16:33 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id n8so3922988lfh.1;
        Tue, 06 Apr 2021 06:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=oK0EvQq5supIkmdytebd79wfYwhuD8P3BwaCXG7Z7hI=;
        b=JwlFh059EWXARC3pWryr8G4rNFVgyPGcRFcZR3fc1UgSmW+vYxbhtLzBO+4CJ6B11T
         +nQxQB1ezl2f0aEoqMYI/rwPLzu5Iw9feXGZqkS5LCAUws+2QhLEZ8ORgEYpagBJqfsB
         sUq3rnvJbBNT08uEY+s8kNnzOmibxNNxrRxeIbXStWNmc5HIEJl0f/nfoRRgPFCD9tuK
         tYPDue4tqXb7ytfEbotfk6cbw98fMsYZtEItNYm+w5WNkHDKyHJu9dOsN8ZSSbN3tfo4
         dVl8WfepjQsBc9LdtMpvvHqSfsP45sKKPoGOjBA1m0/rdBeyGGlm2pdKGF31XhEdG4Bf
         o0Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=oK0EvQq5supIkmdytebd79wfYwhuD8P3BwaCXG7Z7hI=;
        b=jAJIluhf9XnmHn/r2DpWyVp9cZhWtV9WVphqmGL5BfBzV/7pRtBrHlnv7aGs/RDtjU
         eOb+uqlvF0/+YMu45ffTWxxGEIIc1jW5sRy1uI7BS+VO9Wr81Fr1pg7lhd2+0wIakqOS
         u5qpJJUAPFv3j01MBuUT3zIekrqbAr+QoTaPWOZsxJ7lJ75Fg0de5Tz2nxxjedGmsiO8
         913G1kuY3pZxNSvqtmZAAWl3+DLQwN+D+dUqNv6CADiK18wibAON5gmI7QymzQXiQ7XJ
         zqCEg/w8fBVFruyz5hCO3kPw3oE82UJCDIPqilQQlznSEaqD1FJNGpVL6yRzIPMtfu+G
         xfxw==
X-Gm-Message-State: AOAM533lP8HRiWEyByAalQL3fzKRbt0mgKLKMVTD3Q20eO+iqcDAzMGG
        nbV6+q7L50S40Lop6QhtRgyacp3nDsaEfL+E
X-Google-Smtp-Source: ABdhPJzDhp+uGFjyYrbpEJDXoTUzaRZ6JV3//HVJvbSnqFgMDmHs32s/CEiY0zu/w/kQgWc+yhkd6A==
X-Received: by 2002:a19:242:: with SMTP id 63mr3139544lfc.0.1617714991761;
        Tue, 06 Apr 2021 06:16:31 -0700 (PDT)
Received: from [192.168.1.11] ([94.103.229.149])
        by smtp.gmail.com with ESMTPSA id x27sm2158024lfn.95.2021.04.06.06.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 06:16:31 -0700 (PDT)
Message-ID: <f8af54cece4150b2a0ac7db4e73bfcda36da5555.camel@gmail.com>
Subject: Re: [PATCH] net: fix shift-out-of-bounds in nl802154_new_interface
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        syzbot <syzbot+7bf7b22759195c9a21e9@syzkaller.appspotmail.com>
Date:   Tue, 06 Apr 2021 16:16:29 +0300
In-Reply-To: <CAB_54W7R-27cwOTUw1Db1+kbWTMTtRn0X2EW1_9nKuiAWpLFfA@mail.gmail.com>
References: <20210405195744.19386-1-paskripkin@gmail.com>
         <CAB_54W7R-27cwOTUw1Db1+kbWTMTtRn0X2EW1_9nKuiAWpLFfA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-04-06 at 08:21 -0400, Alexander Aring wrote:
> Hi,
> 
> On Mon, 5 Apr 2021 at 15:58, Pavel Skripkin <paskripkin@gmail.com>
> wrote:
> > 
> > syzbot reported shift-out-of-bounds in nl802154_new_interface.
> > The problem was in signed representation of enum nl802154_iftype
> > 
> > enum nl802154_iftype {
> >         /* for backwards compatibility TODO */
> >         NL802154_IFTYPE_UNSPEC = -1,
> > ...
> > 
> > Since, enum has negative value in it, objects of this type
> > will be represented as signed integer.
> > 
> >         type = nla_get_u32(info->attrs[NL802154_ATTR_IFTYPE]);
> > 
> > u32 will be casted to signed, which can cause negative value type.
> > 
> > Reported-by: syzbot+7bf7b22759195c9a21e9@syzkaller.appspotmail.com
> > Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> 
> Yes, this patch will fix the issue but we discussed that the problem
> is deeper than such a fix. The real problem is that we are using a -1
> value which doesn't fit into the u32 netlink value and it gets
> converted back and forward which we should avoid.
> 

OK, thanks for feedback!

> 
> - Alex

With regards,
Pavel Skripkin


