Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECAB11FD3AF
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 19:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgFQRpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 13:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgFQRpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 13:45:11 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331C8C06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 10:45:11 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id n11so3379393ybg.15
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 10:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2nkwnHmiseLtKsFg64/v/NaKV+MbDPhYExgP2nPNZDE=;
        b=VgEKdDMil+GgrkSmaxDoxUckFToSKqyUewnTJ0DMR4CWQ4vhoxMPVAj12FMGzskw27
         RLfV5XR4bMBMZj1xHN/klQCxNAolpeku/duWA2NYEAwzLQ/L+5dJjux1wPlN+Ho3t/eq
         jWd88MP7G4PKfsAuBTC/pa2EHmN9xaTw1KcF/vjf1e+A21AIPw+iNcjjn7JTXwVFIU9Q
         otpNYHum/DrhuRux3wM2Bj5lKgQrdho4359Ayhl6OZ9Jb2hJ0q7XuHWEA8yjiLLKiWd4
         hzqyZvGzlix6f1ropUviiDc5Z+a1zYoT46GbpGi8oJus49cJqqUJbbYFSnaWPy7lszVQ
         0KKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2nkwnHmiseLtKsFg64/v/NaKV+MbDPhYExgP2nPNZDE=;
        b=IA0Cq15c0CaxwWFmHbuVxeSVcQz8y9eXx9+jmjbJ/Ea9ldAk2+VC1jF0mFju15za6n
         ZDqznT6zNwN4OyNfSUqgyDc8UClGRJ09byrbyHpbbWkJGPxpYOQRmy9x1z0AeFPO5SIL
         adhXKOosvUxlpMHU/pp7Klo2WzlBiLTC1h6ExX+FsM3RKEQoAtmf5g/XQbiXnBeNmlD6
         LWiijg5tJlDy8fUehESi7vMEpmVdyfZFRGMm+htX2k5Tf217BZZhE4epU8DUaWTVW6zj
         KpPis7ynrVfjhjUnpn+a3cYz1MoQaXbEMSSTtJp4x7EJMKPZWsjkp8z0KZw8fHwjKW1d
         Tmpg==
X-Gm-Message-State: AOAM533BdZQ29koBzYs2CjXJENNbp+2VcKrcOmxt2K8eFGrE5NMln4VZ
        v1ZKmX6bCdu8YHjEc9UuZ4Kx4NI=
X-Google-Smtp-Source: ABdhPJw6ZIAyTFJ9kTs1kWd+KdsRqknigPNRyis7J3SP3B4jWNgA40krMlqWmYTu8SEkVm6RfOp+gmI=
X-Received: by 2002:a25:3851:: with SMTP id f78mr49390yba.212.1592415910411;
 Wed, 17 Jun 2020 10:45:10 -0700 (PDT)
Date:   Wed, 17 Jun 2020 10:45:08 -0700
In-Reply-To: <20200617170909.koev3t5fmngla3c4@ast-mbp.dhcp.thefacebook.com>
Message-Id: <20200617174508.GA246265@google.com>
Mime-Version: 1.0
References: <20200617010416.93086-1-sdf@google.com> <20200617170909.koev3t5fmngla3c4@ast-mbp.dhcp.thefacebook.com>
Subject: Re: [PATCH bpf v5 1/3] bpf: don't return EINVAL from {get,set}sockopt
 when optlen > PAGE_SIZE
From:   sdf@google.com
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net,
        David Laight <David.Laight@ACULAB.COM>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/17, Alexei Starovoitov wrote:
