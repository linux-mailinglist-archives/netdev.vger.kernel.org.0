Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9CE583CBF
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 13:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235108AbiG1LBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 07:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235236AbiG1LBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 07:01:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B52D84F669
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 04:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659006065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kyxBpp965wmr06G0VQP020eXN9raG+vyvYPqb07HnQM=;
        b=hKDLAu3o/G0RdKvA9/w4eF/TstpTdsL2eAlxZxOOhdCCoELlFoEmCk9LM2kMr97lUn0A5u
        0g79rbESERAR7bdnhvClHcKFvud9meVMm0qdWT22gfTQrPbgp32n5mocr4V/OVs17oiISk
        7CzFLKZSRmICdAWCYXJbhWeFuWA2asc=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-379-qmHqXCiyPlakwej1Z7EfDA-1; Thu, 28 Jul 2022 07:01:04 -0400
X-MC-Unique: qmHqXCiyPlakwej1Z7EfDA-1
Received: by mail-lj1-f198.google.com with SMTP id bd2-20020a05651c168200b0025dcd868408so302401ljb.2
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 04:01:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kyxBpp965wmr06G0VQP020eXN9raG+vyvYPqb07HnQM=;
        b=zdRzb6HfxvqKf83xPfnVFIu/SBGpC0J/VXAwhaU1qs6AXoP2WkFtP8PHv+gCWamg45
         5gbQvRfWwVDm1fqbhTrpTvKMbh5STOcHDxpnatk4ZzGMGOLmVmcJ6OXShpbpexkcjnbI
         iRd9stElZMxASWz/EsTBfbPXIO35Ec/CkFnK4DO0XTqJMh4WbzgKvv72z9NTqOD4MvmV
         HZoq9MBU8wzK6wzwn1/OPR899rz/IiL/q3iU03hSd5WFgjPX7X2/HIiRNbVOJMAPtvT5
         4HZF7AMXQ7mdEF2ZWH3fB11nlHgqu9nbb92Y/i4vn1qRY4NWktzZcLUKa/+8QK7qPSxZ
         7LpQ==
X-Gm-Message-State: AJIora8qwVxi7i+BWvUpBByH9TVsfcnZ5DBBa7fmh0h5NVHFarv2IoBK
        5qdzXNDPiuNpqlHuvjT8wlLehnc+LXlp8qblp/gjnNoI7V7u/OXEGl5moqyj9jnWFbMJquOQ03c
        yHBiUB3/51UhqB4xOQL1ClK1uJ/VzTkMJ
X-Received: by 2002:a2e:888d:0:b0:25e:332:1358 with SMTP id k13-20020a2e888d000000b0025e03321358mr6613320lji.262.1659006061488;
        Thu, 28 Jul 2022 04:01:01 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uSq0lz9bommcbsykN1bL0E7qJp3ukiI/PVqxpP83I6RYIWvQIoUYSxuhpu2abh3/olyBi1q6vJbBfk1d6C5bs=
X-Received: by 2002:a2e:888d:0:b0:25e:332:1358 with SMTP id
 k13-20020a2e888d000000b0025e03321358mr6613316lji.262.1659006061280; Thu, 28
 Jul 2022 04:01:01 -0700 (PDT)
MIME-Version: 1.0
References: <CA+QYu4qw6LecuxwAESLBvzEpj9Uv4LobX0rofDgVk_3YHjY7Fw@mail.gmail.com>
 <0051a5c0-aa9f-423e-bba3-6d5732402692@huaweicloud.com> <CAPhsuW63ms5bULxcyQroLcRABxwx=6Q0ps189S1AH5jizyzZNA@mail.gmail.com>
