Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEE95507DDD
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 03:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348108AbiDTBC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 21:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348181AbiDTBCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 21:02:55 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46CD317A9F
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 18:00:11 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id g9so73783pgc.10
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 18:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0qJuigQ5a8M31Jxp1rX0VkzoPSkVh8eToZpyU/vy+sk=;
        b=GtvTUTYuyPApDhwKEY7nI9mKfLJ0lT6wuUZxSMIWqYwaGdRrIqkJaLG/+KTkbIM0LU
         WRC1YoJ+UybUVmOEgl7ThooZi0foEtRccx13tu0xBqzB0W6JTHJFZST0cDOYrvhYHvfK
         Kx/aU5FgAesVH3Q1RDsrixdvWGYq3MPkP7tNjO22wb6GPrjo8comkGi3mD9NHuPYWMoo
         Gxvp/e2clcgA/4hTweBkmY3iLahQe7zwLcmx8RUt2qQys2YPWKfgoSu+X8b122V4vfMr
         J5gGSDrX3LnaMkqWWxaIp+PBueP+dC2KCZN7NniHq1UcpIKQYDuM1zj81QL3vKASJvwF
         MOlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0qJuigQ5a8M31Jxp1rX0VkzoPSkVh8eToZpyU/vy+sk=;
        b=SDKKcJLZgwVQGe6n2lYTbfSpuBl879zWHrHLWQ1t2cWgs/JJaeO3euSWyUSsTOA9Bo
         +SK9XlIPkCBUemki10peWHSrvIgyVikC9RsLiA1CY4FQLRM0wqQcE/E6mqIK6I2hopyi
         FwfK2VqOE0y08+HhrTI0I/dAuWJhulthBMsQVXwP8s2rR+zgehZuAxodt2bu+edHG8B8
         Rp/ARsnE5H2BhGQeT52yoyidsOPganiB4qk2SqRepLR6pn9m0iOiiLp0mdUPJbX+agom
         tgBZIDL/2OjrTmPLUd1JZ5YALIdTEca97VCLx3a02Y0LPS3xC5Yf6tPX0Alc0DHcYmee
         SeYA==
X-Gm-Message-State: AOAM533YwuBHH9dfRy3ibe6iazG3UdDkVZWzZ4DafDeKAH4EPCY01fjU
        mPCO30XE+k9GG5xoTTe23K0=
X-Google-Smtp-Source: ABdhPJw/drYELBvZ2jIn9qvcvh/AKlZD2bZqiU67oan+ZQbv1PtnGu/aiMSg98MHuP+33Q729RsaMA==
X-Received: by 2002:a05:6a02:19b:b0:39d:cfa:5cda with SMTP id bj27-20020a056a02019b00b0039d0cfa5cdamr16972584pgb.175.1650416410645;
        Tue, 19 Apr 2022 18:00:10 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s11-20020a6550cb000000b0039daee7ed0fsm16980583pgp.19.2022.04.19.18.00.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 18:00:10 -0700 (PDT)
Date:   Wed, 20 Apr 2022 08:59:58 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Mike Pattrick <mpattric@redhat.com>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        virtualization@lists.linux-foundation.org,
        Balazs Nemeth <bnemeth@redhat.com>,
        Flavio Leitner <fbl@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH net 1/2] net/af_packet: adjust network header position
 for VLAN tagged packets
Message-ID: <Yl9bDrDFZhc04MiY@Laptop-X1>
References: <20220418044339.127545-1-liuhangbin@gmail.com>
 <20220418044339.127545-2-liuhangbin@gmail.com>
 <CA+FuTScQ=tP=cr5f2S97Z7ex1HMX5R-C0W6JE2Bx5UWgiGknZA@mail.gmail.com>
 <Yl4mU0XLmPukG0WO@Laptop-X1>
 <CA+FuTSfBU7ck91ayf_t9=7eRGJZHuWSeXzX2SxFAQMPSitY9SA@mail.gmail.com>
 <20220419101325-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419101325-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 19, 2022 at 10:26:09AM -0400, Michael S. Tsirkin wrote:
> > > There are also some duplicated codes in these *_snd functions.
> > > I think we can move them out to one single function.
> > 
> > Please don't refactor this code. It will complicate future backports
> > of stable fixes.
> 
> Hmm I don't know offhand which duplication this refers to specifically
> so maybe it's not worth addressing specifically but generally not
> cleaning up code just because of backports seems wrong ...

Yes, packet_snd() and tpacket_snd() share same addr/msg checking logic that
I think we can clean up.

> > > > stretching the definition of the flags to include VLAN is acceptable
> > > > (unlike outright tunnels), but even then I would suggest for net-next.
> > >
> > > As I asked, I'm not familiar with virtio code. Do you think if I should
> > > add a new VIRTIO_NET_HDR_GSO_VLAN flag? It's only a L2 flag without any L3
> > > info. If I add something like VIRTIO_NET_HDR_GSO_VLAN_TCPV4/TCPV6/UDP. That
> > > would add more combinations. Which doesn't like a good idea.
> > 
> > I would prefer a new flag to denote this type, so that we can be
> > strict and only change the datapath for packets that have this flag
> > set (and thus express the intent).
> > 
> > But the VIRTIO_NET_HDR types are defined in the virtio spec. The
> > maintainers should probably chime in.
> 
> Yes, it's a UAPI extension, not to be done lightly. In this case IIUC
> gso_type in the header is only u8 - 8 bits and 5 of these are already
> used.  So I don't think the virtio TC will be all that happy to burn up
> a bit unless a clear benefit can be demonstrated. 
> 
> I agree with the net-next proposal, I think it's more a feature than a
> bugfix. In particular I think a Fixes tag can also be dropped in that
> IIUC GSO for vlan packets didn't work even before that commit - right?

Right. virtio_net_hdr GSO with vlan doesn't work before.
I will post this to net-next.

Thanks
Hangbin
