Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 400B46BA65B
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 05:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbjCOEv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 00:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbjCOEv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 00:51:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B4B05C9F7
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 21:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678855868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PAc44bIyeunVqM7F9oum4Kb/lC4PewNL7pDwUADmf8I=;
        b=bHakFCK3P9Vnv8oEU3AdtQpR3ctaazsaZXaUg/8KaeD5I03bTfNjMQKg3WxNZRxBu05laq
        f1OeGVRcPpc7rBXcvcxNDZgghIGc9GLhmlt//pHw7/vcXZhCKF15rrz1mxDUrDqs73vS0R
        OaEltkJVZ8HqYsQksefs4e1ZCqite9c=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-282-GOi8DWuENUGshbO4Tn_Aig-1; Wed, 15 Mar 2023 00:51:06 -0400
X-MC-Unique: GOi8DWuENUGshbO4Tn_Aig-1
Received: by mail-pl1-f197.google.com with SMTP id t24-20020a1709028c9800b0019eaa064a51so9920646plo.10
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 21:51:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678855865;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PAc44bIyeunVqM7F9oum4Kb/lC4PewNL7pDwUADmf8I=;
        b=mLnkFcQ5M4ug+2lsj2WIubRycY4GvsfMlK8DvZ5QH1h5BxdW10QZtHUEEGPLluvaWe
         gDzRhZFRKq7Voi5ZY0V3WErtAhATw1ZcqU8tUuD/IXWcSWsxRts8JXm/pwDqu2dHSoyx
         ZtfChDXONDXl+i1gQ8RMSQSRWhUAjJ46sntMptSOAUaGdPK6QTGw97R3wNJ3+9PA2sQz
         OMt45mR7igOM5EOyj74rLy9pWON5ke3+J12F7adV+1KrJrNyYl2bcpMDejguXr1lT6o7
         RbiiYJ79aAFAqrVO3IaTap+EqYtcWqXcSo7PJstnyP1awFIxzo8XL0EZ5V91WiUMjBft
         LhKA==
X-Gm-Message-State: AO0yUKXmdrPHJzk8xtvJILnJsYci7o5m8KgxiqV/vEYVvUBqfCbp/wOC
        XjBzn3gzgnEm0+l3nanh1//Fn535ZS/WEooEqhElVXwYXtClzGMVCJijk63vwTQSj84VPkVFXT9
        W+7+9DTQY2QIvM0EJ
X-Received: by 2002:a05:6a20:160a:b0:cc:88af:12ab with SMTP id l10-20020a056a20160a00b000cc88af12abmr46431421pzj.28.1678855865471;
        Tue, 14 Mar 2023 21:51:05 -0700 (PDT)
X-Google-Smtp-Source: AK7set+nSocWLK/26+zU8BB7aj5/6EfcMGupuzmB02JjazwKDlIXCcdY2K6NOnUTCqz4CJ7oFY/GUQ==
X-Received: by 2002:a05:6a20:160a:b0:cc:88af:12ab with SMTP id l10-20020a056a20160a00b000cc88af12abmr46431406pzj.28.1678855865138;
        Tue, 14 Mar 2023 21:51:05 -0700 (PDT)
Received: from [10.72.12.84] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id u21-20020a62ed15000000b00593c1c5bd0esm2404326pfh.164.2023.03.14.21.51.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 21:51:04 -0700 (PDT)
Message-ID: <e8c01176-dc61-47de-ffab-4d328e3c60b9@redhat.com>
Date:   Wed, 15 Mar 2023 12:50:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v2 13/14] sfc: update vdpa device MAC address
Content-Language: en-US
To:     Gautam Dawar <gdawar@amd.com>, Gautam Dawar <gautam.dawar@amd.com>
Cc:     linux-net-drivers@amd.com, Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eperezma@redhat.com, harpreet.anand@amd.com, tanuj.kamde@amd.com,
        koushik.dutta@amd.com
References: <20230307113621.64153-1-gautam.dawar@amd.com>
 <20230307113621.64153-14-gautam.dawar@amd.com>
 <CACGkMEuY4KoiZKswjMDNfoeUTqUagXye-_qe-iP2JJq0schObQ@mail.gmail.com>
 <e563f5a5-2d1a-fbc9-be2d-986b050c6548@amd.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <e563f5a5-2d1a-fbc9-be2d-986b050c6548@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
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


在 2023/3/13 14:37, Gautam Dawar 写道:
> On 3/10/23 10:35, Jason Wang wrote:
>> Caution: This message originated from an External Source. Use proper 
>> caution when opening attachments, clicking links, or responding.
>>
>>
>> On Tue, Mar 7, 2023 at 7:38 PM Gautam Dawar <gautam.dawar@amd.com> 
>> wrote:
>>> As the VF MAC address can now be updated using `devlink port 
>>> function set`
>> What happens if we run this while the vpda is being used by a VM?
> IIUC, updating the MAC address using devlink interface requires 
> unbinding the device from driver and hence updating the MAC while vdpa 
> device is in-use won't be possible. It can only be done via control vq 
> VIRTIO_NET_CTRL_MAC_ADDR_SET command, when available.


Good to know that.


>>
>>> interface, fetch the vdpa device MAC address from the underlying VF 
>>> during
>>> vdpa device creation.
>>>
>>> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
>>> ---
>>>   drivers/net/ethernet/sfc/ef100_vdpa.c | 12 ++++++++++++
>>>   1 file changed, 12 insertions(+)
>>>
>>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c 
>>> b/drivers/net/ethernet/sfc/ef100_vdpa.c
>>> index 30ca4ab00175..32182a01f6a5 100644
>>> --- a/drivers/net/ethernet/sfc/ef100_vdpa.c
>>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
>>> @@ -272,6 +272,18 @@ static int get_net_config(struct ef100_vdpa_nic 
>>> *vdpa_nic)
>>>          vdpa_nic->net_config.max_virtqueue_pairs =
>>>                  cpu_to_efx_vdpa16(vdpa_nic, 
>>> vdpa_nic->max_queue_pairs);
>>>
>>> +       rc = ef100_get_mac_address(efx, vdpa_nic->mac_address,
>>> +                                  efx->client_id, true);
>>> +       if (rc) {
>>> +               dev_err(&vdpa_nic->vdpa_dev.dev,
>>> +                       "%s: Get MAC for vf:%u failed:%d\n", __func__,
>>> +                       vdpa_nic->vf_index, rc);
>>> +               return rc;
>>> +       }
>> Can this override what is provisioned by the userspace?
>
> No, this was carefully avoided by overwriting the userspace 
> provisioned MAC in ef100_vdpa_create():
>
>         rc = get_net_config(vdpa_nic);
>         if (rc)
>                 goto err_put_device;
>
>         if (mac) {
>                 ether_addr_copy(vdpa_nic->mac_address, mac);
>                 vdpa_nic->mac_configured = true;
>         }


Ah, I see.

Thanks


>
>>
>> Thanks
>>
>>
>>> +
>>> +       if (is_valid_ether_addr(vdpa_nic->mac_address))
>>> +               vdpa_nic->mac_configured = true;
>>> +
>>>          rc = efx_vdpa_get_mtu(efx, &mtu);
>>>          if (rc) {
>>>                  dev_err(&vdpa_nic->vdpa_dev.dev,
>>> -- 
>>> 2.30.1
>>>
>

