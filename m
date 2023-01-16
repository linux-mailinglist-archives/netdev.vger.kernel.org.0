Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAAE66CB02
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 18:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234253AbjAPRJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 12:09:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232958AbjAPRJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 12:09:12 -0500
Received: from dilbert.mork.no (dilbert.mork.no [IPv6:2a01:4f9:c010:a439::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403F323C68;
        Mon, 16 Jan 2023 08:49:37 -0800 (PST)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9a:3200:0:0:0:1])
        (authenticated bits=0)
        by dilbert.mork.no (8.15.2/8.15.2) with ESMTPSA id 30GGmpaU2102783
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 16:48:52 GMT
Received: from miraculix.mork.no ([IPv6:2a01:799:c9a:3202:549f:9f7a:c9d8:875b])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 30GGmjDj2045637
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 17:48:45 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1673887726; bh=UD4ZhaHjRcn1J2dnBAvslht8N8U56Uf/Euv/eC9LvAo=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=PTdLyuia0bJNc5u9zqdnDShXdiE3GeI5ngqK4fbBuVluwBjD87vjwLYx+IzeNJZv/
         taALeumzB0roYExAe6bLKOftCFkFWWhbdUomsV6d83GY5tsvqNetimULAxzYSvGevl
         dGFFWwI74DAMZsAEcTMM6rq4JHme9kXjXVMurB0A=
Received: (nullmailer pid 377843 invoked by uid 1000);
        Mon, 16 Jan 2023 16:48:45 -0000
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org,
        Alexander Couzens <lynxis@fe80.eu>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: mtk_sgmii: implement mtk_pcs_ops
Organization: m
References: <trinity-d2f74581-c020-4473-a5f4-0fc591233293-1666622740261@3c-app-gmx-bap55>
        <Y1ansgmD69AcITWx@shell.armlinux.org.uk>
        <trinity-defa4f3d-804e-401e-bea1-b36246cbc11b-1666685003285@3c-app-gmx-bap29>
        <87o7qy39v5.fsf@miraculix.mork.no>
        <Y8VVa0zHk0nCwS1w@shell.armlinux.org.uk>
        <87h6wq35dn.fsf@miraculix.mork.no>
        <Y8VmSrjHTlllaDy2@shell.armlinux.org.uk>
        <87bkmy33ph.fsf@miraculix.mork.no>
        <Y8Vt9vfEa4w8HXHQ@shell.armlinux.org.uk>
        <875yd630cu.fsf@miraculix.mork.no>
        <Y8V+pvWlV6pSuDX/@shell.armlinux.org.uk>
Date:   Mon, 16 Jan 2023 17:48:45 +0100
In-Reply-To: <Y8V+pvWlV6pSuDX/@shell.armlinux.org.uk> (Russell King's message
        of "Mon, 16 Jan 2023 16:43:18 +0000")
Message-ID: <87v8l61l3m.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.7 at canardo
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Russell King (Oracle)" <linux@armlinux.org.uk> writes:

> I found the document for the PHY at:
>
> https://assets.maxlinear.com/web/documents/617792_gpy212b1vc_gpy212c0vc_d=
s_rev1.3.pdf
>
> It seems as I suspected, the PHY has not completed SGMII AN. Please
> can you read register 8 when operating at 1G speeds as well
> (VSPEC1_SGMII_CTRL)? Thanks.

Both phys at 1G:

root@OpenWrt:/# mdio mdio-bus 5:30 raw 8
0x34da

root@OpenWrt:/# mdio mdio-bus 6:30 raw 8
0x34da


Bj=C3=B8rn
