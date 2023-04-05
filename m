Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8FF6D870F
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 21:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233891AbjDETkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 15:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232442AbjDETk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 15:40:29 -0400
Received: from out-37.mta1.migadu.com (out-37.mta1.migadu.com [95.215.58.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 731987D8A
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 12:40:05 -0700 (PDT)
Message-ID: <c0596a62-0873-5638-920b-235c55ff33a2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1680723534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Frao4MIUa9QmfySt08uJoD9P4bRv8oM72t8WzbutWUM=;
        b=LZIQZ/bjypmz3jEsl53xilMeBc8YgL+90Ws8fG4BKba1/I26tuMu9JqWANc3SYv8W2e4+N
        lcrcfXl2A3g8qWqBh3QCDWEDOrcTrGi4pJB91D1RvAiE9sttQNyxOtX9nRRSRZZP2zT2ey
        nszvNq6wqqY3nycE/qhz4IiZNSIWTvs=
Date:   Wed, 5 Apr 2023 12:38:48 -0700
MIME-Version: 1.0
Subject: Re: [PATCH bpf] xsk: Fix unaligned descriptor validation
Content-Language: en-US
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        Kal Conley <kal.conley@dectris.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230403143601.32168-1-kal.conley@dectris.com>
 <CAJ8uoz1BKJ1_jq6Sum-OkZQTR_ftmr5Enj+Cmn4Qsi15_jOpbQ@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <CAJ8uoz1BKJ1_jq6Sum-OkZQTR_ftmr5Enj+Cmn4Qsi15_jOpbQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/3/23 11:25 PM, Magnus Karlsson wrote:
> On Mon, 3 Apr 2023 at 16:38, Kal Conley <kal.conley@dectris.com> wrote:
>>
>> Make sure unaligned descriptors that straddle the end of the UMEM are
>> considered invalid. Currently, descriptor validation is broken for
>> zero-copy mode which only checks descriptors at page granularity.
>> Descriptors that cross the end of the UMEM but not a page boundary may
>> be therefore incorrectly considered valid. The check needs to happen
>> before the page boundary and contiguity checks in
>> xp_desc_crosses_non_contig_pg. Do this check in
>> xp_unaligned_validate_desc instead like xp_check_unaligned already does.
> 
> Thanks for catching this Kal.
> 
> Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

Is this case covered by an existing test?

