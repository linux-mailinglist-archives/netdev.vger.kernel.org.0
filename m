Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF4718D33A
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 16:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbgCTPqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 11:46:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:39338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727113AbgCTPqg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 11:46:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A9FA2070A;
        Fri, 20 Mar 2020 15:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584719196;
        bh=vGKLtExp+TztSBVJmqOiwJhtSCSDjoH/BogaZKD2yIM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mMnfAdxQ8RgtNr+kx0OS0w+LnS2wzxEm0xMsW9/nqpCR8sP7FQvkjy9HpshXTFsYS
         UZ57JlyU3Euog+h3fcumSH+k0Dm9dacH8xMo8L1JTjF9A26Cj5hjPxlUkGreNH/Nzy
         ry9eMyzvl0/XO4ysV3oBGXd8UsqVkdYn8YXNWEs0=
Date:   Fri, 20 Mar 2020 16:46:33 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        John Stultz <john.stultz@linaro.org>,
        Alexander Potapenko <glider@google.com>,
        Alistair Delva <adelva@google.com>
Subject: Re: [PATCH] bpf: explicitly memset the bpf_attr structure
Message-ID: <20200320154633.GB765793@kroah.com>
References: <20200320094813.GA421650@kroah.com>
 <d0dfc2ff-8323-12ed-3c7e-e8c6a118b890@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0dfc2ff-8323-12ed-3c7e-e8c6a118b890@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 20, 2020 at 08:23:57AM -0700, Yonghong Song wrote:
> 
> 
> On 3/20/20 2:48 AM, Greg Kroah-Hartman wrote:
> > For the bpf syscall, we are relying on the compiler to properly zero out
> > the bpf_attr union that we copy userspace data into.  Unfortunately that
> > doesn't always work properly, padding and other oddities might not be
> > correctly zeroed, and in some tests odd things have been found when the
> > stack is pre-initialized to other values.
> 
> Maybe add more contexts about the failure itself so it could be clear
> why we need this patch.

I didn't have the full details, I think Maciej has them though.

> As far as I know from the link below, the failure happens in
> CHECK_ATTR() which checks any unused *area* for a particular subcommand
> must be 0, and this patch tries to provide this guarantee beyond
> area beyond min(uattr_size, sizeof(attr)).

That macro also will get tripped up if padding is not zeroed out as
well, so this is good to fix up.

thanks for the review.

greg k-h
