Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B77B6BAB0F
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 09:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbjCOItf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 04:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjCOItb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 04:49:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27ECF5B97
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 01:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678870122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MRi8RIBU+b35Md49h2XYjqzMHipH7fb+kqRpHB6ExEM=;
        b=HD6U0I6QITAZXgBzSYyrqAGAjqX6caYv5CmKv7shva4BzNwBjUH175/vBid5e/2WZFUXZY
        AlpBRCJEU3ZtvxaHpskvbkIjpwlSlK47xbMhRQ+bNsdFoxig1hz04l7eJ/mjXmu88YZPof
        e9xR1NVJdv1qVu8Nn5Iag8L6iGx3qds=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-124-iyLIBX2KPiOJAFjRWVXSSQ-1; Wed, 15 Mar 2023 04:48:41 -0400
X-MC-Unique: iyLIBX2KPiOJAFjRWVXSSQ-1
Received: by mail-wm1-f70.google.com with SMTP id o31-20020a05600c511f00b003ed2ed2acb5so688269wms.0
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 01:48:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678870120;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MRi8RIBU+b35Md49h2XYjqzMHipH7fb+kqRpHB6ExEM=;
        b=LaE6YuTQFUThLop5wI+wZ5ujy3ejVpMFOWcELE+Usl+w1R7Qwc0mRsgjlQpesSQmX9
         FMo+PQeIKkhQIoscN4SRMLrL2c377XkSRd6UorGNxNvORhnUpbTPNonc5XW2lpEYZClI
         glOsBsB4Wz9jvFvnZJ1psJrLifBBEtxaMypv0vI/FjNZbiZgugYbORdOjO1p3fgq4XhD
         uSZTxrejrUdu4r59NTW/xdcXMysCWi91upPsYdsiUi6eT9EUzwrziZHHqz5CtGP0oHm2
         c4XlRB3yHlynzEODGEtU3OFmN7KgmI3WnpT7TpI+u15P4FSu4Z4g5IonC2/qyVWKT6gT
         BisQ==
X-Gm-Message-State: AO0yUKUSHNv6dvbGHHkdYtucY7URvJXFc5rIj3ezCC4c8zg8+j3/NUMC
        fP2oxtv+ONizVz+L5L6R2D3VpQsmQzvBQ+6fG23atmxv/I+3ymIVVyofYY39E8jNDElFFhVATFA
        kQr8VBDO+Ygg6BeIg
X-Received: by 2002:a05:600c:45cb:b0:3ed:32bf:c254 with SMTP id s11-20020a05600c45cb00b003ed32bfc254mr1382150wmo.12.1678870120038;
        Wed, 15 Mar 2023 01:48:40 -0700 (PDT)
X-Google-Smtp-Source: AK7set9yaZt+uge8qRM89dSJjYPqWHwMOHZ9uk5q+xGVbn3xRUVi1ZbxrMdmQC+nB9leWZ7Pfa1lDw==
X-Received: by 2002:a05:600c:45cb:b0:3ed:32bf:c254 with SMTP id s11-20020a05600c45cb00b003ed32bfc254mr1382138wmo.12.1678870119729;
        Wed, 15 Mar 2023 01:48:39 -0700 (PDT)
Received: from [192.168.1.163] ([188.65.88.100])
        by smtp.gmail.com with ESMTPSA id r6-20020a05600c458600b003ebff290a52sm1221089wmo.28.2023.03.15.01.48.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 01:48:39 -0700 (PDT)
Message-ID: <698e750d-6e56-7fa3-99f4-e363c8fee90a@redhat.com>
Date:   Wed, 15 Mar 2023 09:48:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH RESEND net-next v4 3/4] sfc: support unicast PTP
Content-Language: en-US
To:     Edward Cree <ecree.xilinx@gmail.com>, habetsm.xilinx@gmail.com,
        richardcochran@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Yalin Li <yalli@redhat.com>
References: <20230314100925.12040-1-ihuguet@redhat.com>
 <20230314100925.12040-4-ihuguet@redhat.com>
 <71e22d1e-336a-8e6a-9b36-708f07c632b2@gmail.com>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
In-Reply-To: <71e22d1e-336a-8e6a-9b36-708f07c632b2@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



