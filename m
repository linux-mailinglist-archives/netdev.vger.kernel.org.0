Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B302B6D5DB6
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 12:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234439AbjDDKk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 06:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234224AbjDDKk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 06:40:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C01B1713
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 03:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680604811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7d46xBYHWEkZyeYytCbGvbVuo90+yW995m9oaiqbPYc=;
        b=TNEawOhn3l9lwQXJSg1rhdS8U/TujmgjfbTPy2SJdH8tQbmG6ocwn0AB6lpT6/8s2JrFkK
        WnFlNapI2f/3eXYVn7tv0+nHomcwAXe6EXopus/uuFGhganhrOoSHUN6WS9wUssu9NY0Z0
        h7xjCqtQLjxQK64gnj/6tejOQjgkJi8=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-100-M82lDKe8O2CpXvmy3Zu0Ow-1; Tue, 04 Apr 2023 06:40:10 -0400
X-MC-Unique: M82lDKe8O2CpXvmy3Zu0Ow-1
Received: by mail-qv1-f72.google.com with SMTP id f8-20020a0cbec8000000b005b14a30945cso14376022qvj.8
        for <netdev@vger.kernel.org>; Tue, 04 Apr 2023 03:40:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680604809; x=1683196809;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7d46xBYHWEkZyeYytCbGvbVuo90+yW995m9oaiqbPYc=;
        b=uuHVqRa8Ix0Ug8c5/er6YP113Wrc6U9kqtIUFUeoDRFjDB5ImSdD5dnSrECJTkt4lV
         4ZdnzvLqxvtLVHk9JAcsm6oJB/zzKkZ13kmv+2noKdLnHDl+FIljlcQbe2yyo3tsWzxW
         lo5bdu2NUudQKsPTd2AN3C33fKPvsUj6ZUrAqS/mhjKKY5BfR2Gd2oTaIoG4IdH9eEk7
         kxGRUAi5zcQj6sx6744iIJiXZB5u+SqGybSG21ZYv0UbgnP2e1O0nXRDfm16ctNO2glu
         TmUu6xqlwa/BjIxSV/Mwok5KJyM/Nd3oa7cWA5DQ3oEJbFE0/aAkQ7ovpG9y8Sw402NU
         ZMIQ==
X-Gm-Message-State: AAQBX9d1CeHNS2OyRAloK4++81NYH3Y5HxVQUMeWymyZXLqHEtuNXnAr
        ihl+4rgXZedU0QV4mdGAXUJLSTFVGbWONIqtmOS3LDgENCAuvr6rA/nlF8OCEReXThAU4QH/Jxh
        qjfj3uvFk686VXEUezXDqJEsg
X-Received: by 2002:a05:622a:1894:b0:3d1:16f4:ae58 with SMTP id v20-20020a05622a189400b003d116f4ae58mr2697731qtc.2.1680604809486;
        Tue, 04 Apr 2023 03:40:09 -0700 (PDT)
X-Google-Smtp-Source: AKy350Y241CMiiNd6Tja1PTWaW0S6XwB0uuG6gKCUbaA+FkQcVXppPqcbrL8TrHUQNnCF7HyeN2CMw==
X-Received: by 2002:a05:622a:1894:b0:3d1:16f4:ae58 with SMTP id v20-20020a05622a189400b003d116f4ae58mr2697711qtc.2.1680604809234;
        Tue, 04 Apr 2023 03:40:09 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-227-151.dyn.eolo.it. [146.241.227.151])
        by smtp.gmail.com with ESMTPSA id t7-20020a37aa07000000b0074a0a47a1f3sm3526972qke.5.2023.04.04.03.40.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 03:40:08 -0700 (PDT)
Message-ID: <50f7d60a35b71048552e01612bfa3c5d36961d28.camel@redhat.com>
Subject: Re: [PATCH net] selftests: net: rps_default_mask.sh: delete veth
 link specifically
From:   Paolo Abeni <pabeni@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net
Date:   Tue, 04 Apr 2023 12:40:06 +0200
In-Reply-To: <20230404072411.879476-1-liuhangbin@gmail.com>
References: <20230404072411.879476-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-04-04 at 15:24 +0800, Hangbin Liu wrote:
> When deleting the netns and recreating a new one while re-adding the
> veth interface, there is a small window of time during which the old
> veth interface has not yet been removed. This can cause the new addition
> to fail. To resolve this issue, we can either wait for a short while to
> ensure that the old veth interface is deleted, or we can specifically
> remove the veth interface.
>=20
> Before this patch:
>   # ./rps_default_mask.sh
>   empty rps_default_mask                                      [ ok ]
>   changing rps_default_mask dont affect existing devices      [ ok ]
>   changing rps_default_mask dont affect existing netns        [ ok ]
>   changing rps_default_mask affect newly created devices      [ ok ]
>   changing rps_default_mask don't affect newly child netns[II][ ok ]
>   rps_default_mask is 0 by default in child netns             [ ok ]
>   RTNETLINK answers: File exists
>   changing rps_default_mask in child ns don't affect the main one[ ok ]
>   cat: /sys/class/net/vethC11an1/queues/rx-0/rps_cpus: No such file or di=
rectory
>   changing rps_default_mask in child ns affects new childns devices./rps_=
default_mask.sh: line 36: [: -eq: unary operator expected
>   [fail] expected 1 found
>   changing rps_default_mask in child ns don't affect existing devices[ ok=
 ]
>=20
> After this patch:
>   # ./rps_default_mask.sh
>   empty rps_default_mask                                      [ ok ]
>   changing rps_default_mask dont affect existing devices      [ ok ]
>   changing rps_default_mask dont affect existing netns        [ ok ]
>   changing rps_default_mask affect newly created devices      [ ok ]
>   changing rps_default_mask don't affect newly child netns[II][ ok ]
>   rps_default_mask is 0 by default in child netns             [ ok ]
>   changing rps_default_mask in child ns don't affect the main one[ ok ]
>   changing rps_default_mask in child ns affects new childns devices[ ok ]
>   changing rps_default_mask in child ns don't affect existing devices[ ok=
 ]
>=20
> Fixes: 3a7d84eae03b ("self-tests: more rps self tests")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  tools/testing/selftests/net/rps_default_mask.sh | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/tools/testing/selftests/net/rps_default_mask.sh b/tools/test=
ing/selftests/net/rps_default_mask.sh
> index 0fd0d2db3abc..a26c5624429f 100755
> --- a/tools/testing/selftests/net/rps_default_mask.sh
> +++ b/tools/testing/selftests/net/rps_default_mask.sh
> @@ -60,6 +60,7 @@ ip link set dev $VETH up
>  ip -n $NETNS link set dev $VETH up
>  chk_rps "changing rps_default_mask affect newly created devices" "" $VET=
H 3
>  chk_rps "changing rps_default_mask don't affect newly child netns[II]" $=
NETNS $VETH 0
> +ip link del dev $VETH
>  ip netns del $NETNS
> =20
>  setup

LGTM, thanks!

Acked-by: Paolo Abeni <pabeni@redhat.com>

