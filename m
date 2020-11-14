Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3839B2B2ABE
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 03:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbgKNCB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 21:01:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:56702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725981AbgKNCB2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 21:01:28 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3EC22225D;
        Sat, 14 Nov 2020 02:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605319287;
        bh=fyjpN/Va4J4KYGHi7KfiJSuLtnzhTFBdvx03iFIiX/8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=arEx7zYeIRjBS9Pd0O0ZrZG2bioB7/jWDvlDhfgsHOsKXrYHpjdmnofJH2hsPcgQj
         JDqoKAT7wA70uF2HfTRJ9zRdm3PINCVJLJOoTFGqEcB5PcDamdawXhx9YdDmguFrYW
         YkXva60+SdiAyouhpOEar50RxQUr1Lbc+HTE/5U4=
Date:   Fri, 13 Nov 2020 18:01:26 -0800
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
Message-ID: <20201113180126.33bc1045@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201114025058.25ae815024ba77d59666a7ab@uniroma2.it>
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
        <20201113155437.7d82550b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201114025058.25ae815024ba77d59666a7ab@uniroma2.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 14 Nov 2020 02:50:58 +0100 Andrea Mayer wrote:
> Hi Jakub,
> Please see my responses inline:
> 
> On Fri, 13 Nov 2020 15:54:37 -0800
> Jakub Kicinski <kuba@kernel.org> wrote:
> 
> > On Sat, 14 Nov 2020 00:00:24 +0100 Andrea Mayer wrote:  
> > > On Fri, 13 Nov 2020 13:40:10 -0800
> > > Jakub Kicinski <kuba@kernel.org> wrote:
> > > 
> > > I can tackle the v6 version but how do we face the compatibility issue raised
> > > by Stefano in his message?
> > > 
> > > if it is ok to implement a uAPI that breaks the existing scripts, it is relatively
> > > easy to replicate the VRF-based approach also in v6.  
> > 
> > We need to keep existing End.DT6 as is, and add a separate
> > implementation.  
> 
> ok
> 
> >
> > The way to distinguish between the two could be either by  
> 
> > 1) passing via
> > netlink a flag attribute (which would request use of VRF in both
> > cases);  
> 
> yes, feasible... see UAPI solution 1
> 
> > 2) using a different attribute than SEG6_LOCAL_TABLE for the
> > table id (or perhaps passing VRF's ifindex instead), e.g.
> > SEG6_LOCAL_TABLE_VRF;  
> 
> yes, feasible... see UAPI solution 2
> 
> > 3) or adding a new command
> > (SEG6_LOCAL_ACTION_END_DT6_VRF) which would behave like End.DT4.  
> 
> no, we prefer not to add a new command, because it is better to keep a 
> semantic one-to-one relationship between these commands and the SRv6 
> behaviors defined in the draft.
> 
> 
> UAPI solution 1
> 
> we add a new parameter "vrfmode". DT4 can only be used with the 
> vrfmode parameter (hence it is a required parameter for DT4).
> DT6 can be used with "vrfmode" (new vrf based mode) or without "vrfmode" 
> (legacy mode)(hence "vrfmode" is an optional parameter for DT6)
> 
> UAPI solution 1 examples:
> 
> ip -6 route add 2001:db8::1/128 encap seg6local action End.DT4 vrfmode table 100 dev eth0
> ip -6 route add 2001:db8::1/128 encap seg6local action End.DT6 vrfmode table 100 dev eth0
> ip -6 route add 2001:db8::1/128 encap seg6local action End.DT6 table 100 dev eth0
> 
> UAPI solution 2
> 
> we turn "table" into an optional parameter and we add the "vrftable" optional
> parameter. DT4 can only be used with the "vrftable" (hence it is a required
> parameter for DT4).
> DT6 can be used with "vrftable" (new vrf mode) or with "table" (legacy mode)
> (hence it is an optional parameter for DT6).
> 
> UAPI solution 2 examples:
> 
> ip -6 route add 2001:db8::1/128 encap seg6local action End.DT4 vrftable 100 dev eth0
> ip -6 route add 2001:db8::1/128 encap seg6local action End.DT6 vrftable 100 dev eth0
> ip -6 route add 2001:db8::1/128 encap seg6local action End.DT6 table 100 dev eth0
> 
> IMO solution 2 is nicer from UAPI POV because we always have only one 
> parameter, maybe solution 1 is slightly easier to implement, all in all 
> we prefer solution 2 but we can go for 1 if you prefer.

Agreed, 2 looks better to me as well. But let's not conflate uABI with
iproute2's command line. I'm more concerned about the kernel ABI.

BTW you prefer to operate on tables (and therefore require
net.vrf.strict_mode=1) because that's closer to the spirit of the RFC,
correct? As I said from the implementation perspective passing any VRF
ifindex down from user space to the kernel should be fine?
