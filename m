Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB60F5066D9
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 10:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349921AbiDSIZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 04:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237934AbiDSIZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 04:25:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1937D3299A
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 01:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650356558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZWDOS/1Ow1szRofZ19KsY9FziDIJpjbqEX9U6FABTUg=;
        b=N8kyFLu1pzQaLrsUQ/NIWxDXt7+7IHcJKTyPa9TxfEkfM2XDRTJN6LJ+K2jqZGz752gk8A
        Zhj6TaCJMeCKWVDVevVnLpm/WmD9X8VBKOoM4fTNhUHuD4/t3C1pcs2Ns8lsfW+ylPPgrX
        hS5Mvcr5NkNIazgvzfnWnCukvO+WuE4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-302-nfuaExMXOLKpB7whQUQ87w-1; Tue, 19 Apr 2022 04:22:37 -0400
X-MC-Unique: nfuaExMXOLKpB7whQUQ87w-1
Received: by mail-wr1-f69.google.com with SMTP id v21-20020adfa1d5000000b0020a80b3b107so721406wrv.0
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 01:22:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ZWDOS/1Ow1szRofZ19KsY9FziDIJpjbqEX9U6FABTUg=;
        b=lBT6m3I6iNwlU0iW6CDTupdFquYft17FDcRlDFSDy83i9BFAgZjnop/vETRclfAedh
         G+wDndEp+O3RknBHBLxmkEHGMdCd+XnJXW33wnAQ/cBvocSXaoIf7soCkRrtDvXj1I5b
         GoUbrdavq5ZE+mqLLhl2wb1VrO3xsGekbQcG0rhor77wx/IsJ/XTCVdiZ06OF3aUkDc/
         sUUa5bLqPib6ErD32jFA+K77RR7YLF0jyj2Wd9fSI+Ghj1ivOPBaMX8xvnrR2pzdArF2
         jnq+zeW5M5hmoQvibylAN9/35cEhxqZ7B906Nm7m31zo5WeC2Wnvrx7QapQUOlseAtuV
         OL+w==
X-Gm-Message-State: AOAM532A9nKW7UYr9NDTW9PMCrEqo0FRXIcmxHO1H2F1Lw0D0efgdrmh
        DAhZi9okBUiHbPFZWVdQnNkcw+A8JUzfW+gUpkv6KX39LDOF3MmOePLpnrAIKb4NriQzefmwdMh
        +qdxnJUDUjd9mvyIo
X-Received: by 2002:a5d:5967:0:b0:207:9b63:b4bc with SMTP id e39-20020a5d5967000000b002079b63b4bcmr10926015wri.264.1650356555602;
        Tue, 19 Apr 2022 01:22:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzAXXqId+1x4Z/96tEL2pXEJOgdPlUzW/K8mA+xvVLYN+B5pxCtcDXye6K+xV19A90WKl4ZNA==
X-Received: by 2002:a5d:5967:0:b0:207:9b63:b4bc with SMTP id e39-20020a5d5967000000b002079b63b4bcmr10926000wri.264.1650356555305;
        Tue, 19 Apr 2022 01:22:35 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-96-237.dyn.eolo.it. [146.241.96.237])
        by smtp.gmail.com with ESMTPSA id l22-20020a05600c4f1600b00392889d04c4sm10217311wmq.23.2022.04.19.01.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 01:22:35 -0700 (PDT)
Message-ID: <daf868a94da8ce7e4ee7e304db54cfee71b0174a.camel@redhat.com>
Subject: Re: [PATCH] net: ethernet: enetc: Add missing put_device() call
From:   Paolo Abeni <pabeni@redhat.com>
To:     Yihao Han <hanyihao@vivo.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kernel@vivo.com
Date:   Tue, 19 Apr 2022 10:22:34 +0200
In-Reply-To: <20220415133633.87127-1-hanyihao@vivo.com>
References: <20220415133633.87127-1-hanyihao@vivo.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-04-15 at 06:36 -0700, Yihao Han wrote:
> A coccicheck run provided information like the following.
> 
> drivers/net/ethernet/freescale/enetc/enetc_pf.c:1180:1-7:
> ERROR: missing put_device; call of_find_device_by_node
> on line 1174, but without a corresponding object release
> within this function.
> 
> Generated by: scripts/coccinelle/free/put_device.cocci
> 
> Signed-off-by: Yihao Han <hanyihao@vivo.com>
> ---
>  drivers/net/ethernet/freescale/enetc/enetc_pf.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> index a0c75c717073..d6e18afda69a 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> @@ -1177,6 +1177,7 @@ static int enetc_pf_register_with_ierb(struct pci_dev *pdev)
>  	if (!ierb_pdev)
>  		return -EPROBE_DEFER;
>  
> +	put_device(ierb_pdev);

put_device() gets a 'struct device' argument, e.g. ierb_pdev->dev.

Have a look at the patchwork checks they catch this sort of issue.

>  	return enetc_ierb_register_pf(ierb_pdev, pdev);

enetc_ierb_register_pf() uses/dereference ierb_pdev, you need to
release the device reference after the above call, or you may hit UaF,
I guess.

Thanks,

Paolo