> On Tue, Jun 16, 2020 at 06:04:14PM -0700, Stanislav Fomichev wrote:
> > Attaching to these hooks can break iptables because its optval is
> > usually quite big, or at least bigger than the current PAGE_SIZE limit.
> > David also mentioned some SCTP options can be big (around 256k).
> >
> > For such optvals we expose only the first PAGE_SIZE bytes to
> > the BPF program. BPF program has two options:
> > 1. Set ctx->optlen to 0 to indicate that the BPF's optval
> >    should be ignored and the kernel should use original userspace
> >    value.
> > 2. Set ctx->optlen to something that's smaller than the PAGE_SIZE.
> >
> > v5:
> > * use ctx->optlen == 0 with trimmed buffer (Alexei Starovoitov)
> > * update the docs accordingly
> >
> > v4:
> > * use temporary buffer to avoid optval == optval_end == NULL;
> >   this removes the corner case in the verifier that might assume
> >   non-zero PTR_TO_PACKET/PTR_TO_PACKET_END.
> >
> > v3:
> > * don't increase the limit, bypass the argument
> >
> > v2:
> > * proper comments formatting (Jakub Kicinski)
> >
> > Fixes: 0d01da6afc54 ("bpf: implement getsockopt and setsockopt hooks")
> > Cc: David Laight <David.Laight@ACULAB.COM>
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  kernel/bpf/cgroup.c | 53 ++++++++++++++++++++++++++++-----------------
> >  1 file changed, 33 insertions(+), 20 deletions(-)
> >
> > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > index 4d76f16524cc..ac53102e244a 100644
> > --- a/kernel/bpf/cgroup.c
> > +++ b/kernel/bpf/cgroup.c
> > @@ -1276,16 +1276,23 @@ static bool  
> __cgroup_bpf_prog_array_is_empty(struct cgroup *cgrp,
> >
> >  static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int  
> max_optlen)
> >  {
> > -	if (unlikely(max_optlen > PAGE_SIZE) || max_optlen < 0)
> > +	if (unlikely(max_optlen < 0))
> >  		return -EINVAL;
> >
> > +	if (unlikely(max_optlen > PAGE_SIZE)) {
> > +		/* We don't expose optvals that are greater than PAGE_SIZE
> > +		 * to the BPF program.
> > +		 */
> > +		max_optlen = PAGE_SIZE;
> > +	}
> > +
> >  	ctx->optval = kzalloc(max_optlen, GFP_USER);
> >  	if (!ctx->optval)
> >  		return -ENOMEM;
> >
> >  	ctx->optval_end = ctx->optval + max_optlen;
> >
> > -	return 0;
> > +	return max_optlen;
> >  }
> >
> >  static void sockopt_free_buf(struct bpf_sockopt_kern *ctx)
> > @@ -1319,13 +1326,13 @@ int __cgroup_bpf_run_filter_setsockopt(struct  
> sock *sk, int *level,
> >  	 */
> >  	max_optlen = max_t(int, 16, *optlen);
> >
> > -	ret = sockopt_alloc_buf(&ctx, max_optlen);
> > -	if (ret)
> > -		return ret;
> > +	max_optlen = sockopt_alloc_buf(&ctx, max_optlen);
> > +	if (max_optlen < 0)
> > +		return max_optlen;
> >
> >  	ctx.optlen = *optlen;
> >
> > -	if (copy_from_user(ctx.optval, optval, *optlen) != 0) {
> > +	if (copy_from_user(ctx.optval, optval, min(*optlen, max_optlen)) !=  
> 0) {
> >  		ret = -EFAULT;
> >  		goto out;
> >  	}
> > @@ -1353,8 +1360,14 @@ int __cgroup_bpf_run_filter_setsockopt(struct  
> sock *sk, int *level,
> >  		/* export any potential modifications */
> >  		*level = ctx.level;
> >  		*optname = ctx.optname;
> > -		*optlen = ctx.optlen;
> > -		*kernel_optval = ctx.optval;
> > +
> > +		/* optlen == 0 from BPF indicates that we should
> > +		 * use original userspace data.
> > +		 */
> > +		if (ctx.optlen != 0) {
> > +			*optlen = ctx.optlen;

> I think it should be:
> *optlen = min(ctx.optlen, max_optlen);
We do have the following (existing) check above:
	} else if (ctx.optlen > max_optlen || ctx.optlen < -1) {
		/* optlen is out of bounds */
		ret = -EFAULT;
	} else {

So we shouldn't need any min here? Or am I missing something?

> Otherwise when bpf prog doesn't adjust ctx.oplen the kernel will see
> 4k only in kernel_optval whereas optlen will be > 4k.
> I suspect iptables sockopt should have crashed at this point.
> How did you test it?
The selftests that I've attached in the series. The test is passing
two pages and for IP_TOS we bypass the value via optlen=0 and
for IP_FREEBIND we trim the buffer to 1 byte. I think this should
cover this check here.

One thing I didn't really test is getsockopt when the kernel
returns really large buffer (iptables). Right now, the test
gets 4 bytes (trimmed) from the kernel. I think that's the only
place that I didn't properly test. I wonder whether I should
do a real iptables-like setsockopt/getsockopt :-/
