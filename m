Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD204D87BE
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 16:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233730AbiCNPJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 11:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233706AbiCNPJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 11:09:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7126B5F99
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 08:07:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E0BAB80E4D
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 15:07:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297DDC340E9;
        Mon, 14 Mar 2022 15:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647270469;
        bh=Rz2KuOESldOzbiiZdkOmgQGYYWtyMDKlvinTB7EuxwY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=LmMSq9YzoaH14GfvsuwFRGjCFoTr/wQ3ntvlFrvBBUqDMOVoyBOJ0ufivZW5Wdhb/
         DaM0rWllKrVBdShdQ4aPgf8fIfFGMM4Z9oHjyVglbe8xfYnnHphLtyn9eHiAK8JVRm
         tRz4e3fquv/CSdumNH/sA9coUl0+wLcBDDllk6xjIsWH7qAJ7lpTkHL4G0My7noqPf
         JHIX2tTnI1iBdSR0EqoleTO82+Wnk0buB1265P5hjepcC3sN7Jj4x5G+jJIsv9onHT
         0jgauxFJjarECswdcL+mF6+t5UFWl1SqdQ8d5i/JMLuuc8Z37LW28Pc1q3nX2VqmE7
         A5FXg70rCuRxg==
Message-ID: <22fe6d6c-d665-e4ee-9e16-04010b184a98@kernel.org>
Date:   Mon, 14 Mar 2022 09:07:48 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH v7 2/4] vdpa: Allow for printing negotiated features of a
 device
Content-Language: en-US
To:     Eli Cohen <elic@nvidia.com>, stephen@networkplumber.org,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        jasowang@redhat.com, si-wei.liu@oracle.com
Cc:     mst@redhat.com, lulu@redhat.com, parav@nvidia.com
References: <20220313171219.305089-1-elic@nvidia.com>
 <20220313171219.305089-3-elic@nvidia.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220313171219.305089-3-elic@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UPPERCASE_75_100 autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/13/22 11:12 AM, Eli Cohen wrote:
> @@ -385,6 +388,97 @@ static const char *parse_class(int num)
>  	return class ? class : "< unknown class >";
>  }
>  
> +static const char * const net_feature_strs[64] = {
> +	[VIRTIO_NET_F_CSUM] = "CSUM",
> +	[VIRTIO_NET_F_GUEST_CSUM] = "GUEST_CSUM",
> +	[VIRTIO_NET_F_CTRL_GUEST_OFFLOADS] = "CTRL_GUEST_OFFLOADS",
> +	[VIRTIO_NET_F_MTU] = "MTU",
> +	[VIRTIO_NET_F_MAC] = "MAC",
> +	[VIRTIO_NET_F_GUEST_TSO4] = "GUEST_TSO4",
> +	[VIRTIO_NET_F_GUEST_TSO6] = "GUEST_TSO6",
> +	[VIRTIO_NET_F_GUEST_ECN] = "GUEST_ECN",
> +	[VIRTIO_NET_F_GUEST_UFO] = "GUEST_UFO",
> +	[VIRTIO_NET_F_HOST_TSO4] = "HOST_TSO4",
> +	[VIRTIO_NET_F_HOST_TSO6] = "HOST_TSO6",
> +	[VIRTIO_NET_F_HOST_ECN] = "HOST_ECN",
> +	[VIRTIO_NET_F_HOST_UFO] = "HOST_UFO",
> +	[VIRTIO_NET_F_MRG_RXBUF] = "MRG_RXBUF",
> +	[VIRTIO_NET_F_STATUS] = "STATUS",
> +	[VIRTIO_NET_F_CTRL_VQ] = "CTRL_VQ",
> +	[VIRTIO_NET_F_CTRL_RX] = "CTRL_RX",
> +	[VIRTIO_NET_F_CTRL_VLAN] = "CTRL_VLAN",
> +	[VIRTIO_NET_F_CTRL_RX_EXTRA] = "CTRL_RX_EXTRA",
> +	[VIRTIO_NET_F_GUEST_ANNOUNCE] = "GUEST_ANNOUNCE",
> +	[VIRTIO_NET_F_MQ] = "MQ",
> +	[VIRTIO_F_NOTIFY_ON_EMPTY] = "NOTIFY_ON_EMPTY",
> +	[VIRTIO_NET_F_CTRL_MAC_ADDR] = "CTRL_MAC_ADDR",
> +	[VIRTIO_F_ANY_LAYOUT] = "ANY_LAYOUT",
> +	[VIRTIO_NET_F_RSC_EXT] = "RSC_EXT",
> +	[VIRTIO_NET_F_HASH_REPORT] = "HASH_REPORT",
> +	[VIRTIO_NET_F_RSS] = "RSS",
> +	[VIRTIO_NET_F_STANDBY] = "STANDBY",
> +	[VIRTIO_NET_F_SPEED_DUPLEX] = "SPEED_DUPLEX",

not very easy on the eyes. Please send a followup that column aligns the
strings. e.g.,

@@ -403,9 +403,9 @@ static const char *parse_class(int num)
 }

 static const char * const net_feature_strs[64] = {
-       [VIRTIO_NET_F_CSUM] = "CSUM",
-       [VIRTIO_NET_F_GUEST_CSUM] = "GUEST_CSUM",
-       [VIRTIO_NET_F_CTRL_GUEST_OFFLOADS] = "CTRL_GUEST_OFFLOADS",
+       [VIRTIO_NET_F_CSUM]                     = "CSUM",
+       [VIRTIO_NET_F_GUEST_CSUM]               = "GUEST_CSUM",
+       [VIRTIO_NET_F_CTRL_GUEST_OFFLOADS]      = "CTRL_GUEST_OFFLOADS",
...


> +};
> +
> +#define VIRTIO_F_IN_ORDER 35
> +#define VIRTIO_F_NOTIFICATION_DATA 38
> +#define VDPA_EXT_FEATURES_SZ (VIRTIO_TRANSPORT_F_END - \
> +			      VIRTIO_TRANSPORT_F_START + 1)
> +
> +static const char * const ext_feature_strs[VDPA_EXT_FEATURES_SZ] = {
> +	[VIRTIO_RING_F_INDIRECT_DESC - VIRTIO_TRANSPORT_F_START] = "RING_INDIRECT_DESC",
> +	[VIRTIO_RING_F_EVENT_IDX - VIRTIO_TRANSPORT_F_START] = "RING_EVENT_IDX",
> +	[VIRTIO_F_VERSION_1 - VIRTIO_TRANSPORT_F_START] = "VERSION_1",
> +	[VIRTIO_F_ACCESS_PLATFORM - VIRTIO_TRANSPORT_F_START] = "ACCESS_PLATFORM",
> +	[VIRTIO_F_RING_PACKED - VIRTIO_TRANSPORT_F_START] = "RING_PACKED",
> +	[VIRTIO_F_IN_ORDER - VIRTIO_TRANSPORT_F_START] = "IN_ORDER",
> +	[VIRTIO_F_ORDER_PLATFORM - VIRTIO_TRANSPORT_F_START] = "ORDER_PLATFORM",
> +	[VIRTIO_F_SR_IOV - VIRTIO_TRANSPORT_F_START] = "SR_IOV",
> +	[VIRTIO_F_NOTIFICATION_DATA - VIRTIO_TRANSPORT_F_START] = "NOTIFICATION_DATA",

and the entries here should be a macro to handle the
VIRTIO_TRANSPORT_F_START  offset with column aligned strings.


