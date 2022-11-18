Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F1B62FEA3
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 21:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbiKRUTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 15:19:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbiKRUTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 15:19:01 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10DBD101FD
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 12:19:00 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id g2so7329999wrv.6
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 12:18:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wHkzrdpv3lkK8RIRncJLDx06Yp7E8CHCSPVhu3Jm7jE=;
        b=AReWUgK0p1Aqm6LaXhJv8oMmen1diWPzRAyKErV1RdKaSbieddz0gJ6O8rnOuwOrX8
         vNvxh5mlXxr7N25nrfVp5QexESD0NpfKgCtosEJCG53HAj/NI3lLekFKoISOUQKkKAgR
         4iVcWP/0FJKI62DuhvYDrK/X2vaVj+QXiQ369CuyEc1dwDc7K4ScKyLm7SQhxVonctCa
         xO3ehxTDnyjD1qWybjkC3BrEJHxbMf6Qk1ZBDGqeR1JhWPqszl+NtSD/J1p7urQ0PeHy
         NUwQUvBMeJy/FF6EPpEXE4zuTq5YiWWUZRfdNkpw+ZvorWR0AnGZQCl8xc5fvE95wE6j
         ZLIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wHkzrdpv3lkK8RIRncJLDx06Yp7E8CHCSPVhu3Jm7jE=;
        b=pJQLizhDS4TC93tLjXYOBG/3bEUE+LJjjtl9WI7tKhdDjnatv3KOtWlmYN62iF//46
         aiFHK55dWk4FP7QGSA2zVbx1QFdinpNZCSqQcdMGojE+yIVAsqB4hRrRCFXprzdExcn/
         a2pFy0RWxdxG83hxh3AvdMGa4qglda9y4qSff+2LGhXTcbG1WC0vf6Kqf4Vtc0UAClVD
         wFuc0ogsDs6op5RqHHZmPffxOXrip2qZrjk8MHk/tGYeaMHLZpUFdwlcyekxpA8dUham
         1T//GD8GP4nJYcSyUlxJA0hgOQzhtp8Tzpj3XVg/PrDy77bfBo/EYAM5NowPe79Cu3jS
         EThQ==
X-Gm-Message-State: ANoB5pkZXBD5+5UxJ+nA4JnVcBi+ZvJOG2KaVTVZuNrBIFr9u9/bfS+9
        gbJDcIECfIVdB6dXLkVAKQ0CWXohlTc=
X-Google-Smtp-Source: AA0mqf6FTzrNvmFTG/Lm2FWZLhyZmFu24U2hqzrSx4FB8MN4husAw8Q7m5l1TdcXt/X+Lytg7uX8Ng==
X-Received: by 2002:a5d:4ec8:0:b0:231:20a2:21f4 with SMTP id s8-20020a5d4ec8000000b0023120a221f4mr5320841wrv.398.1668802738125;
        Fri, 18 Nov 2022 12:18:58 -0800 (PST)
Received: from suse.localnet (host-79-26-100-208.retail.telecomitalia.it. [79.26.100.208])
        by smtp.gmail.com with ESMTPSA id e18-20020adfdbd2000000b0022da3977ec5sm4334301wrj.113.2022.11.18.12.18.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 12:18:57 -0800 (PST)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     netdev@vger.kernel.org,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Cc:     Ira Weiny <ira.weiny@intel.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: Re: [PATCH net-next 1/5] ch_ktls: Use kmap_local_page() instead of kmap_atomic()
Date:   Fri, 18 Nov 2022 21:18:56 +0100
Message-ID: <4854425.0VBMTVartN@suse>
In-Reply-To: <4bcad8cf-2525-bd7c-9d58-ae43a7720191@intel.com>
References: <20221117222557.2196195-1-anirudh.venkataramanan@intel.com> <2310788.ElGaqSPkdT@suse> <4bcad8cf-2525-bd7c-9d58-ae43a7720191@intel.com>
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

