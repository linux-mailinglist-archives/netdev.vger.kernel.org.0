Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA7B6A1776
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 08:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbjBXHpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 02:45:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjBXHpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 02:45:10 -0500
Received: from out-35.mta0.migadu.com (out-35.mta0.migadu.com [91.218.175.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 782641815C
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 23:45:04 -0800 (PST)
Message-ID: <4aaf2a34-b3ad-0970-614f-edfc8244e746@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1677224702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1i4WS33mquNkNcChcjoQGOfw106LH345J9OGkWHW60U=;
        b=qtrfONqUMB5C2p1w282Z0iAG0HpqQSSCpNy64C13H1N5Q9gh/cZJQfBWitKxdVpz7MgYaW
        IdEGSMuAh/gCxTUXbzfowDWNRf90cb1X9XnVk2xy9jCr24/WZD589JXYkyQQW8Q3S1GUsj
        yoSzshX3WHkaDNxHHT69k2WVKJcf9Jc=
Date:   Thu, 23 Feb 2023 23:44:55 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next V3] xdp: bpf_xdp_metadata use EOPNOTSUPP for no
 driver support
Content-Language: en-US
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     brouer@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        martin.lau@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        alexandr.lobakin@intel.com, larysa.zaremba@intel.com,
        xdp-hints@xdp-project.net, Stanislav Fomichev <sdf@google.com>
References: <167673444093.2179692.14745621008776172374.stgit@firesoul>
 <CAKH8qBt-wgiFTjbNfuWXC+CNbnDbVPWuoJFO_H_=tc4e3BZGPA@mail.gmail.com>
 <d8c514c6-15bf-c2fd-11f9-23519cdc9177@linux.dev>
 <613bbdb0-e7b0-59df-f2ee-6c689b15fe41@redhat.com>
 <8bb53544-94f4-601b-24ad-96c6cc87cf50@linux.dev>
 <bff4d5eb-fe4d-786e-f41d-1c45f07a7282@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <bff4d5eb-fe4d-786e-f41d-1c45f07a7282@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/22/23 1:49 PM, Jesper Dangaard Brouer wrote:
> 
> On 21/02/2023 22.58, Martin KaFai Lau wrote:
>> On 2/21/23 12:39 PM, Jesper Dangaard Brouer wrote:
>>> For me this is more about the API we are giving the BPF-programmer.
>>>
>>> There can be natural cases why a driver doesn't provide any hardware
>>> info for a specific hint.  The RX-timestamp is a good practical example,
>>> as often only PTP packets will be timestamped by hardware.
>>>
>>> I can write a BPF-prog that create a stats-map for counting
>>> RX-timestamps, expecting to catch any PTP packets with timestamps.  The
>>> problem is my stats-map cannot record the difference of EOPNOTSUPP vs
>>> ENODATA.  Thus, the user of my RX-timestamps stats program can draw the
>>> wrong conclusion, that there are no packets with (PTP) timestamps, when
>>> this was actually a case of driver not implementing this.
>>>
>>> I hope this simple stats example make is clearer that the BPF-prog can
>>> make use of this info runtime.  It is simply a question of keeping these
>>> cases as separate return codes. Is that too much to ask for from an API?
>>
>> Instead of reserving an errno for this purpose, it can be decided at load time 
>> instead of keep calling a kfunc always returning the same dedicated errno. I 
>> still don't hear why xdp-features + bpf global const won't work.
>>
> 
> Sure, exposing this to xdp-features and combining this with a bpf global
> const is a cool idea, slightly extensive work for the BPF-programmer,
> but sure BPF is all about giving the BPF programmer flexibility.
> 
> I do feel it is orthogonal whether the API should return a consistent
> errno when the driver doesn't implement the kfunc.
> 
> I'm actually hoping in the future that we can achieve dead code
> elimination automatically without having to special case this.
> When we do Stanislav's BPF unroll tricks we get a constant e.g.
> EOPNOTSUPP when driver doesn't implement the kfunc.  This should allow
> the verifier to do deadcode elimination right?
> 
> For my stats example, where I want to count both packets with and
> without timestamps, but not miscount packets that actually had a
> timestamp, but my driver just doesn't support querying this.
> 
> Consider program-A:
> 
>   int err = bpf_xdp_metadata_rx_timestamp(ctx, &ts);
>   if (!err) {
>      ts_stats[HAVE_TS]++;
>   } else {
>      ts_stats[NO_TS_DATA]++;
>   }
> 
> Program-A clearly does the miscount issue. The const propagation and
> deadcode code elimination would work, but is still miscounts.
> Yes, program-A could be extended with the cool idea of xdp-feature
> detection that updates a prog const, for solving the issue.
> 
> Consider program-B:
> 
>   int err = bpf_xdp_metadata_rx_timestamp(ctx, &ts);
>   if (!err) {
>      ts_stats[HAVE_TS]++;
>   } else if (err == -ENODATA) {
>      ts_stats[NO_TS_DATA]++;
>   }
> 
> If I had a separate return, then I can avoid the miscount as demonstrate
> in program-B.  In this program the const propagation and deadcode
> elimination would *also* work and still avoid the miscounts.  It should
> elimination any updates to ts_stats map.
> 
> I do get the cool idea of bpf global const, but we will hopefully get
> this automatically when we can do BPF unroll.

I think the direction is to dual compile a kfunc to native code and bpf code and 
to get away from the manual unroll or hand written bpf insn. Not sure if the 
verifier can (and should) further check whether a compiled bpf subprog always 
returns a const scalar to optimize this particular case.

I think enough words have been exchanged on this subject. A few ways (eg. at 
load time) have been suggested to detect it without reserving an errno for an 
empty function. Beside, it is hard to miss when the stats is all one sided if 
the driver does not implement a xdp-hint. Quickly query the xdp-feature will 
confirm it. I assume ethtool will be able to check that soon also. It is what 
xdp-feature is for instead of reserving a run time value to detect if a driver 
has implemented each individual xdp feature.

May be a tie break vote is needed.
