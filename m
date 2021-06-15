Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 914AB3A8C3D
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 01:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbhFOXJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 19:09:33 -0400
Received: from www62.your-server.de ([213.133.104.62]:39142 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbhFOXJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 19:09:32 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1ltI9U-000G8g-Sg; Wed, 16 Jun 2021 01:07:24 +0200
Received: from [85.7.101.30] (helo=linux-3.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1ltI9U-000Eeg-Fg; Wed, 16 Jun 2021 01:07:24 +0200
Subject: Re: [PATCH RFC bpf-next 0/7] Add bpf_link based TC-BPF API
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Vlad Buslov <vladbu@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>
References: <20210528195946.2375109-1-memxor@gmail.com>
 <CAM_iQpVqVKhK+09Sj_At226mdWpVXfVbhy89As2dai7ip8Nmtw@mail.gmail.com>
 <20210607033724.wn6qn4v42dlm4j4o@apollo>
 <CAM_iQpVCnG8pSci2sMbJ1B5YE-y=reAUp82itgrguecyNBCUVQ@mail.gmail.com>
 <20210607060724.4nidap5eywb23l3d@apollo>
 <CAM_iQpWA=SXNR3Ya8_L2aoVJGP_uaRP8EYCpDrnq3y8Uf6qu=g@mail.gmail.com>
 <20210608071908.sos275adj3gunewo@apollo>
 <CAM_iQpXFmsWhMA-RO2j5Ph5Ak8yJgUVBppGj2_5NS3BuyjkvzQ@mail.gmail.com>
 <20210613025308.75uia7rnt4ue2k7q@apollo>
 <30ab29b9-c8b0-3b0f-af5f-78421b27b49c@mojatatu.com>
 <20210613203438.d376porvf5zycatn@apollo>
 <4b1046ef-ba16-f8d8-c02e-d69648ab510b@mojatatu.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <bd18943b-8a0e-be8c-6a99-17f7dfdd3bc4@iogearbox.net>
Date:   Wed, 16 Jun 2021 01:07:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <4b1046ef-ba16-f8d8-c02e-d69648ab510b@mojatatu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26202/Tue Jun 15 13:21:24 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/13/21 11:10 PM, Jamal Hadi Salim wrote:
> On 2021-06-13 4:34 p.m., Kumar Kartikeya Dwivedi wrote:
>> On Mon, Jun 14, 2021 at 01:57:16AM IST, Jamal Hadi Salim wrote:
[...]
>> Right, also I'm just posting so that the use cases I care about are clear, and
>> why they are not being fulifilled in some other way. How to do it is ofcourse up
>> to TC and BPF maintainers, which is why I'm still waiting on feedback from you,
>> Cong and others before posting the next version.
> 
> I look at it from the perspective that if i can run something with
> existing tc loading mechanism then i should be able to do the same
> with the new (libbpf) scheme.

The intention is not to provide a full-blown tc library (that could be subject to a
libtc or such), but rather to only have libbpf abstract the tc related API that is
most /relevant/ for BPF program development and /efficient/ in terms of execution in
fast-path while at the same time providing a good user experience from the API itself.

That is, simple to use and straight forward to explain to folks with otherwise zero
experience of tc. The current implementation does all that, and from experience with
large BPF programs managed via cls_bpf that is all that is actually needed from tc
layer perspective. The ability to have multi programs (incl. priorities) is in the
existing libbpf API as well.

Best,
Daniel
