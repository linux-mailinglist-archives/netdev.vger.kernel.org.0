Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD3469B1FA
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 18:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjBQRrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 12:47:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjBQRrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 12:47:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F062F711AA
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 09:46:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676655983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e7NLRZnyHJz6CxIp2bsndj4MVccxx/qy4aNSV3L2uLc=;
        b=GI0WWABB+q1r+/aTxJj4uV6p9KHrIkY/D8aIsTPrduIQyf2bxzHeXiDjkl5jniF4a/OsT6
        LrskHRK89DJRuib+yz4UvogDNtJO9TMt8D07mQT/gdMwI7EIiNOesdrV1B4daKxRhPfZSM
        BJ0JKJrMQ7HqKbi+Wt90C3W+Cj/me7I=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-322-S7-A5XAONUiJhQMwp_REUw-1; Fri, 17 Feb 2023 12:46:22 -0500
X-MC-Unique: S7-A5XAONUiJhQMwp_REUw-1
Received: by mail-qv1-f69.google.com with SMTP id t4-20020a0cf984000000b0056c228fa15cso583114qvn.4
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 09:46:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676655982;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e7NLRZnyHJz6CxIp2bsndj4MVccxx/qy4aNSV3L2uLc=;
        b=bKpmmVDIIQ0APP1LT/YBQQOHYZEOFuz/caErNLTuY6PX+7tcneEbm9mHoXlqQZiMNi
         bt6kvWGql9jnJF7A+/GcYc94i38YFm87PCoOEvxtjv0hZcjULV/8yNUIYSGpNZN/cl5u
         swM2HUJPtSyRr+8hEyVRe7bCIMp3zo2PJhpt/8O8+ITOWs2pit66B5MvhGH4wRyBpTsZ
         8hm87g+7LTgb2dxRIgBSQrIrYZj339ADdOIBVf5RB+boUE3X4L82ldsu3Xy4RKVWjBuN
         F8El1TG0cNIy6lBaTMZFu1ax3xv1CjMmnXjyvrT2+wtXA9vwrMRCDcUqHq0a4OBqM13I
         qKiw==
X-Gm-Message-State: AO0yUKWUwG68ZGJPKtU+a8IcyPi6ExFAgRp0CGwcGecDv8o2/hpEXRAX
        WZNwVOVr2/f/t+Jl9m0rZOhQ9bdgKQjvt3+5eFrrx0sGfmveu4EToCMpNCU3ft/+eIo2odBtd9q
        TTa4WeAmZdDo7TXiE
X-Received: by 2002:ac8:5c96:0:b0:3bd:1647:160b with SMTP id r22-20020ac85c96000000b003bd1647160bmr8284483qta.2.1676655982132;
        Fri, 17 Feb 2023 09:46:22 -0800 (PST)
X-Google-Smtp-Source: AK7set/NG9C0E49gn9joHJsCByX7sZR/FGcpq63wgQHLyI4kVCDz5BsMb5tm2WAqtTA4rRH5aoGV+Q==
X-Received: by 2002:ac8:5c96:0:b0:3bd:1647:160b with SMTP id r22-20020ac85c96000000b003bd1647160bmr8284438qta.2.1676655981775;
        Fri, 17 Feb 2023 09:46:21 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-8.dyn.eolo.it. [146.241.121.8])
        by smtp.gmail.com with ESMTPSA id c13-20020ac81e8d000000b003b9ba2cf068sm3708131qtm.56.2023.02.17.09.46.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 09:46:21 -0800 (PST)
Message-ID: <60366cf007060025725a18a77f58c41ee7e3158b.camel@redhat.com>
Subject: Re: [PATCH v2 net-next] sfc: fix ia64 builds without CONFIG_RTC_LIB
From:   Paolo Abeni <pabeni@redhat.com>
To:     alejandro.lucero-palau@amd.com, netdev@vger.kernel.org,
        linux-net-drivers@amd.com
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        habetsm.xilinx@gmail.com, ecree.xilinx@gmail.com,
        linux-doc@vger.kernel.org, corbet@lwn.net, jiri@nvidia.com
Date:   Fri, 17 Feb 2023 18:46:18 +0100
In-Reply-To: <20230217170348.7402-1-alejandro.lucero-palau@amd.com>
References: <20230217170348.7402-1-alejandro.lucero-palau@amd.com>
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

On Fri, 2023-02-17 at 17:03 +0000, alejandro.lucero-palau@amd.com
wrote:
> From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
>=20
> Add an embarrasingly missed semicolon breaking kernel building
> in ia64 configs.
>=20
> Reported-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/oe-kbuild-all/202302170047.EjCPizu3-lkp@int=
el.com/
> Fixes: 14743ddd2495 ("sfc: add devlink info support for ef100")
> Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
> ---
>  drivers/net/ethernet/sfc/efx_devlink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/etherne=
t/sfc/efx_devlink.c
> index d2eb6712ba35..3eb355fd4282 100644
> --- a/drivers/net/ethernet/sfc/efx_devlink.c
> +++ b/drivers/net/ethernet/sfc/efx_devlink.c
> @@ -323,7 +323,7 @@ static void efx_devlink_info_running_v2(struct efx_ni=
c *efx,
>  				    GET_VERSION_V2_OUT_SUCFW_BUILD_DATE);
>  		rtc_time64_to_tm(tstamp, &build_date);
>  #else
> -		memset(&build_date, 0, sizeof(build_date)
> +		memset(&build_date, 0, sizeof(build_date);

You missed the feedback on previous version from Manank reporting you
should also add a final ')' above. Should be:

+		memset(&build_date, 0, sizeof(build_date));

Please try to build test the next version before submitting it, thanks!

Paolo

