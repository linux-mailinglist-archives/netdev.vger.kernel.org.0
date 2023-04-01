Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 971556D32A7
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 18:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbjDAQr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 12:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjDAQr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 12:47:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9FA2C15F
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 09:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680367633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LBpaj6qPaiWPsqZ1uUbFmrrkbOrpiff0SRgLWvVlle4=;
        b=ErXAVjxX1xhOW/sAuUNk46YfrDSAB9QH7LVz2CqHDleRtpvltp4CYP3xgvtklIUbiR15nD
        w7ZYSQVMXLq0O6ax6hNKX13h2dK01sak+Kn3x33nx6cSiQpmff0P/kI3/XIReq21irO2Jx
        8GOhDM+E5c2iP1o4uIUHzAzewbD7oXk=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-392-R7jpj7vYNuywTodYjrw8wA-1; Sat, 01 Apr 2023 12:47:10 -0400
X-MC-Unique: R7jpj7vYNuywTodYjrw8wA-1
Received: by mail-lf1-f70.google.com with SMTP id h16-20020a0565123c9000b004e83f2f56e2so10005645lfv.22
        for <netdev@vger.kernel.org>; Sat, 01 Apr 2023 09:47:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680367629;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LBpaj6qPaiWPsqZ1uUbFmrrkbOrpiff0SRgLWvVlle4=;
        b=GvvfWzFdBEVm1bfWNOx4ea6MNW2Ht7TKhkgaGSjt/TMMA2093UFj9tHpOi3300+Om7
         pyIEQF0ZgRIk1HOWb1gxU6nI1IzTB8/6rfvgUPmCDcIqqof6HfT+7xMQ4AAn5LxmR6YC
         b3FXJ7yq6Npwf3aRQIxYVHXsELQHAuWQg/jxKlrjIps8af4audYaYSTZEufKqXakv5Os
         GfRDt2mU1EEr5GB56maxGchBsOsj1Kb4O0VTMUjDMrzvKWk9wNtrMI51rfh7ZqFmc8xV
         vZk7oTXdGxD8q9JJchxQHnsUaOnFrTSeXQr9H2P+wqHoudJDqOBlVMtIrAnVAGm4h75W
         q5Uw==
X-Gm-Message-State: AAQBX9dj3pk/ZTs+UOD1DP+xIg04BkaN2CVwO3dtd/sbsd3e7mJIHso0
        MCMBN34GbE8vrCeFNbh/jbkRlPmD+WiAFyn+OEp7/XIuJFIQ5SrQ5hzWL9PG5hn5C/si863NdzF
        vhaP0qBNszb5pMlWW
X-Received: by 2002:a2e:6e03:0:b0:299:aa20:22a0 with SMTP id j3-20020a2e6e03000000b00299aa2022a0mr9388786ljc.53.1680367629399;
        Sat, 01 Apr 2023 09:47:09 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZeSpF555yFlSRJ624wPZzgJmZWz4p4qwCgGBnis2x24ag2kBhUEet5FQWdzvm7DiW1qPj20Q==
X-Received: by 2002:a2e:6e03:0:b0:299:aa20:22a0 with SMTP id j3-20020a2e6e03000000b00299aa2022a0mr9388764ljc.53.1680367629089;
        Sat, 01 Apr 2023 09:47:09 -0700 (PDT)
Received: from [192.168.42.100] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id y17-20020a2eb011000000b002a5f554d263sm887063ljk.46.2023.04.01.09.47.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Apr 2023 09:47:08 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <d4b3a22a-c815-a337-29b1-737efd9a7494@redhat.com>
Date:   Sat, 1 Apr 2023 18:47:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, martin.lau@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexandr.lobakin@intel.com,
        larysa.zaremba@intel.com, xdp-hints@xdp-project.net,
        anthony.l.nguyen@intel.com, yoong.siang.song@intel.com,
        boon.leong.ong@intel.com, intel-wired-lan@lists.osuosl.org,
        pabeni@redhat.com, jesse.brandeburg@intel.com, kuba@kernel.org,
        edumazet@google.com, john.fastabend@gmail.com, hawk@kernel.org,
        davem@davemloft.net, tariqt@nvidia.com
Subject: Re: [PATCH bpf V5 0/5] XDP-hints: API change for RX-hash kfunc
 bpf_xdp_metadata_rx_hash
Content-Language: en-US
To:     bpf@vger.kernel.org, Stanislav Fomichev <sdf@google.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
References: <168028882260.4030852.1100965689789226162.stgit@firesoul>
In-Reply-To: <168028882260.4030852.1100965689789226162.stgit@firesoul>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Why have this patchset[1] been marked "Changes Requested" ?

Notice: The BPF test_progs are failing on "xdp_do_redirect", but that is
not related to this patchset as it already happens on a clean bpf-tree.


  [1] 
https://patchwork.kernel.org/project/netdevbpf/list/?series=735957&state=%2A


On 31/03/2023 20.54, Jesper Dangaard Brouer wrote:
> Current API for bpf_xdp_metadata_rx_hash() returns the raw RSS hash value,
> but doesn't provide information on the RSS hash type (part of 6.3-rc).
> 
> This patchset proposal is to change the function call signature via adding
> a pointer value argument for providing the RSS hash type.
> 
> ---
> V5:
>   - Fixes for checkpatch.pl
>   - Change function signature for all xmo_rx_hash calls in patch1
> 
> Jesper Dangaard Brouer (5):
>        xdp: rss hash types representation
>        mlx5: bpf_xdp_metadata_rx_hash add xdp rss hash type
>        veth: bpf_xdp_metadata_rx_hash add xdp rss hash type
>        mlx4: bpf_xdp_metadata_rx_hash add xdp rss hash type
>        selftests/bpf: Adjust bpf_xdp_metadata_rx_hash for new arg
> 
> 
>   drivers/net/ethernet/mellanox/mlx4/en_rx.c    | 22 ++++++-
>   drivers/net/ethernet/mellanox/mlx4/mlx4_en.h  |  3 +-
>   .../net/ethernet/mellanox/mlx5/core/en/xdp.c  | 63 ++++++++++++++++++-
>   drivers/net/veth.c                            | 10 ++-
>   include/linux/mlx5/device.h                   | 14 ++++-
>   include/linux/netdevice.h                     |  3 +-
>   include/net/xdp.h                             | 47 ++++++++++++++
>   net/core/xdp.c                                | 10 ++-
>   .../selftests/bpf/prog_tests/xdp_metadata.c   |  2 +
>   .../selftests/bpf/progs/xdp_hw_metadata.c     | 14 +++--
>   .../selftests/bpf/progs/xdp_metadata.c        |  6 +-
>   .../selftests/bpf/progs/xdp_metadata2.c       |  7 ++-
>   tools/testing/selftests/bpf/xdp_hw_metadata.c |  2 +-
>   tools/testing/selftests/bpf/xdp_metadata.h    |  1 +
>   14 files changed, 180 insertions(+), 24 deletions(-)
> 
> --
> 

