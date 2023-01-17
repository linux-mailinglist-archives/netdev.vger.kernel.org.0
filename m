Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 047FA66D77C
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 09:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235928AbjAQIFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 03:05:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235756AbjAQIFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 03:05:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22901D91B
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 00:04:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673942698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ci2wR72FXU0ZDMra4YH4HsWlppM1rMdiwQgaYnzSGC8=;
        b=VFUM9v2Fgq5AG424K8TMM5xqdgUJrS3y0RsMQKJTwLReXEEKCc8puDJAc2ksgWfu//orCS
        KLtuTbM1XiHqQgdQ5rPwIKfdwsNg3Ga8FzPl7kp/S9efsFPOrHskHShCDU2ewSJZmWLH4s
        VQiaVyUaPBNW6An/6lB10K1ooL0KNUk=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-500-OPnqoZoDPOuU_S2sMtJM6g-1; Tue, 17 Jan 2023 03:04:57 -0500
X-MC-Unique: OPnqoZoDPOuU_S2sMtJM6g-1
Received: by mail-qk1-f198.google.com with SMTP id bp6-20020a05620a458600b006ffd3762e78so22402260qkb.13
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 00:04:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ci2wR72FXU0ZDMra4YH4HsWlppM1rMdiwQgaYnzSGC8=;
        b=KlHK3fY0Bi1/P7TVrjf5/xdDf/z3abEGepXFEgQrmPKOUoOAVtT/Lsx/Xfo/Pn+2ka
         TMDRuV/KPY5RENV/gLv0JsTmKjLYWtMUm8vCFH6R/wcB+yOcj8TKvEc94JLIaHQPilz8
         vaou/VH9gHaOQtGmIhOYJPujJ0hX4LgALOLhOl3tIltbmAGHbvEtaeo4/v4pG9uR4aiY
         3vIzXGwYmDxwyqXBEW69kBPzomaIYc0tfRg+Ng2JtrARAWui7c+pMwpS+4bhwAOM7oJR
         SdOMP5ZX/VQcEaWWjYOL1Y8gVF410NB/7nu1lpJCKTTkNfS20tQPqtvan++h63TBf7AA
         +4aA==
X-Gm-Message-State: AFqh2kqp/13lU9skV/qrXXWkxIiqOpUoO6Pndp8BC4iutf+EBo5Gjq1s
        J9oJc24zSxGWsgJIqYbrxThmylihak6JADEsf7LosGbm+gT+1qak91XKXaEgBFvIvI25I6Ekha6
        8UGxYa2O1WE1TQnNY
X-Received: by 2002:ac8:754f:0:b0:3b6:2ed3:9de3 with SMTP id b15-20020ac8754f000000b003b62ed39de3mr2418603qtr.17.1673942696810;
        Tue, 17 Jan 2023 00:04:56 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuMqP1xLYyHOY78o2Ncqj+0ns5K5aATtEXufGzH3j87xE98AXYXe+zyQxn7UK0mkR5sVyhRGw==
X-Received: by 2002:ac8:754f:0:b0:3b6:2ed3:9de3 with SMTP id b15-20020ac8754f000000b003b62ed39de3mr2418578qtr.17.1673942696519;
        Tue, 17 Jan 2023 00:04:56 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-115-179.dyn.eolo.it. [146.241.115.179])
        by smtp.gmail.com with ESMTPSA id f8-20020a05620a408800b0070543181468sm20082613qko.57.2023.01.17.00.04.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 00:04:56 -0800 (PST)
Message-ID: <504c2c6ba951859cbd007cfd441dde7de1a8f479.camel@redhat.com>
Subject: Re: [PATCH net-next 2/2] net: hns3: add vf fault process in hns3 ras
From:   Paolo Abeni <pabeni@redhat.com>
To:     Hao Lan <lanhao@huawei.com>, kuba@kernel.org,
        Leon Romanovsky <leon@kernel.org>
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        edumazet@google.com, richardcochran@gmail.com,
        shenjian15@huawei.com, wangjie125@huawei.com,
        netdev@vger.kernel.org, davem@davemloft.net
Date:   Tue, 17 Jan 2023 09:04:52 +0100
In-Reply-To: <20230113020829.48451-3-lanhao@huawei.com>
References: <20230113020829.48451-1-lanhao@huawei.com>
         <20230113020829.48451-3-lanhao@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Fri, 2023-01-13 at 10:08 +0800, Hao Lan wrote:
[...]

> +static void hclge_get_vf_fault_bitmap(struct hclge_desc *desc,
> +				      unsigned long *bitmap)
> +{
> +#define HCLGE_FIR_FAULT_BYTES	24
> +#define HCLGE_SEC_FAULT_BYTES	8
> +
> +	u8 *buff;
> +
> +	memcpy(bitmap, desc[0].data, HCLGE_FIR_FAULT_BYTES);
> +	buff =3D (u8 *)bitmap + HCLGE_FIR_FAULT_BYTES;
> +	memcpy(buff, desc[1].data, HCLGE_SEC_FAULT_BYTES);
> +}

The above works under the assumption that:

	HCLGE_FIR_FAULT_BYTES + HCLGE_SEC_FAULT_BYTES =3D=3D BITS_TO_BYTES(HCLGE_V=
PORT_NUM)

I think it's better to enforce such condition at build time with a
BUILD_BUG_ON(), to avoid future issues.

Also I think Leon still deserve a reply to one of his questions,
specifically: What will happen (at recovery time) with driver bound to
this VF?

Thanks!

Paolo

