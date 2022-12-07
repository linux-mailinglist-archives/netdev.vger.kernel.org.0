Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1022264548D
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 08:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiLGHYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 02:24:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiLGHYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 02:24:04 -0500
Received: from out-239.mta0.migadu.com (out-239.mta0.migadu.com [91.218.175.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B8ACC5
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 23:24:02 -0800 (PST)
Message-ID: <dfcfd47a-808f-ee1c-c04a-dcfedd9a2b23@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1670397840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B3PEia+i1BuL1UOZCVF48BHXleojofUs1rdo3/67Nvs=;
        b=Q2P0kiU9qzUSGmCD/3q7Xx7WtlMS3yyMI3z67K73kj6hI63KZp6t6fiXoe8AbusLTZNcUl
        RXjHZIQHc9wPAUSmg6TPKuM+TWP2f1EdPWMbKhT39lanlGe8A1pr9DezKVuZQkbCajQD6C
        rbKIMpmEV9gq4Cw8qu3q5hUjiCVNMHY=
Date:   Tue, 6 Dec 2022 23:23:53 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v3 03/12] bpf: XDP metadata RX kfuncs
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org, David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
References: <20221206024554.3826186-1-sdf@google.com>
 <20221206024554.3826186-4-sdf@google.com>
 <Y5AWkAYVEBqi5jy3@macbook-pro-6.dhcp.thefacebook.com>
 <CAKH8qBuzJsmOGroS+wfb3vY_y1jksishztsiU2nV7Ts2TJ37bg@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <CAKH8qBuzJsmOGroS+wfb3vY_y1jksishztsiU2nV7Ts2TJ37bg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/6/22 8:52 PM, Stanislav Fomichev wrote:
> On Tue, Dec 6, 2022 at 8:29 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
>>
>> On Mon, Dec 05, 2022 at 06:45:45PM -0800, Stanislav Fomichev wrote:
>>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>>> index fc4e313a4d2e..00951a59ee26 100644
>>> --- a/kernel/bpf/verifier.c
>>> +++ b/kernel/bpf/verifier.c
>>> @@ -15323,6 +15323,24 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
>>>                return -EINVAL;
>>>        }
>>>
>>> +     *cnt = 0;
>>> +
>>> +     if (resolve_prog_type(env->prog) == BPF_PROG_TYPE_XDP) {
>>> +             if (bpf_prog_is_offloaded(env->prog->aux)) {
>>> +                     verbose(env, "no metadata kfuncs offload\n");
>>> +                     return -EINVAL;
>>> +             }
>>
>> If I'm reading this correctly than this error will trigger
>> for any XDP prog trying to use a kfunc?
> 
> bpf_prog_is_offloaded() should return true only when the program is
> fully offloaded to the device (like nfp). So here the intent is to
> reject kfunc programs because nft should somehow implement them first.
> Unless I'm not setting offload_requested somewhere, not sure I see the
> problem. LMK if I missed something.

It errors out for all kfunc here though. or it meant to error out for the 
XDP_METADATA_KFUNC_* only?

