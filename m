Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB546BFEA6
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 01:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbjCSAbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 20:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjCSAa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 20:30:59 -0400
Received: from violet.fr.zoreil.com (violet.fr.zoreil.com [IPv6:2001:4b98:dc0:41:216:3eff:fe56:8398])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A570512850;
        Sat, 18 Mar 2023 17:30:19 -0700 (PDT)
Received: from violet.fr.zoreil.com ([127.0.0.1])
        by violet.fr.zoreil.com (8.17.1/8.17.1) with ESMTP id 32J0Si5k158358;
        Sun, 19 Mar 2023 01:28:44 +0100
DKIM-Filter: OpenDKIM Filter v2.11.0 violet.fr.zoreil.com 32J0Si5k158358
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fr.zoreil.com;
        s=v20220413; t=1679185724;
        bh=vW56eiFQyPoJvafoqsvq9JVG5gwKM3D0LOHkxHut+Pw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W929FujEoy3TJtQw69IK5rZzVOJPP0ZdujGDgNzHzCglMmrhsO3HwJTtam1ODlMs1
         11K43jz4gq3mahLPsLeV/eYBsQ8lEeG9sSEo8JNTECQ7BIrDFTE8EZL6tD6MM5CeU0
         w/R9H6Ve5mDIFJ+JpcBfYXRjfn08qhXLLTJ257zE=
Received: (from romieu@localhost)
        by violet.fr.zoreil.com (8.17.1/8.17.1/Submit) id 32J0She6158357;
        Sun, 19 Mar 2023 01:28:43 +0100
Date:   Sun, 19 Mar 2023 01:28:43 +0100
From:   Francois Romieu <romieu@fr.zoreil.com>
To:     Li Zetao <lizetao1@huawei.com>
Cc:     3chas3@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atm: idt77252: fix kmemleak when rmmod idt77252
Message-ID: <20230319002843.GA158280@electric-eye.fr.zoreil.com>
References: <20230317035228.2635209-1-lizetao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230317035228.2635209-1-lizetao1@huawei.com>
X-Organisation: Land of Sunshine Inc.
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Li Zetao <lizetao1@huawei.com> :
> There are memory leaks reported by kmemleak:
[...]
> diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
> index eec0cc2144e0..060f32b0def3 100644
> --- a/drivers/atm/idt77252.c
> +++ b/drivers/atm/idt77252.c
[...]
> @@ -2952,6 +2953,16 @@ open_card_ubr0(struct idt77252_dev *card)
>  	return 0;
>  }
>  
> +static void
> +close_card_ubr0(struct idt77252_dev *card)
> +{
> +	struct vc_map *vc;
> +
> +	vc = card->vcs[0];

Nit:
+	struct vc_map *vc = card->vcs[0];

I have not found any opportunity for a double free related to the patch.

So, other than the nit above:

Reviewed-by: Francois Romieu <romieu@fr.zoreil.com>

FWIW
- the driver leaks on error in open_card_ubr0.
- some forward declarations (alloc_scq, free_scq, etc.) are useless.
- struct idt77252_dev.next is useless. It was probably cargo-culted from
  some driver while hoping to enumerate devices (not that uncommon the
  early 2000). PCI driver registeering could thus look more idiomatic.
- deinit_card can be called two times in an error path and trigger a BUG_ON
  in atm_dev_deregister.

-- 
Ueimor
