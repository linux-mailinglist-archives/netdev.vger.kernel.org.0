Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82D0C546F80
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 00:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347056AbiFJWDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 18:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344309AbiFJWDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 18:03:02 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28DFC274D77;
        Fri, 10 Jun 2022 15:03:01 -0700 (PDT)
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nzmiY-0001ia-W2; Sat, 11 Jun 2022 00:02:59 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nzmiY-0001CB-ML; Sat, 11 Jun 2022 00:02:58 +0200
Subject: Re: [PATCH bpf-next v2 0/7] Add bpf_link based TC-BPF API
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Joanne Koong <joannelkoong@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev <netdev@vger.kernel.org>
References: <20210604063116.234316-1-memxor@gmail.com>
 <CAJnrk1YJe-wtXFF0U2cuZUdd-gH1Y80Ewf3ePo=vh-nbsSBZgg@mail.gmail.com>
 <20220610125830.2tx6syagl2rphl35@apollo.legion>
 <CAJnrk1YCBn2EkVK89f5f3ijFYUDhLNpjiH8buw8K3p=JMwAc1Q@mail.gmail.com>
 <CAJnrk1YCSaRjd88WCzg4ccv59h0Dn99XXsDDT4ddzz4UYiZmbg@mail.gmail.com>
 <20220610193418.4kqpu7crwfb5efzy@apollo.legion> <87h74s2s19.fsf@toke.dk>
 <2f98188b-813b-e226-4962-5c2848998af2@iogearbox.net> <87bkv02qva.fsf@toke.dk>
 <CAADnVQLbC-KVNRPgbJP3rokgLELam5ao1-Fnpej8d-9JaHMJPA@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <15bdc24c-fe85-479a-83fe-921da04cb6b1@iogearbox.net>
Date:   Sat, 11 Jun 2022 00:02:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAADnVQLbC-KVNRPgbJP3rokgLELam5ao1-Fnpej8d-9JaHMJPA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26568/Fri Jun 10 10:06:23 2022)
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/10/22 11:52 PM, Alexei Starovoitov wrote:
> On Fri, Jun 10, 2022 at 1:41 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>
>>>> Except we'd want to also support multiple programs on different
>>>> priorities? I don't think requiring a libxdp-like dispatcher to achieve
>>>> this is a good idea if we can just have it be part of the API from the
>>>> get-go...
>>>
>>> Yes, it will be multi-prog to avoid a situation where dispatcher is needed.
>>
>> Awesome! :)
> 
> Let's keep it simple to start.
> Priorities or anything fancy can be added later if really necessary.
> Otherwise, I'm afraid, we will go into endless bikeshedding
> or the best priority scheme.
> 
> A link list of bpf progs like cls_bpf with the same semantics as
> cls_bpf_classify.
> With prog->exts_integrated always true and no classid, since this
> concept doesn't apply.
Yes, semantics must be that TC_ACT_UNSPEC continues in the list and
everything else as return code would terminate the evaluation.
