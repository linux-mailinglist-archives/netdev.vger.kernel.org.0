Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC2F62F024
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 09:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241440AbiKRIxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 03:53:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240724AbiKRIxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 03:53:47 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB00F1FCF7
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 00:53:45 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id a14so8242703wru.5
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 00:53:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gZfjb461nfSkb95dgxGCMSdAVYV594goseCsH+IUcbo=;
        b=fGdjyrRSKvXYZslJrpsPREHVs2Rq31UnhH3z7c+4mfBu/ZXW+4p6P8BQ728ynaK6TX
         hA1A4K/Geh2KTdswzCBewZeIBP2HO4yMPOIySgnmurOxeNP78V4A9wNimhhSr3+yBZme
         +2ErQh4qqZrJuJdCsm7JQL/uuGHl0jTUzhHP6OETsvtMJm8AqxQF+t5ulVNAC59KMlOS
         T2MlRMTInctJ23kG6xjuq4VPdiyGqa+8QDJYu9xpqYnIT4BPMEX0KTQ7VYdKIXHxDErW
         irq3l58PJuYFDGdlfwRuOTs3jAY7Ibm/evqeuclA7tZ6fkz1IBEY4cBTTfpIZt8144t8
         z7rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gZfjb461nfSkb95dgxGCMSdAVYV594goseCsH+IUcbo=;
        b=Vt/s7CBB8iF810zdv40MEzTyfFbi2LOEA/g7CI41uMR648Jm+RQOvpmkTnFvXXjhsU
         jINKo6vjxRw5Nxt8PbJ/zEJfX9TeOO6V1EXfocK8w/Ky2Wi7w/1hpdCi6IYok0+EXeLx
         4H0ZWNVqYptfHBNSrWPjDeT/I1EIWb2StJo2JoGBDSsGgsW3GtoXCsWSHwFH8RfmLweq
         aidYlfHua5g21fAzGNVobWHtYLRILsNNz50rESHwytYJpom9MDmMzoIL4DJc1iJwtkCB
         jrIg7nTUWjmfUomnooFYWUdKI/yIEOd0+as7TirQo/EABTJMGh64qWbe0C3DWueYPesC
         PXtg==
X-Gm-Message-State: ANoB5pk0eW7lGc5jVat2e37n3vdZkqu6PMyDHI8ehtQbXbHMFmF29fpk
        yNWqA1PEJQaWLXpJyZw9BSu+x4MeELg=
X-Google-Smtp-Source: AA0mqf6QcgP79ATjT13CReBvFx+IlrjlNidnGO/XfJRyGNmScwA7OKri5P+DMNehE/8tdA8xd0Z9lg==
X-Received: by 2002:a05:6000:1042:b0:22e:3f37:fdc with SMTP id c2-20020a056000104200b0022e3f370fdcmr3572845wrx.665.1668761624009;
        Fri, 18 Nov 2022 00:53:44 -0800 (PST)
Received: from suse.localnet (host-79-26-100-208.retail.telecomitalia.it. [79.26.100.208])
        by smtp.gmail.com with ESMTPSA id i6-20020a05600c354600b003cf894c05e4sm8466388wmq.22.2022.11.18.00.53.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 00:53:43 -0800 (PST)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     netdev@vger.kernel.org,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Cc:     Ira Weiny <ira.weiny@intel.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Subject: Re: [PATCH net-next 4/5] cassini: Use kmap_local_page() instead of kmap_atomic()
Date:   Fri, 18 Nov 2022 09:53:42 +0100
Message-ID: <2183897.Icojqenx9y@suse>
In-Reply-To: <20221117222557.2196195-5-anirudh.venkataramanan@intel.com>
References: <20221117222557.2196195-1-anirudh.venkataramanan@intel.com> <20221117222557.2196195-5-anirudh.venkataramanan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On gioved=EC 17 novembre 2022 23:25:56 CET Anirudh Venkataramanan wrote:
> kmap_atomic() is being deprecated in favor of kmap_local_page().
> Replace kmap_atomic() and kunmap_atomic() with kmap_local_page() and
> kunmap_local() respectively. cas_page_map() and cas_page_unmap() aren't
> really useful anymore, so get rid of these as well.
>=20
> Note that kmap_atomic() disables preemption and page-fault processing,
> but kmap_local_page() doesn't. Converting the former to the latter is safe
> only if there isn't an implicit dependency on preemption and page-fault
> handling being disabled, which does appear to be the case here.

Same NIT: again, conversions would be possible with the addition of explici=
t=20
call(s) for disable page faults and preemption. As I said, I have no proble=
ms=20
with this inaccurate description. Please see 2/5, I don't think it should=20
prevent the patch to be applied.

>=20
> Also note that the page being mapped is not allocated by the driver,
> and so the driver doesn't know if the page is in normal memory. This is t=
he
> reason kmap_local_page() is used as opposed to page_address().
>=20
> I don't have hardware, so this change has only been compile tested.
>=20
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Fabio M. De Francesco <fmdefrancesco@gmail.com>
> Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
> ---
>  drivers/net/ethernet/sun/cassini.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/sun/cassini.c
> b/drivers/net/ethernet/sun/cassini.c index 2f66cfc..3e632b0 100644
> --- a/drivers/net/ethernet/sun/cassini.c
> +++ b/drivers/net/ethernet/sun/cassini.c
> @@ -90,8 +90,6 @@
>  #include <linux/uaccess.h>
>  #include <linux/jiffies.h>
>=20
> -#define cas_page_map(x)      kmap_atomic((x))
> -#define cas_page_unmap(x)    kunmap_atomic((x))
>  #define CAS_NCPUS            num_online_cpus()
>=20
>  #define cas_skb_release(x)  netif_rx(x)
> @@ -2788,11 +2786,11 @@ static inline int cas_xmit_tx_ringN(struct cas *c=
p,
> int ring, ctrl, 0);
>  			entry =3D TX_DESC_NEXT(ring, entry);
>=20
> -			addr =3D cas_page_map(skb_frag_page(fragp));
> +			addr =3D kmap_local_page(skb_frag_page(fragp));
>  			memcpy(tx_tiny_buf(cp, ring, entry),
>  			       addr + skb_frag_off(fragp) + len -=20
tabort,
>  			       tabort);
> -			cas_page_unmap(addr);
> +			kunmap_local(addr);

memcpy_from_page() would be better suited.
Please remember to use memcpy_{from,to}_page() where they are better suited.
However, they would not change the logic, so I'm OK with this change too.

>  			mapping =3D tx_tiny_map(cp, ring, entry, tentry);
>  			len     =3D tabort;
>  		}
> --
> 2.37.2

Reviewed-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>

=46eel free to forward my tag, if maintainers require the use of the above-
mentioned helpers and ask for v2.

Thanks,

=46abio



