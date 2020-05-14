Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0532E1D3DCB
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 21:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728418AbgENTnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 15:43:24 -0400
Received: from linux.microsoft.com ([13.77.154.182]:40444 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727769AbgENTnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 15:43:23 -0400
Received: by linux.microsoft.com (Postfix, from userid 1001)
        id 8740120B717B; Thu, 14 May 2020 12:43:22 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8740120B717B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1589485402;
        bh=CJJ+sOkxdWfr6O8hmWNrk7EaS+VUkJF7il2uw19u0gs=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=c5o3x+2QFTsrYiBRb9pjAfHPLzqiQrZo6fMZ9dNLbStilKd8++OGSnFuZlOLrJf0/
         LSohna5CO+XRKRHEsq1FCANuvmaLSBv6SJJzcksJzIhyau5BdUXqoAIA429Y7PHfdU
         kJhZd5pgzIN9QG7zsEKxDyxut/V0obeAu1ZOG04g=
Received: from localhost (localhost [127.0.0.1])
        by linux.microsoft.com (Postfix) with ESMTP id 83BD930705DA;
        Thu, 14 May 2020 12:43:22 -0700 (PDT)
Date:   Thu, 14 May 2020 12:43:22 -0700 (PDT)
From:   James Morris <jamorris@linux.microsoft.com>
X-X-Sender: jamorris@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
cc:     Anders Roxell <anders.roxell@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] security: fix the default value of secid_to_secctx
 hook
In-Reply-To: <CAADnVQK6cka9i_GGz3OcjaNiEQEZYwgCLsn-S_Bkm-OWPJZb_w@mail.gmail.com>
Message-ID: <alpine.LRH.2.21.2005141243120.53197@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.inter>
References: <20200512174607.9630-1-anders.roxell@linaro.org> <CAADnVQK6cka9i_GGz3OcjaNiEQEZYwgCLsn-S_Bkm-OWPJZb_w@mail.gmail.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 May 2020, Alexei Starovoitov wrote:

> James,
> 
> since you took the previous similar patch are you going to pick this
> one up as well?
> Or we can route it via bpf tree to Linus asap.

Routing via your tree is fine.

