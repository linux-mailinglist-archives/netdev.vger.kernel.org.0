Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEACD18D3F1
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 17:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727518AbgCTQPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 12:15:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:48894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726935AbgCTQPT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 12:15:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADA6420724;
        Fri, 20 Mar 2020 16:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584720918;
        bh=dKpCjXh35N/OLn+Ga/h917LVkpQQKxH6YGvz9EUVQtY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dpFWKqRo2BwfiVY3lnyH8On6ZhnfmfFbF81Ms4KFgH0sZCPO4V6FT++I8XSeFP9gV
         q+2VBwlJ+auupvJulJT8WHsmnk572sa7Z5ebg8gfLu9q6wPmI4Q0Et018B6a4PRTcG
         1bwsNvris9qrtrySUz1JeZUxor7OvsEC60bHw8AY=
Date:   Fri, 20 Mar 2020 17:15:15 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        John Stultz <john.stultz@linaro.org>,
        Alexander Potapenko <glider@google.com>,
        Alistair Delva <adelva@google.com>
Subject: Re: [PATCH] bpf: explicitly memset the bpf_attr structure
Message-ID: <20200320161515.GA778529@kroah.com>
References: <20200320094813.GA421650@kroah.com>
 <3bcf52da-0930-a27f-60f9-28a40e639949@iogearbox.net>
 <20200320154518.GA765793@kroah.com>
 <d55983b3-0f94-cc7f-2055-a0b4ab8075ed@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d55983b3-0f94-cc7f-2055-a0b4ab8075ed@iogearbox.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 20, 2020 at 05:04:24PM +0100, Daniel Borkmann wrote:
> On 3/20/20 4:45 PM, Greg Kroah-Hartman wrote:
> > On Fri, Mar 20, 2020 at 04:24:32PM +0100, Daniel Borkmann wrote:
> > > On 3/20/20 10:48 AM, Greg Kroah-Hartman wrote:
> > > > For the bpf syscall, we are relying on the compiler to properly zero out
> > > > the bpf_attr union that we copy userspace data into.  Unfortunately that
> > > > doesn't always work properly, padding and other oddities might not be
> > > > correctly zeroed, and in some tests odd things have been found when the
> > > > stack is pre-initialized to other values.
> > > > 
> > > > Fix this by explicitly memsetting the structure to 0 before using it.
> > > > 
> > > > Reported-by: Maciej Żenczykowski <maze@google.com>
> > > > Reported-by: John Stultz <john.stultz@linaro.org>
> > > > Reported-by: Alexander Potapenko <glider@google.com>
> > > > Reported-by: Alistair Delva <adelva@google.com>
> > > > Cc: stable <stable@vger.kernel.org>
> > > > Link: https://android-review.googlesource.com/c/kernel/common/+/1235490
> > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > ---
> > > >    kernel/bpf/syscall.c | 3 ++-
> > > >    1 file changed, 2 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > > > index a91ad518c050..a4b1de8ea409 100644
> > > > --- a/kernel/bpf/syscall.c
> > > > +++ b/kernel/bpf/syscall.c
> > > > @@ -3354,7 +3354,7 @@ static int bpf_map_do_batch(const union bpf_attr *attr,
> > > >    SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, size)
> > > >    {
> > > > -	union bpf_attr attr = {};
> > > > +	union bpf_attr attr;
> > > >    	int err;
> > > >    	if (sysctl_unprivileged_bpf_disabled && !capable(CAP_SYS_ADMIN))
> > > > @@ -3366,6 +3366,7 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
> > > >    	size = min_t(u32, size, sizeof(attr));
> > > >    	/* copy attributes from user space, may be less than sizeof(bpf_attr) */
> > > > +	memset(&attr, 0, sizeof(attr));
> > > 
> > > Thanks for the fix, there are a few more of these places. We would also need
> > > to cover:
> > > 
> > > - bpf_prog_get_info_by_fd()
> > 
> > Unless I am mistaken, struct bpf_prog_info is packed fully, with no
> > holes, so this shouldn't be an issue there.
> 
> It does have a '/* XXX 31 bits hole, try to pack */' but I presume the compiler
> might simply zero it in this case.
> 
> > > - bpf_map_get_info_by_fd()
> > 
> > No padding in struct bpf_map_info that I can see, so I doubt this is
> > needed there.
> > 
> > > - btf_get_info_by_fd()
> > 
> > There is no padding in struct bpf_btf_info, so that's not needed there,
> > but I can add it if you really want.
> > 
> > I can change these, but I don't think that there currently is a bug in
> > those functions, unlike with "union bpf_attr" which, as Yonghong points
> > out, is tripping on the CHECK_ATTR() test later on.
> 
> Got it, my main concern is that the next time someone extends these fields with
> new members we could potentially add holes in there as well and we'll run into
> the same issue twice, example from the past is b85fab0e67b1 ("bpf: Add gpl_compatible
> flag to struct bpf_prog_info").

Fair enough, I'll make a second patch for this, as there's no known
issue today with those initializations that need to be backported to the
stable tree :)

thanks,

greg k-h
