Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51A0167D45A
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 19:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbjAZSjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 13:39:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231842AbjAZSjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 13:39:06 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3136F66FA7;
        Thu, 26 Jan 2023 10:38:48 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id lp10so2371018pjb.4;
        Thu, 26 Jan 2023 10:38:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xCtTsnHvHXcfhAfqBmg7/nbyMaQj2PKdVlFGtigDrKo=;
        b=Q2nUIitRJrzeIBh5brlwxMI/Sz+meze9LENQfIzK/d+pqBqFEXhT4O9W2SQ3eaZc4Y
         4l5nzF1s92OhkY5VmJ9NV1Nof2xeGAP4GjQ+PDIQ1fQEOpiz3lKiiIhdElnrUPE1CasW
         E/QE3qaTeWd2cfqQ6mCtsvTawCmBdCToLOwuflL69RaBafwiw528cuzUBvcxhql87ZkP
         FLOnagXqUIWsKGfIuahXizHid8F4VcWWeEko9/ETPp+svr5t2khfvuAtutngDlz+zZjz
         97k32w3u4onFD0/DAY7Os4WQCOo/FgoX15TvZOueiuEU1ZYN/6DD1etKopq2ZzB8ECYP
         6isw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xCtTsnHvHXcfhAfqBmg7/nbyMaQj2PKdVlFGtigDrKo=;
        b=ucvd2X/vUzEKcPiZNQ+JCDPlGqOhHSS8z9SJFFUDq/g/T+g/zN+qCXkxOhAI9evHGP
         VeG1LpDlDR8ewQhnuEeRz1Husu8g49w2bZbVhHSW51Zqhg7LeHlVd/pPduejGLeKqKXl
         BLP77OOHpPeosO9eRWXCoBYNDuLN1z9Adyl9AZztOkja0qomO66Zbm+9mrnBZmm9+/aR
         c/Ih3VC8lzDF3wqmdLlAsgmSmGrH17I2z0hIgW/5/SZyzmLlku1xTyGBQX4ecUqbAmah
         /ZOSvWue3RkvciobJe7V301oVpVh/zsq30YZSQ1UTd/KJiivhGG5U4Gx8APucY86Asdu
         00lQ==
X-Gm-Message-State: AO0yUKWATIJ0nua/8RFx43XnZp2WpJJTfpbVX+6lZzOv37lpvOD9hobg
        yQakU5YDDMxK7ol0czXjTY8hC9S6Ig4=
X-Google-Smtp-Source: AK7set/+4lhxhzJVJ5PHLdBliVjIncQa2k+B5gBuMOIo6kATpQz2eTT8+zyM37XNhx+mwffzeeUvuA==
X-Received: by 2002:a17:90b:224f:b0:22c:bca:d1fd with SMTP id hk15-20020a17090b224f00b0022c0bcad1fdmr6606374pjb.5.1674758327489;
        Thu, 26 Jan 2023 10:38:47 -0800 (PST)
Received: from [192.168.0.128] ([98.97.119.47])
        by smtp.googlemail.com with ESMTPSA id gj18-20020a17090b109200b0022c08b63564sm1370351pjb.52.2023.01.26.10.38.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 10:38:46 -0800 (PST)
Message-ID: <156f3e120bd0757133cb6bc11b76889637b5e0a6.camel@gmail.com>
Subject: Re: [PATCH] net: page_pool: fix refcounting issues with fragmented
 allocation
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org, Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        linux-kernel@vger.kernel.org, Yunsheng Lin <linyunsheng@huawei.com>
Date:   Thu, 26 Jan 2023 10:38:45 -0800
In-Reply-To: <bc0fa31a-c935-c6f0-f968-9e2a54bafd45@nbd.name>
References: <20230124124300.94886-1-nbd@nbd.name>
         <CAC_iWjKAEgUB8Z3WNNVgUK8omXD+nwt_VPSVyFn1i4EQzJadog@mail.gmail.com>
         <19121deb-368f-9786-8700-f1c45d227a4c@nbd.name>
         <cd35316065cfe8d706ca2730babe3e6519df6034.camel@gmail.com>
         <c7f1ade0-a607-2e55-d106-9acc26cbed94@nbd.name>
         <49703c370e26ae1a6b19a39dc05e262acf58f6aa.camel@gmail.com>
         <9baecde9-d92b-c18c-daa8-e7a96baa019b@nbd.name>
         <595c5e36b0260ba16833c2a8d9418fd978ca9300.camel@gmail.com>
         <0c0e96a7-1cf1-b856-b339-1f3df36a562c@nbd.name>
         <a0b43a978ae43064777d9d240ef38b3567f58e5a.camel@gmail.com>
         <9992e7b5-7f2b-b79d-9c48-cf689807f185@nbd.name>
         <301aa48a-eb3b-eb56-5041-d6f8d61024d1@nbd.name>
         <148028e75d720091caa56e8b0a89544723fda47e.camel@gmail.com>
         <8ec239d3-a005-8609-0724-f1042659791e@nbd.name>
         <8a331165-4435-4c2d-70e0-20655019dc51@nbd.name>
         <CAKgT0Ud8npNtncH-KbMtj_R=UZ=aFA9T8U=TZoLG_94eVUxKPA@mail.gmail.com>
         <bc0fa31a-c935-c6f0-f968-9e2a54bafd45@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>=20
