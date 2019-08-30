Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBE35A303B
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 08:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbfH3Gr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 02:47:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:40418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbfH3Gr0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 02:47:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FCDC21874;
        Fri, 30 Aug 2019 06:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567147644;
        bh=qSGGYGCGVt2PHacicqqinm4SAFSEKVqpRxF/TIkMHvM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wir2MbvI07k8QRs40r8/NIAkLWFVKpG5WifG1Qz8gLVBc7bzvB3ubrArb2nKxEOuZ
         VV4tJX/tUHnBV1ZRmDQk2/z0dZVBsClDFV3J6hKXzl5kwCJOvumWZLYVntWIdwg9HY
         gZ0pwfXoFjN3K9uNJdAIjsinQd7D30vkdc6sVyGs=
Date:   Fri, 30 Aug 2019 08:47:22 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Julia Kartseva <hex@fb.com>, ast@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, rdna@fb.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: auto-split of commit. Was: [PATCH bpf-next 04/10] tools/bpf: add
 libbpf_prog_type_(from|to)_str helpers
Message-ID: <20190830064722.GJ15257@kroah.com>
References: <cover.1567024943.git.hex@fb.com>
 <467620c966825173dbd65b37a3f9bd7dd4fb8184.1567024943.git.hex@fb.com>
 <20190828163422.3d167c4b@cakuba.netronome.com>
 <20190828234626.ltfy3qr2nne4uumy@ast-mbp.dhcp.thefacebook.com>
 <20190829065151.GB30423@kroah.com>
 <20190829171655.fww5qxtfusehcpds@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829171655.fww5qxtfusehcpds@ast-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 29, 2019 at 10:16:56AM -0700, Alexei Starovoitov wrote:
> On Thu, Aug 29, 2019 at 08:51:51AM +0200, Greg Kroah-Hartman wrote:
> > On Wed, Aug 28, 2019 at 04:46:28PM -0700, Alexei Starovoitov wrote:
> > > On Wed, Aug 28, 2019 at 04:34:22PM -0700, Jakub Kicinski wrote:
> > > > 
> > > > Greg, Thomas, libbpf is extracted from the kernel sources and
> > > > maintained in a clone repo on GitHub for ease of packaging.
> > > > 
> > > > IIUC Alexei's concern is that since we are moving the commits from
> > > > the kernel repo to the GitHub one we have to preserve the commits
> > > > exactly as they are, otherwise SOB lines lose their power.
> > > > 
> > > > Can you provide some guidance on whether that's a valid concern, 
> > > > or whether it's perfectly fine to apply a partial patch?
> > > 
> > > Right. That's exactly the concern.
> > > 
> > > Greg, Thomas,
> > > could you please put your legal hat on and clarify the following.
> > > Say some developer does a patch that modifies
> > > include/uapi/linux/bpf.h
> > > ..some other kernel code...and
> > > tools/include/uapi/linux/bpf.h
> > > 
> > > That tools/include/uapi/linux/bpf.h is used by perf and by libbpf.
> > > We have automatic mirror of tools/libbpf into github/libbpf/
> > > so that external projects and can do git submodule of it,
> > > can build packages out of it, etc.
> > > 
> > > The question is whether it's ok to split tools/* part out of
> > > original commit, keep Author and SOB, create new commit out of it,
> > > and automatically push that auto-generated commit into github mirror.
> > 
> > Note, I am not a laywer, and am not _your_ lawyer either, only _your_
> > lawyer can answer questions as to what is best for you.
> > 
> > That being said, from a "are you keeping the correct authorship info",
> > yes, it sounds like you are doing the correct thing here.
> > 
> > Look at what I do for stable kernels, I take the original commit and add
> > it to "another tree" keeping the original author and s-o-b chain intact,
> > and adding a "this is the original git commit id" type message to the
> > changelog text so that people can link it back to the original.
> 
> I think you're describing 'git cherry-pick -x'.

Well, my scripts don't use git, but yes, it's much the same thing :)

> The question was about taking pieces of the original commit. Not the whole commit.
> Author field obviously stays, but SOB is questionable.

sob matters to the file the commit is touching, and if it is identical
to the original file (including same license), then it should be fine.

> If author meant to change X and Y and Z. Silently taking only Z chunk of the diff
> doesn't quite seem right.

It can be confusing, I agree.

> If we document that such commit split happens in Documentation/bpf/bpf_devel_QA.rst
> do you think it will be enough to properly inform developers?
> The main concern is the surprise factor when people start seeing their commits
> in the mirror, but not their full commits.

Personally, I wouldn't care, but maybe you should just enforce the fact
that the original patch should ONLY touch Z, and not X and Y in the same
patch, to make this a lot more obvious.

Patches should only be doing "one logical thing" in the first place, but
maybe you also need to touch other things when doing a change that you
can't do this, I really do not know, sorry.

greg k-h
