Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 303C063E65D
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 01:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbiLAATM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 19:19:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiLAAS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 19:18:56 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB0B827925;
        Wed, 30 Nov 2022 16:16:11 -0800 (PST)
Message-ID: <07db58dd-0752-e148-8d89-e22b8d7769f0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1669853770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HvGy5tm7ABXBB1vSSUkpS0E3sZwRzjBRJgRM0OOUc8A=;
        b=Qw7SJcVD6U10lW5WYLZRCv4cxzkOaxU77exbblEIQ+ZtvqOLgp/DNGVvDnkyy8JZakV01x
        OG5jFQh+FaUU/606crGIz7r2hSYCzRjFzTYMndBapwX1CQ+If1tTEIIrGG1J9fX5ULKPbA
        lMCDBEFx/dA3nIuTKwqWeVAZznnDPGg=
Date:   Wed, 30 Nov 2022 16:16:00 -0800
MIME-Version: 1.0
Subject: Re: [xdp-hints] Re: [PATCH bpf-next v3 00/11] xdp: hints via kfuncs
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
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
References: <20221129193452.3448944-1-sdf@google.com> <8735a1zdrt.fsf@toke.dk>
 <CAKH8qBsTNEZcyLq8EsZhsBHsLNe7831r23YdwZfDsbXo06FTBg@mail.gmail.com>
 <87o7soxd1v.fsf@toke.dk>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <87o7soxd1v.fsf@toke.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/30/22 3:01 PM, Toke Høiland-Jørgensen wrote:
>> It feels like beyond that extra dev_put, we'd need to reset our
>> aux->xdp_netdev and/or add some flag or something else to indicate
>> that this bpf program is "orphaned" and can't be attached anywhere
>> anymore (since the device is gone; netdev_run_todo should free the
>> netdev it seems).

imo, orphan the prog and not able to attach again is ok.  Finding the next 
compatible netdev would be nice but not a must to begin with.  Regardless, it 
needs a bpf_prog<->netdev decoupling approach which allows to unregister netdev 
gracefully instead of getting the "unregister_netdevice: waiting for xyz to 
become free...".

fwiw, offload.c has solved a similar problem and it keeps its own list of prog 
depending on a particular netdev.  Whatever approach makes more sense here. 
Ideally, other non-NIC HW kfunc can reuse a similar approach in the future.


