Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D78F94B0A29
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 11:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238582AbiBJKBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 05:01:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234215AbiBJKBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 05:01:54 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F44C06;
        Thu, 10 Feb 2022 02:01:55 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 64EF01F3A3;
        Thu, 10 Feb 2022 10:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644487314; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kpIvMALIc+t855APyoHsITk4A3Z//kVWKUUyv5HYwBg=;
        b=O+09E0jN1+FVpCzb4OlzPMBKDq4A4BXqWd4OMXi0Vdymd/uVM6cG1HRDxUit+p72x6DkpI
        z4EHqKwTf2L4UVInC7nVTbMQO2eqjUtI2G+Zw0dkxAp9icw/vy4TXmHiwrGpfj56ZAiaV9
        xVfyB2SlCg2pBx9gEsslBPSA/q2VTpo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644487314;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kpIvMALIc+t855APyoHsITk4A3Z//kVWKUUyv5HYwBg=;
        b=ye+ZukJrEdpKaZcnmOqxPyUm7MkerOHdf0MXH6fVaqSFPhULUqRcjhq4trIq+42hJLRmWH
        E7mtxfRzGRhFqlCg==
Received: from kunlun.suse.cz (unknown [10.100.128.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 4BE00A3B84;
        Thu, 10 Feb 2022 10:01:54 +0000 (UTC)
Date:   Thu, 10 Feb 2022 11:01:53 +0100
From:   Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To:     Yonghong Song <yhs@fb.com>
Cc:     Shung-Hsi Yu <shung-hsi.yu@suse.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: BTF compatibility issue across builds
Message-ID: <20220210100153.GA90679@kunlun.suse.cz>
References: <YfK18x/XrYL4Vw8o@syu-laptop>
 <8d17226b-730f-5426-b1cc-99fe43483ed1@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d17226b-730f-5426-b1cc-99fe43483ed1@fb.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Mon, Jan 31, 2022 at 09:36:44AM -0800, Yonghong Song wrote:
> 
> 
> On 1/27/22 7:10 AM, Shung-Hsi Yu wrote:
> > Hi,
> > 
> > We recently run into module load failure related to split BTF on openSUSE
> > Tumbleweed[1], which I believe is something that may also happen on other
> > rolling distros.
> > 
> > The error looks like the follow (though failure is not limited to ipheth)
> > 
> >      BPF:[103111] STRUCT BPF:size=152 vlen=2 BPF: BPF:Invalid name BPF:
> > 
> >      failed to validate module [ipheth] BTF: -22
> > 
> > The error comes down to trying to load BTF of *kernel modules from a
> > different build* than the runtime kernel (but the source is the same), where
> > the base BTF of the two build is different.
> > 
> > While it may be too far stretched to call this a bug, solving this might
> > make BTF adoption easier. I'd natively think that we could further split
> > base BTF into two part to avoid this issue, where .BTF only contain exported
> > types, and the other (still residing in vmlinux) holds the unexported types.
> 
> What is the exported types? The types used by export symbols?
> This for sure will increase btf handling complexity.

And it will not actually help.

We have modversion ABI which checks the checksum of the symbols that the
module imports and fails the load if the checksum for these symbols does
not match. It's not concerned with symbols not exported, it's not
concerned with symbols not used by the module. This is something that is
sustainable across kernel rebuilds with minor fixes/features and what
distributions watch for.

Now with BTF the situation is vastly different. There are at least three
bugs:

 - The BTF check is global for all symbols, not for the symbols the
   module uses. This is not sustainable. Given the BTF is supposed to
   allow linking BPF programs that were built in completely different
   environment with the kernel it is completely within the scope of BTF
   to solve this problem, it's just neglected.
 - It is possible to load modules with no BTF but not modules with
   non-matching BTF. Surely the non-matching BTF could be discarded.
 - BTF is part of vermagic. This is completely pointless since modules
   without BTF can be loaded on BTF kernel. Surely it would not be too
   difficult to do the reverse as well. Given BTF must pass extra check
   to be used having it in vermagic is just useless moise.

> > Does that sound like something reasonable to work on?
> > 
> > 
> > ## Root case (in case anyone is interested in a verbose version)
> > 
> > On openSUSE Tumbleweed there can be several builds of the same source. Since
> > the source is the same, the binaries are simply replaced when a package with
> > a larger build number is installed during upgrade.
> > 
> > In our case, a rebuild is triggered[2], and resulted in changes in base BTF.
> > More precisely, the BTF_KIND_FUNC{,_PROTO} of i2c_smbus_check_pec(u8 cpec,
> > struct i2c_msg *msg) and inet_lhash2_bucket_sk(struct inet_hashinfo *h,
> > struct sock *sk) was added to the base BTF of 5.15.12-1.3. Those functions
> > are previously missing in base BTF of 5.15.12-1.1.
> 
> As stated in [2] below, I think we should understand why rebuild is
> triggered. If the rebuild for vmlinux is triggered, why the modules cannot
> be rebuild at the same time?

They do get rebuilt. However, if you are running the kernel and install
the update you get the new modules with the old kernel. If the install
script fails to copy the kernel to your EFI partition based on the fact
a kernel with the same filename is alreasy there you get the same.

If you have 'stable' distribution adding new symbols is normal and it
does not break module loading without BTF but it breaks BTF.

Thanks

Michal
