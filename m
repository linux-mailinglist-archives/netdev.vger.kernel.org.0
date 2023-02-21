Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC5C669E7FD
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 20:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbjBUTED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 14:04:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbjBUTEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 14:04:02 -0500
Received: from out-40.mta1.migadu.com (out-40.mta1.migadu.com [IPv6:2001:41d0:203:375::28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6DA02710
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 11:04:00 -0800 (PST)
Message-ID: <d8c514c6-15bf-c2fd-11f9-23519cdc9177@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1677006238;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fHZ9uFeGd1/sPkvqg90pH/bhVbOnjEvOk51cW9TJEMw=;
        b=uyKlIPAeUQHKi4b2oNKrhj6HdBBAlXco3IByyMOZl4wXZR8dsxwxwiHGBFh9R0207ki0Y1
        KylNQV5Crh9hVjUcZKZovfjJ/m8EeNcTe5/Bl6Fywwk78wZaTUR0QdDCvliy25kjv8XO/T
        fVRRQZSDAeXSf7HENmjKQuZ77I1Pb7U=
Date:   Tue, 21 Feb 2023 11:03:52 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next V3] xdp: bpf_xdp_metadata use EOPNOTSUPP for no
 driver support
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, martin.lau@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexandr.lobakin@intel.com,
        larysa.zaremba@intel.com, xdp-hints@xdp-project.net
References: <167673444093.2179692.14745621008776172374.stgit@firesoul>
 <CAKH8qBt-wgiFTjbNfuWXC+CNbnDbVPWuoJFO_H_=tc4e3BZGPA@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <CAKH8qBt-wgiFTjbNfuWXC+CNbnDbVPWuoJFO_H_=tc4e3BZGPA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/21/23 9:13 AM, Stanislav Fomichev wrote:
> On Sat, Feb 18, 2023 at 7:34 AM Jesper Dangaard Brouer
> <brouer@redhat.com> wrote:
>>
>> When driver doesn't implement a bpf_xdp_metadata kfunc the default
>> implementation returns EOPNOTSUPP, which indicate device driver doesn't
>> implement this kfunc.
>>
>> Currently many drivers also return EOPNOTSUPP when the hint isn't
>> available. Instead change drivers to return ENODATA in these cases.
>> There can be natural cases why a driver doesn't provide any hardware
>> info for a specific hint, even on a frame to frame basis (e.g. PTP).
>> Lets keep these cases as separate return codes.

> Long term probably still makes sense to export this info via xdp-features?
> Not sure how long we can 100% ensure EOPNOTSUPP vs ENODATA convention :-)

I am also not sure if it makes the xdp-hints adoption easier for other drivers 
by enforcing ENODATA or what other return values a driver should or should not 
return while EOPNOTSUPP is a more common errno to use. May be the driver experts 
can prove me wrong here.

iiuc, it is for debugging if the bpf prog has been patched with the driver's xdp 
kfunc. Others have suggested method like dumping the bpf prog insn. It could 
also trace the driver xdp kfunc and see if it is actually called. Why these 
won't work?

Beside, it is more like a load time decision which should not need a runtime 
return error value to decide. eg. With xdp-features, the bpf prog can check a 
global const which can be set based on the query result from xdp-features. It 
will then be dead code removed by verifier. This could also handle the older 
kernel that does not have xdp-metadata support (ie. missing 
bpf_xdp_metadata_rx_{timestamp,hash}).