In-Reply-To: <CAPhsuW63ms5bULxcyQroLcRABxwx=6Q0ps189S1AH5jizyzZNA@mail.gmail.com>
From:   Bruno Goncalves <bgoncalv@redhat.com>
Date:   Thu, 28 Jul 2022 13:00:50 +0200
Message-ID: <CA+QYu4pbMA+ci-daYMjsHFegac0iq+h5UynJO5ASnyA179OChA@mail.gmail.com>
Subject: Re: [aarch64] pc : ftrace_set_filter_ip+0x24/0xa0 - lr : bpf_trampoline_update.constprop.0+0x428/0x4a0
To:     Song Liu <song@kernel.org>
Cc:     Xu Kuohai <xukuohai@huaweicloud.com>,
        CKI Project <cki-project@redhat.com>,
        Song Liu <songliubraving@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jul 2022 at 06:04, Song Liu <song@kernel.org> wrote:
>
> On Wed, Jul 27, 2022 at 8:18 PM Xu Kuohai <xukuohai@huaweicloud.com> wrote:
> >
> > On 7/27/2022 6:40 PM, Bruno Goncalves wrote:
> > > Hello,
> > >
> > > Recently we started to hit the following panic when testing the
> > > net-next tree on aarch64. The first commit that we hit this is
> > > "b3fce974d423".
> > >
> > > [   44.517109] audit: type=1334 audit(1658859870.268:59): prog-id=19 op=LOAD
> > > [   44.622031] Unable to handle kernel NULL pointer dereference at
> > > virtual address 0000000000000010
> > > [   44.624321] Mem abort info:
> > > [   44.625049]   ESR = 0x0000000096000004
> > > [   44.625935]   EC = 0x25: DABT (current EL), IL = 32 bits
> > > [   44.627182]   SET = 0, FnV = 0
> > > [   44.627930]   EA = 0, S1PTW = 0
> > > [   44.628684]   FSC = 0x04: level 0 translation fault
> > > [   44.629788] Data abort info:
> > > [   44.630474]   ISV = 0, ISS = 0x00000004
> > > [   44.631362]   CM = 0, WnR = 0
> > > [   44.632041] user pgtable: 4k pages, 48-bit VAs, pgdp=0000000100ab5000
> > > [   44.633494] [0000000000000010] pgd=0000000000000000, p4d=0000000000000000
> > > [   44.635202] Internal error: Oops: 96000004 [#1] SMP
> > > [   44.636452] Modules linked in: xfs crct10dif_ce ghash_ce virtio_blk
> > > virtio_console virtio_mmio qemu_fw_cfg
> > > [   44.638713] CPU: 2 PID: 1 Comm: systemd Not tainted 5.19.0-rc7 #1
> > > [   44.640164] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
> > > [   44.641799] pstate: 00400005 (nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> > > [   44.643404] pc : ftrace_set_filter_ip+0x24/0xa0
> > > [   44.644659] lr : bpf_trampoline_update.constprop.0+0x428/0x4a0
> > > [   44.646118] sp : ffff80000803b9f0
> > > [   44.646950] x29: ffff80000803b9f0 x28: ffff0b5d80364400 x27: ffff80000803bb48
> > > [   44.648721] x26: ffff8000085ad000 x25: ffff0b5d809d2400 x24: 0000000000000000
> > > [   44.650493] x23: 00000000ffffffed x22: ffff0b5dd7ea0900 x21: 0000000000000000
> > > [   44.652279] x20: 0000000000000000 x19: 0000000000000000 x18: ffffffffffffffff
> > > [   44.654067] x17: 0000000000000000 x16: 0000000000000000 x15: ffffffffffffffff
> > > [   44.655787] x14: ffff0b5d809d2498 x13: ffff0b5d809d2432 x12: 0000000005f5e100
> > > [   44.657535] x11: abcc77118461cefd x10: 000000000000005f x9 : ffffa7219cb5b190
> > > [   44.659254] x8 : ffffa7219c8e0000 x7 : 0000000000000000 x6 : ffffa7219db075e0
> > > [   44.661066] x5 : ffffa7219d3130e0 x4 : ffffa7219cab9da0 x3 : 0000000000000000
> > > [   44.662837] x2 : 0000000000000000 x1 : ffffa7219cb7a5c0 x0 : 0000000000000000
> > > [   44.664675] Call trace:
> > > [   44.665274]  ftrace_set_filter_ip+0x24/0xa0
> > > [   44.666327]  bpf_trampoline_update.constprop.0+0x428/0x4a0
> > > [   44.667696]  __bpf_trampoline_link_prog+0xcc/0x1c0
> > > [   44.668834]  bpf_trampoline_link_prog+0x40/0x64
> > > [   44.669919]  bpf_tracing_prog_attach+0x120/0x490
> > > [   44.671011]  link_create+0xe0/0x2b0
> > > [   44.671869]  __sys_bpf+0x484/0xd30
> > > [   44.672706]  __arm64_sys_bpf+0x30/0x40
> > > [   44.673678]  invoke_syscall+0x78/0x100
> > > [   44.674623]  el0_svc_common.constprop.0+0x4c/0xf4
> > > [   44.675783]  do_el0_svc+0x38/0x4c
> > > [   44.676624]  el0_svc+0x34/0x100
> > > [   44.677429]  el0t_64_sync_handler+0x11c/0x150
> > > [   44.678532]  el0t_64_sync+0x190/0x194
> > > [   44.679439] Code: 2a0203f4 f90013f5 2a0303f5 f9001fe1 (f9400800)
> > > [   44.680959] ---[ end trace 0000000000000000 ]---
> > > [   44.682111] Kernel panic - not syncing: Oops: Fatal exception
> > > [   44.683488] SMP: stopping secondary CPUs
> > > [   44.684551] Kernel Offset: 0x2721948e0000 from 0xffff800008000000
> > > [   44.686095] PHYS_OFFSET: 0xfffff4a380000000
> > > [   44.687144] CPU features: 0x010,00022811,19001080
> > > [   44.688308] Memory Limit: none
> > > [   44.689082] ---[ end Kernel panic - not syncing: Oops: Fatal exception ]---
> > >
> > > more logs:
> > > https://s3.us-east-1.amazonaws.com/arr-cki-prod-datawarehouse-public/datawarehouse-public/2022/07/26/redhat:597047279/build_aarch64_redhat:597047279_aarch64/tests/1/results_0001/console.log/console.log
> > >
> > > https://datawarehouse.cki-project.org/kcidb/tests/4529120
> > >
> > > CKI issue tracker: https://datawarehouse.cki-project.org/issue/1434
> > >
>
> Thanks for the report. I assume the build doesn't have
> CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS.Does the tracker have
> a link to the config file?

my apologies, I forgot to add a link to the config used:
https://gitlab.com/api/v4/projects/18194050/jobs/2771087853/artifacts/artifacts/kernel-net-next-aarch64-35d099da41967f114c6472b838e12014706c26e7.config

Bruno
> >
> > Hello,
> >
> > It's caused by a NULL tr->fops passed to ftrace_set_filter_ip:
> >
> > if (tr->func.ftrace_managed) {
> >          ftrace_set_filter_ip(tr->fops, (unsigned long)ip, 0, 0);
> >          ret = register_ftrace_direct_multi(tr->fops, (long)new_addr);
> > }
> >
> > Could you test it with the following patch?
> >
> > --- a/kernel/bpf/trampoline.c
> > +++ b/kernel/bpf/trampoline.c
> > @@ -255,8 +255,15 @@ static int register_fentry(struct bpf_trampoline *tr, void *new_addr)
> >                  return -ENOENT;
> >
> >          if (tr->func.ftrace_managed) {
> > -               ftrace_set_filter_ip(tr->fops, (unsigned long)ip, 0, 0);
> > -               ret = register_ftrace_direct_multi(tr->fops,(long)new_addr);
> > +               if (tr->fops)
> > +                       ret = ftrace_set_filter_ip(tr->fops, (unsigned long)ip,
> > +                                                  0, 0);
> > +               else
> > +                       ret = -ENOTSUPP;
> > +
> > +               if (!ret)
> > +                       ret = register_ftrace_direct_multi(tr->fops,
> > +                                                          (long)new_addr);
> >          } else {
> >                  ret = bpf_arch_text_poke(ip, BPF_MOD_CALL, NULL, new_addr);
> >          }
> >
> > Thanks.
>
> The fix looks good to me. Thanks!
> Acked-by: Song Liu <songliubraving@fb.com>
>
> Song
>

