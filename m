Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98D5B6C218E
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 20:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbjCTTdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 15:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbjCTTck (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 15:32:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84EA23B212;
        Mon, 20 Mar 2023 12:26:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2550E617C3;
        Mon, 20 Mar 2023 19:26:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3712C4339E;
        Mon, 20 Mar 2023 19:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679340380;
        bh=p3nfI37uSD2HaSJ85GLFWgl7AfpzPINmlDeM97COr3g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LSbRdbY4kd9P9uxj3pLqomRsxEQw1KI3sfqU0vaasQo9/aJGViFhNiqlTlb9eHYa5
         vubwALccOL5I2YMNuYB7Lb14Lq6C6B0aId2DQd5MdfuzSwEjkX5UzU+fqajqUeKcZ3
         uGGNojiVjiXlAE7nE9ejACNKX4zYxJI+ongZew5BJfrglx6gIuhdlm9cuSdxlkmNiZ
         hWlH5higqWB6ImYOJ3SA/TgQ7Um8r3fOTd5RHpHBnuiUyUCtQvLZwQj9SJZ9BGq0hi
         atVLKDonKz2bJunCnZjifinF8cuYuUUQN74EZ4X48UrWrgP95n8keaRzwGnFMdwT+r
         NUUBaQk/smCrQ==
Date:   Mon, 20 Mar 2023 13:26:49 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] wifi: mt76: mt7921: Replace fake flex-arrays with
 flexible-array members
Message-ID: <ZBizeZ5DaBT5KKXN@work>
References: <ZBTUB/kJYQxq/6Cj@work>
 <ZBh0NhaNFnttWRz8@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBh0NhaNFnttWRz8@corigine.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 03:56:54PM +0100, Simon Horman wrote:
> >  struct mt7921_asar_cl {
> > @@ -85,7 +85,7 @@ struct mt7921_asar_fg {
> >  	u8 rsvd;
> >  	u8 nr_flag;
> >  	u8 rsvd1;
> > -	u8 flag[0];
> > +	u8 flag[];
> 
> I am curious to know why DECLARE_FLEX_ARRAY isn't used here.

In contrast to the other structs, there is no object of type struct
mt7921_asar_fg declared in a union:

 91 struct mt7921_acpi_sar {
 92         u8 ver;
 93         union {
 94                 struct mt7921_asar_dyn *dyn;
 95                 struct mt7921_asar_dyn_v2 *dyn_v2;
 96         };
 97         union {
 98                 struct mt7921_asar_geo *geo;
 99                 struct mt7921_asar_geo_v2 *geo_v2;
100         };
101         struct mt7921_asar_cl *countrylist;
102         struct mt7921_asar_fg *fg;
103 };

The DECLARE_FLEX_ARRAY() helper was created to declare flex-array members
in unions or alone in structs[1].

--
Gustavo

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays

