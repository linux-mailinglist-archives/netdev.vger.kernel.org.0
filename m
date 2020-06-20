Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF94E201FE4
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 04:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732102AbgFTCsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 22:48:22 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:6292 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732006AbgFTCsQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 22:48:16 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 79D4760E13E5667660A4;
        Sat, 20 Jun 2020 10:48:11 +0800 (CST)
Received: from [10.166.213.22] (10.166.213.22) by smtp.huawei.com
 (10.3.19.214) with Microsoft SMTP Server (TLS) id 14.3.487.0; Sat, 20 Jun
 2020 10:48:06 +0800
Subject: Re: [Patch net] cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
To:     Roman Gushchin <guro@fb.com>
CC:     Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cameron Berkenpas <cam@neo-zeon.de>,
        Peter Geis <pgwipeout@gmail.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        =?UTF-8?Q?Dani=c3=abl_Sonck?= <dsonck92@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Tejun Heo <tj@kernel.org>
References: <20200616180352.18602-1-xiyou.wangcong@gmail.com>
 <141629e1-55b5-34b1-b2ab-bab6b68f0671@huawei.com>
 <CAM_iQpUFFHPnMxS2sAHZqMUs80tTn0+C_jCcne4Ddx2b9omCxg@mail.gmail.com>
 <20200618193611.GE24694@carbon.DHCP.thefacebook.com>
 <CAM_iQpWuNnHqNHKz5FMgAXoqQ5qGDEtNbBKDXpmpeNSadCZ-1w@mail.gmail.com>
 <4f17229e-1843-5bfc-ea2f-67ebaa9056da@huawei.com>
 <20200620005115.GE237539@carbon.dhcp.thefacebook.com>
 <f80878fe-bf2d-605a-50e4-bda97a1390c2@huawei.com>
 <20200620011409.GG237539@carbon.dhcp.thefacebook.com>
From:   Zefan Li <lizefan@huawei.com>
Message-ID: <0851bf66-9d81-5c50-c75d-3a70a069a654@huawei.com>
Date:   Sat, 20 Jun 2020 10:48:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200620011409.GG237539@carbon.dhcp.thefacebook.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.166.213.22]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>> If so, we might wanna fix it in a different way,
>>> just checking if (!(css->flags & CSS_NO_REF)) in cgroup_bpf_put()
>>> like in cgroup_put(). It feels more reliable to me.
>>>
>>
>> Yeah I also have this idea in my mind.
> 
> I wonder if the following patch will fix the issue?
> 

I guess so, but it's better we have someone who reported this bug to
test it.

> --
> 
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 4598e4da6b1b..7eb51137d896 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -942,12 +942,14 @@ static inline bool cgroup_task_frozen(struct task_struct *task)
>  #ifdef CONFIG_CGROUP_BPF
>  static inline void cgroup_bpf_get(struct cgroup *cgrp)
>  {
> -       percpu_ref_get(&cgrp->bpf.refcnt);
> +       if (!(cgrp->self.flags & CSS_NO_REF))
> +               percpu_ref_get(&cgrp->bpf.refcnt);
>  }
>  
>  static inline void cgroup_bpf_put(struct cgroup *cgrp)
>  {
> -       percpu_ref_put(&cgrp->bpf.refcnt);
> +       if (!(cgrp->self.flags & CSS_NO_REF))
> +               percpu_ref_put(&cgrp->bpf.refcnt);
>  }
>  
>  #else /* CONFIG_CGROUP_BPF */
> 

