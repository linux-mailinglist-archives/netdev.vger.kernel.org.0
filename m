Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 028FE211DE3
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 10:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgGBIRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 04:17:36 -0400
Received: from proxmox-new.maurer-it.com ([212.186.127.180]:59973 "EHLO
        proxmox-new.maurer-it.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726042AbgGBIRg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 04:17:36 -0400
X-Greylist: delayed 314 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Jul 2020 04:17:35 EDT
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
        by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 9D6EC42F88;
        Thu,  2 Jul 2020 10:12:20 +0200 (CEST)
Subject: Re: [Patch net] cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
To:     Cong Wang <xiyou.wangcong@gmail.com>, Roman Gushchin <guro@fb.com>
Cc:     Cameron Berkenpas <cam@neo-zeon.de>, Zefan Li <lizefan@huawei.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Peter Geis <pgwipeout@gmail.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        =?UTF-8?Q?Dani=c3=abl_Sonck?= <dsonck92@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Tejun Heo <tj@kernel.org>
References: <4f17229e-1843-5bfc-ea2f-67ebaa9056da@huawei.com>
 <CAM_iQpVKqFi00ohqPARxaDw2UN1m6CtjqsmBAP-pcK0GT2p_fQ@mail.gmail.com>
 <459be87d-0272-9ea9-839a-823b01e354b6@huawei.com>
 <35480172-c77e-fb67-7559-04576f375ea6@huawei.com>
 <CAM_iQpXpZd6ZaQyQifWOHSnqgAgdu1qP+fF_Na7rQ_H1vQ6eig@mail.gmail.com>
 <20200623222137.GA358561@carbon.lan>
 <b3a5298d-3c4e-ba51-7045-9643c3986054@neo-zeon.de>
 <CAM_iQpU1ji2x9Pgb6Xs7Kqoh3mmFRN3R9GKf5QoVUv82mZb8hg@mail.gmail.com>
 <20200627234127.GA36944@carbon.DHCP.thefacebook.com>
 <CAM_iQpWk4x7U_ci1WTf6BG=E3yYETBUk0yxMNSz6GuWFXfhhJw@mail.gmail.com>
 <20200630224829.GC37586@carbon.dhcp.thefacebook.com>
 <CAM_iQpWRsuFE4NRhGncihK8UmPoMv1tEHMM0ufWxVCaP9pdTQg@mail.gmail.com>
From:   Thomas Lamprecht <t.lamprecht@proxmox.com>
Message-ID: <bffca2e0-d36d-0b56-bb1b-a7e96d9493aa@proxmox.com>
Date:   Thu, 2 Jul 2020 10:12:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpWRsuFE4NRhGncihK8UmPoMv1tEHMM0ufWxVCaP9pdTQg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.07.20 06:48, Cong Wang wrote:
> On Tue, Jun 30, 2020 at 3:48 PM Roman Gushchin <guro@fb.com> wrote:
>>
>> Btw if we want to backport the problem but can't blame a specific commit,
>> we can always use something like "Cc: <stable@vger.kernel.org>    [3.1+]".
> 
> Sure, but if we don't know which is the right commit to blame, then how
> do we know which stable version should the patch target? :)

We run into a similar issue here once we made an update from the 5.4.41 to the
5.4.44 stable kernel. This patch addresses the issue, at least we are running
stable at >17 hours uptime with this patch, whereas we ran into issues normally
at <6 hour uptime without this patch.

That update included newly the commit 090e28b229af92dc5b ("netprio_cgroup: Fix
unlimited memory leak of v2 cgroups") which this patch originally mentions as
"Fixes", whereas the other mentioned possible culprit 4bfc0bb2c60e2f4c ("bpf:
decouple the lifetime of cgroup_bpf from cgroup itself") was included with 5.2
here, and did *not* made problems here.

So, while the real culprit may be something else, a mix of them, or even more
complex, the race is at least triggered way more frequently with the
090e28b229af92dc5b ("netprio_cgroup: Fix unlimited memory leak of v2 cgroups")
one or, for the sake of mentioning, possibly also something else from the
v5.4.41..v5.4.44 commit range - I did not looked into that in detail yet.

> 
> I am open to all options here, including not backporting to stable at all.

As said, the stable-5.4.y tree profits from having this patch here, so there's
that.

Also, FWIW:
Tested-by: Thomas Lamprecht <t.lamprecht@proxmox.com>

