Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B851698E52
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 09:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjBPIKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 03:10:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjBPIKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 03:10:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01C72886B
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 00:09:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676534994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vIS+R1ldqJlF2KnzcKAChI+JfhNjLeCB33+uWuhkNv4=;
        b=RJ3KSQ8QHMv7I5TmP2w9/9XbosWJLwfyL6goxn2E62U8fDR6A6CbYfAqK5ZESN3eWFA/Oz
        Vc8/faH7H3IG4ODpxqZPLSdXcUhCE37bRj8gIpbo9uAHye3VsPCXgiziXBO+gnyqGRG16h
        e4egf5/ndQ6AnYpl6c/AZvEkxNggLiw=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-445-_WlGMGxeNGuPyc9cmq6g5A-1; Thu, 16 Feb 2023 03:09:52 -0500
X-MC-Unique: _WlGMGxeNGuPyc9cmq6g5A-1
Received: by mail-qk1-f200.google.com with SMTP id w17-20020a05620a425100b00706bf3b459eso750872qko.11
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 00:09:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676534992;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vIS+R1ldqJlF2KnzcKAChI+JfhNjLeCB33+uWuhkNv4=;
        b=x7Qg2k3e8fpoS9/R4U3rg2vxAbWyIptpJg/BWMayk4fd0NjL2bU5DvZ99u98FX8cpA
         42hC0WZCuOpsz7cBLJG8CKfaOn78ngpH1/MvtDFl9YC/B5pAM98hRnbIyOwVnM7GUBgq
         7lXs07S4wkcAkUwTPjpYtYXLFxMon2jXcu4+USSiXtJCyjlbWV3InEl6GMQO7YkTx8x3
         4W/3K0bVTHxOHqi8IdI2GsldRsYARLFyWsiIeNqKVAtejCGTQNHXKzRl85TxFLDZtywa
         nqW6dHDTOfEOW2FCQD27SOo5ytT9vBuGR2XajeCYrcpR6thSSwGWHGWjQKP7TdXVDvWN
         l3Rw==
X-Gm-Message-State: AO0yUKWYPfU9kLkmTzdJ9NCBFmPVLgF5oZbfPNvtXHXUAqTmhv0YhkC9
        50KEEY2vZmzbg5pZ1Ya8pryyr1XkfFTjViNGklXlkwNfwD8781/al8vJWpvq5KkSJQIr+AUEhb2
        9KktlkqcNV9EoBTGl
X-Received: by 2002:a05:622a:1805:b0:3bd:d8f:2da4 with SMTP id t5-20020a05622a180500b003bd0d8f2da4mr1292074qtc.2.1676534991713;
        Thu, 16 Feb 2023 00:09:51 -0800 (PST)
X-Google-Smtp-Source: AK7set9PVFKwI6qJe0zGzL3CFg0zMbw7EMK4totY36MhT1pUEBExj4rOt0oLZNvcOfzxrhb2GFvh6g==
X-Received: by 2002:a05:622a:1805:b0:3bd:d8f:2da4 with SMTP id t5-20020a05622a180500b003bd0d8f2da4mr1292035qtc.2.1676534991408;
        Thu, 16 Feb 2023 00:09:51 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id hf22-20020a05622a609600b003b85ed59fa2sm790919qtb.50.2023.02.16.00.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 00:09:50 -0800 (PST)
Message-ID: <0b639b4294ffa61776756d33fc345e60a576d0ec.camel@redhat.com>
Subject: Re: [PATCH net-next v2 06/10] net: microchip: sparx5: Add ES0 VCAP
 model and updated KUNIT VCAP model
From:   Paolo Abeni <pabeni@redhat.com>
To:     Steen Hegelund <steen.hegelund@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     UNGLinuxDriver@microchip.com, Randy Dunlap <rdunlap@infradead.org>,
        Casper Andersson <casper.casan@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Nathan Huckleberry <nhuck@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Daniel Machon <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Dan Carpenter <error27@gmail.com>,
        Michael Walle <michael@walle.cc>
Date:   Thu, 16 Feb 2023 09:09:46 +0100
In-Reply-To: <20230214104049.1553059-7-steen.hegelund@microchip.com>
References: <20230214104049.1553059-1-steen.hegelund@microchip.com>
         <20230214104049.1553059-7-steen.hegelund@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-02-14 at 11:40 +0100, Steen Hegelund wrote:
> This provides the VCAP model for the Sparx5 ES0 (Egress Stage 0) VCAP.
>=20
> This VCAP provides rewriting functionality in the egress path.
>=20
> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> ---
>  .../microchip/sparx5/sparx5_vcap_ag_api.c     | 385 +++++++++++++++++-
>  .../net/ethernet/microchip/vcap/vcap_ag_api.h | 174 +++++++-
>  .../microchip/vcap/vcap_api_debugfs_kunit.c   |   4 +-
>  .../microchip/vcap/vcap_model_kunit.c         | 270 +++++++-----
>  .../microchip/vcap/vcap_model_kunit.h         |  10 +-
>  5 files changed, 721 insertions(+), 122 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_ag_api.c b=
/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_ag_api.c
> index 561001ee0516..556d6ea0acd1 100644
> --- a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_ag_api.c
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_ag_api.c
> @@ -3,8 +3,8 @@
>   * Microchip VCAP API
>   */
> =20
> -/* This file is autogenerated by cml-utils 2023-01-17 16:55:38 +0100.
> - * Commit ID: cc027a9bd71002aebf074df5ad8584fe1545e05e
> +/* This file is autogenerated by cml-utils 2023-02-10 11:15:56 +0100.
> + * Commit ID: c30fb4bf0281cd4a7133bdab6682f9e43c872ada
>   */=20

If the following has been already discussed, I'm sorry for the
duplicates, I missed the relevant thread.

Since this drivers contains quite a bit of auto-generated code, I'm
wondering if you could share the tool and/or the source file, too. That
would make reviews more accurate.

Thanks,

Paolo

