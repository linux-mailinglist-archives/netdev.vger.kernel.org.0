Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7E9681109
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 15:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237158AbjA3OJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 09:09:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237153AbjA3OJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 09:09:43 -0500
Received: from mx05lb.world4you.com (mx05lb.world4you.com [81.19.149.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A0A23802F;
        Mon, 30 Jan 2023 06:09:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        Message-ID:References:In-Reply-To:Subject:Cc:To:From:Date:MIME-Version:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dX5joPSrXHt51h5qeLC3Xq8xdcevddD07C/9Rn/Wh2A=; b=m46iI2brqSGyfUUajUeA7OZa3t
        vcYvSFW2JLP/W4gBxZjJX9vF13bZh+kZTCC+XSSxAUr73cW9EuaJuiRFnXdafpbjZuH/BctPcwJnC
        C0Nxl72vj+dhI4aFem34n+hOI/pGP5lUrqDsrjZXzMMUbl10Wxf88529acWRhPIgF2Po=;
Received: from [81.19.149.42] (helo=webmail.world4you.com)
        by mx05lb.world4you.com with esmtpa (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pMUql-0002na-QU; Mon, 30 Jan 2023 15:09:35 +0100
MIME-Version: 1.0
Date:   Mon, 30 Jan 2023 15:09:35 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, pabeni@redhat.com,
        edumazet@google.com, toke@redhat.com, memxor@gmail.com,
        alardam@gmail.com, saeedm@nvidia.com, anthony.l.nguyen@intel.com,
        gospo@broadcom.com, vladimir.oltean@nxp.com, nbd@nbd.name,
        john@phrozen.org, leon@kernel.org, simon.horman@corigine.com,
        aelior@marvell.com, christophe.jaillet@wanadoo.fr,
        ecree.xilinx@gmail.com, mst@redhat.com, bjorn@kernel.org,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        intel-wired-lan@lists.osuosl.org, lorenzo.bianconi@redhat.com,
        martin.lau@linux.dev
Subject: Re: [PATCH v2 bpf-next 2/8] drivers: net: turn on XDP features
In-Reply-To: <Y9ZvA7+RMwbNlFoy@lore-desk>
References: <cover.1674606193.git.lorenzo@kernel.org>
 <c1171111f8af76da11331277b1e4a930c10f3c30.1674606197.git.lorenzo@kernel.org>
 <28eedfd5-4444-112b-bfbc-1c7682385c88@engleder-embedded.com>
 <Y9ZvA7+RMwbNlFoy@lore-desk>
User-Agent: World4You Webmail
Message-ID: <6e2e5b8f5735fc3243dea3a050399e34@engleder-embedded.com>
X-Sender: gerhard@engleder-embedded.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.01.2023 14:05, Lorenzo Bianconi wrote:
>> On 25.01.23 01:33, Lorenzo Bianconi wrote:
>> > From: Marek Majtyka <alardam@gmail.com>
>> >
>> > A summary of the flags being set for various drivers is given below.
>> > Note that XDP_F_REDIRECT_TARGET and XDP_F_FRAG_TARGET are features
>> > that can be turned off and on at runtime. This means that these flags
>> > may be set and unset under RTNL lock protection by the driver. Hence,
>> > READ_ONCE must be used by code loading the flag value.
>> >
>> > Also, these flags are not used for synchronization against the availability
>> > of XDP resources on a device. It is merely a hint, and hence the read
>> > may race with the actual teardown of XDP resources on the device. This
>> > may change in the future, e.g. operations taking a reference on the XDP
>> > resources of the driver, and in turn inhibiting turning off this flag.
>> > However, for now, it can only be used as a hint to check whether device
>> > supports becoming a redirection target.
>> >
>> > Turn 'hw-offload' feature flag on for:
>> >   - netronome (nfp)
>> >   - netdevsim.
>> >
>> > Turn 'native' and 'zerocopy' features flags on for:
>> >   - intel (i40e, ice, ixgbe, igc)
>> >   - mellanox (mlx5).
>> >   - stmmac
>> >
>> > Turn 'native' features flags on for:
>> >   - amazon (ena)
>> >   - broadcom (bnxt)
>> >   - freescale (dpaa, dpaa2, enetc)
>> >   - funeth
>> >   - intel (igb)
>> >   - marvell (mvneta, mvpp2, octeontx2)
>> >   - mellanox (mlx4)
>> >   - qlogic (qede)
>> >   - sfc
>> >   - socionext (netsec)
>> >   - ti (cpsw)
>> >   - tap
>> >   - veth
>> >   - xen
>> >   - virtio_net.
>> >
>> > Turn 'basic' (tx, pass, aborted and drop) features flags on for:
>> >   - netronome (nfp)
>> >   - cavium (thunder)
>> >   - hyperv.
>> >
>> > Turn 'redirect_target' feature flag on for:
>> >   - amanzon (ena)
>> >   - broadcom (bnxt)
>> >   - freescale (dpaa, dpaa2)
>> >   - intel (i40e, ice, igb, ixgbe)
>> >   - ti (cpsw)
>> >   - marvell (mvneta, mvpp2)
>> >   - sfc
>> >   - socionext (netsec)
>> >   - qlogic (qede)
>> >   - mellanox (mlx5)
>> >   - tap
>> >   - veth
>> >   - virtio_net
>> >   - xen
>> 
>> XDP support for tsnep was merged to net-next last week. So this driver
>> cannot get XDP feature support in bpf-next as it is not there 
>> currently.
>> Should I add these flags with a fix afterwards? Or would net-next be 
>> the
>> better target for this patch series?
> 
> bpf-next has been rebased on top of net-next so we can add tsnep 
> support to the
> series. Do you think the patch below is fine?
> 
> Regards,
> Lorenzo
> 
> diff --git a/drivers/net/ethernet/engleder/tsnep_main.c
> b/drivers/net/ethernet/engleder/tsnep_main.c
> index c3cf427a9409..6982aaa928b5 100644
> --- a/drivers/net/ethernet/engleder/tsnep_main.c
> +++ b/drivers/net/ethernet/engleder/tsnep_main.c
> @@ -1926,6 +1926,10 @@ static int tsnep_probe(struct platform_device 
> *pdev)
>  	netdev->features = NETIF_F_SG;
>  	netdev->hw_features = netdev->features | NETIF_F_LOOPBACK;
> 
> +	netdev->xdp_features = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT 
> |
> +			       NETDEV_XDP_ACT_NDO_XMIT |
> +			       NETDEV_XDP_ACT_NDO_XMIT_SG;
> +

Looks good. Thanks!

Gerhard
