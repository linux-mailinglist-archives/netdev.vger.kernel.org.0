Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DAE8572D74
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 07:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234315AbiGMFgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 01:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234429AbiGMFgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 01:36:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E12FEE191E
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 22:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657690292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Jy/furYsDwrNodw4Nu9ZNCwDIYPw0par1/S1mi+rDBY=;
        b=MwxfP2sGe33h4XcEDi1pfaRW6xRYIZstMeCLuvUTi7K8cLG68/y63evDG/CRVAs+6zjoQZ
        tk7Ayl41HfEOV9yIQozzc+zSMJ9YEgQbrTmCITNo2wPkG7YWlYMiX/V1nGbkTmTgmvm9z7
        hZweGlCPB2ncUXIG2jIHifvaV1eZ0zA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-221-v2A7YML5OGSnMPohUmzyAw-1; Wed, 13 Jul 2022 01:31:31 -0400
X-MC-Unique: v2A7YML5OGSnMPohUmzyAw-1
Received: by mail-wr1-f70.google.com with SMTP id n7-20020adfc607000000b0021a37d8f93aso1808365wrg.21
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 22:31:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Jy/furYsDwrNodw4Nu9ZNCwDIYPw0par1/S1mi+rDBY=;
        b=AHAvkLEV4PuIl18zW9aXiCQG1RuUcWCoWHfdejzBYb+mRVdJYyiYy98Kng9DP9qZxz
         qGMwnoL94fsyZIiWrShdaY84FuEyvwhTlCj6WR5Dl/LmnCzWLq4ijCRArBgM9fylilkx
         FhCeQH78cSBooltp0FRcVfWS2Aq4yxhr173H1usnkfXVRB7/APflzkTlRT/XopPnEFdK
         F6/WiVhw4WZyA666vpqG4yUbfcojt0iS0v55DV1rAXaneM5bxtipJSgwN5oT/xR18bug
         uLg1mExSpZrAX/AL7JDNnIdtAQl++nYJom3K9hViPPXJ7af2jT40m5D9FFoc0cN7p9lq
         Q88A==
X-Gm-Message-State: AJIora+EjxSq5l5DbgsllMkbfoAfo2Oc8CNs2yRguEDDUrDNaBdBr152
        /4oe8uQtViWeAh/Botp7IlmNzaald4gZE2wX5MuU88br/IPjqLdUGCem3BbPhTNzTdvVVtPERVI
        4z6UqlwVP8vz+G7lk
X-Received: by 2002:a5d:5d88:0:b0:21d:9ba5:d2c5 with SMTP id ci8-20020a5d5d88000000b0021d9ba5d2c5mr1297540wrb.717.1657690289919;
        Tue, 12 Jul 2022 22:31:29 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vYcXqU7V7hxYQX03o3NQqUyIgbpwEqM9ueULOltT2Jq1yq1UPTP2N90oNm6slLYomX9gDv7w==
X-Received: by 2002:a5d:5d88:0:b0:21d:9ba5:d2c5 with SMTP id ci8-20020a5d5d88000000b0021d9ba5d2c5mr1297524wrb.717.1657690289660;
        Tue, 12 Jul 2022 22:31:29 -0700 (PDT)
Received: from redhat.com ([2.52.24.42])
        by smtp.gmail.com with ESMTPSA id r18-20020a05600c35d200b003a2d0f0ccaesm927840wmq.34.2022.07.12.22.31.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 22:31:29 -0700 (PDT)
Date:   Wed, 13 Jul 2022 01:31:26 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, parav@nvidia.com, xieyongji@bytedance.com,
        gautam.dawar@amd.com
Subject: Re: [PATCH V3 1/6] vDPA/ifcvf: get_config_size should return a value
 no greater than dev implementation
Message-ID: <20220713012944-mutt-send-email-mst@kernel.org>
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-2-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220701132826.8132-2-lingshan.zhu@intel.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 01, 2022 at 09:28:21PM +0800, Zhu Lingshan wrote:
> ifcvf_get_config_size() should return a virtio device type specific value,
> however the ret_value should not be greater than the onboard size of
> the device implementation. E.g., for virtio_net, config_size should be
> the minimum value of sizeof(struct virtio_net_config) and the onboard
> cap size.
> 
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>  drivers/vdpa/ifcvf/ifcvf_base.c | 13 +++++++++++--
>  drivers/vdpa/ifcvf/ifcvf_base.h |  2 ++
>  2 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
> index 48c4dadb0c7c..fb957b57941e 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.c
> @@ -128,6 +128,7 @@ int ifcvf_init_hw(struct ifcvf_hw *hw, struct pci_dev *pdev)
>  			break;
>  		case VIRTIO_PCI_CAP_DEVICE_CFG:
>  			hw->dev_cfg = get_cap_addr(hw, &cap);
> +			hw->cap_dev_config_size = le32_to_cpu(cap.length);
>  			IFCVF_DBG(pdev, "hw->dev_cfg = %p\n", hw->dev_cfg);
>  			break;
>  		}
> @@ -233,15 +234,23 @@ int ifcvf_verify_min_features(struct ifcvf_hw *hw, u64 features)
>  u32 ifcvf_get_config_size(struct ifcvf_hw *hw)
>  {
>  	struct ifcvf_adapter *adapter;
> +	u32 net_config_size = sizeof(struct virtio_net_config);
> +	u32 blk_config_size = sizeof(struct virtio_blk_config);
> +	u32 cap_size = hw->cap_dev_config_size;
>  	u32 config_size;
>  
>  	adapter = vf_to_adapter(hw);
> +	/* If the onboard device config space size is greater than
> +	 * the size of struct virtio_net/blk_config, only the spec
> +	 * implementing contents size is returned, this is very
> +	 * unlikely, defensive programming.
> +	 */
>  	switch (hw->dev_type) {
>  	case VIRTIO_ID_NET:
> -		config_size = sizeof(struct virtio_net_config);
> +		config_size = cap_size >= net_config_size ? net_config_size : cap_size;
>  		break;
>  	case VIRTIO_ID_BLOCK:
> -		config_size = sizeof(struct virtio_blk_config);
> +		config_size = cap_size >= blk_config_size ? blk_config_size : cap_size;
>  		break;
>  	default:
>  		config_size = 0;

There's a min macro for this.

> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
> index 115b61f4924b..f5563f665cc6 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
> @@ -87,6 +87,8 @@ struct ifcvf_hw {
>  	int config_irq;
>  	int vqs_reused_irq;
>  	u16 nr_vring;
> +	/* VIRTIO_PCI_CAP_DEVICE_CFG size */
> +	u32 cap_dev_config_size;
>  };
>  
>  struct ifcvf_adapter {
> -- 
> 2.31.1

