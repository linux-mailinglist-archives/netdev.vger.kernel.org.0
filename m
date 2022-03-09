Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7DD4D2A57
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 09:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbiCIIIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 03:08:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiCIIIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 03:08:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 27ECD1A3AB
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 00:07:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646813269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2IXuEicy64jzYCxNamwmtmwVtyYt/lRqVjQKpT7Nv/M=;
        b=grzP69cmC51sQi/z4891lkLQggIaA45tMXG4hlk4x/IqX4LC5aK0nKoPnaauPgu/H1Xabz
        0AiHa9tLg0ge0YtYIrHCtnrQaOSnmLUmrkmcDYmWB4WStMPtMCUAAZD+cbPvwuEUJaJ40J
        eMvBxSI3LJ6FY/6PnrSe0/87HKcnHC0=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-664-n8gPm0GIMJOeV1CPAzNX9w-1; Wed, 09 Mar 2022 03:07:47 -0500
X-MC-Unique: n8gPm0GIMJOeV1CPAzNX9w-1
Received: by mail-pj1-f72.google.com with SMTP id lt6-20020a17090b354600b001bf5a121802so1142150pjb.1
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 00:07:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2IXuEicy64jzYCxNamwmtmwVtyYt/lRqVjQKpT7Nv/M=;
        b=e/z44ZV5gTSFJNR88cXTBso7ag6FY2rs7AaT/CSG1LK+Pt7q2HWGV4Es6Xegm2p6hL
         wb9gvnK57XRrk5V5MDWkKhUtRYl2L2wDTnRzF14U6sddza0I4flRui045st+KF/cI+xz
         1gWOwDVLA/YSaBWCDgt0FzSbQfKIazWSPW/d+nEBRbUDl3ei+A0mquSmuO9WFhDrADUZ
         MR+i77KrkFLM1FhBGFW5N8TiGLO7sCySbF8yRMKEMQd00SVQPp2aZt5ULz+Xl0abn6/I
         JiTcLnF1R1f4lb+ZmId2B03AZQ8jXJ9QrsrT5ROyC9KAIcCBXlD4L0AsIA6xSrOIxOXd
         45xw==
X-Gm-Message-State: AOAM533Kgzjulvfv+AyFdAHk6Yw5CfwBIjqV8MiaDHM8X35k0CvfnoNG
        lwo74jmRlQiN/+SfVTrtY7ALp7g4S+wpB4nZRlPeFnpSpuk/YgPr1irVvI0wXx6qYi94WX1p01J
        0+qhhjaqj//ADLVpB
X-Received: by 2002:a17:902:7895:b0:14b:6b63:b3fa with SMTP id q21-20020a170902789500b0014b6b63b3famr21356509pll.156.1646813266480;
        Wed, 09 Mar 2022 00:07:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw6DQIqLtQqTfMFPUpM5F+dRCjUh++/2gbXxGyBJdGCkQYoqOQWjpvpTenZNYBY0ODISfgXEQ==
X-Received: by 2002:a17:902:7895:b0:14b:6b63:b3fa with SMTP id q21-20020a170902789500b0014b6b63b3famr21356497pll.156.1646813266263;
        Wed, 09 Mar 2022 00:07:46 -0800 (PST)
Received: from [10.72.12.183] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w21-20020a056a0014d500b004f7261ad03esm1702804pfu.35.2022.03.09.00.07.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 00:07:45 -0800 (PST)
Message-ID: <1755f8e1-358b-b515-c51c-c2aa7bd0dd28@redhat.com>
Date:   Wed, 9 Mar 2022 16:07:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH v4 0/4] vdpa tool enhancements
Content-Language: en-US
To:     Eli Cohen <elic@nvidia.com>, stephen@networkplumber.org,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        dsahern@kernel.org
Cc:     mst@redhat.com, lulu@redhat.com, si-wei.liu@oracle.com,
        parav@nvidia.com
References: <20220302065444.138615-1-elic@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220302065444.138615-1-elic@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/3/2 下午2:54, Eli Cohen 写道:
> Hi Stephen,
>
> this is a resend of v3 which omitted you and netdev from the recepient
> list. I added a few "acked-by" and called it v4.
>
> The following four patch series enhances vdpa to show negotiated
> features for a vdpa device, max features for a management device and
> allows to configure max number of virtqueue pairs.
>
> v3->v4:
> Resend the patches with added "Acked-by" to the right mailing list.


Hello maintainers:

Any comment on the series? We want to have this for the next RHEL release.

Thanks


>
> Eli Cohen (4):
>    vdpa: Remove unsupported command line option
>    vdpa: Allow for printing negotiated features of a device
>    vdpa: Support for configuring max VQ pairs for a device
>    vdpa: Support reading device features
>
>   vdpa/include/uapi/linux/vdpa.h |   4 +
>   vdpa/vdpa.c                    | 151 +++++++++++++++++++++++++++++++--
>   2 files changed, 148 insertions(+), 7 deletions(-)
>

