Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76C5E4FE1E7
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 15:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355306AbiDLNPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 09:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355785AbiDLNNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 09:13:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F0ED7BD
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 05:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649768184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fKGY79qeJkiZPEmiUhd4p41YrGI5Je/IzqvYghVlks4=;
        b=JgnLxN17bYza845u/zoiL3tMPrxJscVHPtm9xXzK4YNRqZCJbUfBqlKGDGDGmfziEVzr9E
        uY0jmT0oAi8PDKGRrm95UwtN8FJ4Ec9ypPluRbtw0yKEeoL09GAi5qOQT+IXd1zxl4rOmD
        8+0qcHC0q56DefF3uXP7Xj9YOu8Llx0=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-284-0Mwdx076MhaHfZkecf1a8w-1; Tue, 12 Apr 2022 08:56:23 -0400
X-MC-Unique: 0Mwdx076MhaHfZkecf1a8w-1
Received: by mail-qt1-f197.google.com with SMTP id s17-20020a05622a1a9100b002ed3cb8acb3so4806094qtc.10
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 05:56:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=fKGY79qeJkiZPEmiUhd4p41YrGI5Je/IzqvYghVlks4=;
        b=KMEw8nM2UrtYXLQF762mPJrKOjvQKj/XhGYzZOQQC+wbodntJkXrmLXBhcLZomeGK/
         Q7iYtXhApg+qYZhA/Z5npJNuYn8KAlaxAB92aNpMcfX3xgAjStAp4KglUS9DIMXAZuBl
         watgLlGgaLHyKEJwVaYZG79eTHVp7icx/HbQrnO4wb0iVv+a+gOBqTPAnBcgkbSHWige
         S15sDSiAdQv+spRyKfpmw3OmiXre1xfsAL1KBpIlN8pH/5t4h/5F3T3iQ+zuX6dNS99m
         9YjOECYOS27Q/jQFpkk+7ybCbYjZV/oOBIasxT9FuxdwnmPzWfIkllsW4m4R7eaGbz3b
         PC8A==
X-Gm-Message-State: AOAM531a2j+4fzNBzEzUb4U2P8nTUiuLJjkVg/hANFXMRbwYIZmdsZI2
        RPslvGz0S+NMvJChM3YkPLd2RrSdrPS7mfHXnEgd1Wg/VIKfWjl9CfIfaUwl78DGr0WlAeIoZRo
        IKZaZTtm72++85bPA
X-Received: by 2002:a05:6214:20e6:b0:440:f6d0:fe55 with SMTP id 6-20020a05621420e600b00440f6d0fe55mr31833013qvk.57.1649768183297;
        Tue, 12 Apr 2022 05:56:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwfGzch4mtv0CtgEFK5dNCfGzrVh3HY2NYysAp6bl6G8/cDuBO5Qvh7If1QbYl5wRAYXhjOTw==
X-Received: by 2002:a05:6214:20e6:b0:440:f6d0:fe55 with SMTP id 6-20020a05621420e600b00440f6d0fe55mr31832990qvk.57.1649768183030;
        Tue, 12 Apr 2022 05:56:23 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-96-237.dyn.eolo.it. [146.241.96.237])
        by smtp.gmail.com with ESMTPSA id j19-20020a05622a039300b002ecc2ebfd87sm10430205qtx.32.2022.04.12.05.56.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 05:56:22 -0700 (PDT)
Message-ID: <d303c605bdb951f1471800aca10bd97f47372295.camel@redhat.com>
Subject: Re: [PATCH net-next v2 05/18] net: dsa: mv88e6xxx: remove redundant
 check in mv88e6xxx_port_vlan()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakob Koschel <jakobkoschel@gmail.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
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
        Colin Ian King <colin.king@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Michael Walle <michael@walle.cc>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Eric Dumazet <edumazet@google.com>,
        Xu Wang <vulab@iscas.ac.cn>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, bpf@vger.kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Date:   Tue, 12 Apr 2022 14:56:15 +0200
In-Reply-To: <8BAFAAD1-D9AB-4339-BE81-18BE564F78F6@gmail.com>
References: <20220412105830.3495846-1-jakobkoschel@gmail.com>
         <20220412105830.3495846-6-jakobkoschel@gmail.com>
         <YlViPWWKhvoV2DLN@shell.armlinux.org.uk>
         <8BAFAAD1-D9AB-4339-BE81-18BE564F78F6@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-04-12 at 13:37 +0200, Jakob Koschel wrote:
> 
> > On 12. Apr 2022, at 13:27, Russell King (Oracle) <linux@armlinux.org.uk> wrote:
> > 
> > On Tue, Apr 12, 2022 at 12:58:17PM +0200, Jakob Koschel wrote:
> > > We know that "dev > dst->last_switch" in the "else" block.
> > > In other words, that "dev - dst->last_switch" is > 0.
> > > 
> > > dsa_port_bridge_num_get(dp) can be 0, but the check
> > > "if (bridge_num + dst->last_switch != dev) continue", rewritten as
> > > "if (bridge_num != dev - dst->last_switch) continue", aka
> > > "if (bridge_num != something which cannot be 0) continue",
> > > makes it redundant to have the extra "if (!bridge_num) continue" logic,
> > > since a bridge_num of zero would have been skipped anyway.
> > > 
> > > Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
> > > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > 
> > Isn't this Vladimir's patch?
> > 
> > If so, it should be commited as Vladimir as the author, and Vladimir's
> > sign-off should appear before yours. When sending out such patches,
> > there should be a From: line for Vladimir as the first line in the body
> > of the patch email.
> 
> yes, you are right. I wasn't sure on how to send those commits, but
> I guess if I just set the commit author correctly it should be fine.
> 
> regarding the order: I thought I did it correctly doing bottom up but
> I confused the order, wasn't on purpose. Sorry about that.
> 
> I'll resend after verifying all the authors and sign-offs are correct.

whoops, too late...

Please, do wait at least 24h before reposting, as pointed out in the
documentation:

https://elixir.bootlin.com/linux/v5.18-rc2/source/Documentation/process/maintainer-netdev.rst#L148

Thanks,

Paolo


