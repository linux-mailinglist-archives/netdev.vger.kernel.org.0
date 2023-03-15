Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3442E6BA688
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 06:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbjCOFM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 01:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCOFM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 01:12:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3961E5D256
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 22:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678857098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jTWqQfH2jSclsQKQPaFec1o38miRjxcnCEr069EGPqA=;
        b=gqqczEI7+zn92ScN9OjLUpf6kLwQz9BgvYWq+7/2xvtTAxXe1qQxsCG549fPUnoXRLh9IT
        NfC4UBoIRr8tJgqn6qh4E5//quEu4KfxmqmnD+6PUHxZzmNuhe7V+Vyy7ZakLfjEsSZ5K5
        3aJdDtOzsx0kg/Y6L/LHWWeSyHwCQJM=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-201-QGnk2IZ_PdCfa3CV465atA-1; Wed, 15 Mar 2023 01:11:37 -0400
X-MC-Unique: QGnk2IZ_PdCfa3CV465atA-1
Received: by mail-pj1-f69.google.com with SMTP id t2-20020a17090a4e4200b0023d27ab43b3so401295pjl.7
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 22:11:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678857096;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jTWqQfH2jSclsQKQPaFec1o38miRjxcnCEr069EGPqA=;
        b=hNMJYB/aZ70D5b0Tyf/SIYuHUvh5zWFrrMlcHaj60/1EDo9CqJXNaok0PM1Dg740CS
         T3m9YI/bFurwbJWVOR8zTErPYKUe8EZPU8a57ik7MaV0MLqn5RwpC9uBPZcbNi170nlO
         4dhHxUJUNQkcgJbMefRI0Upv21TdbuVASGUwyycMKasyQ0g+h5GFsCG0/djyfHyz4XzR
         mjLJP43s/qL55Tpn3d2uPWGDGLjMw2s4YoGfLFaXj27+FpFD7LTrQ8Hs9zZwQ/ogWaSO
         KtTLHrXWXa5A6qiQF/DZ7HOkvziYtZa7T8akBcZCYBRMIsiq03K8mCg1b5VehHsFGxpT
         PDEQ==
X-Gm-Message-State: AO0yUKXzxzmijjf810F48kXh5GRt0x37f9tw8tgMgKZwYvWkK3EOAPIu
        v4uiZXbK7ZX6lntywN+GY4k6V4DntDyxMtlyXTBXmncrkQLZZK9vLLr56QUmQDk+DE9tVw7vUCe
        ibwdZkOkpVHrXtzWO
X-Received: by 2002:a17:903:1389:b0:19a:e96a:58b3 with SMTP id jx9-20020a170903138900b0019ae96a58b3mr1289224plb.22.1678857096178;
        Tue, 14 Mar 2023 22:11:36 -0700 (PDT)
X-Google-Smtp-Source: AK7set9vzLgqqDLumGkAJ6rLHtB3EUu7fIcjX4yeWCXfnK660iCK8xgSOLHGp33SXUSs5VD1la/41Q==
X-Received: by 2002:a17:903:1389:b0:19a:e96a:58b3 with SMTP id jx9-20020a170903138900b0019ae96a58b3mr1289203plb.22.1678857095826;
        Tue, 14 Mar 2023 22:11:35 -0700 (PDT)
Received: from [10.72.12.84] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id g3-20020a170902740300b0019a8530c063sm2580750pll.102.2023.03.14.22.11.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 22:11:35 -0700 (PDT)
Message-ID: <071329fe-7215-235c-06b7-f17bf69d872b@redhat.com>
Date:   Wed, 15 Mar 2023 13:11:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v2 01/14] sfc: add function personality support
 for EF100 devices
Content-Language: en-US
To:     Gautam Dawar <gautam.dawar@amd.com>, linux-net-drivers@amd.com,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eperezma@redhat.com, harpreet.anand@amd.com, tanuj.kamde@amd.com,
        koushik.dutta@amd.com
References: <20230307113621.64153-1-gautam.dawar@amd.com>
 <20230307113621.64153-2-gautam.dawar@amd.com>
 <CACGkMEubKv-CGgTdTbt=Ja=pbazXT3nOGY9f_VtRwrOsmf8-rw@mail.gmail.com>
 <ZA8OBEDECFI4grXG@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <ZA8OBEDECFI4grXG@gmail.com>
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


