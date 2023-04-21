Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0DAA6EA8A8
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 12:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbjDUKyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 06:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbjDUKyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 06:54:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606554C0E
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 03:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682074395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UQTtJKG76znlN/1Zi0auyShcmAYFDpdbxiSvi5v0L+o=;
        b=ZnOrIL3ps+JKfjDDmpG/2tSx2/9ml+8eIGJ2jLem1BlIe9V89rBCZlXe3yyYUWfJ0QQqTP
        hkQg8FAqrCLbKUDSXeXVQczBHpnEvtg5GSIMnx3l8vECaIskGgS4Rw33fpu5I4wfCd7h8H
        gxWli8Pfby3X5ty86nuyBkMOB/UVzjI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-665-xsM4_0BlOAi6WrqBSqYZOw-1; Fri, 21 Apr 2023 06:53:13 -0400
X-MC-Unique: xsM4_0BlOAi6WrqBSqYZOw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f16ef3be6eso9706535e9.3
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 03:53:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682074392; x=1684666392;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UQTtJKG76znlN/1Zi0auyShcmAYFDpdbxiSvi5v0L+o=;
        b=hlf1ocvwqf+LWnwfbGA2WyNQ31MaBObqPIou1fnddRks0bvyxijDIUN+E2P3X6YQTt
         0gr90ocH6YXcyaSJcFq+7NyjFy9oVyi2uDt4ULwSyoGFDtcsKmChXP5VeSC9fF64eQyz
         Y6H+CFKNfL6pVeSwsqJWyR29AW/so/GhomdgSdtEGBiRduN65rTuAnQPGAWg0enVFll4
         oF9IJLyZDb51R1tNxwIuQiuB1QBcm1+zkfWV0IK/M91zbzmCWWDCT/6FgpoOx1INOrVP
         uCsvkzQ1Bzf9cJ54A2YVwuYzRecUjilWGFc9tDq1WzKx7eGU2Dph2JpiaclRzcAA+sbm
         mUOQ==
X-Gm-Message-State: AAQBX9dz2XE8VT6Dd/CrpuqCbB2nqrEkvws1smwIl1m3hiX87zTHQYj3
        noEAWDtMut6URvAY4uzA/wkRgBB7HpT4ov5Z0c9IzW6VnYqE5kK/BtmLleKiDmDz3NHwyfR7wMv
        ad9qNQN2hZfMnTCb+
X-Received: by 2002:a1c:7716:0:b0:3f1:70d5:1bee with SMTP id t22-20020a1c7716000000b003f170d51beemr1493377wmi.29.1682074392428;
        Fri, 21 Apr 2023 03:53:12 -0700 (PDT)
X-Google-Smtp-Source: AKy350a07c45dcgGfnrd68VQAlhxr19V3vzigkuXDvXMbII3cSD3lRogv1buV5bfrUwNFi4dyPd3eA==
X-Received: by 2002:a1c:7716:0:b0:3f1:70d5:1bee with SMTP id t22-20020a1c7716000000b003f170d51beemr1493363wmi.29.1682074392125;
        Fri, 21 Apr 2023 03:53:12 -0700 (PDT)
Received: from localhost ([37.163.148.79])
        by smtp.gmail.com with ESMTPSA id gw19-20020a05600c851300b003f193c1311asm1111707wmb.6.2023.04.21.03.53.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 03:53:11 -0700 (PDT)
Date:   Fri, 21 Apr 2023 12:53:07 +0200
From:   Andrea Claudi <aclaudi@redhat.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     stephen@networkplumber.org, netdev@vger.kernel.org,
        dsahern@gmail.com, Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH iproute2 v3 0/2] iplink: update doc related to the
 'netns' arg
Message-ID: <ZEJrExLtoSjEq+Vl@renaissance-vector>
References: <20230421074720.31004-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230421074720.31004-1-nicolas.dichtel@6wind.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 21, 2023 at 09:47:18AM +0200, Nicolas Dichtel wrote:
> v2 -> v3:
>  - make doc about netns arg consistent between 'add' and 'set'
> 
> v1 -> v2:
>  - add patch 1/2
>  - s/NETNS_FILE/NETNSFILE
>  - describe NETNSNAME in the DESCRIPTION section of man pages
> 
>  ip/iplink.c           |  4 ++--
>  man/man8/ip-link.8.in | 26 +++++++++++++++++++-------
>  2 files changed, 21 insertions(+), 9 deletions(-)
> 
> Regards,
> Nicolas
> 

Reviewed-by: Andrea Claudi <aclaudi@redhat.com>

