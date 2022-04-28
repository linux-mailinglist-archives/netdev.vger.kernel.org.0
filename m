Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6BA512FD8
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 11:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiD1JuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 05:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347954AbiD1Jfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 05:35:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 46CA39548A
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 02:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651138358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OG6hUPY6sAUTqTJViKJ1E1LWjNyEwooQAig3aG1iSlg=;
        b=bSdVaS0yvXXpcbDElCVtDBaDx0k1hLCEBJ30qU6Th/pqqSu19XujxA1FEMqmwRtlmyyEwJ
        YLVSf6reCB8icoY9UilVO5q9FfpYCGyxGTyOgO93umwDCBspKUgGPTFf7DyWzODfM31bh8
        1cFarfsOSA5R9Qh58WE7Xddpipg+Po4=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-73-iJXESnRUOhWCRgCLdHBMYA-1; Thu, 28 Apr 2022 05:32:37 -0400
X-MC-Unique: iJXESnRUOhWCRgCLdHBMYA-1
Received: by mail-qk1-f197.google.com with SMTP id j12-20020ae9c20c000000b0069e8ac6b244so2860936qkg.1
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 02:32:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=OG6hUPY6sAUTqTJViKJ1E1LWjNyEwooQAig3aG1iSlg=;
        b=Rday0giu7Cg8rj/uniDTDqpAd4mSodrn+jMA1eMOkopqWHkN2OX6aY+nry0MaM0GUs
         K2fBubhJawQqO5Xr+ztDCGPWFMPix9R4NV3sAS1e5OvfR+xGNQgrDobJ4+fvqaDsgg4w
         Eu/aZPDswznWY7a+g22hO1YwUjU4YUQgBhTd0EvQp8/0Y5CQqLYZVOyKjiyrqy7/RBqN
         kI+Hezi88x0DhIpNCa47TbYPECEVfLSyVx6GSWHjZxGMLn71fj6KMcguT0zWwjfpqvmw
         GSsP5cyhlbqZK/MlSDU+OKgBhZRBgfeYCL2jf/hfUVUeTEdeBd91bTk7CLVyLxZjM9UI
         udPQ==
X-Gm-Message-State: AOAM530jVT0S9hxRdTydKLP16s2u/LptfEt+JO7HR5uxICa5+1ErXqHW
        O3gCQ3MntBtIgGg34IdD5dOKndkpvr2vx+copi2WLUXgSSntLo9JXy1q5sDZoJMlqkp6ziPEPt/
        RHCC6c37F6nvbSfNy
X-Received: by 2002:a05:622a:2cb:b0:2f3:646b:54b6 with SMTP id a11-20020a05622a02cb00b002f3646b54b6mr15456771qtx.380.1651138356468;
        Thu, 28 Apr 2022 02:32:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyJ3J0ImF+LM/cJTr/TdEmv6YBtIqlv1bBiDK6w9j0coe0CvNV+LL3YO5hh7fcCBb3x5O7y0w==
X-Received: by 2002:a05:622a:2cb:b0:2f3:646b:54b6 with SMTP id a11-20020a05622a02cb00b002f3646b54b6mr15456733qtx.380.1651138356147;
        Thu, 28 Apr 2022 02:32:36 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-117-160.dyn.eolo.it. [146.241.117.160])
        by smtp.gmail.com with ESMTPSA id k66-20020a37ba45000000b0069c5adb2f2fsm9620433qkf.6.2022.04.28.02.32.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 02:32:35 -0700 (PDT)
Message-ID: <c499d01d51095ae338cbc63179bdc0e1606cbfef.camel@redhat.com>
Subject: Re: [PATCH net-next v5 08/18] net: sparx5: Replace usage of found
 with dedicated list iterator variable
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakob Koschel <jakobkoschel@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Casper Andersson <casper.casan@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Colin Ian King <colin.king@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Xu Wang <vulab@iscas.ac.cn>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, bpf@vger.kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Date:   Thu, 28 Apr 2022 11:32:28 +0200
In-Reply-To: <20220427160635.420492-9-jakobkoschel@gmail.com>
References: <20220427160635.420492-1-jakobkoschel@gmail.com>
         <20220427160635.420492-9-jakobkoschel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Wed, 2022-04-27 at 18:06 +0200, Jakob Koschel wrote:
> To move the list iterator variable into the list_for_each_entry_*()
> macro in the future it should be avoided to use the list iterator
> variable after the loop body.
> 
> To *never* use the list iterator variable after the loop it was
> concluded to use a separate iterator variable instead of a
> found boolean [1].
> 
> This removes the need to use a found variable and simply checking if
> the variable was set, can determine if the break/goto was hit.
> 
> Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/ [1]
> Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
> ---
>  .../microchip/sparx5/sparx5_mactable.c        | 25 +++++++++----------
>  1 file changed, 12 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c b/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
> index a5837dbe0c7e..bb8d9ce79ac2 100644
> --- a/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
> @@ -362,8 +362,7 @@ static void sparx5_mact_handle_entry(struct sparx5 *sparx5,
>  				     unsigned char mac[ETH_ALEN],
>  				     u16 vid, u32 cfg2)
>  {
> -	struct sparx5_mact_entry *mact_entry;
> -	bool found = false;
> +	struct sparx5_mact_entry *mact_entry = NULL, *iter;
>  	u16 port;
>  
>  	if (LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR_TYPE_GET(cfg2) !=
> @@ -378,28 +377,28 @@ static void sparx5_mact_handle_entry(struct sparx5 *sparx5,
>  		return;
>  
>  	mutex_lock(&sparx5->mact_lock);
> -	list_for_each_entry(mact_entry, &sparx5->mact_entries, list) {
> -		if (mact_entry->vid == vid &&
> -		    ether_addr_equal(mac, mact_entry->mac)) {
> -			found = true;
> -			mact_entry->flags |= MAC_ENT_ALIVE;
> -			if (mact_entry->port != port) {
> +	list_for_each_entry(iter, &sparx5->mact_entries, list) {
> +		if (iter->vid == vid &&
> +		    ether_addr_equal(mac, iter->mac)) {

I'm sorry for the late feedback.

If you move the 'mact_entry = iter;' statement here, the diffstat will
be slightly smaller and the patch more readable, IMHO.

There is similar situation in the next patch.

Cheers,

Paolo

