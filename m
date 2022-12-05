Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA8D6430AF
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 19:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbiLESnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 13:43:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233042AbiLESnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 13:43:11 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D8DF65EA;
        Mon,  5 Dec 2022 10:42:57 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id d1so19990103wrs.12;
        Mon, 05 Dec 2022 10:42:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vxmZRxH3mlQlQpeh1Uw8TgbokvZBULFz8Ow6tmkWHTE=;
        b=dk/1Ja9hl9PySpQWaha4AATOhBCbQKS6drPmFnOk515lhZoBaQcAzT37w2xMEcXccD
         1F5WohbdbnS2orUD5mWKpfV/DkoAGO9RUNBL4NrHThuH3MMH5w3ZuAqnRM8HFJpdbZlC
         OreB7vCn2Qa6R8mENdHZdaMOiBVzEQqVQJhtKerQMAt091tQd4hnu2ZBHnqoydEAQkFJ
         Kp+/RscXcPty2o8tQyHIkIxgVCiln62H0UZftoIVtmyLERTnSNa3iRXh0cPQxsL2am6M
         Uyb5g9LYvPvDdxLCvL5XsAHW/CrNWj/UtOKady7k6WtjdApNWL691bsqAE2HIR8J/8Z4
         5utg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vxmZRxH3mlQlQpeh1Uw8TgbokvZBULFz8Ow6tmkWHTE=;
        b=wqTm9zaj0xtdtkEOOdSOFaZABLtO7uzrQnLvMlveImpu5hBWgfcUdHrsjSZlf0Y+WF
         FCMkI7OdBr8se07z/Z4ryou+Re3yUgXmOlMy6K7r3EOW0DC6/ksxa1Uwo5TWYZW5rzEb
         Z9zcqpPdXlSdJVy0VDX+dsiyF25AIUPOWSsrJkEu4E9zgmlQ8luIe0HU1x1tBAaKvotJ
         rQbDqycvEblyYu89Sfu1PD5HWMoFPnWol35+hNiblFpTwQF2+9OqWDsgZIfj7doLv5WA
         lBMzFRRfPPrvtJ/RKo1OZ/Gy5uD42uvvDfgwRAw1G8EhDKmCqGdQZhjVzu6qm3gPXXpq
         x5zQ==
X-Gm-Message-State: ANoB5pn3QHXmR+T/oTkxfDT1BBDAlt66xcc84sq5wJ8HeOaTxXszyi3S
        EzvpftcLJTKziNbwYx5xWyQ=
X-Google-Smtp-Source: AA0mqf7DBtfNtaA9jW4T4sTkjP+1PzK/Kz/ih3kvj1GIn+NAOGGJ1uXzSZXuGBVhaVshpziPjoiwSQ==
X-Received: by 2002:adf:f38d:0:b0:241:cb5d:113e with SMTP id m13-20020adff38d000000b00241cb5d113emr47628576wro.353.1670265775901;
        Mon, 05 Dec 2022 10:42:55 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id s5-20020adfeb05000000b002423dc3b1a9sm11252814wrn.52.2022.12.05.10.42.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 10:42:54 -0800 (PST)
Date:   Mon, 5 Dec 2022 21:42:50 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: mvneta: Prevent out of bounds read in
 mvneta_config_rss()
Message-ID: <Y447qgHPpSMAdQLG@kadam>
References: <Y4nMQuEtuVO+rlQy@kili>
 <Y4yW0fhKuoG3i7w3@unreal>
 <Y42z8kv8ehkk6YKf@kadam>
 <Y44t7OczM/wrbowu@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y44t7OczM/wrbowu@unreal>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 07:44:12PM +0200, Leon Romanovsky wrote:
> On Mon, Dec 05, 2022 at 12:03:46PM +0300, Dan Carpenter wrote:
> > On Sun, Dec 04, 2022 at 02:47:13PM +0200, Leon Romanovsky wrote:
> > > On Fri, Dec 02, 2022 at 12:58:26PM +0300, Dan Carpenter wrote:
> > > > The pp->indir[0] value comes from the user.  It is passed to:
> > > > 
> > > > 	if (cpu_online(pp->rxq_def))
> > > > 
> > > > inside the mvneta_percpu_elect() function.  It needs bounds checkeding
> > > > to ensure that it is not beyond the end of the cpu bitmap.
> > > > 
> > > > Fixes: cad5d847a093 ("net: mvneta: Fix the CPU choice in mvneta_percpu_elect")
> > > > Signed-off-by: Dan Carpenter <error27@gmail.com>
> > > > ---
> > > >  drivers/net/ethernet/marvell/mvneta.c | 3 +++
> > > >  1 file changed, 3 insertions(+)
> > > 
> > > I would expect that ethtool_copy_validate_indir() will prevent this.
> > > 
> > 
> > Huh...  Sort of, but in the strictest sense, no.  mvneta_ethtool_get_rxnfc()
> > sets the cap at 8 by default or an unvalidated module parameter.
> 
> And is this solely mvnet issue? Do other drivers safe for this input?
> 

I believe so, yes.  However thinking about it now maybe a better fix
would be to go back to the original way of using pp->rxq_def % nr_cpu_ids.
(Originally it used num_online_cpus() instead of nr_cpu_ids but I think
nr_cpu_ids is correct).  I will send this patch tomorrow.

In this code, if you hit the out of bounds then you kind of deserve it,
but there are probably a lot of people who probably have fewer than 8
cores and in that case the bug results in a WARN().

regards,
dan carpenter