在 2023/3/13 19:50, Martin Habets 写道:
> On Fri, Mar 10, 2023 at 01:04:14PM +0800, Jason Wang wrote:
>> On Tue, Mar 7, 2023 at 7:36 PM Gautam Dawar <gautam.dawar@amd.com> wrote:
>>> A function personality defines the location and semantics of
>>> registers in the BAR. EF100 NICs allow different personalities
>>> of a PCIe function and changing it at run-time. A total of three
>>> function personalities are defined as of now: EF100, vDPA and
>>> None with EF100 being the default.
>>> For now, vDPA net devices can be created on a EF100 virtual
>>> function and the VF personality will be changed to vDPA in the
>>> process.
>>>
>>> Co-developed-by: Martin Habets <habetsm.xilinx@gmail.com>
>>> Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
>>> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
>>> ---
>>>   drivers/net/ethernet/sfc/ef100.c     |  6 +-
>>>   drivers/net/ethernet/sfc/ef100_nic.c | 98 +++++++++++++++++++++++++++-
>>>   drivers/net/ethernet/sfc/ef100_nic.h | 11 ++++
>>>   3 files changed, 111 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/sfc/ef100.c b/drivers/net/ethernet/sfc/ef100.c
>>> index 71aab3d0480f..c1c69783db7b 100644
>>> --- a/drivers/net/ethernet/sfc/ef100.c
>>> +++ b/drivers/net/ethernet/sfc/ef100.c
>>> @@ -429,8 +429,7 @@ static void ef100_pci_remove(struct pci_dev *pci_dev)
>>>          if (!efx)
>>>                  return;
>>>
>>> -       probe_data = container_of(efx, struct efx_probe_data, efx);
>>> -       ef100_remove_netdev(probe_data);
>>> +       efx_ef100_set_bar_config(efx, EF100_BAR_CONFIG_NONE);
>>>   #ifdef CONFIG_SFC_SRIOV
>>>          efx_fini_struct_tc(efx);
>>>   #endif
>>> @@ -443,6 +442,7 @@ static void ef100_pci_remove(struct pci_dev *pci_dev)
>>>          pci_disable_pcie_error_reporting(pci_dev);
>>>
>>>          pci_set_drvdata(pci_dev, NULL);
>>> +       probe_data = container_of(efx, struct efx_probe_data, efx);
>>>          efx_fini_struct(efx);
>>>          kfree(probe_data);
>>>   };
>>> @@ -508,7 +508,7 @@ static int ef100_pci_probe(struct pci_dev *pci_dev,
>>>                  goto fail;
>>>
>>>          efx->state = STATE_PROBED;
>>> -       rc = ef100_probe_netdev(probe_data);
>>> +       rc = efx_ef100_set_bar_config(efx, EF100_BAR_CONFIG_EF100);
>>>          if (rc)
>>>                  goto fail;
>>>
>>> diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
>>> index 4dc643b0d2db..8cbe5e0f4bdf 100644
>>> --- a/drivers/net/ethernet/sfc/ef100_nic.c
>>> +++ b/drivers/net/ethernet/sfc/ef100_nic.c
>>> @@ -772,6 +772,99 @@ static int efx_ef100_get_base_mport(struct efx_nic *efx)
>>>          return 0;
>>>   }
>>>
>>> +/* BAR configuration.
>>> + * To change BAR configuration, tear down the current configuration (which
>>> + * leaves the hardware in the PROBED state), and then initialise the new
>>> + * BAR state.
>>> + */
>>> +struct ef100_bar_config_ops {
>>> +       int (*init)(struct efx_probe_data *probe_data);
>>> +       void (*fini)(struct efx_probe_data *probe_data);
>>> +};
>>> +
>>> +static const struct ef100_bar_config_ops bar_config_ops[] = {
>>> +       [EF100_BAR_CONFIG_EF100] = {
>>> +               .init = ef100_probe_netdev,
>>> +               .fini = ef100_remove_netdev
>>> +       },
>>> +#ifdef CONFIG_SFC_VDPA
>>> +       [EF100_BAR_CONFIG_VDPA] = {
>>> +               .init = NULL,
>>> +               .fini = NULL
>>> +       },
>>> +#endif
>>> +       [EF100_BAR_CONFIG_NONE] = {
>>> +               .init = NULL,
>>> +               .fini = NULL
>>> +       },
>>> +};
>> This looks more like a mini bus implementation. I wonder if we can
>> reuse an auxiliary bus here which is more user friendly for management
>> tools.
> When we were in the design phase of vDPA for EF100 it was still called
> virtbus, and the virtbus discussion was in full swing at that time.
> We could not afford to add risk to the project by depending on it, as
> it might not have been merged at all.


Right.


> If we were doing the same design now I would definitely consider using
> the auxiliary bus.
>
> Martin


But it's not late to do the change now. Auxiliary bus has been used by a 
lot of devices (even with vDPA device). The change looks not too 
complicated.

This looks more scalable and convenient for management layer.

Thanks