El 14/3/23 a las 17:55, Edward Cree escribió:
> On 14/03/2023 10:09, Íñigo Huguet wrote:
>> When sending a PTP event packet, add the correct filters that will make
>> that future incoming unicast PTP event packets will be timestamped.
>> The unicast address for the filter is gotten from the outgoing skb
>> before sending it.
>>
>> Until now they were not timestamped because only filters that match with
>> the PTP multicast addressed were being configured into the NIC for the
>> PTP special channel. Packets received through different channels are not
>> timestamped, getting "received SYNC without timestamp" error in ptp4l.
>>
>> Note that the inserted filters are never removed unless the NIC is stopped
>> or reconfigured, so efx_ptp_stop is called. Removal of old filters will
>> be handled by the next patch.
>>
>> Additionally, cleanup a bit efx_ptp_xmit_skb_mc to use the reverse xmas
>> tree convention and remove an unnecessary assignment to rc variable in
>> void function.
>>
>> Reported-by: Yalin Li <yalli@redhat.com>
>> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
> 
> Few nits below, but still
> Acked-by: Edward Cree <ecree.xilinx@gmail.com>
> 
>> +static bool efx_ptp_filter_exists(struct list_head *ptp_list,
>> +				  struct efx_filter_spec *spec)
>> +{
>> +	struct efx_ptp_rxfilter *rxfilter;
>> +
>> +	list_for_each_entry(rxfilter, ptp_list, list) {
>> +		if (rxfilter->ether_type == spec->ether_type &&
>> +		    rxfilter->loc_port == spec->loc_port &&
>> +		    !memcmp(rxfilter->loc_host, spec->loc_host, sizeof(spec->loc_host)))
>> +			return true;
>> +	}
>> +
>> +	return false;
>> +}
> 
> Technically this could be more efficient if we used an rhashtable
>  instead of a list, but I guess we don't expect the list to grow
>  very long.

Yes, I expect the list to be short, so I thought better not to optimize prematurely. However, after giving to it a second thought, maybe the list can grow more if the NIC is acting as unicast PTP master? I mainly considered the slave case...

I've never used rhashlist, it would be a good learning exercise. How do you see if I submit that as an optimization in a future patch?
 
>> +static int efx_ptp_insert_unicast_filter(struct efx_nic *efx,
>> +					 struct sk_buff *skb)
>> +{
>> +	struct efx_ptp_data *ptp = efx->ptp_data;
>> +	int rc;
>> +
>> +	if (!efx_ptp_valid_unicast_event_pkt(skb))
>> +		return -EINVAL;
>> +
>> +	if (skb->protocol == htons(ETH_P_IP)) {
>> +		__be32 addr = ip_hdr(skb)->saddr;
>> +
>> +		rc = efx_ptp_insert_ipv4_filter(efx, &ptp->rxfilters_ucast,
>> +						addr, PTP_EVENT_PORT);
>> +		if (rc < 0)
>> +			goto fail;
>> +
>> +		rc = efx_ptp_insert_ipv4_filter(efx, &ptp->rxfilters_ucast,
>> +						addr, PTP_GENERAL_PORT);
>> +		if (rc < 0)
>> +			goto fail;
>> +	} else if (efx_ptp_use_mac_tx_timestamps(efx)) {
>> +		/* IPv6 PTP only supported by devices with MAC hw timestamp */
>> +		struct in6_addr *addr = &ipv6_hdr(skb)->saddr;
>> +
>> +		rc = efx_ptp_insert_ipv6_filter(efx, &ptp->rxfilters_ucast,
>> +						addr, PTP_EVENT_PORT);
>> +		if (rc < 0)
>> +			goto fail;
>> +
>> +		rc = efx_ptp_insert_ipv6_filter(efx, &ptp->rxfilters_ucast,
>> +						addr, PTP_GENERAL_PORT);
>> +		if (rc < 0)
>> +			goto fail;
>> +	} else {
>> +		return -EOPNOTSUPP;
>> +	}
>> +
>> +	return 0;
>> +
>> +fail:
>> +	efx_ptp_remove_filters(efx, &ptp->rxfilters_ucast);
>> +	return rc;
>> +}
> 
> Why does failing to insert one filter mean we need to remove *all*
>  the unicast filters we have?  (I'm not even sure it's necessary
>  to remove the new EVENT filter if the GENERAL filter fails.)

Well, my reasoning was that it shouldn't fail in a first place. If it does, it's something very weird. Instead of implementing more complex logic to try checking if the current state is valid or not, just remove all and try to install them again the next time. If it fails again, probably the system is not in a very good state.

