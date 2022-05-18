Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06B7852B8B9
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 13:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235641AbiERLZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 07:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235629AbiERLZH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 07:25:07 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D4517568B;
        Wed, 18 May 2022 04:25:01 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id h11so1410866eda.8;
        Wed, 18 May 2022 04:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=d5+0ld6vIvXb4AXUGD3+swLgU10VfBo9gjxiU0sZkxo=;
        b=p/1CquKZ2KpM2HaO8peNflZCDXRy0gj1cVIe/nKuz2bP3fYtq/w6wqKzwsLpsT9sMD
         eOIxisTYSYNgbg4yismK+RPzGoMDjuIUDdrodj8vre7ZvWH+kOtmRAk8nwls1ZzxfOfR
         DAvb98vky1RH0iPEq1fpikV2GkjxIT2l41TIRP8VJtrvBnZrZ7nVKMiQmOBcVo3ZeQFh
         TG/yXdcL9O9dAom4vJfalvK9zJF9cFVCUObOLVqWNWDrwLe6rt5qsVdkdIR2lUtKALoi
         netJXodpCUQx+tB+tBGEOFoXZXTCuHTxi/S4eaMvX5cud32/jbiR3qYO+cccCDDnlO1E
         aRHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=d5+0ld6vIvXb4AXUGD3+swLgU10VfBo9gjxiU0sZkxo=;
        b=D5aWc2fTkCLfMpw4uGyCGWLCshsT3iOwqh5FrTTNBZaOOQjN7Kfnj8Iwwg8ykhGuY8
         GBloRv3upSeQ7rYTY6PN72NLViUtcNIpR2eRmTNSuco/QTRzVs7trwMertsFu9k8IP6M
         rOp8nuAkTLB9aMG8bWih2eBZBbgOExr3jI3PQb3vXvROmxOCO59kMj5ZLJVFp2uDhhJL
         hrlvgao72rKpPSG2n5G9Kwa3VpCUCIcIBAm3y/a0BbugazhaYMujJQMYmYcVEUHQqiym
         2NFdwJokKzW4yf6TX+dnX8G9mcV56Yk7N7iQNuc4mRLlhMNRsPyrSUHaks+J6UqzGmrI
         sMmQ==
X-Gm-Message-State: AOAM532twxSjR5hsM4wMLrFnCq5w3P/2WoYpSxivyFXz7/vlhCEnuMHO
        GqKbcTJZne2O1N/0AKwIVak=
X-Google-Smtp-Source: ABdhPJylrzPWq2+Iu6K8RtJKvVvAeFK+PtDcRB6PF2VntSYs+asqFf8NFwR+hkN84tlTP1E/GxaatA==
X-Received: by 2002:a05:6402:1cc1:b0:428:a06e:a30f with SMTP id ds1-20020a0564021cc100b00428a06ea30fmr23710681edb.377.1652873099648;
        Wed, 18 May 2022 04:24:59 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id n24-20020a056402515800b0042ad0358c8bsm1188980edd.38.2022.05.18.04.24.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 04:24:59 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Wed, 18 May 2022 13:24:56 +0200
To:     Yonghong Song <yhs@fb.com>
Cc:     Jiri Olsa <olsajiri@gmail.com>,
        Eugene Syromiatnikov <esyr@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 4/4] bpf_trace: pass array of u64 values in
 kprobe_multi.addrs
Message-ID: <YoTXiAk1EpZ0rLKE@krava>
References: <cover.1652772731.git.esyr@redhat.com>
 <6ef675aeeea442fa8fc168cd1cb4e4e474f65a3f.1652772731.git.esyr@redhat.com>
 <YoNnAgDsIWef82is@krava>
 <20220517123050.GA25149@asgard.redhat.com>
 <YoP/eEMqAn3sVFXf@krava>
 <7c5e64f2-f2cf-61b7-9231-fc267bf0f2d8@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c5e64f2-f2cf-61b7-9231-fc267bf0f2d8@fb.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 17, 2022 at 02:34:55PM -0700, Yonghong Song wrote:
> 
> 
> On 5/17/22 1:03 PM, Jiri Olsa wrote:
> > On Tue, May 17, 2022 at 02:30:50PM +0200, Eugene Syromiatnikov wrote:
> > > On Tue, May 17, 2022 at 11:12:34AM +0200, Jiri Olsa wrote:
> > > > On Tue, May 17, 2022 at 09:36:47AM +0200, Eugene Syromiatnikov wrote:
> > > > > With the interface as defined, it is impossible to pass 64-bit kernel
> > > > > addresses from a 32-bit userspace process in BPF_LINK_TYPE_KPROBE_MULTI,
> > > > > which severly limits the useability of the interface, change the ABI
> > > > > to accept an array of u64 values instead of (kernel? user?) longs.
> > > > > Interestingly, the rest of the libbpf infrastructure uses 64-bit values
> > > > > for kallsyms addresses already, so this patch also eliminates
> > > > > the sym_addr cast in tools/lib/bpf/libbpf.c:resolve_kprobe_multi_cb().
> > > > 
> > > > so the problem is when we have 32bit user sace on 64bit kernel right?
> > > > 
> > > > I think we should keep addrs as longs in uapi and have kernel to figure out
> > > > if it needs to read u32 or u64, like you did for symbols in previous patch
> > > 
> > > No, it's not possible here, as addrs are kernel addrs and not user space
> > > addrs, so user space has to explicitly pass 64-bit addresses on 64-bit
> > > kernels (or have a notion whether it is running on a 64-bit
> > > or 32-bit kernel, and form the passed array accordingly, which is against
> > > the idea of compat layer that tries to abstract it out).
> > 
> > hum :-\ I'll need to check on compat layer.. there must
> > be some other code doing this already somewhere, right?

so the 32bit application running on 64bit kernel using libbpf won't
work at the moment, right? because it sees:

  bpf_kprobe_multi_opts::addrs as its 'unsigned long'

which is 4 bytes and it needs to put there 64bits kernel addresses

if we force the libbpf interface to use u64, then we should be fine

> 
> I am not familiar with all these compatibility thing. But if we
> have 64-bit pointer for **syms, maybe we could also have
> 64-bit pointer for *syms for consistency?

right, perhaps we could have one function to read both syms and addrs arrays

> 
> > jirka
> > 
> > > 
> > > > we'll need to fix also bpf_kprobe_multi_cookie_swap because it assumes
> > > > 64bit user space pointers

if we have both addresses and cookies 64 then this should be ok

> > > > 
> > > > would be gret if we could have selftest for this

let's add selftest for this

thanks,
jirka
