Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32CE36ED9F0
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 03:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232801AbjDYBjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 21:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbjDYBjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 21:39:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC35AF04;
        Mon, 24 Apr 2023 18:39:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EB1C62A0D;
        Tue, 25 Apr 2023 01:39:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 634E0C433EF;
        Tue, 25 Apr 2023 01:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682386743;
        bh=7Cc7EPJ+q4FtKp9evs/nNwHrEkNOVZMFrQmiSexhBYE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ZCMILtBlPEqMDJwMW9NM2lomD0O/11qW8UXAgXXF3cQzWvex2moR4JKn05Ve+h0fT
         OMoaZq+TUbiVBIWMm14PvgqhtwuYpVVVWQJwCD/53p7fhV1CXJGNpaIjRffLxoN0E3
         AHjPfsOjafjOymJMexHr9xaqoPAD/5qPOCeXYnsYXGVI6zy1w94VoiBeApiiP92tJw
         jWR2L2TR0dcKjvyfqVgjb2vdnKsfjqFLYlOpIl8lFIcCEFyWHcrh+RPbpcMi8gz5NY
         WoS4ungU+vX3ZuBAzd0oT1gfKqV/ZBtESF8NGZBImxDfHTJQeGfG3u8tg4DM9E5ncL
         AmseJAA5fu9Iw==
Message-ID: <09814247-07ca-5945-8b6e-9dc1632c1e45@kernel.org>
Date:   Mon, 24 Apr 2023 19:39:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH bpf,v2 0/4] Socket lookup BPF API from tc/xdp ingress does
 not respect VRF bindings.
To:     Stanislav Fomichev <sdf@google.com>,
        Gilad Sever <gilad9366@gmail.com>
Cc:     martin.lau@linux.dev, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mykolal@fb.com,
        shuah@kernel.org, hawk@kernel.org, joe@wand.net.nz,
        eyal.birger@gmail.com, shmulik.ladkani@gmail.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
References: <20230420145041.508434-1-gilad9366@gmail.com>
 <ZEFrcoG+QS/PRbew@google.com>
 <2ebf97ba-1bd2-3286-7feb-d2e7f4c95383@gmail.com>
 <CAKH8qBuntApFvGYEs_fU_OAsQeP_Uf2sdrEMAtB4rS6c6fhF9A@mail.gmail.com>
Content-Language: en-US
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <CAKH8qBuntApFvGYEs_fU_OAsQeP_Uf2sdrEMAtB4rS6c6fhF9A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/24/23 11:06 AM, Stanislav Fomichev wrote:
>> - xdp callers would check the device's l3 enslaved state using the new
>> `dev_sdif()`
>> - sock_addr callers would use inet{,6}_sdif() as they did before
>> - cg/tc share the same code path, so when netif_is_l3_master() is true
>>    use inet{,6}_sdif() and when it is false use dev_sdif(). this relies
>> on the following
>>    assumptions:
>>    - tc programs don't run on l3 master devices

this can happen, but I am not sure how prevalent a use case.

>>    - cgroup callers never see l3 enslaved devices

egress definitely, not sure on ingress. The code resets the skb->dev
back to the original device in a lot of places in the ip/ipv6 code now.
And ipv6 brings up LLAs and those did not get the device switch so it
could be fairly common.

>>    - inet{,6}_sdif() isn't relevant for non l3 master devices

sdif should be 0 and not matched if a netdev is not a l3mdev port.

BTW, in skimming the patches, I noticed patch 3 has bpf_l2_sdif which
seems an odd name to me. It returns a layer 3 device index, not a layer
2 which would be a bridge port. I would stick to the l3 naming for
consistency.

> 
> Yeah, that's what I was assuming we should be able to do..
> But we probably need somebody who understands this part better than me
> to say whether the above are safe..
> 
> If nobody comments, ignore me and do a v2 with your original approach.

