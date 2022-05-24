Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFC35532AC5
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 15:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237526AbiEXNDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 09:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237521AbiEXNDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 09:03:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6E6BC6338A
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 06:03:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653397391;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VuA+hQIP5NuMWzKci8Ce7ATCFxGvl8XcBeLDZ4SQZrw=;
        b=Xb+D9eUA/cAvD2E4+VfGAFE004kxNmi85GWwlATNQZmtCYYwOPXk8a4/bUwftWi4sneb9B
        cnDALIKT9LGSoLXv7hHgolR3Fn3bv7jJG+nYCBrL+BO/SztBRQR6eulXA4OLic9DNQXDjR
        kTcDwRgzryvhIFgW3d20KKcKKTFkwjE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-207-dP4kBThZNhiDq9LPLOVzwQ-1; Tue, 24 May 2022 09:03:10 -0400
X-MC-Unique: dP4kBThZNhiDq9LPLOVzwQ-1
Received: by mail-wm1-f70.google.com with SMTP id m9-20020a05600c4f4900b0039746692dc2so3015074wmq.6
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 06:03:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=VuA+hQIP5NuMWzKci8Ce7ATCFxGvl8XcBeLDZ4SQZrw=;
        b=nLfRwcVneepysARSor4AAHzB6cP7KC4MP1BVX+xeRDfdEYUl7dNowZKUaKvrROOUoj
         rN1TnIx1h//K3QVL79CJCHwuIjPehc1YIJXGRraMJxZESrDrijcJ1dB/l+VVsD3Iydld
         NIN3OrLmBElASQeEHsfZrmXSwOLGx6VETf/AbXWi6u4Iemzv6RGJCAKR/Hmw5EaIc11w
         ewgZ61gPcWSTZTyYGwxJ2ksBFjsRxJiGOjxncvCyGNfhVtVXB2fDrqwDsu0KDpw/2a2K
         AOjTwkwX9lCvf6H2rIvJFX2y2UWKa4LofgZa2Ni96wfhHDZD+ZpW8zua9TjVF48F+c9B
         M9WA==
X-Gm-Message-State: AOAM532Ssou3L+6+Hi5wF03HOjyxUqsIbb6ZYKT1HgSRoEFXVnOe9h+2
        B1bF/W7pE91Y2hhjNUcrDLmsjR25wfQFfxOjEqFeFfbQMxFh2U3mfM7bCJQdNN+vJnVfeP1b0vL
        QdipJd+gyjvF52YPY
X-Received: by 2002:a05:6000:184d:b0:20f:e9a0:dad6 with SMTP id c13-20020a056000184d00b0020fe9a0dad6mr5473138wri.317.1653397388921;
        Tue, 24 May 2022 06:03:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy6FGiz36BIprlRrTIAV1mNT8gxPmWO8Z7EZuutiOcqaDrFguXdDtGyDfOJNR44VniSl70yKQ==
X-Received: by 2002:a05:6000:184d:b0:20f:e9a0:dad6 with SMTP id c13-20020a056000184d00b0020fe9a0dad6mr5473116wri.317.1653397388723;
        Tue, 24 May 2022 06:03:08 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-184.dyn.eolo.it. [146.241.112.184])
        by smtp.gmail.com with ESMTPSA id g17-20020adfbc91000000b0020e6c51f070sm12972975wrh.112.2022.05.24.06.03.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 06:03:08 -0700 (PDT)
Message-ID: <6dc4367dc75d3f7baf9f61e2691045066b3716e1.camel@redhat.com>
Subject: Re: [PATCH] r8152: Return true/false (not 1/0) from bool functions
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Abaci Robot <abaci@linux.alibaba.com>
Date:   Tue, 24 May 2022 15:03:07 +0200
In-Reply-To: <20220524093733.9537-1-jiapeng.chong@linux.alibaba.com>
References: <20220524093733.9537-1-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-05-24 at 17:37 +0800, Jiapeng Chong wrote:
> Return statements in functions returning bool should use true/false
> instead of 1/0.
> 
> Clean the following coccicheck warning:
> 
> ./drivers/net/usb/r8152.c:9579:10-11: WARNING: return of 0/1 in function
> 'rtl8152_supports_lenovo_macpassthru' with return type bool.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  drivers/net/usb/r8152.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index 7389d6ef8569..7b7704b4b500 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
> @@ -9576,15 +9576,15 @@ static bool rtl8152_supports_lenovo_macpassthru(struct usb_device *udev)
>  		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2:
>  		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN3:
>  		case DEVICE_ID_THINKPAD_USB_C_DONGLE:
> -			return 1;
> +			return true;
>  		}
>  	} else if (vendor_id == VENDOR_ID_REALTEK && parent_vendor_id == VENDOR_ID_LENOVO) {
>  		switch (product_id) {
>  		case 0x8153:
> -			return 1;
> +			return true;
>  		}
>  	}
> -	return 0;
> +	return false;
>  }
>  
>  static int rtl8152_probe(struct usb_interface *intf,

This looks like net-next material, and net-next is currently closed,
please resubmit in ~2weeks specifying the target tree in the subj.

Thanks

Paolo

