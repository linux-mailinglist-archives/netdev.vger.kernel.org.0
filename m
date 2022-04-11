Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A19A4FB7DC
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 11:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244406AbiDKJnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 05:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344689AbiDKJmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 05:42:47 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D8D62F012;
        Mon, 11 Apr 2022 02:40:33 -0700 (PDT)
Message-ID: <46c1c59e-1368-620d-e57a-f35c2c82084d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1649670031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zS90bcIV3w8B4dGQgPINU7Ih71Ht5FIfbS2dm03ISmU=;
        b=Yc836Dzso0qwc1FwWYDpdsQm1Jow2ayt3zJVXH80ia38H0Bp5G2gt67LQ3Yb4xQQul3l5b
        FtCpsSpyHdGQTBeqjGm4eoENjBwuW5aK58UH8TmsBWjTfIUEG1vQPWx+ZFO9+hYUxDv09S
        lIcGnEmTPBRSkah6VKU7E82P3ke94/0=
Date:   Mon, 11 Apr 2022 12:40:29 +0300
MIME-Version: 1.0
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Vasily Averin <vasily.averin@linux.dev>
Subject: problem with accounting of allocations called from __net_init hooks
Content-Language: en-US
To:     Shakeel Butt <shakeelb@google.com>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Vlastimil Babka <vbabka@suse.cz>, NeilBrown <neilb@suse.de>,
        Michal Hocko <mhocko@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Linux MM <linux-mm@kvack.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Dumazet <edumazet@google.com>,
        Kees Cook <keescook@chromium.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, linux-kernel@vger.kernel.org,
        kernel@openvz.org, Luis Chamberlain <mcgrof@kernel.org>
References: <a5e09e93-106d-0527-5b1e-48dbf3b48b4e@virtuozzo.com>
 <YhzeCkXEvga7+o/A@bombadil.infradead.org>
 <20220301180917.tkibx7zpcz2faoxy@google.com>
In-Reply-To: <20220301180917.tkibx7zpcz2faoxy@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/1/22 21:09, Shakeel Butt wrote:
> On Mon, Feb 28, 2022 at 06:36:58AM -0800, Luis Chamberlain wrote:
>> On Mon, Feb 28, 2022 at 10:17:16AM +0300, Vasily Averin wrote:
>> > Following one-liner running inside memcg-limited container consumes
>> > huge number of host memory and can trigger global OOM.
>> >
>> > for i in `seq 1 xxx` ; do ip l a v$i type veth peer name vp$i ; done
>> >
>> > Patch accounts most part of these allocations and can protect host.
>> > ---[cut]---
>> > It is not polished, and perhaps should be splitted.
>> > obviously it affects other kind of netdevices too.
>> > Unfortunately I'm not sure that I will have enough time to handle it properly
>> > and decided to publish current patch version as is.
>> > OpenVz workaround it by using per-container limit for number of
>> > available netdevices, but upstream does not have any kind of
>> > per-container configuration.
>> > ------

I've noticed that __register_pernet_operations() executes init hook of registered 
pernet_operation structure in all found net namespaces.

Usually these hooks are called by process related to specified net namespace,
and all marked allocation are accounted to related container:
i.e. objects related to netns in container A are accounted to memcg of container A,
objects allocated inside container B are accounted to corresponding memcg B,
and so on.

However __register_pernet_operations() calls the same hooks in one context,
and as result all marked allocations are accounted to one memcg.
It is quite rare scenario, however current processing looks incorrect for me.

I expect we can take memcg from 'struct net', because of this structure is accounted per se.
then we can use set_active_memcg() before init hook execution.
However I'm not sure it is fully correct.

Could you please advise some better solution?

Thank you,
	Vasily Averin