> 
> Thanks
> 
> On Tue, May 12, 2020 at 10:46 AM Anders Roxell <anders.roxell@linaro.org> wrote:
> >
> > security_secid_to_secctx is called by the bpf_lsm hook and a successful
> > return value (i.e 0) implies that the parameter will be consumed by the
> > LSM framework. The current behaviour return success when the pointer
> > isn't initialized when CONFIG_BPF_LSM is enabled, with the default
> > return from kernel/bpf/bpf_lsm.c.
> >
> > This is the internal error:
> >
> > [ 1229.341488][ T2659] usercopy: Kernel memory exposure attempt detected from null address (offset 0, size 280)!
> > [ 1229.374977][ T2659] ------------[ cut here ]------------
> > [ 1229.376813][ T2659] kernel BUG at mm/usercopy.c:99!
> > [ 1229.378398][ T2659] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
> > [ 1229.380348][ T2659] Modules linked in:
> > [ 1229.381654][ T2659] CPU: 0 PID: 2659 Comm: systemd-journal Tainted: G    B   W         5.7.0-rc5-next-20200511-00019-g864e0c6319b8-dirty #13
> > [ 1229.385429][ T2659] Hardware name: linux,dummy-virt (DT)
> > [ 1229.387143][ T2659] pstate: 80400005 (Nzcv daif +PAN -UAO BTYPE=--)
> > [ 1229.389165][ T2659] pc : usercopy_abort+0xc8/0xcc
> > [ 1229.390705][ T2659] lr : usercopy_abort+0xc8/0xcc
> > [ 1229.392225][ T2659] sp : ffff000064247450
> > [ 1229.393533][ T2659] x29: ffff000064247460 x28: 0000000000000000
> > [ 1229.395449][ T2659] x27: 0000000000000118 x26: 0000000000000000
> > [ 1229.397384][ T2659] x25: ffffa000127049e0 x24: ffffa000127049e0
> > [ 1229.399306][ T2659] x23: ffffa000127048e0 x22: ffffa000127048a0
> > [ 1229.401241][ T2659] x21: ffffa00012704b80 x20: ffffa000127049e0
> > [ 1229.403163][ T2659] x19: ffffa00012704820 x18: 0000000000000000
> > [ 1229.405094][ T2659] x17: 0000000000000000 x16: 0000000000000000
> > [ 1229.407008][ T2659] x15: 0000000000000000 x14: 003d090000000000
> > [ 1229.408942][ T2659] x13: ffff80000d5b25b2 x12: 1fffe0000d5b25b1
> > [ 1229.410859][ T2659] x11: 1fffe0000d5b25b1 x10: ffff80000d5b25b1
> > [ 1229.412791][ T2659] x9 : ffffa0001034bee0 x8 : ffff00006ad92d8f
> > [ 1229.414707][ T2659] x7 : 0000000000000000 x6 : ffffa00015eacb20
> > [ 1229.416642][ T2659] x5 : ffff0000693c8040 x4 : 0000000000000000
> > [ 1229.418558][ T2659] x3 : ffffa0001034befc x2 : d57a7483a01c6300
> > [ 1229.420610][ T2659] x1 : 0000000000000000 x0 : 0000000000000059
> > [ 1229.422526][ T2659] Call trace:
> > [ 1229.423631][ T2659]  usercopy_abort+0xc8/0xcc
> > [ 1229.425091][ T2659]  __check_object_size+0xdc/0x7d4
> > [ 1229.426729][ T2659]  put_cmsg+0xa30/0xa90
> > [ 1229.428132][ T2659]  unix_dgram_recvmsg+0x80c/0x930
> > [ 1229.429731][ T2659]  sock_recvmsg+0x9c/0xc0
> > [ 1229.431123][ T2659]  ____sys_recvmsg+0x1cc/0x5f8
> > [ 1229.432663][ T2659]  ___sys_recvmsg+0x100/0x160
> > [ 1229.434151][ T2659]  __sys_recvmsg+0x110/0x1a8
> > [ 1229.435623][ T2659]  __arm64_sys_recvmsg+0x58/0x70
> > [ 1229.437218][ T2659]  el0_svc_common.constprop.1+0x29c/0x340
> > [ 1229.438994][ T2659]  do_el0_svc+0xe8/0x108
> > [ 1229.440587][ T2659]  el0_svc+0x74/0x88
> > [ 1229.441917][ T2659]  el0_sync_handler+0xe4/0x8b4
> > [ 1229.443464][ T2659]  el0_sync+0x17c/0x180
> > [ 1229.444920][ T2659] Code: aa1703e2 aa1603e1 910a8260 97ecc860 (d4210000)
> > [ 1229.447070][ T2659] ---[ end trace 400497d91baeaf51 ]---
> > [ 1229.448791][ T2659] Kernel panic - not syncing: Fatal exception
> > [ 1229.450692][ T2659] Kernel Offset: disabled
> > [ 1229.452061][ T2659] CPU features: 0x240002,20002004
> > [ 1229.453647][ T2659] Memory Limit: none
> > [ 1229.455015][ T2659] ---[ end Kernel panic - not syncing: Fatal exception ]---
> >
> > Rework the so the default return value is -EOPNOTSUPP.
> >
> > There are likely other callbacks such as security_inode_getsecctx() that
> > may have the same problem, and that someone that understand the code
> > better needs to audit them.
> >
> > Thank you Arnd for helping me figure out what went wrong.
> >
> > CC: Arnd Bergmann <arnd@arndb.de>
> > Fixes: 98e828a0650f ("security: Refactor declaration of LSM hooks")
> > Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
> > ---
> >  include/linux/lsm_hook_defs.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
> > index b9e73d736e13..31eb3381e54b 100644
> > --- a/include/linux/lsm_hook_defs.h
> > +++ b/include/linux/lsm_hook_defs.h
> > @@ -243,7 +243,7 @@ LSM_HOOK(int, -EINVAL, getprocattr, struct task_struct *p, char *name,
> >          char **value)
> >  LSM_HOOK(int, -EINVAL, setprocattr, const char *name, void *value, size_t size)
> >  LSM_HOOK(int, 0, ismaclabel, const char *name)
> > -LSM_HOOK(int, 0, secid_to_secctx, u32 secid, char **secdata,
> > +LSM_HOOK(int, -EOPNOTSUPP, secid_to_secctx, u32 secid, char **secdata,
> >          u32 *seclen)
> >  LSM_HOOK(int, 0, secctx_to_secid, const char *secdata, u32 seclen, u32 *secid)
> >  LSM_HOOK(void, LSM_RET_VOID, release_secctx, char *secdata, u32 seclen)
> > --
> > 2.20.1
> >
> 


-- 
James Morris
<jamorris@linux.microsoft.com>
