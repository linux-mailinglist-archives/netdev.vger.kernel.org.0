Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92EA6D8A10
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 09:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391227AbfJPHnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 03:43:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35474 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728201AbfJPHnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 03:43:25 -0400
Received: from [213.220.153.21] (helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1iKdxp-0005wu-W5; Wed, 16 Oct 2019 07:43:22 +0000
Date:   Wed, 16 Oct 2019 09:43:21 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        kafai@fb.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, yhs@fb.com, Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v3 2/3] bpf: use copy_struct_from_user() in
 bpf_prog_get_info_by_fd()
Message-ID: <20191016074320.smgazuy6cyrfa2ef@wittgenstein>
References: <20191016004138.24845-1-christian.brauner@ubuntu.com>
 <20191016034432.4418-1-christian.brauner@ubuntu.com>
 <20191016034432.4418-3-christian.brauner@ubuntu.com>
 <20191016052548.gktf2ctvee7mrwlr@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191016052548.gktf2ctvee7mrwlr@ast-mbp>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 15, 2019 at 10:25:49PM -0700, Alexei Starovoitov wrote:
> On Wed, Oct 16, 2019 at 05:44:31AM +0200, Christian Brauner wrote:
> > In v5.4-rc2 we added a new helper (cf. [1]) copy_struct_from_user().
> > This helper is intended for all codepaths that copy structs from
> > userspace that are versioned by size. bpf_prog_get_info_by_fd() does
> > exactly what copy_struct_from_user() is doing.
> > Note that copy_struct_from_user() is calling min() already. So
> > technically, the min_t() call could go. But the info_len is used further
> > below so leave it.
> > 
> > [1]: f5a1a536fa14 ("lib: introduce copy_struct_from_user() helper")
> > Cc: Alexei Starovoitov <ast@kernel.org>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: bpf@vger.kernel.org
> > Acked-by: Aleksa Sarai <cyphar@cyphar.com>
> > Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> > ---
> > /* v1 */
> > Link: https://lore.kernel.org/r/20191009160907.10981-3-christian.brauner@ubuntu.com
> > 
> > /* v2 */
> > Link: https://lore.kernel.org/r/20191016004138.24845-3-christian.brauner@ubuntu.com
> > - Alexei Starovoitov <ast@kernel.org>:
> >   - remove unneeded initialization
> > 
> > /* v3 */
> > unchanged
> > ---
> >  kernel/bpf/syscall.c | 9 +++------
> >  1 file changed, 3 insertions(+), 6 deletions(-)
> > 
> > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > index 40edcaeccd71..151447f314ca 100644
> > --- a/kernel/bpf/syscall.c
> > +++ b/kernel/bpf/syscall.c
> > @@ -2306,20 +2306,17 @@ static int bpf_prog_get_info_by_fd(struct bpf_prog *prog,
> >  				   union bpf_attr __user *uattr)
> >  {
> >  	struct bpf_prog_info __user *uinfo = u64_to_user_ptr(attr->info.info);
> > -	struct bpf_prog_info info = {};
> > +	struct bpf_prog_info info;
> >  	u32 info_len = attr->info.info_len;
> >  	struct bpf_prog_stats stats;
> >  	char __user *uinsns;
> >  	u32 ulen;
> >  	int err;
> >  
> > -	err = bpf_check_uarg_tail_zero(uinfo, sizeof(info), info_len);
> > +	info_len = min_t(u32, sizeof(info), info_len);
> > +	err = copy_struct_from_user(&info, sizeof(info), uinfo, info_len);
> 
> really?! min?!
> Frankly I'm disappointed in quality of these patches.
> Especially considering it's v3.
> 
> Just live the code alone.

Oh, I didn't see that part. I didn't know that this would upset
you that much. Sure, I can leave the code alone. Or I try to fix this
up. If you're not happy with you can just ignore this.

Christian
