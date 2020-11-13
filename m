Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2012B295C
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 00:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgKMXyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 18:54:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:55092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725866AbgKMXyk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 18:54:40 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A309420B80;
        Fri, 13 Nov 2020 23:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605311679;
        bh=9eC2CW2QafH5iaDoDfr9QC0DpqrajW1pVS4MswQ1RnU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZrxRncwsA3QCuYoHg7YXmZmOL+a8LLs4ndZwKXDL6/GacjUfgmHfEztDtTRyeXqll
         ED/2cUpEDAG48PSgtWpJA0ye2k4N/pqQys12DGnfAWB0y3WeiuM2JikZDyLZBaF9CG
         PI+nJ3mekC3C+l2dzvkbK3v0GDqYJjUE69k7tCRk=
Date:   Fri, 13 Nov 2020 15:54:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrea Mayer <andrea.mayer@uniroma2.it>
Cc:     David Ahern <dsahern@gmail.com>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
Subject: Re: [net-next,v2,4/5] seg6: add support for the SRv6 End.DT4
 behavior
Message-ID: <20201113155437.7d82550b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201114000024.614c6c097050188abc87a7ff@uniroma2.it>
References: <20201107153139.3552-1-andrea.mayer@uniroma2.it>
        <20201107153139.3552-5-andrea.mayer@uniroma2.it>
        <20201110151255.3a86afcc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201113022848.dd40aa66763316ac4f4ffd56@uniroma2.it>
        <34d9b96f-a378-4817-36e8-3d9287c5b76b@gmail.com>
        <20201113085547.68e04931@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <bd3712b6-110b-acce-3761-457a6d2b4463@uniroma2.it>
        <09381c96-42a3-91cd-951b-f970cd8e52cb@gmail.com>
        <20201113114036.18e40b32@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201113134010.5eb2a154@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201114000024.614c6c097050188abc87a7ff@uniroma2.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 14 Nov 2020 00:00:24 +0100 Andrea Mayer wrote:
> On Fri, 13 Nov 2020 13:40:10 -0800
> Jakub Kicinski <kuba@kernel.org> wrote:
> 
> > On Fri, 13 Nov 2020 11:40:36 -0800 Jakub Kicinski wrote:  
> > > > agreed. The v6 variant has existed for a while. The v4 version is
> > > > independent.    
> > > 
> > > Okay, I'm not sure what's the right call so I asked DaveM.  
> > 
> > DaveM raised a concern that unless we implement v6 now we can't be sure
> > the interface we create for v4 is going to fit there.
> > 
> > So Andrea unless it's a major hurdle, could you take a stab at the v6
> > version with VRFs as part of this series?  
> 
> I can tackle the v6 version but how do we face the compatibility issue raised
> by Stefano in his message?
> 
> if it is ok to implement a uAPI that breaks the existing scripts, it is relatively
> easy to replicate the VRF-based approach also in v6.

We need to keep existing End.DT6 as is, and add a separate
implementation.

The way to distinguish between the two could be either by passing via
netlink a flag attribute (which would request use of VRF in both
cases); using a different attribute than SEG6_LOCAL_TABLE for the
table id (or perhaps passing VRF's ifindex instead), e.g.
SEG6_LOCAL_TABLE_VRF; or adding a new command
(SEG6_LOCAL_ACTION_END_DT6_VRF) which would behave like End.DT4.