> > Which piece did you change? My main interest would be trying to narrow
> > down the section of this function that is causing this. Did you modify
> > __ieee80211_amsdu_copy or some other function within the setup?
> I replaced this line:
>    bool reuse_frag =3D skb->head_frag && !skb_has_frag_list(skb);
> with:
>    bool reuse_frag =3D false;

I see. So essentially everything is copied into the new buffers.

> > > > I believe the issue must be specific to that codepath, since most
> > > > received and processed packets are either not A-MSDU or A-MSDU deca=
p has
> > > > already been performed by the hardware.
> > > > If I change my test to use 3 client mode interfaces instead of 4, t=
he
> > > > hardware is able to offload all A-MSDU rx processing and I don't se=
e any
> > > > crashes anymore.
> > > >=20
> > > > Could you please take another look at ieee80211_amsdu_to_8023s to s=
ee if
> > > > there's anything in there that could cause these issues?
> >=20
> > The thing is I am not sure it is the only cause for this. I am
> > suspecting we are seeing this triggering an issue when combined with
> > something else.
> >=20
> > If we could add some tracing to dump the skb and list buffers that
> > might be helpful. We would want to verify the pp_recycle value, clone
> > flag, and for the frags we would want to frag count and page reference
> > counts. The expectation would be that the original skb should have the
> > pp_recycle flag set and the frag counts consistent through the
> > process, and the list skbs should all have taken page references w/ no
> > pp_recycle on the skbs in the list.
> >=20
> > > Here are clues from a few more tests that I ran:
> > > - preventing the reuse of the last skb in ieee80211_amsdu_to_8023s do=
es
> > > not prevent the crashes, so the issue is indeed related to taking pag=
e
> > > references and putting the pages in skb fragments.
> >=20
> > You said in the first email it stops it and in the second "does not".
> > I am assuming that is some sort of typo since you seem to be implying
> > it does resolve it for you. Is that correct?
> For everything except for the last subframe, the function pulls=20
> fragments out of the original skb and puts them into a new skb allocated=
=20
> with dev_alloc_skb. Additionally, the last skb is reused for the final=
=20
> subframe. What I meant was: In order to figure out if the skb-reuse is=
=20
> problematic, I prevented it from happening, ensuring that all subframes=
=20
> are allocated and get the fragments from the skb.
> All I meant to say is that since that led to the same crash, the=20
> skb-reuse is not the problem.
>=20
> Regarding the question from your other mail: without GRO there is no=20
> crash and it looks stable.
>=20
> - Felix
>=20

Okay, I think that tells me exactly what is going on. Can you give the
change below a try and see if it solves the problem for you.

I think what is happening is that after you are reassigning the frags
they are getting merged into GRO frames where the head may have
pp_recycle set. As a result I think the pages are getting recycled when
they should be just freed via put_page.

I'm suspecting this wasn't an issue up until now as I don't believe
there are any that are running in a mixed mode where they have both
pp_recycle and non-pp_recycle skbs coming from the same device.

diff --git a/net/core/gro.c b/net/core/gro.c
index 506f83d715f8..4bac7ea6e025 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -162,6 +162,15 @@ int skb_gro_receive(struct sk_buff *p, struct
sk_buff *skb)
 	struct sk_buff *lp;
 	int segs;
=20
+	/* Do not splice page pool based packets w/ non-page pool
+	 * packets. This can result in reference count issues as page
+	 * pool pages will not decrement the reference count and will
+	 * instead be immediately returned to the pool or have frag
+	 * count decremented.
+	 */
+	if (p->pp_recycle !=3D skb->pp_recycle)
+		return -ETOOMANYREFS;
+
 	/* pairs with WRITE_ONCE() in netif_set_gro_max_size() */
 	gro_max_size =3D READ_ONCE(p->dev->gro_max_size);
=20
