Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5FA89D439
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 18:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732892AbfHZQlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 12:41:51 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:33645 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729344AbfHZQlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 12:41:51 -0400
Received: by mail-ed1-f67.google.com with SMTP id s15so27377538edx.0
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 09:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=sUOyFBT2+8QqNk5UJQIBj6nCxO+4SHMbLqF7J7W/NhI=;
        b=LrOoB8mx7pwy349C38sVSk3ZgMzTc/zFD3rmQww2ovzBa6mV9c48mAMHVruoePFfKI
         YJOdX2aAgJBsD5nlz/or/tNH/F1Cd/tOVg9g+CC44sh0taWQ0IhbrkDtz6BEe/K9M56p
         Zh129KoOT3usmeT2/UgmpEsyO3f8OcTUKB1qx0nuNSqK42UbAHyAp7UbQ/VmDVqr0vnO
         f+trBL1Awdu3i2+4DBzzDsqP5ZVbYzwR6aQ8e58L3q7XGQE1J+94ixPNyCor552hInGn
         RfA9dln1blHWPuMyea1MJ2+OerKUjaY/86qEu7OZTO+KJYBi9mHt5Ns6NgaJjmX7cTdG
         NNWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=sUOyFBT2+8QqNk5UJQIBj6nCxO+4SHMbLqF7J7W/NhI=;
        b=Xnmfu5JO82Bwbpqs2akQMdC0ckns4aeu59/G5sbsX4MkdJmypQq5xVYe48bgj/xiph
         etSKDvlfcCiyOl4bTnK6zqAck7k2Lr/jWhI3b2S9rLQg3idT8elPlLmAr2gvKSVeC3KX
         U0Hb8VNr7kCEYmpoqymcyZRdr8FN7gvNivVfr0n8UqCTjD0pD2FovdOH0zPzc4aPgrrX
         FbllFy4B0UGukvwWPCHDspP3QaHfm06QCtkKWuhGPwxXNPPfYOtBcLPhSufDSyJPzaL0
         Zl95cSyt8B+g29UfO/kypjbsLRG28izhScjyMk46tuHd3Ier2ERv4WEUn2sXUzM6xmLd
         GLWg==
X-Gm-Message-State: APjAAAUcuw6pmuNNn3IrsyXHGj0me6nh9WRKaPKqUXpVpFNou/lySrRg
        2zoIE//2BpZQEV/RfNE0SLVipBxmvUQ=
X-Google-Smtp-Source: APXvYqzY4N30xw3vQHFEyJ5Xq6qPEyBfCSuJzko5PdbB5tOoObXrkYkezylbeknuj0Tf8aF0qs31tA==
X-Received: by 2002:a05:6402:8c9:: with SMTP id d9mr19437197edz.154.1566837710037;
        Mon, 26 Aug 2019 09:41:50 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id f6sm1405942edn.63.2019.08.26.09.41.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 09:41:49 -0700 (PDT)
Date:   Mon, 26 Aug 2019 09:41:29 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Song Liu <liu.song.a23@gmail.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        OSS Drivers <oss-drivers@netronome.com>,
        Jiong Wang <jiong.wang@netronome.com>
Subject: Re: [PATCH bpf] nfp: bpf: fix latency bug when updating stack index
 register
Message-ID: <20190826094129.3d28ce64@cakuba.netronome.com>
In-Reply-To: <1417962c-e63d-6c46-bf07-9284f5332583@iogearbox.net>
References: <20190824020028.6242-1-jakub.kicinski@netronome.com>
        <CAPhsuW7_dSEPJOdKApQFU-aVmEXgOwmqLS7S1FC4JtnzjR6OiQ@mail.gmail.com>
        <CAJpBn1z736w5_uv7apwyy82vzcnc9c5Gua_9ZyUy-pSEwnQewA@mail.gmail.com>
        <CAADnVQ++TEUK=Cb3sCyunFyYFcpXu=NK71P4-1rEWEGCGewU7A@mail.gmail.com>
        <1417962c-e63d-6c46-bf07-9284f5332583@iogearbox.net>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Aug 2019 18:25:10 +0200, Daniel Borkmann wrote:
> On 8/26/19 6:18 PM, Alexei Starovoitov wrote:
> > On Mon, Aug 26, 2019 at 8:57 AM Jakub Kicinski
> > <jakub.kicinski@netronome.com> wrote:  
> >> On Sun, Aug 25, 2019 at 10:37 PM Song Liu <liu.song.a23@gmail.com> wrote:  
> >>> On Fri, Aug 23, 2019 at 7:04 PM Jakub Kicinski wrote:  
> >>>> From: Jiong Wang <jiong.wang@netronome.com>
> >>>>
> >>>> NFP is using Local Memory to model stack. LM_addr could be used as base of
> >>>> a 16 32-bit word region of Local Memory. Then, if the stack offset is
> >>>> beyond the current region, the local index needs to be updated. The update
> >>>> needs at least three cycles to take effect, therefore the sequence normally
> >>>> looks like:
> >>>>
> >>>>    local_csr_wr[ActLMAddr3, gprB_5]
> >>>>    nop
> >>>>    nop
> >>>>    nop
> >>>>
> >>>> If the local index switch happens on a narrow loads, then the instruction
> >>>> preparing value to zero high 32-bit of the destination register could be
> >>>> counted as one cycle, the sequence then could be something like:
> >>>>
> >>>>    local_csr_wr[ActLMAddr3, gprB_5]
> >>>>    nop
> >>>>    nop
> >>>>    immed[gprB_5, 0]
> >>>>
> >>>> However, we have zero extension optimization that zeroing high 32-bit could
> >>>> be eliminated, therefore above IMMED insn won't be available for which case
> >>>> the first sequence needs to be generated.
> >>>>
> >>>> Fixes: 0b4de1ff19bf ("nfp: bpf: eliminate zero extension code-gen")
> >>>> Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
> >>>> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>  
> >>> I haven't looked into the code yet. But ^^^ should be
> >>>
> >>> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> >>>
> >>> right?  
> >>
> >> I prefer Review on code I review, ack on code I ack, and sign-off on
> >> code I co-author.  
> > 
> > I believe if you're sending somebody else patch you have to add your SOB
> > in addition to their 'Author:' and their SOB fields.  
> 
> +1, for co-authoring there's a 'Co-authored-by:' tag which seems to be frequently
> used these days.

Ack, there is a difference between co-author of code, and co-author as
step by step guidance. I've been doing this for 6 years now, and nobody
ever complained :)

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Is that enough or should I repost?
