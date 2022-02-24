Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC5CB4C311D
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 17:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiBXQS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 11:18:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiBXQS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 11:18:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 643BF1BA910;
        Thu, 24 Feb 2022 08:17:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0597161729;
        Thu, 24 Feb 2022 16:13:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14565C340E9;
        Thu, 24 Feb 2022 16:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645719181;
        bh=C9NaldNevEVwFrJUsg+tpN65Jix9N8OzdfrdpdIEhG4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nRne8iblWckia5T24Xj+KWasP3fcU9EO95OV9/Ojun5Lm9wNZG8rKXr6FMBCu9K2U
         8hGoxuTyo7Bpjvd+Kv2tSQLWFUXxZ/v4mKpw9KjFVcfpgIiRu3XWVJaaHO55qSfTdm
         IWWRh4qkM7ZKhFTSs5gIgBCrkPzq08/PPjX2EtrGum16vZRDcPDGr7FnydWe9Ywskm
         2EDECycVczqMJOGo5pYnbcfODfzOl+L08CdbLYtGT7LfcIQQj7AsWYi3SSWu2KKGWe
         t2gOpwvb6m9NCxzqwAHfTFl+pcXepU+52qW13sQyTpC4ytQontVRzgG9Qii0lXB8uB
         mm2u6iVu6VbKg==
Date:   Thu, 24 Feb 2022 08:12:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?5ZC05L+K5paH?= <wudaemon@163.com>
Cc:     davem@davemloft.net, chenhao288@hisilicon.com, arnd@arndb.de,
        shenyang39@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ksz884x: use time_before in netdev_open for
 compatibility
Message-ID: <20220224081259.729050a5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1294b33.81f7.17f2c172621.Coremail.wudaemon@163.com>
References: <20220220122101.5017-1-wudaemon@163.com>
        <20220222113942.1747f2dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1294b33.81f7.17f2c172621.Coremail.wudaemon@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Feb 2022 22:16:28 +0800 (CST) =E5=90=B4=E4=BF=8A=E6=96=87 wrote:
> Hi ,Jakub .I have changed my patch as your advise as follows:
> diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet=
/micrel/ksz884x.c index 7dc451f..443d7bc 100644 --- a/drivers/net/ethernet/=
micrel/ksz884x.c +++ b/drivers/net/ethernet/micrel/ksz884x.c @@ -5301,7 +53=
01,6 @@ static irqreturn_t netdev_intr(int irq, void *dev_id) * Linux netwo=
rk device functions */ -static unsigned long next_jiffies; #ifdef CONFIG_NE=
T_POLL_CONTROLLER static void netdev_netpoll(struct net_device *dev) @@ -54=
92,7 +5491,7 @@ static int netdev_open(struct net_device *dev) int i; int p=
; int rc =3D 0; - + unsigned long next_jiffies=3D0 priv->multicast =3D 0; p=
riv->promiscuous =3D 0; @@ -5506,7 +5505,7 @@ static int netdev_open(struct=
 net_device *dev) if (rc) return rc; for (i =3D 0; i < hw->mib_port_cnt; i+=
+) { - if (next_jiffies < jiffies) + if (time_before(next_jiffies, jiffies)=
) next_jiffies =3D jiffies + HZ * 2; else next_jiffies +=3D HZ * 1; @@ -664=
2,7 +6641,7 @@ static void mib_read_work(struct work_struct *work) struct k=
sz_port_mib *mib; int i; - next_jiffies =3D jiffies; + unsigned long next_j=
iffies =3D jiffies; for (i =3D 0; i < hw->mib_port_cnt; i++) { mib =3D &hw-=
>port_mib[i];
>=20
> Do you have any other advise ?Thanks

Sorry your patch got scrambled into a single line and encoded with HTML.
Feel free to post it with git as [PATCH v2] and we'll take it from
there.
