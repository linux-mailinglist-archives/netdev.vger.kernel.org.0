Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF085332AA
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 22:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240047AbiEXUyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 16:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241678AbiEXUyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 16:54:01 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF84E880D2
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 13:53:59 -0700 (PDT)
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1ntbXF-00035A-8k; Tue, 24 May 2022 22:53:45 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1ntbXE-000FwZ-U2; Tue, 24 May 2022 22:53:44 +0200
Subject: Re: [PATCH net-next v2] net, neigh: introduce interval_probe_time for
 periodic probe
To:     Yuwei Wang <wangyuweihx@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     davem@davemloft.net, Eric Dumazet <edumazet@google.com>,
        roopa@nvidia.com, dsahern@kernel.org,
        =?UTF-8?B?56em6L+q?= <qindi@staff.weibo.com>,
        netdev@vger.kernel.org, yuwei wang <wangyuweihx@hotmail.com>,
        razor@blackwall.org
References: <20220522031739.87399-1-wangyuweihx@gmail.com>
 <b5cf7fac361752d925f663d9a9b0b8415084f7d3.camel@redhat.com>
 <CANmJ_FP0CxSVksjvNsNjpQO8w+S3_10byQSCpt1ifQ6HeURUmA@mail.gmail.com>
 <cf3188eba7e529e4f112f6a752158f38e22f4851.camel@redhat.com>
 <797c3c53-ce1b-9f60-e253-cda615788f4a@iogearbox.net>
 <20220524110749.6c29464b@kernel.org>
 <CANmJ_FN6_79nRmmzKzoExzD+KJ5Uzehj8Rw_GQhV0SiBpF3rPg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3fc6aba3-fc63-5722-7a6a-48b7472deffd@iogearbox.net>
Date:   Tue, 24 May 2022 22:53:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CANmJ_FN6_79nRmmzKzoExzD+KJ5Uzehj8Rw_GQhV0SiBpF3rPg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26551/Tue May 24 10:06:48 2022)
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/24/22 9:13 PM, Yuwei Wang wrote:
> On Wed, 25 May 2022 at 02:07, Jakub Kicinski <kuba@kernel.org> wrote:
>> On Tue, 24 May 2022 17:32:57 +0200 Daniel Borkmann wrote:
>>> Right, maybe we could just split this into two: 1) prevent misconfig (see
>>> below), and 2) make the timeout configurable as what Yuwei has. Wdyt?
>>>
>>> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
>>> index 47b6c1f0fdbb..54625287ee5b 100644
>>> --- a/net/core/neighbour.c
>>> +++ b/net/core/neighbour.c
>>> @@ -1579,7 +1579,7 @@ static void neigh_managed_work(struct work_struct *work)
>>>           list_for_each_entry(neigh, &tbl->managed_list, managed_list)
>>>                   neigh_event_send_probe(neigh, NULL, false);
>>>           queue_delayed_work(system_power_efficient_wq, &tbl->managed_work,
>>> -                          NEIGH_VAR(&tbl->parms, DELAY_PROBE_TIME));
>>> +                          max(NEIGH_VAR(&tbl->parms, DELAY_PROBE_TIME), HZ));
>>>           write_unlock_bh(&tbl->lock);
>>>    }
>>
>> FWIW that was my reaction as well. Let's do that unless someone
>> disagrees.
> 
> I agree too, so there will be as following parts:
> 1) prevent misconfig by offering a minimum value
> 2) separate the params `INTERVAL_PROBE_TIME` as the probe interval for
> `MANAGED` neigh

Ok.

> 3) notify the change of `INTERVAL_PROBE_TIME` and set the driver poll interval
> according to `INTERVAL_PROBE_TIME` instead of `DELAY_PROBE_TIME`
> 
> I still have doubt about whether we need part 3, or if exist this scenario:
> - the NIC offloading the data plane.
> - the driver needs periodically poll the device for neighbours activity
> 
> May I ask for further explanation?

Well, but for that case we would need some in-tree driver users of managed neigh
first, and they can probably drive it according to their needs if they require a
notifier message. Are you saying you are panning to convert the mlx one over to
use managed neigh?

Thanks,
Daniel