On venerd=EC 18 novembre 2022 19:27:56 CET Anirudh Venkataramanan wrote:
> On 11/18/2022 12:14 AM, Fabio M. De Francesco wrote:
> > On gioved=EC 17 novembre 2022 23:25:53 CET Anirudh Venkataramanan wrote:
> >> kmap_atomic() is being deprecated in favor of kmap_local_page().
> >> Replace kmap_atomic() and kunmap_atomic() with kmap_local_page()
> >> and kunmap_local() respectively.
> >>=20
> >> Note that kmap_atomic() disables preemption and page-fault processing,
> >> but kmap_local_page() doesn't. Converting the former to the latter is=
=20
safe
> >> only if there isn't an implicit dependency on preemption and page-fault
> >> handling being disabled, which does appear to be the case here.
> >>=20
> >> Also note that the page being mapped is not allocated by the driver,
> >> and so the driver doesn't know if the page is in normal memory. This i=
s=20
the
> >> reason kmap_local_page() is used as opposed to page_address().
> >>=20
> >> I don't have hardware, so this change has only been compile tested.
> >>=20
> >> Cc: Ayush Sawal <ayush.sawal@chelsio.com>
> >> Cc: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
> >> Cc: Rohit Maheshwari <rohitm@chelsio.com>
> >> Cc: Ira Weiny <ira.weiny@intel.com>
> >> Cc: Fabio M. De Francesco <fmdefrancesco@gmail.com>
> >> Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.co=
m>
> >> ---
> >>=20
> >>   .../ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 10 +++++---=
=2D-
> >>   1 file changed, 5 insertions(+), 5 deletions(-)
> >>=20
> >> diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/
chcr_ktls.c
> >> b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c index
> >> da9973b..d95f230 100644
> >> --- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
> >> +++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
> >> @@ -1853,24 +1853,24 @@ static int chcr_short_record_handler(struct
> >> chcr_ktls_info *tx_info, i++;
> >>=20
> >>   			}
> >>   			f =3D &record->frags[i];
> >>=20
> >> -			vaddr =3D kmap_atomic(skb_frag_page(f));
> >> +			vaddr =3D kmap_local_page(skb_frag_page(f));
> >>=20
> >>   			data =3D vaddr + skb_frag_off(f)  + remaining;
> >>   			frag_delta =3D skb_frag_size(f) - remaining;
> >>   		=09
> >>   			if (frag_delta >=3D prior_data_len) {
> >>   		=09
> >>   				memcpy(prior_data, data,
> >=20
> > prior_data_len);
> >=20
> >> -				kunmap_atomic(vaddr);
> >> +				kunmap_local(vaddr);
> >>=20
> >>   			} else {
> >>   		=09
> >>   				memcpy(prior_data, data, frag_delta);
> >>=20
> >> -				kunmap_atomic(vaddr);
> >> +				kunmap_local(vaddr);
> >>=20
> >>   				/* get the next page */
> >>   				f =3D &record->frags[i + 1];
> >>=20
> >> -				vaddr =3D kmap_atomic(skb_frag_page(f));
> >> +				vaddr =3D
> >=20
> > kmap_local_page(skb_frag_page(f));
> >=20
> >>   				data =3D vaddr + skb_frag_off(f);
> >>   				memcpy(prior_data + frag_delta,
> >>   			=09
> >>   				       data, (prior_data_len -
> >=20
> > frag_delta));
> >=20
> >> -				kunmap_atomic(vaddr);
> >> +				kunmap_local(vaddr);
> >>=20
> >>   			}
> >>   			/* reset tcp_seq as per the prior_data_required
> >=20
> > len */
> >=20
> >>   			tcp_seq -=3D prior_data_len;
> >>=20
> >> --
> >> 2.37.2
> >=20
> > The last conversion could have been done with memcpy_from_page(). Howev=
er,
> > it's not that a big deal. Therefore...
> >=20
> > Reviewed-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
>=20
> Yeah, using memcpy_from_page() is cleaner. I'll update this patch, and
> probably 4/5 too.
>=20
> Thanks!
> Ani

Well, I didn't ask you for a second version. This is why you already see my=
=20
"Reviewed-by:" tag. I'm OK with your changes. I just warned you that=20
maintainers might ask, so I'd wait and see. However it's up to you.

However, if you decide to send this patch with memcpy_from_page(), why you=
=20
are not sure about 4/5? Since you decided to send 1/5 again, what does prev=
ent=20
you from updating also 4/5?

=46abio =20



