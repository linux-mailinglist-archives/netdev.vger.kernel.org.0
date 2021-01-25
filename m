Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 633DA302C7E
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 21:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbhAYU0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 15:26:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:43566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727454AbhAYU0V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 15:26:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9D982256F;
        Mon, 25 Jan 2021 20:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611606340;
        bh=Vt6cEKhwm+GDDoPC6+aazE3s1x1KfiNN1b8Ygc0cd6s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YKfrAvOfDX9twGZqM/+otHDm0nvmrTSObr1+Av1yQkbmPUbwzzSVJHJA6V0dFVKug
         8TcMcOKWgpNWTliuE/ol2IUVpNwH5KHSgu39Xw3Jo4vkq1Qn7DMxt5c58ev8EYDz/8
         WSwH0t3A/CzJx4c09WgYJudyzhAAQ18GiVWOi9WVXIVgs0n896lzGLDHp1LnZMBIBb
         aRBru3QOf9Gu1s5Il1cQZrfivN3/RQnrwsLE4GvXmMy2rXDsmA2ILATP3CxqxwMxIJ
         kZP8QCiJitFYnza4gKy5RIxkxJbdPv18UQRU+OQUZby25IMqX9eN3D35uPGlQWXKxW
         ysAgzWqDcm02Q==
Date:   Mon, 25 Jan 2021 12:25:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Justin Iurman <justin.iurman@uliege.be>, netdev@vger.kernel.org,
        davem@davemloft.net, alex aring <alex.aring@gmail.com>
Subject: Re: [PATCH net 1/1] uapi: fix big endian definition of
 ipv6_rpl_sr_hdr
Message-ID: <20210125122539.1086fa4e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <bf77978e-c204-bf98-6b1b-965d6ebd9bbc@gmail.com>
References: <20210121220044.22361-1-justin.iurman@uliege.be>
        <20210121220044.22361-2-justin.iurman@uliege.be>
        <20210123205444.5e1df187@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <55663307.1072450.1611482265804.JavaMail.zimbra@uliege.be>
        <fd7957e7-ab5c-d2c2-9338-76879563460e@gmail.com>
        <20210125113231.3fac0e10@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <bf77978e-c204-bf98-6b1b-965d6ebd9bbc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jan 2021 13:12:42 -0700 David Ahern wrote:
> On 1/25/21 12:32 PM, Jakub Kicinski wrote:
> >>>>> diff --git a/include/uapi/linux/rpl.h b/include/uapi/linux/rpl.h
> >>>>> index 1dccb55cf8c6..708adddf9f13 100644
> >>>>> --- a/include/uapi/linux/rpl.h
> >>>>> +++ b/include/uapi/linux/rpl.h
> >>>>> @@ -28,10 +28,10 @@ struct ipv6_rpl_sr_hdr {
> >>>>>  		pad:4,
> >>>>>  		reserved1:16;
> >>>>>  #elif defined(__BIG_ENDIAN_BITFIELD)
> >>>>> -	__u32	reserved:20,
> >>>>> +	__u32	cmpri:4,
> >>>>> +		cmpre:4,
> >>>>>  		pad:4,
> >>>>> -		cmpri:4,
> >>>>> -		cmpre:4;
> >>>>> +		reserved:20;
> >>>>>  #else
> >>>>>  #error  "Please fix <asm/byteorder.h>"
> >>>>>  #endif    
> >>
> >> cross-checking with other headers - tcp and vxlan-gpe - this patch looks
> >> correct.  
> > 
> > What are you cross-checking?
> >   
> 
> https://tools.ietf.org/html/draft-ietf-nvo3-vxlan-gpe-10, Section 3.1
> header definition and vxlanhdr_gpe in include/net/vxlan.h. The
> __BIG_ENDIAN_BITFIELD part follows the definition in the spec.
> 
> Similarly for the TCP header - RFC header definition and tcphdr in
> include/uapi/linux/tcp.h. TCP header shows doff + res1 order which is
> comparable to cmpri + cpmre in this header as both sets are 4-bits and
> start a word.

Ack, thanks for the pointers. The LE definition is broken as well,
then, right?
