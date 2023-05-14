Return-Path: <netdev+bounces-2430-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E2274701E3C
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 18:34:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78C88281097
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 16:34:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FF996FA0;
	Sun, 14 May 2023 16:34:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A2922600
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 16:34:24 +0000 (UTC)
Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5309A3AA0;
	Sun, 14 May 2023 09:34:22 -0700 (PDT)
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.96)
	(envelope-from <daniel@makrotopia.org>)
	id 1pyEfh-00070J-22;
	Sun, 14 May 2023 16:34:09 +0000
Date: Sun, 14 May 2023 18:32:15 +0200
From: Daniel Golle <daniel@makrotopia.org>
To: Simon Horman <simon.horman@corigine.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>, Kalle Valo <kvalo@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Alexander Couzens <lynxis@fe80.eu>,
	Sujuan Chen <sujuan.chen@mediatek.com>,
	Bo Jiao <bo.jiao@mediatek.com>,
	Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
	Howard Hsu <howard-yh.hsu@mediatek.com>,
	MeiChia Chiu <MeiChia.Chiu@mediatek.com>,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Wang Yufen <wangyufen@huawei.com>, Lorenz Brun <lorenz@brun.one>
Subject: Re: [PATCH] wifi: mt76: mt7915: add support for MT7981
Message-ID: <ZGENDwGXkuhrCGFY@pidgin.makrotopia.org>
References: <ZF-SN-sElZB_g_bA@pidgin.makrotopia.org>
 <ZGD192iDcUqoUwo3@corigine.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZGD192iDcUqoUwo3@corigine.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Simon,

thank you for reviewing!

On Sun, May 14, 2023 at 04:53:43PM +0200, Simon Horman wrote:
> On Sat, May 13, 2023 at 03:35:51PM +0200, Daniel Golle wrote:
> > From: Alexander Couzens <lynxis@fe80.eu>
> > 
> > Add support for the MediaTek MT7981 SoC which is similar to the MT7986
> > but with a newer IP cores and only 2x ARM Cortex-A53 instead of 4x.
> > Unlike MT7986 the MT7981 can only connect a single wireless frontend,
> > usually MT7976 is used for DBDC.
> > 
> > Signed-off-by: Alexander Couzens <lynxis@fe80.eu>
> > Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> 
> ...
> 
> > @@ -489,7 +516,10 @@ static int mt7986_wmac_adie_patch_7976(struct mt7915_dev *dev, u8 adie)
> >  		rg_xo_01 = 0x1d59080f;
> >  		rg_xo_03 = 0x34c00fe0;
> >  	} else {
> > -		rg_xo_01 = 0x1959f80f;
> > +		if (is_mt7981(&dev->mt76))
> > +			rg_xo_01 = 0x1959c80f;
> > +		else if (is_mt7986(&dev->mt76))
> > +			rg_xo_01 = 0x1959f80f;
> 
> Hi Daniel,
> 
> 		rg_xo_01 will be used uninitialised below if we get here
> 		and neither of the conditions above are true.
> 
> 		Can this occur?

No, it cannot occur. Either of is_mt7981() or is_mt7986() will return
true, as the driver is bound via one of the two compatibles
'mediatek,mt7986-wmac' or newly added 'mediatek,mt7981-wmac'.
Based on that the match_data is either 0x7986 or 0x7981, which is then
used as chip_id, which is used by the is_mt7981() and is_mt7986()
functions.

> 
> >  		rg_xo_03 = 0x34d00fe0;
> >  	}
> >  
> 
> ...
> 

