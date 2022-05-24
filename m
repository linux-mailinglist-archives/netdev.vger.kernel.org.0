Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 500DF532D91
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 17:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234056AbiEXPdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 11:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbiEXPdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 11:33:12 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 172A157144
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 08:33:11 -0700 (PDT)
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1ntWWn-0005Ie-SM; Tue, 24 May 2022 17:32:57 +0200
Received: from [2a02:168:f656:0:d16a:7287:ccf0:4fff] (helo=localhost.localdomain)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1ntWWn-0004fk-Kl; Tue, 24 May 2022 17:32:57 +0200
Subject: Re: [PATCH net-next v2] net, neigh: introduce interval_probe_time for
 periodic probe
To:     Paolo Abeni <pabeni@redhat.com>, Yuwei Wang <wangyuweihx@gmail.com>
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>, roopa@nvidia.com,
        dsahern@kernel.org, =?UTF-8?B?56em6L+q?= <qindi@staff.weibo.com>,
        netdev@vger.kernel.org
References: <20220522031739.87399-1-wangyuweihx@gmail.com>
 <b5cf7fac361752d925f663d9a9b0b8415084f7d3.camel@redhat.com>
 <CANmJ_FP0CxSVksjvNsNjpQO8w+S3_10byQSCpt1ifQ6HeURUmA@mail.gmail.com>
 <cf3188eba7e529e4f112f6a752158f38e22f4851.camel@redhat.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <797c3c53-ce1b-9f60-e253-cda615788f4a@iogearbox.net>
Date:   Tue, 24 May 2022 17:32:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <cf3188eba7e529e4f112f6a752158f38e22f4851.camel@redhat.com>
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

On 5/24/22 12:41 PM, Paolo Abeni wrote:
> On Tue, 2022-05-24 at 17:38 +0800, Yuwei Wang wrote:
>> On Tue, 24 May 2022 at 16:38, Paolo Abeni <pabeni@redhat.com> wrote:
>>>
>>> On Sun, 2022-05-22 at 03:17 +0000, Yuwei Wang wrote:
>>>
>>>> diff --git a/include/net/netevent.h b/include/net/netevent.h
>>>> index 4107016c3bb4..121df77d653e 100644
>>>> --- a/include/net/netevent.h
>>>> +++ b/include/net/netevent.h
>>>> @@ -26,6 +26,7 @@ enum netevent_notif_type {
>>>>        NETEVENT_NEIGH_UPDATE = 1, /* arg is struct neighbour ptr */
>>>>        NETEVENT_REDIRECT,         /* arg is struct netevent_redirect ptr */
>>>>        NETEVENT_DELAY_PROBE_TIME_UPDATE, /* arg is struct neigh_parms ptr */
>>>> +     NETEVENT_INTERVAL_PROBE_TIME_UPDATE, /* arg is struct neigh_parms ptr */
>>>
>>> Are you sure we need to notify the drivers about this parameter change?
>>> The host will periodically resolve the neighbours, and that should work
>>> regardless of the NIC offload. I think we don't need additional
>>> notifications.
>>>
>>
>> `mlxsw_sp_router_netevent_event` in
>> drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.c and
>> `mlx5e_rep_netevent_event` in
>> drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c still
>> use `NETEVENT_DELAY_PROBE_TIME_UPDATE` to receive the update event of
>> `DELAY_PROBE_TIME` as the probe interval.
>>
>> I think we are supposed to replace `NETEVENT_DELAY_PROBE_TIME_UPDATE` with
>> `NETEVENT_INTERVAL_PROBE_TIME_UPDATE` after this patch is merged.
> 
> AFAICS the event notification is to let neigh_timer_handler() cope
> properly with NIC offloading the data plane.
> 
> In such scenario packets (forwarded by the NIC) don't reach the host,
> and neigh->confirmed can be untouched for a long time fooling
> neigh_timer_handler() into a timeout.
> 
> The event notification allows the NIC to perform the correct actions to
> avoid such timeout.
> 
> In case of MANAGED neighbour, the host is periodically sending probe
> request, and both req/replies should not be offloaded. AFAICS no action
> is expected from the NIC to cope with INTERVAL_PROBE_TIME changes.

Right, maybe we could just split this into two: 1) prevent misconfig (see
below), and 2) make the timeout configurable as what Yuwei has. Wdyt?

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 47b6c1f0fdbb..54625287ee5b 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1579,7 +1579,7 @@ static void neigh_managed_work(struct work_struct *work)
         list_for_each_entry(neigh, &tbl->managed_list, managed_list)
                 neigh_event_send_probe(neigh, NULL, false);
         queue_delayed_work(system_power_efficient_wq, &tbl->managed_work,
-                          NEIGH_VAR(&tbl->parms, DELAY_PROBE_TIME));
+                          max(NEIGH_VAR(&tbl->parms, DELAY_PROBE_TIME), HZ));
         write_unlock_bh(&tbl->lock);
  }

Thanks,
Daniel
