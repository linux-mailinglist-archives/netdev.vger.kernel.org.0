Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B51DD687766
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 09:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjBBIbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 03:31:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbjBBIbm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 03:31:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B4EF17176
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 00:30:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675326651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=80FPjEat9xWRh1CoI72Gthl8r1ple2zW+6cWRK3cZyU=;
        b=JwjarO1aaRSO4jXOhbVD669sum0GZEU1Bymu13pnXT0Qne61KqDPzwuWGyPS8aK6QiIW0S
        b+D5lSy3EjPqQtWQVhr+eNOG08+12PornNJZHTirzYDaM+uJTSvopZceKWU84WtoNRZRi9
        rdv0SCv+d8xnUOvOfn6CUCCcB3dR8tY=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-402-DyGs6eE4OYOceSGUfzEFDg-1; Thu, 02 Feb 2023 03:30:50 -0500
X-MC-Unique: DyGs6eE4OYOceSGUfzEFDg-1
Received: by mail-qt1-f199.google.com with SMTP id t5-20020a05622a180500b003b9c03cd525so616057qtc.20
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 00:30:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=80FPjEat9xWRh1CoI72Gthl8r1ple2zW+6cWRK3cZyU=;
        b=O+wG4O7M7GDgjKq2zgl2dLxVAdkwClTlBGTMjvMiIrkwmw9K5MSO5IbDLFk9DbZqDv
         S9drV+vnjsPBw6GlnDDcN9mVgvBdZxRVoBDAw97uhSZtjdnwjRglE4OFWBYCUZnJ2ru8
         uCLmzwwgmjJSmTg7q4Pxt8T+cswk4pvu8+7HzS8bn7ycVaOG8bEyVvcK/C1CR+rbI2Es
         l9+zmDsNzX4fb1OWMaTmOfzM63FRudQFfVcKHMuaqWpX3DxzyDdvBWF0/V4oV5AEPALN
         0pAXHiw8Sy0FifBOODxTBAnoeG7tQUiLfNy5F6sp+w7si6TdLi4iYVY0iSkfE0UKp3bF
         Jw8Q==
X-Gm-Message-State: AO0yUKVVoXTIvGNPZDLcB9qz3b4n996yqVmTFp8pvGKMBYU77Edr1R1g
        T+kg0MlmvzISW/id2SA1XCHPJqh301w79GFfV4nAyyHK5CP2SjIoGIa9GXH0ZO3o4tg+TNuxU4R
        3jvxVa2DdjgSFZoO2
X-Received: by 2002:ac8:4b79:0:b0:3b9:b801:8744 with SMTP id g25-20020ac84b79000000b003b9b8018744mr7367863qts.4.1675326649833;
        Thu, 02 Feb 2023 00:30:49 -0800 (PST)
X-Google-Smtp-Source: AK7set+XwGpHzz3PSxQBwrvbOYbYJ2Djz1B611kpWp+2snxz+FIhXQHy+mOjeXyvKH5A9iNpelANOg==
X-Received: by 2002:ac8:4b79:0:b0:3b9:b801:8744 with SMTP id g25-20020ac84b79000000b003b9b8018744mr7367843qts.4.1675326649589;
        Thu, 02 Feb 2023 00:30:49 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id e11-20020ac8010b000000b003b630ea0ea1sm13293508qtg.19.2023.02.02.00.30.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 00:30:49 -0800 (PST)
Message-ID: <8a4d08f94d3e6fe8b6da68440eaa89a088ad84f9.camel@redhat.com>
Subject: Re: [PATCH net 1/1] hv_netvsc: Fix missed pagebuf entries in
 netvsc_dma_map/unmap()
From:   Paolo Abeni <pabeni@redhat.com>
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Date:   Thu, 02 Feb 2023 09:30:45 +0100
In-Reply-To: <BYAPR21MB1688B7F47F9ADF2E40E9DEE4D7D69@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1675135986-254490-1-git-send-email-mikelley@microsoft.com>
         <20230201210107.450ff5d3@kernel.org>
         <BYAPR21MB1688B7F47F9ADF2E40E9DEE4D7D69@BYAPR21MB1688.namprd21.prod.outlook.com>
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

On Thu, 2023-02-02 at 05:20 +0000, Michael Kelley (LINUX) wrote:
> From: Jakub Kicinski <kuba@kernel.org> Sent: Wednesday, February 1, 2023 =
9:01 PM
> >=20
> > On Mon, 30 Jan 2023 19:33:06 -0800 Michael Kelley wrote:
> > > @@ -990,9 +987,7 @@ static int netvsc_dma_map(struct hv_device *hv_de=
v,
> > >  			  struct hv_netvsc_packet *packet,
> > >  			  struct hv_page_buffer *pb)
> > >  {
> > > -	u32 page_count =3D  packet->cp_partial ?
> > > -		packet->page_buf_cnt - packet->rmsg_pgcnt :
> > > -		packet->page_buf_cnt;
> > > +	u32 page_count =3D packet->page_buf_cnt;
> > >  	dma_addr_t dma;
> > >  	int i;
> >=20
> > Suspiciously, the caller still does:
> >=20
> >                 if (packet->cp_partial)
> >                         pb +=3D packet->rmsg_pgcnt;
> >=20
> >                 ret =3D netvsc_dma_map(ndev_ctx->device_ctx, packet, pb=
);
> >=20
> > Shouldn't that if () pb +=3D... also go away?
>=20
> No -- it's correct.
>=20
> In netvsc_send(), cp_partial is tested and packet->page_buf_cnt is
> adjusted.  But the pointer into the pagebuf array is not adjusted in
> netvsc_send().  Instead it is adjusted here in netvsc_send_pkt(), which
> brings it back in sync with packet->page_buf_cnt.

Ok

> I don't know if there's a good reason for the adjustment being split
> across two different functions.  It doesn't seem like the most
> straightforward approach.  From a quick glance at the code it looks
> like this adjustment to 'pb' could move to netvsc_send() to be
> together with the adjustment to packet->page_buf_cnt,  but maybe
> there's a reason for the split that I'm not familiar with.
>=20
> Haiyang -- any insight?

While at that, please also have a look at the following allocation in
netvsc_dma_map():

	packet->dma_range =3D kcalloc(page_count,
                                    sizeof(*packet->dma_range),
                                    GFP_KERNEL);

which looks wrong - netvsc_dma_map() should be in atomic context.

Anyway it's a topic unrelated from this patch. I just stumbled upon it
while reviewing.

Cheers,

Paolo

