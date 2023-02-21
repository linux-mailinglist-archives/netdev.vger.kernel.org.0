Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26ABA69E9CA
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 22:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjBUV6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 16:58:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjBUV6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 16:58:36 -0500
Received: from out-7.mta1.migadu.com (out-7.mta1.migadu.com [IPv6:2001:41d0:203:375::7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A8EC265A6
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 13:58:28 -0800 (PST)
Message-ID: <8bb53544-94f4-601b-24ad-96c6cc87cf50@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1677016706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KnZLwilDruK9CFWQQ3g9Fih43fAYFFYjJwf6kfAGURA=;
        b=nxA44YjL8YBprnKDZPlylyXNTxRGYvpQAuA1gLKZeH01Q7l+12C7/TbxtocNglAanC/l4i
        ya0wRGwUPWQZ7pycpnSyyjJYvr4FlqXZ49Ovl36lddo3ACl5C+WE8+QsKg+xEN8EmNI1o0
        TvNF1rtf3PwcPzb/EHabHEmOgYQdZBs=
Date:   Tue, 21 Feb 2023 13:58:22 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next V3] xdp: bpf_xdp_metadata use EOPNOTSUPP for no
 driver support
Content-Language: en-US
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Stanislav Fomichev <sdf@google.com>
Cc:     brouer@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        martin.lau@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        alexandr.lobakin@intel.com, larysa.zaremba@intel.com,
        xdp-hints@xdp-project.net
References: <167673444093.2179692.14745621008776172374.stgit@firesoul>
 <CAKH8qBt-wgiFTjbNfuWXC+CNbnDbVPWuoJFO_H_=tc4e3BZGPA@mail.gmail.com>
 <d8c514c6-15bf-c2fd-11f9-23519cdc9177@linux.dev>
 <613bbdb0-e7b0-59df-f2ee-6c689b15fe41@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <613bbdb0-e7b0-59df-f2ee-6c689b15fe41@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/21/23 12:39 PM, Jesper Dangaard Brouer wrote:
> For me this is more about the API we are giving the BPF-programmer.
> 
> There can be natural cases why a driver doesn't provide any hardware
> info for a specific hint.  The RX-timestamp is a good practical example,
> as often only PTP packets will be timestamped by hardware.
> 
> I can write a BPF-prog that create a stats-map for counting
> RX-timestamps, expecting to catch any PTP packets with timestamps.  The
> problem is my stats-map cannot record the difference of EOPNOTSUPP vs
> ENODATA.  Thus, the user of my RX-timestamps stats program can draw the
> wrong conclusion, that there are no packets with (PTP) timestamps, when
> this was actually a case of driver not implementing this.
> 
> I hope this simple stats example make is clearer that the BPF-prog can
> make use of this info runtime.  It is simply a question of keeping these
> cases as separate return codes. Is that too much to ask for from an API?

Instead of reserving an errno for this purpose, it can be decided at load time 
instead of keep calling a kfunc always returning the same dedicated errno. I 
still don't hear why xdp-features + bpf global const won't work.
