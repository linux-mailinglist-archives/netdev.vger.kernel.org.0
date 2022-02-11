Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2B724B1BA6
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 02:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347114AbiBKBxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 20:53:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347112AbiBKBxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 20:53:24 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93FAD5F65
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 17:53:21 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id d10so19506470eje.10
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 17:53:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=xyyZL44WcSobgJEeTn4X1pRLXMq80QXuLnGEhz1vyXc=;
        b=Zs1cNdxRKzva7RTbZ8CwOd3cxc0PpR0f5c4YwU9/K+qdFUum+noacxU8wfnomuyGzy
         cnK+7zD4vLwi2rFXktl9tnTQBnarsGeiskjYmPbjVzhOWn28UAMrSDlhFqVpgKq4L8il
         4VyWysiW3AiOURniryFspBabn9rh8SFe14tu6zC0tiM72U8Ze8ZMaZOOKBU+Jw15wRxL
         1Bc4LGRhDRMO02p1wZOyTar9VimkmdACAvVGVgyjP2gSeQtSh6hqjNmjBng4Bg8Mx4KE
         47+rhOG0B4axrQAEOOmYww8LK9piliJk3IcjOqU2WPMCtbXd0anzfEW6eI711oXylUDX
         G+Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=xyyZL44WcSobgJEeTn4X1pRLXMq80QXuLnGEhz1vyXc=;
        b=a2ri9LHbuQN2dNW5Y3gUYuwewlBssmAuLrWxb85W+CnsW+fGK+RZcBF9uevpfkd3AE
         iNvf0329XmkXgny0XE7Cqlo612ENuAXjHuuHvbruc3XArk1Yvp6gE+YCr5E4ckcLfrG2
         62LxLHShAWPisvpasDYTct7aDpiJ7Z34n9N3fUKwuX4XHPId8wOykRGlLOm1enufgApJ
         6o7hYZDfNweSt1xEVKUSXe2DjMi1h3k0FFSHN0AQaEuQvdnCVYQ49X6GSOkw0td1lr6Q
         vCBrtqnrphkcodPzd/PA8Tp3dMYf/dpObBYSs0pLizXdz5FsuYJ2xR5SAumW1CFKrVj/
         SjnQ==
X-Gm-Message-State: AOAM530BLseLYnYL/RkRLenHolrHFm59Elct7qDDEie2VGu79GFbclTD
        +CLqqyyyWVBsfy7HjWYv5aR6DPZsD1749f4JVB2q+lAUZGvvPA==
X-Google-Smtp-Source: ABdhPJx6SSUSKcTTPP+IEElU3gIbzz3hVhusYoI/L7O8IibpChOzBhMP4p2F7eYhdapOdZO0kOoqgNcHH5xOaZ2wsnM=
X-Received: by 2002:a17:907:608f:: with SMTP id ht15mr8634739ejc.498.1644544399987;
 Thu, 10 Feb 2022 17:53:19 -0800 (PST)
MIME-Version: 1.0
From:   Yi Li <lovelylich@gmail.com>
Date:   Fri, 11 Feb 2022 09:53:09 +0800
Message-ID: <CAAA3+Bo6RQjhYom0+RPaDvYZJ90NdqgVBFomDMWyc=nsiJm1Tg@mail.gmail.com>
Subject: Why skb->data so far from skb->head after skb_reserve?
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi list,
I am digging on skb layout when tcp send packets throught tcp/ip
stack, but i am stuck on the skb->data now.
I use the net-next branch, and the commit id
6cf7a1ac0fedad8a70c050ade8a27a2071638500, and i think this (problem?)
is not relevant with specific commit id.

Firstly I just used systemtap to digging the routines, but when I
found for every pkt, the data is far way from skb->head, i became
curious.

After add some printk logs and analysis, I found the strange behavior
as follows:

Let's only look at the tcp syn pkt when we do a tcp connection. I have
added many logs , but for simply let's only see root cause, the
following log:

static inline void skb_reserve(struct sk_buff *skb, int len)
{
    printk("%s:%d:  head=%p, data=%p, tail=%d, end=%d, len=%d,
data_len=%d, transport_header=%d, nr_frags=%d\n",
                    __func__, __LINE__, skb->head, skb->data,
skb->tail, skb->end, skb->len, skb->data_len,
                    skb->transport_header, skb_shinfo(skb)->nr_frags);
skb->data += len;
    printk("%s:%d:  head=%p, data=%p, tail=%d, end=%d, len=%d,
data_len=%d, transport_header=%d, nr_frags=%d\n",
                    __func__, __LINE__, skb->head, skb->data,
skb->tail, skb->end, skb->len, skb->data_len,
                    skb->transport_header, skb_shinfo(skb)->nr_frags);
skb->tail += len;
}

And I got the strange result:
[  131.750170] skb_reserve:2453:  head=000000000cfe1b70,
data=000000000cfe1b70, tail=0, end=704, len=0, data_len=0,
transport_header=65535, nr_frags=0
[  131.750173] skb_reserve:2457:  head=000000000cfe1b70,
data=00000000bf8ffb2c, tail=0, end=704, len=0, data_len=0,
transport_header=65535, nr_frags=0

Why the skb->data so far from skb->head, i can't understand. Could you
kindly help me ?
