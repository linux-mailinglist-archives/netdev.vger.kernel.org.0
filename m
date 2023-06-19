Return-Path: <netdev+bounces-11945-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D04D173564E
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 13:56:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C48B1C209BC
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 11:56:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6553D531;
	Mon, 19 Jun 2023 11:56:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B024B8C06
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 11:56:04 +0000 (UTC)
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BB1F102;
	Mon, 19 Jun 2023 04:56:03 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-988b75d8b28so109133266b.3;
        Mon, 19 Jun 2023 04:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687175761; x=1689767761;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vOF1HQ65PMcVDah81Cgs1ZApX9tkkoWLvArF198/E+k=;
        b=Wfq+AvrzBdKN9WTKX0+xbZ1aUARe6smA6r9p9lttA+/LoMw1qQoa6jvVwu5LKTzhp0
         J2ZX6/EBgRuq36n2Nrx0aPKjl5UujfmFDKIbsdK72iRcleopzeR1iPH6ckGQXLoddfyo
         3LY9RkbvuxK6zG8et1VLY/1KaKEhKN5hiEWKn0us0jrrqji4EIjKhuaz8EF8vf3Zp5xj
         Xi099ai3YrwMI/98sv2yBmHicoj1atC8iqzBOyR5UwYD5POq2/58mZPHNasyXOx86J1c
         GeXKComhurH8mybVHOt2niIfTXLSEWFIJc4RG+XRmD0YJ49ZJ7OXYBtQrN7ve1FMXQdT
         pnqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687175761; x=1689767761;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vOF1HQ65PMcVDah81Cgs1ZApX9tkkoWLvArF198/E+k=;
        b=RZl1ODP0HOa3HeODsZ/4oTKbOZ0lS11OgYKAfmNU6NpK86RinZLTw4SDbTp7Tc/BH9
         vvsi8S3ZrDzqd/4xpLer+4YZkXGT+qvK8Lw7Bgnao4N6mHF3NyiByUK70X/OMbNqoM2q
         aHXGZSm9m4lowWGomHbB6AurZAPR9lrM+qhHOzdyAWgSyp6L8UAagQMFOJwtSGxxLiQc
         IGwrWPAz0gOxXYCesfAs6Q7FOOUfDL2X47IVelmoAGXXjNzNeuBbLJJbGr2vpGl4v5yt
         sXhkXtvoDcYonyhpVqMCaCxw21cddzmYOUmdL/MR+kgOD7vxmI45bK9Yl70Q0EUk2sQC
         DMEg==
X-Gm-Message-State: AC+VfDyM+9VEmOW7ZJfVSYI9DM7J1TC6f0zzgrnj8aVUPCQFMWFDVsuB
	IR3/hAe3eZI75YcrKIyogaw=
X-Google-Smtp-Source: ACHHUZ6RA5IYBywkmrhFAiIjoMLVhWWRWoBkuAx3NCOFQ0lftLuqhSw8HcKoZubPZww6v17ga/g7kw==
X-Received: by 2002:a17:907:7f12:b0:988:66d9:438 with SMTP id qf18-20020a1709077f1200b0098866d90438mr3653609ejc.51.1687175761392;
        Mon, 19 Jun 2023 04:56:01 -0700 (PDT)
Received: from skbuf ([188.25.159.134])
        by smtp.gmail.com with ESMTPSA id t25-20020a170906269900b00982983a6a34sm6281529ejc.34.2023.06.19.04.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jun 2023 04:56:01 -0700 (PDT)
Date: Mon, 19 Jun 2023 14:55:58 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: arinc9.unal@gmail.com
Cc: =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Landen Chao <Landen.Chao@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>,
	Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Russell King <linux@armlinux.org.uk>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	mithat.guner@xeront.com, erkin.bozoglu@xeront.com,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net v6 3/6] net: dsa: mt7530: fix handling of BPDUs on
 MT7530 switch
Message-ID: <20230619115558.vqh6oedosxunwy3l@skbuf>
References: <20230617062649.28444-1-arinc.unal@arinc9.com>
 <20230617062649.28444-4-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230617062649.28444-4-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, Jun 17, 2023 at 09:26:46AM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> BPDUs are link-local frames, therefore they must be trapped to the CPU
> port. Currently, the MT7530 switch treats BPDUs as regular multicast
> frames, therefore flooding them to user ports. To fix this, set BPDUs to be
> trapped to the CPU port. Group this on mt7530_setup() and
> mt7531_setup_common() into mt753x_trap_frames() and call that.
> 
> Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

