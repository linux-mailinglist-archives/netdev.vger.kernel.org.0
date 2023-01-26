Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD95867D53C
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 20:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbjAZTR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 14:17:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjAZTR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 14:17:56 -0500
X-Greylist: delayed 506 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 26 Jan 2023 11:17:53 PST
Received: from mx23lb.world4you.com (mx23lb.world4you.com [81.19.149.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1879B758;
        Thu, 26 Jan 2023 11:17:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:References:Cc:To:Subject:From:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=iI5nfSnVTsfzi2TlCeq92ugJV3Nwoh2wrjkWIusgImY=; b=G0ue/G7tl16TgJINez8QJijHtJ
        uKd+cqh62/qlUUSdzeAmHvdxGaeG0iUG8xoHEk9E2speQJ1GP/06dlwCf6vz2pEPhiF9hNYldKpOl
        vL0OhK295xa99LumXda6C2PudttuqpphE4gBWgutC0oI7M7whHtnblynlaGErkcOMDtU=;
Received: from [88.117.49.184] (helo=[10.0.0.160])
        by mx23lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pL7cf-0006HX-88; Thu, 26 Jan 2023 20:09:21 +0100
Message-ID: <28eedfd5-4444-112b-bfbc-1c7682385c88@engleder-embedded.com>
Date:   Thu, 26 Jan 2023 20:09:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: Re: [PATCH v2 bpf-next 2/8] drivers: net: turn on XDP features
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, pabeni@redhat.com, edumazet@google.com,
        toke@redhat.com, memxor@gmail.com, alardam@gmail.com,
        saeedm@nvidia.com, anthony.l.nguyen@intel.com, gospo@broadcom.com,
        vladimir.oltean@nxp.com, nbd@nbd.name, john@phrozen.org,
        leon@kernel.org, simon.horman@corigine.com, aelior@marvell.com,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        mst@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, intel-wired-lan@lists.osuosl.org,
        lorenzo.bianconi@redhat.com, martin.lau@linux.dev
References: <cover.1674606193.git.lorenzo@kernel.org>
 <c1171111f8af76da11331277b1e4a930c10f3c30.1674606197.git.lorenzo@kernel.org>
Content-Language: en-US
In-Reply-To: <c1171111f8af76da11331277b1e4a930c10f3c30.1674606197.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.01.23 01:33, Lorenzo Bianconi wrote:
> From: Marek Majtyka <alardam@gmail.com>
> 
> A summary of the flags being set for various drivers is given below.
> Note that XDP_F_REDIRECT_TARGET and XDP_F_FRAG_TARGET are features
> that can be turned off and on at runtime. This means that these flags
> may be set and unset under RTNL lock protection by the driver. Hence,
> READ_ONCE must be used by code loading the flag value.
> 
> Also, these flags are not used for synchronization against the availability
> of XDP resources on a device. It is merely a hint, and hence the read
> may race with the actual teardown of XDP resources on the device. This
> may change in the future, e.g. operations taking a reference on the XDP
> resources of the driver, and in turn inhibiting turning off this flag.
> However, for now, it can only be used as a hint to check whether device
> supports becoming a redirection target.
> 
> Turn 'hw-offload' feature flag on for:
>   - netronome (nfp)
>   - netdevsim.
> 
> Turn 'native' and 'zerocopy' features flags on for:
>   - intel (i40e, ice, ixgbe, igc)
>   - mellanox (mlx5).
>   - stmmac
> 
> Turn 'native' features flags on for:
>   - amazon (ena)
>   - broadcom (bnxt)
>   - freescale (dpaa, dpaa2, enetc)
>   - funeth
>   - intel (igb)
>   - marvell (mvneta, mvpp2, octeontx2)
>   - mellanox (mlx4)
>   - qlogic (qede)
>   - sfc
>   - socionext (netsec)
>   - ti (cpsw)
>   - tap
>   - veth
>   - xen
>   - virtio_net.
> 
> Turn 'basic' (tx, pass, aborted and drop) features flags on for:
>   - netronome (nfp)
>   - cavium (thunder)
>   - hyperv.
> 
> Turn 'redirect_target' feature flag on for:
>   - amanzon (ena)
>   - broadcom (bnxt)
>   - freescale (dpaa, dpaa2)
>   - intel (i40e, ice, igb, ixgbe)
>   - ti (cpsw)
>   - marvell (mvneta, mvpp2)
>   - sfc
>   - socionext (netsec)
>   - qlogic (qede)
>   - mellanox (mlx5)
>   - tap
>   - veth
>   - virtio_net
>   - xen

XDP support for tsnep was merged to net-next last week. So this driver
cannot get XDP feature support in bpf-next as it is not there currently.
Should I add these flags with a fix afterwards? Or would net-next be the
better target for this patch series?

Gerhard
