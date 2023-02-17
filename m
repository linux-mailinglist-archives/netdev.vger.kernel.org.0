Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 780C669B150
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 17:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjBQQrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 11:47:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjBQQru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 11:47:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2129F190
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 08:47:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676652426;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l1LxwWmWqf8IjOm2G4QGdHlkYxOfwoVPScy+qKlyy5U=;
        b=Zzi1ModXIV9xUQXeIqFF6wzKrTj4V8wISUc0TeTte80UbLKU6vVfAU7S2L9p6uz31JxTfZ
        HzRUmD7nn5Z6/DFffEsKYvJ3v7rHciLBtghTYRrduYXE04txf0tC+sONKRKKkzHGhFmown
        uMMqFNzAsqdh+YcvUhwfKvyz4m8g1W0=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-587-SDacw3xXNGmUZg7bAVGQGw-1; Fri, 17 Feb 2023 11:47:04 -0500
X-MC-Unique: SDacw3xXNGmUZg7bAVGQGw-1
Received: by mail-qt1-f197.google.com with SMTP id c19-20020ac853d3000000b003ba2a2c50f9so734573qtq.23
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 08:47:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l1LxwWmWqf8IjOm2G4QGdHlkYxOfwoVPScy+qKlyy5U=;
        b=UAPcHqvIn9Q80KfAmEBvfcNSlljxTkIlZ5GyxSi4XIO5mELnUSQoGWHCakKvLceuKN
         n0va5dbVBtbb7oz6AhwGo1ij+moZ4+1B4mDSyqbCRfhRz8ww3tRvAP0MHL2JmHLwuhqI
         yyrGL+mTDgJmkrxn60FmOIRQrvQRRHs/u0+qi4MhPOYH+0w+wRrk6umlewPEhp1VF9lU
         ZMNxR35zaxF0+9KOk6ArMHfFW3ZM5a5r97h0Dxsem2Nrn2GInbFRJk+0qQD2vRignUsL
         8UesndRhVIAFFxe96ZNqmuFCzBqyI7QpOp9bty8dH7wzlXkspLKFgpaWD2ixWme8ynp4
         WKoQ==
X-Gm-Message-State: AO0yUKU6ogxpbIo3VTVZvsxSeauRSqGHjneiMn67eIPGnrtYMcFyPdgH
        /rBeyzsjh7BEXa8GFnXlf2P7WIzGrlYL2IZMDREyfni/zw16w6+8i34lUhxPIinsgfeMNfrP2wj
        PbQp7EvvvXcacHWy0
X-Received: by 2002:a05:622a:1790:b0:3bd:142d:64dd with SMTP id s16-20020a05622a179000b003bd142d64ddmr7110983qtk.3.1676652424290;
        Fri, 17 Feb 2023 08:47:04 -0800 (PST)
X-Google-Smtp-Source: AK7set8cIx+NjXXQGUOhiogUNo6kn4XAge3rNmfZI5qHreTVLPFExzEzU56U5DlzoVCTINkGDPve7Q==
X-Received: by 2002:a05:622a:1790:b0:3bd:142d:64dd with SMTP id s16-20020a05622a179000b003bd142d64ddmr7110954qtk.3.1676652423974;
        Fri, 17 Feb 2023 08:47:03 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-8.dyn.eolo.it. [146.241.121.8])
        by smtp.gmail.com with ESMTPSA id c76-20020ae9ed4f000000b00728bbe45888sm3562145qkg.10.2023.02.17.08.47.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 08:47:03 -0800 (PST)
Message-ID: <07293a5cbb4ac1680d7b737105b1c308d626a72c.camel@redhat.com>
Subject: Re: [PATCH] sfc: fix builds without CONFIG_RTC_LIB
From:   Paolo Abeni <pabeni@redhat.com>
To:     "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>,
        Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "jiri@nvidia.com" <jiri@nvidia.com>
Date:   Fri, 17 Feb 2023 17:46:59 +0100
In-Reply-To: <DM6PR12MB420241B35AB4B8846AB4F568C1A19@DM6PR12MB4202.namprd12.prod.outlook.com>
References: <20230217102236.48789-1-alejandro.lucero-palau@amd.com>
         <ef38e919-f7ea-0b11-f5d5-2eb4fb665c72@intel.com>
         <DM6PR12MB4202D1FA796BF66E6AD4C6C0C1A19@DM6PR12MB4202.namprd12.prod.outlook.com>
         <DM6PR12MB420241B35AB4B8846AB4F568C1A19@DM6PR12MB4202.namprd12.prod.outlook.com>
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

On Fri, 2023-02-17 at 15:30 +0000, Lucero Palau, Alejandro wrote:
> BTW, I did not send the net-next tag what I'm not sure if it is required=
=20
> (I would say so).
>=20
> Should I add it?

Indeed is required and you should add it when you will post v2.

Thanks,

Paolo

